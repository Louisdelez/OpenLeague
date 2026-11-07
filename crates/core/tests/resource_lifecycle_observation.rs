//! Current resource observations. Injected scalar state is explicit; native server rules remain unqualified.
use openleague_core::{damage::DamageKind,Action,Navigation,Simulation,TICK_RATE};
use serde_json::{Value,json};
fn game(name:&str)->(Simulation,u32){
 let nav=Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
 let mut s=Simulation::new(nav).unwrap();let id=s.join(name).unwrap();(s,id)
}
fn resources()->Value{serde_json::from_str(include_str!("../../../data/4.20/champion_resources.json")).unwrap()}
fn close(a:f32,b:f32){assert!((a-b).abs()<0.003,"{a} != {b}");}
#[test]
fn all_champions_expose_current_capacity_initial_value_and_regeneration_policy(){
 let rs=resources();let catalog=openleague_core::champion_catalog().unwrap();assert_eq!(catalog.len(),122);
 for c in catalog.values() {
  let(s,id)=game(&c.id);let p=&s.players[&id];let st=s.stats(id);let rate=s.regeneration_rates(id).unwrap();let kind=rs[&c.id]["type"].as_str().unwrap();
  assert_eq!(p.mana.to_bits(),c.mana.to_bits());assert_eq!(st.max_mana.to_bits(),c.mana.to_bits());
  if kind!="Mana"&&kind!="Energy"{assert_eq!(rate.resource_per_second,0.);}
  let snapshot=s.snapshot();let view=snapshot.players.iter().find(|p|p.id==id).unwrap();assert_eq!(view.mana,p.mana);assert_eq!(view.max_mana,Some(st.max_mana));
  assert!(s.regeneration_rates(u32::MAX).is_none());
  println!("OBSERVATION {}",json!({"case":"catalog","champion":c.id,"kind":kind,"initial":p.mana,"capacity":st.max_mana,"regen":rate.resource_per_second,"snapshot_capacity":view.max_mana}));
 }
}
#[test]
fn actual_ticks_and_public_death_respawn_distinguish_special_resource_policies(){
 let rs=resources();
 for (name,r) in rs.as_object().unwrap(){
  let kind=r["type"].as_str().unwrap();if kind=="Mana"&&name!="ahri"&&name!="annie"{continue;}
  let(mut s,id)=game(name);let cap=s.stats(id).max_mana;let rate=s.regeneration_rates(id).unwrap().resource_per_second;
  // Deliberate diagnostic input, not a claimed native spawn or ability expenditure.
  s.players.get_mut(&id).unwrap().mana=0.;
  for _ in 0..TICK_RATE{s.advance();}
  let after_ticks=s.players[&id].mana;close(after_ticks,rate.min(cap));
  let hp=s.players[&id].health;s.apply_damage(None,id,hp*10.+1.,DamageKind::True).unwrap();
  assert_eq!(s.players[&id].health,0.);let deadline=s.players[&id].respawn_at.unwrap();let death_tick=s.tick;let at_death=s.players[&id].mana;
  while s.tick+1<deadline{s.advance();assert_eq!(s.players[&id].health,0.);assert_eq!(s.players[&id].mana,at_death);}
  s.advance();assert!(s.players[&id].health>0.);assert!(s.players[&id].respawn_at.is_none());
  let expected=if ["Mana","Energy","Wind"].contains(&kind){cap}else{0.};assert_eq!(s.players[&id].mana,expected);
  println!("OBSERVATION {}",json!({"case":"tick_and_respawn","champion":name,"kind":kind,"injected_resource":0,"alive_ticks":TICK_RATE,"capacity":cap,"regen":rate,"after_ticks":after_ticks,"death_tick":death_tick,"respawn_tick":s.tick,"resource_after_respawn":s.players[&id].mana}));
 }
}
#[test]
fn special_resource_cast_boundaries_and_garen_free_cast_remain_distinct(){
 let rs=resources();let mut rejected=0;
 for (name,r) in rs.as_object().unwrap(){
  if r["type"]=="Mana"||name=="garen"{continue;}
  let(mut s,id)=game(name);let before=serde_json::to_value(s.snapshot()).unwrap();
  assert_eq!(s.command(id,Action::Learn{slot:0}).unwrap_err(),"champion skill progression not implemented");rejected+=1;assert_eq!(serde_json::to_value(s.snapshot()).unwrap(),before);
  for slot in 0..4 {assert_eq!(s.command(id,Action::Cast{slot,target:None}).unwrap_err(),"champion spell not implemented");rejected+=1;assert_eq!(serde_json::to_value(s.snapshot()).unwrap(),before);}
  println!("OBSERVATION {}",json!({"case":"unsupported_cast","champion":name,"kind":r["type"],"refusals":5,"snapshot_unchanged":true}));
 }
 let(mut s,id)=game("garen");s.command(id,Action::Learn{slot:0}).unwrap();let mana=s.players[&id].mana;let health=s.players[&id].health;
 s.command(id,Action::Cast{slot:0,target:None}).unwrap();assert_eq!(s.players[&id].mana,mana);assert_eq!(s.players[&id].health,health);assert!(s.players[&id].cooldowns[0]>s.tick);
 let before=serde_json::to_value(s.snapshot()).unwrap();assert_eq!(s.command(id,Action::Cast{slot:0,target:None}).unwrap_err(),"skill on cooldown");assert_eq!(serde_json::to_value(s.snapshot()).unwrap(),before);
 println!("OBSERVATION {}",json!({"case":"garen_no_resource_q","mana":mana,"health":health,"cooldown":s.players[&id].cooldowns[0],"cooldown_refusal":true,"other_champion_refusals":rejected}));
}
