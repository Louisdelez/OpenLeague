//! Observations of current shield and same-tick call boundaries.
//! These tests explicitly do not qualify native typed shields or a total event ordering.
use openleague_core::{damage::{self,DamageKind},Navigation,Simulation};
fn game() -> (Simulation,u32) {
    let nav=Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
    let mut s=Simulation::new(nav).unwrap();let id=s.join("garen").unwrap();(s,id)
}
fn close(a:f32,b:f32){assert!((a-b).abs()<0.001,"{a} != {b}");}
#[test]
fn current_general_shield_absorbs_every_damage_category() {
    for kind in [DamageKind::Physical,DamageKind::Magical,DamageKind::True] {
        let(mut s,id)=game();s.grant_shield(id,"observation",500.,60).unwrap();
        let hp=s.players[&id].health;let stats=s.stats(id);
        let expected=damage::mitigate(100.,kind,stats.armor,stats.magic_resist,1.).unwrap();
        let e=s.apply_damage(None,id,100.,kind).unwrap();
        close(e.post_mitigation,expected);close(e.shield_absorbed,expected);close(e.health_removed,0.);
        close(s.players[&id].health,hp);close(s.players[&id].shields[0].remaining,500.-expected);
        println!("OBSERVATION {}",serde_json::json!({"case":"general_shield_category","event":e,"tick":s.tick,"remaining":s.players[&id].shields[0].remaining}));
    }
}
#[test]
fn same_tick_damage_is_consumed_in_call_order_not_sorted_by_amount() {
    let mut records=vec![];
    for amounts in [[75.,80.],[80.,75.]] {
        let(mut s,id)=game();s.grant_shield(id,"observation",50.,60).unwrap();let tick=s.tick;let hp=s.players[&id].health;
        let first=s.apply_damage(None,id,amounts[0],DamageKind::True).unwrap();
        let second=s.apply_damage(None,id,amounts[1],DamageKind::True).unwrap();
        close(first.shield_absorbed,50.);close(first.health_removed,amounts[0]-50.);
        close(second.shield_absorbed,0.);close(second.health_removed,amounts[1]);
        close(hp-s.players[&id].health,105.);assert_eq!(s.tick,tick);
        records.push(serde_json::json!({"case":"same_tick_call_order","amounts":amounts,"first":first,"second":second,"tick":s.tick,"health_removed":hp-s.players[&id].health}));
    }
    assert_ne!(records[0]["first"]["health_removed"],records[1]["first"]["health_removed"]);
    for record in records {println!("OBSERVATION {record}");}
}
#[test]
fn invalid_damage_preserves_shield_and_expired_shield_is_not_used() {
    let(mut s,id)=game();s.grant_shield(id,"observation",50.,60).unwrap();let before=serde_json::to_value(&s.players[&id]).unwrap();
    for amount in [f32::NAN,f32::INFINITY,-1.] {
        assert_eq!(s.apply_damage(None,id,amount,DamageKind::True).unwrap_err(),"invalid damage");
        assert_eq!(serde_json::to_value(&s.players[&id]).unwrap(),before);
    }
    s.tick=60;let e=s.apply_damage(None,id,20.,DamageKind::True).unwrap();
    close(e.shield_absorbed,0.);close(e.health_removed,20.);assert!(s.players[&id].shields.is_empty());
    println!("OBSERVATION {}",serde_json::json!({"case":"invalid_and_expired","invalid_inputs_refused":3,"event":e,"tick":s.tick}));
}
