//! Physical Windows boundaries and lifetime ownership for native8FC610.
//! The source base or derived object remains owned until close_configuration/shutdown.
use super::*;
use crate::{
    audio_replay_address as address, audio_replay_stream_transport as derived,
    audio_replay_transport_configuration as native,
};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ConfigurationCallback {
    pub owner: u32,
    pub member: u32,
}
pub struct ConfigurationRequest<'a> {
    pub host: Option<&'a [u8]>,
    pub port: u32,
    pub arguments: [u32; 2],
    pub callback: Option<ConfigurationCallback>,
    /// Caller-owned initial storage, including the native unwritten port/padding.
    /// Numeric IPv4 conversion overwrites it; localhost preserves those bytes.
    pub sockaddr_frame: [u8; 16],
}
/// Source8F6EB0 configuration of the2328-byte implementation used by8F68D0.
pub struct StreamConfigurationRequest<'a> {
    pub transport: ConfigurationRequest<'a>,
    pub key: [u8; 16],
    pub flag: u32,
    pub extra: u32,
}
#[derive(Debug, Clone, PartialEq, Eq, serde::Serialize)]
pub struct StreamConfigurationSnapshot {
    pub interface_pointer: u32,
    pub key_pointer: u32,
    pub flag: u8,
    pub extra: u32,
}
#[derive(Debug, Clone, PartialEq, Eq, serde::Serialize)]
pub struct ConfigurationSnapshot {
    pub pointer: u32,
    pub return_code: Option<u32>,
    pub ipv4: u32,
    pub requested_port: u16,
    pub uid: u32,
    pub arguments: [u32; 2],
    pub address_text: Vec<u8>,
    pub callback: Option<[u32; 3]>,
    pub host: u32,
    pub queue_count: u32,
    pub stream: Option<StreamConfigurationSnapshot>,
}
pub(super) struct Record {
    pointer: u32,
    code: Option<u32>,
    derived: bool,
    attempted: bool,
}

