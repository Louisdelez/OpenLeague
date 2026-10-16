//! Active selected Ring plus conditional own fresh-source Firefly Destroy admission.
//! Original Firefly/Well/provider/whole-frame stay unqualified.
//! Activation, stationary map ownership, seed/globals, sampler/cull are explicit own adapters.
use bevy::{prelude::*,asset::{AssetId,AssetEvent,AssetEventSystems},ecs::message::MessageCursor,
    image::{ImageSampler,ImageSamplerDescriptor,ImageAddressMode,ImageFilterMode,CompressedImageFormats},
    camera::primitives::MeshAabb};
use std::collections::HashSet;
use openleague_core::{native_random::Rng55,native_complex_quad_binding as binding,native_complex_type0_quad as quad};
use crate::{tt_well_ring_sampler as sampler,tt_well_ring_state as state,
    nexus_glow_material::{GlowMaterial,Inputs},nexus_complex_material::{Cull,OutputEncoding},
    relic_image_reference_store::{Store,Lease},relic_rune_image_bindings::{Bindings,Source},Connection,Match};
pub const PLATFORM:&[u8]=include_bytes!("../../../assets/particles/relic_runes/TT_Heal_Platform.dds");
pub const COLOR:&[u8]=include_bytes!("../../../assets/particles/relic_runes/DefaultColorOverLifetime.dds");
const OVERLAY:&str="maps/terrain_native/DefaultFogOfWarOverlay.png";

// Selected source admission at the actual Ring startup, before any retention
// RNG/instance/image work. A null named group alone is never this admission.
const FIREFLY_SOURCE_TEXT:&str=include_str!("../../../data/4.20/relic_runes/TT_Heal_RuneWell.json");
const FIREFLY_GROUP:&str="Firefly_Spin";
/// This owned adapter has no native merged cache/provider. Any future caller
/// supplying those inputs must refuse this selected no-overlay admission.
#[derive(Resource,Clone,Copy,Debug,PartialEq,Eq)]
pub struct FireflySourcePolicy {
    pub fresh_primary:bool,pub overlay_supplied:bool,pub external_provider_supplied:bool,
    pub material_override_supplied:bool,pub prior_diffuse_supplied:bool,
}
impl Default for FireflySourcePolicy {
    fn default()->Self {Self{fresh_primary:true,overlay_supplied:false,external_provider_supplied:false,
        material_override_supplied:false,prior_diffuse_supplied:false}}
}
fn firefly_policy(policy:FireflySourcePolicy)->Result<(),String>{
    if !policy.fresh_primary{return Err("Firefly dormant admission requires a fresh own primary".into());}
    if policy.overlay_supplied{return Err("Firefly overlay is not admitted; cannot silently omit a group".into());}
    if policy.external_provider_supplied{return Err("Firefly foreign provider is not admitted".into());}
    if policy.material_override_supplied{return Err("Firefly foreign material overrides are not admitted".into());}
    if policy.prior_diffuse_supplied{return Err("Firefly prior diffuse inheritance is not admitted".into());}
    Ok(())
}
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
pub struct DormantFirefly {
    single_field_334:u32,rate_max_field_d4_bits:u32,flex_flag_4b8:bool,
    material_override_vector_empty:bool,particle_kind:u32,
}
impl DormantFirefly {
    pub fn evidence(&self)->serde_json::Value {
        serde_json::json!({"schema":1,"pid":std::process::id(),"slot":2,"group":FIREFLY_GROUP,
            "source_troy_sha256":sampler::SOURCE_TROY_SHA256,"source_policy":"own fresh primary, no overlay/provider/override/prior diffuse",
            "inputs":{"single_field_334":self.single_field_334,"rate_max_field_d4_bits":self.rate_max_field_d4_bits,
                "flex_flag_4b8":self.flex_flag_4b8,"auxiliary_material_override_vector_nonempty":!self.material_override_vector_empty},
            "particle_kind":self.particle_kind,"emitter_class":"Complex","factory_decision":"Destroy",
            "local_status":"Dormant","active_instance_allocated":false,"diffuse_request":null,
            "original_provider_qualified":false,"original_factory_execution_qualified":false,
            "full_Well_qualified":false,"original_global_RNG_qualified":false,"native_pixels_qualified":false})
    }
}
fn firefly_raw_absent(input:&serde_json::Value,key:&str)->Result<(),String>{
    let hash=FIREFLY_GROUP.bytes().chain([b'*']).chain(key.bytes()).fold(0u32,|value,byte|
        value.wrapping_mul(65599).wrapping_add(byte.to_ascii_lowercase() as u32));
    let named=input["fields"].as_array().ok_or("Firefly raw named ledger absent")?;
    let unknown=input["unknown_fields"].as_object().ok_or("Firefly raw unknown ledger absent")?;
    if named.iter().any(|row|row["native_hash"].as_u64()==Some(hash as u64))||unknown.contains_key(&hash.to_string()){
        return Err(format!("Firefly source producer {key} is present; active/Retain route is unsupported"));
    }Ok(())
}
fn firefly_require_destroy(input:openleague_core::native_complex_factory_admission::Input)->Result<(),String>{
    use openleague_core::native_complex_factory_admission::{self as factory,Decision};
    if factory::decide(input)!=Decision::Destroy{
        return Err(format!("Firefly native factory Retain is unsupported; cannot silently mark Dormant: {input:?}"));
    }Ok(())
}
fn firefly_from_document(input:&serde_json::Value,policy:FireflySourcePolicy)->Result<DormantFirefly,String>{
    firefly_policy(policy)?;
    if input["source"]["sha256"].as_str()!=Some(sampler::SOURCE_TROY_SHA256)||input["semantics_qualified"]!=false{
        return Err("Firefly source identity/qualification scope changed".into());
    }
    let sections=input["sections"].as_object().ok_or("Firefly source sections absent")?;
    let system=sections.get("System").ok_or("Firefly System absent")?;
    let groups=input["groups"].as_array().ok_or("Firefly declarations absent")?;
    if groups.len()!=2||groups[1]["slot"]!=2||groups[1]["name"]!=FIREFLY_GROUP
        ||!groups[1]["fields"].is_null()||sections.contains_key(FIREFLY_GROUP)||system["GroupPart2"]!=FIREFLY_GROUP
        ||crate::native_particle_class::EmitterClass::from_system(system,2)?!=crate::native_particle_class::EmitterClass::Complex{
        return Err("Firefly selected declaration/class changed; no dormant admission".into());
    }
    // Actual raw namespace hashes, including all310 unnamed entries. Missing
    // scalar base AND first numbered knot closes the bounded reader branch.
    for key in ["single-particle","e-rate","e-rate1","p-type","p-texture"]{firefly_raw_absent(input,key)?;}
    for i in 0..3 {for key in [format!("e-rate_flex{i}"),format!("e-rate_flex{i}1")]{firefly_raw_absent(input,&key)?;}}
    for i in 0..4 {for tail in ["SubMesh","Texture","GlossTexture","Priority","UVScroll","FixedAlphaScrolling","BlendMode"]{
        firefly_raw_absent(input,&format!("MaterialOverride{i}{tail}"))?;
    }}
    let reference:serde_json::Value=serde_json::from_str(FIREFLY_SOURCE_TEXT).map_err(|e|format!("Firefly source JSON: {e}"))?;
    if input!=&reference{return Err("Firefly frozen source changed; provider/overlay or unknown-hash additions are unsupported".into());}
    // This is a selected decoded numeric adapter, not the original raw cache
    // parser. It calls the existing scalar reader; its None result selects the
    // primary912138..912151 one-entry zero/max0 fallback, not ctor max100.
    let selected=&input["sections"][FIREFLY_GROUP];
    let read=|key:&str|openleague_core::native_scalar_parameter::ScalarParameter::read_numeric(key,0.,
        |name|crate::relic_pickup_complex_profiles::numeric(selected,name))
        .map_err(|e|format!("Firefly selected missing scalar {key}: {e:?}"));
    let rate_max=match read("e-rate")? {None=>0.,Some(_)=>return Err("Firefly authored rate requires active Retain route".into())};
    let mut flex=false;
    for i in 0..3 {if read(&format!("e-rate_flex{i}"))?.is_some(){flex=true;}}
    // Selected getter caller fallback single0; primary910A5D fresh flexfalse;
    // ctor3A8/3AC empty and material reader indices0..3 add only nonzero flags.
    // These defaults are admitted only after all determinant hashes above.
    let input=openleague_core::native_complex_factory_admission::Input{single_field_334:0,
        rate_max_field_d4:rate_max,flex_flag_4b8:flex,auxiliary_vector_nonempty:false};
    firefly_require_destroy(input)?;
    Ok(DormantFirefly{single_field_334:input.single_field_334,rate_max_field_d4_bits:input.rate_max_field_d4.to_bits(),
        flex_flag_4b8:input.flex_flag_4b8,material_override_vector_empty:!input.auxiliary_vector_nonempty,particle_kind:0})
}
#[derive(Clone,Copy,Debug,PartialEq,Eq,PartialOrd,Ord,Hash)]
pub struct Key {pub session:u64,pub ready_tick:u64,pub generation:u64}
#[derive(Clone)]
struct Effect {key:Key,owner:state::OwnerFrame,emitter:state::Emitter}
#[derive(Resource)]
struct Host {profile:sampler::Profile,rotations:Vec<crate::tt_capture_sampler::RotationSource>,rng:Rng55,
    effect:Option<Effect>,generation:u64,ordinal:u64,last_clock:Option<f64>,firefly:DormantFirefly}
