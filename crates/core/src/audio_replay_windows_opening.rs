//! Owning Windows stream lifetime composed with the actual transport bank.
use super::*;
use crate::{
    audio_replay_object_commands as packets, audio_replay_object_manager as manager,
    audio_replay_opening as opening, audio_replay_shared_pair as pair,
    audio_replay_stream as stream, audio_replay_stream_running as running,
    audio_replay_stream_transport as derived,
};
pub struct StreamOpenRequest<'a> {
    pub configuration: StreamConfigurationRequest<'a>,
    pub mode: u32,
}
pub(super) struct Record {
    pub(super) pointer: u32,
    code: Option<u32>,
    attempted: bool,
}
#[derive(Debug, Clone, PartialEq, Eq, serde::Serialize)]
pub struct StreamSnapshot {
    pub pointer: u32,
    pub return_code: Option<u32>,
    pub state_id: u32,
    pub implementation: [u32; 2],
    pub manager: [u32; 2],
    pub implementation_manager: [u32; 2],
    pub manager_references: u32,
    pub key_pointer: Option<u32>,
}
impl<N: startup::Network + Send + 'static> Runtime<N> {
    /// Native8F68D0 without the optional file-log preparation branch. This opens
    /// the source state/implementation/manager, not a socket or replay frame pump.
    pub fn open_stream(&self, request: StreamOpenRequest<'_>) -> Result<u32, String> {
        let closed = self
            .shared
            .launch
            .lock()
            .map_err(|_| "launch lock poisoned")?;
        if *closed {
            return Err("transport runtime is shut down".into());
        }
        self.open_stream_owned(request, 0, 0)
    }
    /// Caller holds launch for the entire operation. Recording callers must
    /// preserve native start/stop and retire the raw logger callbacks on cleanup.
    pub(super) fn open_stream_owned(
        &self,
        request: StreamOpenRequest<'_>,
        recording_path: u32,
        recording: u32,
    ) -> Result<u32, String> {
        if *self.shared.game_manager_attempted.lock().unwrap() {
            return Err("game manager lifetime excludes a standalone stream".into());
        }
        if self.shared.diagnostics.is_some() {
            return Err("stream requires the owned native logger".into());
        }
        if self.shared.active.load(Ordering::Acquire) != 0 {
            return Err("stream opening requires retired workers".into());
        }
        if self.shared.configuration.lock().unwrap().is_some() {
            return Err("standalone transport configuration already owns this runtime".into());
        }
        let mut b = Backend::new(self.shared.clone());
        if b.word(startup::STATUS)
            .map_err(|e| format!("stream status: {e:?}"))?
            == 2
            && b.word(startup::REFERENCES)
                .map_err(|e| format!("stream references: {e:?}"))?
                == 0
        {
            return Err("native transport was released but status remains2; a fresh application lifetime is required".into());
        }
        let mut owner = self
            .shared
            .stream
            .lock()
            .map_err(|_| "stream owner poisoned")?;
        if owner.as_ref().is_some_and(|r| r.attempted) {
            return Err(
                "stream opening already attempted; parent reopening lifecycle is not connected"
                    .into(),
            );
        }
        if owner.is_none() {
            let p = b
                .allocate(120)
                .map_err(|e| format!("stream allocation: {e:?}"))?;
            stream::construct(&mut b, p).map_err(|e| format!("stream construction: {e:?}"))?;
            *owner = Some(Record {
                pointer: p,
                code: None,
                attempted: false,
            });
        }
        let p = owner.as_ref().unwrap().pointer;
        let r = request.configuration;
        let t = r.transport;
        let scratch = {
            let mut bank = self.shared.bank.lock().unwrap();
            let p = bank.next_scratch;
            let next = p.checked_add(64).ok_or("stream scratch exhausted")?;
            bank.memory
                .reserve_at(p, 24)
                .map_err(|e| format!("stream scratch: {e:?}"))?;
            bank.next_scratch = next;
            p
        };
        let incoming = if let Some(cb) = t.callback {
            let q = b
                .allocate(12)
                .map_err(|e| format!("stream callback: {e:?}"))?;
            for (o, v) in [
                (0, callbacks::HANDLER_VTABLE),
                (4, cb.owner),
                (8, cb.member),
            ] {
                Storage::write_word(&mut b, q + o, v)
                    .map_err(|e| format!("stream callback initialization: {e:?}"))?;
            }
            q
        } else {
            0
        };
        owner.as_mut().unwrap().attempted = true;
        b.address_frame = Some(t.sockaddr_frame);
        let result = opening::open(
            &mut b,
            p,
            opening::Request {
                callback: incoming,
                arguments: t.arguments,
                key: &r.key,
                host: t.host,
                port: t.port,
                mode: request.mode,
                flag: r.flag,
                extra: r.extra,
                recording_path,
                recording,
            },
            scratch,
        );
        owner.as_mut().unwrap().code = result.as_ref().ok().copied();
        let cleanup = self.shared.bank.lock().unwrap().memory.release(scratch);
        match (result, cleanup) {
            (Ok(v), Ok(())) => Ok(v),
            (result, cleanup) => Err(format!(
                "stream opening: {result:?}; scratch cleanup: {cleanup:?}"
            )),
        }
    }
    /// Source no-op implementation start is available. Active ENet creation and
    /// connection must be supplied before starting the derived implementation.
    pub fn start_stream(&self, args: [u32; 6]) -> Result<u32, String> {
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
            .stream
            .lock()
            .map_err(|_| "stream owner poisoned")?;
        let p = owner.as_ref().ok_or("no open stream")?.pointer;
        let mut b = Backend::new(self.shared.clone());
        if !running::has_state(&mut b, p, 3).map_err(|e| format!("stream state: {e:?}"))? {
            return Ok(8);
        }
        let object = b
            .word(p + 0x64)
            .map_err(|e| format!("stream implementation: {e:?}"))?;
        if b.word(object)
            .map_err(|e| format!("implementation vtable: {e:?}"))?
            != opening::NULL_VTABLE
        {
            return Err("native active replay host creation/connection is not connected".into());
        }
        running::start(&mut b, p, args).map_err(|e| format!("stream start: {e:?}"))
    }
    pub fn stop_stream(&self) -> Result<(), String> {
        let closed = self
            .shared
            .launch
            .lock()
            .map_err(|_| "launch lock poisoned")?;
        if *closed {
            return Ok(());
        }
        let owner = self
            .shared
            .stream
            .lock()
            .map_err(|_| "stream owner poisoned")?;
        if let Some(r) = owner.as_ref() {
            let mut b = Backend::new(self.shared.clone());
            stream::stop(&mut b, r.pointer).map_err(|e| format!("stream stop: {e:?}"))?;
        }
        if self.shared.active.load(Ordering::Acquire) != 0 {
            return Err("stream worker did not retire after stop".into());
        }
        Ok(())
    }
    pub fn close_stream(&self) -> Result<(), String> {
        let closed = self
            .shared
            .launch
            .lock()
            .map_err(|_| "launch lock poisoned")?;
        if *closed {
            return Ok(());
        }
        let mut b = Backend::new(self.shared.clone());
        thread::drain(&mut b).map_err(|e| format!("stream drain: {e:?}"))?;
        self.close_stream_owned(&mut b)
    }
    pub(super) fn close_stream_owned(&self, b: &mut Backend<N>) -> Result<(), String> {
        let mut owner = self
            .shared
            .stream
            .lock()
            .map_err(|_| "stream owner poisoned")?;
        let Some(record) = owner.as_ref() else {
            return Ok(());
        };
        stream::stop(b, record.pointer)
            .map_err(|e| format!("stream stop before destruction: {e:?}"))?;
        if self.shared.active.load(Ordering::Acquire) != 0 {
            return Err("stream cleanup requires retired workers".into());
        }
        stream::scalar_delete(b, record.pointer, 1)
            .map_err(|e| format!("stream destruction: {e:?}"))?;
        *owner = None;
        Ok(())
    }
    pub fn stream_snapshot(&self) -> Result<Option<StreamSnapshot>, String> {
        let _launch = self
            .shared
            .launch
            .lock()
            .map_err(|_| "launch lock poisoned")?;
        if self.shared.active.load(Ordering::Acquire) != 0 {
            return Err("stream snapshot requires retired workers".into());
        }
        let owner = self
            .shared
            .stream
            .lock()
            .map_err(|_| "stream owner poisoned")?;
        let Some(r) = owner.as_ref() else {
            return Ok(None);
        };
        let mut b = Backend::new(self.shared.clone());
        let mut w = |p| b.word(p).map_err(|e| format!("stream snapshot: {e:?}"));
        let p = r.pointer;
        let current = w(p + 0x44)?;
        let implementation = [w(p + 0x64)?, w(p + 0x68)?];
        let manager = [w(p + 0x6c)?, w(p + 0x70)?];
        let (implementation_manager, key_pointer) = if implementation[0] == 0 {
            ([0, 0], None)
        } else {
            let q = implementation[0];
            let vt = w(q)?;
            match vt {
                derived::INTERFACE_VTABLE => ([w(q + 4)?, w(q + 8)?], Some(w(q + 12)?)),
                opening::NULL_VTABLE => ([w(q + 8)?, w(q + 12)?], None),
                _ => return Err("unknown stream implementation vtable".into()),
            }
        };
        Ok(Some(StreamSnapshot {
            pointer: p,
            return_code: r.code,
            state_id: if current == 0 {
                u32::MAX
            } else {
                w(current + 12)?
            },
            implementation,
            manager,
            implementation_manager,
            manager_references: if manager[1] == 0 {
                0
            } else {
                w(manager[1] + 4)?
            },
            key_pointer,
        }))
    }
}
impl<N: startup::Network + Send + 'static> pair::Boundary for Backend<N> {
    fn increment_reference(&mut self, p: u32) -> Result<u32, &'static str> {
        self.mutate(p, |v| v.wrapping_add(1))
    }
}
impl<N: startup::Network + Send + 'static> manager::Boundary for Backend<N> {
    fn read_byte(&mut self, p: u32) -> Result<u8, read::Error> {
        self.shared
            .bank
            .lock()
            .unwrap()
            .memory
            .read_byte(p)
            .map_err(|_| read::Error::MissingWord(p))
    }
    fn initialize_lock(&mut self, p: u32) -> Result<(), &'static str> {
        engine::Boundary::initialize_critical_section(self, p + 8)
    }
    fn destroy_lock(&mut self, p: u32) -> Result<(), &'static str> {
        thread::Boundary::delete_critical_section(self, p + 8)
    }
    fn enter_lock(&mut self, p: u32) -> Result<(), &'static str> {
        self.lock(p, true)
    }
    fn leave_lock(&mut self, p: u32) -> Result<(), &'static str> {
        self.lock(p, false)
    }
    fn object_id(&mut self, p: u32, f: u32) -> Result<u32, &'static str> {
        if f != packets::PACKET_ID {
            return Err("unknown replay packet ID method");
        }
        packets::packet_id(self, p).map_err(|e| self.failure(e, "packet ID failed"))
    }
    fn object_value(&mut self, p: u32, f: u32) -> Result<u64, &'static str> {
        if f != packets::PACKET_VALUE {
            return Err("unknown replay packet value method");
        }
        packets::packet_value(self, p).map_err(|e| self.failure(e, "packet value failed"))
    }
}
impl<N: startup::Network + Send + 'static> stream::Boundary for Backend<N> {
    fn close_resource(&mut self, p: u32) -> Result<(), &'static str> {
        crate::audio_replay_recording_resource::close(self, p)
            .map(|_| ())
            .map_err(|e| self.failure(e, "stream file close failed"))
    }

    fn join_worker(&mut self, worker: u32, timeout: u32) -> Result<(), &'static str> {
        //8FB620 ignores8A8C50's numeric return. The owning API separately guards
        //against freeing storage still used by a worker after a failed/timed wait.
        thread::join(self, worker, timeout)
            .map(|_| ())
            .map_err(|e| self.failure(e, "stream worker join failed"))
    }
    fn stop_implementation(&mut self, object: u32, method: u32) -> Result<(), &'static str> {
        match method {
            0x5642d0 => Ok(()),
            0x901c44 => derived::close(
                self,
                object.checked_sub(0xe0).ok_or("invalid stream interface")?,
            )
            .map_err(|e| self.failure(e, "derived stream stop failed")),
            _ => Err("unknown stream stop method"),
        }
    }
}
impl<N: startup::Network + Send + 'static> running::Boundary for Backend<N> {
    fn launch_stream_worker(&mut self, launch: &thread::Launch) -> Result<u32, &'static str> {
        thread::Boundary::create_worker(self, launch)
    }
    fn sleep(&mut self, milliseconds: u32) -> Result<(), &'static str> {
        std::thread::sleep(std::time::Duration::from_millis(milliseconds.into()));
        Ok(())
    }
}
impl<N: startup::Network + Send + 'static> opening::Boundary for Backend<N> {
    fn prepare_recording(&mut self, p: u32, path: u32) -> Result<bool, &'static str> {
        let scratch = self.recording_scratch(16)?;
        let result = crate::audio_replay_recording_resource::prepare(self, p, path, scratch);
        let cleanup = self.shared.bank.lock().unwrap().memory.release(scratch);
        match (result, cleanup) {
            (Ok(v), Ok(())) => Ok(v),
            (a, b) => Err(self.failure((a, b), "stream file preparation failed")),
        }
    }
}
impl<N: startup::Network + Send + 'static> control::ObjectBoundary for Backend<N> {
    fn scalar_delete_object(&mut self, p: u32, f: u32, flags: u32) -> Result<(), &'static str> {
        match f {
            callbacks::HANDLER_DELETE => {
                crate::audio_replay_callbacks::scalar_delete(self, p, flags)
                    .map(|_| ())
                    .map_err(|e| self.failure(e, "callback destruction failed"))
            }
            crate::audio_replay_metadata::SCALAR_DELETE => {
                crate::audio_replay_metadata::scalar_delete(self, p, flags)
                    .map(|_| ())
                    .map_err(|e| self.failure(e, "parent metadata destruction failed"))
            }
            opening::NULL_DELETE => opening::scalar_delete_null(self, p, flags)
                .map(|_| ())
                .map_err(|e| self.failure(e, "null implementation destruction failed")),
            packets::PACKET_DELETE => packets::delete_packet(self, p, flags)
                .map(|_| ())
                .map_err(|e| self.failure(e, "packet destruction failed")),
            _ => Err("unknown replay shared object scalar deletion"),
        }
    }
}
