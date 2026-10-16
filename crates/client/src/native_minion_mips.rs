//! SOURCE DRAFT: three native DDS mip chains only; no gamma/shader/UV changes.
//! Only base_color_texture changes on three exact StandardMaterial subassets.
//! CPU asset validation is not GPU preparation, rendered-pixel or native proof.
use bevy::{prelude::*, asset::{AssetId, LoadState, RenderAssetUsages},
    image::{CompressedImageFormatSupport, CompressedImageFormats, ImageAddressMode,
            ImageFormat, ImageFormatSetting, ImageLoaderSettings, ImageSampler, ImageSamplerDescriptor},
    render::render_resource::{TextureDimension, TextureFormat}};

const DRAFT: bool = false;
struct Input { material: &'static str, png: &'static str, dds: &'static str, native: &'static [u8] }
const INPUTS: [Input; 3] = [
    Input { material:"forms/blue_minion_basic.glb#Material0/std", png:"forms/blue_minion_basic.glb#Texture0",
        dds:"forms/native_minion_mips/Blue_Minion_Basic.dds",
        native:include_bytes!("../../../assets/forms/native_minion_mips/Blue_Minion_Basic.dds") },
    Input { material:"forms/blue_minion_wizard.glb#Material0/std", png:"forms/blue_minion_wizard.glb#Texture0",
        dds:"forms/native_minion_mips/Blue_Minion_Wizard.dds",
        native:include_bytes!("../../../assets/forms/native_minion_mips/Blue_Minion_Wizard.dds") },
    Input { material:"forms/red_minion_mechmelee.glb#Material0/std", png:"forms/red_minion_mechmelee.glb#Texture0",
        dds:"forms/native_minion_mips/Red_Minion_MechMelee.dds",
        native:include_bytes!("../../../assets/forms/native_minion_mips/Red_Minion_MechMelee.dds") },
];
#[derive(Default)]
struct Entry { target:Option<AssetId<StandardMaterial>>, png:Option<Handle<Image>>,
    dds:Option<Handle<Image>>, owned:Option<Handle<Image>>, foreign:bool }