#[derive(Resource,Default)]
pub struct Diagnostics {pub error:Option<String>,pub ordinal:u64,pub particles:usize,pub draws:usize,
    pub retired:u64,pub rng_seed:Option<u32>,pub normal_cleanup:Option<bool>,
    pub active_key:Option<Key>,pub retired_key:Option<Key>,
    pub firefly_admission:Option<DormantFirefly>,pub firefly_admission_error:Option<String>}
#[derive(Component,Clone,Debug,PartialEq,Eq)]
pub struct Ticket {pub key:Key,pub group:usize,pub birth:u32,pub draw:Entity,pub mesh:AssetId<Mesh>,
    pub material:AssetId<GlowMaterial>,pub images:[AssetId<Image>;4],pub layouts:[ImageLayout;2]}
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
pub struct ImageLayout {pub extent:[u32;3],pub mips:u32,pub format:bevy::render::render_resource::TextureFormat}
struct Owned {ticket:Ticket,mesh:Handle<Mesh>,material:Handle<GlowMaterial>}
struct Prepared {key:Key,group:usize,birth:u32,mesh:Mesh,bounds:bevy::camera::primitives::Aabb,
    material:GlowMaterial,images:[AssetId<Image>;4],layouts:[ImageLayout;2]}
#[derive(Clone,Copy,PartialEq,Eq)]
struct MaterialInputs {images:[AssetId<Image>;4],layouts:[ImageLayout;2],extent_bits:u32}
struct MaterialCache {inputs:MaterialInputs,template:GlowMaterial}
#[derive(Resource,Default)]
pub struct Backend {draws:Vec<Owned>,store:Store,bindings:Option<Bindings>,overlay:Handle<Image>,
    failed_leases:Vec<Lease>,cursor:MessageCursor<AssetEvent<Image>>,watched:Vec<AssetId<Image>>,
    material_cursor:MessageCursor<AssetEvent<GlowMaterial>>,material_cache:Option<MaterialCache>,
    invalidated:bool,pub error:Option<String>,pub published_frames:u64}
