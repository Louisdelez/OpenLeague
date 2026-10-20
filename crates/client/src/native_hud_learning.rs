//! Original learning arrows/frames. Native expanded-panel animation/input routing remains open.
use bevy::{prelude::*,ui_render::ui_material::MaterialNode,window::PrimaryWindow};
use crate::{native_hud_panels::Panel,native_hud_element_storage::ElementStorage,native_hud_icon_material::IconMaterial,native_zip_provider::StartupHud};
#[derive(Clone,Debug)] pub(crate) struct Bounds {pub slot:u8,pub rect:[f32;4]}
#[derive(Resource,Default)] pub(crate) struct Live {sources:Vec<Panel>,bounds:Vec<Bounds>,entities:Vec<Entity>,materials:Vec<Handle<IconMaterial>>,signature:Option<String>,error:Option<String>,pub pointer_hover:bool,pending:Vec<Vec2>,events:Vec<serde_json::Value>,report:Option<serde_json::Value>}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {fn build(&self,app:&mut App) {app.init_resource::<Live>().add_systems(Startup,setup).add_systems(Update,(render,input).chain().after(crate::receive).after(crate::native_hud_inventory::InputSet).after(crate::native_minimap::InputSet).after(crate::camera_lock_ui::InputSet).before(crate::commands).before(crate::render_probe::capture));}}
fn flags(blocked:bool,expanded:bool,animating:bool)->[bool;4] {[!blocked&&animating,blocked&&animating,!blocked&&expanded,!blocked&&expanded]}
pub(crate) fn eligible(p:&openleague_core::Champion)->Result<[bool;4],String> {crate::native_hud_ranks::maxima(&p.champion)?;Ok(std::array::from_fn(|slot|openleague_core::progression::next_rank(p,slot as u8).is_ok()))}
fn source(hud:&StartupHud)->Result<Vec<Panel>,String> {
 let mut result=Vec::new();for layout in &hud.shadow_isles_layouts {if !layout.request.ends_with("ShadowIslesEvolutionBar.ini") {continue;}for record in &layout.structure.accepted {
  let s=&record.element.storage;if s.kind()!=1 {continue;}let name=std::str::from_utf8(s.bytes()[..32].split(|b|*b==0).next().unwrap()).map_err(|_|"learning widget name encoding")?;
  if !(0..4).any(|i|name==format!("EvolutionArrow{i}") || name==format!("EvolutionArrowFrame{i}")) {continue;}
  if s.bytes()[0x1e0..0x200].split(|b|*b==0).next().unwrap()!=b"ShadowIslesHUDAtlas" {return Err("native learning atlas mismatch".into());}let mut storage=ElementStorage::new(1).unwrap();storage.write_bytes(0,s.bytes());result.push(Panel {name:name.into(),path:layout.request.clone(),storage});
 }}if result.len()!=8 {return Err(format!("eight native learning sprites required: {}",result.len()));}Ok(result)
}
fn setup(hud:Res<StartupHud>,mut live:ResMut<Live>) {match source(&hud) {Ok(v)=>live.sources=v,Err(e)=>{live.error=Some(e.clone());eprintln!("Native learning HUD unavailable: {e}");}}}
fn clear(live:&mut Live,commands:&mut Commands,materials:&mut Assets<IconMaterial>) {for e in live.entities.drain(..) {commands.entity(e).despawn();}for m in live.materials.drain(..) {materials.remove(m.id());}live.bounds.clear();live.signature=None;live.pointer_hover=false;}
fn persist(live:&Live) {if let (Ok(path),Some(report))=(std::env::var("OPENLEAGUE_NATIVE_HUD_LEARNING_TRACE"),&live.report) {let mut value=report.clone();value["input_events"]=serde_json::json!(live.events);value["pointer_hover"]=serde_json::json!(live.pointer_hover);if let Err(e)=std::fs::write(path,serde_json::to_vec_pretty(&value).unwrap()) {eprintln!("Native learning trace failed: {e}");}}}
fn render(mut commands:Commands,game:Res<crate::Match>,connection:Res<crate::Connection>,window:Query<&Window,With<PrimaryWindow>>,viewport:Res<crate::native_hud_viewport::Viewport>,atlases:Res<crate::native_hud_atlases::Atlases>,mut materials:ResMut<Assets<IconMaterial>>,mut live:ResMut<Live>) {
 if live.sources.len()!=8 {return;}let Some(s)=&game.snapshot else {clear(&mut live,&mut commands,&mut materials);return;};let Some(player)=s.players.iter().find(|p|Some(p.id)==connection.id) else {clear(&mut live,&mut commands,&mut materials);return;};
 let allowed=match eligible(player) {Ok(v)=>if s.winner.is_some() {[false;4]}else {v},Err(e)=>{clear(&mut live,&mut commands,&mut materials);if live.error.as_ref()!=Some(&e) {eprintln!("Native learning state unavailable: {e}");live.error=Some(e);}return;}};
 let Ok(window)=window.single() else {return;};let dimensions=[window.physical_width(),window.physical_height()];let dpi=window.scale_factor();let signature=format!("{:?}:{}:{allowed:?}:{dimensions:?}:{dpi}:{}",connection.id,player.champion,viewport.scalar.to_bits());if live.signature.as_ref()==Some(&signature) {return;}
 let result=(||->Result<Vec<(Node,IconMaterial,serde_json::Value,Option<Bounds>,i32)>,String> {
  let atlas=atlases.entries.iter().find(|a|a.normalized.ends_with("ShadowIslesHUDAtlas.dds")).ok_or("native learning atlas missing")?.image.clone();let expanded=allowed.iter().any(|x|*x);let mut result=Vec::new();
  for p in &live.sources {let slot=p.name.as_bytes().last().unwrap()-b'0';let is_frame=p.name.starts_with("EvolutionArrowFrame");let enabled=flags(!allowed[slot as usize],expanded,false)[if is_frame {3}else {2}];if !enabled {continue;}let (node,material)=crate::native_hud_panels::payload(p,dimensions,viewport.scalar,dpi,atlas.clone())?;let layer=p.storage.word(0x1a4);
   let bounds=if is_frame {match (node.left,node.top,node.width,node.height) {(Val::Px(x),Val::Px(y),Val::Px(w),Val::Px(h))=>Some(Bounds {slot,rect:[x,y,x+w,y+h]}),_=>return Err("native learning bounds are not pixels".into())}}else {None};
   let record=serde_json::json!({"name":p.name,"path":p.path,"slot":slot,"source_flags":p.storage.flags(),"layer":layer,"uv":material.parameters.uv.to_array(),"color":p.storage.word(0x1dc),"node":format!("{:?},{:?},{:?},{:?}",node.left,node.top,node.width,node.height)});result.push((node,material,record,bounds,80+layer as i32));
  }Ok(result)
 })();let payloads=match result {Ok(v)=>v,Err(e)=>{clear(&mut live,&mut commands,&mut materials);eprintln!("Native learning render unavailable: {e}");return;}};
 clear(&mut live,&mut commands,&mut materials);let mut records=Vec::new();for (node,material,record,bounds,z) in payloads {records.push(record);if let Some(b)=bounds {live.bounds.push(b);}let h=materials.add(material);live.entities.push(commands.spawn((node,MaterialNode(h.clone()),GlobalZIndex(z),Name::new("NativeMap10HudLearning"))).id());live.materials.push(h);}live.signature=Some(signature);live.error=None;
 live.report=Some(serde_json::json!({"complete":false,"champion":player.champion,"player":connection.id,"eligible":allowed,"entities":live.entities.len(),"sources":live.sources.len(),"elements":records,"bounds":live.bounds.iter().map(|b|serde_json::json!({"slot":b.slot,"rect":b.rect})).collect::<Vec<_>>(),"limits":["Native enable/disable selection32cases qualified; current open state derived from supported authoritative progression. Native actor mask producer, expanded panel/fade/glow and original mouse callbacks unqualified.","Annie/Garen plus reconstructed Trundle Q/W/E/R ordinary learning. E terrain/callback and native R presentation parity remain open. Pointer hit boxes use rendered frame rectangles with inclusive left/top and exclusive right/bottom. Native hit semantics/tooltip/rebinding/OS input equivalence remain open.","Ordinary Learn command only; server revalidates progression. Graphical probe clicks are synthetic logical cursor requests, not OS mouse automation."]}));persist(&live);
}
pub(crate) fn action_at(s:&openleague_core::Snapshot,id:u32,bounds:&[Bounds],point:Vec2)->Option<openleague_core::Action> {
 if !point.is_finite() || s.winner.is_some() {return None;}let p=s.players.iter().find(|p|p.id==id)?;let allowed=eligible(p).ok()?;
 bounds.iter().find(|b|b.slot<4 && allowed[b.slot as usize] && point.x>=b.rect[0] && point.y>=b.rect[1] && point.x<b.rect[2] && point.y<b.rect[3]).map(|b|openleague_core::Action::Learn {slot:b.slot})
}
#[cfg(test)]
fn emit(socket:&std::net::UdpSocket,sequence:&mut u64,action:openleague_core::Action)->Result<serde_json::Value,String> {let next=sequence.checked_add(1).ok_or("learning command sequence overflow")?;let packet=openleague_core::ClientPacket::Command {sequence:next,action};let bytes=serde_json::to_vec(&packet).map_err(|e|e.to_string())?;if socket.send(&bytes).map_err(|e|e.to_string())?!=bytes.len() {return Err("learning datagram incomplete".into());}*sequence=next;Ok(serde_json::to_value(packet).unwrap())}
pub(crate) fn queue_probe_click(live:&mut Live,slot:u8)->Result<Vec2,String> {let b=live.bounds.iter().find(|b|b.slot==slot).ok_or("probe learning button not visible")?;let point=Vec2::new((b.rect[0]+b.rect[2])*0.5,(b.rect[1]+b.rect[3])*0.5);live.pending.push(point);Ok(point)}
fn input(game:Res<crate::Match>,mut connection:ResMut<crate::Connection>,window:Query<&Window,With<PrimaryWindow>>,buttons:Res<ButtonInput<MouseButton>>,shop:Res<crate::shop_ui::Filters>,capture:Res<crate::native_hud_inventory::Capture>,minimap:Option<Res<crate::native_minimap::Capture>>,camera:Option<Res<crate::camera_lock_ui::Capture>>,mut live:ResMut<Live>) {
 let point=window.single().ok().and_then(|w|w.cursor_position());live.pointer_hover=point.is_some_and(|p|live.bounds.iter().any(|b|p.x>=b.rect[0] && p.y>=b.rect[1] && p.x<b.rect[2] && p.y<b.rect[3]));
 let mut requests=std::mem::take(&mut live.pending).into_iter().map(|p|(p,"qualification_cursor")).collect::<Vec<_>>();if buttons.just_pressed(MouseButton::Left) {if let Some(p)=point {requests.push((p,"pointer"));}}
 if !minimap.is_some_and(|m|m.blocks_world_pointer()) && !camera.is_some_and(|c|c.blocks_world_pointer()) && !capture.blocks_commands() && !shop.focused && connection.ready() {if let (Some(s),Some(id))=(&game.snapshot,connection.id) {for (point,origin) in requests {if let Some(action)=action_at(s,id,&live.bounds,point) {let result=connection.send_action(action);match result {Ok(packet)=>live.events.push(serde_json::json!({"origin":origin,"point":point.to_array(),"packet":packet,"tick":s.tick})),Err(e)=>eprintln!("Native learning command failed: {e}")}}}}}
 persist(&live);
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn all32_native_enable_branch_cases_match() {let c:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_learning_contract.json")).unwrap();assert_eq!(c["case_count"],32);for a in c["cases"].as_array().unwrap() {let out=flags(a["blocked"].as_bool().unwrap(),a["expanded"].as_bool().unwrap(),a["animating"].as_bool().unwrap());for (i,key) in ["icon","overlay","arrow","frame"].iter().enumerate() {assert_eq!(out[i],a["states"][*key].as_bool().unwrap());}}}
 fn game()->(std::path::PathBuf,openleague_core::Simulation,u32) {let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let nav=openleague_core::Navigation::load(&std::fs::read_to_string(root.join("assets/maps/tt_navigation_grid.json")).unwrap(),&std::fs::read(root.join("assets/maps/tt_navigation_grid.cells.bin")).unwrap()).unwrap();let mut sim=openleague_core::Simulation::new(nav).unwrap();let id=sim.join("annie").unwrap();(root,sim,id)}

 #[test] fn reconstructed_trundle_q_pointer_sends_only_eligible_ordinary_learning() {
  let (root,mut sim,_)=game();let id=sim.join("trundle").unwrap();
  let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();
  let hud=provider.startup_hud(&root).unwrap();let sources=source(&hud).unwrap();
  let frame=sources.iter().find(|p|p.name=="EvolutionArrowFrame0").unwrap();
  let (node,_)=crate::native_hud_panels::payload(frame,[1280,800],1.0,1.0,Handle::default()).unwrap();
  let (Val::Px(x),Val::Px(y),Val::Px(w),Val::Px(h))=(node.left,node.top,node.width,node.height)else{panic!("pixel rectangle required")};
  let center=Vec2::new(x+w/2.,y+h/2.);let bounds=[Bounds{slot:0,rect:[x,y,x+w,y+h]}];
  assert_eq!(eligible(&sim.players[&id]).unwrap(),[true,true,true,false]);
  for slot in 3..4 {let invalid=[Bounds{slot,rect:[x,y,x+w,y+h]}];assert!(action_at(&sim.snapshot(),id,&invalid,center).is_none());}
  assert!(action_at(&sim.snapshot(),id,&bounds,Vec2::new(x+w,y)).is_none());
  assert!(action_at(&sim.snapshot(),id,&bounds,Vec2::new(f32::NAN,y)).is_none());
  let action=action_at(&sim.snapshot(),id,&bounds,center).unwrap();assert!(matches!(action,openleague_core::Action::Learn{slot:0}));
  sim.command(id,action).unwrap();assert_eq!(sim.players[&id].ranks,[1,0,0,0]);
  assert_eq!(eligible(&sim.players[&id]).unwrap(),[false;4]);assert!(action_at(&sim.snapshot(),id,&bounds,center).is_none());
 }


 #[test] fn reconstructed_trundle_w_native_frame_routes_ordinary_learning_and_rejects_disabled_slots() {
  let (root,mut sim,_)=game();let id=sim.join("trundle").unwrap();
  let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();let sources=source(&hud).unwrap();
  let frame=sources.iter().find(|p|p.name=="EvolutionArrowFrame1").unwrap();
  let (node,_)=crate::native_hud_panels::payload(frame,[1280,800],1.0,1.0,Handle::default()).unwrap();
  let (Val::Px(x),Val::Px(y),Val::Px(w),Val::Px(h))=(node.left,node.top,node.width,node.height)else{panic!("pixel rectangle required")};
  let center=Vec2::new(x+w/2.,y+h/2.);let bounds=[Bounds{slot:1,rect:[x,y,x+w,y+h]}];
  assert_eq!(eligible(&sim.players[&id]).unwrap(),[true,true,true,false]);
  assert!(action_at(&sim.snapshot(),999,&bounds,center).is_none());
  for slot in 3..4 {assert!(action_at(&sim.snapshot(),id,&[Bounds{slot,rect:[x,y,x+w,y+h]}],center).is_none());}
  assert!(action_at(&sim.snapshot(),id,&bounds,Vec2::new(x+w,y)).is_none());assert!(action_at(&sim.snapshot(),id,&bounds,Vec2::new(f32::NAN,y)).is_none());
  let action=action_at(&sim.snapshot(),id,&bounds,center).unwrap();assert!(matches!(action,openleague_core::Action::Learn{slot:1}));sim.command(id,action).unwrap();assert_eq!(sim.players[&id].ranks,[0,1,0,0]);
  assert_eq!(eligible(&sim.players[&id]).unwrap(),[false;4]);assert!(action_at(&sim.snapshot(),id,&bounds,center).is_none());assert!(sim.command(id,openleague_core::Action::Learn{slot:1}).is_err());
  sim.players.get_mut(&id).unwrap().level=2;assert!(action_at(&sim.snapshot(),id,&bounds,center).is_none());
  sim.players.get_mut(&id).unwrap().level=3;sim.winner=Some(0);assert!(action_at(&sim.snapshot(),id,&bounds,center).is_none());
 }

 #[test] fn original_button_geometry_and_real_learning_gate_pointer_actions() {let (root,mut sim,id)=game();let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();let sources=source(&hud).unwrap();assert_eq!(sources.len(),8);let frame=sources.iter().find(|p|p.name=="EvolutionArrowFrame2").unwrap();let (node,m)=crate::native_hud_panels::payload(frame,[1280,800],1.0,1.0,Handle::default()).unwrap();assert_eq!(m.parameters.mode.x,0.0);let (Val::Px(x),Val::Px(y),Val::Px(w),Val::Px(h))=(node.left,node.top,node.width,node.height) else {panic!("pixel rectangle required")};let bounds=[Bounds {slot:2,rect:[x,y,x+w,y+h]}];let center=Vec2::new(x+w/2.0,y+h/2.0);assert_eq!(eligible(&sim.players[&id]).unwrap(),[true,true,true,false]);assert!(matches!(action_at(&sim.snapshot(),id,&bounds,center),Some(openleague_core::Action::Learn {slot:2})));assert!(action_at(&sim.snapshot(),id,&bounds,Vec2::new(x+w,y)).is_none());assert!(action_at(&sim.snapshot(),id,&bounds,Vec2::new(f32::NAN,y)).is_none());let action=action_at(&sim.snapshot(),id,&bounds,center).unwrap();sim.command(id,action).unwrap();assert_eq!(sim.players[&id].ranks,[0,0,1,0]);assert_eq!(eligible(&sim.players[&id]).unwrap(),[false;4]);assert!(action_at(&sim.snapshot(),id,&bounds,center).is_none());}
 #[test] fn ordinary_learning_datagram_has_sequence_and_server_revalidates() {let (_,mut sim,id)=game();let receiver=std::net::UdpSocket::bind("127.0.0.1:0").unwrap();receiver.set_read_timeout(Some(std::time::Duration::from_secs(1))).unwrap();let socket=std::net::UdpSocket::bind("127.0.0.1:0").unwrap();socket.connect(receiver.local_addr().unwrap()).unwrap();let mut seq=41;emit(&socket,&mut seq,openleague_core::Action::Learn {slot:2}).unwrap();let mut bytes=[0u8;1024];let n=receiver.recv(&mut bytes).unwrap();let packet:openleague_core::ClientPacket=serde_json::from_slice(&bytes[..n]).unwrap();let openleague_core::ClientPacket::Command {sequence,action}=packet else {panic!("ordinary command")};assert_eq!(sequence,42);sim.command(id,action).unwrap();assert!(sim.command(id,openleague_core::Action::Learn {slot:2}).is_err());assert_eq!(sim.players[&id].ranks,[0,0,1,0]);assert!(emit(&socket,&mut u64::MAX,openleague_core::Action::Learn {slot:0}).is_err());}

 #[test] fn reconstructed_trundle_r_pointer_obeys_levels_and_ordinary_learn_validation() {
  let(root,mut s,_)=game();let id=s.join("trundle").unwrap();s.players.get_mut(&id).unwrap().level=5;
  let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();let sources=source(&hud).unwrap();
  let frame=sources.iter().find(|p|p.name=="EvolutionArrowFrame3").unwrap();let(node,_)=crate::native_hud_panels::payload(frame,[1280,800],1.0,1.0,Handle::default()).unwrap();
  let(Val::Px(x),Val::Px(y),Val::Px(w),Val::Px(h))=(node.left,node.top,node.width,node.height)else{panic!("pixel rectangle required")};let bounds=[Bounds{slot:3,rect:[x,y,x+w,y+h]}];let center=Vec2::new(x+w/2.,y+h/2.);
  assert!(!eligible(&s.players[&id]).unwrap()[3]);assert!(action_at(&s.snapshot(),id,&bounds,center).is_none());s.players.get_mut(&id).unwrap().level=6;
  assert!(eligible(&s.players[&id]).unwrap()[3]);let action=action_at(&s.snapshot(),id,&bounds,center).unwrap();assert!(matches!(action,openleague_core::Action::Learn{slot:3}));s.command(id,action).unwrap();assert_eq!(s.players[&id].ranks[3],1);assert!(action_at(&s.snapshot(),id,&bounds,center).is_none());
  assert!(action_at(&s.snapshot(),999,&bounds,center).is_none());assert!(action_at(&s.snapshot(),id,&bounds,Vec2::new(x+w,y)).is_none());assert!(action_at(&s.snapshot(),id,&bounds,Vec2::new(f32::NAN,y)).is_none());
  s.players.get_mut(&id).unwrap().level=11;assert!(action_at(&s.snapshot(),id,&bounds,center).is_some());s.players.get_mut(&id).unwrap().ranks[0]=5;s.players.get_mut(&id).unwrap().ranks[1]=5;assert!(action_at(&s.snapshot(),id,&bounds,center).is_none());
  s.players.get_mut(&id).unwrap().ranks=[0,0,0,1];assert!(matches!(action_at(&s.snapshot(),id,&[Bounds{slot:2,rect:[x,y,x+w,y+h]}],center),Some(openleague_core::Action::Learn{slot:2})));s.winner=Some(0);assert!(action_at(&s.snapshot(),id,&bounds,center).is_none());
 }
}


