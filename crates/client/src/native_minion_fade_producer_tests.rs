//! Actual consumer with controlled accepted endgame/wave/model fixture; no live/GPU claim.
use super::*;
#[path="native_minion_fade_test_fixture.rs"]mod helper;
fn ready()->(App,Owner,Entity,Handle<crate::map_fog::FogMaterial>){
 let(mut app,owner,primitive,_,previous)=helper::fixture();
 app.world_mut().entity_mut(owner.root).insert((GlobalTransform::from_translation(Vec3::new(7684.981903076172/20.,123./20.,6934.240234375/20.)),Visibility::Inherited));
 app.world_mut().resource_mut::<Time<Virtual>>().set_max_delta(std::time::Duration::from_secs(10));
 synchronize(app.world_mut());assert!(app.world().resource::<Host>().issues.is_empty());
 (app,owner,primitive,previous)
}
fn advance(app:&mut App,millis:u64){app.insert_resource(bevy::time::TimeUpdateStrategy::ManualDuration(std::time::Duration::from_millis(millis)));app.update();synchronize(app.world_mut());}
#[test]fn original_sampled_fade_runs_once_caps_actual_map10_brush_and_retires_at_native_deadline(){
 let(mut app,owner,primitive,previous)=ready();assert!(app.world().get::<Guard>(primitive).is_none(),"initial native alpha1 preserves actual baseline");
 advance(&mut app,500);assert_eq!(app.world().get::<Guard>(primitive).unwrap().submitted,0.75);
 let private=app.world().get::<Guard>(primitive).unwrap().owned.clone();
 synchronize(app.world_mut());assert_eq!(app.world().get::<Guard>(primitive).unwrap().owned,private);assert_eq!(app.world().get::<Guard>(primitive).unwrap().submitted,0.75,"duplicate update does not restart fade");
 let oracle:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_minion_brush_map10_cases.json")).unwrap();let p=oracle.as_array().unwrap().iter().find(|r|r["native_brush"]==true).unwrap()["position"].as_array().unwrap();
 app.world_mut().entity_mut(owner.root).insert(GlobalTransform::from_translation(Vec3::new(p[0].as_f64().unwrap()as f32,p[1].as_f64().unwrap()as f32,p[2].as_f64().unwrap()as f32)/20.));
 synchronize(app.world_mut());assert_eq!(app.world().get::<Guard>(primitive).unwrap().submitted,0.25,"native brush branch caps alpha; it never floors it");
 advance(&mut app,1500);assert!(app.world().get::<Guard>(primitive).is_none());assert_eq!(app.world().get::<MeshMaterial3d<crate::map_fog::FogMaterial>>(primitive).unwrap().0,previous);assert_eq!(app.world().get::<Visibility>(owner.root),Some(&Visibility::Inherited),"fade retirement does not overwrite terminal visibility consumer");
}
#[test]fn accepted_result_departure_retires_private_material_and_replacement_model_does_not_replay_event(){
 let(mut app,owner,primitive,previous)=ready();advance(&mut app,500);assert!(app.world().get::<Guard>(primitive).is_some());
 let name=app.world().get::<crate::animation::Playback>(owner.root).unwrap().model_name().to_owned();let replacement=app.world().resource::<Assets<Gltf>>().reserve_handle();
 app.world_mut().entity_mut(owner.root).insert(crate::animation::endgame_test_playback(owner.network,&name,replacement));synchronize(app.world_mut());assert!(app.world().get::<Guard>(primitive).is_none());assert_eq!(app.world().get::<MeshMaterial3d<crate::map_fog::FogMaterial>>(primitive).unwrap().0,previous);
 synchronize(app.world_mut());assert!(app.world().get::<Guard>(primitive).is_none(),"late replacement cannot replay the earlier FadeMinions event");
 app.world_mut().resource_mut::<crate::Match>().snapshot=None;synchronize(app.world_mut());assert_eq!(app.world().resource::<Host>().key,None);assert!(!app.world().resource::<Host>().fired);assert!(app.world().resource::<Host>().actors.is_empty());
}
