//! Canonical ownership of the configured72A3B0 service and its eventual parent.
use super::*;
use crate::audio_game_service_lifecycle as service;

pub(super) struct Record {
    pub(super) pointer: u32,
    allocations: BTreeSet<u32>,
}
/// This handle owns only the configured service. The application retains the
/// runtime and its CRT lifetime; shutdown may retire the service before Drop.
pub struct ServiceHandle<N: startup::Network + Send + 'static> {
    shared: Arc<Shared<N>>,
    pointer: u32,
}
impl<N: startup::Network + Send + 'static> ServiceHandle<N> {
    pub fn diagnostic(&self) -> Result<serde_json::Value, String> {
        let runtime = Runtime {
            shared: self.shared.clone(),
        };
        runtime.service_diagnostic(self.pointer)
    }
    pub fn live_allocations(&self) -> usize {
        let owner = self.shared.service.lock().unwrap();
        let Some(r) = owner.as_ref() else {
            return 0;
        };
        if r.pointer != self.pointer {
            return 0;
        }
        let bank = self.shared.bank.lock().unwrap();
        r.allocations.intersection(&bank.owned).count()
    }
    pub fn close(&self) -> Result<(), String> {
        let runtime = Runtime {
            shared: self.shared.clone(),
        };
        runtime.close_service(self.pointer)
    }
}
impl<N: startup::Network + Send + 'static> Drop for ServiceHandle<N> {
    fn drop(&mut self) {
        if let Err(e) = self.close() {
            eprintln!("Canonical replay service shutdown failed: {e}");
        }
    }
}
impl<N: startup::Network + Send + 'static> service::Settings for Backend<N> {
    fn float_bits(&mut self, s: &str, k: &str, d: u32) -> Result<u32, &'static str> {
        self.shared
            .service_settings
            .lock()
            .map_err(|_| "service settings poisoned")?
            .as_mut()
            .ok_or("service settings unavailable")?
            .float_bits(s, k, d)
    }
    fn bool_value(&mut self, s: &str, k: &str, d: u8) -> Result<u8, &'static str> {
        self.shared
            .service_settings
            .lock()
            .map_err(|_| "service settings poisoned")?
            .as_mut()
            .ok_or("service settings unavailable")?
            .bool_value(s, k, d)
    }
    fn integer(&mut self, s: &str, k: &str, d: u32) -> Result<u32, &'static str> {
        self.shared
            .service_settings
            .lock()
            .map_err(|_| "service settings poisoned")?
            .as_mut()
            .ok_or("service settings unavailable")?
            .integer(s, k, d)
    }
}
impl<N: startup::Network + Send + 'static> Runtime<N> {
    /// Reconstruct from the parsed provider, never import pointers or a snapshot
    /// from another canonical address space. One configured owner per runtime.
    pub fn configure_service<S: service::Settings + Send + 'static>(
        &self,
        settings: S,
    ) -> Result<ServiceHandle<N>, String> {
        let closed = self
            .shared
            .launch
            .lock()
            .map_err(|_| "launch lock poisoned")?;
        if *closed {
            return Err("transport runtime is shut down".into());
        }
        if self.shared.diagnostics.is_some()
            || self.shared.active.load(Ordering::Acquire) != 0
            || self.shared.service.lock().unwrap().is_some()
            || self.shared.service_settings.lock().unwrap().is_some()
            || !self.shared.bank.lock().unwrap().owned.is_empty()
        {
            return Err("configured service requires a fresh owned runtime lifetime".into());
        }
        let baseline = self.shared.bank.lock().unwrap().owned.clone();
        let mut b = Backend::new(self.shared.clone());
        let scratch = b.recording_scratch(4).map_err(str::to_string)?;
        *self.shared.service_settings.lock().unwrap() = Some(Box::new(settings));
        let result = (|| -> Result<u32, String> {
            let p = b
                .allocate(0x188)
                .map_err(|e| format!("service allocation: {e:?}"))?;
            service::construct(&mut b, p, scratch, 0)
                .map_err(|e| format!("service construction: {e:?}"))?;
            Ok(p)
        })();
        let cleanup = self.shared.bank.lock().unwrap().memory.release(scratch);
        let p = match (result, cleanup) {
            (Ok(p), Ok(())) => p,
            (a, c) => {
                // Host construction guard: source72A3B0 publishes no external
                // listeners/locks. Its newly allocated blocks remain private
                // until Record publication, so a provider failure can retire all.
                let mut bank = self.shared.bank.lock().unwrap();
                let fresh: Vec<_> = bank.owned.difference(&baseline).copied().collect();
                for q in fresh.into_iter().rev() {
                    bank.memory
                        .release(q)
                        .map_err(|e| format!("service rollback: {e:?}; original: {a:?}/{c:?}"))?;
                    bank.owned.remove(&q);
                }
                self.shared.service_settings.lock().unwrap().take();
                return Err(format!("service construction: {a:?}; scratch: {c:?}"));
            }
        };
        let allocations = self
            .shared
            .bank
            .lock()
            .unwrap()
            .owned
            .difference(&baseline)
            .copied()
            .collect();
        *self.shared.service.lock().unwrap() = Some(Record {
            pointer: p,
            allocations,
        });
        Ok(ServiceHandle {
            shared: self.shared.clone(),
            pointer: p,
        })
    }
    pub(super) fn has_only_service_allocations(&self) -> bool {
        let owner = self.shared.service.lock().unwrap();
        let bank = self.shared.bank.lock().unwrap();
        if let Some(r) = owner.as_ref() {
            bank.owned == r.allocations
        } else {
            bank.owned.is_empty()
        }
    }
    fn service_diagnostic(&self, expected: u32) -> Result<serde_json::Value, String> {
        let closed = self
            .shared
            .launch
            .lock()
            .map_err(|_| "launch lock poisoned")?;
        if *closed {
            return Err("transport runtime is shut down".into());
        }
        let owner = self
            .shared
            .service
            .lock()
            .map_err(|_| "service owner poisoned")?;
        let r = owner.as_ref().ok_or("service already closed")?;
        if r.pointer != expected {
            return Err("stale service handle".into());
        }
        let p = r.pointer;
        let mut b = Backend::new(self.shared.clone());
        let mut floats = serde_json::Map::new();
        for (i, name) in [
            "FastForwardSpeed",
            "LagUpdateFreq",
            "MaxLiveTimeBehind",
            "HeartbeatDelay",
            "SlowFastForwardSpeed",
            "SpeedupSpeed",
        ]
        .iter()
        .enumerate()
        {
            floats.insert(
                (*name).into(),
                serde_json::json!(b
                    .word(p + 0x60 + i as u32 * 4)
                    .map_err(|e| format!("service setting: {e:?}"))?),
            );
        }
        let disable = logger::Boundary::byte(&mut b, p + 0x100).map_err(str::to_string)?;
        let look = logger::Boundary::byte(&mut b, p + 0x131).map_err(str::to_string)?;
        let history = b
            .word(p + 0x14c)
            .map_err(|e| format!("service history: {e:?}"))?;
        let ping = b
            .word(p + 0x17c)
            .map_err(|e| format!("service ping: {e:?}"))? as i32;
        let bank = self.shared.bank.lock().unwrap();
        let count = r.allocations.intersection(&bank.owned).count();
        Ok(
            serde_json::json!({"float_bits":floats,"DisableCatchup":disable,"UseLookAhead":look,"history_mode":history,"PingTimeForReconnectMessage":ping,"live_allocations":count,"canonical_runtime_bank":true,"pointer":p}),
        )
    }
    fn close_service(&self, expected: u32) -> Result<(), String> {
        let closed = self
            .shared
            .launch
            .lock()
            .map_err(|_| "launch lock poisoned")?;
        if *closed {
            return Ok(());
        }
        if self
            .shared
            .service
            .lock()
            .unwrap()
            .as_ref()
            .is_some_and(|r| r.pointer != expected)
        {
            return Err("stale service handle".into());
        }
        let mut b = Backend::new(self.shared.clone());
        self.close_game_manager_owned(&mut b)?;
        self.close_service_owned(&mut b)
    }
    pub(super) fn close_service_owned(&self, b: &mut Backend<N>) -> Result<(), String> {
        let mut owner = self
            .shared
            .service
            .lock()
            .map_err(|_| "service owner poisoned")?;
        if let Some(r) = owner.as_ref() {
            service::scalar_delete(b, r.pointer, 1)
                .map_err(|e| format!("service destruction: {e:?}"))?;
        }
        *owner = None;
        Ok(())
    }
}
