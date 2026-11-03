//! Original pip-bar fraction and divider positions. Champion rank-table population remains open.
use bevy::{prelude::*,ui_render::ui_material::MaterialNode,window::PrimaryWindow};
use crate::{native_hud_panels::Panel,native_hud_element_storage::ElementStorage,native_hud_icon_material::IconMaterial,native_zip_provider::StartupHud};
#[derive(Resource,Default)] struct Live {sources:Vec<Panel>,entities:Vec<Entity>,materials:Vec<Handle<IconMaterial>>,signature:Option<String>,error:Option<String>}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {fn build(&self,app:&mut App) {app.init_resource::<Live>().add_systems(Startup,setup).add_systems(Update,update.after(crate::receive).before(crate::render_probe::capture));}}
pub(crate) fn maxima(champion:&str)->Result<[Option<u8>;4],String> {match champion {"ezreal"=>Ok([Some(5),Some(5),Some(5),Some(3)]),"annie"|"garen"=>Ok([Some(5),Some(5),Some(5),Some(3)]),"trundle"=>Ok([Some(5),Some(5),Some(5),Some(3)]),_=>Err("native champion rank table not yet integrated".into())}}
fn fraction(rank:u8,maximum:u8,width:f32,gap:f32)->Result<Option<f32>,String> {
 if maximum==0 || !width.is_finite() || !gap.is_finite() || gap<0.0 || width<=gap*(maximum.saturating_sub(1)) as f32 {return Err("native pip geometry invalid".into());}
 if rank==0 {return Ok(None);}
 let segment=(width as f64-gap as f64*(maximum-1) as f64)/maximum as f64;
 let gaps=(rank as f32-0.5).max(0.0).min((maximum-1) as f32);
 Ok(Some(((segment*rank as f64+gap as f64*gaps as f64)/width as f64) as f32))
}
fn divider(left:f32,width:f32,gap:f32,maximum:u8,index:u8)->Result<[f32;2],String> {
 if index==0 || index>=maximum {return Err("native divider index invalid".into());}fraction(1,maximum,width,gap)?;
 let segment=((width as f64-gap as f64*(maximum-1) as f64)/maximum as f64) as f32;
 let start=(left as f64+segment as f64*index as f64+gap as f64*(index-1) as f64) as f32;
 let end=(left as f64+segment as f64*index as f64+gap as f64*index as f64) as f32;
 Ok([start,end])
}
fn source(hud:&StartupHud)->Result<Vec<Panel>,String> {
 let mut result=Vec::new();for layout in &hud.shadow_isles_layouts {for record in &layout.structure.accepted {
  let s=&record.element.storage;if s.kind()!=1 {continue;}let name=std::str::from_utf8(s.bytes()[..32].split(|b|*b==0).next().unwrap()).map_err(|_|"pip name encoding")?;
  let selected=(layout.request.ends_with("CenterHUD_PositioningDummies.ini") && matches!(name,"PipBarDummyReference"|"PipDividerDummyReference")) || (layout.request.ends_with("CenterHUD_AbilitiesPipBars.ini") && name.starts_with("PipDivider")) || (0..4).any(|slot|layout.request.ends_with(&format!("CenterHUD_AbilitiesSpell{slot}.ini")) && (name==format!("PipBar{slot}") || name==format!("SpellHotKeyBG{slot}")));
  if selected {let mut storage=ElementStorage::new(1).unwrap();storage.write_bytes(0,s.bytes());result.push(Panel {name:name.into(),path:layout.request.clone(),storage});}
 }}if result.len()!=26 {return Err(format!("native pip sources missing/duplicated: {}",result.len()));}Ok(result)
}
fn setup(hud:Res<StartupHud>,mut live:ResMut<Live>) {match source(&hud) {Ok(v)=>live.sources=v,Err(e)=>{live.error=Some(e.clone());eprintln!("Native rank HUD unavailable: {e}");}}}
fn copy(panel:&Panel)->Panel {let mut storage=ElementStorage::new(1).unwrap();storage.write_bytes(0,panel.storage.bytes());Panel {name:panel.name.clone(),path:panel.path.clone(),storage}}
fn field(p:&Panel,o:usize)->f32 {f32::from_bits(p.storage.word(o))}
fn panels(sources:&[Panel],champion:&str,ranks:[u8;4])->Result<Vec<(Panel,Option<u8>)>,String> {
 let maximum=maxima(champion)?;let find=|name:&str|sources.iter().find(|p|p.name==name).ok_or("native pip source missing".to_string());
 let bar=find("PipBarDummyReference")?;let gap=find("PipDividerDummyReference")?;let width=field(bar,0x1c8)-field(bar,0x1c0);let gap_width=field(gap,0x1c8)-field(gap,0x1c0);
 let mut result=Vec::new();let mut next=0;
 for slot in 0..4 {
  result.push((copy(find(&format!("SpellHotKeyBG{slot}"))?),Some(slot as u8)));
  let Some(maximum)=maximum[slot] else {if ranks[slot]!=0 {return Err("rank on an unsupported slot".into());}continue;};
  if ranks[slot]>maximum {return Err("authoritative rank exceeds supported native scheme".into());}
  let bar=find(&format!("PipBar{slot}"))?;
  if let Some(f)=fraction(ranks[slot],maximum,width,gap_width)? {let mut p=copy(bar);p.storage.set_word(0x1d0,f.to_bits());p.storage.set_word(0x48,p.storage.flags()|1);result.push((p,Some(slot as u8)));}
  for index in 1..maximum {
   let xy=divider(field(bar,0x1c0),width,gap_width,maximum,index)?;let mut p=copy(find(&format!("PipDivider{next}"))?);
   for (offset,value) in [(0x1c0,xy[0]),(0x1c4,field(gap,0x1c4)),(0x1c8,xy[1]),(0x1cc,field(gap,0x1cc))] {p.storage.set_word(offset,value.to_bits());}
   p.storage.set_word(0x48,p.storage.flags()|1);result.push((p,Some(slot as u8)));next+=1;
  }
 }Ok(result)
}
fn clear(live:&mut Live,commands:&mut Commands,materials:&mut Assets<IconMaterial>) {for e in live.entities.drain(..) {commands.entity(e).despawn();}for m in live.materials.drain(..) {materials.remove(m.id());}live.signature=None;}
fn update(mut commands:Commands,game:Res<crate::Match>,connection:Res<crate::Connection>,window:Query<&Window,With<PrimaryWindow>>,viewport:Res<crate::native_hud_viewport::Viewport>,atlases:Res<crate::native_hud_atlases::Atlases>,mut materials:ResMut<Assets<IconMaterial>>,mut live:ResMut<Live>) {
 if live.sources.len()!=26 {return;}let Some(s)=&game.snapshot else {clear(&mut live,&mut commands,&mut materials);return;};let Some(player)=s.players.iter().find(|p|Some(p.id)==connection.id) else {clear(&mut live,&mut commands,&mut materials);return;};let Ok(window)=window.single() else {return;};
 let dimensions=[window.physical_width(),window.physical_height()];let dpi=window.scale_factor();let signature=format!("{}:{:?}:{:?}:{dimensions:?}:{dpi}:{}",player.champion,connection.id,player.ranks,viewport.scalar.to_bits());if live.signature.as_ref()==Some(&signature) {return;}
 let result=(||->Result<Vec<(Node,IconMaterial,serde_json::Value,i32)>,String> {
  let texture=atlases.entries.iter().find(|a|a.normalized.ends_with("/HUDAtlas.dds")).ok_or("native pip atlas missing")?.image.clone();let mut result=Vec::new();
  for (p,slot) in panels(&live.sources,&player.champion,player.ranks)? {let (node,material)=crate::native_hud_panels::payload(&p,dimensions,viewport.scalar,dpi,texture.clone())?;let layer=p.storage.word(0x1a4);let record=serde_json::json!({"name":p.name,"path":p.path,"slot":slot,"fraction":field(&p,0x1d0),"source_flags":p.storage.flags(),"rect":(0..4).map(|i|field(&p,0x1c0+i*4)).collect::<Vec<_>>(),"uv":material.parameters.uv.to_array(),"layer":layer,"node":format!("{:?},{:?},{:?},{:?}",node.left,node.top,node.width,node.height)});result.push((node,material,record,80+layer as i32));}Ok(result)
 })();let payloads=match result {Ok(v)=>v,Err(e)=>{clear(&mut live,&mut commands,&mut materials);if live.error.as_ref()!=Some(&e) {eprintln!("Native rank HUD unavailable: {e}");live.error=Some(e);}return;}};
 clear(&mut live,&mut commands,&mut materials);let mut records=Vec::new();for (node,material,record,z) in payloads {records.push(record);let h=materials.add(material);live.entities.push(commands.spawn((node,MaterialNode(h.clone()),GlobalZIndex(z),Name::new("NativeMap10HudRank"))).id());live.materials.push(h);}live.signature=Some(signature);live.error=None;
 if let Ok(path)=std::env::var("OPENLEAGUE_NATIVE_HUD_RANKS_TRACE") {let report=serde_json::json!({"complete":false,"champion":player.champion,"ranks":player.ranks,"maximum":maxima(&player.champion).unwrap(),"source_count":live.sources.len(),"entities":live.entities.len(),"elements":records,"limits":["Annie/Garen supported; reconstructed Trundle Q/W/E max5 and R max3. Existing native pip assets are reused. Native E terrain/callback, R presentation and full-rank framebuffer parity remain open.","Native pip fractions and divider x positions qualified. Original preceding layout/getters/virtual setters and full framebuffer identity remain unqualified. Hotkey text/input labels, learning buttons and interactions remain open."]});if let Err(e)=std::fs::write(path,serde_json::to_vec_pretty(&report).unwrap()) {eprintln!("Rank HUD trace failed: {e}");}}
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn native_fraction_cases_match_original_x87_sse() {let c:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_ranks_contract.json")).unwrap();assert_eq!(c["fraction_case_count"],364);for a in c["fraction_cases"].as_array().unwrap() {let x=fraction(a["rank"].as_u64().unwrap() as u8,a["maximum"].as_u64().unwrap() as u8,a["width"].as_f64().unwrap() as f32,a["gap"].as_f64().unwrap() as f32).unwrap().unwrap();assert!((x-a["fraction"].as_f64().unwrap() as f32).abs()<1e-6);}assert_eq!(fraction(0,5,0.020625,0.00125).unwrap(),None);}
 #[test] fn native_divider_cases_match_original_x87() {let c:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_ranks_contract.json")).unwrap();assert_eq!(c["divider_case_count"],66);for a in c["divider_cases"].as_array().unwrap() {let xy=divider(a["left"].as_f64().unwrap() as f32,a["width"].as_f64().unwrap() as f32,a["gap"].as_f64().unwrap() as f32,a["maximum"].as_u64().unwrap() as u8,a["index"].as_u64().unwrap() as u8).unwrap();for (i,j) in [(0,0),(1,2)] {let want=a["rect"][j].as_f64().unwrap() as f32;assert!((xy[i]-want).abs()<1e-6f32.max(want.abs()*1e-6));}}}

 #[test] fn reconstructed_trundle_q_learning_uses_existing_native_pip_assets() {
  let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
  let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();
  let hud=provider.startup_hud(&root).unwrap();let sources=source(&hud).unwrap();
  assert_eq!(maxima("trundle").unwrap(),[Some(5),Some(5),Some(5),Some(3)]);
  let nav=openleague_core::Navigation::load(&std::fs::read_to_string(root.join("assets/maps/tt_navigation_grid.json")).unwrap(),&std::fs::read(root.join("assets/maps/tt_navigation_grid.cells.bin")).unwrap()).unwrap();
  let mut sim=openleague_core::Simulation::new(nav).unwrap();let id=sim.join("trundle").unwrap();
  assert_eq!(panels(&sources,"trundle",sim.players[&id].ranks).unwrap().len(),18);
  sim.command(id,openleague_core::Action::Learn{slot:0}).unwrap();
  let updated=panels(&sources,"trundle",sim.players[&id].ranks).unwrap();assert_eq!(updated.len(),19);
  let bar=updated.iter().find(|(p,_)|p.name=="PipBar0").unwrap();
  assert!(field(&bar.0,0x1d0)>0.18 && field(&bar.0,0x1d0)<0.20);
  sim.players.get_mut(&id).unwrap().level=2;sim.command(id,openleague_core::Action::Learn{slot:1}).unwrap();
  let updated=panels(&sources,"trundle",sim.players[&id].ranks).unwrap();assert_eq!(updated.len(),20);let wbar=updated.iter().find(|(p,_)|p.name=="PipBar1").unwrap();assert!(field(&wbar.0,0x1d0)>0.18 && field(&wbar.0,0x1d0)<0.20);
  for slot in 2..4 {assert!(sim.command(id,openleague_core::Action::Learn{slot}).is_err());}
 }

 #[test] fn original_sources_and_real_learning_preserve_native_rank_widgets() {let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();let sources=source(&hud).unwrap();assert_eq!(sources.len(),26);let nav=openleague_core::Navigation::load(&std::fs::read_to_string(root.join("assets/maps/tt_navigation_grid.json")).unwrap(),&std::fs::read(root.join("assets/maps/tt_navigation_grid.cells.bin")).unwrap()).unwrap();let mut sim=openleague_core::Simulation::new(nav).unwrap();let id=sim.join("annie").unwrap();assert_eq!(panels(&sources,"annie",sim.players[&id].ranks).unwrap().len(),18);sim.command(id,openleague_core::Action::Learn {slot:2}).unwrap();let p=panels(&sources,"annie",sim.players[&id].ranks).unwrap();assert_eq!(p.len(),19);let fill=p.iter().find(|(p,_)|p.name=="PipBar2").unwrap();assert!(field(&fill.0,0x1d0)>0.18 && field(&fill.0,0x1d0)<0.20);assert!(maxima("udyr").is_err());for (p,_) in p {let (_,m)=crate::native_hud_panels::payload(&p,[1280,800],1.0,1.0,Handle::default()).unwrap();assert_eq!(m.parameters.mode.x,0.0);}}

 #[test] fn reconstructed_trundle_r_three_native_pips_coexist_with_five_rank_e() {
  let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
  let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();let sources=source(&hud).unwrap();
  assert_eq!(maxima("trundle").unwrap(),[Some(5),Some(5),Some(5),Some(3)]);
  let nav=openleague_core::Navigation::load(&std::fs::read_to_string(root.join("assets/maps/tt_navigation_grid.json")).unwrap(),&std::fs::read(root.join("assets/maps/tt_navigation_grid.cells.bin")).unwrap()).unwrap();
  let mut s=openleague_core::Simulation::new(nav).unwrap();let id=s.join("trundle").unwrap();s.players.get_mut(&id).unwrap().level=16;
  assert_eq!(panels(&sources,"trundle",s.players[&id].ranks).unwrap().len(),18);
  for rank in 1..=3 {s.command(id,openleague_core::Action::Learn{slot:3}).unwrap();assert_eq!(s.players[&id].ranks[3],rank);let p=panels(&sources,"trundle",s.players[&id].ranks).unwrap();let r=p.iter().find(|(p,_)|p.name=="PipBar3").unwrap();assert!(field(&r.0,0x1d0)>0.);if rank==3 {assert_eq!(field(&r.0,0x1d0),1.);}}
  assert!(s.command(id,openleague_core::Action::Learn{slot:3}).is_err());s.command(id,openleague_core::Action::Learn{slot:2}).unwrap();assert_eq!(s.players[&id].ranks[2],1);
  let e=panels(&sources,"trundle",s.players[&id].ranks).unwrap();assert!(e.iter().any(|(p,_)|p.name=="PipBar2"));
  s.players.get_mut(&id).unwrap().ranks[2]=5;assert_eq!(field(&panels(&sources,"trundle",s.players[&id].ranks).unwrap().iter().find(|(p,_)|p.name=="PipBar2").unwrap().0,0x1d0),1.);
  s.players.get_mut(&id).unwrap().ranks[2]=6;assert!(panels(&sources,"trundle",s.players[&id].ranks).is_err());
 }
}