#[cfg(test)]
mod trundle_e_learning_tests {
    use super::*;
    #[test]
    fn native_e_frame_learns_five_ranks_and_physical_key_routes_ordinary_ground_command() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
        let nav=openleague_core::Navigation::load(&std::fs::read_to_string(root.join("assets/maps/tt_navigation_grid.json")).unwrap(),&std::fs::read(root.join("assets/maps/tt_navigation_grid.cells.bin")).unwrap()).unwrap();
        let mut sim=openleague_core::Simulation::new(nav).unwrap();let id=sim.join("trundle").unwrap();sim.players.get_mut(&id).unwrap().level=9;
        let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();let sources=source(&hud).unwrap();
        let frame=sources.iter().find(|p|p.name=="EvolutionArrowFrame2").unwrap();let(node,_)=crate::native_hud_panels::payload(frame,[1280,800],1.0,1.0,Handle::default()).unwrap();
        let(Val::Px(x),Val::Px(y),Val::Px(w),Val::Px(h))=(node.left,node.top,node.width,node.height)else{panic!("pixel rectangle required")};
        let bounds=[Bounds{slot:2,rect:[x,y,x+w,y+h]}];let point=Vec2::new(x+w/2.,y+h/2.);
        assert_eq!(crate::native_hud_ranks::maxima("trundle").unwrap(),[Some(5),Some(5),Some(5),Some(3)]);
        for rank in 1..=5 {let action=action_at(&sim.snapshot(),id,&bounds,point).unwrap();assert!(matches!(action,openleague_core::Action::Learn{slot:2}));sim.command(id,action).unwrap();assert_eq!(sim.players[&id].ranks[2],rank);}
        assert!(action_at(&sim.snapshot(),id,&bounds,point).is_none());assert!(sim.command(id,openleague_core::Action::Learn{slot:2}).is_err());
        assert!(action_at(&sim.snapshot(),999,&bounds,point).is_none());assert!(action_at(&sim.snapshot(),id,&bounds,Vec2::new(f32::NAN,y)).is_none());
        sim.players.get_mut(&id).unwrap().ranks[2]=0;assert!(action_at(&sim.snapshot(),id,&bounds,Vec2::new(x+w,y)).is_none());sim.winner=Some(0);assert!(action_at(&sim.snapshot(),id,&bounds,point).is_none());
        let mut keys=ButtonInput::<KeyCode>::default();keys.press(KeyCode::KeyE);let slot=crate::spell_input::pressed_slot(&keys).unwrap();assert_eq!(slot,2);
        assert!(crate::spell_input::ground_target("trundle",slot));assert!(!crate::spell_input::ground_target("trundle",0));assert!(!crate::spell_input::ground_target("trundle",3));
        let target=openleague_core::Point{x:400.,z:500.};let packet=openleague_core::ClientPacket::Command{sequence:42,action:openleague_core::Action::CastAt{slot,point:target}};
        let decoded:openleague_core::ClientPacket=serde_json::from_slice(&serde_json::to_vec(&packet).unwrap()).unwrap();
        assert!(matches!(decoded,openleague_core::ClientPacket::Command{sequence:42,action:openleague_core::Action::CastAt{slot:2,point}}if point==target));
    }
}


