//! PARTIAL reconstructed Subjugate. Numeric bindings are native/Riot 4.20.1.
//! The four 1s pulses, snapshots, ordering, death cleanup and HP-removed healing
//! are explicit local policies, not recovered native server callbacks.
use crate::*;
use std::sync::OnceLock;

const PULSES: u8 = 4;
const STEP: u64 = TICK_RATE;
const HOLD: u64 = 8 * TICK_RATE;
const ARITHMETIC_LIMIT: f32 = f32::MAX / 8.;

#[derive(Debug, Clone, Copy)]
pub struct Rank {
    pub cost: f32,
    pub cooldown: f32,
    pub range: f32,
    pub health_percent: f32,
    pub ap_percent: f32,
    pub defense_fraction: f32,
}
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Drain {
    pub owner: u32,
    pub target: u32,
    pub rank: u8,
    pub starts: u64,
    pub until: u64,
    pub pulses: u8,
    pub total_raw: f32,
    pub raw_applied: f32,
    pub armor: f32,
    pub mr: f32,
}
fn number(v: &serde_json::Value, key: &str) -> Result<f32, String> {
    let v = v.get(key).ok_or_else(|| format!("Trundle R native field absent: {key}"))?;
    let n = if let Some(n) = v.as_f64() { n as f32 }
        else if let Some(s) = v.as_str() { s.parse::<f32>().map_err(|_| format!("Trundle R invalid number: {key}"))? }
        else { return Err(format!("Trundle R field is not numeric: {key}")); };
    if !n.is_finite() { return Err(format!("Trundle R nonfinite field: {key}")); }
    Ok(n)
}
fn parse(text: &str) -> Result<[Rank; 3], String> {
    let data: serde_json::Value = serde_json::from_str(text).map_err(|e| e.to_string())?;
    let rows = data.as_array().ok_or("Trundle R native table is not an array")?;
    let rows: Vec<_> = rows.iter().filter(|r| r["champion"].as_str().is_some_and(|c| c.eq_ignore_ascii_case("trundle")) && r["slot"].as_u64() == Some(3)).collect();
    if rows.len() != 1 || rows[0]["spell"] != "TrundlePain" { return Err("unique native Trundle R resource required".into()); }
    let v = &rows[0]["values"];
    if v["AnimationName"] != "Spell4" || v["TextFlags"] != "AffectEnemies | AffectHeroes" { return Err("Trundle R source identity changed".into()); }
    for (k, exact) in [("CastRange",700.),("CastRadius",300.),("Coefficient",0.02)] {
        if number(v,k)? != exact { return Err(format!("Trundle R verified field changed: {k}")); }
    }
    let mut result = Vec::with_capacity(3);
    for i in 0..3 {
        let rank = i + 1;
        let keys = [format!("ManaCost{rank}"),format!("Cooldown{rank}"),format!("CastRange{rank}"),format!("Effect1Level{rank}Amount"),format!("Effect2Level{rank}Amount"),format!("Effect3Level{rank}Amount"),format!("Effect4Level{rank}Amount"),format!("Effect5Level{rank}Amount")];
        let exact = [75.,[80.,70.,60.][i],650.,[20.,24.,28.][i],40.,4.,4.,4.];
        for (key,want) in keys.iter().zip(exact) {
            if number(v,key)? != want { return Err(format!("Trundle R verified field changed: {key}")); }
        }
        result.push(Rank {cost:75.,cooldown:exact[1],range:650.,health_percent:exact[3],ap_percent:number(v,"Coefficient")?,defense_fraction:0.4});
    }
    result.try_into().map_err(|_| "Trundle R requires exactly three ranks".into())
}
pub fn rules(rank: u8) -> Result<Rank, String> {
    if !(1..=3).contains(&rank) { return Err("Trundle R rank out of range".into()); }
    static RULES: OnceLock<Result<[Rank; 3], String>> = OnceLock::new();
    RULES.get_or_init(|| parse(include_str!("../../../data/4.20/native_spells_420.json")))
        .as_ref().map(|v| v[rank as usize-1]).map_err(Clone::clone)
}
fn bounded(value: f64) -> Result<f32, String> {
    if !value.is_finite() || value < 0. || value > ARITHMETIC_LIMIT as f64 { return Err("Trundle R arithmetic out of bounds".into()); }
    Ok(value as f32)
}
fn total_damage(r: Rank, max_health: f32, ap: f32) -> Result<f32, String> {
    if !max_health.is_finite() || max_health <= 0. || !ap.is_finite() || ap < 0. { return Err("Trundle R invalid damage snapshot".into()); }
    bounded(max_health as f64 * (r.health_percent as f64 + r.ap_percent as f64 * ap as f64) / 100.)
}
fn amount(total: f32, step: u8) -> f32 {
    if step == 0 { return total * 0.5; }
    if step < PULSES { return total * 0.125; }
    // Final remainder avoids adding a fifth rounded eighth to the total.
    let eighth = total * 0.125;
    (total - (((total * 0.5 + eighth) + eighth) + eighth)).max(0.)
}
fn applied(total: f32, pulses: u8) -> f32 {
    (0..=pulses).map(|n| amount(total,n)).fold(0., |sum,v| sum+v)
}
fn healthy(p: &Champion) -> bool {
    p.health.is_finite() && p.health > 0. && p.max_health.is_finite() && p.max_health > 0. && p.health <= p.max_health
}

