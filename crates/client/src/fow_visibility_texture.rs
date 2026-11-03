//! Transport of qualified CPU expansion into a render-world Image asset.
//! Raw visibility only: native fade/blur, material sampling and backend readback remain open.
use bevy::{prelude::*,asset::RenderAssetUsages,image::{ImageSampler,ImageSamplerDescriptor,ImageAddressMode,ImageFilterMode},render::render_resource::{Extent3d,TextureDimension,TextureFormat}};
const DIM:usize=128;
const WIDTH:usize=DIM*4;
#[derive(Default)]
pub struct Staging {session:Option<(u64,u8)>,previous:f32,pub pixels:Vec<u8>,pub uploads:u64}
impl Staging {
    pub fn prepare(&mut self,session:(u64,u8),now:f32,source:&[u8])->Result<bool,&'static str> {
        if source.len()!=DIM*DIM {return Err("Map10 visibility source size mismatch");}
        if !now.is_finite() || now<0. {return Err("invalid visibility upload clock");}
        let reset=self.session!=Some(session);
        let previous=if reset {0.}else{self.previous};
        let due=crate::fow_timing::upload_due(now,previous)?;
        if reset {
            // Explicit Bevy allocation adapter: native untouched corners' allocation contents are unknown.
            self.pixels=vec![0;WIDTH*WIDTH];self.previous=0.;self.session=Some(session);
        }
        if due {crate::fow_upscale::expand_native(source,DIM,&mut self.pixels,WIDTH)?;self.previous=now;self.uploads+=1;}
        Ok(reset || due)
    }
}
#[derive(Resource)]
pub struct VisibilityTexture {pub image:Handle<Image>,pub settings:crate::fow_settings::Settings,pub staging:Staging,last_error:Option<&'static str>,publication:MaskImageStatus}
/// A CPU Image publication only. No GPU preparation or draw readiness is implied.
#[derive(Clone,Debug)]
pub(crate) struct MaskImagePublication {
    pub source:crate::fow_champion_sources::MaskSourceStamp,
    pub revision:u64,
    pub image:AssetId<Image>,
}
/// Immutable transport Image; its ID is distinct from the stable CPU Image.
#[derive(Clone,Debug)]
pub(crate) struct TransportSnapshot {pub cpu:MaskImagePublication,pub image:Handle<Image>}
impl TransportSnapshot {
    pub(crate) fn same_publication(&self,other:&Self)->bool {
        self.cpu.revision==other.cpu.revision && self.cpu.image==other.cpu.image
            && self.cpu.source.same_episode(&other.cpu.source) && self.image.id()==other.image.id()
    }
}
#[derive(Default)]
struct MaskImageStatus {
    revision:u64,current:Option<MaskImagePublication>,
    // Keep cleanup identity even when no snapshot is admissible.
    transport_owner:Option<TransportSnapshot>,transport_eligible:bool,
}
impl MaskImageStatus {
    fn invalidate(&mut self) {self.current=None;self.transport_eligible=false;}
    fn reconcile(&mut self,source:&crate::fow_champion_sources::MaskSourceStamp,image:AssetId<Image>) {
        if !self.current.as_ref().is_some_and(|p|p.image==image && p.source.same_episode(source)) {self.invalidate();}
    }
    fn next_revision(&self)->Result<u64,&'static str> {
        self.revision.checked_add(1).ok_or("visibility Image publication revision exhausted")
    }
    fn commit(&mut self,source:crate::fow_champion_sources::MaskSourceStamp,image:AssetId<Image>,revision:u64) {
        self.revision=revision;self.current=Some(MaskImagePublication {source,image,revision});
    }
}
impl VisibilityTexture {
    pub(crate) fn publication_for(&self,sources:&crate::fow_champion_sources::Sources,map:&crate::map10_vision_view::Map10VisionView,session:u64,team:u8)->Option<MaskImagePublication> {
        let current=sources.mask_stamp(map,session,team)?;
        self.publication.current.as_ref().filter(|p|p.image==self.image.id() && p.source.same_episode(&current)).cloned()
    }
    pub(crate) fn transport_snapshot(&self,sources:&crate::fow_champion_sources::Sources,map:&crate::map10_vision_view::Map10VisionView)->Option<TransportSnapshot> {
        if !self.publication.transport_eligible {return None;}
        let owned=self.publication.transport_owner.as_ref()?;
        let cpu=self.publication_for(sources,map,owned.cpu.source.session,owned.cpu.source.team)?;
        let current=TransportSnapshot {cpu,image:owned.image.clone()};
        owned.same_publication(&current).then_some(current)
    }
    pub(crate) fn transport_owner_id(&self)->Option<AssetId<Image>> {
        self.publication.transport_owner.as_ref().map(|owned|owned.image.id())
    }
    /// Remove the Main value before losing the owner slot or its strong handle.
    /// Keep this owner for the plugin lifetime, or call this explicit teardown.
    pub(crate) fn retire_transport(&mut self,images:&mut Assets<Image>) {
        self.publication.invalidate();
        if let Some(id)=self.transport_owner_id() {drop(images.remove(id));}
        self.publication.transport_owner=None;
    }
    fn refresh(&mut self,snapshot:&openleague_core::Snapshot,viewer:u32,sources:&crate::fow_champion_sources::Sources,map:&crate::map10_vision_view::Map10VisionView,now:f32,images:&mut Assets<Image>)->Result<(),&'static str> {
        let result=(|| {
            let team=snapshot.roster.iter().find(|p|p.id==viewer).ok_or("missing texture viewer roster")?.team;
            if team>1 {return Err("unsupported texture viewer team");}
            let source=sources.mask_stamp(map,snapshot.session,team).ok_or("visibility CPU source cycle is not valid for this view and audience")?;
            if source.represented_tick!=snapshot.tick {return Err("visibility CPU source cycle does not represent this snapshot tick");}
            self.publication.reconcile(&source,self.image.id());
            let image=images.get(&self.image).ok_or("missing visibility Image asset")?;
            let size=image.texture_descriptor.size;
            if size.width!=WIDTH as u32 || size.height!=WIDTH as u32 || size.depth_or_array_layers!=1
                || image.texture_descriptor.dimension!=TextureDimension::D2 || image.texture_descriptor.format!=TextureFormat::R8Unorm {
                return Err("visibility Image descriptor must remain512x512x1 D2 R8Unorm");
            }
            // Preflight fallible counters before changing live native timestamps.
            let revision=self.publication.next_revision()?;
            let view=map.view.lock().map_err(|_|"poisoned visibility view")?;
            // Preserve Staging's input checks before the upload-counter preflight.
            if view.circle.layer.pixels.len()!=DIM*DIM {return Err("Map10 visibility source size mismatch");}
            if !now.is_finite() || now<0. {return Err("invalid visibility upload clock");}
            let audience=(snapshot.session,team);
            let prior=if self.staging.session!=Some(audience) {0.}else{self.staging.previous};
            let due=crate::fow_timing::upload_due(now,prior)?;
            let expected_upload=if due {Some(self.staging.uploads.checked_add(1).ok_or("visibility upload counter exhausted")?)}else{None};
            // Run Staging.prepare byte-for-byte unchanged on private candidate state.
            let mut staged=Staging {session:self.staging.session,previous:self.staging.previous,pixels:self.staging.pixels.clone(),uploads:self.staging.uploads};
            let changed=staged.prepare(audience,now,&view.circle.layer.pixels)?;
            drop(view);
            let expanded=expected_upload.is_some_and(|count|staged.uploads==count);
            if staged.uploads!=self.staging.uploads && !expanded {return Err("visibility upload count did not match this preparation");}
            if changed {
                // Reset alone cannot create a GPU source even when uploads was >0.
                let transport=if expanded {
                    let mut fresh=image.clone();fresh.data=Some(staged.pixels.clone());
                    fresh.asset_usage=RenderAssetUsages::MAIN_WORLD|RenderAssetUsages::RENDER_WORLD;
                    Some(fresh)
                }else{None};
                let cpu_data=staged.pixels.clone();
                // Assets::add has no recoverable Result in this API. Never certify
                // an ID before add returns; allocation/panic is not success evidence.
                let next=transport.map(|fresh|images.add(fresh));
                images.get_mut(&self.image).expect("validated stable CPU Image remains present under exclusive Assets access").data=Some(cpu_data);
                self.staging=staged;
                self.publication.commit(source,self.image.id(),revision);
                if let Some(image)=next {
                    // C exists first; remove Main B before losing its cleanup slot.
                    // Render has a separate last-ID owner, including queued assets.
                    if let Some(old)=self.transport_owner_id() {drop(images.remove(old));}
                    self.publication.transport_owner=Some(TransportSnapshot {cpu:self.publication.current.as_ref().unwrap().clone(),image});
                    self.publication.transport_eligible=true;
                }else {self.publication.transport_eligible=false;}
            }
            Ok(())
        })();
        if result.is_err() {self.publication.invalidate();}
        result
    }
}

