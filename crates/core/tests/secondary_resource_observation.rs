//! Diagnostic flat navigation and player placement; this is not a native server or a full match.
use openleague_core::{Action,Navigation,Simulation,Point,damage::DamageKind};
use serde_json::json;
fn game(name:&str, opponents:usize)->(Simulation,u32,Vec<u32>){
 let mut bytes=Vec::new();for _ in 0..6400 {bytes.extend(0f32.to_le_bytes());bytes.extend(0u16.to_le_bytes());bytes.extend(0u32.to_le_bytes());bytes.push(1);}
 let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":80,"height":80}"#,&bytes).unwrap();
 let mut s=Simulation::new(nav).unwrap();s.session=420;let owner=s.join(name).unwrap();let mut targets=vec![];
 for _ in 0..opponents {targets.push(s.join("garen").unwrap());}
 for (i,id) in std::iter::once(owner).chain(targets.iter().copied()).enumerate(){
  let p=s.players.get_mut(&id).unwrap();p.team=if id==owner{0}else{1};p.level=6;p.position=Point{x:200.+i as f32*150.,z:300.};p.ranks=if id==owner{[1;4]}else{[0;4]};p.mana=2000.;
  let hp=s.stats(id).max_health;s.players.get_mut(&id).unwrap().health=hp;
 }
 (s,owner,targets)
}
fn until(s:&mut Simulation,t:u64){while s.tick<t{s.advance();}}
#[test]
fn annie_real_e_casts_cap_w_release_consumes_and_public_death_resets(){
 let(mut s,a,targets)=game("annie",1);let b=targets[0];assert_eq!(s.players[&a].effects.pyromania,0);
 let mut charges=vec![];
 for _ in 0..5 {s.command(a,Action::Cast{slot:2,target:None}).unwrap();charges.push(s.players[&a].effects.pyromania);let deadline=s.players[&a].cooldowns[2];until(&mut s,deadline);}
 assert_eq!(charges,vec![1,2,3,4,4]);
 s.command(a,Action::Cast{slot:2,target:None}).unwrap();let before=serde_json::to_value(s.snapshot()).unwrap();
 let refusal=s.command(a,Action::Cast{slot:2,target:None}).unwrap_err();assert_eq!(refusal,"skill on cooldown");assert_eq!(serde_json::to_value(s.snapshot()).unwrap(),before);
 s.command(a,Action::CastAt{slot:1,point:Point{x:900.,z:300.}}).unwrap();assert_eq!(s.players[&a].effects.pyromania,4);
 let limit=s.tick+15;while s.players[&a].effects.pyromania==4&&s.tick<limit{s.advance();}
 assert_eq!(s.players[&a].effects.pyromania,0);assert!(!s.players[&b].stuns.is_empty());let consumed=s.tick;
 let deadline=s.players[&a].cooldowns[2];until(&mut s,deadline);s.command(a,Action::Cast{slot:2,target:None}).unwrap();assert_eq!(s.players[&a].effects.pyromania,1);
 s.apply_damage(None,a,100000.,DamageKind::True).unwrap();assert_eq!(s.players[&a].effects.pyromania,0);
 let deadline=s.players[&a].respawn_at.unwrap();until(&mut s,deadline);assert!(s.players[&a].health>0.);assert_eq!(s.players[&a].effects.pyromania,0);
 println!("OBSERVATION {}",json!({"case":"annie_secondary_lifecycle","casts_charges":charges,"cooldown_refusal":refusal,"refusal_snapshot_unchanged":true,"w_consumed_tick":consumed,"stun_observed":true,"before_death":1,"after_death":0,"after_respawn":0,"respawn_tick":s.tick,"fixture":"flat80x80;level6;ranks1;position;teams;initial_health_and_mana"}));
}
#[test]
fn ezreal_actual_w_and_r_contacts_cap_refresh_expire_and_owner_project(){
 let(mut s,a,targets)=game("ezreal",5);let base=s.stats(a).attack_cooldown_ticks;
 s.command(a,Action::CastAt{slot:1,point:Point{x:3000.,z:300.}}).unwrap();assert_eq!(s.ezreal_passive_stacks(a),0);
 let before=serde_json::to_value(s.snapshot()).unwrap();let refusal=s.command(a,Action::CastAt{slot:1,point:Point{x:3000.,z:300.}}).unwrap_err();assert_eq!(refusal,"skill blocked during cast");assert_eq!(serde_json::to_value(s.snapshot()).unwrap(),before);
 let mut transitions=vec![];let mut previous=0;
 while s.tick<60&&s.ezreal_passive_stacks(a)<5 {s.advance();let n=s.ezreal_passive_stacks(a);if n!=previous {transitions.push((s.tick,n));previous=n;}}
 assert_eq!(s.ezreal_passive_stacks(a),5);assert_eq!(transitions.iter().map(|x|x.1).collect::<Vec<_>>(),vec![1,2,3,4,5]);let first_cap=s.tick;
 let boosted=s.stats(a).attack_cooldown_ticks;assert!(boosted<base);
 let dto=s.snapshot_for(a).unwrap().ezreal_passive_self.unwrap();assert_eq!(dto.stacks,5);assert_eq!(serde_json::to_value(dto).unwrap().as_object().unwrap().len(),3);
 assert!(s.snapshot().ezreal_passive_self.is_none());for id in &targets {assert!(s.snapshot_for(*id).unwrap().ezreal_passive_self.is_none());assert_eq!(s.ezreal_passive_stacks(*id),0);}
 s.command(a,Action::CastAt{slot:3,point:Point{x:3000.,z:300.}}).unwrap();let limit=s.tick+70;let mut hits=vec![];
 while s.tick<limit {let hp:Vec<_>=targets.iter().map(|id|s.players[id].health).collect();s.advance();for(i,id)in targets.iter().enumerate(){if s.players[id].health<hp[i]-1. {hits.push((s.tick,*id));}}}
 assert_eq!(hits.len(),5);let last=hits.last().unwrap().0;assert!(last>first_cap);assert_eq!(s.ezreal_passive_stacks(a),5);
 until(&mut s,first_cap+180);assert_eq!(s.ezreal_passive_stacks(a),5);until(&mut s,last+179);assert_eq!(s.ezreal_passive_stacks(a),5);
 s.advance();assert_eq!(s.tick,last+180);assert_eq!(s.ezreal_passive_stacks(a),0);assert_eq!(s.stats(a).attack_cooldown_ticks,base);assert_eq!(s.snapshot_for(a).unwrap().ezreal_passive_self.unwrap().stacks,0);assert!(s.ezreal_passive_faults().is_empty());
 println!("OBSERVATION {}",json!({"case":"ezreal_secondary_contacts","w_transitions":transitions,"r_hits":hits,"cap":5,"expiry_tick":s.tick,"last_contact":last,"refresh_at_cap":true,"after_expiry":0,"attack_cooldown_before":base,"attack_cooldown_boosted":boosted,"owner_fields":3,"generic_and_five_enemy_projections_absent":true,"cast_refusal":refusal,"refusal_snapshot_unchanged":true,"fixture":"flat80x80;level6;ranks1;positions;five_opposing_targets_not_3v3_match;health_and_mana"}));
}
