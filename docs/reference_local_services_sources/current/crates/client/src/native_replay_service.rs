//! Client-owned native service storage with real parsed configuration.
//! Frame dispatch and replay streams are not yet connected to the simulation.
use openleague_core::{audio_game_service_lifecycle as service, audio_announcer_owner_metadata as metadata,
    audio_announcer_registry_init::{self as init, Storage, OwnedMemory},
    audio_announcer_object_lookup::{self as lookup, Memory},
    audio_announcer_registry_remove::{self as remove, Backend as RemovalBackend, Deallocator},
    audio_announcer_owner_component_destructor::ControlBoundary,
    audio_announcer_owner_control::{self as control, ObjectBoundary}};
use service::Settings;
use std::collections::BTreeMap;
use crate::native_replay_settings::Configuration;

struct Backend { memory: OwnedMemory, configuration: Configuration, counts: BTreeMap<u32, control::Counts> }
impl Memory for Backend {
    fn word(&mut self, address: u32) -> Result<u32, lookup::Error> { self.memory.word(address) }
}
impl Storage for Backend {
    fn allocate(&mut self, n: u32) -> Result<u32, init::Error> { self.memory.allocate(n) }
    fn write_word(&mut self, a: u32, v: u32) -> Result<(), init::Error> { Storage::write_word(&mut self.memory,a,v) }
    fn write_byte(&mut self, a: u32, v: u8) -> Result<(), init::Error> { self.memory.write_byte(a,v) }
    fn register_shutdown(&mut self, c: u32) -> Result<(), init::Error> { self.memory.register_shutdown(c) }
}
impl RemovalBackend for Backend {
    fn write_word(&mut self,a:u32,v:u32)->Result<(),remove::Error>{Storage::write_word(&mut self.memory,a,v).map_err(remove::Error::Owned)}
    fn deallocator(&mut self)->Result<Deallocator,remove::Error>{Ok(Deallocator::Standard)}
    fn free(&mut self,p:u32,_:Deallocator)->Result<(),remove::Error>{self.memory.release(p).map_err(remove::Error::Owned)?;self.counts.remove(&p);Ok(())}
}
impl metadata::Boundaries for Backend {
    fn allocate_callback_clone(&mut self,n:u32)->Result<u32,&'static str>{self.memory.allocate(n).map_err(|_|"callback allocation failed")}
    fn register_listener(&mut self,_:u32,_:u32,_:u32,_:&mut u32)->Result<(),&'static str>{Err("live actor listener registration is not connected")}
    fn unregister_listener(&mut self,_:u32,_:u32,_:u32)->Result<(),&'static str>{Err("live actor listener removal is not connected")}
}
impl Settings for Backend {
    fn float_bits(&mut self,s:&str,k:&str,d:u32)->Result<u32,&'static str>{self.configuration.float_bits(s,k,d)}
    fn bool_value(&mut self,s:&str,k:&str,d:u8)->Result<u8,&'static str>{self.configuration.bool_value(s,k,d)}
    fn integer(&mut self,s:&str,k:&str,d:u32)->Result<u32,&'static str>{self.configuration.integer(s,k,d)}
}
impl ControlBoundary for Backend {
    fn decrement_reference(&mut self,address:u32)->Result<u32,&'static str>{
        let (base,offset)=if self.counts.contains_key(&(address-4)){(address-4,4)}else if self.counts.contains_key(&(address-8)){(address-8,8)}else{
            let base=address.checked_sub(4).ok_or("invalid reference counter")?;
            let strong=self.word(base+4).map_err(|_|"missing strong count")?;
            let weak=self.word(base+8).map_err(|_|"missing weak count")?;
            self.counts.insert(base,control::Counts::new(strong,weak));(base,4)
        };
        let counts=self.counts.get(&base).ok_or("missing reference counter")?;
        let previous=counts.decrement(offset)?;
        Storage::write_word(&mut self.memory,address,counts.read(offset)?).map_err(|_|"counter write failed")?;
        Ok(previous)
    }
    fn dispose(&mut self,p:u32,callback:u32)->Result<(),&'static str>{
        if callback!=control::DISPOSE{return Err("unsupported control disposal");}
        control::dispose(self,p).map_err(|_|"control disposal failed")
    }
    fn release_control(&mut self,p:u32,callback:u32)->Result<(),&'static str>{
        if callback!=control::RELEASE{return Err("unsupported control release");}
        control::release(self,p).map_err(|_|"control release failed")
    }
}
impl ObjectBoundary for Backend {
    fn scalar_delete_object(&mut self,p:u32,callback:u32,flags:u32)->Result<(),&'static str>{
        if callback!=metadata::HANDLER_DELETE{return Err("unsupported replay stream object");}
        metadata::scalar_delete_callback(self,p,flags).map(|_|()).map_err(|_|"callback deletion failed")
    }
}

