//! Effect-owned diffuse/lifetime-color leases. Resource names and native sampler
//! settings come from the caller. No missing diffuse is replaced with white.
use bevy::{prelude::*,image::{ImageSampler,CompressedImageFormats}};
use crate::relic_image_reference_store::{Store,Lease};
pub struct Source<'a> {key:u32,pub bytes:&'a [u8],pub sampler:ImageSampler,pub is_srgb:bool}
impl<'a> Source<'a> {
    /// Missing diffuse fields do not admit a texture load. Canonical-name lookup
    /// is supplied by the caller; empty provider output retains the requested key.
    /// The physical DDS filename never determines this key by itself.
    pub fn request(requested:&std::ffi::CStr,canonical:&std::ffi::CStr,bytes:&'a [u8],
                   sampler:ImageSampler,is_srgb:bool)->Result<Self,&'static str> {
        if requested.to_bytes().is_empty(){return Err("absent native texture request");}
        Ok(Self {key:crate::relic_texture_name::cache_key(requested,canonical),bytes,sampler,is_srgb})
    }
    pub fn key(&self)->u32 {self.key}
}

#[must_use="Release image leases after retiring the effect's draw/material use"]
#[derive(Debug)]
pub struct Bindings {diffuse:Lease,color:Lease}
#[derive(Debug)]
pub struct Failure {pub leases:Vec<Lease>,pub message:String}
impl Bindings {
    /// CPU image acquisition only. On partial failure the caller keeps every
    /// acquired lease; no forgotten reference or resident pin is created.
    pub fn acquire(store:&mut Store,assets:&mut Assets<Image>,compressed:CompressedImageFormats,
                   diffuse:Source<'_>,color:Source<'_>)->Result<Self,Failure> {
        let diffuse=store.acquire_dds(diffuse.key,diffuse.bytes,compressed,diffuse.is_srgb,diffuse.sampler,assets)
            .map_err(|message|Failure {leases:Vec::new(),message})?;
        let color=match store.acquire_dds(color.key,color.bytes,compressed,color.is_srgb,color.sampler,assets) {
            Ok(lease)=>lease,
            Err(message)=>return Err(Failure {leases:vec![diffuse],message}),
        };
        Ok(Self {diffuse,color})
    }
    /// Renderer registration is explicit and independent of GPU readiness.
    pub fn register(&self,store:&mut Store,assets:&Assets<Image>)->Result<(),String> {
        // Check both before mutation, rejecting foreign/retired leases early.
        store.image(&self.diffuse,assets)?;store.image(&self.color,assets)?;
        store.pin_for_renderer(&self.diffuse)?;store.pin_for_renderer(&self.color)?;Ok(())
    }
    /// Handles for the existing four-texture material packet. Fog ownership is
    /// external; these main-world checks do not substitute for render-world checks.
    pub fn images(&self,store:&Store,assets:&Assets<Image>,fog:[Handle<Image>;2])->Result<[Handle<Image>;4],String> {
        if fog.iter().any(|h|assets.get(h).is_none()) {return Err("native fog image is not CPU loaded".into());}
        Ok([store.image(&self.diffuse,assets)?,store.image(&self.color,assets)?,fog[0].clone(),fog[1].clone()])
    }
    /// Main-world lease admission for DDS plus externally owned render-only fog.
    /// Strong handles retain external ownership but cannot prove GPU allocation,
    /// texture contents, sampler or render-world readiness. The caller checks those.
    /// Render-only images may have left Assets<Image> after extraction.
    pub fn images_render_fog(&self,store:&Store,assets:&Assets<Image>,fog:[Handle<Image>;2])->Result<[Handle<Image>;4],String> {
        if fog.iter().any(|h|!h.is_strong() || h.id()==Handle::<Image>::default().id()) {
            return Err("native render fog requires externally owned strong handles".into());
        }
        Ok([store.image(&self.diffuse,assets)?,store.image(&self.color,assets)?,fog[0].clone(),fog[1].clone()])
    }
    /// Logical/storage metadata for admission to the existing native quad shader.
    pub fn layouts(&self,store:&Store)->Result<[crate::relic_image_reference_store::Layout;2],String>{
        Ok([store.layout(&self.diffuse)?,store.layout(&self.color)?])
    }
    /// Call only after removing all draw/material users of these handles.
    /// Failed releases retain their leases so the host can recover ownership.
    pub fn retire(self,store:&mut Store,assets:&mut Assets<Image>)->Result<(),Failure> {
        let mut leases=Vec::new();let mut messages=Vec::new();
        for lease in [self.diffuse,self.color] {
            if let Err(error)=store.release(lease,assets) {leases.push(error.lease);messages.push(error.message);}
        }
        if leases.is_empty(){Ok(())}else{Err(Failure {leases,message:messages.join("; ")})}
    }
}

#[cfg(test)]
#[path="relic_rune_image_bindings_tests.rs"]
mod tests;
