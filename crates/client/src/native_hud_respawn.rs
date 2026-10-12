//! Original Map10 RespawnTimerFrame, controlled by accepted server death state.
//! Countdown uses local integer ceil-seconds; original formatter/clock parity is open.
use bevy::{prelude::*, ui_render::ui_material::MaterialNode, window::PrimaryWindow};
use crate::{native_hud_panels::Panel, native_hud_element_storage::ElementStorage,
    native_hud_icon_material::IconMaterial, native_zip_provider::StartupHud};

pub(crate) fn countdown(snapshot:&openleague_core::Snapshot,id:Option<u32>)->Option<String> {
    if snapshot.winner.is_some() {return None;}
    let player=snapshot.players.iter().find(|p|Some(p.id)==id)?;
    if !player.health.is_finite() || player.health>0. {return None;}
    let ticks=player.respawn_at?.saturating_sub(snapshot.tick);
    let rate=openleague_core::TICK_RATE;
    Some((ticks/rate+u64::from(ticks%rate!=0)).to_string())
}
fn visible(state:&crate::Match,connection:&crate::Connection)->bool {
    connection.ready() && state.snapshot.as_ref().is_some_and(|snapshot|
        connection.session==Some(snapshot.session) && countdown(snapshot,connection.id).is_some())
}
fn source_panel(hud:&StartupHud)->Result<Panel,String> {
    let mut found=None;
    for layout in &hud.shadow_isles_layouts {
        if !layout.request.ends_with("ShadowIslesChampionLeft.ini") {continue;}
        for record in &layout.structure.accepted {
            let s=&record.element.storage;
            if s.kind()!=1 || s.bytes()[..32].split(|b|*b==0).next()!=Some(b"RespawnTimerFrame".as_slice()) {continue;}
            if found.is_some() || s.flags()&1!=0 || s.bytes()[0x1e0..0x200].split(|b|*b==0).next()!=Some(b"HUDAtlas".as_slice())
                || s.bytes()[0x204..0x214]!=s.bytes()[0x214..0x224] {
                return Err("original RespawnTimerFrame changed or duplicated".into());
            }
            let mut storage=ElementStorage::new(1).map_err(str::to_owned)?;
            storage.write_bytes(0,s.bytes());
            // Native source starts disabled; only this accepted death-state consumer enables its copy.
            storage.set_word(0x48,storage.flags()|1);
            found=Some(Panel{name:"RespawnTimerFrame".into(),path:layout.request.clone(),storage});
        }
    }
    found.ok_or("original RespawnTimerFrame missing".into())
}
#[derive(Resource,Default)] struct Live {
    panel:Option<Panel>, entity:Option<Entity>, material:Option<Handle<IconMaterial>>, signature:Option<String>,
}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self,app:&mut App) {
        app.init_resource::<Live>().add_systems(Startup,setup)
            .add_systems(Update,update.after(crate::receive).before(crate::render_probe::capture));
    }
}
fn setup(hud:Res<StartupHud>,mut live:ResMut<Live>) {
    match source_panel(&hud) {Ok(panel)=>live.panel=Some(panel),Err(error)=>eprintln!("Native respawn frame unavailable: {error}")}
}
fn clear(live:&mut Live,commands:&mut Commands,materials:&mut Assets<IconMaterial>) {
    if let Some(entity)=live.entity.take() {commands.entity(entity).despawn();}
    if let Some(material)=live.material.take() {materials.remove(material.id());}
    live.signature=None;
}
fn update(mut commands:Commands,state:Res<crate::Match>,connection:Res<crate::Connection>,
    windows:Query<&Window,With<PrimaryWindow>>,atlases:Res<crate::native_hud_atlases::Atlases>,
    viewport:Res<crate::native_hud_viewport::Viewport>,mut materials:ResMut<Assets<IconMaterial>>,mut live:ResMut<Live>) {
    if !visible(&state,&connection) {clear(&mut live,&mut commands,&mut materials);return;}
    let Some(atlas)=atlases.entries.iter().find(|a|a.normalized.rsplit(['/', '\\']).next()==Some("HUDAtlas.dds"))
        else {clear(&mut live,&mut commands,&mut materials);return;};
    let Some(panel)=live.panel.as_ref() else {return;};
    let Ok(window)=windows.single() else {clear(&mut live,&mut commands,&mut materials);return;};
    let dimensions=[window.physical_width(),window.physical_height()];let dpi=window.scale_factor();
    let signature=format!("{:?}:{:?}:{dimensions:?}:{dpi}:{}:{:?}",connection.session,connection.id,viewport.scalar.to_bits(),atlas.image.id());
    if live.signature.as_ref()==Some(&signature) {return;}
    let layer=panel.storage.word(0x1a4);
    let result=crate::native_hud_panels::payload(panel,dimensions,viewport.scalar,dpi,atlas.image.clone());
    let (node,material)=match result {Ok(payload)=>payload,Err(error)=>{
        eprintln!("Native respawn frame rendering unavailable: {error}");clear(&mut live,&mut commands,&mut materials);return;}};
    clear(&mut live,&mut commands,&mut materials);
    let handle=materials.add(material);
    live.entity=Some(commands.spawn((node,MaterialNode(handle.clone()),GlobalZIndex(80+layer as i32),Name::new("NativeMap10RespawnFrame"))).id());
    live.material=Some(handle);live.signature=Some(signature);
}

#[cfg(test)]
#[path="native_hud_respawn_tests.rs"]
mod tests;
