use super::*;
fn game() -> (Simulation,u32,u32) {
    let mut bytes=Vec::new();for _ in 0..6400 {bytes.extend(0f32.to_le_bytes());bytes.extend(0u16.to_le_bytes());bytes.extend(0u32.to_le_bytes());bytes.push(1);}
    let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":80,"height":80}"#,&bytes).unwrap();
    let mut s=Simulation::new(nav).unwrap();s.session=420;let a=s.join("ezreal").unwrap();let b=s.join("garen").unwrap();
    for(id,x,team)in[(a,200.,0),(b,1000.,1)] {let p=s.players.get_mut(&id).unwrap();p.team=team;p.position=Point{x,z:300.};p.health=10000.;p.max_health=10000.;p.mana=2000.;p.level=6;}
    s.players.get_mut(&a).unwrap().ranks=[1,1,1,1];(s,a,b)
}
fn advance(s:&mut Simulation,tick:u64) {while s.tick<tick {s.tick+=1;s.prune_ezreal_passive();s.advance_ezreal_q();s.advance_ezreal_w();s.advance_ezreal_e();s.advance_ezreal_r();}}
fn aim(slot:u8)->Point {Point{x:if slot==2 {675.}else {3000.},z:300.}}
fn cast(s:&mut Simulation,a:u32,slot:u8) {s.command(a,Action::CastAt{slot,point:aim(slot)}).unwrap();}
fn grant(s:&mut Simulation,a:u32) {let team=s.players[&a].team;let session=s.session;s.accepted_ezreal_ability_contact(a,team,session);}

#[test]
fn actual_q_w_e_r_hits_and_fully_absorbed_hits_grant_once_but_rejected_damage_does_not() {
    for slot in 0..4 {
        for shielded in[false,true] {
            let(mut s,a,b)=game();if shielded {s.grant_shield(b,"passive fixture",10000.,100).unwrap();}
            cast(&mut s,a,slot);assert_eq!(s.ezreal_passive_stacks(a),0);advance(&mut s,60);
            assert_eq!(s.ezreal_passive_stacks(a),1);if shielded {assert_eq!(s.players[&b].health,10000.);}else {assert!(s.players[&b].health<10000.);}
            advance(&mut s,70);assert_eq!(s.ezreal_passive_stacks(a),1);assert_eq!(s.ezreal_passive_stacks(b),0);
        }
        let(mut s,a,b)=game();cast(&mut s,a,slot);
        if slot==0 {s.definitions.get_mut("garen").unwrap().armor=f32::NAN;}else {s.definitions.get_mut("garen").unwrap().magic_resist=f32::NAN;}
        advance(&mut s,60);assert_eq!(s.ezreal_passive_stacks(a),0);assert_eq!(s.players[&b].health,10000.);
    }
}

#[test]
fn real_allied_and_repositioned_self_w_buff_contacts_grant_the_caster_not_the_receiver() {
    let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().position.z=1500.;let ally=s.join("ezreal").unwrap();
    let p=s.players.get_mut(&ally).unwrap();p.team=0;p.position=Point{x:650.,z:300.};p.health=10000.;
    cast(&mut s,a,1);advance(&mut s,25);assert!(s.ezreal_w_attack_speed_bonus(ally)>0.);
    assert_eq!(s.ezreal_passive_stacks(a),1);assert_eq!(s.ezreal_passive_stacks(ally),0);
    let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().position.z=1500.;cast(&mut s,a,1);advance(&mut s,12);
    assert_eq!(s.ezreal_passive_stacks(a),0);assert_eq!(s.ezreal_w_attack_speed_bonus(a),0.);
    // Root-approved W self policy permits real fixture repositioning after arming.
    s.players.get_mut(&a).unwrap().position=Point{x:550.,z:300.};advance(&mut s,16);
    assert!(s.ezreal_w_attack_speed_bonus(a)>0.);assert_eq!(s.ezreal_passive_stacks(a),1);
    advance(&mut s,27);assert_eq!(s.ezreal_passive_stacks(a),1);
}

