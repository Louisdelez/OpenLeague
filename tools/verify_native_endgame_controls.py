from pathlib import Path
r=Path('E:/OpenLeague')
p=r/'crates/client/src/native_endgame_ui.rs';s=p.read_text(encoding='utf-8');s=s.replace('let catalog:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/endgame_ui_native.json")).expect("native UI catalog");','static CATALOG:std::sync::OnceLock<serde_json::Value>=std::sync::OnceLock::new();\n let catalog=CATALOG.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/endgame_ui_native.json")).expect("native UI catalog"));')
s+='''
#[cfg(test)] mod tests {
 use super::*;
 fn app(team:u8)->(App,Entity,Entity,Entity){
  let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();let mut game=openleague_core::Simulation::new(nav).unwrap();game.session=42;for _ in 0..6{game.join("garen").unwrap();}let id=game.players.values().find(|p|p.team==team).unwrap().id;game.winner=Some(0);game.advance();
  let connection=Connection{socket:std::net::UdpSocket::bind("127.0.0.1:0").unwrap(),id:Some(id),session:Some(42),sequence:0,last_join:std::time::Instant::now(),champion:"garen".into(),summoners:[None,None],rejection:String::new(),assembler:Default::default()};
  let mut app=App::new();app.add_plugins((MinimalPlugins,AssetPlugin::default())).init_asset::<Image>().init_resource::<View>().init_resource::<ButtonInput<MouseButton>>().insert_resource(connection).insert_resource(Match{snapshot:Some(game.snapshot()),..default()}).add_systems(Update,update);
  let root=app.world_mut().spawn((Splash,Node::default())).id();let image=app.world_mut().spawn((NativeImage("background"),Node::default(),ImageNode::default())).id();let button=app.world_mut().spawn((Continue,Node::default(),ImageNode::default(),Interaction::None)).id();(app,root,image,button)
 }
 #[test] fn native_splash_selects_local_team_and_dismisses_only_armed_release(){
  let (mut app,root,image,button)=app(0);app.update();assert_eq!(app.world().get::<Node>(root).unwrap().display,Display::Flex);
  let image_path=app.world().resource::<AssetServer>().get_path(app.world().get::<ImageNode>(image).unwrap().image.id()).unwrap();assert_eq!(image_path.path().to_str(),Some("ui/endgame/victory.png"));
  app.world_mut().resource_mut::<ButtonInput<MouseButton>>().press(MouseButton::Left);*app.world_mut().get_mut::<Interaction>(button).unwrap()=Interaction::Pressed;app.update();assert!(app.world().resource::<View>().armed);
  *app.world_mut().get_mut::<Interaction>(button).unwrap()=Interaction::Hovered;app.world_mut().resource_mut::<ButtonInput<MouseButton>>().release(MouseButton::Left);app.update();assert!(app.world().resource::<View>().dismissed);
  app.world_mut().resource_mut::<ButtonInput<MouseButton>>().clear();app.update();assert_eq!(app.world().get::<Node>(root).unwrap().display,Display::None);
 }
 #[test] fn losing_team_uses_original_red_asset_and_unarmed_release_is_ignored(){
  let (mut app,_,image,button)=app(1);app.update();let image_path=app.world().resource::<AssetServer>().get_path(app.world().get::<ImageNode>(image).unwrap().image.id()).unwrap();assert_eq!(image_path.path().to_str(),Some("ui/endgame/defeat.png"));
  *app.world_mut().get_mut::<Interaction>(button).unwrap()=Interaction::Hovered;let mut input=app.world_mut().resource_mut::<ButtonInput<MouseButton>>();input.press(MouseButton::Left);input.release(MouseButton::Left);drop(input);app.update();assert!(!app.world().resource::<View>().dismissed);
 }
}
''';p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');i=s.index('fn labels(');tail=s[i:];needle='    for mut text in &mut labels {'
if needle not in tail:
 print(tail[:550]);raise ValueError('label loop missing')
tail=tail.replace(needle,needle+'\n        if state.snapshot.as_ref().is_some_and(|s|s.winner.is_some()){**text=String::new();continue;}',1);p.write_text(s[:i]+tail,encoding='utf-8')
p=r/'crates/client/src/health.rs';s=p.read_text(encoding='utf-8');needle='    let Some((camera, camera_transform)) = cameras.iter().next() else {';assert needle in s;s=s.replace(needle,'    if snapshot.winner.is_some() {for (mut node, _) in &mut roots {node.display=Display::None;}return;}\n'+needle,1);p.write_text(s,encoding='utf-8')
print('native splash control tests and HUD end-game gate added')