pub fn setup(mut commands:Commands,mut images:ResMut<Assets<Image>>) {
    let settings=crate::fow_settings::Settings::map10();
    // This qualified Map10 pipeline requires the native default upscale choice.
    // A different map/configuration must construct its own texture dimensions.
    assert!(settings.upscale,"Map10 recovered configuration requires native upscale");
    let mut image=Image::new(Extent3d {width:WIDTH as u32,height:WIDTH as u32,depth_or_array_layers:1},TextureDimension::D2,vec![0;WIDTH*WIDTH],TextureFormat::R8Unorm,RenderAssetUsages::MAIN_WORLD|RenderAssetUsages::RENDER_WORLD);
    // Bevy transport sampler; native device/sampler producer qualification remains pending.
    image.sampler=ImageSampler::Descriptor(ImageSamplerDescriptor {address_mode_u:ImageAddressMode::ClampToEdge,address_mode_v:ImageAddressMode::ClampToEdge,mag_filter:ImageFilterMode::Linear,min_filter:ImageFilterMode::Linear,lod_min_clamp:0.,lod_max_clamp:0.,..default()});
    let image=images.add(image);
    let gpu=crate::fow_gpu::Images::new(image.clone(),&mut images,settings.blur_kernel_sigma);
    crate::fow_gpu::observe_readback(&mut commands,&gpu);commands.insert_resource(gpu);
    commands.insert_resource(VisibilityTexture {image,settings,staging:Staging::default(),last_error:None,publication:MaskImageStatus::default()});
}
pub fn update(state:Res<crate::Match>,connection:Res<crate::Connection>,sources:Res<crate::fow_champion_sources::Sources>,map:Res<crate::map10_vision_view::Map10VisionView>,time:Res<Time>,mut texture:ResMut<VisibilityTexture>,mut images:ResMut<Assets<Image>>) {
    let (Some(snapshot),Some(viewer))=(&state.snapshot,connection.id) else {texture.publication.invalidate();return;};
    let result=texture.refresh(snapshot,viewer,&sources,&map,time.elapsed_secs(),&mut images);
    let error=result.err();if error!=texture.last_error {if let Some(e)=error {eprintln!("OpenLeague visibility texture: {e}");}texture.last_error=error;}
    if let Ok(path)=std::env::var("OPENLEAGUE_VISIBILITY_TEXTURE_PROBE") {
        let report=serde_json::json!({"complete":false,"width":WIDTH,"height":WIDTH,"format":"R8Unorm","native_upscale":texture.settings.upscale,"native_blur_sigma":texture.settings.blur_kernel_sigma,"configuration_profile":"native_map10_inibin_no_launch_override","logical_configuration":crate::map10_native_config::LOGICAL_PATH,"binary_configuration":crate::map10_native_config::PHYSICAL_PATH,"uploads":texture.staging.uploads,"nonzero_texels":texture.staging.pixels.iter().filter(|v|**v!=0).count(),"error":texture.last_error,"render_asset_registered":images.get(&texture.image).is_some(),"gpu_readback_verified":false,"material_bound":false,"limits":["Raw visibility only; native fade/blur and material binding pending.","Corner allocation and sampler are explicit Bevy adapters; original initialization/device producers remain open."]});let _=std::fs::write(path,serde_json::to_vec_pretty(&report).unwrap());
    }
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn transport_keeps_native_cadence_flip_boundary_and_session_isolation() {
        let mut staging=Staging::default();let mut source=vec![0;DIM*DIM];source[3*DIM+8]=255;
        assert!(staging.prepare((1,0),0.,&source).unwrap());assert_eq!(staging.uploads,0);
        assert!(!staging.prepare((1,0),0.2,&source).unwrap());
        assert!(staging.prepare((1,0),f32::from_bits(0.2f32.to_bits()+1),&source).unwrap());
        let mut expected=vec![0;WIDTH*WIDTH];crate::fow_upscale::expand_native(&source,DIM,&mut expected,WIDTH).unwrap();assert_eq!(staging.pixels,expected);
        assert!(staging.pixels[10*WIDTH..20*WIDTH].iter().any(|v|*v!=0));assert!(staging.pixels[WIDTH*400..].iter().all(|v|*v==0));
        // Team change before the next upload never leaks the previous team's texture.
        assert!(staging.prepare((1,1),0.1,&source).unwrap());assert!(staging.pixels.iter().all(|v|*v==0));
        assert!(staging.prepare((2,1),0.3,&vec![0;DIM*DIM]).unwrap());assert!(staging.pixels.iter().all(|v|*v==0));
        let before=staging.pixels.clone();let previous=staging.previous;assert!(staging.prepare((2,1),0.4,&[]).is_err());assert!(staging.prepare((2,1),0.2,&source).is_err());assert_eq!(staging.previous,previous);assert_eq!(staging.pixels,before);
    }
}

