//! Map10 minimap: original texture/layout, static native coordinate port and
//! visible Snapshot actors and the available, visible MapState relic.
//! TT_Relic -> HealthPack is an explicit local binding; no hidden-state cache.
use bevy::{prelude::*,asset::RenderAssetUsages,image::{CompressedImageFormats,ImageSampler,ImageSamplerDescriptor,ImageType},
    render::renderer::RenderDevice,ui_render::ui_material::MaterialNode,window::PrimaryWindow};
use std::collections::{BTreeMap,BTreeSet};
use crate::{native_hud_panels::Panel,native_hud_element_storage::ElementStorage,
    native_hud_icon_material::{IconMaterial,Parameters},native_zip_provider::StartupHud};
#[path="native_minimap_geometry.rs"] mod geometry;
#[path="native_minimap_input.rs"] mod input;
#[path="native_minimap_fow.rs"] mod fog;
pub(crate) use input::{Capture,InputSet};
use geometry::{Rect,Projection};

#[derive(Clone,Copy,Debug,PartialEq,Eq,PartialOrd,Ord)] enum Key {Panel(u8),Player(u32),Unit(u32),Relic}
#[derive(Clone,Copy,Debug,PartialEq,Eq)] enum Texture {Background,Champion,Minion,Strip,Relic}
struct Style {width:f32,min_scale:f32,color:Vec4,strip:Option<u32>}
#[derive(Default)] struct Images {background:Handle<Image>,champion:Handle<Image>,minion:Handle<Image>,strip:Handle<Image>,relic:Handle<Image>}
impl Images {fn get(&self,t:Texture)->Handle<Image> {match t {Texture::Background=>&self.background,Texture::Champion=>&self.champion,Texture::Minion=>&self.minion,Texture::Strip=>&self.strip,Texture::Relic=>&self.relic}.clone()}}
#[derive(Clone,Debug)] struct Marker {key:Key,point:Vec2,style:String,team:u8,texture:Texture}
struct Owned {entity:Entity,material:Handle<IconMaterial>}
#[derive(Resource,Default)] struct Live {
    panels:Vec<Panel>,images:Images,styles:BTreeMap<(String,u8),Style>,strip_count:u32,
    owned:BTreeMap<Key,Owned>,rect:Option<Rect>,error:Option<String>,assets_ready:bool,session:Option<u64>,
    trace_tick:Option<(u64,u64)>,
}
pub(crate) fn summoner_requires_world_target(spell:Option<openleague_core::summoners::Spell>)->bool {
    use openleague_core::summoners::Spell;
    matches!(spell,Some(Spell::Exhaust|Spell::Ignite|Spell::Smite))
}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self,app:&mut App) {
        app.init_resource::<Live>().init_resource::<Capture>().add_plugins(fog::Plugin).add_systems(Startup,setup)
            .add_systems(Update,update.after(crate::receive).before(InputSet).before(crate::render_probe::capture))
            .add_systems(Update,input::input.in_set(InputSet).after(crate::native_hud_inventory::InputSet)
                .after(crate::ordinary_camera_input::drive).after(crate::shop_ui::update)
                .before(crate::commands).before(crate::camera));
    }
}
fn sources(hud:&StartupHud)->Result<Vec<Panel>,String> {
    let names=["MinimapContent","MinimapFrame","MinimapPillar"];
    let mut result=BTreeMap::new();
    for layout in &hud.shadow_isles_layouts {if !layout.request.ends_with("ShadowIslesMinimapRight.ini") {continue;}
        for record in &layout.structure.accepted {
            let s=&record.element.storage;
            let name=std::str::from_utf8(s.bytes()[..32].split(|b|*b==0).next().unwrap()).map_err(|_|"minimap name encoding")?;
            let Some(index)=names.iter().position(|n|*n==name) else {continue;};
            if s.kind()!=1 || s.bytes()[0x204..0x214]!=s.bytes()[0x214..0x224] {return Err("minimap source icon/UV mismatch".into());}
            let texture=s.bytes()[0x1e0..0x200].split(|b|*b==0).next().unwrap();
            if index>0 && texture!=b"ShadowIslesHUDAtlas" {return Err("minimap frame atlas mismatch".into());}
            let mut storage=ElementStorage::new(1).unwrap();storage.write_bytes(0,s.bytes());
            if index==0 {
                // Native content is disabled/alpha0 until its controller binds
                // the map texture. This explicit local bridge uses the accepted
                // session; it does not claim to port that original controller.
                storage.set_word(0x48,storage.flags()|1);storage.set_word(0x1dc,0xffffffff);
            }
            if result.insert(index,Panel{name:name.into(),path:layout.request.clone(),storage}).is_some() {return Err("duplicate minimap source".into());}
        }
    }
    if result.len()!=3 {return Err("three original minimap elements required".into());}
    Ok(result.into_values().collect())
}
fn profile()->Result<(BTreeMap<(String,u8),Style>,u32),String> {
    let value:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_minimap_profile.json")).map_err(|e|e.to_string())?;
    let count=value["strip_count"].as_u64().ok_or("minimap strip count")? as u32;
    if count!=28 {return Err("unexpected minimap icon strip".into());}
    let mut out=BTreeMap::new();
    for name in ["Champion","Minion","Tower","Inhibitor","HQ","HealthPack"] {
        let entry=&value["styles"][name];let width=entry["width"].as_f64().ok_or("marker width")? as f32;
        let min_scale=entry["min_scale"].as_f64().ok_or("marker minScale")? as f32;
        if !width.is_finite() || !min_scale.is_finite() || width<=0. || min_scale<=0. {return Err("invalid minimap marker dimensions".into());}
        for team in [0u8,1,255] {let row=&entry[team.to_string()];if row.is_null() {continue;}
            let color=row["color"].as_array().filter(|a|a.len()==4).ok_or("marker color")?;
            let mut rgba=[0.;4];for i in 0..4 {rgba[i]=color[i].as_u64().filter(|v|*v<=255).ok_or("marker color channel")? as f32/255.;}
            let strip=row["strip"].as_u64().map(|v|v as u32);if strip.is_some_and(|v|v>=count) {return Err("marker strip index".into());}
            out.insert((name.to_owned(),team),Style{width,min_scale,color:Vec4::from_array(rgba),strip});
        }
    }
    Ok((out,count))
}
// The original Map10 DDS has a colored level0 but nearly-white lower mips.
// Explicit local display policy: sample its authored base image at every UI size.
// Keep the DDS bytes/mips and all other image samplers unchanged.
fn image_sampler(name:&str)->ImageSampler {
    if name=="background.dds" {
        ImageSampler::Descriptor(ImageSamplerDescriptor{lod_min_clamp:0.,lod_max_clamp:0.,..ImageSamplerDescriptor::linear()})
    } else {ImageSampler::linear()}
}
fn setup(hud:Res<StartupHud>,device:Res<RenderDevice>,mut assets:ResMut<Assets<Image>>,mut live:ResMut<Live>) {
    let result=(||->Result<_,String>{
        let panels=sources(&hud)?;let (styles,count)=profile()?;
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../../assets/ui/minimap_native");
        let supported=CompressedImageFormats::from_features(device.features());
        let mut decoded=Vec::new();
        for (name,ext) in [("background.dds","dds"),("MapCircle.png","png"),("MinionMapCircle.png","png"),("icons.dds","dds"),("healthPack.dds","dds")] {
            let bytes=std::fs::read(root.join(name)).map_err(|e|e.to_string())?;
            let image=Image::from_buffer(&bytes,ImageType::Extension(ext),supported,true,image_sampler(name),RenderAssetUsages::default()).map_err(|e|e.to_string())?;
            decoded.push(image);
        }
        let expected=[(752,752),(128,128),(16,16),(1008,36),(32,32)];
        for (image,size) in decoded.iter().zip(expected) {if (image.width(),image.height())!=size {return Err("minimap asset dimensions mismatch".into());}}
        Ok((panels,styles,count,decoded))
    })();
    match result {
        Ok((panels,styles,count,images))=>{
            let mut handles=images.into_iter().map(|image|assets.add(image));
            live.images=Images{background:handles.next().unwrap(),champion:handles.next().unwrap(),minion:handles.next().unwrap(),strip:handles.next().unwrap(),relic:handles.next().unwrap()};
            live.panels=panels;live.styles=styles;live.strip_count=count;live.assets_ready=true;
        }
        Err(error)=>{eprintln!("Minimap unavailable: {error}");live.error=Some(error);}
    }
}
fn markers(snapshot:&openleague_core::Snapshot,r:Rect,p:Projection)->Result<Vec<Marker>,String> {
    let mut out=Vec::new();let mut keys=BTreeSet::new();
    let mut push=|key:Key,point:openleague_core::Point,health:f32,team:u8,style:&str,texture:Texture|->Result<(),String>{
        if !keys.insert(key) {return Err("duplicate minimap actor identity".into());}
        if !health.is_finite() || health<=0. {return Ok(());}
        if let Some(point)=p.project(r,point) {out.push(Marker{key,point,team,style:style.into(),texture});}Ok(())
    };
    // Roster has hidden identities but no admitted positions: deliberately unused.
    for actor in &snapshot.players {if matches!(actor.team,0|1) {push(Key::Player(actor.id),actor.position,actor.health,actor.team,"Champion",Texture::Champion)?;}}
    use openleague_core::world::Kind;
    for unit in &snapshot.units {
        let (style,texture)=match unit.kind {
            Kind::Melee|Kind::Caster|Kind::Siege|Kind::Super=>("Minion",Texture::Minion),
            Kind::Turret=>("Tower",Texture::Strip),Kind::Inhibitor=>("Inhibitor",Texture::Strip),Kind::Nexus=>("HQ",Texture::Strip),
            // Camp/summon/fountain/altar roles require their own native binding.
            _=>continue,
        };
        if matches!(unit.team,0|1) {push(Key::Unit(unit.id),unit.position,unit.health,unit.team,style,texture)?;}
    }
    // One relic per accepted Map10 session. Native HealthPack resource/style,
    // community-attested selector, explicitly local bridge to filtered MapState.
    // No ready_tick extrapolation, hidden position cache or roster lookup.
    if let Some(map)=snapshot.map10.as_ref().filter(|map|map.relic_visible && map.relic_available) {
        if let Some(point)=p.project(r,map.relic_position) {
            out.push(Marker{key:Key::Relic,point,team:255,style:"HealthPack".into(),texture:Texture::Relic});
        }
    }
    Ok(out)
}
struct Payload {key:Key,node:Node,material:IconMaterial,z:i32}
fn marker_payload(marker:&Marker,live:&Live,r:Rect,dpi:f32)->Result<Payload,String> {
    let style=live.styles.get(&(marker.style.clone(),marker.team)).ok_or("minimap native marker style unavailable")?;
    // Explicit local fixed-size policy using the authored lower scale bound.
    let size=style.width*style.min_scale/dpi;
    let left=marker.point.x-size*0.5;let top=marker.point.y-size*0.5;
    let clipped=Vec4::new(left.max(r.left),top.max(r.top),(left+size).min(r.left+r.width),(top+size).min(r.top+r.height));
    let uv=if let Some(index)=style.strip {Vec4::new(index as f32/live.strip_count as f32,0.,(index+1) as f32/live.strip_count as f32,1.)}else{Vec4::new(0.,0.,1.,1.)};
    let delta=uv.zw()-uv.xy();let start=uv.xy()+((clipped.xy()-Vec2::new(left,top))/size)*delta;
    let end=uv.xy()+((clipped.zw()-Vec2::new(left,top))/size)*delta;
    Ok(Payload{key:marker.key,node:Node{position_type:PositionType::Absolute,left:Val::Px(clipped.x),top:Val::Px(clipped.y),width:Val::Px(clipped.z-clipped.x),height:Val::Px(clipped.w-clipped.y),..default()},
        material:IconMaterial{parameters:Parameters{uv:Vec4::new(start.x,start.y,end.x,end.y),vertex_color:style.color,tint:Vec4::ONE,mode:Vec4::ZERO},texture:live.images.get(marker.texture)},z:84})
}
fn retire(live:&mut Live,commands:&mut Commands,materials:&mut Assets<IconMaterial>) {
    for (_,owned) in std::mem::take(&mut live.owned) {commands.entity(owned.entity).despawn();materials.remove(owned.material.id());}
    live.rect=None;live.session=None;
}
fn sync(live:&mut Live,commands:&mut Commands,materials:&mut Assets<IconMaterial>,payloads:Vec<Payload>)->Result<(),String> {
    let wanted=payloads.iter().map(|p|p.key).collect::<BTreeSet<_>>();
    if wanted.len()!=payloads.len() {return Err("duplicate minimap draw key".into());}
    let absent=live.owned.keys().filter(|key|!wanted.contains(*key)).copied().collect::<Vec<_>>();
    for key in absent {let owned=live.owned.remove(&key).unwrap();commands.entity(owned.entity).despawn();materials.remove(owned.material.id());}
    for payload in payloads {
        if let Some(owned)=live.owned.get(&payload.key) {
            let Some(mut material)=materials.get_mut(&owned.material) else {return Err("owned minimap material removed externally".into());};
            if material.texture!=payload.material.texture || material.parameters.uv!=payload.material.parameters.uv || material.parameters.vertex_color!=payload.material.parameters.vertex_color || material.parameters.tint!=payload.material.parameters.tint || material.parameters.mode!=payload.material.parameters.mode {*material=payload.material;}
            commands.entity(owned.entity).insert((payload.node,GlobalZIndex(payload.z)));
        } else {
            let material=materials.add(payload.material);let entity=commands.spawn((payload.node,MaterialNode(material.clone()),GlobalZIndex(payload.z),Name::new("NativeMap10Minimap"))).id();
            live.owned.insert(payload.key,Owned{entity,material});
        }
    }Ok(())
}
fn update(mut commands:Commands,game:Res<crate::Match>,connection:Res<crate::Connection>,windows:Query<&Window,With<PrimaryWindow>>,
    atlases:Res<crate::native_hud_atlases::Atlases>,viewport:Res<crate::native_hud_viewport::Viewport>,images:Res<Assets<Image>>,
    mut materials:ResMut<Assets<IconMaterial>>,mut live:ResMut<Live>) {
    let snapshot=game.snapshot.as_ref().filter(|s|Some(s.session)==connection.session && s.players.iter().any(|p|Some(p.id)==connection.id));
    let Some(snapshot)=snapshot else {retire(&mut live,&mut commands,&mut materials);return;};
    let Ok(window)=windows.single() else {retire(&mut live,&mut commands,&mut materials);return;};
    if !live.assets_ready {return;}
    let result=(||->Result<_,String>{
        let atlas=atlases.entries.iter().find(|a|a.normalized.ends_with("ShadowIslesHUDAtlas.dds")).ok_or("minimap frame atlas unavailable")?;
        let dimensions=[window.physical_width(),window.physical_height()];let dpi=window.scale_factor();
        if dimensions.contains(&0) || !dpi.is_finite() || dpi<=0. {return Err("minimap viewport unavailable".into());}
        for handle in [&live.images.background,&live.images.champion,&live.images.minion,&live.images.strip,&live.images.relic,&atlas.image] {if !images.contains(handle.id()) {return Err("minimap image unavailable".into());}}
        let mut payloads=Vec::new();let mut rect=None;
        for (index,panel) in live.panels.iter().enumerate() {
            let texture=if index==0 {live.images.get(Texture::Background)}else {atlas.image.clone()};
            let (node,material)=crate::native_hud_panels::payload(panel,dimensions,viewport.scalar,dpi,texture)?;
            if index==0 {rect=Some(Rect::from_node(&node)?);}
            payloads.push(Payload{key:Key::Panel(index as u8),node,material,z:if index==0 {80}else{80+panel.storage.word(0x1a4) as i32}});
        }
        let rect=rect.ok_or("minimap content unavailable")?;let markers=markers(snapshot,rect,Projection::map10()?)?;
        for marker in &markers {payloads.push(marker_payload(marker,&live,rect,dpi)?);}
        Ok((payloads,rect,markers))
    })();
    let result=result.and_then(|(payloads,rect,markers)|{
        if live.session!=Some(snapshot.session) {retire(&mut live,&mut commands,&mut materials);}
        sync(&mut live,&mut commands,&mut materials,payloads)?;live.rect=Some(rect);live.session=Some(snapshot.session);Ok((rect,markers))
    });
    match result {
        Ok((rect,markers))=>{
            live.error=None;
            if live.trace_tick.is_none_or(|(session,tick)|session!=snapshot.session || snapshot.tick.saturating_sub(tick)>=15) {
                live.trace_tick=Some((snapshot.session,snapshot.tick));
                if let Ok(path)=std::env::var("OPENLEAGUE_MINIMAP_TRACE") {
                    let value=serde_json::json!({"complete":false,"pixels_qualified":false,"session":snapshot.session,"tick":snapshot.tick,"player":connection.id,
                        "rect":[rect.left,rect.top,rect.width,rect.height],"draw_count":live.owned.len(),"marker_count":markers.len(),"marker_trace_limit":512,"markers":markers.iter().take(512).map(|m|serde_json::json!({"key":format!("{:?}",m.key),"point":m.point.to_array(),"team":m.team,"style":m.style})).collect::<Vec<_>>(),
                        "limits":["Only accepted filtered Snapshot actors and visible, available MapState relic; no roster positions, hidden-state cache or local relic timer. TT_Relic -> HealthPack is a local binding.","The current client FoW output is guarded separately in the render world; this CPU trace does not assert a fog draw. Native fixed minScale is local marker sizing."]});
                    if let Err(error)=std::fs::write(path,serde_json::to_vec_pretty(&value).unwrap()) {eprintln!("Minimap trace failed: {error}");}
                }
            }
        }
        Err(error)=>{retire(&mut live,&mut commands,&mut materials);if live.error.as_ref()!=Some(&error) {eprintln!("Minimap unavailable: {error}");live.error=Some(error);}}
    }
}
#[cfg(test)] #[path="native_minimap_tests.rs"] mod tests;
