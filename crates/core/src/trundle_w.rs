//! PARTIAL reconstructed Trundle W. Native 4.20 rank values, not native callbacks.
//! Geometry: ranked CastRange=750 is selected; community6dcac zone radius=1000.
//! No 0.5s aura linger/CC reduction from that older community script is adopted.
//! The zone is owner-only, immediate, queried at the current simulation position,
//! does not reset/cancel attacks, and ends on expiry/death. VFX/audio remain open.
use crate::*;
use std::sync::OnceLock;

pub const DOMAIN_RADIUS: f32 = 1000.; // Explicit Chronobreak reconstruction.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Zone {
    pub owner: u32,
    pub center: Point,
    pub rank: u8,
    pub starts: u64,
    pub until: u64,
}
#[derive(Debug, Clone, Copy)]
pub struct Rank {
    pub cost: f32,
    pub cooldown: f32,
    pub cast_range: f32,
    pub movement: f32,
    pub attack_speed: f32,
    pub healing: f32,
    pub duration: u64,
}
fn number(values: &serde_json::Value, key: &str) -> Result<f32, String> {
    let v = values.get(key).ok_or_else(|| format!("Trundle W native field absent: {key}"))?;
    let n = if let Some(n) = v.as_f64() { n as f32 }
        else if let Some(s) = v.as_str() { s.parse::<f32>().map_err(|_| format!("Trundle W native number invalid: {key}"))? }
        else { return Err(format!("Trundle W native field not numeric: {key}")); };
    if !n.is_finite() { return Err(format!("Trundle W native number nonfinite: {key}")); }
    Ok(n)
}
fn parse(text: &str) -> Result<[Rank; 5], String> {
    let rows: serde_json::Value = serde_json::from_str(text).map_err(|e| e.to_string())?;
    let rows = rows.as_array().ok_or("Trundle W native table is not an array")?;
    let matching: Vec<_> = rows.iter().filter(|r|
        r["champion"].as_str().is_some_and(|c| c.eq_ignore_ascii_case("trundle"))
            && r["slot"].as_u64() == Some(1)).collect();
    if matching.len() != 1 || matching[0]["spell"] != "trundledesecrate" {
        return Err("unique native Trundle W resource required".into());
    }
    let v = &matching[0]["values"];
    // These are distinct serialized fields. Their native consumer precedence
    // is unknown; only ranked CastRange is selected for this implementation.
    for (key, exact) in [("CastRange", 900.), ("CastRadius", 750.),
                         ("CastTargetAdditionalUnitsRadius", 650.)] {
        if number(v, key)? != exact { return Err(format!("Trundle W source geometry changed: {key}")); }
    }
    let mut result = Vec::with_capacity(5);
    for index in 0..5 {
        let rank = index + 1;
        let keys = [format!("ManaCost{rank}"), format!("Cooldown{rank}"),
            format!("CastRange{rank}"), format!("Effect1Level{rank}Amount"),
            format!("Effect2Level{rank}Amount"), format!("Effect3Level{rank}Amount"),
            format!("Effect4Level{rank}Amount")];
        let exact = [60., 15., 750., [20.,25.,30.,35.,40.][index],
            [20.,35.,50.,65.,80.][index], [8.,11.,14.,17.,20.][index], 8.];
        let mut got = [0f32; 7];
        for i in 0..keys.len() {
            got[i] = number(v, &keys[i])?;
            if got[i] != exact[i] { return Err(format!("Trundle W verified field changed: {}", keys[i])); }
        }
        result.push(Rank { cost: got[0], cooldown: got[1], cast_range: got[2],
            movement: got[3]/100., attack_speed: got[4]/100., healing: got[5]/100.,
            duration: spells::seconds(got[6]) });
    }
    result.try_into().map_err(|_| "Trundle W requires five verified ranks".into())
}
pub fn rules(rank: u8) -> Result<Rank, String> {
    if !(1..=5).contains(&rank) { return Err("Trundle W rank out of range".into()); }
    static RULES: OnceLock<Result<[Rank; 5], String>> = OnceLock::new();
    RULES.get_or_init(|| parse(include_str!("../../../data/4.20/native_spells_420.json")))
        .as_ref().map(|r| r[rank as usize-1]).map_err(Clone::clone)
}
fn active(p: &Champion, tick: u64) -> Option<Rank> {
    let z = p.effects.trundle_w.as_ref()?;
    if p.champion != "trundle" || p.id != z.owner || !p.health.is_finite() || p.health <= 0.
        || !p.position.finite() || !z.center.finite() || tick < z.starts || tick >= z.until
        || !(1..=5).contains(&p.ranks[1]) || !(1..=p.ranks[1]).contains(&z.rank) { return None; }
    let r = rules(z.rank).ok()?; // Fail closed; a rejected data table never grants a cast.
    let d = p.position.distance(z.center);
    if z.starts.checked_add(r.duration) != Some(z.until) || !d.is_finite() || d > DOMAIN_RADIUS { return None; }
    Some(r)
}
pub fn movement_bonus(p: &Champion, tick: u64) -> f32 { active(p,tick).map_or(0., |r| r.movement) }
pub fn attack_speed_bonus(p: &Champion, tick: u64) -> f32 { active(p,tick).map_or(0., |r| r.attack_speed) }
pub fn healing_multiplier(p: &Champion, tick: u64) -> f32 { active(p,tick).map_or(1., |r| 1.+r.healing) }