#[cfg(test)]
mod ezreal_q_learning_tests {
    use super::*;
    #[test]
    fn original_q_arrow_obeys_five_server_level_gates_and_never_enables_unsupported_slots() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
        let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
        let mut game=openleague_core::Simulation::new(nav).unwrap();let id=game.join("ezreal").unwrap();
        let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();let frames=source(&hud).unwrap();
        let mut bounds=Vec::new();
        for slot in 0..4 {
            let frame=frames.iter().find(|p|p.name==format!("EvolutionArrowFrame{slot}")).unwrap();
            let(node,_)=crate::native_hud_panels::payload(frame,[1280,800],1.,1.,Handle::default()).unwrap();
            let(Val::Px(x),Val::Px(y),Val::Px(w),Val::Px(h))=(node.left,node.top,node.width,node.height)else{panic!("native frame pixels");};
            bounds.push(Bounds{slot,rect:[x,y,x+w,y+h]});
        }
        let q=&bounds[0];let center=Vec2::new((q.rect[0]+q.rect[2])*0.5,(q.rect[1]+q.rect[3])*0.5);
        for rank in 1..=5 {
            let required=2*rank-1;
            if rank>1 {game.players.get_mut(&id).unwrap().level=required-1;let eligibility=eligible(&game.players[&id]).unwrap();assert!(!eligibility[0]);assert_eq!(eligibility[3],required-1>=6);assert!(action_at(&game.snapshot(),id,&bounds,center).is_none());}
            game.players.get_mut(&id).unwrap().level=required;
            assert_eq!(eligible(&game.players[&id]).unwrap(),[true,true,true,required>=6]);
            let action=action_at(&game.snapshot(),id,&bounds,center).unwrap();assert!(matches!(&action,openleague_core::Action::Learn{slot:0}));
            game.command(id,action).unwrap();assert_eq!(game.players[&id].ranks,[rank,0,0,0]);
            assert!(action_at(&game.snapshot(),id,&bounds,center).is_none());
        }
        game.players.get_mut(&id).unwrap().level=18;let eligibility=eligible(&game.players[&id]).unwrap();assert!(!eligibility[0]&&eligibility[3]);
        for b in bounds.iter().skip(3) {
            let p=Vec2::new((b.rect[0]+b.rect[2])*0.5,(b.rect[1]+b.rect[3])*0.5);
            let action=action_at(&game.snapshot(),id,&bounds,p).unwrap();assert!(matches!(&action,openleague_core::Action::Learn{slot:3}));game.command(id,action).unwrap();assert_eq!(game.players[&id].ranks[3],1);
        }
        assert!(action_at(&game.snapshot(),999,&bounds,center).is_none());assert!(action_at(&game.snapshot(),id,&bounds,Vec2::splat(f32::NAN)).is_none());
        assert_eq!(crate::spell_input::hud_labels()[0],"q");assert!(crate::spell_input::ground_target("ezreal",0));
    }
}

