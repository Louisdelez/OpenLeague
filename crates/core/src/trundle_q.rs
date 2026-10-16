//! Explicit reconstruction of PARTIAL historical Trundle Q, not native server parity.
//! Native mana/CD/Effect1/2 and client DDF are verified sources. The DDF coefficient
//! conflicts with Effect3 at ranks1..4; this implementation deliberately chooses DDF.
//! Brief slow on locally supported targets: TestGrounds2026 reconstruction, not recovered2014 server code.
//! No W/E/R, particles, audio or native reset/timing parity is claimed.
use crate::*;
use std::sync::OnceLock;

pub const ARM_TICKS: u64 = 8 * TICK_RATE; // RECONSTRUCTION, not a recovered arm duration.
pub const AD_TICKS: u64 = 8 * TICK_RATE; // Native tooltip duration; local tick conversion.
pub const LOSS_SLOTS: usize = 6; // Local participant bound, not a Riot constant.
// RECONSTRUCTION: TestGrounds35cf3aba, TrundleTrollSmash OnHit (2026).
// Native4.20 text says only "briefly slowing"; exact native parameters are unknown.
pub const BRIEF_SLOW_FRACTION: f32 = 0.75;
pub const BRIEF_SLOW_SECONDS: f32 = 0.1;
pub const BRIEF_SLOW_TAG: &str = "TrundleQBriefSlow";