impl Backend {
    pub fn tickets(&self)->Vec<Ticket>{self.draws.iter().map(|d|d.ticket.clone()).collect()}
    fn matches(world:&World,d:&Owned)->bool {
        world.get::<Ticket>(d.ticket.draw)==Some(&d.ticket)
            &&world.get::<Mesh3d>(d.ticket.draw).map(|m|m.id())==Some(d.ticket.mesh)
            &&world.get::<MeshMaterial3d<GlowMaterial>>(d.ticket.draw).map(|m|m.id())==Some(d.ticket.material)
            &&world.get::<ChildOf>(d.ticket.draw).is_none()
            &&world.get::<Transform>(d.ticket.draw)==Some(&Transform::IDENTITY)
            &&world.get::<GlobalTransform>(d.ticket.draw)==Some(&GlobalTransform::IDENTITY)
            &&world.get::<Visibility>(d.ticket.draw).is_some()
    }
    fn hide(&self,world:&mut World) {
        for d in &self.draws {if Self::matches(world,d) {
            if let Some(mut v)=world.get_mut::<Visibility>(d.ticket.draw){*v=Visibility::Hidden;}
            if let Some(mut assets)=world.get_resource_mut::<Assets<GlowMaterial>>(){
                if assets.get(&d.material).is_some_and(|m|m.is_admitted()){
                    assets.get_mut(&d.material).unwrap().set_admitted(false);
                }
            }
        }}
    }
    fn clear_draws(&mut self,world:&mut World)->Result<(),String> {
        self.hide(world);let mut retained=Vec::new();
        for d in self.draws.drain(..) {
            if !Self::matches(world,&d) {retained.push(d);continue;}
            world.despawn(d.ticket.draw);
            if let Some(mut a)=world.get_resource_mut::<Assets<Mesh>>(){a.remove(d.mesh.id());}
            if let Some(mut a)=world.get_resource_mut::<Assets<GlowMaterial>>(){a.remove(d.material.id());}
        }
        self.draws=retained;
        if self.draws.is_empty(){Ok(())}else{Err("TT Well Ring foreign draw ownership retained; image leases not released".into())}
    }
    // Lost map activation ownership must retire draws even with a failed clock.
    // Foreign components remain owned until restored; no shared entity is removed.
    fn retire_effects(&mut self,world:&mut World,keys:&HashSet<Key>)->Result<(),String> {
        let mut retained=Vec::new();let mut foreign=false;
        for d in self.draws.drain(..) {
            if keys.contains(&d.ticket.key) {
                retained.push(d);continue;
            }
            if !Self::matches(world,&d) {foreign=true;retained.push(d);continue;}
            world.despawn(d.ticket.draw);
            if let Some(mut assets)=world.get_resource_mut::<Assets<Mesh>>(){assets.remove(d.mesh.id());}
            if let Some(mut assets)=world.get_resource_mut::<Assets<GlowMaterial>>(){assets.remove(d.material.id());}
        }
        self.draws=retained;
        if foreign {Err("TT Well Ring lost event has foreign draw ownership; retained for safe cleanup".into())} else {Ok(())}
    }
    fn release(&mut self,world:&mut World)->Result<(),String> {
        self.clear_draws(world)?;
        // Cached strong handles are owned too; drop them before retiring DDS leases.
        self.material_cache=None;
        let mut assets=world.get_resource_mut::<Assets<Image>>().ok_or("TT Well Ring image assets absent at release")?;
        if let Some(bindings)=self.bindings.take(){if let Err(error)=bindings.retire(&mut self.store,&mut assets){
            self.failed_leases.extend(error.leases);return Err(error.message);
        }}
        let mut failed=Vec::new();for lease in self.failed_leases.drain(..){
            if let Err(error)=self.store.release(lease,&mut assets){failed.push(error.lease);}
        }self.failed_leases=failed;
        if !self.failed_leases.is_empty(){return Err("TT Well Ring failed image leases remain owned".into());}
        self.store.cleanup_renderer(&mut assets)?;self.watched.clear();Ok(())
    }
    fn load(&mut self,world:&mut World)->Result<(),String> {
        if self.invalidated{return Err("TT Well Ring source asset changed; verified source restart required".into());}
        if !self.failed_leases.is_empty() {
            let mut images=world.get_resource_mut::<Assets<Image>>().ok_or("TT Well Ring partial lease cleanup pending")?;
            let mut retained=Vec::new();
            for lease in self.failed_leases.drain(..){if let Err(error)=self.store.release(lease,&mut images){retained.push(error.lease);}}
            self.failed_leases=retained;
            if !self.failed_leases.is_empty(){return Err("TT Well Ring partial leases cannot be released; no reacquire".into());}
        }
        if self.bindings.is_none() {
            // Explicit existing Bevy sampling policy, not an original device claim.
            let sampler=ImageSampler::Descriptor(ImageSamplerDescriptor {address_mode_u:ImageAddressMode::ClampToEdge,
                address_mode_v:ImageAddressMode::ClampToEdge,mag_filter:ImageFilterMode::Linear,
                min_filter:ImageFilterMode::Linear,mipmap_filter:ImageFilterMode::Linear,lod_min_clamp:0.,..default()});
            let spark=std::ffi::CString::new("TT_Heal_Platform.tga").unwrap();
            let color=std::ffi::CString::new("DefaultColorOverLifetime.dds").unwrap();
            let diffuse=Source::request(&spark,&spark,PLATFORM,sampler.clone(),false)?;
            let color=Source::request(&color,&color,COLOR,sampler,false)?;
            let compressed=CompressedImageFormats::from_features(world.get_resource::<bevy::render::renderer::RenderDevice>()
                .ok_or("TT Well Ring actual GPU device pending")?.features());
            let mut images=world.get_resource_mut::<Assets<Image>>().ok_or("TT Well Ring images absent")?;
            let bindings=Bindings::acquire(&mut self.store,&mut images,compressed,diffuse,color)
                .map_err(|error|{self.failed_leases.extend(error.leases);error.message})?;
            // Store the leases BEFORE registration: a failed register cannot drop ownership.
            self.bindings=Some(bindings);
            self.bindings.as_ref().unwrap().register(&mut self.store,&images)?;
        }
        let fog=world.get_resource::<crate::fow_gpu::Images>().ok_or("TT Well Ring FoW pending")?.output.clone();
        let images=world.get_resource::<Assets<Image>>().ok_or("TT Well Ring image assets absent")?;
        let handles=self.bindings.as_ref().unwrap().images_render_fog(&self.store,images,[fog,self.overlay.clone()])?;
        self.watched=handles.iter().map(Handle::id).collect();
        Ok(())
    }
    fn publish(&mut self,world:&mut World,packets:Vec<Prepared>)->Result<(),String> {
        let published_frames=self.published_frames.checked_add(1).ok_or("TT Well Ring publication counter overflow")?;
        let mut identities=HashSet::new();
        for p in &packets {
            if p.group!=0 || p.birth==0 || !identities.insert((p.key,p.group,p.birth)){
                return Err("TT Well Ring duplicate/out-of-source particle identity".into());
            }
            if let Some(old)=self.draws.iter().find(|d|d.ticket.key==p.key&&d.ticket.group==p.group&&d.ticket.birth==p.birth){
                if old.ticket.images!=p.images||old.ticket.layouts!=p.layouts{
                    return Err("Ring retained immutable material inputs changed".into());
                }
            }

        }
        for d in &self.draws {if !Self::matches(world,d)
            ||world.resource::<Assets<Mesh>>().get(&d.mesh).is_none()
            ||!world.resource::<Assets<GlowMaterial>>().get(&d.material).is_some_and(|m|m.is_admitted()){
                return Err("TT Well Ring retained draw/material ownership changed".into());
            }
        }
        let mut output=Vec::new();output.try_reserve_exact(packets.len()).map_err(|_|"TT Well Ring draw allocation")?;
        for p in packets {
            let old=self.draws.iter().position(|d|d.ticket.key==p.key
                &&d.ticket.group==p.group&&d.ticket.birth==p.birth);
            let d=if let Some(index)=old {
                let mut d=self.draws.swap_remove(index);
                *world.resource_mut::<Assets<Mesh>>().get_mut(&d.mesh).unwrap()=p.mesh;
                // Immutable material inputs were validated before mutation. Keep
                // admission/visibility and avoid material Modified events every frame.
                d.ticket.images=p.images;d.ticket.layouts=p.layouts;world.entity_mut(d.ticket.draw).insert((p.bounds,d.ticket.clone()));d
            }else{
                let mesh=world.resource_mut::<Assets<Mesh>>().add(p.mesh);
                let mut value=p.material;value.set_admitted(true);
                let material=world.resource_mut::<Assets<GlowMaterial>>().add(value);
                let draw=world.spawn((Name::new(format!("TT Well Ring group{} birth{}",p.group,p.birth)),
                    Mesh3d(mesh.clone()),MeshMaterial3d(material.clone()),Transform::IDENTITY,
                    GlobalTransform::IDENTITY,p.bounds,Visibility::Hidden)).id();
                let ticket=Ticket {key:p.key,group:p.group,birth:p.birth,draw,
                    mesh:mesh.id(),material:material.id(),images:p.images,layouts:p.layouts};
                world.entity_mut(draw).insert(ticket.clone());Owned {ticket,mesh,material}
            };output.push(d);
        }
        let old=std::mem::replace(&mut self.draws,output);
        for d in old {
            // Ownership was validated before mutation; no external system interleaves.
            world.despawn(d.ticket.draw);world.resource_mut::<Assets<Mesh>>().remove(d.mesh.id());
            world.resource_mut::<Assets<GlowMaterial>>().remove(d.material.id());
        }
        for d in &self.draws {
            if world.get::<Visibility>(d.ticket.draw)!=Some(&Visibility::Visible){
                *world.get_mut::<Visibility>(d.ticket.draw).unwrap()=Visibility::Visible;
            }
        }
        self.published_frames=published_frames;Ok(())
    }
}