/// Readonly status interface; restored_in_assets never means GPU-ready.
#[derive(Resource)]
pub struct State { entries:[Entry;3], pub status:[&'static str;3], pub restored_in_assets:[bool;3] }
impl Default for State { fn default()->Self {Self { entries:std::array::from_fn(|_|Entry::default()),
    status:["draft_blocked";3], restored_in_assets:[false;3] }} }
impl State {fn begin(&mut self,index:usize,target:AssetId<StandardMaterial>){
    // Every observation starts unqualified, including either PNG_pending return.
    self.restored_in_assets[index]=false;
    if self.entries[index].target!=Some(target){
        self.entries[index]=Entry{target:Some(target),..Default::default()};
    }
}}
fn sampler()->ImageSamplerDescriptor {let mut value=ImageSamplerDescriptor::linear();
    value.address_mode_u=ImageAddressMode::Repeat;value.address_mode_v=ImageAddressMode::Repeat;value}
fn shape(image:&Image,format:TextureFormat,mips:u32)->bool {let d=&image.texture_descriptor;
    d.size.width==512&&d.size.height==512&&d.size.depth_or_array_layers==1
    &&d.dimension==TextureDimension::D2&&d.format==format&&d.mip_level_count==mips
    &&d.sample_count==1&&image.texture_view_descriptor.is_none()
    &&image.sampler==ImageSampler::Descriptor(sampler())}
fn png(image:&Image)->bool {shape(image,TextureFormat::Rgba8UnormSrgb,1)
    &&image.data.as_ref().is_some_and(|value|value.len()==512*512*4)}
fn native(image:&Image,input:&Input)->bool {input.native.len()==174904&&&input.native[..4]==b"DDS "
    &&shape(image,TextureFormat::Bc1RgbaUnormSrgb,10)&&image.data.as_deref()==Some(&input.native[128..])}
fn known_texture(entry:&Entry,current:&Option<Handle<Image>>)->bool{
    current.as_ref().is_some_and(|handle|entry.png.as_ref()==Some(handle)||entry.owned.as_ref()==Some(handle))
}
fn fallback(entry:&mut Entry,base:&mut Assets<StandardMaterial>){
    if let (Some(target),Some(owned),Some(png))=(entry.target,&entry.owned,&entry.png){
        if base.get(target).is_some_and(|m|m.base_color_texture.as_ref()==Some(owned)){
            if let Some(mut material)=base.get_mut(target){material.base_color_texture=Some(png.clone());}
        }
    }
    entry.owned=None;
}
pub fn update(server:Res<AssetServer>,support:Option<Res<CompressedImageFormatSupport>>,
    images:Res<Assets<Image>>,mut base:ResMut<Assets<StandardMaterial>>,mut state:ResMut<State>){
    if DRAFT{return;}
    let bc=support.as_ref().is_some_and(|value|value.0.contains(CompressedImageFormats::BC));
    for (index,input) in INPUTS.iter().enumerate(){
        // get_handle does not start or reload the GLTF; only an already alive subasset is selected.
        let Some(target)=server.get_handle::<StandardMaterial>(input.material)else{
            state.entries[index]=Entry::default();state.status[index]="material_not_loaded";
            state.restored_in_assets[index]=false;continue;};
        state.begin(index,target.id());
        let entry=&mut state.entries[index];
        let Some(material)=base.get(&target)else{state.status[index]="material_pending";
            state.restored_in_assets[index]=false;continue;};
        if entry.png.is_none()&&!entry.foreign{
            let Some(original)=server.get_handle::<Image>(input.png)else{state.status[index]="PNG_pending";continue;};
            let Some(image)=images.get(&original)else{state.status[index]="PNG_pending";continue;};
            if material.base_color_texture.as_ref()==Some(&original)&&png(image){entry.png=Some(original);}
            else{entry.foreign=true;}
        }
        let known=known_texture(entry,&material.base_color_texture);
        if entry.foreign||!known{entry.foreign=true;entry.owned=None;
            state.status[index]="foreign_texture_preserved";state.restored_in_assets[index]=false;continue;}
        if !bc{fallback(entry,&mut base);entry.dds=None;state.status[index]="PNG_retained_BC_unavailable";
            state.restored_in_assets[index]=false;continue;}
        let dds=entry.dds.get_or_insert_with(||server.load_with_settings::<Image,ImageLoaderSettings>(input.dds,|s|{
            s.format=ImageFormatSetting::Format(ImageFormat::Dds);s.texture_format=None;s.array_layout=None;
            s.is_srgb=true;s.sampler=ImageSampler::Descriptor(sampler());
            s.asset_usage=RenderAssetUsages::MAIN_WORLD|RenderAssetUsages::RENDER_WORLD;
        })).clone();
        let loaded=server.is_loaded_with_dependencies(dds.id());
        if !loaded||!images.get(&dds).is_some_and(|image|native(image,input)){
            fallback(entry,&mut base);
            state.status[index]=if matches!(server.get_load_state(dds.id()),Some(LoadState::Failed(_))){
                "PNG_retained_DDS_load_failed"
            }else if loaded{"PNG_retained_DDS_validation_failed"}else{"PNG_retained_DDS_pending"};
            state.restored_in_assets[index]=false;continue;
        }
        if base.get(&target).is_some_and(|m|m.base_color_texture.as_ref()!=Some(&dds)){
            // The only product field assigned by this module; normal AssetEvent follows.
            if let Some(mut material)=base.get_mut(&target){material.base_color_texture=Some(dds.clone());}
        }
        entry.owned=Some(dds);state.status[index]="native_DDS10mips_in_Assets_not_GPU_proof";
        state.restored_in_assets[index]=true;
    }
}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {fn build(&self,app:&mut App){app.init_resource::<State>()
    .add_systems(Update,update.after(crate::animation::load_models).before(crate::actor_fow::bind));}}
#[cfg(test)]
#[path="native_minion_mips_tests.rs"]
mod tests;