#[cfg(test)]
mod ezreal_w_learning_tests {
    use super::*;
    #[test]
    fn original_w_arrow_obeys_five_server_gates_without_enabling_e_r() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
        let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
        let mut game=openleague_core::Simulation::new(nav).unwrap();let id=game.join("ezreal").unwrap();
        let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();let frames=source(&hud).unwrap();
        let frame=frames.iter().find(|panel|panel.name=="EvolutionArrowFrame1").unwrap();
        let(node,_)=crate::native_hud_panels::payload(frame,[1280,800],1.,1.,Handle::default()).unwrap();
        let(Val::Px(x),Val::Px(y),Val::Px(w),Val::Px(h))=(node.left,node.top,node.width,node.height)else{panic!("native frame pixels");};
        let bounds=[Bounds{slot:1,rect:[x,y,x+w,y+h]}];let point=Vec2::new(x+w/2.,y+h/2.);
        for rank in 1..=5 {
            let required=2*rank-1;
            if rank>1 {game.players.get_mut(&id).unwrap().level=required-1;assert!(!eligible(&game.players[&id]).unwrap()[1]);assert!(action_at(&game.snapshot(),id,&bounds,point).is_none());}
            game.players.get_mut(&id).unwrap().level=required;assert!(eligible(&game.players[&id]).unwrap()[1]);
            let action=action_at(&game.snapshot(),id,&bounds,point).unwrap();assert!(matches!(&action,openleague_core::Action::Learn{slot:1}));
            game.command(id,action).unwrap();assert_eq!(game.players[&id].ranks,[0,rank,0,0]);assert!(action_at(&game.snapshot(),id,&bounds,point).is_none());
            assert_eq!(eligible(&game.players[&id]).unwrap()[3],required>=6);
        }
        assert!(crate::spell_input::ground_target("ezreal",1));assert!(crate::spell_input::ground_target("ezreal",2));assert!(crate::spell_input::ground_target("ezreal",3));
    }
}

