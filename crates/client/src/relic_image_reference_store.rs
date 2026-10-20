//! Main-world Bevy Image ownership adapter; CPU load/residency never means GPU ready.
use bevy::{prelude::*,image::{ImageType,ImageSampler,CompressedImageFormats},asset::RenderAssetUsages};
use std::{collections::HashMap,sync::atomic::{AtomicU64,Ordering}};
static NEXT_IMAGE_ID:AtomicU64=AtomicU64::new(0);
use crate::relic_texture_reference_cache::{Cache,Id,Release};
#[derive(Debug,PartialEq,Eq)]
pub struct Lease {id:Id}
impl Lease {pub fn id(&self)->Id {self.id}}
#[derive(Debug)]
pub struct ReleaseError {pub lease:Lease,pub message:String}
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
pub struct Layout {pub source_extent:[u32;3],pub storage_extent:[u32;3],pub mip_levels:u32}
impl Layout {
    /// Header metadata differs from the physical texture, as in the original
    /// DDS parser/device path (9B6685 / 9BB45F). This is not a crop instruction.
    pub fn source_has_block_padding(self)->bool {self.source_extent!=self.storage_extent}
}
#[derive(Default)]
pub struct Store {cache:Cache,images:HashMap<Id,Handle<Image>>,layouts:HashMap<Id,Layout>}
impl Store {
    /// Caller supplies the qualified native file/VFS hash, sampler, supported GPU
    /// compression set and colour-space choice. No replacement texture is generated.
    pub fn acquire_dds(&mut self,key:u32,bytes:&[u8],compressed:CompressedImageFormats,is_srgb:bool,
                       sampler:ImageSampler,assets:&mut Assets<Image>)->Result<Lease,String> {
        if let Some(id)=self.cache.lookup(key) {
            let handle=self.images.get(&id).ok_or("owned image handle missing")?;
            if assets.get(handle).is_none() {return Err("cached image removed outside its owner".into());}
            self.cache.acquire(key,id).map_err(|e|format!("cached image acquire: {e:?}"))?;
            return Ok(Lease {id});
        }
        let image=Image::from_buffer(bytes,ImageType::Extension("dds"),compressed,is_srgb,sampler,
            RenderAssetUsages::MAIN_WORLD|RenderAssetUsages::RENDER_WORLD).map_err(|e|format!("original DDS decode: {e}"))?;
        let word=|offset:usize|->Result<u32,String> {
            Ok(u32::from_le_bytes(bytes.get(offset..offset+4).ok_or("truncated original DDS header")?.try_into().unwrap()))
        };
        let source_extent=[word(16)?,word(12)?,word(24)?.max(1)];
        if source_extent.contains(&0) {return Err("invalid original DDS logical extent".into());}
        let d=&image.texture_descriptor;
        if matches!(bytes.get(84..88),Some(b"DXT1"|b"DXT3"|b"DXT5")) {
            let expected=[source_extent[0].div_ceil(4)*4,source_extent[1].div_ceil(4)*4,source_extent[2]];
            if [d.size.width,d.size.height,d.size.depth_or_array_layers]!=expected {
                return Err("Bevy view disagrees with native compressed DDS extent".into());
            }
        }
        let layout=Layout {source_extent,storage_extent:[d.size.width,d.size.height,d.size.depth_or_array_layers],mip_levels:d.mip_level_count};
        // Process-wide transport IDs prevent leases from one image store from
        // accidentally referring to an equal local ordinal in another store.
        let id=NEXT_IMAGE_ID.fetch_update(Ordering::Relaxed,Ordering::Relaxed,|n|n.checked_add(1))
            .map_err(|_|"image identity exhausted")?+1;
        self.cache.acquire(key,id).map_err(|e|format!("new image acquire: {e:?}"))?;
        self.images.insert(id,assets.add(image));self.layouts.insert(id,layout);Ok(Lease {id})
    }
    pub fn image(&self,lease:&Lease,assets:&Assets<Image>)->Result<Handle<Image>,String> {
        if self.cache.refs(lease.id).is_none() {return Err("retired image lease".into());}
        let handle=self.images.get(&lease.id).ok_or("owned image handle missing")?;
        if assets.get(handle).is_none() {return Err("owned image is not CPU loaded".into());}
        Ok(handle.clone())
    }
    /// Pins the image for renderer ownership; RenderAssets/pipeline checks are separate.
    pub fn pin_for_renderer(&mut self,lease:&Lease)->Result<bool,String> {
        self.cache.register_resident(lease.id).map_err(|e|format!("image registration: {e:?}"))
    }
    pub fn layout(&self,lease:&Lease)->Result<Layout,String> {
        self.layouts.get(&lease.id).copied().ok_or_else(||"retired image layout".into())
    }
    /// Caller must retire its draw/material use before releasing that lease.
    pub fn release(&mut self,lease:Lease,assets:&mut Assets<Image>)->Result<(),ReleaseError> {
        if self.cache.refs(lease.id).is_none() || !self.images.contains_key(&lease.id) {
            return Err(ReleaseError {lease,message:"foreign or retired image lease".into()});
        }
        let result=match self.cache.release(lease.id) {
            Ok(result)=>result,
            Err(error)=>return Err(ReleaseError {lease,message:format!("image release: {error:?}")}),
        };
        if result==Release::Destroyed {
            let handle=self.images.remove(&lease.id).expect("owned image checked before reference release");
            self.layouts.remove(&lease.id);assets.remove(handle.id());
        }
        Ok(())
    }
    /// After draw retirement, native renderer teardown invalidates all remaining IDs.
    pub fn cleanup_renderer(&mut self,assets:&mut Assets<Image>)->Result<(),String> {
        for id in self.cache.cleanup_renderer().map_err(|e|format!("image cleanup: {e:?}"))? {
            let handle=self.images.remove(&id).ok_or("owned image handle missing")?;
            self.layouts.remove(&id);
            assets.remove(handle.id());
        }
        Ok(())
    }
    pub fn refs(&self,lease:&Lease)->Option<i32> {self.cache.refs(lease.id)}
    pub fn len(&self)->usize {self.cache.len()}
}

#[cfg(test)]
#[path="relic_image_reference_store_tests.rs"]
mod tests;
