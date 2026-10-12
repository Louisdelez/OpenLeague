//! Eighteen original map10 Text widgets, fed by authoritative OpenLeague snapshots.
//! Snapshot value formatting is engine-owned; original formatter/clip matrix remain open.
use bevy::{prelude::*,asset::RenderAssetUsages,render::render_resource::{Extent3d,TextureDimension,TextureFormat},ui_render::ui_material::MaterialNode,window::PrimaryWindow};
use crate::{native_font_gpu::{FontMaterial,Pages},native_font_metrics::Faces,native_hud_font_creation::Sizes,native_hud_element_storage::ElementStorage,native_zip_provider::StartupHud};
struct Widget {name:String,path:String,binding:usize,storage:ElementStorage}
#[derive(Resource,Default)] pub struct Live {widgets:Vec<Widget>,fill:Handle<Image>,entities:Vec<Entity>,materials:Vec<Handle<FontMaterial>>,signature:Option<String>,last_error:Option<String>,pub rebuilds:u64}
impl Live {pub fn healthy(&self)->bool {self.last_error.is_none() && !self.entities.is_empty()}}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {fn build(&self,app:&mut App) {app.init_resource::<Live>().add_systems(Startup,setup).add_systems(Update,update.after(crate::receive).after(crate::native_font_metrics::MetricsSet).before(crate::render_probe::capture));}}
fn load(hud:&StartupHud)->Result<Vec<Widget>,String> {
    let mut widgets=Vec::new();let mut binding=0;
    for layout in &hud.shadow_isles_layouts {for record in &layout.structure.accepted {
        let storage=&record.element.storage;if storage.kind()!=3 {continue}
        let name=storage.bytes()[..32].split(|b|*b==0).next().unwrap();
        if (name.starts_with(b"SummonerSpell") && (0..2).any(|slot|layout.request.ends_with(&format!("CenterHUD_AbilitiesSpellSummoner{slot}.ini")) && (name==format!("SummonerSpellHotKey{slot}").as_bytes() || name==format!("SummonerSpellCooldown{slot}").as_bytes()))) || (name.starts_with(b"SpellHotKey") && (0..4).any(|slot|layout.request.ends_with(&format!("CenterHUD_AbilitiesSpell{slot}.ini")) && name==format!("SpellHotKey{slot}").as_bytes())) || (layout.request.ends_with("ShadowIslesChampionLeft.ini") && (name==b"GoldStat" || name==b"LevelStat" || name==b"RespawnTimer")) || (layout.request.ends_with("ShadowIslesTitanBar.ini") && name==b"GameTime") || (layout.request.ends_with("CenterHUD_HealthBar.ini") && name==b"HPStat") || (layout.request.ends_with("CenterHUD_PARBar.ini") && name==b"MPStat") || (name.starts_with(b"SpellCooldown") && (0..4).any(|slot|layout.request.ends_with(&format!("CenterHUD_AbilitiesSpell{slot}.ini")) && name==format!("SpellCooldown{slot}").as_bytes())) {
            let mut owned=ElementStorage::new(3).map_err(str::to_owned)?;owned.write_bytes(0,storage.bytes());owned.set_word(0x200,binding as u32+1);
            widgets.push(Widget {name:String::from_utf8(name.to_vec()).map_err(|_|"source widget name encoding")?,path:layout.request.clone(),binding,storage:owned});
        }binding+=1;
    }}
    if widgets.len()!=18 {return Err("original eighteen HUD Text definitions missing or duplicated".into())}Ok(widgets)
}
fn setup(hud:Res<StartupHud>,mut live:ResMut<Live>,mut images:ResMut<Assets<Image>>) {
    match load(&hud) {Ok(widgets)=>live.widgets=widgets,Err(e)=>{live.last_error=Some(e.clone());eprintln!("Native HUD widgets unavailable: {e}");return}}
    let mut white=Image::new(Extent3d {width:1,height:1,depth_or_array_layers:1},TextureDimension::D2,vec![255;4],TextureFormat::Rgba8Unorm,RenderAssetUsages::MAIN_WORLD|RenderAssetUsages::RENDER_WORLD);white.sampler=crate::native_font_material::sampler(1,false).unwrap();live.fill=images.add(white);
}
pub fn snapshot_values(snapshot:&openleague_core::Snapshot,id:Option<u32>)->Result<Option<std::collections::BTreeMap<String,String>>,String> { snapshot_values_with_mode(snapshot,id,1) }
pub fn snapshot_values_with_mode(snapshot:&openleague_core::Snapshot,id:Option<u32>,mode:i32)->Result<Option<std::collections::BTreeMap<String,String>>,String> {
    let Some(player)=snapshot.players.iter().find(|p|Some(p.id)==id) else {return Ok(None)};
    if !player.gold.is_finite() || player.gold<0.0 || player.gold as f64>u32::MAX as f64 {return Err("HUD authoritative gold outside supported unsigned32 range".into())}
    let seconds=snapshot.tick/openleague_core::TICK_RATE;
    let health_counter=crate::native_hud_pool_numbers::health_number;
    let counter=crate::native_hud_pool_numbers::mana_number;
    let bars=crate::native_hud_bars::values(snapshot,id)?.ok_or("authoritative player disappeared")?;
    let mut values=std::collections::BTreeMap::from([("GameTime".into(),format!("{}:{:02}",seconds/60,seconds%60)),("GoldStat".into(),format!("{}",player.gold.floor() as u32)),("LevelStat".into(),player.level.to_string()),("HPStat".into(),format!("{} / {}",health_counter(player.health)?,health_counter(player.max_health)?))]);
    if bars.kind=="Mana" {values.insert("MPStat".into(),format!("{} / {}",counter(player.mana)?,counter(player.max_mana.ok_or("authoritative mana capacity missing")?)?));}
    for slot in 0..4 {let seconds=player.cooldowns[slot].saturating_sub(snapshot.tick) as f32/openleague_core::TICK_RATE as f32;if let Some(text)=crate::native_hud_cooldown_text::format(seconds,mode)? {values.insert(format!("SpellCooldown{slot}"),text);}}
    for (slot,label) in crate::spell_input::hud_labels().into_iter().enumerate() {values.insert(format!("SpellHotKey{slot}"),label);}
    for (slot,label) in crate::native_hud_summoners::labels()?.into_iter().enumerate() {values.insert(format!("SummonerSpellHotKey{slot}"),label);if player.summoners.spells[slot].is_some() {let seconds=player.summoners.ready_at[slot].saturating_sub(snapshot.tick) as f32/openleague_core::TICK_RATE as f32;if let Some(text)=crate::native_hud_cooldown_text::format(seconds,mode)? {values.insert(format!("SummonerSpellCooldown{slot}"),text);}}}
    if let Some(text)=crate::native_hud_respawn::countdown(snapshot,id) {values.insert("RespawnTimer".into(),text);}
    Ok(Some(values))
}
fn clear(live:&mut Live,commands:&mut Commands,materials:&mut Assets<FontMaterial>) {for entity in live.entities.drain(..) {commands.entity(entity).despawn();}for material in live.materials.drain(..) {materials.remove(material.id());}live.signature=None;}
fn update(mut commands:Commands,state:Res<crate::Match>,connection:Res<crate::Connection>,window:Query<&Window,With<PrimaryWindow>>,viewport:Res<crate::native_hud_viewport::Viewport>,sizes:Res<Sizes>,settings:Res<crate::native_user_settings::Loaded>,mut faces:NonSendMut<Faces>,mut pages:ResMut<Pages>,mut images:ResMut<Assets<Image>>,mut materials:ResMut<Assets<FontMaterial>>,mut live:ResMut<Live>) {
    if live.widgets.len()!=18 {return}
    let Some(snapshot)=&state.snapshot else {clear(&mut live,&mut commands,&mut materials);return};
    let cooldown_mode=match crate::native_hud_cooldown_text::mode(&settings) {Ok(v)=>v,Err(e)=>{clear(&mut live,&mut commands,&mut materials);eprintln!("Cooldown setting unavailable: {e}");return;}};
    let mut values=match snapshot_values_with_mode(snapshot,connection.id,cooldown_mode) {Ok(Some(v))=>v,Ok(None)=>{clear(&mut live,&mut commands,&mut materials);return},Err(e)=>{clear(&mut live,&mut commands,&mut materials);if live.last_error.as_ref()!=Some(&e) {eprintln!("Native HUD values unavailable: {e}");live.last_error=Some(e)}return}};
    if !connection.ready() || connection.session!=Some(snapshot.session) {values.remove("RespawnTimer");}
    let Ok(window)=window.single() else {return};let dimensions=[window.physical_width(),window.physical_height()];if sizes.height!=Some(dimensions[1]) || faces.height!=sizes.height {return}
    let signature=format!("{}:{:?}:{dimensions:?}:{:?}:{}:{values:?}",snapshot.session,connection.id,faces.dpi,viewport.scalar.to_bits());if live.signature.as_ref()==Some(&signature) {return}
    let result=(||->Result<Vec<(Node,FontMaterial)>,String> {
        for widget in &mut live.widgets {if widget.name=="RespawnTimer" {let flags=widget.storage.flags()&!1;widget.storage.set_word(0x48,flags|u32::from(values.contains_key(&widget.name)));}if (widget.name.starts_with("SpellCooldown") || widget.name.starts_with("SummonerSpellCooldown")) {widget.storage.set_word(0x48,if values.contains_key(&widget.name) {1}else {0});}let Some(text)=values.get(&widget.name) else {continue;};let text=text.as_bytes();if text.len()>255 {return Err("HUD value exceeds original capacity".into())}let mut bytes=[0u8;256];bytes[..text.len()].copy_from_slice(text);widget.storage.write_bytes(0x20c,&bytes);}
        let bindings=live.widgets.iter().map(|w|(w.binding as u32+1,w.binding)).collect::<std::collections::BTreeMap<_,_>>();let mut storages=live.widgets.iter_mut().filter(|w|values.contains_key(&w.name)).map(|w|&mut w.storage).collect::<Vec<_>>();
        let batch=crate::native_hud_text_batch::from_elements(&mut storages,dimensions,viewport.scalar,0,[1.0,1.0,0.0,0.0]).map_err(str::to_owned)?;
        let prepared=crate::native_hud_text_render::prepare(&mut faces,&sizes,&batch,&crate::native_hud_text_render::Context {viewport:dimensions,packet_scalar:viewport.scalar,glyph_owner_scale:1.0},&bindings,|text|if text.is_ascii() {Ok(text.iter().map(|b|*b as u16).collect())}else {Err("numeric HUD values require ASCII".into())})?;
        if !prepared.copy_errors.is_empty() {return Err("HUD native text copy failed".into())}
        pages.sync(&faces,&sizes,&mut images)?;crate::native_hud_text_render::projected_ui_payloads(&prepared,&faces,&sizes,&pages,live.fill.clone(),Vec2::splat(0.5))
    })();
    let payloads=match result {Ok(v)=>v,Err(e)=>{clear(&mut live,&mut commands,&mut materials);if live.last_error.as_ref()!=Some(&e) {eprintln!("Native HUD widget rendering unavailable: {e}");live.last_error=Some(e)}return}};
    clear(&mut live,&mut commands,&mut materials);let rects=payloads.iter().map(|(n,_)|format!("{:?},{:?},{:?},{:?}",n.left,n.top,n.width,n.height)).collect::<Vec<_>>();
    for (node,material) in payloads {let handle=materials.add(material);live.entities.push(commands.spawn((node,MaterialNode(handle.clone()),GlobalZIndex(100),Name::new("NativeMap10HudGlyph"))).id());live.materials.push(handle);}
    live.signature=Some(signature);live.last_error=None;live.rebuilds+=1;
    if let Ok(path)=std::env::var("OPENLEAGUE_NATIVE_HUD_TRACE") {
        let sources=live.widgets.iter().map(|w|serde_json::json!({"name":w.name,"path":w.path,"source_text_binding":w.binding,"alignment":w.storage.word(0x208),"packed_color":w.storage.word(0x1dc),"active":values.contains_key(&w.name)})).collect::<Vec<_>>();
        let report=serde_json::json!({"tick":snapshot.tick,"player":connection.id,"cooldown_mode":cooldown_mode,"values":values,"viewport":dimensions,"rebuilds":live.rebuilds,"glyph_entities":live.entities.len(),"material_assets":live.materials.len(),"total_font_material_assets":materials.len(),"window_scale_factor":window.scale_factor(),"sources":sources,"glyph_nodes":rects,"complete":false,"limits":["Eighteen source Text widgets including D/F labels and remaining time; HP ceil qualified against original CRT positive fast path; MP floor qualified against original SSE positive ordinary-pool conversion and mana text hidden for non-mana champions. Original formatter, base clip matrix and original framebuffer equivalence pending. Engine numeric ASCII formatter, white fill, positive packet scale and viewport offset0.5 explicit."]});
        if let Err(e)=std::fs::write(path,serde_json::to_vec_pretty(&report).unwrap()) {eprintln!("Native HUD trace failed: {e}");}
    }
}
#[cfg(test)] mod tests {
    // Exercises real simulation operations and the bounded state transport before HUD conversion.
    // This is not a GPU capture or a qualification of original LoL numeric formatting.
    #[test]
    fn health_and_mana_hud_follow_simulation_lifecycle_through_state_transport() {
        use openleague_core::{Action, ServerPacket, Snapshot, Simulation, Navigation, damage::DamageKind};
        fn received(sim:&Simulation)->Snapshot {
            let snapshot=sim.snapshot();
            let mut assembler=openleague_core::wire::StateAssembler::default();
            let mut received=None;
            for bytes in openleague_core::wire::state_datagrams(&snapshot).unwrap() {
                assert!(bytes.len()<=1200);
                if let Some(packet)=assembler.push(&bytes,Some(snapshot.session)) {received=Some(packet);}
            }
            let ServerPacket::State(snapshot)=serde_json::from_slice(&received.unwrap()).unwrap() else {panic!("expected state")};
            snapshot
        }
        fn check(sim:&Simulation,id:u32)->(std::collections::BTreeMap<String,String>,crate::native_hud_bars::Values) {
            let snapshot=received(sim);
            let p=snapshot.players.iter().find(|p|p.id==id).unwrap();
            let texts=snapshot_values(&snapshot,Some(id)).unwrap().unwrap();
            let bars=crate::native_hud_bars::values(&snapshot,Some(id)).unwrap().unwrap();
            assert_eq!(texts["HPStat"],format!("{} / {}",p.health.ceil() as i32,p.max_health.ceil() as i32));
            assert_eq!(texts["LevelStat"],p.level.to_string());
            assert_eq!(texts["GoldStat"],(p.gold.floor() as u32).to_string());
            assert_eq!(bars.health,(p.health.ceil()/p.max_health.ceil()).clamp(0.0,1.0));
            if bars.kind=="Mana" {
                let cap=sim.stats(id).max_mana;
                assert_eq!(p.max_mana,Some(cap));
                assert_eq!(texts["MPStat"],format!("{} / {}",p.mana.floor() as u32,cap.floor() as u32));
                assert_eq!(bars.resource,Some((p.mana.floor()/cap.floor()).clamp(0.0,1.0)));
            } else {assert!(!texts.contains_key("MPStat"));assert_eq!(bars.resource,None);}
            (texts,bars)
        }
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
        let navigation=Navigation::load(&std::fs::read_to_string(root.join("assets/maps/tt_navigation_grid.json")).unwrap(),&std::fs::read(root.join("assets/maps/tt_navigation_grid.cells.bin")).unwrap()).unwrap();
        let mut sim=Simulation::new(navigation).unwrap();
        let a=sim.join("annie").unwrap();let g=sim.join("garen").unwrap();
        let (start,_)=check(&sim,a);check(&sim,g);
        let cap=sim.stats(a).max_mana;
        sim.command(a,Action::Buy{item:1027}).unwrap();
        let (purchase,bars)=check(&sim,a);
        assert_ne!(start["GoldStat"],purchase["GoldStat"]);assert!(sim.stats(a).max_mana>cap);
        assert!(bars.resource.unwrap()<1.0);
        sim.command(a,Action::Learn{slot:2}).unwrap();
        let mana=sim.players[&a].mana;
        sim.command(a,Action::Cast{slot:2,target:None}).unwrap();
        assert!(sim.players[&a].mana<mana);
        let (cast,cast_bars)=check(&sim,a);assert_ne!(cast["MPStat"],purchase["MPStat"]);
        sim.apply_damage(Some(g),a,150.0,DamageKind::True).unwrap();
        let (hurt,hurt_bars)=check(&sim,a);assert_ne!(hurt["HPStat"],cast["HPStat"]);assert!(hurt_bars.health<1.0);
        let hp=sim.players[&a].health;let mana=sim.players[&a].mana;
        for _ in 0..openleague_core::TICK_RATE {sim.advance();}
        assert!(sim.players[&a].health>hp);assert!(sim.players[&a].mana>mana);
        let (_,regen_bars)=check(&sim,a);assert!(regen_bars.health>hurt_bars.health);assert!(regen_bars.resource>cast_bars.resource);
        sim.heal(Some(a),a,sim.players[&a].max_health).unwrap();
        assert_eq!(check(&sim,a).1.health,1.0);
        sim.award_experience(a,1000.0).unwrap();
        let (grown,_)=check(&sim,a);assert_ne!(grown["LevelStat"],start["LevelStat"]);assert!(sim.stats(a).max_mana>cap);
        sim.apply_damage(Some(g),a,100000.0,DamageKind::True).unwrap();
        assert_eq!(check(&sim,a).1.health,0.0);
        let respawn=sim.players[&a].respawn_at.expect("lethal damage schedules respawn");
        while sim.tick<=respawn {sim.advance();}
        let (_,respawn_bars)=check(&sim,a);assert_eq!(respawn_bars.health,1.0);assert_eq!(respawn_bars.resource,Some(1.0));
        assert_eq!(check(&sim,g).1.resource,None);
    }

    use super::*;
    #[test] fn exact_source_widgets_bind_original_styles_and_font_request_order() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();let widgets=load(&hud).unwrap();assert_eq!(widgets.len(),18);
        for widget in &widgets {assert!(widget.binding<154);assert_eq!(widget.storage.flags(),if matches!(widget.name.as_str(),"HPStat"|"MPStat") {0x11}else if widget.name=="RespawnTimer" {0x10}else if (widget.name.starts_with("SpellCooldown") || widget.name.starts_with("SummonerSpellCooldown")) {0}else {1});assert_eq!(widget.storage.word(0x208),1);assert_eq!(widget.storage.word(0x200),widget.binding as u32+1);}
        assert_eq!(widgets.iter().find(|w|w.name=="GoldStat").unwrap().storage.word(0x1dc),0xfffff799);assert_eq!(widgets.iter().find(|w|w.name=="LevelStat").unwrap().storage.word(0x1dc),0xc8ffffff);
        let timer=widgets.iter().find(|w|w.name=="RespawnTimer").unwrap();assert_eq!(timer.storage.word(0x204),30);assert_eq!(timer.storage.word(0x1dc),0xffffffff);let requests=hud.source_font_requests().unwrap();assert_eq!(requests[timer.binding].size,30);assert!(requests[timer.binding].shadow);
    }
    #[test] fn health_mana_numbers_follow_real_snapshots_and_absence_never_becomes_zero_capacity() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let navigation=openleague_core::Navigation::load(&std::fs::read_to_string(root.join("assets/maps/tt_navigation_grid.json")).unwrap(),&std::fs::read(root.join("assets/maps/tt_navigation_grid.cells.bin")).unwrap()).unwrap();let mut simulation=openleague_core::Simulation::new(navigation).unwrap();let a=simulation.join("ahri").unwrap();let g=simulation.join("garen").unwrap();let mut snapshot=simulation.snapshot();
        let values=snapshot_values(&snapshot,Some(g)).unwrap().unwrap();assert!(values.contains_key("HPStat"));assert!(!values.contains_key("MPStat"));
        let p=snapshot.players.iter_mut().find(|p|p.id==a).unwrap();p.health=123.75;p.max_health=456.5;p.mana=12.5;p.max_mana=Some(300.25);let values=snapshot_values(&snapshot,Some(a)).unwrap().unwrap();assert_eq!(values["HPStat"],"124 / 457");assert_eq!(values["MPStat"],"12 / 300");
        let p=snapshot.players.iter_mut().find(|p|p.id==a).unwrap();p.max_mana=None;assert!(snapshot_values(&snapshot,Some(a)).is_err());let p=snapshot.players.iter_mut().find(|p|p.id==a).unwrap();p.max_mana=Some(300.25);p.health=f32::NAN;assert!(snapshot_values(&snapshot,Some(a)).is_err());
    }
    #[test] fn authoritative_snapshot_values_follow_gold_level_time_and_missing_player() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let navigation=openleague_core::Navigation::load(&std::fs::read_to_string(root.join("assets/maps/tt_navigation_grid.json")).unwrap(),&std::fs::read(root.join("assets/maps/tt_navigation_grid.cells.bin")).unwrap()).unwrap();let mut simulation=openleague_core::Simulation::new(navigation).unwrap();let id=simulation.join("garen").unwrap();simulation.tick=61*openleague_core::TICK_RATE;let player=simulation.players.get_mut(&id).unwrap();player.gold=1234.75;player.level=7;let mut snapshot=simulation.snapshot();let values=snapshot_values(&snapshot,Some(id)).unwrap().unwrap();assert_eq!(values["GameTime"],"1:01");assert_eq!(values["GoldStat"],"1234");assert_eq!(values["LevelStat"],"7");assert_eq!(snapshot_values(&snapshot,None).unwrap(),None);snapshot.players[0].gold=f32::NAN;assert!(snapshot_values(&snapshot,Some(id)).is_err());
    }
}
