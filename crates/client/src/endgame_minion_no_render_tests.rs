//! Controlled ECS/network-snapshot fixtures, not a completed-match/GPU proof.
use super::*;
use std::time::Duration;
fn connection(session:u64,id:u32)->crate::Connection{crate::Connection{
 socket:std::net::UdpSocket::bind("127.0.0.1:0").unwrap(),link:crate::session_connection::Link::legacy(),id:Some(id),session:Some(session),sequence:0,last_join:std::time::Instant::now(),champion:"garen".into(),summoners:[None,None],rejection:String::new(),assembler:Default::default(),welcome_history:Default::default()}}

fn fixture()->(App,Vec<(Entity,u8,openleague_core::world::Kind)>){
 let nav=openleague_core::Navigation::load(include_str!("E:/OpenLeague/assets/maps/tt_navigation_grid.json"),include_bytes!("E:/OpenLeague/assets/maps/tt_navigation_grid.cells.bin")).unwrap();
 let mut game=openleague_core::Simulation::new(nav).unwrap();game.enable_map10().unwrap();game.session=7;for _ in 0..6{game.join("garen").unwrap();}
 for _ in 0..2251{game.advance();}
 game.winner=Some(0);game.advance();let snapshot:openleague_core::Snapshot=serde_json::from_slice(&serde_json::to_vec(&game.snapshot()).unwrap()).unwrap();
 let player=snapshot.result.as_ref().unwrap().players.iter().find(|p|p.team==0).unwrap().id;
 let mut app=App::new();app.insert_resource(Time::<()>::default()).init_resource::<crate::endgame_timeline::Clock>().init_resource::<Host>()
  .insert_resource(connection(7,player)).add_systems(Update,crate::endgame_timeline::update).add_systems(PostUpdate,synchronize);
 let mut state=crate::Match{snapshot:Some(snapshot),..Default::default()};let mut roots=Vec::new();
 for unit in state.snapshot.as_ref().unwrap().units.iter().filter(|u|u.kind.lane()||u.kind==openleague_core::world::Kind::Monster){
  let root=app.world_mut().spawn((crate::actor_fow::Root,crate::animation::endgame_test_playback(unit.id,&unit.definition,Handle::default()),Visibility::Inherited,Transform::IDENTITY,GlobalTransform::IDENTITY)).id();
  roots.push((root,unit.team,unit.kind));state.visuals.insert(unit.id,root);
 }
 assert!(roots.iter().any(|r|r.1==1&&r.2.lane()));assert!(roots.iter().any(|r|r.1==0&&r.2.lane()));
 app.insert_resource(state);app.update();(app,roots)
}
fn advance(app:&mut App,seconds:f64){app.world_mut().resource_mut::<Time>().advance_by(Duration::from_secs_f64(seconds));app.update();}

#[test]
fn exact_native_stop_render_deadline_hides_only_loser_wave_roots_and_reasserts_after_model_updates(){
 let (mut app,roots)=fixture();advance(&mut app,5.499999);
 for (root,_,_) in &roots{assert_eq!(app.world().get::<Visibility>(*root),Some(&Visibility::Inherited));}
 advance(&mut app,0.000001);
 for (root,team,kind) in &roots{assert_eq!(app.world().get::<Visibility>(*root),Some(&if *team==1&&kind.lane(){Visibility::Hidden}else{Visibility::Inherited}));}
 let loser=roots.iter().find(|r|r.1==1&&r.2.lane()).unwrap().0;
 *app.world_mut().get_mut::<Visibility>(loser).unwrap()=Visibility::Inherited;
 app.update();assert_eq!(app.world().get::<Visibility>(loser),Some(&Visibility::Hidden));
}
#[test]
fn absent_result_or_changed_session_restores_owned_visibility_without_hiding_winner(){
 let (mut app,roots)=fixture();advance(&mut app,6.);
 let mut next=app.world().resource::<crate::Match>().snapshot.as_ref().unwrap().clone();
 app.world_mut().resource_mut::<crate::Match>().snapshot.as_mut().unwrap().result=None;app.update();
 for (root,_,_) in &roots{assert_eq!(app.world().get::<Visibility>(*root),Some(&Visibility::Inherited));}
 assert!(app.world().resource::<Host>().entries.is_empty());
 next.session=8;let result=next.result.as_mut().unwrap();result.session=8;let id=result.players[0].id;
 app.insert_resource(connection(8,id));app.world_mut().resource_mut::<crate::Match>().snapshot=Some(next);app.update();assert!(app.world().resource::<Host>().entries.is_empty());
 advance(&mut app,5.5);assert!(!app.world().resource::<Host>().entries.is_empty());
}
#[test]
fn foreign_connection_session_and_replaced_playback_never_receive_stale_no_render(){
 let (mut app,roots)=fixture();advance(&mut app,6.);let loser=roots.iter().find(|r|r.1==1&&r.2.lane()).unwrap().0;
 app.world_mut().entity_mut(loser).insert((crate::animation::endgame_test_playback(9999,"other",Handle::default()),Visibility::Visible));
 app.update();assert_eq!(app.world().get::<Visibility>(loser),Some(&Visibility::Visible));assert!(app.world().get::<Suppressed>(loser).is_none());
 app.insert_resource(connection(8,21));app.update();
 assert!(app.world().resource::<Host>().entries.is_empty());
 for (root,_,_) in roots.iter().filter(|r|r.0!=loser){assert_eq!(app.world().get::<Visibility>(*root),Some(&Visibility::Inherited));}
}
#[test]
fn cancellation_preserves_prior_hidden_and_later_external_visible_states(){
 let (mut app,roots)=fixture();let losers=roots.iter().filter(|r|r.1==1&&r.2.lane()).map(|r|r.0).collect::<Vec<_>>();assert!(losers.len()>=2);
 *app.world_mut().get_mut::<Visibility>(losers[0]).unwrap()=Visibility::Hidden;
 advance(&mut app,6.);
 *app.world_mut().get_mut::<Visibility>(losers[1]).unwrap()=Visibility::Visible;
 app.world_mut().resource_mut::<crate::Match>().snapshot.as_mut().unwrap().result=None;app.update();
 assert_eq!(app.world().get::<Visibility>(losers[0]),Some(&Visibility::Hidden));assert_eq!(app.world().get::<Visibility>(losers[1]),Some(&Visibility::Visible));
}
