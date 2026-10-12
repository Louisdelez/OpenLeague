//! Six original Map10 item slots, fed by authoritative inventory snapshots.
//! Original DDS bytes/layout/text transport; inventory binding is local policy.
//! Local drag gesture is separate from native data; no native input/full framebuffer claim.
use bevy::{prelude::*, asset::RenderAssetUsages, image::CompressedImageFormats,
    render::{renderer::RenderDevice,render_resource::{Extent3d,TextureDimension,TextureFormat}},
    ui_render::ui_material::MaterialNode, window::PrimaryWindow};
use std::collections::BTreeMap;
#[path="native_hud_inventory_drag.rs"]
mod drag;
pub(crate) use drag::{Capture,InputSet};
use crate::{native_zip_provider::StartupHud,native_hud_panels::Panel,
    native_hud_element_storage::ElementStorage,native_hud_icon_material::IconMaterial,
    native_font_gpu::{FontMaterial,Pages},native_font_metrics::Faces,native_hud_font_creation::Sizes};

#[derive(Debug,Clone,Copy,PartialEq,Eq)]
struct Slot { item:u32, count:u8, stackable:bool }
fn values(snapshot:&openleague_core::Snapshot,id:Option<u32>)->Result<Option<[Option<Slot>;6]>,String> {
    let Some(player)=snapshot.players.iter().find(|p|Some(p.id)==id) else {return Ok(None);};
    let mut slots=[None;6];
    for (index,item) in player.inventory.iter().enumerate() {
        let Some(item)=item else {continue;};
        let entry=openleague_core::shop::catalog().iter().find(|entry|entry.id==*item)
            .ok_or_else(||format!("inventory icon unavailable for unsupported item {item}"))?;
        let count=openleague_core::shop::inventory_count(player,index);
        let stackable=entry.consumable.is_some() && entry.max_stack>1;
        if count>(if stackable {entry.max_stack} else {1}) {return Err("invalid authoritative inventory quantity".into());}
        slots[index]=Some(Slot {item:*item,count,stackable});
    }
    Ok(Some(slots))
}
fn count_text(slot:Option<Slot>)->Option<String> {slot.filter(|s|s.stackable).map(|s|s.count.to_string())}
fn copy_storage(source:&ElementStorage)->ElementStorage {
    let mut out=ElementStorage::new(source.kind()).expect("validated source kind");out.write_bytes(0,source.bytes());out
}
struct CountSource { slot:usize, binding:usize, storage:ElementStorage }
fn sources(hud:&StartupHud)->Result<(Vec<Panel>,Vec<CountSource>),String> {
    let mut icons=BTreeMap::new();let mut counts=BTreeMap::new();let mut binding=0;
    for layout in &hud.shadow_isles_layouts {for record in &layout.structure.accepted {
        let storage=&record.element.storage;
        let text_binding=binding;if storage.kind()==3 {binding+=1;}
        if !layout.request.ends_with("ShadowIslesChampionLeft.ini") {continue;}
        let name=std::str::from_utf8(storage.bytes()[..32].split(|b|*b==0).next().unwrap()).map_err(|_|"inventory source name encoding")?;
        for slot in 0..6 {
            if name==format!("InventoryItem{slot}") {
                if storage.kind()!=1 || storage.bytes()[0x1e0..0x200].split(|b|*b==0).next().unwrap()!=format!("InventoryItemIcon{slot}").as_bytes()
                    || storage.bytes()[0x204..0x214]!=storage.bytes()[0x214..0x224] {return Err("inventory icon source contract mismatch".into());}
                if icons.insert(slot,Panel{name:name.into(),path:layout.request.clone(),storage:copy_storage(storage)}).is_some() {return Err("duplicate inventory icon source".into());}
            }
            if name==format!("InventoryItemCount{slot}") {
                if storage.kind()!=3 {return Err("inventory count source kind mismatch".into());}
                let mut owned=copy_storage(storage);owned.set_word(0x200,text_binding as u32+1);
                if counts.insert(slot,CountSource{slot,binding:text_binding,storage:owned}).is_some() {return Err("duplicate inventory count source".into());}
            }
        }
    }}
    if icons.len()!=6 || counts.len()!=6 {return Err("six native inventory icon/count sources required".into());}
    Ok((icons.into_values().collect(),counts.into_values().collect()))
}
struct Icon {image:Handle<Image>,asset:String}
#[derive(Resource,Default)] struct Icons {
    panels:Vec<Panel>,images:BTreeMap<u32,Icon>,entities:Vec<Entity>,materials:Vec<Handle<IconMaterial>>,
    signature:Option<String>,error:Option<String>,
}
#[derive(Resource,Default)] struct Counts {
    sources:Vec<CountSource>,fill:Handle<Image>,entities:Vec<Entity>,materials:Vec<Handle<FontMaterial>>,
    signature:Option<String>,error:Option<String>,
}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self,app:&mut App) {
        app.init_resource::<Icons>().init_resource::<Counts>().init_resource::<Capture>().add_systems(Startup,setup)
            .add_systems(Update,drag::input.in_set(InputSet).after(crate::receive).after(crate::shop_ui::update).after(update_icons).before(crate::commands))
            .add_systems(Update,(update_icons,update_counts).after(crate::receive)
                .after(crate::native_font_metrics::MetricsSet).before(crate::render_probe::capture));
    }
}
fn setup(hud:Res<StartupHud>,device:Res<RenderDevice>,mut images:ResMut<Assets<Image>>,mut icons:ResMut<Icons>,mut counts:ResMut<Counts>) {
    match sources(&hud) {Ok((a,b))=>{icons.panels=a;counts.sources=b;},Err(error)=>{eprintln!("Inventory HUD sources unavailable: {error}");icons.error=Some(error.clone());counts.error=Some(error);return;}}
    let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../../assets");
    let catalog:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_inventory_icons.json")).expect("pinned inventory catalogue");
    for entry in catalog["entries"].as_array().expect("inventory entries") {
        let id=entry["id"].as_u64().expect("item id") as u32;let asset=entry["asset"].as_str().expect("asset path");
        let result=std::fs::read(root.join(asset)).map_err(|e|e.to_string()).and_then(|bytes| {
            if Some(bytes.len() as u64)!=entry["bytes"].as_u64() {return Err("inventory DDS byte length mismatch".into());}
            crate::native_hud_atlases::decode(&bytes,CompressedImageFormats::from_features(device.features())).map_err(|e|e.to_string())
        });
        match result {Ok(image)=>{icons.images.insert(id,Icon{image:images.add(image),asset:asset.into()});},Err(error)=>eprintln!("Inventory DDS {id} unavailable: {error}")}
    }
    let mut image=Image::new(Extent3d{width:1,height:1,depth_or_array_layers:1},TextureDimension::D2,vec![255;4],TextureFormat::Rgba8Unorm,RenderAssetUsages::MAIN_WORLD|RenderAssetUsages::RENDER_WORLD);
    image.sampler=crate::native_font_material::sampler(1,false).expect("existing HUD white-fill sampler");counts.fill=images.add(image);
}
fn clear_icons(live:&mut Icons,commands:&mut Commands,materials:&mut Assets<IconMaterial>) {
    for entity in live.entities.drain(..) {commands.entity(entity).despawn();}
    for material in live.materials.drain(..) {materials.remove(material.id());}live.signature=None;
}
fn clear_counts(live:&mut Counts,commands:&mut Commands,materials:&mut Assets<FontMaterial>) {
    for entity in live.entities.drain(..) {commands.entity(entity).despawn();}
    for material in live.materials.drain(..) {materials.remove(material.id());}live.signature=None;
}
fn icon_payloads(panels:&[Panel],images:&BTreeMap<u32,Icon>,slots:&[Option<Slot>;6],dimensions:[u32;2],scalar:f32,dpi:f32)->Result<Vec<(Node,IconMaterial,i32,usize)>,String> {
    if panels.len()!=6 {return Err("six inventory sources unavailable".into());}
    let mut result=Vec::new();
    for (index,slot) in slots.iter().enumerate() {if let Some(slot)=slot {
        let icon=images.get(&slot.item).ok_or_else(||format!("original inventory DDS not loaded for {}",slot.item))?;
        let mut storage=copy_storage(&panels[index].storage);storage.set_word(0x48,storage.flags()|1);
        let panel=Panel{name:panels[index].name.clone(),path:panels[index].path.clone(),storage};
        let (node,material)=crate::native_hud_panels::payload(&panel,dimensions,scalar,dpi,icon.image.clone())?;
        result.push((node,material,80+panel.storage.word(0x1a4) as i32,index));
    }}Ok(result)
}
fn update_icons(mut commands:Commands,state:Res<crate::Match>,connection:Res<crate::Connection>,window:Query<&Window,With<PrimaryWindow>>,
    viewport:Res<crate::native_hud_viewport::Viewport>,mut materials:ResMut<Assets<IconMaterial>>,mut live:ResMut<Icons>) {
    let Some(snapshot)=&state.snapshot else {clear_icons(&mut live,&mut commands,&mut materials);return;};
    let slots=match values(snapshot,connection.id) {Ok(Some(v))=>v,Ok(None)=>{clear_icons(&mut live,&mut commands,&mut materials);return;},Err(error)=>{clear_icons(&mut live,&mut commands,&mut materials);if live.error.as_ref()!=Some(&error){eprintln!("Inventory HUD unavailable: {error}");live.error=Some(error);}return;}};
    let Ok(window)=window.single() else {clear_icons(&mut live,&mut commands,&mut materials);return;};
    let dimensions=[window.physical_width(),window.physical_height()];let dpi=window.scale_factor();
    let signature=format!("{}:{:?}:{slots:?}:{dimensions:?}:{dpi}:{}",snapshot.session,connection.id,viewport.scalar.to_bits());
    if live.signature.as_ref()==Some(&signature) {return;}
    let payloads=match icon_payloads(&live.panels,&live.images,&slots,dimensions,viewport.scalar,dpi) {Ok(v)=>v,Err(error)=>{clear_icons(&mut live,&mut commands,&mut materials);if live.error.as_ref()!=Some(&error){eprintln!("Inventory HUD unavailable: {error}");live.error=Some(error);}return;}};
    clear_icons(&mut live,&mut commands,&mut materials);let mut records=Vec::new();
    for (node,material,z,slot) in payloads {
        let item=slots[slot].unwrap();let asset=&live.images[&item.item].asset;
        records.push(serde_json::json!({"slot":slot,"item":item.item,"count":item.count,"count_text":count_text(Some(item)),"asset":asset,"z":z,"uv":material.parameters.uv.to_array(),"texture":format!("{:?}",material.texture.id())}));
        let handle=materials.add(material);live.entities.push(commands.spawn((node,MaterialNode(handle.clone()),GlobalZIndex(z),Name::new("NativeMap10InventoryIcon"))).id());live.materials.push(handle);
    }
    live.signature=Some(signature);live.error=None;
    if let Ok(path)=std::env::var("OPENLEAGUE_NATIVE_HUD_INVENTORY_TRACE") {
        let report=serde_json::json!({"session":snapshot.session,"tick":snapshot.tick,"player":connection.id,"slots":records,"icon_entities":live.entities.len(),"icon_materials":live.materials.len(),"native_framebuffer_equivalence":false});
        if let Err(error)=std::fs::write(path,serde_json::to_vec_pretty(&report).unwrap()) {eprintln!("Inventory trace failed: {error}");}
    }
}
fn prepare_counts(sources:&mut [CountSource],slots:&[Option<Slot>;6],dimensions:[u32;2],scalar:f32)->Result<(crate::native_hud_text_batch::Batch,BTreeMap<u32,usize>),String> {
    let mut bindings=BTreeMap::new();
    for source in sources.iter_mut() {
        let text=count_text(slots[source.slot]);let flags=source.storage.flags();source.storage.set_word(0x48,if text.is_some(){flags|1}else{flags&!1});
        let mut bytes=[0;256];if let Some(text)=text {bytes[..text.len()].copy_from_slice(text.as_bytes());}
        source.storage.write_bytes(0x20c,&bytes);bindings.insert(source.binding as u32+1,source.binding);
    }
    let mut elements=sources.iter_mut().map(|s|&mut s.storage).collect::<Vec<_>>();
    Ok((crate::native_hud_text_batch::from_elements(&mut elements,dimensions,scalar,0,[1.,1.,0.,0.]).map_err(str::to_owned)?,bindings))
}
fn update_counts(mut commands:Commands,state:Res<crate::Match>,connection:Res<crate::Connection>,window:Query<&Window,With<PrimaryWindow>>,
    viewport:Res<crate::native_hud_viewport::Viewport>,sizes:Res<Sizes>,mut faces:NonSendMut<Faces>,mut pages:ResMut<Pages>,
    mut images:ResMut<Assets<Image>>,mut materials:ResMut<Assets<FontMaterial>>,mut live:ResMut<Counts>) {
    if live.sources.len()!=6 {return;}
    let Some(snapshot)=&state.snapshot else {clear_counts(&mut live,&mut commands,&mut materials);return;};
    let slots=match values(snapshot,connection.id) {Ok(Some(v))=>v,_=>{clear_counts(&mut live,&mut commands,&mut materials);return;}};
    let Ok(window)=window.single() else {clear_counts(&mut live,&mut commands,&mut materials);return;};
    let dimensions=[window.physical_width(),window.physical_height()];
    if sizes.height!=Some(dimensions[1]) || faces.height!=sizes.height {clear_counts(&mut live,&mut commands,&mut materials);return;}
    let signature=format!("{}:{:?}:{slots:?}:{dimensions:?}:{:?}:{}",snapshot.session,connection.id,faces.dpi,viewport.scalar.to_bits());
    if live.signature.as_ref()==Some(&signature) {return;}
    let result=(||->Result<Vec<(Node,FontMaterial)>,String>{
        let (batch,bindings)=prepare_counts(&mut live.sources,&slots,dimensions,viewport.scalar)?;
        let prepared=crate::native_hud_text_render::prepare(&mut faces,&sizes,&batch,&crate::native_hud_text_render::Context{viewport:dimensions,packet_scalar:viewport.scalar,glyph_owner_scale:1.},&bindings,
            |bytes|if bytes.is_ascii(){Ok(bytes.iter().map(|b|u16::from(*b)).collect())}else{Err("inventory count must be ASCII".into())})?;
        if !prepared.copy_errors.is_empty(){return Err("inventory count packet copy failed".into());}
        pages.sync(&faces,&sizes,&mut images)?;
        crate::native_hud_text_render::projected_ui_payloads(&prepared,&faces,&sizes,&pages,live.fill.clone(),Vec2::splat(0.5))
    })();
    let payloads=match result {Ok(v)=>v,Err(error)=>{clear_counts(&mut live,&mut commands,&mut materials);if live.error.as_ref()!=Some(&error){eprintln!("Inventory counts unavailable: {error}");live.error=Some(error);}return;}};
    clear_counts(&mut live,&mut commands,&mut materials);
    // Same text transport layer as the existing native numeric HUD widgets.
    for (node,material) in payloads {let handle=materials.add(material);live.entities.push(commands.spawn((node,MaterialNode(handle.clone()),GlobalZIndex(100),Name::new("NativeMap10InventoryCount"))).id());live.materials.push(handle);}
    live.signature=Some(signature);live.error=None;
}
#[cfg(test)]
#[path="native_hud_inventory_tests.rs"]
mod tests;
