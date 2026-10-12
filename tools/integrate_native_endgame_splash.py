from pathlib import Path
import sys,json,hashlib,shutil
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
from PIL import Image
r=Path('E:/OpenLeague');d=json.loads(Path('E:/mapslol3v3/native_endgame_classic_layout.json').read_text());root=Path(d['source']).parent
out=r/'assets/ui/endgame';out.mkdir(parents=True,exist_ok=True);manifest={}
for name,id in [('victory',30),('defeat',16),('victory_idle',22),('victory_hover',25),('victory_down',27),('defeat_idle',7),('defeat_hover',11),('defeat_down',13)]:
 info=d['images'][str(id)];source=root/info['filename'];im=Image.open(source).convert('RGBA');target=out/(name+'.png');im.save(target);manifest[name]=dict(source=str(source),source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),png_sha256=hashlib.sha256(target.read_bytes()).hexdigest(),rect=[0,0,info['width'],info['height']])
for name,row in [('victory_title',3),('defeat_title',1)]:
 source=root.parent/'Menu_SC4'/('assets.eog.'+('victory' if row==3 else 'defeat')+'.fr_FR.dds');im=Image.open(source).convert('RGBA');bounds=im.getchannel('A').crop((0,row*256,1024,(row+1)*256)).getbbox();assert bounds;rect=[bounds[0],bounds[1]+row*256,bounds[2],bounds[3]+row*256];target=out/(name+'.png');im.save(target);manifest[name]=dict(source=str(source),source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),png_sha256=hashlib.sha256(target.read_bytes()).hexdigest(),rect=rect,selection='French word visually inspected in shared multilingual atlas; native locale-to-atlas runtime selector remains unqualified')