#[cfg(test)]
mod ezreal_q_hud_tests {
    use super::*;
    #[test]
    fn real_ezreal_q_learning_fills_five_native_pips_without_supporting_other_slots() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
        let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
        let mut game=openleague_core::Simulation::new(nav).unwrap();let id=game.join("ezreal").unwrap();
        let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();let sources=source(&hud).unwrap();
        let original=sources.iter().map(|p|p.storage.bytes().to_vec()).collect::<Vec<_>>();
        assert_eq!(maxima("ezreal").unwrap(),[Some(5),Some(5),Some(5),Some(3)]);
        let unlearned=panels(&sources,"ezreal",game.players[&id].ranks).unwrap();assert_eq!(unlearned.len(),18);
        assert_eq!(unlearned.iter().filter(|(p,_)|p.name.starts_with("SpellHotKeyBG")).count(),4);
        for rank in 1..=5 {
            game.players.get_mut(&id).unwrap().level=2*rank-1;
            game.command(id,openleague_core::Action::Learn{slot:0}).unwrap();
            let current=panels(&sources,"ezreal",game.players[&id].ranks).unwrap();assert_eq!(current.len(),19);
            let bar=current.iter().find(|(p,_)|p.name=="PipBar0").unwrap();
            assert!(field(&bar.0,0x1d0)>0.);if rank==5 {assert_eq!(field(&bar.0,0x1d0),1.);}
            assert!(!current.iter().any(|(p,_)|matches!(p.name.as_str(),"PipBar1"|"PipBar2"|"PipBar3")));
            let eligibility=crate::native_hud_learning::eligible(&game.players[&id]).unwrap();assert!(!eligibility[0]);assert_eq!(eligibility[3],game.players[&id].level>=6);
        }
        let mut bad=game.players[&id].ranks;bad[0]=6;assert!(panels(&sources,"ezreal",bad).is_err());
        for slot in 3..=3 {let mut bad=game.players[&id].ranks;bad[slot]=4;assert!(panels(&sources,"ezreal",bad).is_err());}
        for (panel,bytes) in sources.iter().zip(original) {assert_eq!(panel.storage.bytes(),bytes);}
    }
}