/// Explicit screenshot diagnostic; normal material color is unchanged until full factors qualify.
pub fn diagnostic_enabled()->bool {std::env::var_os("OPENLEAGUE_SCREENSHOT").is_some() && std::env::var("OPENLEAGUE_FOW_MASK_PROBE").as_deref()==Ok("1")}
pub fn bind_materials(gpu:Res<crate::fow_gpu::Images>,texture:Res<VisibilityTexture>,map:Res<crate::map10_vision_view::Map10VisionView>,mut terrain:ResMut<Assets<crate::terrain_material::TerrainMaterial>>,mut environment:ResMut<Assets<crate::map_fog::FogMaterial>>,assets:Res<AssetServer>,mut projected:ResMut<Assets<crate::projected_render::ProjectedMaterial>>) {
    let uniforms=texture.settings.shader_parameters(map.geometry.extent).expect("qualified native Map10 FoW uniforms");
    let native=Vec4::from_array(uniforms.coordinates);
    let below=crate::native_fow::always_below_params();let height=Vec4::from_array(uniforms.height);let edge=Vec4::from_array(uniforms.edge);
    let params=Vec4::new(native.x*20.,native.y*20.,native.z,native.w);
    // Native catalog-qualified fallback overlay; original DDS conversion is pixel-equal.
    let overlay:Handle<Image>=assets.load("maps/terrain_native/DefaultFogOfWarOverlay.png");
    let ids:Vec<_>=projected.iter().filter(|(_,m)|m.visibility_map!=gpu.output || m.visibility_params!=params || m.visibility_edge!=edge || m.visibility_overlay!=overlay || m.visibility_ready!=1).map(|(id,_)|id).collect();
    for id in ids {let mut m=projected.get_mut(id).expect("existing projected material");m.visibility_map=gpu.output.clone();m.visibility_overlay=overlay.clone();m.visibility_params=params;m.visibility_edge=edge;m.visibility_ready=1;}

    // Assets::iter_mut marks every visited asset modified. Inspect immutably first,
    // then mutate only missing bindings, including new assets added after startup.
    let terrain_ids:Vec<_>=terrain.iter().filter(|(_,m)|m.visibility_map!=gpu.output || m.visibility_params!=params || m.visibility_height!=height || m.visibility_edge!=edge || m.visibility_overlay!=overlay || m.visibility_below!=below || m.visibility_ready!=1).map(|(id,_)|id).collect();
    for id in terrain_ids {let mut m=terrain.get_mut(id).expect("existing terrain material");m.visibility_map=gpu.output.clone();m.visibility_params=params;m.visibility_height=height;m.visibility_edge=edge;m.visibility_overlay=overlay.clone();m.visibility_below=below;m.visibility_ready=1;m.visibility_diagnostic=if parameter_diagnostic_enabled() {2} else {u32::from(diagnostic_enabled())};}
    let environment_ids:Vec<_>=environment.iter().filter(|(_,m)|m.extension.visibility_map!=gpu.output || m.extension.visibility_params!=params || m.extension.visibility_height!=height || m.extension.visibility_edge!=edge || m.extension.visibility_overlay!=overlay || m.extension.visibility_below!=below || m.extension.visibility_ready!=1).map(|(id,_)|id).collect();
    for id in environment_ids {let mut m=environment.get_mut(id).expect("existing environment material");m.extension.visibility_map=gpu.output.clone();m.extension.visibility_params=params;m.extension.visibility_height=height;m.extension.visibility_edge=edge;m.extension.visibility_overlay=overlay.clone();m.extension.visibility_below=below;m.extension.visibility_ready=1;}
}

