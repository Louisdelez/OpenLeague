use crate::*;
fn game(champion:&str)->(Simulation,u32,u32) {
 let nav=Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();let mut s=Simulation::new(nav).unwrap();s.enable_map10().unwrap();s.interactions=None;let a=s.join(champion).unwrap();let b=s.join("garen").unwrap();
 let point=s.navigation.nearest_walkable(Point{x:7700.,z:7000.}).unwrap();
 for id in [a,b] {let p=s.players.get_mut(&id).unwrap();p.position=point;p.health=p.max_health;p.mana=1000.;p.level=18;}
 (s,a,b)
}
#[test] fn all_eight_implemented_casts_capture_server_duration_and_failed_casts_do_not_change_it() {
 for champion in ["annie","garen"] {for slot in 0..4 {
  let(mut s,a,b)=game(champion);assert_eq!(s.players[&a].cooldown_totals,[None;4]);s.learn(a,slot).unwrap();s.tick=37;
  if champion=="annie" && matches!(slot,1|3) {let p=s.players[&a].position;s.cast_at(a,slot,Point{x:p.x+100.,z:p.z}).unwrap();}else {s.cast(a,slot,if matches!(slot,0|3) {Some(b)}else {None}).unwrap();}
  let total=s.players[&a].cooldowns[slot as usize]-s.tick;assert!(total>0);assert_eq!(s.players[&a].cooldown_totals[slot as usize],Some(total));
  let saved=s.players[&a].cooldown_totals;s.players.get_mut(&a).unwrap().health=0.;assert!(s.cast(a,slot,Some(b)).is_err());assert_eq!(s.players[&a].cooldown_totals,saved);
 }}
}
#[test] fn item_changes_cancel_and_kill_refund_preserve_committed_total() {
 let(mut s,a,_)=game("garen");let spawns:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/champion_spawns_map10.json")).unwrap();s.players.get_mut(&a).unwrap().position=serde_json::from_value(spawns[0]["point"].clone()).unwrap();s.learn(a,2).unwrap();s.players.get_mut(&a).unwrap().gold=10000.;s.buy_item(a,3108).unwrap();s.cast(a,2,None).unwrap();let total=s.players[&a].cooldown_totals[2];let ready=s.players[&a].cooldowns[2];s.sell_item(a,0).unwrap();s.tick+=1;s.cast(a,2,None).unwrap();assert_eq!(s.players[&a].cooldown_totals[2],total);assert_eq!(s.players[&a].cooldowns[2],ready);
 let(mut s,a,b)=game("annie");s.learn(a,0).unwrap();s.players.get_mut(&a).unwrap().inventory[0]=Some(3108);s.players.get_mut(&b).unwrap().health=1.;s.cast(a,0,Some(b)).unwrap();assert_eq!(s.players[&a].cooldown_totals[0],Some(108));s.players.get_mut(&a).unwrap().inventory[0]=None;
 for tick in 1..=30 {s.tick=tick;s.advance_annie();}assert_eq!(s.players[&a].cooldowns[0],54);assert_eq!(s.players[&a].cooldown_totals[0],Some(108));
}
#[test] fn actual_udp_state_fragments_transport_totals_and_older_packets_remain_unknown() {
 let(mut s,a,_)=game("annie");s.learn(a,2).unwrap();s.cast(a,2,None).unwrap();let snapshot=s.snapshot();
 let receiver=std::net::UdpSocket::bind("127.0.0.1:0").unwrap();receiver.set_read_timeout(Some(std::time::Duration::from_secs(1))).unwrap();let sender=std::net::UdpSocket::bind("127.0.0.1:0").unwrap();let mut assembler=wire::StateAssembler::default();let mut decoded=None;
 for d in wire::state_datagrams(&snapshot).unwrap() {sender.send_to(&d,receiver.local_addr().unwrap()).unwrap();let mut buffer=[0u8;1200];let(n,_)=receiver.recv_from(&mut buffer).unwrap();if let Some(bytes)=assembler.push(&buffer[..n],Some(snapshot.session)) {decoded=Some(serde_json::from_slice::<ServerPacket>(&bytes).unwrap());}}
 let ServerPacket::State(received)=decoded.unwrap() else {panic!("state packet required")};assert_eq!(received.players.iter().find(|p|p.id==a).unwrap().cooldown_totals[2],Some(300));
 let mut old=serde_json::to_value(&s.players[&a]).unwrap();old.as_object_mut().unwrap().remove("cooldown_totals");let old:Champion=serde_json::from_value(old).unwrap();assert_eq!(old.cooldown_totals,[None;4]);
}