#[cfg(test)]
mod ezreal_w_hud_tests {
    use super::*;
    #[test]
    fn real_ezreal_w_learning_fills_native_pips_with_q_preserved_and_e_r_unsupported() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
        let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
        let mut game=openleague_core::Simulation::new(nav).unwrap();let id=game.join("ezreal").unwrap();
        let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();let sources=source(&hud).unwrap();
        let original=sources.iter().map(|panel|panel.storage.bytes().to_vec()).collect::<Vec<_>>();
        assert_eq!(maxima("ezreal").unwrap(),[Some(5),Some(5),Some(5),Some(3)]);
        for rank in 1..=5 {
            game.players.get_mut(&id).unwrap().level=2*rank-1;game.command(id,openleague_core::Action::Learn{slot:1}).unwrap();
            let current=panels(&sources,"ezreal",game.players[&id].ranks).unwrap();
            let bar=current.iter().find(|(panel,_)|panel.name=="PipBar1").unwrap();assert!(field(&bar.0,0x1d0)>0.);
            if rank==5 {assert_eq!(field(&bar.0,0x1d0),1.);}
            assert!(!current.iter().any(|(panel,_)|matches!(panel.name.as_str(),"PipBar0"|"PipBar2"|"PipBar3")));
        }
        for slot in [3] {let mut bad=game.players[&id].ranks;bad[slot]=4;assert!(panels(&sources,"ezreal",bad).is_err());}
        for(panel,raw)in sources.iter().zip(original) {assert_eq!(panel.storage.bytes(),raw);}
    }
}