pub fn parameter_diagnostic_enabled()->bool {std::env::var_os("OPENLEAGUE_SCREENSHOT").is_some() && std::env::var("OPENLEAGUE_FOW_PARAMETER_PROBE").as_deref()==Ok("1")}
#[cfg(test)]
mod mask_publication_tests {
    use super::*;
    use crate::fow_champion_sources::mask_provenance_tests::{native_fixture,cycle};
    fn texture(images:&mut Assets<Image>)->VisibilityTexture {
        let image=Image::new(Extent3d {width:WIDTH as u32,height:WIDTH as u32,depth_or_array_layers:1},TextureDimension::D2,vec![0;WIDTH*WIDTH],TextureFormat::R8Unorm,RenderAssetUsages::MAIN_WORLD|RenderAssetUsages::RENDER_WORLD);
        VisibilityTexture {image:images.add(image),settings:crate::fow_settings::Settings::map10(),staging:Staging::default(),last_error:None,publication:MaskImageStatus::default()}
    }
    #[test]
    fn actual_native_sources_publish_image_only_on_legal_cadence_and_post_error_recovery() {
        let (snapshot,viewer,mut map,mut sources)=native_fixture();let mut images=Assets::<Image>::default();let mut texture=texture(&mut images);
        cycle(&mut sources,&snapshot,viewer,&mut map).unwrap();
        let team=snapshot.roster.iter().find(|p|p.id==viewer).unwrap().team;
        texture.refresh(&snapshot,viewer,&sources,&map,0.,&mut images).unwrap();
        assert_eq!(texture.publication_for(&sources,&map,snapshot.session,team).unwrap().revision,1);
        assert!(images.get(&texture.image).unwrap().data.as_ref().unwrap().iter().all(|p|*p==0),"first allocation reset is conservative before the native upload interval");
        texture.refresh(&snapshot,viewer,&sources,&map,0.25,&mut images).unwrap();
        let first=texture.publication_for(&sources,&map,snapshot.session,team).unwrap();
        let pixels=images.get(&texture.image).unwrap().data.as_ref().unwrap().clone();assert!(pixels.iter().any(|p|*p!=0));
        assert_eq!(first.revision,2);assert_eq!(first.image,texture.image.id());
        sources.invalidate_mask();assert!(texture.publication_for(&sources,&map,snapshot.session,team).is_none());
        assert!(texture.refresh(&snapshot,viewer,&sources,&map,0.26,&mut images).is_err());
        assert_eq!(images.get(&texture.image).unwrap().data.as_ref().unwrap(),&pixels);
        cycle(&mut sources,&snapshot,viewer,&mut map).unwrap();
        texture.refresh(&snapshot,viewer,&sources,&map,0.3,&mut images).unwrap();
        assert!(texture.publication_for(&sources,&map,snapshot.session,team).is_none());
        assert_eq!(texture.staging.previous,0.25,"recovery does not reset native upload time");
        let boundary=0.25f32+0.2;
        assert!(!crate::fow_timing::upload_due(boundary,0.25).unwrap());
        texture.refresh(&snapshot,viewer,&sources,&map,boundary,&mut images).unwrap();
        assert!(texture.publication_for(&sources,&map,snapshot.session,team).is_none());
        let due=f32::from_bits(boundary.to_bits()+1);assert!(crate::fow_timing::upload_due(due,0.25).unwrap());
        texture.refresh(&snapshot,viewer,&sources,&map,due,&mut images).unwrap();
        let recovered=texture.publication_for(&sources,&map,snapshot.session,team).unwrap();
        assert_eq!(recovered.revision,first.revision+1);assert!(!first.source.same_episode(&recovered.source));
        for _ in 0..3 {cycle(&mut sources,&snapshot,viewer,&mut map).unwrap();texture.refresh(&snapshot,viewer,&sources,&map,due,&mut images).unwrap();}
        assert_eq!(texture.publication_for(&sources,&map,snapshot.session,team).unwrap().revision,recovered.revision);
        assert_eq!(texture.staging.previous,due);
    }
    #[test]
    fn missing_image_and_wrong_audience_revoke_without_relabelling_retained_pixels() {
        let (mut snapshot,viewer,mut map,mut sources)=native_fixture();let mut images=Assets::<Image>::default();let mut texture=texture(&mut images);
        cycle(&mut sources,&snapshot,viewer,&mut map).unwrap();
        let team=snapshot.roster.iter().find(|p|p.id==viewer).unwrap().team;
        texture.refresh(&snapshot,viewer,&sources,&map,0.25,&mut images).unwrap();
        let old=images.get(&texture.image).unwrap().data.as_ref().unwrap().clone();
        assert!(old.iter().any(|p|*p!=0),"the adversarial case must retain a real nonzero A Image");
        snapshot.session+=1;
        let next_team=1-team;for p in &mut snapshot.players {p.team=next_team;p.position.x+=2000.;}for p in &mut snapshot.roster {p.team=next_team;}
        assert!(std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
            let _guard=map.view.lock().unwrap();panic!("intentional new-audience retirement failure in CPU fixture");
        })).is_err());
        assert_eq!(cycle(&mut sources,&snapshot,viewer,&mut map),Err("poisoned registered fog view"));
        assert!(texture.refresh(&snapshot,viewer,&sources,&map,0.5,&mut images).is_err());
        assert!(texture.publication_for(&sources,&map,snapshot.session,next_team).is_none());
        assert_eq!(images.get(&texture.image).unwrap().data.as_ref().unwrap(),&old);
        map.view.clear_poison();
        cycle(&mut sources,&snapshot,viewer,&mut map).unwrap();
        texture.refresh(&snapshot,viewer,&sources,&map,0.5,&mut images).unwrap();
        let current=texture.publication_for(&sources,&map,snapshot.session,next_team).unwrap();
        assert_eq!(current.source.session,snapshot.session);assert_eq!(current.source.team,next_team);
        let before_clock_error=images.get(&texture.image).unwrap().data.as_ref().unwrap().clone();
        assert!(before_clock_error.iter().any(|p|*p!=0));assert_ne!(before_clock_error,old,"B publishes real native Source pixels elsewhere, not just a new label on A");
        assert_eq!(texture.refresh(&snapshot,viewer,&sources,&map,f32::NAN,&mut images),Err("invalid visibility upload clock"));
        assert!(texture.publication_for(&sources,&map,snapshot.session,next_team).is_none());
        assert_eq!(images.get(&texture.image).unwrap().data.as_ref().unwrap(),&before_clock_error);
        texture.refresh(&snapshot,viewer,&sources,&map,0.75,&mut images).unwrap();
        assert!(texture.publication_for(&sources,&map,snapshot.session,next_team).is_some());
        images.get_mut(&texture.image).unwrap().texture_descriptor.size.width=1;
        assert_eq!(texture.refresh(&snapshot,viewer,&sources,&map,0.8,&mut images),Err("visibility Image descriptor must remain512x512x1 D2 R8Unorm"));
        assert!(texture.publication_for(&sources,&map,snapshot.session,next_team).is_none());
        assert_eq!(texture.staging.previous,0.75);assert_eq!(images.get(&texture.image).unwrap().data.as_ref().unwrap(),&before_clock_error);
        images.get_mut(&texture.image).unwrap().texture_descriptor.size.width=WIDTH as u32;
        images.remove(texture.image.id()).unwrap();
        assert_eq!(texture.refresh(&snapshot,viewer,&sources,&map,0.6,&mut images),Err("missing visibility Image asset"));
        assert!(texture.publication_for(&sources,&map,snapshot.session,next_team).is_none());
        assert!(texture.refresh(&snapshot,viewer,&sources,&map,f32::NAN,&mut images).is_err());
        assert_eq!(texture.staging.previous,0.75);
    }
    #[test]
    fn image_revision_exhaustion_does_not_advance_timestamp_or_assign_data() {
        let (snapshot,viewer,mut map,mut sources)=native_fixture();let mut images=Assets::<Image>::default();let mut texture=texture(&mut images);
        cycle(&mut sources,&snapshot,viewer,&mut map).unwrap();
        texture.refresh(&snapshot,viewer,&sources,&map,0.25,&mut images).unwrap();
        let old=images.get(&texture.image).unwrap().data.as_ref().unwrap().clone();
        texture.publication.revision=u64::MAX;
        assert_eq!(texture.refresh(&snapshot,viewer,&sources,&map,0.6,&mut images),Err("visibility Image publication revision exhausted"));
        assert_eq!(images.get(&texture.image).unwrap().data.as_ref().unwrap(),&old);
        assert_eq!(texture.staging.previous,0.25);assert_eq!(texture.publication.revision,u64::MAX);
        let team=snapshot.roster.iter().find(|p|p.id==viewer).unwrap().team;
        assert!(texture.publication_for(&sources,&map,snapshot.session,team).is_none());
    }
}


