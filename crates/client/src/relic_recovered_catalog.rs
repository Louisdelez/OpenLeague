//! Recovered nine-DDS namespace subset. Original global mounts, namespace
//! precedence and particle-owner provider binding are not established here.
use std::ffi::{CStr,CString};
use bevy::image::ImageSampler;
use crate::{relic_namespace::{Namespace,Origin},relic_rune_image_bindings::Source};
struct Resource {canonical:CString,bytes:&'static [u8]}
pub struct Catalog {namespace:Namespace,resources:Vec<Resource>}
impl Catalog {
 pub fn recovered_subset()->Result<Self,String>{
  let doc:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/relic_runes/recovered_dds_alias_catalog.json")).map_err(|e|e.to_string())?;
  if doc["actual_global_mount_table_recovered"]!=false{return Err("recovered relic catalog scope changed".into());}
  let mut namespace=Namespace::empty();
  for entry in doc["entries"].as_array().ok_or("recovered alias entries missing")? {
   let key=CString::new(entry[0].as_str().ok_or("invalid alias key")?).map_err(|_|"alias key NUL")?;
   let value=CString::new(entry[1].as_str().ok_or("invalid alias value")?).map_err(|_|"alias value NUL")?;
   if !namespace.register_if_absent(&key,&value){return Err("duplicate recovered alias".into());}
  }
  let resources=vec![
Resource {canonical:CString::new("DATA/Particles/DefaultColorOverLifetime.dds").unwrap(),bytes:include_bytes!("../../../assets/particles/relic_runes/DefaultColorOverLifetime.dds")},
Resource {canonical:CString::new("DATA/Particles/DefaultFalloff.dds").unwrap(),bytes:include_bytes!("../../../assets/particles/relic_runes/DefaultFalloff.dds")},
Resource {canonical:CString::new("DATA/Shared/Particles/color-hold.DDS").unwrap(),bytes:include_bytes!("../../../assets/particles/relic_runes/color-hold.DDS")},
Resource {canonical:CString::new("DATA/Particles/Env_Ice_Sheen.dds").unwrap(),bytes:include_bytes!("../../../assets/particles/relic_runes/Env_Ice_Sheen.dds")},
Resource {canonical:CString::new("DATA/Particles/Env_TT_Heal_Proj.dds").unwrap(),bytes:include_bytes!("../../../assets/particles/relic_runes/Env_TT_Heal_Proj.dds")},
Resource {canonical:CString::new("DATA/Shared/Particles/light_rays_01.dds").unwrap(),bytes:include_bytes!("../../../assets/particles/relic_runes/light_rays_01.dds")},
Resource {canonical:CString::new("DATA/Shared/Particles/color-bellcurve.DDS").unwrap(),bytes:include_bytes!("../../../assets/particles/relic_runes/color-bellcurve.DDS")},
Resource {canonical:CString::new("DATA/Shared/Particles/Soraka_Heal_Sparkle_Green.dds").unwrap(),bytes:include_bytes!("../../../assets/particles/relic_runes/Soraka_Heal_Sparkle_Green.dds")},
Resource {canonical:CString::new("DATA/Particles/TT_Heal_Platform.dds").unwrap(),bytes:include_bytes!("../../../assets/particles/relic_runes/TT_Heal_Platform.dds")}];
  if namespace.len()!=18 || resources.len()!=9{return Err("recovered relic resource count changed".into());}
  Ok(Self {namespace,resources})
 }
 /// Combined recovered rune/pickup subset; actual actor provider remains external.
 pub fn recovered_with_pickup()->Result<Self,String> {
  let mut catalog=Self::recovered_subset()?;
  let doc:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/relic_pickup/pickup_dds_alias_catalog.json")).map_err(|e|e.to_string())?;
  if doc["actual_global_mount_table_recovered"]!=false {return Err("pickup catalog scope changed".into());}
  for row in doc["entries"].as_array().ok_or("pickup aliases missing")? {
   let key=CString::new(row[0].as_str().ok_or("pickup alias key invalid")?).map_err(|_|"pickup key NUL")?;
   let value=CString::new(row[1].as_str().ok_or("pickup alias value invalid")?).map_err(|_|"pickup value NUL")?;
   if !catalog.namespace.register_if_absent(&key,&value) {return Err("duplicate pickup alias".into());}
  }
  catalog.resources.extend(vec![Resource {canonical:CString::new("DATA/Shared/Particles/Purify01.DDS").unwrap(),bytes:include_bytes!("../../../assets/particles/relic_pickup/Purify01.DDS")},
Resource {canonical:CString::new("DATA/Shared/Particles/Wish_tar__starTrailSPI3__p-rgba.DDS").unwrap(),bytes:include_bytes!("../../../assets/particles/relic_pickup/Wish_tar__starTrailSPI3__p-rgba.DDS")},
Resource {canonical:CString::new("DATA/Shared/Particles/Wish_Cylinder.DDS").unwrap(),bytes:include_bytes!("../../../assets/particles/relic_pickup/Wish_Cylinder.DDS")},
Resource {canonical:CString::new("DATA/Shared/Particles/wish_tar__mesh__p-rgba.DDS").unwrap(),bytes:include_bytes!("../../../assets/particles/relic_pickup/wish_tar__mesh__p-rgba.DDS")},
Resource {canonical:CString::new("DATA/Shared/Particles/color-healbell.dds").unwrap(),bytes:include_bytes!("../../../assets/particles/relic_pickup/color-healbell.dds")},
Resource {canonical:CString::new("DATA/Shared/Particles/Wish_tar.DDS").unwrap(),bytes:include_bytes!("../../../assets/particles/relic_pickup/Wish_tar.DDS")},
Resource {canonical:CString::new("DATA/Shared/Particles/Wish_tar__starswirl__p-rgba.DDS").unwrap(),bytes:include_bytes!("../../../assets/particles/relic_pickup/Wish_tar__starswirl__p-rgba.DDS")},
Resource {canonical:CString::new("DATA/Shared/Particles/Wish_tar__shafts__p-rgba.DDS").unwrap(),bytes:include_bytes!("../../../assets/particles/relic_pickup/Wish_tar__shafts__p-rgba.DDS")}]);
  if catalog.namespace.len()!=34 || catalog.resources.len()!=17 {return Err("pickup catalog count changed".into());}
  Ok(catalog)
 }
 /// Use the caller's selected provider. Do not substitute the isolated alias
 /// subset if that provider selects a different canonical path or returns empty.
 /// Only the nine recovered DDS resources are available through this catalog.
 pub fn source_from_provider(&self,requested:&CStr,provider:&crate::map_resource_provider::Provider,
                             sampler:ImageSampler,is_srgb:bool)->Result<Source<'_>,String>{
  if requested.to_bytes().is_empty(){return Err("absent native texture request".into());}
  let requested_text=requested.to_str().map_err(|_|"native provider request encoding unqualified")?;
  let canonical=provider.resolve(requested_text).map_err(str::to_owned)?
   .filter(|value|!value.is_empty()).ok_or("native provider did not resolve recovered texture")?;
  let resource=self.resources.iter().find(|resource|resource.canonical.to_bytes().eq_ignore_ascii_case(canonical.as_bytes()))
   .ok_or("provider selected a texture outside the recovered DDS catalog")?;
  let canonical=CString::new(canonical).map_err(|_|"canonical texture name NUL")?;
  Source::request(requested,&canonical,resource.bytes,sampler,is_srgb).map_err(str::to_owned)
 }
 /// Caller supplies the selected package chain and active namespace order.
 /// A terminal global fallback is scoped; it never searches other namespaces.
 pub fn source_from_package(&self,requested:&CStr,provider:&mut crate::relic_package_provider::PackageProvider,
                            order:&[&CStr],sampler:ImageSampler,is_srgb:bool)->Result<Source<'_>,String>{
  if requested.to_bytes().is_empty(){return Err("absent native texture request".into());}
  let selected=provider.lookup(order,requested);
  if selected.value.to_bytes().is_empty(){return Err("native package did not resolve recovered texture".into());}
  let resource=self.resources.iter().find(|resource|resource.canonical.to_bytes().eq_ignore_ascii_case(selected.value.to_bytes()))
   .ok_or("package selected a texture outside the recovered DDS catalog")?;
  Source::request(requested,&selected.value,resource.bytes,sampler,is_srgb).map_err(str::to_owned)
 }
 pub fn source(&self,requested:&CStr,sampler:ImageSampler,is_srgb:bool)->Result<Source<'_>,String>{
  let selected=self.namespace.lookup(requested,None);
  if selected.origin!=Origin::Table || selected.value.to_bytes().is_empty(){return Err("resource outside recovered relic namespace".into());}
  let resource=self.resources.iter().find(|r|r.canonical.as_c_str()==selected.value).ok_or("recovered canonical resource missing")?;
  Source::request(requested,selected.value,resource.bytes,sampler,is_srgb).map_err(str::to_owned)
 }
}

#[cfg(test)]
#[path="relic_recovered_catalog_tests.rs"]
mod tests;