#[cfg(test)]
mod ezreal_e_hud_tests {
    use super::*;
    #[test]
    fn real_ezreal_e_learning_fills_native_pips_with_q_w_preserved_and_r_unsupported() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
        let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
        let mut game=openleague_core::Simulation::new(nav).unwrap();let id=game.join("ezreal").unwrap();
        let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();let sources=source(&hud).unwrap();
        let original=sources.iter().map(|panel|panel.storage.bytes().to_vec()).collect::<Vec<_>>();
        assert_eq!(maxima("ezreal").unwrap(),[Some(5),Some(5),Some(5),Some(3)]);
        for rank in 1..=5 {
            game.players.get_mut(&id).unwrap().level=2*rank-1;game.command(id,openleague_core::Action::Learn{slot:2}).unwrap();
            let current=panels(&sources,"ezreal",game.players[&id].ranks).unwrap();
            let bar=current.iter().find(|(panel,_)|panel.name=="PipBar2").unwrap();assert!(field(&bar.0,0x1d0)>0.);
            if rank==5 {assert_eq!(field(&bar.0,0x1d0),1.);}
            assert!(!current.iter().any(|(panel,_)|matches!(panel.name.as_str(),"PipBar0"|"PipBar1"|"PipBar3")));
        }
        for slot in [3] {let mut bad=game.players[&id].ranks;bad[slot]=4;assert!(panels(&sources,"ezreal",bad).is_err());}
        for(panel,raw)in sources.iter().zip(original) {assert_eq!(panel.storage.bytes(),raw);}
    }
}


