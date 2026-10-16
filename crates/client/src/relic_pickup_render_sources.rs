//! Concrete selected local pickup render source. The isolated recovered DDS
//! provider and default QUAD pass are explicit choices, not historical trigger
//! or global namespace parity. Native creation modulation is kept separate
//! from the animated particle RGBA already present in each Complex Record.
use std::{ffi::CString,sync::Arc};
use bevy::image::{ImageSampler,ImageSamplerDescriptor,ImageAddressMode,ImageFilterMode};
use serde_json::Value;
use crate::{relic_pickup_seven_identity::{Group,GROUPS,Class},relic_pickup_seven_render::{self as render,RenderSources},
    relic_pickup_events as events,relic_pickup_complex_sources::Context,
    relic_pickup_simple_draw as simple,relic_recovered_catalog::Catalog,
    relic_namespace::{Namespace,Origin},nexus_glow_material::Inputs,nexus_complex_material::{Cull,OutputEncoding}};

pub const SCOPE:&str="selected local fresh actor, isolated recovered DDS provider, immutable native primary configuration, mode0 default QUAD pass0 and reflected camera; original trigger/global namespace/whole GPU pixel parity false";
#[derive(Clone)]
struct TextureSource {requested:CString,canonical:CString,bytes:Arc<[u8]>,sampler:ImageSampler}
impl TextureSource {fn texture(&self)->render::Texture {render::Texture {requested:self.requested.clone(),canonical:self.canonical.clone(),bytes:self.bytes.clone(),sampler:self.sampler.clone(),is_srgb:false}}}
#[derive(Clone,Copy)]
struct SimpleSource {e0:f32,rgba:[f32;4],scroll:[f32;2]}
#[derive(Clone)]
struct Profile {textures:[TextureSource;2],simple:Option<SimpleSource>,render_mode:u32,render_flags:u8}
#[derive(Clone)]
pub struct RecoveredLocal {profiles:[Profile;7]}
fn word(v:&Value)->Result<u32,String>{v.as_u64().filter(|v|*v<=u32::MAX as u64).map(|v|v as u32).ok_or("invalid native render source word".into())}
fn floats<const N:usize>(v:&Value)->Result<[f32;N],String>{
 let a=v.as_array().ok_or("native render source array absent")?;
 if a.len()!=N{return Err("native render source array width".into());}
 let a=a.iter().map(|v|word(v).map(f32::from_bits)).collect::<Result<Vec<_>,_>>()?;
 if a.iter().any(|v|!v.is_finite()){return Err("native render source nonfinite".into());}
 a.try_into().map_err(|_|"native render source array width".into())
}
fn text(v:&Value)->Result<CString,String>{CString::new(v.as_str().ok_or("native texture request absent")?).map_err(|_|"native texture request NUL".into())}
fn integer(v:&Value,key:&str)->Result<u32,String>{
 word(&v["integers"].as_array().ok_or("native integer getters absent")?.iter().find(|x|x["key"]==key).ok_or("native integer getter absent")?["value"])
}
fn owner_check(owner:events::OwnerFrame,time:f32)->Result<(),String>{
 if !time.is_finite() || owner.native_position.iter().chain(&owner.native_matrix).any(|v|!f32::from_bits(*v).is_finite()) {return Err("pickup render source owner/time nonfinite".into());}Ok(())
}
impl RecoveredLocal {
 /// Constructs the exact selected recovered resource subset. A historical actor
 /// provider cannot be silently substituted: it requires a different adapter.
 pub fn recovered_local()->Result<Self,String>{
  let data:Value=serde_json::from_str(include_str!("../../../data/4.20/relic_pickup/complex_render_source_parameters.json")).map_err(|e|e.to_string())?;
  if data["schema"]!=1 || data["original_trigger_parity"]!=false || data["actual_global_mount_table_recovered"]!=false {
   return Err("pickup recovered source scope changed".into());
  }
  let catalog=Catalog::recovered_with_pickup()?;let mut namespace=Namespace::empty();
  for row in data["alias_entries"].as_array().ok_or("pickup source aliases absent")? {
   let requested=text(&row[0])?;let canonical=text(&row[1])?;
   if !namespace.register_if_absent(&requested,&canonical){return Err("pickup source alias duplicated".into());}
  }
  let repeat=ImageSamplerDescriptor {address_mode_u:ImageAddressMode::Repeat,address_mode_v:ImageAddressMode::Repeat,
   mag_filter:ImageFilterMode::Linear,min_filter:ImageFilterMode::Linear,mipmap_filter:ImageFilterMode::Linear,..Default::default()};
  let clamp=ImageSamplerDescriptor {address_mode_u:ImageAddressMode::ClampToEdge,address_mode_v:ImageAddressMode::ClampToEdge,..repeat.clone()};
  let rows=data["groups"].as_array().ok_or("pickup source groups absent")?;
  if rows.len()!=GROUPS.len(){return Err("pickup source group count".into());}
  let mut profiles=Vec::new();
  for (group,row) in GROUPS.into_iter().zip(rows) {
   if row["name"]!=group.name() || row["class_name"]!=if group.class()==Class::Complex {"Complex"}else{"Simple"} {
    return Err("pickup source order/class differs".into());
   }
   let material=&row["material"];let mode=integer(material,"rendermode")?;
   if mode!=0 || integer(material,"p-backfaceon")?!=0 || integer(material,"e-alpharef")?!=0 || integer(material,"p-uvmode")?!=0 {
    return Err("pickup source outside selected default QUAD pass".into());
   }
   let mut flags=0u8;
   for field in material["flags"].as_array().ok_or("native flag getters absent")? {
    let value=word(&field["value"])?;
    if value!=0{return Err("pickup source nondefault shader/texture flag".into());}
    flags|=(value as u8)*word(&field["bit"])? as u8;
   }
   if flags!=0 || word(&material["diffuse_address_mode"])?!=0 || material["texture_mode"]!="wrap" {
    return Err("pickup source nondefault flags/address policy".into());
   }
   for scalar in material["scalars"].as_array().ok_or("native scalar getters absent")? {
    if word(&scalar["word"])?!=0{return Err("pickup source nondefault distortion/alpha slice".into());}
   }
   let requests=row["requested"].as_array().ok_or("pickup texture requests absent")?;
   if requests.len()!=2{return Err("pickup texture request pair width".into());}
   let mut textures=Vec::new();
   for (index,request) in requests.iter().enumerate() {
    let requested=text(request)?;let selected=namespace.lookup(&requested,None);
    if selected.origin!=Origin::Table || selected.value.to_bytes().is_empty(){return Err("pickup selected alias absent".into());}
    let canonical=selected.value.to_owned();let sampler=ImageSampler::Descriptor(if index==0 {repeat.clone()}else{clamp.clone()});
    let source=catalog.source(&requested,sampler.clone(),false)?;
    if source.key()!=crate::relic_texture_name::cache_key(&requested,&canonical){return Err("pickup catalog/provider identity differs".into());}
    textures.push(TextureSource {requested,canonical,bytes:Arc::from(source.bytes),sampler});
   }
   let selected=&row["selected"];
   let simple=if group.class()==Class::Simple {
    let e0=f32::from_bits(word(&selected["instance_e0_word"])?);
    let rgba=floats(&selected["modulation_words"])?;let scroll=floats(&selected["scroll_words"])?;
    if !e0.is_finite() || rgba!=[1.;4] || scroll!=[0.;2] {return Err("pickup Simple frame outside qualified constant source scope".into());}
    Some(SimpleSource {e0,rgba,scroll})
   }else{None};
   profiles.push(Profile {textures:textures.try_into().map_err(|_|"pickup texture pair")?,simple,render_mode:mode,render_flags:flags});
  }
  Ok(Self {profiles:profiles.try_into().map_err(|_|"pickup profile count")?})
 }
}
impl RenderSources<Context> for RecoveredLocal {
 fn textures(&self,group:Group)->Result<[render::Texture;2],String>{Ok(self.profiles[group.index()].textures.each_ref().map(TextureSource::texture))}
 fn material(&self,group:Group,native_extent:f32)->Result<Inputs,String>{
  if !native_extent.is_finite() || native_extent<=0. {return Err("pickup native fog extent invalid".into());}
  let p=&self.profiles[group.index()];
  // Native D3DCULL_CCW=3, actual retained native winding, and current reflected
  // Bevy camera are qualified together. Readiness rejects an unreflected view.
  Ok(Inputs {native_fog_extent:native_extent,encoding:OutputEncoding::DisplayToLinear,cull:Cull::Back,
   render_mode:p.render_mode,render_flags:p.render_flags,shader_features:0})
 }
 fn simple_frame(&self,_:events::Key,owner:events::OwnerFrame,group:Group,host:&crate::relic_pickup_simulation::Host,time:f32)->Result<simple::Frame,String>{
  owner_check(owner,time)?;
  let source=self.profiles[group.index()].simple.ok_or("Complex group requested Simple frame source")?;
  if time<host.time{return Err("pickup Simple draw predates owned host".into());}
  let system=openleague_core::native_troy_resource_initial::empty_instance(0,[0;3],0.).map_err(str::to_owned)?;
  Ok(simple::Frame {instance_e0:source.e0,system_bc:f32::from_bits(system.scales[0]),system_c0:f32::from_bits(system.scales[1]),rgba:source.rgba,scroll:source.scroll})
 }
 fn complex_frame(&self,_:events::Key,owner:events::OwnerFrame,group:Group,context:&Context,_:&openleague_core::native_complex_particle_storage::Record,time:f32)->Result<render::ComplexFrame,String>{
  owner_check(owner,time)?;
  if group.complex_index()!=Some(context.definition.index) || context.binding[0]!=owner.binding.root.to_bits() || time<context.start {
   return Err("pickup Complex render context owner/group/time changed".into());
  }
  // A4 comes from whole910EB0 creation, including capability-gated censor color.
  // Do not re-read e-rgba or replace the record's p-xrgba lifetime result here.
  let native_modulation=context.definition.modulation;
  let system_bc=f32::from_bits(context.system_scales[0]);let system_c0=f32::from_bits(context.system_scales[1]);
  if native_modulation.iter().chain([system_bc,system_c0].iter()).any(|v|!v.is_finite()){return Err("pickup native draw source nonfinite".into());}
  if context.definition.primary_mult_texture_pointer!=0 {return Err("pickup auxiliary diffuse shader branch unqualified".into());}
  Ok(render::ComplexFrame {native_modulation,system_bc,system_c0,primary_mult_texture_pointer:context.definition.primary_mult_texture_pointer})
 }
}
