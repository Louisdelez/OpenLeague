//! Encoded TLS/FLS provider for the actual CRT getter, constructor and default power.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,audio_global_float_default_power::Windows};
pub struct Provider<'a,S>{pub services:&'a mut S}
impl<S:Windows+crate::audio_crt_tls_value_wrappers::Services> Windows for Provider<'_,S>{
 fn get_last_error(&mut self,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.services.get_last_error(m,d)}
 fn set_last_error(&mut self,value:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{self.services.set_last_error(value,m,d)}
 fn tls_get_value(&mut self,index:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{crate::audio_crt_tls_value_wrappers::get_value(m,d,index,self.services)}
 fn tls_set_value(&mut self,index:u32,value:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<bool,Error>{Ok(crate::audio_crt_tls_value_wrappers::set_value(m,d,index,value,self.services)?!=0)}
 fn calloc_thread(&mut self,count:u32,size:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{self.services.calloc_thread(count,size,m,d)}
 fn free_thread(&mut self,reference:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{self.services.free_thread(reference,m,d)}
 fn current_thread_id(&mut self,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.services.current_thread_id(m,d)}
 fn thread_lock(&mut self,reference:u32,enter:bool,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{self.services.thread_lock(reference,enter,m,d)}
}
pub fn get_context(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,services:&mut(impl Windows+crate::audio_crt_tls_value_wrappers::Services))->Result<u32,Error>{crate::audio_crt_thread_context::get_context(m,d,&mut Provider{services})}