impl Simulation {
    pub(crate) fn cast_trundle_w_at(&mut self, id: u32, point: Point) -> Result<(), String> {
        if self.winner.is_some() { return Err("match ended".into()); }
        if !point.finite() { return Err("invalid Trundle W point".into()); }
        let p = self.players.get(&id).ok_or("unknown player")?;
        if p.champion != "trundle" { return Err("Trundle W requires Trundle".into()); }
        if !p.health.is_finite() || p.health <= 0. { return Err("champion dead".into()); }
        if !p.position.finite() { return Err("invalid Trundle W owner position".into()); }
        if stuns::active(p,self.tick) { return Err("champion stunned".into()); }
        if self.tick < p.effects.silence_until { return Err("champion silenced".into()); }
        let rank = p.ranks[1]; let r = rules(rank)?;
        if self.tick < p.cooldowns[1] { return Err("skill on cooldown".into()); }
        if !p.mana.is_finite() || p.mana < r.cost { return Err("insufficient mana".into()); }
        let distance = p.position.distance(point);
        if !distance.is_finite() || distance > r.cast_range { return Err("Trundle W point out of range".into()); }
        // Local policy: reject nonwalkable/out-of-map center; never clamp/move it.
        if self.navigation.ground(point).is_none() { return Err("Trundle W center has no walkable map ground".into()); }
        let reduction = self.stats(id).cooldown_reduction;
        if !reduction.is_finite() { return Err("invalid cooldown reduction".into()); }
        let cd = cooldown::ticks(r.cooldown,reduction);
        let ready = self.tick.checked_add(cd).ok_or("Trundle W cooldown clock overflow")?;
        let until = self.tick.checked_add(r.duration).ok_or("Trundle W duration clock overflow")?;
        let cast_audience = [self.visible_to(0,id), self.visible_to(1,id)];
        // All validation precedes mutation. Instant local placement deliberately
        // preserves windup, cached crit, cadence, path/target and any armed Q.
        let p = self.players.get_mut(&id).unwrap();
        p.mana -= r.cost; p.cooldowns[1] = ready; p.cooldown_totals[1] = Some(cd);
        p.effects.trundle_w = Some(Zone { owner: id, center: point, rank, starts: self.tick, until });
        self.accepted_casts.record(self.session,id,self.tick,accepted_cast_presentation::Kind::W,cast_audience);
        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn arena() -> Simulation {
        let mut cells=Vec::new(); for _ in 0..6400 { cells.extend(0f32.to_le_bytes()); cells.extend(0u16.to_le_bytes()); cells.extend(0u32.to_le_bytes()); cells.push(1); }
        let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":80,"height":80}"#,&cells).unwrap();
        Simulation::new(nav).unwrap()
    }
    fn game() -> (Simulation,u32,u32) {
        let mut s=arena(); let a=s.join("trundle").unwrap(); let b=s.join("garen").unwrap();
        for (id,x) in [(a,1500.),(b,1600.)] { let p=s.players.get_mut(&id).unwrap(); p.position=Point{x,z:1500.}; p.health=1000.; p.max_health=10000.; p.mana=500.; p.level=2; }
        s.players.get_mut(&a).unwrap().ranks=[1,1,0,0]; (s,a,b)
    }
    fn point(s:&Simulation,a:u32)->Point {s.players[&a].position}
    fn cast(s:&mut Simulation,a:u32) {let p=point(s,a);s.command(a,Action::CastAt{slot:1,point:p}).unwrap();}
    fn close(a:f32,b:f32) {assert!((a-b).abs()<0.002,"{a} != {b}");}
    #[test] fn verified_rank_values_and_missing_duplicate_nonfinite_rows_are_strict() {
        for rank in 1..=5 {let r=rules(rank).unwrap();assert_eq!((r.cost,r.cooldown,r.cast_range,r.duration),(60.,15.,750.,240));close(r.movement,[0.2,0.25,0.3,0.35,0.4][rank as usize-1]);close(r.attack_speed,[0.2,0.35,0.5,0.65,0.8][rank as usize-1]);close(r.healing,[0.08,0.11,0.14,0.17,0.2][rank as usize-1]);}
        for rank in [0,6,255] {assert!(rules(rank).is_err());}
        for rank in 1u8..=5 {let(mut s,a,_)=game();let p=s.players.get_mut(&a).unwrap();p.level=2*rank-1;p.ranks=[0,rank-1,0,0];s.command(a,Action::Learn{slot:1}).unwrap();assert_eq!(s.players[&a].ranks[1],rank);assert!(s.command(a,Action::Learn{slot:1}).is_err());// R and E now have their own exact rank/point-allocation gate tests.
            assert_eq!(s.players[&a].ranks[1],rank);}
        let text=include_str!("../../../data/4.20/native_spells_420.json");
        for case in 0..3 {let mut v:serde_json::Value=serde_json::from_str(text).unwrap();let rows=v.as_array_mut().unwrap();let index=rows.iter().position(|r|r["spell"]=="trundledesecrate").unwrap();
            if case==0 {rows[index]["values"].as_object_mut().unwrap().remove("ManaCost1");}
            else if case==1 {let duplicate=rows[index].clone();rows.push(duplicate);}
            else {rows[index]["values"]["Effect3Level1Amount"]=serde_json::json!("NaN");}
            assert!(parse(&v.to_string()).is_err());}
        assert!(parse("[]").is_err());
    }
    #[test] fn ordinary_cast_commits_once_preserving_windup_path_q_and_cached_roll() {
        let(mut s,a,b)=game();s.command(a,Action::Attack{target:b}).unwrap();s.tick=1;s.advance_attacks();
        s.players.get_mut(&a).unwrap().attack_roll=Some(true);s.players.get_mut(&a).unwrap().effects.trundle_q.armed_rank=1;s.players.get_mut(&a).unwrap().effects.trundle_q.armed_until=200;
        let before=s.players[&a].clone();assert!(before.windup.is_some());let windup=serde_json::to_value(&before.windup).unwrap();let events=s.snapshot().attack_events;cast(&mut s,a);
        let p=&s.players[&a];assert_eq!(p.mana,before.mana-60.);assert_eq!(p.cooldowns[1],451);assert_eq!(p.cooldown_totals[1],Some(450));assert_eq!(p.attack_roll,Some(true));assert_eq!(p.next_attack,before.next_attack);assert_eq!(p.destination,before.destination);assert_eq!(p.target,before.target);assert_eq!(p.path,before.path);assert_eq!(serde_json::to_value(&p.windup).unwrap(),windup);assert_eq!(p.effects.trundle_q.armed_until,200);assert_eq!(s.snapshot().attack_events,events);
        assert!(s.command(a,Action::CastAt{slot:1,point:before.position}).is_err());assert_eq!(s.players[&a].mana,before.mana-60.);
    }
    #[test] fn rejected_commands_do_not_spend_reset_cancel_or_replace_a_zone() {
        for case in 0..10 {let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().attack_roll=Some(true);let mut p=point(&s,a);
            match case {0=>s.players.get_mut(&a).unwrap().ranks[1]=0,1=>s.players.get_mut(&a).unwrap().mana=59.,2=>s.players.get_mut(&a).unwrap().mana=f32::NAN,3=>s.players.get_mut(&a).unwrap().health=0.,4=>s.players.get_mut(&a).unwrap().health=f32::NAN,5=>s.players.get_mut(&a).unwrap().effects.silence_until=1,6=>s.grant_stun(Some(b),a,"fixture",30).unwrap(),7=>s.players.get_mut(&a).unwrap().cooldowns[1]=1,8=>p.x=f32::INFINITY,_=>s.tick=u64::MAX-10}
            let before=serde_json::to_value(&s.players[&a]).unwrap();assert!(s.cast_at(a,1,p).is_err());assert_eq!(serde_json::to_value(&s.players[&a]).unwrap(),before);assert_eq!(s.players[&a].attack_roll,Some(true));}
        let(mut s,a,b)=game();let p=point(&s,a);assert!(s.cast_at(999,1,p).is_err());assert!(s.cast_at(b,1,p).is_err());assert!(s.cast(a,1,None).is_err());assert!(s.cast(a,1,Some(b)).is_err());for slot in [2,3] {assert_eq!(s.players[&a].ranks[slot as usize],0);assert!(s.cast_at(a,slot,p).is_err());assert!(s.cast(a,slot,None).is_err());}
    }
    #[test] fn ranked_target_range_is_closed_and_invalid_ground_is_never_clamped() {
        let(mut s,a,_)=game();let origin=point(&s,a);let boundary=Point{x:origin.x+750.,z:origin.z};assert_eq!(origin.distance(boundary),750.);s.cast_at(a,1,boundary).unwrap();assert_eq!(s.players[&a].effects.trundle_w.as_ref().unwrap().center,boundary);
        let(mut s,a,_)=game();let origin=point(&s,a);let before=serde_json::to_value(&s.players[&a]).unwrap();let outside=Point{x:origin.x+750.25,z:origin.z};assert_eq!(origin.distance(outside),750.25);assert!(s.cast_at(a,1,outside).is_err());assert_eq!(serde_json::to_value(&s.players[&a]).unwrap(),before);
        let inside=origin;let index=s.navigation.index(inside).unwrap();s.navigation.cells[index].1=false;assert!(s.navigation.ground(inside).is_none());assert!(s.cast_at(a,1,inside).is_err());assert_eq!(serde_json::to_value(&s.players[&a]).unwrap(),before);
        s.players.get_mut(&a).unwrap().position=Point{x:25.,z:25.};let p=Point{x:-25.,z:25.};assert!(s.cast_at(a,1,p).is_err());assert!(s.players[&a].effects.trundle_w.is_none());
    }
    #[test] fn zone_boundary_entry_exit_and_half_open_duration_use_current_position() {
        let(mut s,a,_)=game();cast(&mut s,a);let center=s.players[&a].effects.trundle_w.as_ref().unwrap().center;
        s.players.get_mut(&a).unwrap().position=Point{x:center.x+DOMAIN_RADIUS,z:center.z};assert_eq!(s.players[&a].position.distance(center),1000.);assert_eq!(movement_bonus(&s.players[&a],s.tick),0.2);
        s.players.get_mut(&a).unwrap().position.x=center.x+1000.25;assert_eq!(s.players[&a].position.distance(center),1000.25);assert_eq!(movement_bonus(&s.players[&a],s.tick),0.);
        s.players.get_mut(&a).unwrap().position=center;s.tick=239;assert!(attack_speed_bonus(&s.players[&a],s.tick)>0.);s.tick=240;assert_eq!(attack_speed_bonus(&s.players[&a],s.tick),0.);assert_eq!(healing_multiplier(&s.players[&a],s.tick),1.);
    }
    #[test] fn membership_is_owner_only_and_bad_serialized_state_never_grants_modifiers() {
        let(mut s,a,b)=game();cast(&mut s,a);let zone=s.players[&a].effects.trundle_w.clone();let c=s.join("trundle").unwrap();let center=point(&s,a);
        for id in [b,c] {let p=s.players.get_mut(&id).unwrap();p.position=center;p.ranks[1]=1;p.effects.trundle_w=zone.clone();assert_eq!(movement_bonus(p,0),0.);assert_eq!(healing_multiplier(p,0),1.);}
        for case in 0..6 {let mut p=s.players[&a].clone();match case {0=>p.effects.trundle_w.as_mut().unwrap().owner+=1,1=>p.effects.trundle_w.as_mut().unwrap().rank=0,2=>p.effects.trundle_w.as_mut().unwrap().until+=1,3=>p.effects.trundle_w.as_mut().unwrap().starts=1,4=>p.health=f32::NAN,_=>p.position.x=f32::NAN};assert_eq!(attack_speed_bonus(&p,0),0.);assert_eq!(healing_multiplier(&p,0),1.);}
    }
    #[test] fn six_owners_keep_separate_domains_and_shared_stats_caps_do_not_change() {
        let(mut other,a,b)=game();let baseline=other.stats(b);cast(&mut other,a);
        assert_eq!(other.stats(b).move_speed.to_bits(),baseline.move_speed.to_bits());assert_eq!(other.stats(b).attack_cooldown_ticks,baseline.attack_cooldown_ticks);
        let mut s=arena();let ids:Vec<_>=(0..6).map(|_|s.join("trundle").unwrap()).collect();assert_eq!(s.players.len(),6);
        for id in &ids {let p=s.players.get_mut(id).unwrap();p.position=Point{x:1500.,z:1500.};p.ranks[1]=1;p.mana=500.;p.health=1000.;p.max_health=10000.;p.level=2;let before=s.stats(*id);cast(&mut s,*id);assert_eq!(s.players[id].effects.trundle_w.as_ref().unwrap().owner,*id);assert!(s.stats(*id).move_speed>before.move_speed);assert!(s.stats(*id).attack_cooldown_ticks<before.attack_cooldown_ticks);assert!(s.stats(*id).attack_cooldown_ticks>=12);assert_eq!(s.players[id].effects.trundle_w.as_ref().unwrap().rank,1);}
        // Synthetic base cadence deliberately exercises the existing 12-tick
        // floor; no production champion stat is replaced by this fixture.
        let(mut s,a,_)=game();s.definitions.get_mut("trundle").unwrap().attack_cooldown_ticks=12;assert_eq!(s.stats(a).attack_cooldown_ticks,12);cast(&mut s,a);assert_eq!(s.stats(a).attack_cooldown_ticks,12);
        for flat in [220.,415.,490.,1000.] {close(movement::effective_speed(&s.players[&a],flat,s.tick),movement::soft_cap(flat*1.2));}
    }
    #[test] fn shared_heal_regeneration_potion_and_ignite_order_are_not_double_amplified() {
        let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().level=9;s.players.get_mut(&a).unwrap().ranks[1]=5;cast(&mut s,a);
        close(s.heal(None,a,100.).unwrap().restored,120.);
        s.players.get_mut(&a).unwrap().effects.ignite=Some(summoner_ignite::Burn{source:b,source_team:1,expires_at:100,next_tick:100,remaining_ticks:1,damage_per_tick:0.});close(s.heal(Some(a),a,100.).unwrap().restored,60.);
        s.players.get_mut(&a).unwrap().effects.ignite=None;let before=s.players[&a].health;let rate=s.regeneration_rates(a).unwrap().health_per_second;s.advance_regeneration();close(s.players[&a].health-before,rate/30.*1.2);
        let before=s.players[&a].health;s.players.get_mut(&a).unwrap().effects.health_potion_ticks=1;let potion=shop::catalog().iter().find(|i|i.id==2003).unwrap().consumable.unwrap();s.advance_consumables();close(s.players[&a].health-before,potion.amount/potion.duration_seconds/30.*1.2);
        s.players.get_mut(&a).unwrap().health=9999.;close(s.heal(None,a,100.).unwrap().restored,1.);
    }
    #[test] fn lifesteal_and_installed_death_passive_use_the_same_received_healing_once() {
        let(mut s,a,b)=game();let p=s.players.get_mut(&a).unwrap();p.level=18;p.ranks[1]=5;p.inventory[0]=Some(1053);cast(&mut s,a);let before=s.players[&a].health;let steal=s.stats(a).life_steal;assert!(steal>0.);let hit=s.basic_attack_hit(a,b,100.).unwrap();close(s.players[&a].health-before,hit.post_mitigation*steal*1.2);
        s.players.get_mut(&b).unwrap().max_health=1000.;s.players.get_mut(&b).unwrap().health=1.;let before=s.players[&a].health;s.apply_damage(Some(a),b,100.,damage::DamageKind::True).unwrap();close(s.players[&a].health-before,1000.*trundle_passive::ratio(18).unwrap()*1.2);
    }
    #[test] fn captured_rank_death_respawn_and_terminal_guards_leave_no_sticky_buff() {
        let(mut s,a,b)=game();cast(&mut s,a);s.players.get_mut(&a).unwrap().ranks[1]=5;assert_eq!(attack_speed_bonus(&s.players[&a],s.tick),0.2);
        let serialized=serde_json::to_value(&s.players[&a]).unwrap();let restored:Champion=serde_json::from_value(serialized).unwrap();assert_eq!(movement_bonus(&restored,s.tick),0.2);
        s.apply_damage(Some(b),a,100000.,damage::DamageKind::True).unwrap();assert!(s.players[&a].effects.trundle_w.is_none());assert_eq!(healing_multiplier(&s.players[&a],s.tick),1.);let due=s.players[&a].respawn_at.unwrap();s.tick=due;s.advance_respawns();assert!(s.players[&a].health>0.);assert_eq!(s.players[&a].respawn_at,None);assert!(s.players[&a].effects.trundle_w.is_none());
        s.winner=Some(0);let before=serde_json::to_value(&s.players[&a]).unwrap();let p=point(&s,a);assert!(s.cast_at(a,1,p).is_err());assert_eq!(serde_json::to_value(&s.players[&a]).unwrap(),before);
    }
}