#[cfg(test)]
pub(crate) mod transport_snapshot_tests {
    use super::*;
    use crate::fow_champion_sources::mask_provenance_tests::{native_fixture,cycle};
    fn texture(images:&mut Assets<Image>)->VisibilityTexture {
        let image=Image::new(Extent3d {width:WIDTH as u32,height:WIDTH as u32,depth_or_array_layers:1},TextureDimension::D2,vec![0;WIDTH*WIDTH],TextureFormat::R8Unorm,RenderAssetUsages::MAIN_WORLD|RenderAssetUsages::RENDER_WORLD);
        VisibilityTexture {image:images.add(image),settings:crate::fow_settings::Settings::map10(),staging:Staging::default(),last_error:None,publication:MaskImageStatus::default()}
    }
    pub(crate) fn published_fixture()->(openleague_core::Snapshot,u32,crate::map10_vision_view::Map10VisionView,crate::fow_champion_sources::Sources,VisibilityTexture,Assets<Image>) {
        let (snapshot,viewer,mut map,mut sources)=native_fixture();let mut images=Assets::<Image>::default();let mut texture=texture(&mut images);
        cycle(&mut sources,&snapshot,viewer,&mut map).unwrap();texture.refresh(&snapshot,viewer,&sources,&map,0.25,&mut images).unwrap();
        assert!(texture.transport_snapshot(&sources,&map).is_some());
        (snapshot,viewer,map,sources,texture,images)
    }
    pub(crate) fn refresh_fixture(texture:&mut VisibilityTexture,snapshot:&openleague_core::Snapshot,viewer:u32,sources:&crate::fow_champion_sources::Sources,map:&crate::map10_vision_view::Map10VisionView,now:f32,images:&mut Assets<Image>)->Result<(),&'static str> {
        texture.refresh(snapshot,viewer,sources,map,now,images)
    }
    #[test]
    fn real_native_publications_create_distinct_immutable_assets_and_remove_old_main_value() {
        let (mut snapshot,viewer,mut map,mut sources,mut texture,mut images)=published_fixture();
        let a=texture.transport_snapshot(&sources,&map).unwrap();
        assert_eq!(a.cpu.image,texture.image.id());assert_ne!(a.image.id(),texture.image.id());
        let a_image=images.get(&a.image).unwrap().clone();let a_data=a_image.data.as_ref().unwrap().clone();
        assert!(a_data.iter().any(|v|*v!=0));assert_eq!(a_data,*images.get(&texture.image).unwrap().data.as_ref().unwrap());
        assert_eq!(a_image.asset_usage,RenderAssetUsages::MAIN_WORLD|RenderAssetUsages::RENDER_WORLD);
        assert_eq!(a_image.sampler,images.get(&texture.image).unwrap().sampler);
        texture.refresh(&snapshot,viewer,&sources,&map,0.3,&mut images).unwrap();
        assert!(a.same_publication(&texture.transport_snapshot(&sources,&map).unwrap()));
        assert_eq!(images.get(&a.image).unwrap(),&a_image,"retained transport asset is immutable between legal uploads");
        snapshot.tick+=1;for p in &mut snapshot.players {p.position.x+=2000.;}
        cycle(&mut sources,&snapshot,viewer,&mut map).unwrap();texture.refresh(&snapshot,viewer,&sources,&map,0.5,&mut images).unwrap();
        let b=texture.transport_snapshot(&sources,&map).unwrap();assert!(!a.same_publication(&b));assert_ne!(a.image.id(),b.image.id());
        assert_eq!(b.cpu.revision,a.cpu.revision+1);assert_eq!(b.cpu.image,a.cpu.image);
        assert!(images.get(&a.image).is_none(),"retained strong handle does not retain the retired Main value");
        let b_data=images.get(&b.image).unwrap().data.as_ref().unwrap();assert!(b_data.iter().any(|v|*v!=0));assert_ne!(b_data,&a_data);
        assert_eq!(a_image.data.as_ref().unwrap(),&a_data);assert_eq!(images.iter().count(),2);
    }
    #[test]
    fn reset_with_prior_upload_count_revokes_transport_without_making_zero_source() {
        let (mut snapshot,viewer,mut map,mut sources,mut texture,mut images)=published_fixture();
        let a=texture.transport_snapshot(&sources,&map).unwrap();let saved=images.get(&a.image).unwrap().clone();assert_eq!(texture.staging.uploads,1);
        snapshot.session+=1;for p in &mut snapshot.players {p.team=1-p.team;}for p in &mut snapshot.roster {p.team=1-p.team;}
        cycle(&mut sources,&snapshot,viewer,&mut map).unwrap();assert!(texture.transport_snapshot(&sources,&map).is_none());
        texture.refresh(&snapshot,viewer,&sources,&map,0.1,&mut images).unwrap();
        let team=snapshot.roster.iter().find(|p|p.id==viewer).unwrap().team;
        assert!(texture.publication_for(&sources,&map,snapshot.session,team).is_some(),"CPU zero publication contract remains intact");
        assert_eq!(texture.staging.uploads,1);assert_eq!(texture.staging.previous,0.);
        assert!(images.get(&texture.image).unwrap().data.as_ref().unwrap().iter().all(|v|*v==0));
        assert!(texture.transport_snapshot(&sources,&map).is_none());assert_eq!(texture.transport_owner_id(),Some(a.image.id()));
        assert_eq!(images.get(&a.image).unwrap(),&saved);assert_eq!(images.iter().count(),2);
    }
    #[test]
    fn actual_source_error_keeps_cleanup_owner_and_recovery_waits_for_legal_expansion() {
        let (snapshot,viewer,mut map,mut sources,mut texture,mut images)=published_fixture();
        let a=texture.transport_snapshot(&sources,&map).unwrap();let saved=images.get(&a.image).unwrap().clone();
        sources.invalidate_mask();assert!(texture.refresh(&snapshot,viewer,&sources,&map,0.3,&mut images).is_err());
        assert!(texture.transport_snapshot(&sources,&map).is_none());assert_eq!(texture.transport_owner_id(),Some(a.image.id()));assert_eq!(images.get(&a.image).unwrap(),&saved);
        cycle(&mut sources,&snapshot,viewer,&mut map).unwrap();texture.refresh(&snapshot,viewer,&sources,&map,0.3,&mut images).unwrap();
        assert!(texture.transport_snapshot(&sources,&map).is_none());assert_eq!(texture.staging.previous,0.25);assert_eq!(texture.transport_owner_id(),Some(a.image.id()));
        texture.refresh(&snapshot,viewer,&sources,&map,0.5,&mut images).unwrap();
        let recovered=texture.transport_snapshot(&sources,&map).unwrap();assert_ne!(recovered.image.id(),a.image.id());
        assert!(!a.cpu.source.same_episode(&recovered.cpu.source));assert_eq!(texture.staging.previous,0.5);assert!(images.get(&a.image).is_none());
    }
    #[test]
    fn repeated_publications_and_explicit_teardown_bound_owned_main_assets_and_preserve_foreign() {
        let (snapshot,viewer,map,sources,mut texture,mut images)=published_fixture();
        let foreign_image=images.get(&texture.image).unwrap().clone();let foreign=images.add(foreign_image.clone());
        let mut retained:Vec<Handle<Image>>=Vec::new();
        for i in 2..=24 {
            texture.refresh(&snapshot,viewer,&sources,&map,i as f32*0.25,&mut images).unwrap();
            let current=texture.transport_snapshot(&sources,&map).unwrap();
            assert_eq!(images.iter().count(),3,"only S/current/foreign remain even when old handles are retained");
            for old in &retained {assert!(images.get(old).is_none());}
            assert_eq!(texture.transport_owner_id(),Some(current.image.id()));retained.push(current.image);
        }
        texture.retire_transport(&mut images);assert!(texture.transport_owner_id().is_none());assert!(texture.transport_snapshot(&sources,&map).is_none());
        assert_eq!(images.iter().count(),2);assert!(images.get(&texture.image).is_some());assert_eq!(images.get(&foreign).unwrap(),&foreign_image);
        texture.retire_transport(&mut images);assert_eq!(images.iter().count(),2,"teardown is idempotent");
    }
    #[test]
    fn upload_counter_exhaustion_rejects_before_live_timestamp_or_pixels_change() {
        let (snapshot,viewer,map,sources,mut texture,mut images)=published_fixture();
        let a=texture.transport_snapshot(&sources,&map).unwrap();let cpu=images.get(&texture.image).unwrap().clone();let pixels=texture.staging.pixels.clone();
        texture.staging.uploads=u64::MAX;
        assert_eq!(texture.refresh(&snapshot,viewer,&sources,&map,0.5,&mut images),Err("visibility upload counter exhausted"));
        assert_eq!(texture.staging.previous,0.25);assert_eq!(texture.staging.uploads,u64::MAX);assert_eq!(texture.staging.pixels,pixels);
        assert_eq!(images.get(&texture.image).unwrap(),&cpu);assert_eq!(texture.transport_owner_id(),Some(a.image.id()));assert!(texture.transport_snapshot(&sources,&map).is_none());assert_eq!(images.iter().count(),2);
    }
}