impl<N: startup::Network + Send + 'static> Runtime<N> {
    /// Configure the source object through actual Windows startup/address/logging.
    /// This does not create an ENet host or deliver replay frames.
    pub fn configure(&self, request: ConfigurationRequest<'_>) -> Result<u32, String> {
        self.configure_owned(request, None)
    }
    /// Fresh implementation only, matching the source parent's state1 gate.
    /// Frame delivery and the parent stream's shared ownership are not attached yet.
    pub fn configure_stream_transport(
        &self,
        request: StreamConfigurationRequest<'_>,
    ) -> Result<u32, String> {
        self.configure_owned(
            request.transport,
            Some((request.key, request.flag, request.extra)),
        )
    }
    fn configure_owned(
        &self,
        request: ConfigurationRequest<'_>,
        stream: Option<([u8; 16], u32, u32)>,
    ) -> Result<u32, String> {
        let closed = self
            .shared
            .launch
            .lock()
            .map_err(|_| "launch lock poisoned")?;
        if *closed {
            return Err("transport runtime is shut down".into());
        }
        if *self.shared.game_manager_attempted.lock().unwrap() {
            return Err("game manager lifetime excludes a standalone configuration".into());
        }
        if self.shared.stream.lock().unwrap().is_some() {
            return Err("an owned replay stream already uses this transport".into());
        }
        if self.shared.diagnostics.is_some() {
            return Err("configuration requires the owned native logger".into());
        }
        if self.shared.active.load(Ordering::Acquire) != 0 {
            return Err("configuration requires retired startup workers".into());
        }
        let mut b = Backend::new(self.shared.clone());
        //8FC380 skips the worker when status remains2 after the last reference was
        // released. Do not manufacture a new native reference or report readiness.
        if b.word(startup::STATUS)
            .map_err(|e| format!("configuration status: {e:?}"))?
            == 2
            && b.word(startup::REFERENCES)
                .map_err(|e| format!("configuration references: {e:?}"))?
                == 0
        {
            return Err("native transport was released but status remains2; a fresh application lifetime is required".into());
        }
        for (p, v) in [
            (native::VTABLE, native::CLOSE),
            (native::VTABLE + 4, native::SCALAR_DELETE),
        ] {
            if b.word(p)
                .map_err(|e| format!("configuration vtable: {e:?}"))?
                != v
            {
                return Err("unrecognized configuration vtable".into());
            }
        }
        for i in 0..144 {
            engine::Boundary::byte(&mut b, native::UID_SCRATCH + i)
                .map_err(|e| format!("configuration scratch: {e}"))?;
        }
        let mut owner = self
            .shared
            .configuration
            .lock()
            .map_err(|_| "configuration owner poisoned")?;
        let is_derived = stream.is_some();
        if let Some(record) = owner.as_ref() {
            if record.derived != is_derived {
                return Err(
                    "configuration implementation kind cannot change within its lifetime".into(),
                );
            }
            if is_derived && record.attempted {
                return Err("stream transport configuration already attempted; source state1 opening is required".into());
            }
        }
        if is_derived {
            for (p, v) in [
                (derived::VTABLE, derived::CLOSE),
                (derived::VTABLE + 4, derived::SCALAR_DELETE),
                (derived::INTERFACE_VTABLE + 16, 0x8f6eb0),
            ] {
                if b.word(p).map_err(|e| format!("stream vtable: {e:?}"))? != v {
                    return Err("unrecognized stream configuration vtable".into());
                }
            }
        }
        if owner.is_none() {
            let p = b
                .allocate(if is_derived { derived::BYTES } else { 224 })
                .map_err(|e| format!("configuration allocation: {e:?}"))?;
            let construction = if is_derived {
                derived::construct(&mut b, p).map_err(|e| format!("{e:?}"))
            } else {
                native::construct(&mut b, p).map_err(|e| format!("{e:?}"))
            };
            if let Err(error) = construction {
                // Constructor errors occur before any worker starts. Retire only this
                // object's optional proxy/section and allocation; preserve all other owners.
                let mut cleanup = Vec::new();
                let section_present = self.shared.locks.lock().unwrap().section(p + 0xc4).is_ok();
                if section_present {
                    if let Err(e) = thread::Boundary::delete_critical_section(&mut b, p + 0xc4) {
                        cleanup.push(e.to_string());
                    }
                }
                if let Ok(proxy) = b.word(p + 0xa8) {
                    if proxy != 0 {
                        if let Err(e) =
                            remove::Backend::free(&mut b, proxy, remove::Deallocator::Standard)
                        {
                            cleanup.push(format!("proxy: {e:?}"));
                        }
                    }
                }
                if let Err(e) = remove::Backend::free(&mut b, p, remove::Deallocator::Standard) {
                    cleanup.push(format!("object: {e:?}"));
                }
                return Err(format!(
                    "configuration construction: {error:?}; cleanup: {cleanup:?}"
                ));
            }
            *owner = Some(Record {
                pointer: p,
                code: None,
                derived: is_derived,
                attempted: false,
            });
        }
        let p = owner.as_ref().unwrap().pointer;
        let incoming = if let Some(cb) = request.callback {
            let p = b
                .allocate(12)
                .map_err(|e| format!("configuration callback: {e:?}"))?;
            for (offset, value) in [
                (0, callbacks::HANDLER_VTABLE),
                (4, cb.owner),
                (8, cb.member),
            ] {
                if let Err(e) = Storage::write_word(&mut b, p + offset, value) {
                    let cleanup = remove::Backend::free(&mut b, p, remove::Deallocator::Standard);
                    return Err(format!(
                        "callback initialization: {e:?}; cleanup: {cleanup:?}"
                    ));
                }
            }
            p
        } else {
            0
        };
        b.address_frame = Some(request.sockaddr_frame);
        owner.as_mut().unwrap().attempted = true;
        let result = if let Some((key, flag, extra)) = stream {
            derived::configure(
                &mut b,
                p + derived::INTERFACE,
                incoming,
                request.arguments,
                &key,
                request.host,
                request.port,
                flag,
                extra,
            )
            .map_err(|e| format!("{e:?}"))
        } else {
            native::configure(
                &mut b,
                p,
                incoming,
                request.arguments[0],
                request.arguments[1],
                request.host,
                request.port,
            )
            .map_err(|e| format!("{e:?}"))
        };
        owner.as_mut().unwrap().code = result.as_ref().ok().copied();
        result.map_err(|e| format!("native transport configuration: {e:?}"))
    }
    /// Uses the same ordered close/destruction during explicit and application exit.
    pub fn close_configuration(&self) -> Result<(), String> {
        let closed = self
            .shared
            .launch
            .lock()
            .map_err(|_| "launch lock poisoned")?;
        if *closed {
            return Ok(());
        }
        let mut b = Backend::new(self.shared.clone());
        thread::drain(&mut b).map_err(|e| format!("configuration worker drain: {e:?}"))?;
        self.close_configuration_owned(&mut b)
    }
    pub(super) fn close_configuration_owned(&self, b: &mut Backend<N>) -> Result<(), String> {
        if self.shared.active.load(Ordering::Acquire) != 0 {
            return Err("configuration cleanup requires retired workers".into());
        }
        let mut owner = self
            .shared
            .configuration
            .lock()
            .map_err(|_| "configuration owner poisoned")?;
        let Some(record) = owner.as_ref() else {
            return Ok(());
        };
        let p = record.pointer;
        let refs = b
            .word(startup::REFERENCES)
            .map_err(|e| format!("configuration references: {e:?}"))?;
        if refs > 1 {
            return Err("multiple global transport references require explicit owners".into());
        }
        if refs == 1 {
            if record.derived {
                derived::close(b, p).map_err(|e| format!("stream close: {e:?}"))?;
            } else {
                native::close(b, p).map_err(|e| format!("configuration close: {e:?}"))?;
            }
        } else if b
            .word(p + 8)
            .map_err(|e| format!("configuration host: {e:?}"))?
            != 0
        {
            return Err("active host has no owned network reference".into());
        }
        if record.derived {
            derived::scalar_delete(b, p, 1).map_err(|e| format!("stream destruction: {e:?}"))?;
        } else {
            native::scalar_delete(b, p, 1)
                .map_err(|e| format!("configuration destruction: {e:?}"))?;
        }
        *owner = None;
        Ok(())
    }
    pub fn configuration_snapshot(&self) -> Result<Option<ConfigurationSnapshot>, String> {
        let _launch = self
            .shared
            .launch
            .lock()
            .map_err(|_| "launch lock poisoned")?;
        if self.shared.active.load(Ordering::Acquire) != 0 {
            return Err("configuration snapshot requires retired workers".into());
        }
        let owner = self
            .shared
            .configuration
            .lock()
            .map_err(|_| "configuration owner poisoned")?;
        let Some(record) = owner.as_ref() else {
            return Ok(None);
        };
        let mut b = Backend::new(self.shared.clone());
        let p = record.pointer;
        let word = |b: &mut Backend<N>, p| {
            b.word(p)
                .map_err(|e| format!("configuration snapshot: {e:?}"))
        };
        let cb = word(&mut b, p + 0xdc)?;
        let callback = if cb == 0 {
            None
        } else {
            Some([
                word(&mut b, cb)?,
                word(&mut b, cb + 4)?,
                word(&mut b, cb + 8)?,
            ])
        };
        let mut address_text = Vec::new();
        for i in 0..128 {
            let v = engine::Boundary::byte(&mut b, p + 0x18 + i)
                .map_err(|e| format!("address text: {e}"))?;
            if v == 0 {
                break;
            }
            address_text.push(v);
        }
        Ok(Some(ConfigurationSnapshot {
            pointer: p,
            return_code: record.code,
            ipv4: word(&mut b, p + 0x10)?,
            requested_port: word(&mut b, p + 0x14)? as u16,
            uid: word(&mut b, p + 0xa0)?,
            arguments: [word(&mut b, p + 0x98)?, word(&mut b, p + 0x9c)?],
            address_text,
            callback,
            host: word(&mut b, p + 8)?,
            queue_count: word(&mut b, p + 0xb8)?,
            stream: if record.derived {
                Some(StreamConfigurationSnapshot {
                    interface_pointer: p + derived::INTERFACE,
                    key_pointer: word(&mut b, p + 0xec)?,
                    flag: engine::Boundary::byte(&mut b, p + 0x108)
                        .map_err(|e| format!("stream flag: {e}"))?,
                    extra: word(&mut b, p + 0xf4)?,
                })
            } else {
                None
            },
        }))
    }
}
fn windows_address() -> address::windows::Windows {
    address::windows::Windows {
        validation_scratch: [0; 16],
    }
}
impl<N: startup::Network + Send + 'static> address::Boundary for Backend<N> {
    fn validation_byte(&mut self, i: usize, v: u8) -> Result<(), &'static str> {
        if i >= 16 {
            return Err("invalid address validation offset");
        }
        self.write_byte(native::UID_SCRATCH + 128 + i as u32, v)
            .map_err(|_| "address scratch write failed")
    }
    fn inet_addr(&mut self, text: &[u8]) -> Result<u32, &'static str> {
        address::Boundary::inet_addr(&mut windows_address(), text)
    }
    fn localhost(&mut self) -> Result<u32, &'static str> {
        address::Boundary::localhost(&mut windows_address())
    }
    fn passive_lookup(&mut self, service: &[u8]) -> Result<address::Lookup, &'static str> {
        address::Boundary::passive_lookup(&mut windows_address(), service)
    }
    fn address_to_string(
        &mut self,
        socket: &[u8; 16],
        text: &mut [u8],
        capacity: &mut u32,
    ) -> Result<u32, &'static str> {
        address::Boundary::address_to_string(&mut windows_address(), socket, text, capacity)
    }
}
#[link(name = "winmm")]
unsafe extern "system" {
    fn timeGetTime() -> u32;
}
impl<N: startup::Network + Send + 'static> derived::Boundary for Backend<N> {}
impl<N: startup::Network + Send + 'static> native::Boundary for Backend<N> {
    fn close_derived_transport(&mut self, p: u32) -> Result<(), &'static str> {
        derived::close(self, p).map_err(|e| self.failure(e, "derived configuration close failed"))
    }

    fn byte(&mut self, p: u32) -> Result<u8, &'static str> {
        engine::Boundary::byte(self, p)
    }
    fn initialize_critical_section(&mut self, p: u32) -> Result<(), &'static str> {
        engine::Boundary::initialize_critical_section(self, p)
    }
    fn delete_critical_section(&mut self, p: u32) -> Result<(), &'static str> {
        thread::Boundary::delete_critical_section(self, p)
    }
    fn mutex(&mut self, p: u32, enter: bool) -> Result<(), &'static str> {
        self.lock(p, enter)
    }
    fn initialize_transport(&mut self) -> Result<u8, &'static str> {
        thread::initialize(self).map_err(|e| self.failure(e, "configuration startup failed"))
    }
    fn drain_transport(&mut self) -> Result<(), &'static str> {
        thread::drain(self).map_err(|e| self.failure(e, "configuration drain failed"))?;
        if self.shared.active.load(Ordering::Acquire) != 0 {
            return Err("startup worker still owns runtime state");
        }
        Ok(())
    }
    fn release_transport(&mut self) -> Result<(), &'static str> {
        if self
            .word(startup::REFERENCES)
            .map_err(|_| "missing transport references")?
            == 0
        {
            return Err("no owned transport reference");
        }
        startup::release(self).map_err(|e| self.failure(e, "configuration network release failed"))
    }
    fn milliseconds(&mut self) -> Result<u32, &'static str> {
        Ok(unsafe { timeGetTime() })
    }
    fn logger(&mut self) -> Result<u32, &'static str> {
        startup::Backend::logger(self)
            .map_err(|e| self.failure(e, "configuration logger unavailable"))
    }
    fn log(&mut self, message: &str, source: Option<&str>, line: u32) -> Result<(), &'static str> {
        if self.held.last().map(|(p, _)| *p) != Some(self.shared.logger) {
            return Err("configuration logger lock is not held");
        }
        logger::write_message(
            self,
            self.shared.logger,
            message.as_bytes(),
            source.map(str::as_bytes),
            line,
        )
        .map_err(|e| self.failure(e, "configuration log failed"))
    }
    fn address_frame(&mut self) -> Result<[u8; 16], &'static str> {
        self.address_frame
            .take()
            .ok_or("missing caller address-frame storage")
    }
    fn packet_callback(&mut self, _: u32, _: u32) -> Result<(), &'static str> {
        Err("packet member callback dispatcher is not connected")
    }
    fn packet_free(&mut self, _: u32, _: u32) -> Result<(), &'static str> {
        Err("native8FCC80 packet pool deallocator is not connected")
    }
    fn flush_host(&mut self, _: u32, _: u32, _: u32) -> Result<(), &'static str> {
        Err("native9007F0 host flush is not connected")
    }
    fn reset_peer(&mut self, _: u32, _: u32) -> Result<(), &'static str> {
        Err("native8FE700 peer reset is not connected")
    }
    fn destroy_host(&mut self, _: u32) -> Result<(), &'static str> {
        Err("native8FD8A0 host destruction is not connected")
    }
}