fn initialize(world:&mut World){
    let firefly=(||->Result<DormantFirefly,String>{
        let policy=world.get_resource::<FireflySourcePolicy>().copied().ok_or("Firefly own fresh source policy absent")?;
        let document:serde_json::Value=serde_json::from_str(FIREFLY_SOURCE_TEXT).map_err(|e|format!("Firefly source JSON: {e}"))?;
        firefly_from_document(&document,policy)
    })();
    match &firefly {
        Ok(admission)=>{world.resource_mut::<Diagnostics>().firefly_admission=Some(*admission);
            world.resource_mut::<Diagnostics>().firefly_admission_error=None;
            println!("TT_Well_Firefly_source_admission {}",admission.evidence());},
        Err(error)=>{world.resource_mut::<Diagnostics>().firefly_admission=None;
            world.resource_mut::<Diagnostics>().firefly_admission_error=Some(error.clone());
            warn!("TT Well Firefly source admission rejected: {error}");},
    }
    let result=(||->Result<Host,String>{
        let firefly=firefly?;
        let profile=sampler::profile()?;
        let time=std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).map_err(|_|"Ring local seed before epoch")?;
        let filetime=u64::try_from(time.as_nanos()/100).ok().and_then(|v|v.checked_add(116_444_736_000_000_000))
            .ok_or("Ring local seed overflow")?;
        let seed=Rng55::seed_from_filetime(filetime);let mut rng=Rng55::from_filetime(filetime);
        let rotations=profile.retained(&mut rng)?;world.resource_mut::<Diagnostics>().rng_seed=Some(seed);
        Ok(Host{profile,rotations,rng,effect:None,generation:0,ordinal:0,last_clock:None,firefly})
    })();
    match result{Ok(host)=>{world.insert_resource(host);},Err(error)=>{world.resource_mut::<Diagnostics>().error=Some(error);return;}}
    let overlay=world.get_resource::<AssetServer>().map(|a|a.load(OVERLAY)).unwrap_or_default();
    world.resource_mut::<Backend>().overlay=overlay;
}
/// Exact existing GLB placement predicate, independently used for an actorless effect.
/// This is ordinary own presentation policy, not recovered TT_RelicAura activation.
fn desired(snapshot:&openleague_core::Snapshot,session:Option<u64>,ready:bool)->Option<(u64,u64,state::OwnerFrame)>{
    if !ready||session!=Some(snapshot.session)||snapshot.winner.is_some(){return None;}
    let map=snapshot.map10.as_ref()?;if !map.relic_visible||!map.relic_available{return None;}
    let position=[map.relic_position.x,map.relic_height,map.relic_position.z];
    if position.iter().any(|v|!v.is_finite()){return None;}
    Some((snapshot.session,map.relic_ready_tick,state::OwnerFrame{native_position:position.map(f32::to_bits)}))
}
fn prepared(world:&World,backend:&mut Backend,effect:&Effect,extent:f32,fog:Handle<Image>)->Result<Vec<Prepared>,String>{
    let camera=world.get_resource::<crate::camera_native::NativeCamera>().ok_or("Ring native camera absent")?;
    let images=world.get_resource::<Assets<Image>>().ok_or("Ring images absent")?;
    let bindings=backend.bindings.as_ref().ok_or("Ring DDS leases pending")?;
    // Full primary flags16 are explicitly projected to low depth route0. This
    // type0 policy does not claim the animated-mesh/full native shader branch.
    let handles=bindings.images_render_fog(&backend.store,images,[fog,backend.overlay.clone()])?;
    let layouts=std::array::from_fn(|i|{let d=&images.get(&handles[i]).expect("Ring DDS validated").texture_descriptor;
        ImageLayout{extent:[d.size.width,d.size.height,d.size.depth_or_array_layers],mips:d.mip_level_count,format:d.format}});
    let inputs=MaterialInputs{images:handles.each_ref().map(|h|h.id()),layouts,extent_bits:extent.to_bits()};
    if let Some(cache)=&backend.material_cache{
        if cache.inputs!=inputs{return Err("Ring immutable material source/extent changed; new verified activation required".into());}
    }else{
        let template=GlowMaterial::new_owned_render_fog(bindings,&backend.store,images,[handles[2].clone(),backend.overlay.clone()],
            Inputs{native_fog_extent:extent,encoding:OutputEncoding::RawNumeric,cull:Cull::Back,
                render_mode:0,render_flags:0,shader_features:0})?;
        backend.material_cache=Some(MaterialCache{inputs,template});
    }
    let material=backend.material_cache.as_ref().unwrap().template.clone();
    let systems=openleague_core::native_troy_resource_initial::empty_instance(0,[0;3],0.)?.scales.map(f32::from_bits);
    let mut output=Vec::new();output.try_reserve_exact(effect.emitter.particles.len()).map_err(|_|"Ring packet allocation")?;
    for p in &effect.emitter.particles{
        let fields=binding::DrawFields::from_record(&p.record,false)?;
        let axes=crate::nexus_glow_quad::current_native_axes(camera,fields.quad_angle)?;
        let factor=systems[1]*systems[0];let [r,g,b,a]=fields.rgba;
        // Native Well uniformscale defaultsfalse: preserve distinct sampled X/Y.
        let geometry=crate::nexus_glow_quad::geometry(quad::Input{center:fields.matrix_center,
            axis_a:axes.a.map(|v|v*(factor*fields.scale[0])),axis_b:axes.b.map(|v|v*(factor*fields.scale[1])),
            rgba:[r*a,g*a,b*a,1.],channel0_origin:fields.uv_scroll,channel0_z:fields.atlas_frame,
            channel1_origin:fields.lookup,channel1_corners:false},[2,1])?;
        let bounds=geometry.mesh.compute_aabb().ok_or("Ring finite bounds absent")?;
        output.push(Prepared{key:effect.key,group:0,birth:p.birth,mesh:geometry.mesh,bounds,
            material:material.clone(),images:handles.each_ref().map(|h|h.id()),layouts});
    }Ok(output)
}
pub fn synchronize(world:&mut World){
    let Some(mut host)=world.remove_resource::<Host>()else{return};
    let mut backend=world.remove_resource::<Backend>().unwrap_or_default();
    let mut diagnostic=world.remove_resource::<Diagnostics>().unwrap_or_default();let old=diagnostic.error.clone();
    let firefly_guard=world.get_resource::<FireflySourcePolicy>().copied().ok_or("Firefly own fresh source policy removed".to_owned())
        .and_then(firefly_policy);
    diagnostic.firefly_admission_error=firefly_guard.as_ref().err().cloned();
    diagnostic.firefly_admission=firefly_guard.as_ref().ok().map(|_|host.firefly);
    let result=(||->Result<(),String>{
        let connection=world.get_resource::<Connection>();let state=world.get_resource::<Match>();
        let wanted=connection.zip(state).and_then(|(c,s)|s.snapshot.as_ref().and_then(|s|desired(s,c.session,c.ready())));
        // Session/map retirement runs BEFORE clock/asset readiness. No actor entity is owned.
        if host.effect.as_ref().is_some_and(|e|wanted.as_ref().is_none_or(|(session,tick,pose)|
            e.key.session!=*session||e.key.ready_tick!=*tick||e.owner!=*pose)){
            diagnostic.retired_key=host.effect.as_ref().map(|e|e.key);
            host.effect=None;diagnostic.retired=diagnostic.retired.saturating_add(1);
        }
        let keys=host.effect.iter().map(|e|e.key).collect();backend.retire_effects(world,&keys)?;
        let Some((session,ready_tick,owner))=wanted else{backend.release(world)?;return firefly_guard.clone();};
        firefly_guard.clone()?;
        if let Some(events)=world.get_resource::<Messages<AssetEvent<Image>>>(){for event in backend.cursor.read(events){
            if matches!(event,AssetEvent::Modified{id}|AssetEvent::Removed{id} if backend.watched.contains(id)){backend.invalidated=true;}
        }}
        // No successful publication mutates a retained material. Any later
        // Modified/Removed event for an owned immutable material fails closed,
        // including an earlier diagnostic hide: recovery requires retirement.
        if let Some(events)=world.get_resource::<Messages<AssetEvent<GlowMaterial>>>(){for event in backend.material_cursor.read(events){
            if matches!(event,AssetEvent::Modified{id}|AssetEvent::Removed{id}
                if backend.draws.iter().any(|d|d.ticket.material==*id)){backend.invalidated=true;}
        }}
        let clock=world.get_resource::<crate::native_effect_clock::EffectClock>().ok_or("Ring canonical clock missing")?;
        if !clock.presentation_ready(){return Err("Ring canonical clock not attached, initialized and healthy".into());}
        let now=clock.now;if !now.is_finite()||now<0.||host.last_clock.is_some_and(|old|now<old){return Err("Ring canonical clock regressed".into());}
        let time=now as f32;if !time.is_finite(){return Err("Ring f32 clock overflow".into());}
        let ordinal=host.ordinal.checked_add(1).ok_or("Ring host ordinal overflow")?;
        backend.load(world)?;
        let camera=world.get_resource::<crate::camera_native::NativeCamera>().ok_or("Ring native camera pending")?;
        let _=crate::nexus_glow_quad::current_native_axes(camera,0.)?;
        let fog=world.get_resource::<crate::fow_gpu::Images>().ok_or("Ring FoW pending")?.output.clone();
        let extent=world.get_resource::<crate::map10_vision_view::Map10VisionView>().ok_or("Ring FoW extent pending")?.geometry.extent;
        let mut generation=host.generation;let mut effect=host.effect.clone();let mut random=host.rng.clone();
        if effect.is_none(){generation=generation.checked_add(1).ok_or("Ring activation generation overflow")?;
            effect=Some(Effect{key:Key{session,ready_tick,generation},owner,emitter:state::Emitter::new(time,owner)?});}
        let active=effect.as_mut().unwrap();active.emitter.step(&host.profile,&host.rotations,time,owner,&mut random)?;
        let packets=prepared(world,&mut backend,active,extent,fog)?;backend.publish(world,packets)?;
        host.effect=effect;host.rng=random;host.generation=generation;host.ordinal=ordinal;host.last_clock=Some(now);Ok(())
    })();
    diagnostic.error=result.err();backend.error=diagnostic.error.clone();if diagnostic.error.is_some(){backend.hide(world);}
    diagnostic.active_key=host.effect.as_ref().map(|e|e.key);
    diagnostic.ordinal=host.ordinal;diagnostic.particles=host.effect.as_ref().map_or(0,|e|e.emitter.particles.len());
    diagnostic.draws=backend.draws.len();if diagnostic.error!=old{if let Some(e)=&diagnostic.error{warn!("TT Ring presentation: {e}");}}
    world.insert_resource(host);world.insert_resource(backend);world.insert_resource(diagnostic);
}
pub(crate) fn shutdown(world:&mut World){
    if !world.get_resource::<Messages<bevy::app::AppExit>>().is_some_and(|m|!m.is_empty()){return;}
    let Some(mut backend)=world.remove_resource::<Backend>()else{return};let result=backend.release(world);
    if let Some(mut host)=world.get_resource_mut::<Host>(){host.effect=None;}
    let mut d=world.remove_resource::<Diagnostics>().unwrap_or_default();d.normal_cleanup=Some(result.is_ok());
    d.active_key=None;d.particles=0;d.draws=backend.draws.len();
    if let Err(e)=result{d.error=Some(e);}world.insert_resource(backend);world.insert_resource(d);
}
#[cfg(test)]
mod tests{
    use super::*;
    #[derive(Resource)]struct FixtureFog(Handle<Image>);