#[test]
fn shared_expiry_refresh_at_cap_and_expiry_before_same_tick_hit_do_not_accumulate_forever() {
    let(mut s,a,_)=game();for _ in 0..8 {grant(&mut s,a);}assert_eq!(s.ezreal_passive_stacks(a),5);
    s.tick=179;grant(&mut s,a);assert_eq!(s.ezreal_passive_stacks(a),5);
    s.tick=358;assert_eq!(s.ezreal_passive_stacks(a),5);
    s.tick=359;assert_eq!(s.ezreal_passive_stacks(a),0);grant(&mut s,a);assert_eq!(s.ezreal_passive_stacks(a),1);
    s.tick=539;s.prune_ezreal_passive();assert!(s.ezreal_passive.buffs.is_empty());assert_eq!(s.ezreal_passive_stacks(a),0);
}

#[test]
fn additive_passive_changes_real_new_aa_cadence_and_windup_without_retiming_existing_attacks() {
    let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().position.x=450.;s.players.get_mut(&a).unwrap().inventory[0]=Some(1042);
    let base=s.stats(a).attack_cooldown_ticks;s.command(a,Action::Attack{target:b}).unwrap();s.advance_attacks();
    let committed=s.players[&a].windup.clone().unwrap();let next=s.players[&a].next_attack;
    for _ in 0..5 {grant(&mut s,a);}let boosted=s.stats(a).attack_cooldown_ticks;assert!(boosted<base&&boosted>=12);
    assert_eq!(s.players[&a].windup.as_ref().unwrap().release,committed.release);assert_eq!(s.players[&a].next_attack,next);
    s.tick=committed.release;s.advance_attacks();assert_eq!(s.projectiles.len(),1);
    let aa=(s.projectiles[0].source,s.projectiles[0].target,s.projectiles[0].raw.to_bits(),s.projectiles[0].speed.to_bits());let old_x=s.projectiles[0].position.x;
    s.tick=next.max(committed.release+1);s.players.get_mut(&a).unwrap().next_attack=s.tick;s.advance_attacks();
    let started=s.players[&a].windup.as_ref().unwrap();assert_eq!(started.release-started.started,attacks::windup_ticks("ezreal",boosted).min(boosted));
    assert_eq!(s.players[&a].next_attack-s.tick,boosted);assert_eq!(s.projectiles.len(),1);
    assert_eq!((s.projectiles[0].source,s.projectiles[0].target,s.projectiles[0].raw.to_bits(),s.projectiles[0].speed.to_bits()),aa);
    assert!(s.projectiles[0].position.x>old_x); // Its ordinary motion continues.
    s.tick=180;s.prune_ezreal_passive();assert_eq!(s.stats(a).attack_cooldown_ticks,base);
}

#[test]
fn death_new_life_session_and_departure_cleanup_preserve_only_fresh_alive_owner_hits() {
    let(mut s,a,_)=game();grant(&mut s,a);s.players.get_mut(&a).unwrap().health=0.;assert_eq!(s.ezreal_passive_stacks(a),0);
    grant(&mut s,a);assert!(s.ezreal_passive.buffs.is_empty());s.players.get_mut(&a).unwrap().health=10000.;grant(&mut s,a);assert_eq!(s.ezreal_passive_stacks(a),1);
    s.session+=1;assert_eq!(s.ezreal_passive_stacks(a),0);grant(&mut s,a);assert_eq!(s.ezreal_passive_stacks(a),1);
    s.tick=20;s.prune_ezreal_passive();s.tick=19;assert_eq!(s.ezreal_passive_stacks(a),0);s.prune_ezreal_passive();assert!(s.ezreal_passive.buffs.is_empty());
    grant(&mut s,a);s.remove_player(a).unwrap();assert!(s.ezreal_passive.buffs.is_empty());
    // A released old-life spell may grant a fresh stack only if owner is alive
    // when contact is accepted: explicit local policy, no invented life token.
    let(mut s,a,b)=game();cast(&mut s,a,3);advance(&mut s,30);s.players.get_mut(&a).unwrap().health=0.;advance(&mut s,32);
    assert_eq!(s.ezreal_passive_stacks(a),0);s.players.get_mut(&a).unwrap().health=10000.;advance(&mut s,60);
    assert!(s.players[&b].health<10000.);assert_eq!(s.ezreal_passive_stacks(a),1);
}

