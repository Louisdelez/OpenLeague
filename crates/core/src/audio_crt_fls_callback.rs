//! Registered original CA9026 FLS callback dispatch to the actual Rust destructor.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
pub const THREAD_DESTRUCTOR:u32=0xca9026;
/// Windows skips NULL data/callback. The provider must clear slot data before dispatch.
/// This dispatch is logical; a native OS ABI shim remains a separate provider obligation.
pub fn dispatch(callback:Option<u32>,value:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,s:&mut impl crate::audio_crt_thread_destructor::Services)->Result<(),Error>{
 if value==0||callback.is_none()||callback==Some(0){return Ok(());}
 if callback!=Some(THREAD_DESTRUCTOR){return Err(Error::Backend("unresolved FLS callback"));}
 crate::audio_crt_thread_destructor::destroy(m,dead,value,s)
}
