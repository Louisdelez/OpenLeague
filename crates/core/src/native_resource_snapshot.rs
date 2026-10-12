//! Authoritative resource capacity replication, including compatibility with older snapshots.
#[cfg(test)] mod tests {
 use crate::*;
 fn simulation()->Simulation {let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let navigation=Navigation::load(&std::fs::read_to_string(root.join("assets/maps/tt_navigation_grid.json")).unwrap(),&std::fs::read(root.join("assets/maps/tt_navigation_grid.cells.bin")).unwrap()).unwrap();Simulation::new(navigation).unwrap()}
 #[test] fn snapshots_replicate_current_caps_after_growth_and_inventory_and_preserve_absent_unknown() {
  let mut sim=simulation();let a=sim.join("ahri").unwrap();let g=sim.join("garen").unwrap();let k=sim.join("akali").unwrap();
  for level in [1,9,18] {sim.players.get_mut(&a).unwrap().level=level;let snapshot=sim.snapshot();for player in &snapshot.players {assert_eq!(player.max_mana,Some(sim.stats(player.id).max_mana));}assert_eq!(snapshot.players.iter().find(|p|p.id==g).unwrap().max_mana,Some(0.0));assert_eq!(snapshot.players.iter().find(|p|p.id==k).unwrap().max_mana,Some(sim.stats(k).max_mana));}
  let before=sim.stats(a).max_mana;sim.players.get_mut(&a).unwrap().inventory[0]=Some(1027);assert!(sim.stats(a).max_mana>before);let snapshot=sim.snapshot();let player=snapshot.players.iter().find(|p|p.id==a).unwrap();assert_eq!(player.max_mana,Some(sim.stats(a).max_mana));
  let mut old=serde_json::to_value(player).unwrap();old.as_object_mut().unwrap().remove("max_mana");let old:Champion=serde_json::from_value(old).unwrap();assert_eq!(old.max_mana,None);
  let datagrams=wire::state_datagrams(&snapshot).unwrap();assert!(datagrams.iter().all(|d|d.len()<=1200));let mut assembler=wire::StateAssembler::default();let mut rebuilt=None;for d in datagrams {if let Some(bytes)=assembler.push(&d,Some(snapshot.session)) {rebuilt=Some(bytes);}}let packet:ServerPacket=serde_json::from_slice(&rebuilt.unwrap()).unwrap();let ServerPacket::State(decoded)=packet else {panic!("state required")};assert_eq!(decoded.players.iter().find(|p|p.id==a).unwrap().max_mana,player.max_mana);
 }
}
