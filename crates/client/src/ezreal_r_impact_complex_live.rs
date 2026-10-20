//! Bounded Complex impact groups1/4, separate from Flash, Magicdust and missile Sparks. Strict same-draw FoW
//! authorization is independent of the frozen contact and its local lifetime.
use bevy::{asset::RenderAssetUsages, camera::primitives::MeshAabb,
    image::{ImageAddressMode,ImageFilterMode,ImageLoaderSettings,ImageSampler,ImageSamplerDescriptor},
    mesh::{Indices,PrimitiveTopology}, prelude::*, render::{batching::NoAutomaticBatching,
        render_resource::{TextureDimension,TextureFormat}}};
use std::collections::BTreeMap;
use crate::{ezreal_r_flash_events::{Request as EventRequest,State as Events},
    ezreal_r_impact_complex_profile::{self as authored,Profile as Authored},
    ezreal_r_impact_complex_simulation::{self as simulation,State,Key},
    ezreal_r_impact_complex_draw::{Current,Frontier,Request},ezreal_r_impact_complex_material::StrictMaterial,
    nexus_glow_material::{GlowMaterial,Textures,Inputs},nexus_complex_material::{Cull,OutputEncoding}};
const IMAGE_BYTES:&[u8]=include_bytes!("../../../assets/particles/ezreal/r_impact_complex/sliver.dds");

#[derive(Resource)]
struct Profile { authored:[Authored;2],textures:Textures,overlay:Handle<Image> }
fn samplers() -> [ImageSamplerDescriptor;2] {
    // Explicit local sampling, not a claim about unrecovered native R samplers.
    let clamp=ImageSamplerDescriptor {address_mode_u:ImageAddressMode::ClampToEdge,
        address_mode_v:ImageAddressMode::ClampToEdge,address_mode_w:ImageAddressMode::ClampToEdge,
        mag_filter:ImageFilterMode::Linear,min_filter:ImageFilterMode::Linear,
        mipmap_filter:ImageFilterMode::Linear,..default()}; [clamp.clone(),clamp]
}
impl Profile {
    fn validate(&self,images:&Assets<Image>) -> Result<(),&'static str> {
        let image=images.get(&self.textures.image).ok_or("impact Sliver DDS unavailable")?;
        let d=&image.texture_descriptor;
        if d.dimension!=TextureDimension::D2 || d.size.width!=128 || d.size.height!=128
            || d.size.depth_or_array_layers!=1 || d.mip_level_count!=8 || d.format!=TextureFormat::Bc3RgbaUnorm
            || image.data.as_deref()!=Some(&IMAGE_BYTES[128..])
            || !matches!(&image.sampler,ImageSampler::Descriptor(s) if s==&self.textures.samplers[0]) {
            return Err("impact Sliver exact DDS/layout/sampler changed");
        }
        let white=images.get(&self.textures.color).ok_or("impact local white modulation absent")?;
        let d=&white.texture_descriptor;
        if d.dimension!=TextureDimension::D2 || d.size.width!=1 || d.size.height!=1
            || d.size.depth_or_array_layers!=1 || d.mip_level_count!=1 || d.format!=TextureFormat::Rgba8Unorm
            || white.data.as_deref()!=Some(&[255u8;4][..])
            || !matches!(&white.sampler,ImageSampler::Descriptor(s) if s==&self.textures.samplers[1]) {
            return Err("impact local neutral modulation changed");
        }
        if !images.contains(self.overlay.id()) { return Err("R ImpactComplex FoW overlay absent"); }
        Ok(())
    }
}
fn white_image(sampler:ImageSamplerDescriptor)->Image {
    // p-rgba absent: explicit local neutral modulation, not a recovered texture.
    let mut image=Image::new_fill(bevy::render::render_resource::Extent3d {width:1,height:1,depth_or_array_layers:1},
        TextureDimension::D2,&[255;4],TextureFormat::Rgba8Unorm,RenderAssetUsages::default());
    image.sampler=ImageSampler::Descriptor(sampler);image
}
fn setup(mut commands:Commands,assets:Res<AssetServer>,mut images:ResMut<Assets<Image>>) {
    match Authored::load(0).and_then(|spin|Authored::load(1).map(|rays|[spin,rays])) {
        Ok(authored) => {
            let samplers=samplers();let sampler=samplers[0].clone();
            let image=assets.load_builder().with_settings(move |s:&mut ImageLoaderSettings|{
                s.is_srgb=false;s.sampler=ImageSampler::Descriptor(sampler.clone());}).load(authored::IMAGE);
            let color=images.add(white_image(samplers[1].clone()));
            commands.insert_resource(Profile {authored,textures:Textures {image,color,samplers},
                overlay:assets.load("maps/terrain_native/DefaultFogOfWarOverlay.png")});
        }
        Err(error)=>warn!("R ImpactComplex profile disabled: {error}"),
    }
}
#[derive(Component)]
struct Owned;
struct Draw {entity:Entity,mesh:Handle<Mesh>,material:Handle<StrictMaterial>,incarnation:u64,
    geometry:(u64,u64,[u32;16])}
