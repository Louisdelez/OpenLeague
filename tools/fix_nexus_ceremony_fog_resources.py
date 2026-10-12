from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/match_results.rs';s=p.read_text(encoding='utf-8');s=s.replace('pub position:[f32;3]}','pub position:[f32;3],#[serde(default)] pub definition:String,#[serde(default)] pub facing:f32}');s=s.replace('position:[u.position.x,u.height,u.position.z]}','position:[u.position.x,u.height,u.position.z],definition:u.definition.clone(),facing:u.facing}');s=s.replace('assert_eq!(nexus.team,1);','assert_eq!(nexus.team,1);assert_eq!(nexus.definition,s.units[&nexus.id].definition);assert_eq!(nexus.facing,s.units[&nexus.id].facing);');p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/nexus_ceremony.rs';s=p.read_text(encoding='utf-8')
a=s.index(' if !clock.skin_due_for(result,time.elapsed_secs_f64())');b=s.index('\n}\n#[cfg(test)]',a)
s=s[:a]+''' let destroyed=clock.skin_due_for(result,time.elapsed_secs_f64());
 let id=nexus.id;
 if state.visuals.contains_key(&id) && state.destroyed_structures.get(&id)==Some(&destroyed) {return;}
 // This definition/pose is supplied by the server's unfiltered frozen result for the ceremony.
 if nexus.definition.is_empty() {return;}
 let name=if destroyed {format!("{}_destroyed",nexus.definition)} else {nexus.definition.clone()};
 let (request,scale)=animation::request(id,&name,&catalog,&assets);
 let transform=Transform::from_translation(Vec3::from_array(nexus.position)/20.).with_rotation(Quat::from_rotation_y(nexus.facing)).with_scale(Vec3::splat(scale*0.05));
 if let Some(entity)=state.visuals.remove(&id) {commands.entity(entity).despawn();}
 let entity=commands.spawn((transform,request)).id();
 state.visuals.insert(id,entity);state.destroyed_structures.insert(id,destroyed);'''+s[b:]
needle='  let (snapshot,id)=fixture();let tick=snapshot.tick;';s=s.replace(needle,'  let (mut snapshot,id)=fixture();let tick=snapshot.tick;snapshot.units.retain(|u|u.id!=id);')
needle='#[cfg(test)] mod tests {';assert needle in s
# Also prove absent fog actor creates an intact ceremony root from authoritative result metadata.
i=s.index('\n}\n\n/// Readonly',s.index(needle))
s=s[:i]+r'''
 #[test] fn absent_fog_actor_is_created_from_frozen_server_definition_and_pose() {
  let (mut snapshot,id)=fixture();let nexus=snapshot.result.as_ref().unwrap().destroyed_nexus.as_ref().unwrap().clone();snapshot.units.retain(|u|u.id!=id);
  let mut app=App::new();app.add_plugins((MinimalPlugins,bevy::asset::AssetPlugin::default())).init_asset::<Gltf>().init_resource::<animation::Catalog>().init_resource::<Match>().init_resource::<endgame_timeline::Clock>().add_systems(Update,(endgame_timeline::update,update).chain());
  app.world_mut().resource_mut::<Match>().snapshot=Some(snapshot);app.update();
  let state=app.world().resource::<Match>();let entity=state.visuals[&id];assert!(!state.destroyed_structures[&id]);
  let transform=app.world().get::<Transform>(entity).unwrap();assert_eq!(transform.translation,Vec3::from_array(nexus.position)/20.);assert_eq!(transform.rotation,Quat::from_rotation_y(nexus.facing));assert!(app.world().get::<animation::ModelRequest>(entity).is_some());
  app.update();assert_eq!(app.world().resource::<Match>().visuals[&id],entity);
 }
'''+s[i:];p.write_text(s,encoding='utf-8')
print('Authoritative nexus definition and pose preserve ceremony actor under fog filtering')