d['converted_assets']=manifest;d['limits']+=['Native layout coordinates retained within a centered uniformly scaled splash; original viewport/layout manager behavior not executed.','French title atlas rows selected by visual inspection; native text/image substitution not executed.','Continue dismisses this splash and exposes authoritative local results; engine callback and launcher return remain open.']
(r/'data/4.20/endgame_ui_native.json').write_text(json.dumps(d,indent=2),encoding='utf-8')
shutil.copy2('E:/mapslol3v3/native_endgame_source.json',r/'data/4.20/endgame_lua_source_audit.json')
p=r/'crates/client/src/native_endgame_ui.rs';assert not p.exists()
p.write_text('''//! Original classic 4.20 splash assets/layout. Native engine callback/ceremony remains open.
use bevy::prelude::*;
use crate::{Match,Connection};
#[derive(Resource,Default)] pub struct View {pub session:Option<u64>,pub dismissed:bool,pub armed:bool}
#[derive(Component)] pub struct Splash;
#[derive(Component)] pub struct NativeImage(&'static str);
#[derive(Component)] pub struct Continue;
pub fn setup(mut commands:Commands,assets:Res<AssetServer>){
 commands.spawn((Splash,Node{display:Display::None,position_type:PositionType::Absolute,width:Val::Px(1024.),height:Val::Px(532.),..default()})).with_children(|parent|{
  parent.spawn((NativeImage("background"),ImageNode::new(assets.load("ui/endgame/victory.png")),Node{position_type:PositionType::Absolute,width:Val::Px(1024.),height:Val::Px(512.),..default()}));
  parent.spawn((NativeImage("title"),ImageNode::new(assets.load("ui/endgame/victory_title.png")),Node{position_type:PositionType::Absolute,..default()}));
  parent.spawn((Button,Continue,ImageNode::new(assets.load("ui/endgame/victory_idle.png")),Node{position_type:PositionType::Absolute,left:Val::Px(409.95),top:Val::Px(469.95),width:Val::Px(204.),height:Val::Px(60.),justify_content:JustifyContent::Center,align_items:AlignItems::Center,..default()})).with_children(|parent|{parent.spawn((Text::new("CONTINUER"),TextFont{font:FontSource::Handle(assets.load("fonts/DejaVuSans.ttf")),font_size:FontSize::Px(20.),..default()},TextColor(Color::srgb_u8(255,244,153)),NativeImage("button_label")));});
 });
}
fn local_victory(result:&openleague_core::match_results::MatchResult,id:Option<u32>)->Option<bool>{id.and_then(|id|result.players.iter().find(|p|p.id==id)).map(|p|p.team==result.winner)}
pub fn update(state:Res<Match>,connection:Res<Connection>,mut view:ResMut<View>,assets:Res<AssetServer>,buttons:Res<ButtonInput<MouseButton>>,windows:Query<&Window>,
 mut roots:Query<&mut Node,(With<Splash>,Without<NativeImage>,Without<Continue>)>,
 mut images:Query<(&NativeImage,&mut Node,Option<&mut ImageNode>,Option<&mut TextFont>),(Without<Splash>,Without<Continue>)>,
 mut controls:Query<(&Interaction,&mut Node,&mut ImageNode),(With<Continue>,Without<Splash>,Without<NativeImage>)>){
 let result=state.snapshot.as_ref().and_then(|s|s.result.as_ref());
 if view.session!=result.map(|r|r.session){view.session=result.map(|r|r.session);view.dismissed=false;view.armed=false;}
 let victory=result.and_then(|r|local_victory(r,connection.id));
 let visible=victory.is_some()&&!view.dismissed;
 let window=windows.iter().next();let (w,h)=window.map(|w|(w.width(),w.height())).unwrap_or((1280.,800.));let scale=(w/1024.).min(h/532.).min(1.);
 for mut root in &mut roots {root.display=if visible {Display::Flex}else{Display::None};root.width=Val::Px(1024.*scale);root.height=Val::Px(532.*scale);root.left=Val::Px((w-1024.*scale)/2.);root.top=Val::Px((h-532.*scale)/2.);}
 let outcome=if victory==Some(false){"defeat"}else{"victory"};
 let catalog:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/endgame_ui_native.json")).expect("native UI catalog");
 for (kind,mut node,image,font) in &mut images {
  if let Some(mut image)=image {
   let key=if kind.0=="title"{format!("{outcome}_title")}else{outcome.into()};image.image=assets.load(format!("ui/endgame/{key}.png"));
   let rect=catalog["converted_assets"][&key]["rect"].as_array().expect("native rectangle");let v:Vec<f32>=rect.iter().map(|v|v.as_f64().unwrap() as f32).collect();image.rect=Some(Rect::new(v[0],v[1],v[2],v[3]));
   node.width=Val::Px((v[2]-v[0])*scale);node.height=Val::Px((v[3]-v[1])*scale);
   if kind.0=="title"{node.left=Val::Px((67.+(890.95-(v[2]-v[0]))/2.)*scale);node.top=Val::Px(196.75*scale);}
  }
  if let Some(mut font)=font{font.font_size=FontSize::Px(20.*scale);}
 }
 for (interaction,mut node,mut image) in &mut controls {
  let appearance=match interaction {Interaction::Pressed=>"down",Interaction::Hovered=>"hover",Interaction::None=>"idle"};let key=format!("{outcome}_{appearance}");image.image=assets.load(format!("ui/endgame/{key}.png"));let rect=&catalog["converted_assets"][&key]["rect"];image.rect=Some(Rect::new(0.,0.,rect[2].as_f64().unwrap() as f32,rect[3].as_f64().unwrap() as f32));
  node.left=Val::Px(if outcome=="defeat"{410.95*scale}else{409.95*scale});node.top=Val::Px(469.95*scale);node.width=Val::Px(204.*scale);node.height=Val::Px(60.*scale);
  if visible&&*interaction==Interaction::Pressed{view.armed=true;}
  if buttons.just_released(MouseButton::Left){if visible&&view.armed&&*interaction==Interaction::Hovered{view.dismissed=true;}view.armed=false;}
 }
}
''',encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');s='mod native_endgame_ui;\n'+s;s=s.replace('.init_resource::<Match>()','.init_resource::<Match>()\n        .init_resource::<native_endgame_ui::View>()',1);s=s.replace('                match_results_ui::setup,','                match_results_ui::setup,\n                native_endgame_ui::setup,',1);s=s.replace('.add_systems(Update, match_results_ui::update.after(receive)','.add_systems(Update, native_endgame_ui::update.after(receive).before(match_results_ui::update))\n        .add_systems(Update, match_results_ui::update.after(receive)',1);p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/match_results_ui.rs';s=p.read_text(encoding='utf-8');s=s.replace('pub fn update(state:Res<Match>,','pub fn update(view:Res<crate::native_endgame_ui::View>,state:Res<Match>,');s=s.replace('if result.is_some(){Display::Flex}','if result.is_some() && view.dismissed{Display::Flex}');s=s.replace('app.insert_resource(connection)','app.insert_resource(crate::native_endgame_ui::View{dismissed:true,..default()}).insert_resource(connection)');p.write_text(s,encoding='utf-8')
print('original splash images and Continue dismissal integrated; full ceremony/launcher callback remain open')