#[derive(Resource,Default)]
struct Live {state:State,rows:BTreeMap<Key,Draw>,revision:u64,last_error:Option<&'static str>}
#[derive(Clone)]
struct Frame {frontier:Frontier,visibility:Handle<Image>,extent:f32,view:[f32;16],camera_position:[f32;3],clock:f64}
fn material(profile:&Profile,frame:&Frame) -> Result<StrictMaterial,&'static str> {
    let mut inner=GlowMaterial::new(&profile.textures,frame.visibility.clone(),profile.overlay.clone(),
        Inputs {native_fog_extent:frame.extent,encoding:OutputEncoding::DisplayToLinear,cull:Cull::None,
            render_mode:0,render_flags:0,shader_features:0})?;
    inner.set_admitted(true); let strict=StrictMaterial::new(inner);
    strict.source_key().ok_or("R ImpactComplex source key invalid")?; Ok(strict)
}
#[path="relic_pickup_complex_type2_quad.rs"] mod type2;
fn geometry(entry:&simulation::Entry,view:[f32;16],camera:[f32;3]) -> Result<Option<Mesh>,&'static str> {
    use openleague_core::{native_complex_quad_binding as binding,native_complex_type0_quad as type0};
    let mut positions=Vec::new();let mut uv0=Vec::new();let mut uv1=Vec::new();let mut colors=Vec::new();let mut indices=Vec::new();
    for record in &entry.host.storage.particles {
        let fields=binding::DrawFields::from_record(record,false)?;
        let rgba=crate::relic_pickup_complex_rgba::mode0(fields.rgba,[1.;4])?.value();
        let words=if entry.profile==0 {
            let vector=std::array::from_fn(|i|f32::from_bits(record.surface[32+i]));
            let (a,b)=crate::ezreal_r_impact_complex_axes::aligned(view,vector)?;
            type0::pack(type0::Input {center:fields.matrix_center,axis_a:a.map(|v|v*fields.scale[1]),
                axis_b:b.map(|v|v*fields.scale[0]),rgba,channel0_origin:fields.uv_scroll,
                channel0_z:fields.atlas_frame,channel1_origin:fields.lookup,channel1_corners:false})
                .map_err(|_|"impact aligned type0 packet invalid")?.words
        } else {
            let direction=std::array::from_fn::<_,3,_>(|i|f32::from_bits(record.surface[24+i]));
            type2::packet(type2::Input {camera,center:fields.matrix_center,
                motion_point:std::array::from_fn(|i|fields.matrix_center[i]-direction[i]),scales:fields.scale,
                rgba,frame:fields.atlas_frame,uv:fields.uv_scroll,lookup:fields.lookup,channel_corners:false})?.words
        };
        let base=u32::try_from(positions.len()).map_err(|_|"R ImpactComplex mesh index overflow")?;
        for words in words {
            if words[..3].iter().any(|v|!f32::from_bits(*v).is_finite()){return Err("impact packet position overflow");}
            // Exact packet transport, sole native→world conversion. One-cell
            // local atlas policy; no generated UVs or generic Bevy billboard.
            positions.push([words[0],words[1],words[2]].map(|v|f32::from_bits(v)/20.));
            uv0.push([words[4],words[5]].map(f32::from_bits));
            uv1.push([words[8],words[9]].map(f32::from_bits));
            colors.push([((words[3]>>16)&255) as f32/255.,((words[3]>>8)&255) as f32/255.,
                (words[3]&255) as f32/255.,((words[3]>>24)&255) as f32/255.]);
        }
        indices.extend([base,base+1,base+2,base,base+2,base+3]);
    }
    if positions.is_empty() { return Ok(None); }
    let mut mesh=Mesh::new(PrimitiveTopology::TriangleList,RenderAssetUsages::default());
    mesh.insert_attribute(Mesh::ATTRIBUTE_POSITION,positions);mesh.insert_attribute(Mesh::ATTRIBUTE_UV_0,uv0);
    mesh.insert_attribute(Mesh::ATTRIBUTE_UV_1,uv1);mesh.insert_attribute(Mesh::ATTRIBUTE_COLOR,colors);
    mesh.insert_indices(Indices::U32(indices)); Ok(Some(mesh))
}
fn release(draw:Draw,commands:&mut Commands,meshes:&mut Assets<Mesh>,materials:&mut Assets<StrictMaterial>) {
    commands.entity(draw.entity).try_despawn();meshes.remove(draw.mesh.id());materials.remove(draw.material.id());
}
fn clear(live:&mut Live,current:&mut Current,commands:&mut Commands,
    meshes:&mut Assets<Mesh>,materials:&mut Assets<StrictMaterial>) {
    current.invalidate();live.state=State::default();
    for (_,draw) in std::mem::take(&mut live.rows) {release(draw,commands,meshes,materials);}
}
type OwnedQuery<'w,'s> = Query<'w,'s,(&'static Mesh3d,&'static MeshMaterial3d<StrictMaterial>,
    &'static Transform,&'static GlobalTransform,Has<NoAutomaticBatching>,Has<ChildOf>),With<Owned>>;