#[cfg(test)]
mod ezreal_r_hud_tests {
    use super::*;
    #[test]
    fn real_ezreal_r_learning_fills_three_native_pips_and_preserves_q_w_e() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
        let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
        let mut game=openleague_core::Simulation::new(nav).unwrap();let id=game.join("ezreal").unwrap();
        let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();let sources=source(&hud).unwrap();
        let original=sources.iter().map(|panel|panel.storage.bytes().to_vec()).collect::<Vec<_>>();
        assert_eq!(maxima("ezreal").unwrap(),[Some(5),Some(5),Some(5),Some(3)]);
        assert_eq!(panels(&sources,"ezreal",game.players[&id].ranks).unwrap().len(),18);
        game.players.get_mut(&id).unwrap().level=6;
        for slot in 0..3 {game.command(id,openleague_core::Action::Learn{slot}).unwrap();}
        let before=panels(&sources,"ezreal",game.players[&id].ranks).unwrap();
        let qwe=(0..3).map(|slot|field(&before.iter().find(|(p,_)|p.name==format!("PipBar{slot}")).unwrap().0,0x1d0)).collect::<Vec<_>>();
        let mut previous=0.;
        for (rank,level) in [(1,6),(2,11),(3,16)] {
            game.players.get_mut(&id).unwrap().level=level;
            game.command(id,openleague_core::Action::Learn{slot:3}).unwrap();assert_eq!(game.players[&id].ranks,[1,1,1,rank]);
            let current=panels(&sources,"ezreal",game.players[&id].ranks).unwrap();assert_eq!(current.len(),22);
            let r=current.iter().find(|(p,_)|p.name=="PipBar3").unwrap();let fill=field(&r.0,0x1d0);
            assert!(fill>previous&&fill<=1.);previous=fill;if rank==3 {assert_eq!(fill,1.);}
            assert_eq!(current.iter().filter(|(p,slot)|*slot==Some(3)&&p.name.starts_with("PipDivider")).count(),2);
            for slot in 0..3 {
                assert_eq!(field(&current.iter().find(|(p,_)|p.name==format!("PipBar{slot}")).unwrap().0,0x1d0),qwe[slot]);
                assert_eq!(current.iter().filter(|(p,s)|*s==Some(slot as u8)&&p.name.starts_with("PipDivider")).count(),4);
            }
        }
        assert!(game.command(id,openleague_core::Action::Learn{slot:3}).is_err());
        let mut corrupt=game.players[&id].ranks;corrupt[3]=4;assert!(panels(&sources,"ezreal",corrupt).is_err());
        for(panel,bytes)in sources.iter().zip(original){assert_eq!(panel.storage.bytes(),bytes);}
    }
}