#[cfg(windows)]
type CanonicalService = openleague_core::audio_replay_windows_transport::ServiceHandle<
    openleague_core::audio_replay_transport_startup::windows::WindowsNetwork>;

pub struct Service {
    backend: Backend,
    pointer: Option<u32>,
    #[cfg(windows)]
    canonical: Option<CanonicalService>,
}
#[cfg(windows)]
fn canonical_error(context: &'static str, error: String) -> metadata::Error {
    eprintln!("{context}: {error}");
    metadata::Error::Boundary(context)
}
impl Service {
    pub fn new(configuration: Configuration) -> Result<Self,metadata::Error> {
        let mut backend=Backend {memory:OwnedMemory::new(0x34000000,0),configuration,counts:BTreeMap::new()};
        for (address,bytes) in [(service::CALLBACK_VTABLE,12),(control::VTABLE,12),(service::CURVE_CONTROLS,32),(0x30009800,4)] {
            backend.memory.reserve_at(address,bytes)?;
        }
        for (address,value) in [(service::CALLBACK_VTABLE,metadata::HANDLER_DELETE),(service::CALLBACK_VTABLE+4,service::CALLBACK_CLONE),
            (service::CALLBACK_VTABLE+8,0x734130),(control::VTABLE,control::DISPOSE),(control::VTABLE+4,control::RELEASE),(control::VTABLE+8,control::SCALAR_DELETE)] {
            Storage::write_word(&mut backend,address,value)?;
        }
        // Eight controls recovered at1224D84 in the verified4.20 executable.
        for (index,value) in [0.0f32,10.,25.,50.,100.,200.,400.,800.].iter().enumerate() {
            Storage::write_word(&mut backend,service::CURVE_CONTROLS+index as u32*4,value.to_bits())?;
        }
        let pointer=backend.allocate(0x188)?;
        service::construct(&mut backend,pointer,0x30009800,0)?;
        Ok(Self {backend,pointer:Some(pointer),#[cfg(windows)] canonical:None})
    }
    /// Reconstruct from parsed settings in the runtime's own bank, then retire
    /// the standalone object. Only configuration values cross this boundary.
    #[cfg(windows)]
    pub fn attach(&mut self, runtime: &openleague_core::audio_replay_windows_application::Runtime) -> Result<(),String> {
        if self.canonical.is_some() { return Err("replay service is already attached to a canonical runtime".into()); }
        if self.pointer.is_none() { return Err("cannot attach a closed replay service".into()); }
        let canonical = runtime.configure_service(self.backend.configuration.clone())?;
        self.close().map_err(|e|format!("retire standalone replay service after canonical construction: {e:?}"))?;
        self.canonical = Some(canonical);
        Ok(())
    }
    pub fn diagnostic(&mut self)->Result<serde_json::Value,metadata::Error>{
        #[cfg(windows)]
        if let Some(canonical) = &self.canonical {
            return canonical.diagnostic().map_err(|e|canonical_error("canonical replay service diagnostic failed",e));
        }
        let p=self.pointer.ok_or(metadata::Error::Boundary("service already closed"))?;
        let mut floats=serde_json::Map::new();
        for (index,name) in ["FastForwardSpeed","LagUpdateFreq","MaxLiveTimeBehind","HeartbeatDelay","SlowFastForwardSpeed","SpeedupSpeed"].iter().enumerate(){
            floats.insert((*name).into(),serde_json::json!(self.backend.word(p+0x60+index as u32*4)?));
        }
        Ok(serde_json::json!({"float_bits":floats,"DisableCatchup":self.backend.memory.read_byte(p+0x100)?,
            "UseLookAhead":self.backend.memory.read_byte(p+0x131)?,"history_mode":self.backend.word(p+0x14c)?,
            "PingTimeForReconnectMessage":self.backend.word(p+0x17c)? as i32,"live_allocations":self.live_allocations()}))
    }
    pub fn live_allocations(&self)->usize{
        #[cfg(windows)]
        if let Some(canonical) = &self.canonical { return canonical.live_allocations(); }
        self.backend.memory.allocations.iter().filter(|(_,p)|self.backend.memory.read_byte(*p).is_ok()).count()
    }
    pub fn close(&mut self)->Result<(),metadata::Error>{
        #[cfg(windows)]
        if let Some(canonical) = &self.canonical {
            return canonical.close().map_err(|e|canonical_error("canonical replay service shutdown failed",e));
        }
        if let Some(pointer)=self.pointer.take(){service::scalar_delete(&mut self.backend,pointer,1)?;}
        Ok(())
    }
}
impl Drop for Service {
    fn drop(&mut self){if let Err(error)=self.close(){eprintln!("Native replay service shutdown failed: {error:?}");}}
}

#[cfg(test)] mod tests {
    use super::*;
    #[cfg(windows)]
    #[test]
    fn native_replay_service_attachment_reconstructs_settings_and_retires_standalone_ownership() {
        let configuration=Configuration::from_files(
            Some(b"[Replay]\nFastForwardSpeed=12.5\n"),
            Some(b"[Replay]\nFastForwardSpeed=8.5\nDisableCatchup=false\nUseLookAhead=2\n[Reconnect]\nPingTimeForReconnectMessage=-7\n")
        ).unwrap();
        let mut service=Service::new(configuration).unwrap();
        let before=service.diagnostic().unwrap();
        let old_pointer=service.pointer.unwrap();
        let mut application=openleague_core::audio_replay_windows_application::Application::new().unwrap();
        service.attach(application.transport().unwrap()).unwrap();
        assert!(service.pointer.is_none());
        assert!(service.backend.memory.read_byte(old_pointer).is_err());
        assert!(service.backend.memory.allocations.iter().all(|(_,p)|service.backend.memory.read_byte(*p).is_err()));
        let attached=service.diagnostic().unwrap();
        for key in ["float_bits","DisableCatchup","UseLookAhead","history_mode","PingTimeForReconnectMessage"] {
            assert_eq!(attached[key],before[key],"configuration field {key}");
        }
        assert_eq!(attached["canonical_runtime_bank"],true);
        assert_ne!(attached["pointer"].as_u64().unwrap(),old_pointer as u64);
        assert_eq!(attached["live_allocations"].as_u64().unwrap() as usize,service.live_allocations());
        assert!(service.live_allocations()>0);
        assert!(service.attach(application.transport().unwrap()).is_err());
        service.close().unwrap();service.close().unwrap();
        assert_eq!(service.live_allocations(),0);
        application.close().unwrap();
    }
    #[test] fn native_replay_loaded_files_reach_owned_service_and_close_releases_storage(){
        let baseline=include_bytes!("../../../data/4.20/configuration/defaults/Game.cfg");
        let user=b"[Replay]\nFastForwardSpeed=8.5\nLagUpdateFreq=2\nDisableCatchup=false\nUseLookAhead=2\n[TournamentPause]\nHeartbeatDelay=.25\n[Hacks]\nDisableFM=true\n[Reconnect]\nPingTimeForReconnectMessage=-7\n";
        let config=Configuration::from_files(Some(baseline),Some(user)).unwrap();
        let mut service=Service::new(config).unwrap();let d=service.diagnostic().unwrap();
        assert_eq!(d["float_bits"]["FastForwardSpeed"],8.5f32.to_bits());assert_eq!(d["float_bits"]["LagUpdateFreq"],2f32.to_bits());
        assert_eq!(d["float_bits"]["HeartbeatDelay"],0.25f32.to_bits());assert_eq!(d["DisableCatchup"],0);assert_eq!(d["UseLookAhead"],1);
        assert_eq!(d["history_mode"],u32::MAX);assert_eq!(d["PingTimeForReconnectMessage"],-7);assert!(service.live_allocations()>0);
        service.close().unwrap();assert_eq!(service.live_allocations(),0);service.close().unwrap();
    }
    #[test] fn native_replay_file_comment_rules_reach_service_and_invalid_file_is_not_defaulted(){
        let config=Configuration::from_files(Some(b"[Replay]\nFastForwardSpeed=12.5\n"),Some(b"[Replay]\nFastForwardSpeed=$##$\n")).unwrap();
        // The file parser treats '#' as a comment, so this file contains '$'.
        // Only an already-populated exact '$##$' value invokes the getter marker.
        let mut service=Service::new(config).unwrap();assert_eq!(service.diagnostic().unwrap()["float_bits"]["FastForwardSpeed"],0f32.to_bits());
        service.close().unwrap();assert_eq!(service.live_allocations(),0);
        assert!(Configuration::from_files(None,Some(b"[Replay]\n\t\t=4\n")).is_err());
    }
}