#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
pub struct Loss { pub source: u32, pub amount: f32, pub until: u64 }
#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct State {
    pub armed_until: u64,
    pub armed_rank: u8,
    pub buff_until: u64,
    pub buff_rank: u8,
    pub losses: [Option<Loss>; LOSS_SLOTS],
}
#[derive(Debug, Clone, Copy)]
pub struct Rank {
    pub cost: f32,
    pub cooldown: f32,
    pub base: f32,
    pub bonus_ad: f32,
    pub ad_coefficient: f32,
}
fn number(values: &serde_json::Value, key: &str) -> Result<f32, String> {
    let value=values.get(key).ok_or_else(||format!("Trundle Q native field absent: {key}"))?;
    let value=if let Some(n)=value.as_f64() {n as f32}
        else if let Some(s)=value.as_str() {s.parse::<f32>().map_err(|_|format!("Trundle Q native number invalid: {key}"))?}
        else {return Err(format!("Trundle Q native field not numeric: {key}"));};
    if !value.is_finite() {return Err(format!("Trundle Q native number nonfinite: {key}"));}
    Ok(value)
}
fn parse(text: &str) -> Result<[Rank;5], String> {
    let rows:serde_json::Value=serde_json::from_str(text).map_err(|e|e.to_string())?;
    let rows=rows.as_array().ok_or("Trundle Q native table is not an array")?;
    let rows:Vec<_>=rows.iter().filter(|r|r["champion"].as_str().is_some_and(|c|c.eq_ignore_ascii_case("trundle")) && r["slot"].as_u64()==Some(0)).collect();
    if rows.len()!=1 || rows[0]["spell"]!="TrundleTrollSmash" {return Err("unique native Trundle Q resource required".into());}
    let values=&rows[0]["values"];let mut result=Vec::with_capacity(5);
    for index in 0..5 {
        let rank=index+1;
        let expected=[30.,4.,[20.,40.,60.,80.,100.][index],[20.,25.,30.,35.,40.][index],300.,[100.,105.,110.,115.,120.][index]];
        let keys=[format!("ManaCost{rank}"),format!("Cooldown{rank}"),format!("Effect1Level{rank}Amount"),format!("Effect2Level{rank}Amount"),format!("CastRange{rank}"),format!("Effect3Level{rank}Amount")];
        let mut actual=[0f32;6];
        for i in 0..keys.len() {actual[i]=number(values,&keys[i])?;if actual[i]!=expected[i] {return Err(format!("Trundle Q exact verified contract changed: {}",keys[i]));}}
        result.push(Rank {cost:actual[0],cooldown:actual[1],base:actual[2],bonus_ad:actual[3],
            // Explicit reconstructed gameplay choice from native Trundle.ddf f1.
            ad_coefficient:[0.8,0.9,1.0,1.1,1.2][index]});
    }
    result.try_into().map_err(|_|"Trundle Q requires five verified ranks".into())
}
pub fn rules(rank: u8) -> Result<Rank, String> {
    if !(1..=5).contains(&rank) {return Err("Trundle Q rank out of range".into());}
    static RULES:OnceLock<Result<[Rank;5],String>>=OnceLock::new();
    RULES.get_or_init(||parse(include_str!("../../../data/4.20/native_spells_420.json")))
        .as_ref().map(|r|r[rank as usize-1]).map_err(Clone::clone)
}
pub fn attack_rank(p:&Champion,tick:u64)->Option<u8> {
    let state=&p.effects.trundle_q;
    (p.champion=="trundle" && p.health.is_finite() && p.health>0.
        && tick<state.armed_until && (1..=5).contains(&state.armed_rank)
        && (state.armed_rank..=5).contains(&p.ranks[0])).then_some(state.armed_rank)
}
pub fn armed(p:&Champion,tick:u64)->bool {attack_rank(p,tick).is_some()}
impl Simulation {
    pub(crate) fn cast_trundle_q(&mut self,id:u32,slot:u8,target:Option<u32>)->Result<(),String> {
        if self.winner.is_some() {return Err("match ended".into());}
        if slot!=0 {return Err("Trundle W/E/R not implemented".into());}
        if target.is_some() {return Err("Trundle Q is a self arming command".into());}
        let p=self.players.get(&id).ok_or("unknown player")?;
        if p.champion!="trundle" {return Err("Trundle Q requires Trundle".into());}
        if !p.health.is_finite() || p.health<=0. {return Err("champion dead".into());}
        if stuns::active(p,self.tick) {return Err("champion stunned".into());}
        if self.tick<p.effects.silence_until {return Err("champion silenced".into());}
        let rank=p.ranks[0];let q=rules(rank)?;
        if self.tick<p.cooldowns[0] {return Err("skill on cooldown".into());}
        if !p.mana.is_finite() || p.mana<q.cost {return Err("insufficient mana".into());}
        if p.windup.as_ref().is_some_and(|w|!w.cancelable) {return Err("attack windup cannot be cancelled".into());}
        let reduction=self.stats(id).cooldown_reduction;
        if !reduction.is_finite() {return Err("invalid cooldown reduction".into());}
        let cd=cooldown::ticks(q.cooldown,reduction);
        let ready=self.tick.checked_add(cd).ok_or("Trundle Q cooldown clock overflow")?;
        let until=self.tick.checked_add(ARM_TICKS).ok_or("Trundle Q arm clock overflow")?;
        // Everything above is read-only. Rejected commands cannot spend/reset/cancel.
        self.cancel_attack_presentation(id,attack_presentation::CancelReason::OtherCast);
        let p=self.players.get_mut(&id).unwrap();
        p.mana-=q.cost;p.cooldowns[0]=ready;p.cooldown_totals[0]=Some(cd);
        // RECONSTRUCTION: accepted reset discards even a pre-existing ordinary
        // cached roll. Rejection above preserves it; Q never stores a fake false
        // roll. This changes only Trundle Q, not generic anti-reroll controls.
        p.windup=None;p.attack_roll=None;p.next_attack=self.tick;
        p.effects.trundle_q.armed_until=until;p.effects.trundle_q.armed_rank=rank;
        Ok(())
    }
    pub(crate) fn trundle_q_ad_adjustment(&self,id:u32)->f32 {
        let Some(p)=self.players.get(&id) else{return 0.};
        if !p.health.is_finite() || p.health<=0. {return 0.;}
        let state=&p.effects.trundle_q;
        let gain=if p.champion=="trundle" && self.tick<state.buff_until && (1..=5).contains(&state.buff_rank) {
            // A successful cast already validated this immutable embedded table.
            // Invalid state has no buff; missing native data is never a new value.
            rules(state.buff_rank).expect("live Q buff rank validated by its cast").bonus_ad
        }else{0.};
        let mut seen=std::collections::BTreeSet::new();
        let loss:f32=state.losses.iter().flatten().filter(|entry| {
            entry.until>self.tick && entry.amount.is_finite() && entry.amount>0. && entry.amount<=20.
                && entry.source!=id && self.players.get(&entry.source).is_some_and(|source|source.champion=="trundle"&&source.team!=p.team)
                && seen.insert(entry.source)
        }).map(|entry|entry.amount).sum();
        gain-loss
    }
    pub(crate) fn trundle_q_attack_hit(&mut self,source:u32,target:u32,raw:f32,rank:u8)->Result<damage::DamageOutcome,String> {
        let p=self.players.get(&source).ok_or("unknown Trundle Q source")?;
        if attack_rank(p,self.tick)!=Some(rank) {return Err("Trundle Q is not armed for this rank".into());}
        let q=rules(rank)?;let enemy=self.target_info(target).ok_or("unknown attack target")?;
        let distance=p.position.distance(enemy.position);
        if !enemy.health.is_finite() || enemy.health<=0. || p.team==enemy.team || self.protected(target)
            || !self.visible_to(p.team,target) || !distance.is_finite()
            || distance>self.definitions[&p.champion].attack_range+enemy.radius {
            return Err("invalid Trundle Q attack target".into());
        }
        let expected=q.base+q.ad_coefficient*self.stats(source).damage;
        if !raw.is_finite() || raw<0. || raw.to_bits()!=expected.to_bits() {return Err("Trundle Q raw damage differs from its reconstructed contract".into());}
        let until=self.tick.checked_add(AD_TICKS).ok_or("Trundle Q modifier clock overflow")?;
        let slow_ticks=spells::seconds(BRIEF_SLOW_SECONDS);
        // Reserve an existing/expired/departed-owner slot BEFORE doing damage.
        let slot=if let Some(victim)=self.players.get(&target) {
            let entries=&victim.effects.trundle_q.losses;
            Some(entries.iter().position(|entry|entry.is_some_and(|entry|entry.source==source))
                .or_else(||entries.iter().position(|entry|entry.is_none_or(|entry|entry.until<=self.tick || !self.players.contains_key(&entry.source))))
                .ok_or("Trundle Q AD-loss capacity exhausted")?)
        }else{None};
        // Preflight every supported slow BEFORE damage. Other target kinds retain
        // their existing damage path, without claiming native slow immunity.
        let slow=if self.players.contains_key(&target)||self.npc_slow_supported(target) {
            Some(self.prepare_slow(target,BRIEF_SLOW_TAG,BRIEF_SLOW_FRACTION,slow_ticks)?)
        } else {None};
        // Common physical damage, shields, retaliation, kill credit and lifesteal ONCE.
        let outcome=self.basic_attack_hit(source,target,raw)?;
        if let Some(p)=self.players.get_mut(&source).filter(|p|p.health>0.) {
            let state=&mut p.effects.trundle_q;
            state.armed_until=0;state.armed_rank=0;
            state.buff_rank=rank;state.buff_until=until;
        }
        if let Some(index)=slot {
            if let Some(p)=self.players.get_mut(&target).filter(|p|p.health>0.) {
                p.effects.trundle_q.losses[index]=Some(Loss{source,amount:q.bonus_ad*0.5,until});
            }
        }
        // The hit may kill the target, or retaliation may kill the source.
        // Commit only to the surviving preflighted identity, with no fallible
        // admission or unexpected panic after accepted damage. Shielded hits qualify.
        if let Some(event)=slow {self.commit_slow_for_surviving_target(event);}
        // advance_allied_motion already ran this tick. A three-tick interval
        // [impact,impact+3) affects movement at impact+1,+2, never retroactively.
        Ok(outcome)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use attack_presentation::{Kind,Phase,CancelReason};
    fn game()->(Simulation,u32,u32) {
        let mut bytes=Vec::new();for _ in 0..400 {bytes.extend(0f32.to_le_bytes());bytes.extend(0u16.to_le_bytes());bytes.extend(0u32.to_le_bytes());bytes.push(1);}
        let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,&bytes).unwrap();
        let mut s=Simulation::new(nav).unwrap();let a=s.join("trundle").unwrap();let b=s.join("garen").unwrap();
        for(id,x)in[(a,100.),(b,150.)] {let p=s.players.get_mut(&id).unwrap();p.position=Point{x,z:100.};p.health=10000.;p.max_health=10000.;}
        s.players.get_mut(&a).unwrap().ranks[0]=1;(s,a,b)
    }
    fn raw(s:&Simulation,a:u32)->f32 {let q=rules(s.players[&a].effects.trundle_q.armed_rank).unwrap();q.base+q.ad_coefficient*s.stats(a).damage}
    fn release(s:&mut Simulation,a:u32,b:u32) {
        s.command(a,Action::Attack{target:b}).unwrap();s.tick+=1;s.advance_attacks();
        s.tick=s.players[&a].windup.as_ref().unwrap().release;s.advance_attacks();
    }
    #[test]fn verified_five_ranks_and_conflicting_data_are_strict_not_fallback() {
        for rank in 1..=5 {let q=rules(rank).unwrap();assert_eq!(q.cost,30.);assert_eq!(q.cooldown,4.);assert_eq!(q.base,20.*rank as f32);assert_eq!(q.bonus_ad,15.+5.*rank as f32);assert_eq!(q.ad_coefficient,[0.8,0.9,1.,1.1,1.2][rank as usize-1]);}
        for rank in[0,6,255] {assert!(rules(rank).is_err());}
        let original=include_str!("../../../data/4.20/native_spells_420.json");let mut value:serde_json::Value=serde_json::from_str(original).unwrap();
        let row=value.as_array_mut().unwrap().iter_mut().find(|r|r["champion"].as_str().is_some_and(|c|c.eq_ignore_ascii_case("trundle"))&&r["slot"]==0).unwrap();row["values"]["ManaCost1"]=serde_json::Value::Null;
        assert!(parse(&value.to_string()).is_err());assert!(parse("[]").is_err());
    }
    #[test]fn rejected_commands_are_atomic_and_q_w_progression_is_admitted() {
        let(mut s,a,_)=game();s.players.get_mut(&a).unwrap().ranks=[0;4];
        s.players.get_mut(&a).unwrap().level=2;assert!(s.learn(a,0).is_ok());assert!(s.learn(a,1).is_ok());for slot in 2..4 {assert!(s.learn(a,slot).is_err());}
        for case in 0..8 {
            let(mut g,a,_)=game();let mut slot=0;let mut target=None;
            match case {0=>slot=1,1=>target=Some(a),2=>g.players.get_mut(&a).unwrap().mana=29.,3=>g.players.get_mut(&a).unwrap().effects.silence_until=1,4=>g.players.get_mut(&a).unwrap().cooldowns[0]=1,5=>g.players.get_mut(&a).unwrap().ranks[0]=0,6=>g.players.get_mut(&a).unwrap().health=0.,_=>g.players.get_mut(&a).unwrap().mana=f32::NAN}
            let before=serde_json::to_value(&g.players[&a]).unwrap();let events=g.snapshot().attack_events;
            assert!(g.cast(a,slot,target).is_err());assert_eq!(serde_json::to_value(&g.players[&a]).unwrap(),before);assert_eq!(g.snapshot().attack_events,events);
        }
    }
    #[test]fn accepted_reset_closes_identity_once_and_next_attack_is_trundle_not_garen() {
        let(mut s,a,b)=game();s.command(a,Action::Attack{target:b}).unwrap();s.tick=1;s.advance_attacks();let old=s.players[&a].windup.as_ref().unwrap().presentation.unwrap();
        let mana=s.players[&a].mana;s.cast(a,0,None).unwrap();assert_eq!(s.players[&a].mana,mana-30.);assert_eq!(s.players[&a].next_attack,s.tick);
        assert_eq!(s.snapshot().attack_events.iter().filter(|e|e.attack==old&&matches!(e.phase,Phase::Cancelled{reason:CancelReason::OtherCast})).count(),1);
        s.tick+=1;s.advance_attacks();let new=s.players[&a].windup.as_ref().unwrap().presentation.unwrap();assert_ne!(new.id,old.id);
        assert!(s.snapshot().attack_events.iter().any(|e|e.attack==new&&matches!(e.phase,Phase::Started{kind:Kind::TrundleQ})));assert!(s.attack_presentation_error.is_none());
    }
    #[test]fn reconstructed_hit_replaces_normal_ad_once_and_applies_modifiers_afterward() {
        for rank in 1..=5 {let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().ranks[0]=rank;s.cast(a,0,None).unwrap();
            let before=s.stats(a).damage;let target=s.stats(b).damage;let hp=s.players[&b].health;let expected=damage::mitigate(raw(&s,a),damage::DamageKind::Physical,s.stats(b).armor,s.stats(b).magic_resist,1.).unwrap();
            release(&mut s,a,b);assert!((hp-s.players[&b].health-expected).abs()<0.001);assert!(!armed(&s.players[&a],s.tick));
            assert!((s.stats(a).damage-before-rules(rank).unwrap().bonus_ad).abs()<0.001);assert!((target-s.stats(b).damage-rules(rank).unwrap().bonus_ad*0.5).abs()<0.001);
            assert!(s.snapshot().attack_events.iter().any(|e|matches!(e.phase,Phase::Resolved{kind:Kind::TrundleQ,hit_succeeded:true})));}
    }
    #[test]fn deadline_refresh_and_no_permanent_stat_subtraction() {
        let(mut s,a,b)=game();let source_base=s.stats(a).damage;let target_base=s.stats(b).damage;s.cast(a,0,None).unwrap();let damage=raw(&s,a);s.trundle_q_attack_hit(a,b,damage,1).unwrap();
        let first_until=s.players[&a].effects.trundle_q.buff_until;s.tick=120;s.cast(a,0,None).unwrap();let damage=raw(&s,a);s.trundle_q_attack_hit(a,b,damage,1).unwrap();
        assert_eq!(s.players[&b].effects.trundle_q.losses.iter().flatten().count(),1);assert_eq!(s.stats(a).damage,source_base+20.);assert_eq!(s.stats(b).damage,target_base-10.);
        let until=s.players[&a].effects.trundle_q.buff_until;assert!(until>first_until);s.tick=until-1;assert_eq!(s.stats(a).damage,source_base+20.);s.tick=until;assert_eq!(s.stats(a).damage,source_base);assert_eq!(s.stats(b).damage,target_base);
    }
    #[test]fn shielded_success_consumes_and_uses_common_lifesteal_with_reconstructed_slow() {
        let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().inventory[0]=Some(1053);s.players.get_mut(&a).unwrap().health=100.;s.cast(a,0,None).unwrap();
        s.grant_shield(b,"fixture",10000.,300).unwrap();let before=s.players[&a].health;let damage=raw(&s,a);let out=s.trundle_q_attack_hit(a,b,damage,1).unwrap();
        assert_eq!(out.health_removed,0.);assert!(s.players[&a].health>before);assert!(!armed(&s.players[&a],s.tick));
        assert_eq!(s.players[&b].slows.len(),1);let slow=&s.players[&b].slows[0];
        assert_eq!((slow.tag.as_str(),slow.fraction,slow.expires_at),(BRIEF_SLOW_TAG,0.75,s.tick+3));
        assert!(s.trundle_q_attack_hit(a,b,damage,1).is_err());
    }
    #[test]fn invalid_hit_does_not_consume_and_fixed_loss_storage_is_bounded() {
        let(mut s,a,b)=game();s.cast(a,0,None).unwrap();let damage=raw(&s,a);let hp=s.players[&b].health;
        assert!(s.trundle_q_attack_hit(a,a,damage,1).is_err());assert!(armed(&s.players[&a],s.tick));assert_eq!(s.players[&b].health,hp);
        for entry in &mut s.players.get_mut(&b).unwrap().effects.trundle_q.losses {*entry=Some(Loss{source:b,amount:1.,until:1000});}
        assert_eq!(s.players[&b].effects.trundle_q.losses.len(),6);assert!(s.trundle_q_attack_hit(a,b,damage,1).is_err());assert_eq!(s.players[&b].health,hp);assert!(armed(&s.players[&a],s.tick));
    }
    #[test]fn arm_expiry_stop_and_death_preserve_explicit_local_policies() {
        let(mut s,a,b)=game();s.cast(a,0,None).unwrap();s.command(a,Action::Stop).unwrap();assert!(armed(&s.players[&a],s.tick));
        s.tick=ARM_TICKS;assert!(!armed(&s.players[&a],s.tick));s.cast(a,0,None).unwrap();
        s.apply_damage(Some(b),a,100000.,damage::DamageKind::True).unwrap();assert!(!armed(&s.players[&a],s.tick));assert_eq!(s.players[&a].effects.trundle_q.armed_until,0);
    }
    #[test]fn uncancellable_control_ended_and_overflow_rejections_do_not_cancel_or_reset() {
        for case in 0..4 {
            let(mut s,a,b)=game();s.command(a,Action::Attack{target:b}).unwrap();s.tick=1;s.advance_attacks();
            match case {0=>s.players.get_mut(&a).unwrap().windup.as_mut().unwrap().cancelable=false,
                1=>s.grant_stun(Some(b),a,"fixture",30).unwrap(),2=>s.winner=Some(0),_=>s.tick=u64::MAX-1}
            let before=serde_json::to_value(&s.players[&a]).unwrap();let events=s.snapshot().attack_events;
            assert!(s.cast(a,0,None).is_err());assert_eq!(serde_json::to_value(&s.players[&a]).unwrap(),before);assert_eq!(s.snapshot().attack_events,events);
        }
    }
    #[test]fn q_suppresses_only_its_own_critical_roll_then_next_basic_uses_normal_kind() {
        let(mut s,a,b)=game();s.cast(a,0,None).unwrap();s.players.get_mut(&a).unwrap().attack_roll=Some(true);
        let rng=s.critical_rng;release(&mut s,a,b);assert_eq!(s.critical_rng,rng);
        let events=s.snapshot().attack_events;
        assert!(events.iter().any(|e|matches!(e.phase,Phase::Started{kind:Kind::TrundleQ})));
        assert!(!events.iter().any(|e|matches!(e.phase,Phase::Started{kind:Kind::Critical})));
        s.tick=s.players[&a].next_attack;s.players.get_mut(&a).unwrap().attack_roll=Some(true);
        let hp=s.players[&b].health;let stats=s.stats(a);
        let expected=damage::mitigate(stats.damage*stats.critical_multiplier,damage::DamageKind::Physical,s.stats(b).armor,s.stats(b).magic_resist,1.).unwrap();
        release(&mut s,a,b);
        assert!((hp-s.players[&b].health-expected).abs()<0.001);
        assert!(s.snapshot().attack_events.iter().any(|e|matches!(e.phase,Phase::Resolved{kind:Kind::Critical,hit_succeeded:true})));
        assert!(s.attack_presentation_error.is_none());
    }
    #[test]fn cancelled_q_expiry_does_not_cache_a_forced_noncritical_normal_attack() {
        // Both fixtures use actually implemented items. 3031 is absent from the
        // current shop catalog and is ignored by shop::bonuses; it cannot provide
        // a guaranteed critical chance. Exercise real fractional draws instead.
        for copies in[1usize,6] {
            let(mut s,a,b)=game();let mut inventory=[None;6];inventory[..copies].fill(Some(1018));
            assert!(inventory.iter().flatten().all(|id|shop::catalog().iter().any(|item|item.id==*id)));
            s.players.get_mut(&a).unwrap().inventory=inventory;
            let chance=s.stats(a).critical_chance;assert!(chance>0.&&chance<1.);
            s.cast(a,0,None).unwrap();s.command(a,Action::Attack{target:b}).unwrap();s.tick=1;s.advance_attacks();
            assert!(!s.players[&a].windup.as_ref().unwrap().critical);assert!(s.players[&a].attack_roll.is_none());assert_eq!(s.critical_rng,0);
            s.command(a,Action::Stop).unwrap();s.tick=s.players[&a].effects.trundle_q.armed_until;
            s.command(a,Action::Attack{target:b}).unwrap();s.advance_attacks();
            let windup=s.players[&a].windup.as_ref().unwrap();assert_ne!(s.critical_rng,0);
            assert_eq!(s.players[&a].attack_roll,Some(windup.critical));
        }
    }
    #[test]fn separate_trundle_sources_stack_refresh_and_depart_without_permanent_loss() {
        let(mut s,a,b)=game();let c=s.join("trundle").unwrap();
        let p=s.players.get_mut(&c).unwrap();p.position=Point{x:100.,z:100.};p.ranks[0]=1;
        let base=s.stats(b).damage;
        for source in[a,c] {s.cast(source,0,None).unwrap();let damage=raw(&s,source);s.trundle_q_attack_hit(source,b,damage,1).unwrap();}
        assert!((s.stats(b).damage-(base-20.)).abs()<0.001);assert_eq!(s.players[&b].effects.trundle_q.losses.iter().flatten().count(),2);
        s.apply_damage(Some(b),a,100000.,damage::DamageKind::True).unwrap();
        assert!((s.stats(b).damage-(base-20.)).abs()<0.001); // Chosen: persists through source death.
        assert!(s.remove_player(a).is_some());assert!((s.stats(b).damage-(base-10.)).abs()<0.001);
        s.tick=AD_TICKS;assert_eq!(s.stats(b).damage,base);
    }
    #[test]fn lethal_target_and_lethal_retaliation_leave_no_stale_arm_or_repeated_buff() {
        let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().health=1.;s.cast(a,0,None).unwrap();let damage=raw(&s,a);
        assert!(s.trundle_q_attack_hit(a,b,damage,1).unwrap().lethal);assert_eq!(s.players[&b].health,0.);
        assert!(s.players[&b].effects.trundle_q.losses.iter().all(Option::is_none));assert!(!armed(&s.players[&a],s.tick));assert_eq!(s.players[&a].effects.trundle_q.buff_rank,1);
        let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().health=1.;
        // Explicit fixture for the existing Annie E retaliation path.
        let p=s.players.get_mut(&b).unwrap();p.champion="annie".into();p.effects.molten_rank=5;p.effects.molten_until=1000;
        s.cast(a,0,None).unwrap();let damage=raw(&s,a);s.trundle_q_attack_hit(a,b,damage,1).unwrap();
        assert_eq!(s.players[&a].health,0.);assert_eq!(s.players[&a].effects.trundle_q.armed_until,0);assert_eq!(s.players[&a].effects.trundle_q.buff_until,0);
        assert_eq!(s.players[&b].effects.trundle_q.losses.iter().flatten().count(),1);assert!(s.attack_presentation_error.is_none());
    }
    #[test]fn accepted_q_reset_discards_old_cache_while_rejection_and_other_champions_preserve_it() {
        for cache in[None,Some(true)] {
            let(mut s,a,_)=game();let p=s.players.get_mut(&a).unwrap();p.attack_roll=cache;p.cooldowns[0]=1;
            assert!(s.cast(a,0,None).is_err());assert_eq!(s.players[&a].attack_roll,cache);
            s.tick=1;s.cast(a,0,None).unwrap();assert_eq!(s.players[&a].attack_roll,None);
            s.command(a,Action::Stop).unwrap();assert_eq!(s.players[&a].attack_roll,None);
            s.tick=s.players[&a].effects.trundle_q.armed_until;assert!(!armed(&s.players[&a],s.tick));assert_eq!(s.players[&a].attack_roll,None);
        }
        for champion in["garen","annie","ashe"] {
            let(mut s,a,b)=game();let p=s.players.get_mut(&a).unwrap();p.champion=champion.into();p.attack_roll=Some(true);
            let result=s.cast(a,0,if champion=="annie" {Some(b)}else{None});
            assert_eq!(result.is_ok(),champion!="ashe");assert_eq!(s.players[&a].attack_roll,Some(true));
        }
    }

    #[test]fn reconstructed_brief_slow_starts_at_accepted_impact_not_arm_or_windup() {
        let(mut s,a,b)=game();s.cast(a,0,None).unwrap();assert!(s.players[&b].slows.is_empty());
        s.command(a,Action::Attack{target:b}).unwrap();s.tick=1;s.advance_attacks();
        let impact=s.players[&a].windup.as_ref().unwrap().release;assert!(impact>s.tick);
        s.tick=impact-1;s.advance_attacks();assert!(s.players[&b].slows.is_empty());
        s.tick=impact;s.advance_attacks();let slow=&s.players[&b].slows[0];
        assert_eq!(spells::seconds(BRIEF_SLOW_SECONDS),3);
        assert_eq!((slow.tag.as_str(),slow.fraction,slow.expires_at),(BRIEF_SLOW_TAG,0.75,impact+3));
        assert_eq!(slows::strongest(&s.players[&b],impact),0.75);
        s.tick=impact+2;assert_eq!(slows::strongest(&s.players[&b],s.tick),0.75);
        s.tick=impact+3;s.advance_slows();assert!(s.players[&b].slows.is_empty());
    }

    #[test]fn reconstructed_three_tick_window_respects_existing_motion_before_attack_phase() {
        let(mut s,a,b)=game();s.cast(a,0,None).unwrap();s.command(a,Action::Attack{target:b}).unwrap();
        s.tick=1;s.advance_attacks();let impact=s.players[&a].windup.as_ref().unwrap().release;
        s.command(b,Action::Move{point:Point{x:500.,z:100.}}).unwrap();s.tick=impact-1;
        let normal=s.movement_speed(b);let before=s.players[&b].position;s.advance();
        assert_eq!(s.tick,impact);assert!((before.distance(s.players[&b].position)-normal/TICK_RATE as f32).abs()<0.001);
        let reduced=s.movement_speed(b);assert!(reduced>0.&&reduced<normal);
        assert_eq!(s.players[&b].slows[0].expires_at,impact+3);
        for expected in [impact+1,impact+2] {
            let before=s.players[&b].position;s.advance();assert_eq!(s.tick,expected);
            assert!((before.distance(s.players[&b].position)-reduced/TICK_RATE as f32).abs()<0.001);
        }
        let before=s.players[&b].position;s.advance();assert_eq!(s.tick,impact+3);
        assert!(s.players[&b].slows.is_empty());
        assert!((before.distance(s.players[&b].position)-normal/TICK_RATE as f32).abs()<0.001);
    }

    #[test]fn reconstructed_slow_reuses_tag_refresh_strongest_and_garen_q_purge() {
        let(mut s,a,b)=game();let c=s.join("trundle").unwrap();
        let p=s.players.get_mut(&c).unwrap();p.position=Point{x:100.,z:100.};p.ranks[0]=1;
        s.grant_slow(b,"other",0.2,30).unwrap();s.cast(a,0,None).unwrap();let damage=raw(&s,a);
        s.trundle_q_attack_hit(a,b,damage,1).unwrap();s.tick=1;
        s.cast(c,0,None).unwrap();let damage=raw(&s,c);s.trundle_q_attack_hit(c,b,damage,1).unwrap();
        assert_eq!(s.players[&b].slows.iter().filter(|slow|slow.tag==BRIEF_SLOW_TAG).count(),1);
        assert_eq!(s.players[&b].slows.iter().find(|slow|slow.tag==BRIEF_SLOW_TAG).unwrap().expires_at,4);
        assert_eq!(s.players[&b].slows.len(),2);assert_eq!(slows::strongest(&s.players[&b],s.tick),0.75);
        // Purge while the Q slow is still active, not only after its expiry.
        s.learn(b,0).unwrap();s.cast(b,0,None).unwrap();assert!(s.players[&b].slows.is_empty());
        assert_eq!(s.players[&b].effects.trundle_q.losses.iter().flatten().count(),2);
        let(mut s,a,b)=game();s.grant_slow(b,"other",0.2,30).unwrap();
        s.cast(a,0,None).unwrap();let damage=raw(&s,a);s.trundle_q_attack_hit(a,b,damage,1).unwrap();
        s.tick=3;s.advance_slows();assert_eq!(slows::strongest(&s.players[&b],s.tick),0.2);
        assert_eq!(s.players[&b].slows.len(),1);assert_eq!(s.players[&b].slows[0].tag,"other");
    }

    #[test]fn reconstructed_short_slow_uses_existing_courage_ceil_without_extra_reduction() {
        let(mut s,a,b)=game();s.learn(b,1).unwrap();s.cast(b,1,None).unwrap();
        assert!(s.tick<s.players[&b].effects.courage_until);s.cast(a,0,None).unwrap();
        let damage=raw(&s,a);s.trundle_q_attack_hit(a,b,damage,1).unwrap();
        assert_eq!(spells::control_duration(&s.players[&b],s.tick,3),3);
        assert_eq!(s.players[&b].slows[0].expires_at,s.tick+3);
        s.tick=2;s.advance_slows();assert_eq!(s.players[&b].slows[0].expires_at,3);
        s.tick=3;s.advance_slows();assert!(s.players[&b].slows.is_empty());
    }

    #[test]fn rejected_or_late_reconstructed_q_hit_does_not_create_slow_or_mutate_players() {
        for case in 0..7 {
            let(mut s,a,b)=game();s.cast(a,0,None).unwrap();let mut target=b;let mut damage=raw(&s,a);
            match case {
                0=>target=a,1=>s.players.get_mut(&b).unwrap().health=0.,
                2=>s.players.get_mut(&b).unwrap().position=Point{x:800.,z:100.},
                3=>damage+=1.,4=>s.tick=ARM_TICKS,5=>s.winner=Some(0),_=>target=u32::MAX,
            }
            let before=serde_json::to_value(&s.players).unwrap();
            assert!(s.trundle_q_attack_hit(a,target,damage,1).is_err());
            assert_eq!(serde_json::to_value(&s.players).unwrap(),before);
            assert!(s.players.values().all(|p|p.slows.is_empty()));
        }
    }

    #[test]fn reconstructed_slow_omits_lethal_target_but_survives_source_retaliation_death() {
        let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().health=1.;s.cast(a,0,None).unwrap();
        let damage=raw(&s,a);assert!(s.trundle_q_attack_hit(a,b,damage,1).unwrap().lethal);
        assert!(s.players[&b].slows.is_empty());
        let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().health=1.;
        let p=s.players.get_mut(&b).unwrap();p.champion="annie".into();p.effects.molten_rank=5;p.effects.molten_until=1000;
        s.cast(a,0,None).unwrap();let damage=raw(&s,a);s.trundle_q_attack_hit(a,b,damage,1).unwrap();
        assert_eq!(s.players[&a].health,0.);assert!(s.players[&b].health>0.);
        assert_eq!(s.players[&b].slows.len(),1);assert_eq!(s.players[&b].slows[0].tag,BRIEF_SLOW_TAG);
    }

    #[test]fn reconstructed_q_slow_supports_map_npc_and_preserves_structure_damage() {
        for kind in [world::Kind::Melee,world::Kind::Turret] {
            let(mut s,a,b)=game();s.enable_map10().unwrap();
            let definition=s.world.as_ref().unwrap().config.definitions.iter()
                .find(|(_,d)|d.kind==kind).map(|(name,_)|name.clone()).unwrap();
            let target=s.spawn_unit(&definition,"trundle_q_slow_scope_fixture",1,Point{x:150.,z:100.},0.,0.,None,None).unwrap();
            let u=s.units.get_mut(&target).unwrap();u.health=10000.;u.max_health=10000.;
            assert!(!s.players.contains_key(&target));assert!(!s.protected(target));
            s.cast(a,0,None).unwrap();let damage=raw(&s,a);let hp=s.units[&target].health;
            assert!(s.trundle_q_attack_hit(a,target,damage,1).is_ok());
            assert!(s.units[&target].health<hp);assert!(!armed(&s.players[&a],s.tick));
            assert!(s.players[&a].slows.is_empty()&&s.players[&b].slows.is_empty());
            if kind==world::Kind::Melee {assert_eq!(s.units[&target].slows.len(),1);assert_eq!(s.units[&target].slows[0].tag,BRIEF_SLOW_TAG);}
            else {assert!(s.units[&target].slows.is_empty());}
        }
    }
}