#[test]
fn current_data_ad_split_preserves_total_bits_and_keeps_negative_bonus_until_final_r_clamp() {
    let(mut s,a,_)=game();
    for level in[1,6,18] {for item in[None,Some(1036),Some(3108)] {for altar in[1.,1.1] {for adjustment in[-200.,-10.,0.,35.] {
        let p=s.players.get_mut(&a).unwrap();p.level=level;p.inventory=[None;6];p.inventory[0]=item;
        let base=&s.definitions["ezreal"];let growth=&s.growth["ezreal"];let factor=progression::growth_total(level);let items=shop::bonuses(&s.players[&a]);
        let existing=(base.attack_damage+growth.damage*factor+items.damage)*altar;
        let expected=if adjustment==0. {existing}else{(existing+adjustment).max(0.)};
        let ad=progression::ad_components(base.attack_damage,growth.damage,factor,items.damage,altar,adjustment);
        assert_eq!(ad.total.to_bits(),expected.to_bits());assert_eq!(ad.level_base.to_bits(),(base.attack_damage+growth.damage*factor).to_bits());
        assert_eq!(ad.bonus.to_bits(),(expected-ad.level_base).to_bits());if expected==0. {assert_eq!(ad.bonus,-ad.level_base);}
    }}}}
    let ad=s.attack_damage_components(a).unwrap();assert_eq!(ad.total.to_bits(),s.stats(a).damage.to_bits());
}
use std::collections::BTreeSet;
#[test]
fn owner_passive_snapshot_is_owner_only_count_and_server_expiry_without_state_mutation() {
    let(mut s,a,b)=game();let ally=s.join("ezreal").unwrap();s.players.get_mut(&ally).unwrap().team=0;
    assert_eq!(s.snapshot_for(a).unwrap().ezreal_passive_self.unwrap().stacks,0);
    for _ in 0..8 {grant(&mut s,a);}
    let private=format!("{:?}",s.ezreal_passive);
    let own=s.snapshot_for(a).unwrap().ezreal_passive_self.unwrap();assert_eq!(own.stacks,5);
    assert_eq!(format!("{:?}",s.ezreal_passive),private);
    assert_eq!(s.snapshot_for(ally).unwrap().ezreal_passive_self.unwrap().owner,ally);
    assert_eq!(s.snapshot_for(ally).unwrap().ezreal_passive_self.unwrap().stacks,0);
    assert!(s.snapshot_for(b).unwrap().ezreal_passive_self.is_none());assert!(s.snapshot().ezreal_passive_self.is_none());
    let value=serde_json::to_value(own).unwrap();
    assert_eq!(value.as_object().unwrap().keys().map(String::as_str).collect::<BTreeSet<_>>(),BTreeSet::from(["session","owner","stacks"]));
    s.tick=STACK_TICKS;assert_eq!(s.snapshot_for(a).unwrap().ezreal_passive_self.unwrap().stacks,0);
    // Projection observes expiry without pruning or granting anything.
    assert_eq!(format!("{:?}",s.ezreal_passive),private);
}

#[test]
fn owner_passive_projection_clears_death_departure_end_and_session_and_rejects_wrong_identity() {
    let(mut s,a,_)=game();grant(&mut s,a);
    s.players.get_mut(&a).unwrap().health=0.;assert!(s.snapshot_for(a).unwrap().ezreal_passive_self.is_none());
    s.prune_ezreal_passive();s.players.get_mut(&a).unwrap().health=10000.;
    assert_eq!(s.snapshot_for(a).unwrap().ezreal_passive_self.unwrap().stacks,0);
    grant(&mut s,a);s.session+=1;assert_eq!(s.snapshot_for(a).unwrap().ezreal_passive_self.unwrap().stacks,0);
    s.winner=Some(0);assert!(s.snapshot_for(a).unwrap().ezreal_passive_self.is_none());s.winner=None;
    s.players.get_mut(&a).unwrap().team=2;assert!(s.ezreal_passive_self_projection(a).is_none());
    s.players.get_mut(&a).unwrap().team=0;s.players.get_mut(&a).unwrap().id=a+100;
    assert!(s.ezreal_passive_self_projection(a).is_none());s.players.get_mut(&a).unwrap().id=a;
    s.remove_player(a).unwrap();assert!(s.ezreal_passive_self_projection(a).is_none());
}

