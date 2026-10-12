from pathlib import Path
import shutil
r=Path('E:/OpenLeague');shutil.copy2('E:/mapslol3v3/native_camera_pan_contract.json',r/'data/4.20/native_camera_pan_contract.json')
p=r/'crates/core/src/camera_pan.rs';assert not p.exists();p.write_text('''//! Original default two-key camera pan (mode1), request565E00/update5663B0/curve565F50.
#[derive(Debug,Clone)] pub struct Pan {start:[f32;3],end:[f32;3],began:f32,ends:f32,pub current:[f32;3],pub finished:bool}
impl Pan {
 pub fn new(start:[f32;3],end:[f32;3],now:f32,duration:f32)->Self {let ends=now+duration;let finished=now>=ends;Self{start,end,began:now,ends,current:if finished{end}else{start},finished}}
 pub fn update(&mut self,now:f32)->[f32;3]{
  if self.finished{return self.current;}
  if now>=self.ends{self.current=self.end;self.finished=true;return self.current;}
  let t=((now-self.began)/(self.ends-self.began)).clamp(0.,1.);
  // Preserve native scalar instruction order and do not introduce fused multiply-add.
  let weight=(3.-t*2.)*(t*t);let complement=1.-weight;
  self.current=std::array::from_fn(|i|self.start[i]*complement+self.end[i]*weight);
  self.current[1]=0.;self.current
 }
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn matches176_original_request_update_cleanup_sequences_bit_for_bit(){
  let d:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_camera_pan_contract.json")).unwrap();let cases=d["cases"].as_array().unwrap();assert_eq!(cases.len(),176);
  for c in cases{let vector=|name:&str|std::array::from_fn(|i|c[name][i].as_f64().unwrap() as f32);let mut pan=Pan::new(vector("start"),vector("end"),100.,c["duration"].as_f64().unwrap() as f32);let actual=pan.update(f32::from_bits(c["now_bits"].as_u64().unwrap() as u32));for (i,v) in actual.iter().enumerate(){assert_eq!(v.to_bits(),c["output_bits"][i].as_u64().unwrap() as u32,"{c}");}assert_eq!(pan.finished,c["finished"].as_bool().unwrap());}
 }
}
''',encoding='utf-8')
p=r/'crates/core/src/lib.rs';s=p.read_text(encoding='utf-8');s='pub mod camera_pan;\n'+s;p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/match_results.rs';s=p.read_text(encoding='utf-8');s=s.replace('#[derive(Debug,Clone,Serialize,Deserialize)]\npub struct MatchResult', '#[derive(Debug,Clone,Serialize,Deserialize)]\npub struct NexusResult {pub id:u32,pub team:u8,pub position:[f32;3]}\n#[derive(Debug,Clone,Serialize,Deserialize)]\npub struct MatchResult',1)
s=s.replace('pub players:Vec<PlayerResult>}','pub players:Vec<PlayerResult>,#[serde(default)] pub destroyed_nexus:Option<NexusResult>}',1)
s=s.replace('   players:self.players.values()', '   destroyed_nexus:self.units.values().find(|u|u.kind==world::Kind::Nexus&&u.team==1-winner).map(|u|NexusResult{id:u.id,team:u.team,position:[u.position.x,u.height,u.position.z]}),\n   players:self.players.values()',1)
needle='assert_eq!(result.ended_tick,s.tick);';assert needle in s;s=s.replace(needle,needle+'let nexus=result.destroyed_nexus.as_ref().unwrap();assert_eq!(nexus.team,1);assert_eq!(nexus.id,s.units.values().find(|u|u.name=="HQ_T2").unwrap().id);',1);p.write_text(s,encoding='utf-8')
p=r/'crates/server/src/result_store.rs';s=p.read_text(encoding='utf-8');s=s.replace('winner:0,players:vec![]','winner:0,players:vec![],destroyed_nexus:None',1);p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/camera_native.rs';s=p.read_text(encoding='utf-8');s+='''
/// The server result supplies the destroyed nexus independently of fog-filtered actors.
#[derive(Resource,Default)] pub struct EndPan {key:Option<(u64,u64)>,pub pan:Option<openleague_core::camera_pan::Pan>}
impl EndPan {
 pub fn apply(&mut self,result:Option<&openleague_core::match_results::MatchResult>,focus:[f32;3],now:f32)->Option<[f32;3]> {
  let key=result.map(|r|(r.session,r.ended_tick));
  if self.key!=key {self.key=key;self.pan=result.and_then(|r|r.destroyed_nexus.as_ref()).map(|n|openleague_core::camera_pan::Pan::new(focus,n.position,now,crate::endgame_timeline::schedule().pan as f32));}
  self.pan.as_mut().map(|pan|pan.update(now))
 }
}
''';p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');s=s.replace('.init_resource::<Match>()','.init_resource::<Match>().init_resource::<camera_native::EndPan>()');s=s.replace('fn camera(\n    state: Res<Match>,','fn camera(\n    mut end_pan:ResMut<camera_native::EndPan>,\n    state: Res<Match>,',1)
needle='    focus.0 += delta * time.delta_secs() * 150.;';assert needle in s;s=s.replace(needle,needle+'\n    if let Some(position)=end_pan.apply(state.snapshot.as_ref().and_then(|s|s.result.as_ref()),(focus.0*20.).to_array(),time.elapsed_secs()) {focus.0=Vec3::from_array(position)/20.;}',1)
s=s.replace('endgame_timeline::update.after(receive).before(native_endgame_ui::update)','endgame_timeline::update.after(receive).before(camera).before(native_endgame_ui::update)',1)
idx=s.rfind('\n}');s=s[:idx]+'''
 #[test]
 fn end_game_camera_moves_to_authoritative_nexus_and_reaches_actual_renderer_pose(){
  let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();let mut game=openleague_core::Simulation::new(nav).unwrap();game.enable_map10().unwrap();game.session=734;for _ in 0..6{game.join("garen").unwrap();}game.winner=Some(0);game.advance();let snapshot=game.snapshot();let endpoint=Vec3::from_array(snapshot.result.as_ref().unwrap().destroyed_nexus.as_ref().unwrap().position)/20.;
  let origin=Vec3::new(370.,0.,385.);let mut app=App::new();let mut time:Time=Time::default();time.advance_by(std::time::Duration::from_millis(16));let mut keys=ButtonInput::default();keys.press(KeyCode::ArrowDown);
  app.add_message::<bevy::input::mouse::MouseWheel>().insert_resource(time).insert_resource(keys).insert_resource(Match{snapshot:Some(snapshot),..default()}).init_resource::<camera_native::EndPan>().insert_resource(CameraFocus(origin)).insert_resource(camera_native::NativeCamera::default()).add_systems(Update,camera);
  let entity=app.world_mut().spawn((Camera3d::default(),Transform::default(),Projection::default())).id();app.update();assert!(app.world().resource::<CameraFocus>().0.distance(origin)<0.001);
  app.world_mut().resource_mut::<Time>().advance_by(std::time::Duration::from_millis(1500));app.update();let middle=app.world().resource::<CameraFocus>().0;let target=Vec3::new(endpoint.x,0.,endpoint.z);assert!(middle.distance((origin+target)*0.5)<0.001);
  app.world_mut().resource_mut::<Time>().advance_by(std::time::Duration::from_millis(1500));app.update();assert!(app.world().resource::<CameraFocus>().0.distance(target)<0.001);assert!(app.world().resource::<camera_native::EndPan>().pan.as_ref().unwrap().finished);
  let transform=app.world().get::<Transform>(entity).unwrap();assert!(transform.forward().dot((target-transform.translation).normalize())>0.999999);
 }
'''+s[idx:];p.write_text(s,encoding='utf-8')
print('176-case native pan port, authoritative nexus result and actual camera integration implemented')