#[cfg(test)]
mod ezreal_e_learning_tests {
    use super::*;
    #[test]
    fn original_e_arrow_obeys_five_server_gates_with_r_still_unsupported() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
        let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
        let mut game=openleague_core::Simulation::new(nav).unwrap();let id=game.join("ezreal").unwrap();
        let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();let frames=source(&hud).unwrap();
        let frame=frames.iter().find(|panel|panel.name=="EvolutionArrowFrame2").unwrap();
        let(node,_)=crate::native_hud_panels::payload(frame,[1280,800],1.,1.,Handle::default()).unwrap();
        let(Val::Px(x),Val::Px(y),Val::Px(w),Val::Px(h))=(node.left,node.top,node.width,node.height)else{panic!("native frame pixels");};
        let bounds=[Bounds{slot:2,rect:[x,y,x+w,y+h]}];let point=Vec2::new(x+w/2.,y+h/2.);
        for rank in 1..=5 {
            let required=2*rank-1;
            if rank>1 {game.players.get_mut(&id).unwrap().level=required-1;assert!(!eligible(&game.players[&id]).unwrap()[2]);assert!(action_at(&game.snapshot(),id,&bounds,point).is_none());}
            game.players.get_mut(&id).unwrap().level=required;assert!(eligible(&game.players[&id]).unwrap()[2]);
            let action=action_at(&game.snapshot(),id,&bounds,point).unwrap();assert!(matches!(&action,openleague_core::Action::Learn{slot:2}));
            game.command(id,action).unwrap();assert_eq!(game.players[&id].ranks,[0,0,rank,0]);assert!(action_at(&game.snapshot(),id,&bounds,point).is_none());
            assert_eq!(eligible(&game.players[&id]).unwrap()[3],required>=6);
        }
        assert!(crate::spell_input::ground_target("ezreal",1));assert!(crate::spell_input::ground_target("ezreal",2));assert!(crate::spell_input::ground_target("ezreal",3));
    }
}