    #[test]
    fn Firefly_selected_Well_destroy_admission_has_no_emitter_or_diffuse_substitution(){
        let source:serde_json::Value=serde_json::from_str(FIREFLY_SOURCE_TEXT).unwrap();
        let admitted=firefly_from_document(&source,FireflySourcePolicy::default()).unwrap();
        assert_eq!(admitted,DormantFirefly{single_field_334:0,rate_max_field_d4_bits:0,flex_flag_4b8:false,
            material_override_vector_empty:true,particle_kind:0});
        let evidence=admitted.evidence();assert_eq!(evidence["factory_decision"],"Destroy");
        assert_eq!(evidence["active_instance_allocated"],false);assert!(evidence["diffuse_request"].is_null());
        assert_eq!(evidence["full_Well_qualified"],false);
        let mut world=World::new();world.init_resource::<Backend>();world.init_resource::<Diagnostics>();
        world.insert_resource(FireflySourcePolicy::default());initialize(&mut world);
        assert!(world.contains_resource::<Host>());assert_eq!(world.resource::<Diagnostics>().firefly_admission,Some(admitted));
        assert!(world.resource::<Diagnostics>().firefly_admission_error.is_none());
        assert!(world.resource::<Host>().effect.is_none());assert!(world.resource::<Backend>().tickets().is_empty());
        assert!(world.resource::<Backend>().bindings.is_none());
    }
    #[test]
    fn Firefly_foreign_source_and_provider_reject_before_Ring_startup_side_effects(){
        for failure in 0..6{
            let mut world=World::new();world.init_resource::<Backend>();world.init_resource::<Diagnostics>();
            world.init_resource::<Assets<Image>>();let overlay=world.resource_mut::<Assets<Image>>().add(Image::default());
            world.resource_mut::<Backend>().overlay=overlay.clone();let mut policy=FireflySourcePolicy::default();
            match failure{0=>policy.fresh_primary=false,1=>policy.overlay_supplied=true,2=>policy.external_provider_supplied=true,
                3=>policy.material_override_supplied=true,4=>policy.prior_diffuse_supplied=true,_=>{}}
            if failure!=5{world.insert_resource(policy);}initialize(&mut world);
            assert!(!world.contains_resource::<Host>());let d=world.resource::<Diagnostics>();
            assert!(d.error.as_ref().is_some_and(|e|e.contains("Firefly")));assert!(d.firefly_admission.is_none());
            assert!(d.firefly_admission_error.is_some());assert!(d.rng_seed.is_none());
            assert_eq!(world.resource::<Backend>().overlay,overlay);assert!(world.resource::<Backend>().bindings.is_none());
            assert!(world.resource::<Backend>().tickets().is_empty());
        }
        let mut changed:serde_json::Value=serde_json::from_str(FIREFLY_SOURCE_TEXT).unwrap();
        changed["unknown_fields"]["new_foreign_key"]=serde_json::json!({"value":1});
        assert!(firefly_from_document(&changed,FireflySourcePolicy::default()).unwrap_err().contains("frozen source changed"));
    }
    #[test]
    fn Firefly_retained_native_factory_inputs_never_become_dormant(){
        use openleague_core::native_complex_factory_admission::Input;
        for failure in 0..6{
            let mut input=Input{single_field_334:0,rate_max_field_d4:0.,flex_flag_4b8:false,auxiliary_vector_nonempty:false};
            match failure{0=>input.single_field_334=1,1=>input.rate_max_field_d4=1.,2=>input.flex_flag_4b8=true,
                3=>input.auxiliary_vector_nonempty=true,4=>input.rate_max_field_d4=-1.,_=>input.rate_max_field_d4=f32::NAN}
            assert!(firefly_require_destroy(input).unwrap_err().contains("Retain is unsupported"));
        }
    }
    fn snapshot()->openleague_core::Snapshot{
        let root=std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");
        let nav=openleague_core::Navigation::load(
            &std::fs::read_to_string(root.join("assets/maps/tt_navigation_grid.json")).unwrap(),
            &std::fs::read(root.join("assets/maps/tt_navigation_grid.cells.bin")).unwrap()).unwrap();
        let mut sim=openleague_core::Simulation::new(nav).unwrap();sim.enable_map10().unwrap();
        sim.session=41;sim.join("garen").unwrap();sim.tick=180*openleague_core::TICK_RATE;sim.advance();
        let mut assembler=openleague_core::wire::StateAssembler::default();let mut packet=None;
        for bytes in openleague_core::wire::state_datagrams(&sim.snapshot()).unwrap(){
            if let Some(value)=assembler.push(&bytes,Some(sim.session)){packet=Some(value);}
        }
        let openleague_core::ServerPacket::State(s)=serde_json::from_slice(&packet.unwrap()).unwrap()
            else{panic!("transported Map10 state required")};s
    }
    #[test]
    fn transported_Map10_placement_requires_current_visible_available_identity_without_actor_binding(){
        let source=snapshot();let map=source.map10.as_ref().unwrap();assert!(map.relic_available);
        let(_,tick,owner)=desired(&source,Some(source.session),true).unwrap();
        assert_eq!(tick,map.relic_ready_tick);
        assert_eq!(owner.native_position,[map.relic_position.x,map.relic_height,map.relic_position.z].map(f32::to_bits));
        assert!(desired(&source,Some(source.session+1),true).is_none());
        assert!(desired(&source,Some(source.session),false).is_none());
        for failure in 0..5{
            let mut bad=source.clone();match failure{
                0=>bad.map10.as_mut().unwrap().relic_available=false,
                1=>bad.map10.as_mut().unwrap().relic_visible=false,
                2=>bad.winner=Some(0),3=>bad.map10=None,
                _=>bad.map10.as_mut().unwrap().relic_height=f32::NAN,
            }
            assert!(desired(&bad,Some(source.session),true).is_none());
        }
    }
    fn fixture()->(World,Backend,Effect){
        let mut world=World::new();world.insert_resource(Assets::<Image>::default());
        world.insert_resource(Assets::<Mesh>::default());world.insert_resource(Assets::<GlowMaterial>::default());
        let p=sampler::profile().unwrap();let mut rng=Rng55::seeded(42);let r=p.retained(&mut rng).unwrap();
        let owner=state::OwnerFrame{native_position:[0;3]};let mut emitter=state::Emitter::new(0.,owner).unwrap();
        emitter.step(&p,&r,0.5,owner,&mut rng).unwrap();assert!(emitter.particles.len()>32);
        let effect=Effect{key:Key{session:41,ready_tick:5400,generation:1},owner,emitter};
        let mut backend=Backend::default();let diffuse=std::ffi::CString::new("TT_Heal_Platform.tga").unwrap();
        let color=std::ffi::CString::new("DefaultColorOverLifetime.dds").unwrap();let policy=ImageSampler::Descriptor(ImageSamplerDescriptor::default());
        let mut images=world.resource_mut::<Assets<Image>>();
        let b=Bindings::acquire(&mut backend.store,&mut images,CompressedImageFormats::BC,
            Source::request(&diffuse,&diffuse,PLATFORM,policy.clone(),false).unwrap(),
            Source::request(&color,&color,COLOR,policy,false).unwrap()).unwrap();
        b.register(&mut backend.store,&images).unwrap();backend.bindings=Some(b);
        // CPU-only fixture fog, never an ordinary render/FoW or pixel admission.
        let fog=images.add(Image::default());backend.overlay=images.add(Image::default());drop(images);
        let mut camera=crate::camera_native::NativeCamera::default();camera.pose(Vec3::new(370.,0.,385.),0.016,0.016).unwrap();
        world.insert_resource(camera);world.insert_resource(FixtureFog(fog));
        (world,backend,effect)
    }
    #[test]
    fn actorless_ring_publishes_above32_and_release_preserves_untagged_shared_Glow_draw(){
        let(mut world,mut backend,effect)=fixture();
        let fog=world.resource::<FixtureFog>().0.clone();
        let first=prepared(&world,&mut backend,&effect,15360.,fog.clone()).unwrap();
        // A foreign same-material-type draw must not be retired by the Ring host.
        let foreign_mesh=world.resource_mut::<Assets<Mesh>>().add(first[0].mesh.clone());
        // Independent copies of exact DDS fixture images: the foreign same-type
        // material does not borrow the Ring's private native image leases.
        let source=backend.bindings.as_ref().unwrap().images_render_fog(&backend.store,
            world.resource::<Assets<Image>>(),[fog.clone(),backend.overlay.clone()]).unwrap();
        let mut images=world.resource_mut::<Assets<Image>>();
        let diffuse=images.get(&source[0]).unwrap().clone();let diffuse=images.add(diffuse);
        let color=images.get(&source[1]).unwrap().clone();let color=images.add(color);drop(images);
        let textures=crate::nexus_glow_material::Textures{image:diffuse.clone(),color:color.clone(),
            samplers:std::array::from_fn(|_|ImageSamplerDescriptor::default())};
        let material=GlowMaterial::new(&textures,fog.clone(),backend.overlay.clone(),Inputs{
            native_fog_extent:15360.,encoding:OutputEncoding::RawNumeric,cull:Cull::Back,
            render_mode:0,render_flags:0,shader_features:0}).unwrap();
        let foreign_material=world.resource_mut::<Assets<GlowMaterial>>().add(material);
        let foreign=world.spawn((Mesh3d(foreign_mesh.clone()),MeshMaterial3d(foreign_material.clone()))).id();
        backend.publish(&mut world,first).unwrap();let tickets=backend.tickets();assert!(tickets.len()>32);
        let again=prepared(&world,&mut backend,&effect,15360.,fog).unwrap();backend.publish(&mut world,again).unwrap();
        assert_eq!(backend.tickets(),tickets);backend.release(&mut world).unwrap();
        assert!(backend.tickets().is_empty());assert!(world.get_entity(foreign).is_ok());
        assert!(world.resource::<Assets<Mesh>>().get(&foreign_mesh).is_some());
        assert!(world.resource::<Assets<GlowMaterial>>().get(&foreign_material).is_some());
        assert!(world.resource::<Assets<Image>>().get(&diffuse).is_some());
        assert!(world.resource::<Assets<Image>>().get(&color).is_some());
    }
    #[test]
    fn foreign_ring_ticket_blocks_image_lease_retirement_until_exact_ownership_restored(){
        let(mut world,mut backend,effect)=fixture();let fog=world.resource::<FixtureFog>().0.clone();
        let p=prepared(&world,&mut backend,&effect,15360.,fog).unwrap();backend.publish(&mut world,p).unwrap();
        let original=backend.tickets()[0].clone();let mut foreign=original.clone();foreign.birth=0;
        world.entity_mut(original.draw).insert(foreign.clone());
        assert!(backend.retire_effects(&mut world,&HashSet::new()).is_err());assert!(backend.release(&mut world).is_err());
        assert_eq!(world.get::<Ticket>(original.draw),Some(&foreign));assert!(backend.bindings.is_some());
        world.entity_mut(original.draw).insert(original);backend.retire_effects(&mut world,&HashSet::new()).unwrap();
        backend.release(&mut world).unwrap();assert_eq!(backend.store.len(),0);
    }
}
pub struct Plugin;
impl bevy::app::Plugin for Plugin{
    fn build(&self,app:&mut App){
        // GlowMaterial is shared with Nexus/Rune. Never register its plugin twice
        // or replace its global DrawMaterial/foreign guarded draw functions.
        if !app.is_plugin_added::<MaterialPlugin<GlowMaterial>>(){app.add_plugins(MaterialPlugin::<GlowMaterial>::default());}
        app.init_resource::<Backend>().init_resource::<Diagnostics>().init_resource::<FireflySourcePolicy>()
            .add_plugins(crate::tt_well_ring_readiness::Plugin)
            .add_systems(Startup,initialize.after(crate::fow_visibility_texture::setup))
            .add_systems(PostUpdate,synchronize.after(crate::receive).after(AssetEventSystems)
                .before(bevy::camera::visibility::VisibilitySystems::CalculateBounds)
                .before(bevy::camera::visibility::VisibilitySystems::VisibilityPropagate))
            .add_systems(Last,shutdown.after(bevy::window::ExitSystems));
    }
}