impl Simulation {
    fn trundle_r_live(&self, d: &Drain) -> bool {
        if self.winner.is_some() || self.players.len() > 6 || d.owner == d.target || d.pulses > PULSES || self.tick < d.starts || self.tick >= d.until
            || d.starts.checked_add(HOLD) != Some(d.until) || !(1..=3).contains(&d.rank)
            || ![d.total_raw,d.armor,d.mr].into_iter().all(|n| n.is_finite() && (0. ..=ARITHMETIC_LIMIT).contains(&n))
            || d.raw_applied.to_bits() != applied(d.total_raw,d.pulses).to_bits() { return false; }
        let (Some(a),Some(b)) = (self.players.get(&d.owner),self.players.get(&d.target)) else { return false; };
        a.id == d.owner && b.id == d.target && a.champion == "trundle" && healthy(a) && healthy(b) && a.team != b.team
            && (d.rank..=3).contains(&a.ranks[3])
    }
    /// Pure, bounded lookup: NEVER calls stats(), damage(), heal() or mutates bases.
    pub(crate) fn trundle_r_defense_adjustment(&self, id: u32) -> (f32,f32) {
        let mut armor = 0f64; let mut mr = 0f64;
        for p in self.players.values().take(6) {
            let Some(d) = &p.effects.trundle_r else { continue; };
            if p.id != d.owner || !self.trundle_r_live(d) { continue; }
            let sign = if id == d.owner {1.} else if id == d.target {-1.} else {continue;};
            let fraction = (PULSES + d.pulses) as f64 / 8.;
            armor += sign * fraction * d.armor as f64;
            mr += sign * fraction * d.mr as f64;
        }
        (armor as f32,mr as f32)
    }
    /// Clears BOTH sides immediately. A record copied for a pulse is never reinserted.
    pub(crate) fn clear_trundle_r_for(&mut self, id: u32) {
        for p in self.players.values_mut() {
            if p.id == id || p.effects.trundle_r.as_ref().is_some_and(|d| d.owner == id || d.target == id) { p.effects.trundle_r = None; }
        }
    }
    pub(crate) fn clear_trundle_r_terminal(&mut self) {
        for p in self.players.values_mut() { p.effects.trundle_r = None; }
    }
    // All checks which can make common apply_damage fail precede command writes.
    fn validate_trundle_r_hit(&self, owner: u32, target: u32, raw: f32) -> Result<(), String> {
        if self.winner.is_some() { return Err("match ended".into()); }
        let a = self.players.get(&owner).ok_or("unknown Trundle R owner")?;
        let b = self.players.get(&target).ok_or("Trundle R requires an enemy champion")?;
        if a.champion != "trundle" || !healthy(a) || !healthy(b) || a.team == b.team { return Err("invalid Trundle R actors".into()); }
        if self.protected(target) || !raw.is_finite() || raw < 0. { return Err("invalid Trundle R damage target".into()); }
        let s = self.stats(target);
        let (armor,mr) = self.penetrated_defenses(Some(owner),damage::DamageKind::Magical,s.armor,s.magic_resist)?;
        let outgoing = raw * self.exhaust_damage_multiplier(Some(owner),damage::DamageKind::Magical);
        let reduction = if self.tick < b.effects.courage_until {0.7} else {1.};
        damage::mitigate(outgoing,damage::DamageKind::Magical,armor,mr,reduction).ok_or("invalid Trundle R defense/mitigation")?;
        Ok(())
    }
    fn heal_trundle_r_hit(&mut self, owner: u32, outcome: damage::DamageOutcome) {
        // R damage may already have triggered the installed death passive/XP.
        // Read current actor; never restore a pre-damage Champion clone.
        if outcome.health_removed > 0. && self.winner.is_none() && self.players.get(&owner).is_some_and(healthy) {
            self.heal(Some(owner),owner,outcome.health_removed).expect("validated current R heal owner and finite damage outcome");
        }
    }
    pub(crate) fn cast_trundle_r(&mut self, id: u32, target: Option<u32>) -> Result<(), String> {
        if self.winner.is_some() { return Err("match ended".into()); }
        let target = target.ok_or("Trundle R requires an enemy champion")?;
        let p = self.players.get(&id).ok_or("unknown player")?;
        if p.champion != "trundle" || !healthy(p) || !p.position.finite() { return Err("invalid Trundle R owner".into()); }
        if stuns::active(p,self.tick) || self.tick < p.effects.silence_until { return Err("Trundle R owner disabled".into()); }
        let rank = p.ranks[3]; let r = rules(rank)?;
        if self.tick < p.cooldowns[3] { return Err("skill on cooldown".into()); }
        if !p.mana.is_finite() || p.mana < r.cost { return Err("insufficient mana".into()); }
        if p.windup.as_ref().is_some_and(|w| !w.cancelable) { return Err("attack windup cannot be cancelled".into()); }
        if self.players.len() > 6 || p.effects.trundle_r.as_ref().is_some_and(|d| self.trundle_r_live(d)) { return Err("Trundle R caster slot occupied".into()); }
        let b = self.players.get(&target).ok_or("Trundle R requires an enemy champion")?;
        if !healthy(b) || b.team == p.team || !b.position.finite() || self.protected(target) || !self.visible_to(p.team,target) { return Err("invalid visible Trundle R target".into()); }
        let distance = p.position.distance(b.position);
        if !distance.is_finite() || distance > r.range { return Err("Trundle R target out of range".into()); }
        let caster = self.stats(id); let enemy = self.stats(target);
        if !caster.cooldown_reduction.is_finite() || !caster.armor.is_finite() || !caster.magic_resist.is_finite() || !enemy.armor.is_finite() || !enemy.magic_resist.is_finite() { return Err("invalid Trundle R stats snapshot".into()); }
        let raw = total_damage(r,b.max_health,caster.ability_power)?;
        // Remove ALL current R adjustments from the snapshot. Existing unrelated
        // item/level/Garen/Annie/Exhaust changes remain in their ordinary formula.
        let adjustment = self.trundle_r_defense_adjustment(target);
        let armor = bounded(((enemy.armor as f64-adjustment.0 as f64).max(0.))*r.defense_fraction as f64)?;
        let mr = bounded(((enemy.magic_resist as f64-adjustment.1 as f64).max(0.))*r.defense_fraction as f64)?;
        let cd = cooldown::ticks(r.cooldown,caster.cooldown_reduction);
        let ready = self.tick.checked_add(cd).ok_or("Trundle R cooldown clock overflow")?;
        let until = self.tick.checked_add(HOLD).ok_or("Trundle R duration clock overflow")?;
        self.tick.checked_add(PULSES as u64 * STEP).ok_or("Trundle R pulse clock overflow")?;
        let first = amount(raw,0);
        self.validate_trundle_r_hit(id,target,first)?;
        let captured = self.capture_attack_presentation(id);
        let cast_audience = [self.visible_to(0,id), self.visible_to(1,id)];
        // First magic damage is BEFORE this cast's first resistance transfer.
        // Common damage runs only after every command check above. Its fallible
        // defense path was preflighted; own mana/CD/windup are untouched on error.
        let outcome = self.apply_damage(Some(id),target,first,damage::DamageKind::Magical)?;
        self.cancel_captured_attack_presentation(captured,attack_presentation::CancelReason::OtherCast);
        let p = self.players.get_mut(&id).unwrap();
        p.mana -= r.cost; p.cooldowns[3] = ready; p.cooldown_totals[3] = Some(cd);
        // Instant reconstructed R interrupts only an unresolved cancelable BA;
        // no reset, no cached-roll discard, no Q/W/path/target/cadence rewriting.
        p.windup = None;
        self.heal_trundle_r_hit(id,outcome);
        if self.players.get(&id).is_some_and(healthy) && self.players.get(&target).is_some_and(healthy) {
            self.players.get_mut(&id).unwrap().effects.trundle_r = Some(Drain {owner:id,target,rank,starts:self.tick,until,pulses:0,total_raw:raw,raw_applied:first,armor,mr});
        }
        // Accepted even when the first hit was lethal and no Drain exists.
        self.accepted_casts.record(self.session,id,self.tick,accepted_cast_presentation::Kind::R,cast_audience);
        Ok(())
    }
    pub(crate) fn advance_trundle_r(&mut self) {
        if self.winner.is_some() { self.clear_trundle_r_terminal(); return; }
        let owners: Vec<_> = self.players.keys().copied().take(6).collect();
        for owner in owners {
            loop {
                let Some(d) = self.players.get(&owner).and_then(|p| p.effects.trundle_r.clone()) else { break; };
                if !self.trundle_r_live(&d) { self.players.get_mut(&owner).unwrap().effects.trundle_r = None; break; }
                if d.pulses == PULSES { break; }
                let step = d.pulses + 1;
                let Some(due) = d.starts.checked_add(step as u64 * STEP) else { self.players.get_mut(&owner).unwrap().effects.trundle_r = None; break; };
                if self.tick < due { break; }
                let raw = amount(d.total_raw,step);
                // After commitment movement/visibility/stun do not cancel drain.
                // Protection, invalid actors/stats or failed common damage end it.
                if self.validate_trundle_r_hit(owner,d.target,raw).is_err() { self.players.get_mut(&owner).unwrap().effects.trundle_r = None; break; }
                let Ok(outcome) = self.apply_damage(Some(owner),d.target,raw,damage::DamageKind::Magical) else { self.players.get_mut(&owner).unwrap().effects.trundle_r = None; break; };
                self.heal_trundle_r_hit(owner,outcome);
                // A lethal hit clears all matching pairs in damage(). Do NOT
                // reinsert d, including when the same id later respawns.
                let Some(current) = self.players.get_mut(&owner).and_then(|p| p.effects.trundle_r.as_mut()) else { break; };
                if current.starts != d.starts || current.target != d.target { break; }
                current.pulses = step; current.raw_applied += raw;
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn arena() -> Simulation {
        let mut cells=Vec::new(); for _ in 0..6400 {cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
        Simulation::new(Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":80,"height":80}"#,&cells).unwrap()).unwrap()
    }
    fn game() -> (Simulation,u32,u32) {
        let mut s=arena();let a=s.join("trundle").unwrap();let b=s.join("garen").unwrap();
        for (id,x) in [(a,1500.),(b,1600.)] {let p=s.players.get_mut(&id).unwrap();p.position=Point{x,z:1500.};p.health=1000.;p.max_health=10000.;p.mana=1000.;p.level=6;}
        s.players.get_mut(&a).unwrap().ranks=[1,1,0,1];(s,a,b)
    }
    fn cast(s:&mut Simulation,a:u32,b:u32) {s.command(a,Action::Cast{slot:3,target:Some(b)}).unwrap();}
    fn close(a:f32,b:f32) {assert!((a-b).abs()<0.01,"{a} != {b}");}
    fn effects(s:&Simulation,id:u32)->serde_json::Value {serde_json::to_value(&s.players[&id]).unwrap()}
    #[test] fn native_r_three_ranks_ap_and_corrupt_rows_are_strict() {
        for rank in 1..=3 {let r=rules(rank).unwrap();assert_eq!((r.cost,r.cooldown,r.range),(75.,[80.,70.,60.][rank as usize-1],650.));close(total_damage(r,1000.,100.).unwrap(),[220.,260.,300.][rank as usize-1]);}
        for rank in [0,4,5,255] {assert!(rules(rank).is_err());}
        let text=include_str!("../../../data/4.20/native_spells_420.json");
        for case in 0..4 {let mut v:serde_json::Value=serde_json::from_str(text).unwrap();let rows=v.as_array_mut().unwrap();let n=rows.iter().position(|r|r["spell"]=="TrundlePain").unwrap();
            match case {0=>{rows[n]["values"].as_object_mut().unwrap().remove("ManaCost1");},1=>{let copy=rows[n].clone();rows.push(copy);},2=>rows[n]["values"]["Coefficient"]=serde_json::json!("NaN"),_=>rows[n]["values"]["Effect1Level2Amount"]=serde_json::json!(20)}
            assert!(parse(&v.to_string()).is_err());}
        assert!(parse("[]").is_err());assert!(total_damage(rules(1).unwrap(),f32::NAN,0.).is_err());assert!(total_damage(rules(1).unwrap(),1000.,-1.).is_err());
    }
    #[test] fn ordinary_r_commit_cancels_identified_windup_without_q_reset_or_roll_loss() {
        let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().health=9000.;s.command(a,Action::Attack{target:b}).unwrap();s.tick=1;s.advance_attacks();assert!(s.players[&a].windup.is_some());
        s.players.get_mut(&a).unwrap().attack_roll=Some(true);s.players.get_mut(&a).unwrap().effects.trundle_q.armed_rank=1;s.players.get_mut(&a).unwrap().effects.trundle_q.armed_until=100;
        let before=s.players[&a].clone();let attack=before.windup.as_ref().unwrap().presentation.unwrap();cast(&mut s,a,b);
        let p=&s.players[&a];assert_eq!(p.mana,before.mana-75.);assert_eq!(p.cooldowns[3],2401);assert_eq!(p.cooldown_totals[3],Some(2400));assert!(p.windup.is_none());assert_eq!(p.attack_roll,Some(true));assert_eq!(p.next_attack,before.next_attack);assert_eq!(p.path,before.path);assert_eq!(p.destination,before.destination);assert_eq!(p.target,before.target);assert_eq!(p.effects.trundle_q.armed_until,100);
        let events=s.snapshot().attack_events;assert_eq!(events.iter().filter(|e|e.attack==attack&&matches!(e.phase,attack_presentation::Phase::Cancelled{reason:attack_presentation::CancelReason::OtherCast})).count(),1);assert!(s.attack_presentation_error.is_none());
        let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().health=9000.;s.command(a,Action::Attack{target:b}).unwrap();s.tick=1;s.advance_attacks();let attack=s.players[&a].windup.as_ref().unwrap().presentation.unwrap();s.tick=attack.release;s.advance_attacks();assert!(s.players[&a].windup.is_none());let prior=s.snapshot().attack_events;s.players.get_mut(&a).unwrap().attack_roll=Some(true);cast(&mut s,a,b);assert_eq!(s.players[&a].attack_roll,Some(true));assert_eq!(s.snapshot().attack_events,prior);
    }
    #[test] fn rejected_r_commands_are_atomic_for_owner_target_stats_and_clocks() {
        for case in 0..15 {let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().attack_roll=Some(true);
            match case {0=>s.players.get_mut(&a).unwrap().ranks[3]=0,1=>s.players.get_mut(&a).unwrap().mana=74.,2=>s.players.get_mut(&a).unwrap().mana=f32::NAN,3=>s.players.get_mut(&a).unwrap().health=0.,4=>s.players.get_mut(&a).unwrap().effects.silence_until=1,5=>s.grant_stun(Some(b),a,"fixture",30).unwrap(),6=>s.players.get_mut(&a).unwrap().cooldowns[3]=1,7=>s.players.get_mut(&b).unwrap().team=s.players[&a].team,8=>s.players.get_mut(&b).unwrap().health=f32::NAN,9=>s.players.get_mut(&b).unwrap().health=0.,10=>s.players.get_mut(&b).unwrap().position.x=f32::INFINITY,11=>s.players.get_mut(&a).unwrap().position.x=f32::NAN,12=>s.tick=u64::MAX-10,13=>s.definitions.get_mut("garen").unwrap().magic_resist=f32::NAN,_=>s.players.get_mut(&a).unwrap().champion="garen".into()}
            let before=(effects(&s,a),effects(&s,b));let result=if case==14 {s.cast_trundle_r(a,Some(b))} else {s.cast(a,3,Some(b))};assert!(result.is_err());assert_eq!((effects(&s,a),effects(&s,b)),before);assert_eq!(s.players[&a].attack_roll,Some(true));}
        let(mut s,a,b)=game();assert!(s.cast(a,3,None).is_err());assert!(s.cast(999,3,Some(b)).is_err());assert!(s.cast(a,3,Some(999)).is_err());assert!(s.cast(a,3,Some(a)).is_err());assert!(s.cast(a,2,Some(b)).is_err());
        // Public dispatcher must retain the unrelated valid Garen R.
        let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().champion="garen".into();s.cast(a,3,Some(b)).unwrap();assert!(s.players[&a].effects.ultimate.is_some());assert!(s.players[&a].effects.trundle_r.is_none());
    }
    #[test] fn r_target_center_range_visibility_and_uncancelable_windup_are_strict() {
        let(mut s,a,b)=game();let origin=s.players[&a].position;s.players.get_mut(&b).unwrap().position=Point{x:origin.x+650.,z:origin.z};s.players.get_mut(&b).unwrap().health=9000.;assert_eq!(origin.distance(s.players[&b].position),650.);cast(&mut s,a,b);
        let(mut s,a,b)=game();let origin=s.players[&a].position;s.players.get_mut(&b).unwrap().position=Point{x:origin.x+650.25,z:origin.z};let before=effects(&s,a);assert!(s.cast(a,3,Some(b)).is_err());assert_eq!(effects(&s,a),before);
        let(mut s,a,b)=game();s.command(a,Action::Attack{target:b}).unwrap();s.tick=1;s.advance_attacks();s.players.get_mut(&a).unwrap().windup.as_mut().unwrap().cancelable=false;let before=effects(&s,a);assert!(s.cast(a,3,Some(b)).is_err());assert_eq!(effects(&s,a),before);
        s.players.get_mut(&a).unwrap().windup=None;s.enable_interactions();s.players.get_mut(&b).unwrap().position=Point{x:3500.,z:3500.};assert!(!s.visible_to(s.players[&a].team,b));assert!(s.cast(a,3,Some(b)).is_err());
    }
    #[test] fn first_magic_hit_precedes_first_shred_and_timed_total_is_once() {
        let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().health=9000.;let defense=s.stats(b).magic_resist;let raw=total_damage(rules(1).unwrap(),s.players[&b].max_health,s.stats(a).ability_power).unwrap();let hp=s.players[&b].health;
        let first=damage::mitigate(raw*0.5,damage::DamageKind::Magical,0.,defense,1.).unwrap();cast(&mut s,a,b);close(hp-s.players[&b].health,first);close(s.stats(b).magic_resist,defense*0.8);
        for n in 1..=4 {s.tick=n*STEP;s.advance_trundle_r();assert_eq!(s.players[&a].effects.trundle_r.as_ref().unwrap().pulses,n as u8);let hp=s.players[&b].health;s.advance_trundle_r();assert_eq!(s.players[&b].health,hp);}
        let d=s.players[&a].effects.trundle_r.as_ref().unwrap();assert_eq!(d.raw_applied.to_bits(),raw.to_bits());close(s.stats(b).magic_resist,defense*0.6);s.tick=239;assert!(s.trundle_r_defense_adjustment(a).1>0.);s.tick=240;s.advance_trundle_r();assert!(s.players[&a].effects.trundle_r.is_none());close(s.stats(b).magic_resist,defense);
    }
    #[test] fn r_healing_uses_removed_hp_after_shields_overkill_w_and_ignite_once() {
        let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().health=9000.;s.grant_shield(b,"fixture",100000.,300).unwrap();let hp=s.players[&a].health;cast(&mut s,a,b);assert_eq!(s.players[&a].health,hp);assert_eq!(s.players[&b].health,9000.);
        let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().level=18;s.players.get_mut(&a).unwrap().ranks[1]=5;s.command(a,Action::CastAt{slot:1,point:Point{x:1500.,z:1500.}}).unwrap();s.players.get_mut(&a).unwrap().effects.ignite=Some(summoner_ignite::Burn{source:b,source_team:1,expires_at:100,next_tick:100,remaining_ticks:1,damage_per_tick:0.});s.players.get_mut(&b).unwrap().health=10.;let hp=s.players[&a].health;
        // Existing nearby-death passive is a separate legitimate heal; include it
        // explicitly, not by attributing the whole caster HP delta to R.
        let passive=s.players[&b].max_health*trundle_passive::ratio(18).unwrap();cast(&mut s,a,b);close(s.players[&a].health-hp,(passive+10.)*1.2*0.5);assert!(s.players[&a].effects.trundle_r.is_none());assert_eq!(s.players[&a].score.kills,1);
        let hp=s.players[&a].health;s.tick=120;s.advance_trundle_r();assert_eq!(s.players[&a].health,hp);assert_eq!(s.players[&a].score.kills,1);
    }
    #[test] fn lethal_pulse_death_respawn_and_departure_never_reinsert_a_pair() {
        let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().health=9000.;let base=s.stats(a).armor;cast(&mut s,a,b);s.players.get_mut(&b).unwrap().health=1.;s.tick=30;s.advance_trundle_r();assert!(s.players[&a].effects.trundle_r.is_none());close(s.stats(a).armor,base);let due=s.players[&b].respawn_at.unwrap();s.tick=due;s.advance_respawns();assert!(s.players[&b].health>0.);assert!(s.players[&a].effects.trundle_r.is_none());
        let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().health=9000.;cast(&mut s,a,b);s.apply_damage(Some(b),a,100000.,damage::DamageKind::True).unwrap();assert!(s.players[&a].effects.trundle_r.is_none());assert_eq!(s.trundle_r_defense_adjustment(b),(0.,0.));
        let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().health=9000.;cast(&mut s,a,b);s.remove_player(b).unwrap();assert!(s.players[&a].effects.trundle_r.is_none());
    }
    #[test] fn simultaneous_r_uses_non_r_snapshots_and_restores_without_base_writes() {
        let mut s=arena();let a=s.join("trundle").unwrap();let b=s.join("trundle").unwrap();let c=s.join("trundle").unwrap();
        for id in [a,b,c] {let p=s.players.get_mut(&id).unwrap();p.position=Point{x:1500.,z:1500.};p.health=9000.;p.max_health=10000.;p.mana=1000.;p.ranks[3]=1;p.level=6;}
        s.players.get_mut(&a).unwrap().team=0;s.players.get_mut(&b).unwrap().team=1;s.players.get_mut(&c).unwrap().team=0;let baseline=s.stats(b);let defs=serde_json::to_value(&s.definitions).unwrap();cast(&mut s,a,b);cast(&mut s,c,b);
        close(s.players[&a].effects.trundle_r.as_ref().unwrap().armor,s.players[&c].effects.trundle_r.as_ref().unwrap().armor);close(s.stats(b).armor,baseline.armor*0.6);
        s.tick=120;s.advance_trundle_r();close(s.stats(b).armor,baseline.armor*0.2);s.players.get_mut(&b).unwrap().inventory[0]=Some(1029);let item=s.stats(b).armor-baseline.armor*0.2;assert!(item>0.);s.tick=240;s.advance_trundle_r();close(s.stats(b).armor,baseline.armor+item);assert_eq!(serde_json::to_value(&s.definitions).unwrap(),defs);
    }
    #[test] fn negative_defenses_are_not_stolen_or_globally_clamped() {
        let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().health=9000.;s.definitions.get_mut("garen").unwrap().armor=-500.;s.definitions.get_mut("garen").unwrap().magic_resist=-500.;let before=s.stats(b);assert!(before.armor<0.&&before.magic_resist<0.);cast(&mut s,a,b);let d=s.players[&a].effects.trundle_r.as_ref().unwrap();assert_eq!((d.armor,d.mr),(0.,0.));close(s.stats(b).armor,before.armor);close(s.stats(b).magic_resist,before.magic_resist);
    }
    #[test] fn r_refresh_invalid_records_catchup_and_terminal_are_bounded() {
        let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().health=9000.;cast(&mut s,a,b);s.players.get_mut(&a).unwrap().cooldowns[3]=0;let before=effects(&s,a);assert!(s.cast(a,3,Some(b)).is_err());assert_eq!(effects(&s,a),before);
        s.tick=120;s.advance_trundle_r();assert_eq!(s.players[&a].effects.trundle_r.as_ref().unwrap().pulses,4);let hp=s.players[&b].health;s.advance_trundle_r();assert_eq!(s.players[&b].health,hp);
        s.players.get_mut(&a).unwrap().effects.trundle_r.as_mut().unwrap().raw_applied=f32::NAN;assert_eq!(s.trundle_r_defense_adjustment(a),(0.,0.));s.advance_trundle_r();assert!(s.players[&a].effects.trundle_r.is_none());
        let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().health=9000.;cast(&mut s,a,b);s.winner=Some(0);let hp=s.players[&b].health;s.advance();assert!(s.players[&a].effects.trundle_r.is_none());assert_eq!(s.players[&b].health,hp);assert!(s.cast(a,3,Some(b)).is_err());
    }
    #[test] fn r_progression_preserves_q_w_and_other_champion_gates() {
        for (rank,level) in [(1,6),(2,11),(3,16)] {let(mut s,a,_)=game();let p=s.players.get_mut(&a).unwrap();p.level=level-1;p.ranks=[0,0,0,rank-1];assert!(s.command(a,Action::Learn{slot:3}).is_err());s.players.get_mut(&a).unwrap().level=level;s.command(a,Action::Learn{slot:3}).unwrap();assert_eq!(s.players[&a].ranks[3],rank);s.command(a,Action::Learn{slot:2}).unwrap();assert_eq!(s.players[&a].ranks,[0,0,1,rank]);}
        let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().ranks=[0,0,0,0];s.command(a,Action::Learn{slot:0}).unwrap();s.command(a,Action::Learn{slot:1}).unwrap();assert!(s.command(b,Action::Learn{slot:3}).is_ok());let c=s.join("ahri").unwrap();s.players.get_mut(&c).unwrap().level=18;assert!(s.command(c,Action::Learn{slot:3}).is_err());
    }
}