#[cfg(test)]
mod ezreal_r_learning_tests {
    use super::*;
    #[test]
    fn original_r_arrow_obeys_levels_six_eleven_sixteen_maxrank_and_points() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
        let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
        let mut game=openleague_core::Simulation::new(nav.clone()).unwrap();let id=game.join("ezreal").unwrap();
        let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();let frames=source(&hud).unwrap();
        let frame=frames.iter().find(|panel|panel.name=="EvolutionArrowFrame3").unwrap();let original=frame.storage.bytes().to_vec();
        let(node,_)=crate::native_hud_panels::payload(frame,[1280,800],1.,1.,Handle::default()).unwrap();
        let(Val::Px(x),Val::Px(y),Val::Px(w),Val::Px(h))=(node.left,node.top,node.width,node.height)else{panic!("native R frame pixels");};
        let bounds=[Bounds{slot:3,rect:[x,y,x+w,y+h]}];let point=Vec2::new(x+w/2.,y+h/2.);
        for (rank,required) in [(1,6),(2,11),(3,16)] {
            game.players.get_mut(&id).unwrap().level=required-1;
            assert!(!eligible(&game.players[&id]).unwrap()[3]);assert!(action_at(&game.snapshot(),id,&bounds,point).is_none());
            assert!(game.command(id,openleague_core::Action::Learn{slot:3}).is_err());
            game.players.get_mut(&id).unwrap().level=required;assert!(eligible(&game.players[&id]).unwrap()[3]);
            let action=action_at(&game.snapshot(),id,&bounds,point).unwrap();assert!(matches!(&action,openleague_core::Action::Learn{slot:3}));
            game.command(id,action).unwrap();assert_eq!(game.players[&id].ranks,[0,0,0,rank]);
            assert!(!eligible(&game.players[&id]).unwrap()[3]);assert!(action_at(&game.snapshot(),id,&bounds,point).is_none());
        }
        game.players.get_mut(&id).unwrap().level=18;assert!(!eligible(&game.players[&id]).unwrap()[3]);
        assert!(game.command(id,openleague_core::Action::Learn{slot:3}).is_err());
        assert!(action_at(&game.snapshot(),999,&bounds,point).is_none());assert!(action_at(&game.snapshot(),id,&bounds,Vec2::splat(f32::NAN)).is_none());
        assert!(action_at(&game.snapshot(),id,&bounds,Vec2::new(x+w,y)).is_none());
        let mut spent=openleague_core::Simulation::new(nav).unwrap();let spender=spent.join("ezreal").unwrap();spent.players.get_mut(&spender).unwrap().level=6;
        for slot in 0..3 {for _ in 0..2 {spent.command(spender,openleague_core::Action::Learn{slot}).unwrap();}}
        assert_eq!(spent.players[&spender].ranks,[2,2,2,0]);assert!(!eligible(&spent.players[&spender]).unwrap()[3]);
        assert!(action_at(&spent.snapshot(),spender,&bounds,point).is_none());assert!(spent.command(spender,openleague_core::Action::Learn{slot:3}).is_err());
        assert_eq!(frame.storage.bytes(),original);assert!(crate::spell_input::ground_target("ezreal",3));
    }
}
