//! Explicit source resource-manager lifetime in the canonical Windows bank.
//! This does not claim to execute the complete original startup caller or load
//! real providers on cache misses. An unresolved retirement retains its bank.
use super::*;
use crate::audio_loading_resource_manager as resource;
use crate::audio_loading_resource_cache as cache;

impl<N: startup::Network + Send + 'static> cache::Boundary for Backend<N> {
    fn locale_is_default(&mut self)->Result<bool,cache::Error> {
        self.shared.bridge.loading_c_locale_is_default()
            .map_err(|e|cache::Error::Boundary(self.failure(e,"resource cache CRT locale lookup failed")))
    }
}

pub(super) struct Record<N> {
    native: resource::Record,
    ready: bool,
    last_error: Option<String>,
    _keepalive: Arc<Shared<N>>,
}
pub(super) struct State<N> {
    attempted: bool,
    record: Option<Record<N>>,
}
impl<N> Default for State<N> {
    fn default() -> Self { Self { attempted:false, record:None } }
}

impl<N: startup::Network + Send + 'static> Runtime<N> {
    /// Execute the four real static initializers, source producer and separately
    /// qualified backpointer fragment. No configured provider is fabricated.
    pub fn initialize_loading_resources(&self) -> Result<u32,String> {
        let closed=self.shared.launch.lock().map_err(|_|"launch lock poisoned")?;
        if *closed {return Err("transport runtime is shut down".into());}
        if self.shared.active.load(Ordering::Acquire)!=0 {
            return Err("resource manager initialization requires an idle worker lifetime".into());
        }
        let mut state=self.shared.resource_manager.lock().map_err(|_|"resource manager lock poisoned")?;
        if state.attempted {
            return match state.record.as_ref() {
                Some(record) if record.ready => Ok(record.native.pointer()),
                _ => Err("resource manager initialization already attempted; retire the retained lifetime".into()),
            };
        }
        let mut b=Backend::new(self.shared.clone());
        if b.word(0x2d78f1c).map_err(|e|format!("resource manager global: {e:?}"))?!=0 {
            return Err("resource manager global belongs to another owner".into());
        }
        // Validate the actual static registration table, not fixture hashes.
        for (i,expected) in [0x531a50,0x531a90,0x531ad0,0x531b10].into_iter().enumerate() {
            if b.word(0xfa6b74+i as u32*4).map_err(|e|format!("resource initializer table: {e:?}"))?!=expected {
                return Err("unrecognized resource static initializer table".into());
            }
        }
        state.attempted=true;
        state.record=Some(Record { native:resource::Record::default(),ready:false,last_error:None,_keepalive:self.shared.clone() });
        let record=state.record.as_mut().unwrap();
        let result:Result<u32,String>=(|| {
            resource::initialize_hashes(&mut b).map_err(|e|format!("resource hash initialization: {e:?}"))?;
            // The insertion output is borrowed only during produce. All native
            // allocations become Record-owned before their fallible writes.
            let pointer=b.event_temporary(4,|b,scratch| {
                resource::produce(b,&mut record.native,scratch)
                    .map_err(|e|b.failure(e,"resource manager construction failed"))
            }).map_err(str::to_string)?;
            if pointer==0 {return Err("resource manager allocation returned null".into());}
            resource::wire_backpointers(&mut b,&mut record.native)
                .map_err(|e|format!("resource manager backpointers: {e:?}"))?;
            Ok(pointer)
        })();
        match result {
            Ok(pointer)=>{record.ready=true;Ok(pointer)},
            Err(error)=>{record.last_error=Some(error.clone());Err(error)},
        }
    }

    pub fn loading_resource_snapshot(&self)->Result<serde_json::Value,String> {
        let state=self.shared.resource_manager.lock().map_err(|_|"resource manager lock poisoned")?;
        Ok(serde_json::json!({"attempted":state.attempted,"record":state.record.as_ref().map(|record|
            serde_json::json!({"ready":record.ready,"native":record.native.snapshot(),"last_error":record.last_error})),
            "real_providers_connected":false,"normal_startup_caller_complete":false}))
    }

    pub(super) fn close_loading_resources_owned(&self,b:&mut Backend<N>)->Result<(),String> {
        if self.shared.active.load(Ordering::Acquire)!=0 {
            return Err("resource manager cannot retire while a worker owns runtime state".into());
        }
        let mut state=self.shared.resource_manager.lock().map_err(|_|"resource manager lock poisoned")?;
        let Some(record)=state.record.as_mut() else{return Ok(());};
        record.ready=false;
        match resource::retire_empty(b,&mut record.native) {
            Ok(())=>{state.record=None;Ok(())},
            Err(error)=>{
                let text=format!("resource manager retirement remains unresolved: {error:?}");
                record.last_error=Some(text.clone());
                b.failure(&error,"resource manager retirement remains unresolved");
                Err(text)
            },
        }
    }
}

#[cfg(test)]
#[path="audio_replay_windows_resource_manager_tests.rs"]
mod tests;