fn synchronize(commands:&mut Commands,live:&mut Live,current:&mut Current,
    meshes:&mut Assets<Mesh>,materials:&mut Assets<StrictMaterial>,profile:&Profile,frame:&Frame,
    events:&Events,requests:&[EventRequest],paused:bool,owned:&OwnedQuery,base_model_selected:bool) -> Result<(),&'static str> {
    if !base_model_selected {return Err("R ImpactComplex restored base model not selected");}
    if !events.context().is_some_and(|(session,epoch,_)|session==frame.frontier.source.session && epoch==frame.frontier.accepted_epoch) {
        return Err("R ImpactComplex authority/frontier mismatch");
    }
    let plan=live.state.plan(events,requests,frame.clock,paused,&profile.authored,crate::ezreal_r_flash_simulation::map10_height)?;
    let mut prepared=Vec::new();
    for (key,entry) in &plan.rows {
        let Some(mesh)=geometry(entry,frame.view,frame.camera_position)? else {continue;};
        let bounds=mesh.compute_aabb().ok_or("R ImpactComplex mesh bounds invalid")?;
        prepared.push((*key,entry.request.incarnation(),mesh,bounds,material(profile,frame)?));
    }
    let revision=live.revision.checked_add(1).ok_or("R ImpactComplex revision exhausted")?;
    // Preparation has no externally committed RNG or particles. Check all owned
    // references before altering assets. A failed frame clears only this host.
    for draw in live.rows.values() {
        if !meshes.contains(draw.mesh.id()) || !materials.contains(draw.material.id())
            || !owned.get(draw.entity).is_ok_and(|(mesh,material,t,g,no_batch,parent)|
                mesh.0.id()==draw.mesh.id() && material.0.id()==draw.material.id()
                && *t==Transform::IDENTITY && *g==GlobalTransform::IDENTITY && no_batch && !parent) {
            return Err("R ImpactComplex owned draw changed");
        }
    }
    let retired:Vec<_>=live.rows.keys().filter(|key|!prepared.iter().any(|p|p.0==**key)).copied().collect();
    for key in retired {release(live.rows.remove(&key).unwrap(),commands,meshes,materials);}
    let mut requests=Vec::new();
    for (key,incarnation,mesh,bounds,material) in prepared {
        if live.rows.get(&key).is_some_and(|old|old.incarnation!=incarnation) {
            release(live.rows.remove(&key).unwrap(),commands,meshes,materials);
        }
        let geometry=(frame.frontier.accepted_epoch,frame.clock.to_bits(),frame.view.map(f32::to_bits));
        if let Some(draw)=live.rows.get_mut(&key) {
            if draw.geometry!=geometry {
                // A changed population/camera gets a NEW AssetId. RenderAssets
                // cannot substitute the preceding GPU mesh while upload waits.
                let replacement=meshes.add(mesh);meshes.remove(draw.mesh.id());
                draw.mesh=replacement;draw.geometry=geometry;
                commands.entity(draw.entity).insert((Mesh3d(draw.mesh.clone()),bounds));
            }
            *materials.get_mut(draw.material.id()).ok_or("R ImpactComplex material disappeared")?=material;
        } else {
            let mesh=meshes.add(mesh);let material=materials.add(material);
            let entity=commands.spawn((Owned,Mesh3d(mesh.clone()),MeshMaterial3d(material.clone()),bounds,
                Transform::IDENTITY,GlobalTransform::IDENTITY,Visibility::Inherited,NoAutomaticBatching,
                bevy::light::NotShadowCaster,bevy::light::NotShadowReceiver)).id();
            live.rows.insert(key,Draw {entity,mesh,material,incarnation,geometry});
        }
        let draw=&live.rows[&key];requests.push(Request {entity:draw.entity,material:draw.material.clone(),
            pool_incarnation:incarnation,input_revision:revision});
    }
    current.replace(frame.frontier.clone(),requests)?;
    live.state=plan;live.revision=revision;Ok(())
}
fn update(mut commands:Commands,
    inputs:(Res<crate::native_effect_clock::EffectClock>,Res<crate::Match>,Res<crate::Connection>,
        Res<crate::fow_champion_sources::Sources>,Res<crate::map10_vision_view::Map10VisionView>,
        Res<crate::fow_visibility_texture::VisibilityTexture>,Res<crate::fow_gpu::Images>,
        Res<crate::camera_native::NativeCamera>,Res<crate::animation::Catalog>),
    batch:Res<crate::ezreal_r_impact_dispatch::Batch>,frame_number:Res<bevy::diagnostic::FrameCount>,
    profile:Option<Res<Profile>>,images:Res<Assets<Image>>,mut meshes:ResMut<Assets<Mesh>>,
    mut materials:ResMut<Assets<StrictMaterial>>,mut live:ResMut<Live>,mut current:ResMut<Current>,
    cameras:Query<(Entity,&Camera),With<Camera3d>>,owned:OwnedQuery) {
    let (clock,state,connection,sources,map,texture,gpu,native_camera,catalog)=inputs;
    // Dispatcher drains once; all impact groups borrow the same immutable frame.
    let result=(|| {
        let requests=batch.requests(frame_number.0,clock.now,&state.ezreal_r_flash_events)?;
        let profile=profile.as_deref().ok_or("R ImpactComplex profile unavailable")?;
        profile.validate(&images)?;
        let (session,viewer,Some(epoch))=connection.inventory_input_identity().ok_or("R ImpactComplex session unavailable")?
            else {return Err("R ImpactComplex requires atomic OLSR");};
        if !connection.ready() || !clock.presentation_ready() || !clock.now.is_finite() {return Err("R ImpactComplex clock unavailable");}
        let snapshot=state.snapshot.as_ref().ok_or("R ImpactComplex snapshot absent")?;
        if snapshot.session!=session || snapshot.winner.is_some() || snapshot.result.is_some() || snapshot.map10.is_none() {return Err("R ImpactComplex session ended");}
        let team=snapshot.roster.iter().find(|p|p.id==viewer).ok_or("R ImpactComplex viewer absent")?.team;
        let mut active=cameras.iter().filter(|(_,camera)|camera.is_active);
        let (camera,_)=active.next().ok_or("R ImpactComplex camera absent")?;
        if active.next().is_some() {return Err("R ImpactComplex camera ambiguous");}
        let source=sources.mask_stamp(&map,session,team).ok_or("R ImpactComplex FoW source absent")?;
        if source.represented_tick!=snapshot.tick {return Err("R ImpactComplex FoW tick stale");}
        let publication=texture.publication_for(&sources,&map,session,team).ok_or("R ImpactComplex FoW publication absent")?;
        if !publication.source.same_episode(&source) || !images.contains(gpu.output.id()) {
            return Err("R ImpactComplex FoW episode/output unavailable");
        }
        let uniforms=texture.settings.shader_parameters(map.geometry.extent).map_err(|_|"R ImpactComplex FoW parameters invalid")?;
        if Vec4::from_array(uniforms.coordinates)!=crate::native_fow::FogParams::from_native_extent(map.geometry.extent)?.params() {
            return Err("R ImpactComplex unsupported FoW coordinate policy");
        }
        let parameters=native_camera.native_parameters().ok_or("R ImpactComplex native camera not ready")?;
        let view=openleague_core::camera_view::from_parameters(parameters)?;
        let frame=Frame {frontier:Frontier {source,accepted_epoch:epoch,camera},visibility:gpu.output.clone(),
            extent:map.geometry.extent,view,camera_position:parameters.position,clock:clock.now};
        let events=&state.ezreal_r_flash_events;
        if events.context()!=Some((session,epoch,viewer)) {return Err("R ImpactComplex event context changed");}
        synchronize(&mut commands,&mut live,&mut current,&mut meshes,&mut materials,profile,&frame,
            events,requests,clock.paused(),&owned,catalog.r_sparks_base_model_selected())
    })();
    if let Err(error)=result {
        clear(&mut live,&mut current,&mut commands,&mut meshes,&mut materials);
        if live.last_error!=Some(error) {debug!("{} waiting: {error}",authored::POLICY);live.last_error=Some(error);}
    } else {live.last_error=None;}
}
pub(crate) struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self,app:&mut App) {
        app.init_resource::<Live>().add_systems(Startup,setup)
            .add_systems(PostUpdate,update.after(crate::ezreal_r_impact_dispatch::Dispatch).after(bevy::asset::AssetEventSystems)
                .before(bevy::camera::visibility::VisibilitySystems::CalculateBounds)
                .before(bevy::camera::visibility::VisibilitySystems::VisibilityPropagate));
    }
}
#[cfg(test)]
#[path="ezreal_r_impact_complex_live_tests.rs"]
mod tests;
