//! Shared Windows runtime underneath the recovered transport launch/worker ports.
//! The caller supplies the native global image. The logger can be externally
//! owned or lazily constructed and destroyed through the original native ports.
use crate::{
    audio_announcer_object_lookup as read,
    audio_announcer_owner_component_destructor::ControlBoundary,
    audio_announcer_owner_control as control, audio_announcer_owner_metadata as callbacks,
    audio_announcer_registry_init as init, audio_announcer_registry_remove as remove,
    audio_crt_windows_critical_sections as cs, audio_crt_windows_engine_worker as crt,
    audio_crt_windows_worker_thread as os, audio_replay_engine_thread as engine,
    audio_replay_logger as logger, audio_replay_transport_startup as startup,
    audio_replay_transport_thread as thread,
};
use init::Storage;
use read::Memory;
use std::{
    collections::{BTreeMap, BTreeSet},
    ffi::CString,
    sync::{
        atomic::{AtomicUsize, Ordering},
        Arc, Mutex,
    },
};
#[link(name = "kernel32")]
unsafe extern "system" {
    fn GetCurrentThreadId() -> u32;
    fn WaitForSingleObject(handle: *mut std::ffi::c_void, ms: u32) -> u32;
    fn GetLastError() -> u32;
}
#[path = "audio_replay_windows_clock_host.rs"]
mod clock_host;
#[path = "audio_replay_windows_clock.rs"]
mod process_clock;
pub use clock_host::ProcessClockSnapshot;
pub use process_clock::ClockHandle;
#[path = "audio_replay_windows_configuration.rs"]
mod configuration;
#[path = "audio_replay_windows_events.rs"]
mod events;
#[path = "audio_replay_windows_game_manager.rs"]
mod game_manager;
#[path = "audio_replay_windows_loading_metadata.rs"]
mod loading_metadata;
#[path = "audio_replay_windows_loading.rs"]
mod loading_owner;
#[path = "audio_replay_windows_loading_packets.rs"]
mod loading_packets;
#[path = "audio_replay_windows_loading_retirement.rs"]
mod loading_retirement;
#[path = "audio_replay_windows_opening.rs"]
mod opening;
#[path = "audio_replay_windows_receive.rs"]
mod receive;
#[path = "audio_replay_windows_recording.rs"]
mod recording;
#[path = "audio_replay_windows_service.rs"]
mod service_owner;
pub use configuration::{
    ConfigurationCallback, ConfigurationRequest, ConfigurationSnapshot, StreamConfigurationRequest,
    StreamConfigurationSnapshot,
};
pub use game_manager::{GameManagerSnapshot, GameReplayRequest};
pub use opening::{StreamOpenRequest, StreamSnapshot};
pub use recording::{RecordingFileProbe, RecordingStreamProbe};
pub use service_owner::ServiceHandle;

pub trait Diagnostics: Send + Sync + 'static {
    /// Receives the native formatted transport message while its logger mutex is
    /// held. The supplied logger's timestamp/file/virtual-callback layer owns output.
    fn emit(&self, message: &str) -> Result<(), &'static str>;
}
struct Bank {
    memory: init::OwnedMemory,
    next_scratch: u32,
    event_scratch: BTreeMap<u32, Vec<u32>>,
    owned: BTreeSet<u32>,
}
struct Shared<N> {
    bank: Mutex<Bank>,
    clock: Mutex<clock_host::HostState>,
    locks: Mutex<cs::Bank>,
    handles: Mutex<BTreeMap<u32, Arc<Mutex<os::Thread>>>>,
    network: Mutex<N>,
    bridge: Arc<crt::Bridge>,
    logger: u32,
    diagnostics: Option<Arc<dyn Diagnostics>>,
    logger_init: Mutex<()>,
    configuration: Mutex<Option<configuration::Record>>,
    stream: Mutex<Option<opening::Record>>,
    files: Mutex<recording::Files>,
    service: Mutex<Option<service_owner::Record>>,
    service_settings: Mutex<Option<Box<dyn crate::audio_game_service_lifecycle::Settings + Send>>>,
    game_manager: Mutex<Option<game_manager::Record>>,
    game_manager_attempted: Mutex<bool>,
    loading_retirements: Mutex<loading_retirement::Ledger<N>>,
    launch: Mutex<bool>,
    active: AtomicUsize,
    errors: Mutex<Vec<String>>,
}
pub struct Runtime<N: startup::Network + Send + 'static> {
    shared: Arc<Shared<N>>,
}
#[derive(Debug, PartialEq, Eq)]
pub struct Snapshot {
    pub status: u32,
    pub references: u32,
    pub pair: [u32; 2],
    pub counters: [u32; 5],
    pub engine_allocations: usize,
    pub handles: usize,
    pub active_workers: usize,
    pub critical_sections: usize,
}
#[derive(Debug, PartialEq, Eq)]
pub struct LoggerSnapshot {
    pub pointer: u32,
    pub flags: [u8; 2],
    pub callback: Option<[u32; 3]>,
    pub shutdown_registrations: Vec<u32>,
    pub last_message: Vec<u8>,
}
impl<N: startup::Network + Send + 'static> Runtime<N> {
    /// Own a fresh transport instance, with reference count0, empty thread pair,
    /// original control vtable, and existing native logger/global mutex banks.
    /// Physical CS objects are attached to the supplied canonical storage labels.
    pub fn new(
        bridge: Arc<crt::Bridge>,
        memory: init::OwnedMemory,
        network: N,
        logger: u32,
        diagnostics: Arc<dyn Diagnostics>,
        first_scratch: u32,
    ) -> Result<Self, String> {
        Self::attach(
            bridge,
            memory,
            network,
            logger,
            Some(diagnostics),
            first_scratch,
        )
    }
    /// Supply actual initial global storage, including logger flags, static
    /// storage, callback vtable and output buffer. Fixture JSON is not loaded.
    /// The original default callback has no output. A configured nondefault
    /// callback requires an explicit dispatcher before it can be used.
    pub fn new_with_native_logger(
        bridge: Arc<crt::Bridge>,
        memory: init::OwnedMemory,
        network: N,
        first_scratch: u32,
    ) -> Result<Self, String> {
        Self::attach(bridge, memory, network, logger::LOGGER, None, first_scratch)
    }
    fn attach(
        bridge: Arc<crt::Bridge>,
        mut memory: init::OwnedMemory,
        network: N,
        logger: u32,
        diagnostics: Option<Arc<dyn Diagnostics>>,
        first_scratch: u32,
    ) -> Result<Self, String> {
        let word = |m: &mut init::OwnedMemory, p| {
            m.word(p)
                .map_err(|e| format!("transport global bank: {e:?}"))
        };
        if first_scratch == 0
            || first_scratch.checked_add(64).is_none()
            || logger == 0
            || logger.checked_add(32).is_none()
        {
            return Err("invalid runtime scratch/logger label".into());
        }
        if word(&mut memory, startup::REFERENCES)? != 0
            || word(&mut memory, thread::PAIR)? != 0
            || word(&mut memory, thread::PAIR + 4)? != 0
        {
            return Err("runtime cannot adopt external transport references or threads".into());
        }
        let native = diagnostics.is_none();
        if native {
            if word(&mut memory, logger::POINTER)? != 0 {
                return Err("native logger is already externally owned".into());
            }
            for (p, len) in [
                (logger::REINITIALIZE, 2),
                (logger::LOGGER, 36),
                (logger::BUFFER, logger::CAPACITY as u32),
            ] {
                for i in 0..len {
                    memory
                        .read_byte(p + i)
                        .map_err(|_| "missing native logger bank")?;
                }
            }
            for (offset, expected) in [
                (0, callbacks::HANDLER_DELETE),
                (4, callbacks::HANDLER_CLONE),
                (8, logger::INVOKE),
            ] {
                if word(&mut memory, callbacks::HANDLER_VTABLE + offset)? != expected {
                    return Err("unrecognized native logger callback vtable".into());
                }
            }
        } else if word(&mut memory, logger::POINTER)? != logger {
            return Err("external logger must already be constructed by its owner".into());
        }
        for p in [startup::STATUS, startup::ALLOCATOR, startup::DEALLOCATOR]
            .into_iter()
            .chain(startup::COUNTERS)
        {
            word(&mut memory, p)?;
        }
        for (offset, expected) in [
            (0, thread::DISPOSE),
            (4, control::RELEASE),
            (8, control::SCALAR_DELETE),
        ] {
            if word(&mut memory, thread::CONTROL_VTABLE + offset)? != expected {
                return Err("unrecognized native thread control vtable".into());
            }
        }
        let mut locks = cs::Bank::default();
        for p in std::iter::once(startup::MUTEX).chain((!native).then_some(logger)) {
            memory
                .read_byte(p)
                .map_err(|_| "missing native mutex flags")?;
            if word(&mut memory, p + 4)? != 0 {
                return Err("cannot adopt an already-owned native mutex".into());
            }
            for i in 0..24 {
                memory
                    .read_byte(p + 8 + i)
                    .map_err(|_| "missing native critical-section bank")?;
            }
            locks
                .initialize(p + 8, 0, None)
                .map_err(|e| format!("runtime critical section: {e:?}"))?;
        }
        Ok(Self {
            shared: Arc::new(Shared {
                bank: Mutex::new(Bank {
                    memory,
                    next_scratch: first_scratch,
                    event_scratch: BTreeMap::new(),
                    owned: BTreeSet::new(),
                }),
                clock: Mutex::new(clock_host::HostState::default()),
                locks: Mutex::new(locks),
                handles: Mutex::new(BTreeMap::new()),
                network: Mutex::new(network),
                bridge,
                logger,
                diagnostics,
                logger_init: Mutex::new(()),
                configuration: Mutex::new(None),
                stream: Mutex::new(None),
                files: Mutex::new(recording::Files::default()),
                service: Mutex::new(None),
                service_settings: Mutex::new(None),
                game_manager: Mutex::new(None),
                game_manager_attempted: Mutex::new(false),
                loading_retirements: Mutex::new(loading_retirement::Ledger::default()),
                launch: Mutex::new(false),
                active: AtomicUsize::new(0),
                errors: Mutex::new(vec![]),
            }),
        })
    }
    pub fn initialize(&self) -> Result<u8, String> {
        let closed = self
            .shared
            .launch
            .lock()
            .map_err(|_| "launch lock poisoned")?;
        if *closed {
            return Err("transport runtime is shut down".into());
        }
        thread::initialize(&mut Backend::new(self.shared.clone()))
            .map_err(|e| format!("transport launch: {e:?}"))
    }
    pub fn release(&self) -> Result<(), String> {
        let closed = self
            .shared
            .launch
            .lock()
            .map_err(|_| "launch lock poisoned")?;
        if *closed {
            return Err("transport runtime is shut down".into());
        }
        if self.shared.stream.lock().unwrap().is_some() {
            return Err("close the owned stream before releasing transport".into());
        }
        if self.shared.configuration.lock().unwrap().is_some() {
            return Err("close the owned configuration before releasing transport".into());
        }
        self.release_owned()
    }
    fn release_owned(&self) -> Result<(), String> {
        if self.shared.active.load(Ordering::Acquire) != 0 {
            return Err("transport worker is still active".into());
        }
        let mut b = Backend::new(self.shared.clone());
        if b.word(startup::REFERENCES)
            .map_err(|e| format!("references: {e:?}"))?
            == 0
        {
            return Err("no owned global transport reference to release".into());
        }
        startup::release(&mut b).map_err(|e| format!("transport release: {e:?}"))
    }
    /// Source drain may time out and close its handle while a worker survives.
    /// Keep the shared banks alive and report pending work instead of deleting
    /// its locks or pretending a timed-out worker has stopped.
    pub fn shutdown(&self) -> Result<(), String> {
        let mut closed = self
            .shared
            .launch
            .lock()
            .map_err(|_| "launch lock poisoned")?;
        if *closed {
            return Ok(());
        }
        let mut b = Backend::new(self.shared.clone());
        thread::drain(&mut b).map_err(|e| format!("transport drain: {e:?}"))?;
        // Retained name descriptors must outlive failed String24 cleanup and
        // retire before their service/metadata/CRT bank can be destroyed.
        b.retire_loading_temporaries().map_err(str::to_string)?;
        self.close_game_manager_owned(&mut b)?;
        self.close_service_owned(&mut b)?;
        self.close_stream_owned(&mut b)?;
        if self.shared.active.load(Ordering::Acquire) != 0 {
            return Err("transport worker still owns runtime state after drain".into());
        }
        self.close_configuration_owned(&mut b)?;
        let references = b
            .word(startup::REFERENCES)
            .map_err(|e| format!("references: {e:?}"))?;
        if references > 1 {
            return Err("multiple transport reference owners require explicit release".into());
        }
        if references == 1 {
            self.release_owned()?;
        }
        //8FC480 intentionally leaves a failed-creation null-object control. Its
        // enclosing lifetime still owns it; release that pair on final shutdown.
        crate::audio_replay_shared_pair::destroy(&mut b, thread::PAIR)
            .map_err(|e| format!("final thread control: {e:?}"))?;
        Storage::write_word(&mut b, thread::PAIR, 0).map_err(|e| format!("final pair: {e:?}"))?;
        Storage::write_word(&mut b, thread::PAIR + 4, 0)
            .map_err(|e| format!("final pair: {e:?}"))?;
        if !self.shared.handles.lock().unwrap().is_empty() {
            return Err("started worker handle remains outside the published pair".into());
        }
        if self.shared.diagnostics.is_none()
            && b.word(logger::POINTER)
                .map_err(|e| format!("logger pointer: {e:?}"))?
                != 0
        {
            logger::shutdown(&mut b).map_err(|e| format!("native logger shutdown: {e:?}"))?;
        }
        // Only an actually initialized source singleton owns its tree sentinel.
        // Older externally supplied transport banks need not contain this region.
        if self
            .shared
            .bank
            .lock()
            .unwrap()
            .memory
            .word(crate::audio_replay_path_registry::FLAG)
            .ok()
            .is_some_and(|v| v & 1 != 0)
        {
            crate::audio_replay_path_registry::shutdown(&mut b)
                .map_err(|e| format!("path registry shutdown: {e:?}"))?;
        }
        b.shutdown_process_clock()?;
        if !self.shared.bank.lock().unwrap().owned.is_empty() {
            return Err("engine allocations remain live at shutdown".into());
        }
        *closed = true;
        Ok(())
    }
    pub fn snapshot(&self) -> Result<Snapshot, String> {
        let mut b = self
            .shared
            .bank
            .lock()
            .map_err(|_| "engine bank poisoned")?;
        let mut word = |p| b.memory.word(p).map_err(|e| format!("snapshot: {e:?}"));
        let status = word(startup::STATUS)?;
        let references = word(startup::REFERENCES)?;
        let pair = [word(thread::PAIR)?, word(thread::PAIR + 4)?];
        let mut counters = [0; 5];
        for (i, p) in startup::COUNTERS.into_iter().enumerate() {
            counters[i] = word(p)?;
        }
        let engine_allocations = b.owned.len();
        drop(b);
        Ok(Snapshot {
            status,
            references,
            pair,
            counters,
            engine_allocations,
            handles: self.shared.handles.lock().unwrap().len(),
            active_workers: self.shared.active.load(Ordering::Acquire),
            critical_sections: self.shared.locks.lock().unwrap().len(),
        })
    }
    pub fn inspect_network<T>(&self, read: impl FnOnce(&N) -> T) -> T {
        read(&self.shared.network.lock().unwrap())
    }
    pub fn logger_snapshot(&self) -> Result<LoggerSnapshot, String> {
        if self.shared.diagnostics.is_some() {
            return Err("external logger storage is owned by its caller".into());
        }
        let _launch = self
            .shared
            .launch
            .lock()
            .map_err(|_| "launch lock poisoned")?;
        if self.shared.active.load(Ordering::Acquire) != 0 {
            return Err("logger snapshot requires retired workers".into());
        }
        let mut b = self
            .shared
            .bank
            .lock()
            .map_err(|_| "engine bank poisoned")?;
        let m = &mut b.memory;
        let pointer = m
            .word(logger::POINTER)
            .map_err(|e| format!("logger pointer: {e:?}"))?;
        let flags = [
            m.read_byte(logger::REINITIALIZE)
                .map_err(|_| "missing logger flag")?,
            m.read_byte(logger::REGISTERED)
                .map_err(|_| "missing logger flag")?,
        ];
        let callback = if pointer == 0 {
            None
        } else {
            let p = m
                .word(pointer + 32)
                .map_err(|_| "missing logger callback")?;
            if p == 0 {
                None
            } else {
                Some([
                    m.word(p).map_err(|_| "missing callback vtable")?,
                    m.word(p + 4).map_err(|_| "missing callback owner")?,
                    m.word(p + 8).map_err(|_| "missing callback member")?,
                ])
            }
        };
        let mut last_message = Vec::new();
        for i in 0..logger::CAPACITY {
            let v = m
                .read_byte(logger::BUFFER + i as u32)
                .map_err(|_| "missing logger buffer")?;
            if v == 0 {
                break;
            }
            last_message.push(v);
        }
        Ok(LoggerSnapshot {
            pointer,
            flags,
            callback,
            shutdown_registrations: m.shutdown_callbacks.clone(),
            last_message,
        })
    }
    pub fn errors(&self) -> Vec<String> {
        self.shared.errors.lock().unwrap().clone()
    }
    pub fn critical_section_report(&self) -> Arc<cs::Report> {
        self.shared.locks.lock().unwrap().report()
    }
}
struct Active<N> {
    shared: Arc<Shared<N>>,
}
impl<N> Drop for Active<N> {
    fn drop(&mut self) {
        self.shared.active.fetch_sub(1, Ordering::AcqRel);
    }
}
struct Backend<N> {
    shared: Arc<Shared<N>>,
    held: Vec<(u32, cs::Guard)>,
    last: u32,
    address_frame: Option<[u8; 16]>,
}
impl<N: startup::Network + Send + 'static> Backend<N> {
    fn new(shared: Arc<Shared<N>>) -> Self {
        Self {
            shared,
            held: vec![],
            last: 0,
            address_frame: None,
        }
    }
    fn failure(&self, error: impl std::fmt::Debug, message: &'static str) -> &'static str {
        self.shared
            .errors
            .lock()
            .unwrap()
            .push(format!("{message}: {error:?}"));
        message
    }
    fn mutate(&self, p: u32, f: impl FnOnce(u32) -> u32) -> Result<u32, &'static str> {
        let mut bank = self
            .shared
            .bank
            .lock()
            .map_err(|_| "engine bank poisoned")?;
        let old = bank.memory.word(p).map_err(|_| "missing atomic word")?;
        bank.memory
            .write_word(p, f(old))
            .map_err(|_| "atomic word write failed")?;
        Ok(old)
    }
    fn lock(&mut self, p: u32, enter: bool) -> Result<(), &'static str> {
        let tid = unsafe { GetCurrentThreadId() };
        let recursive = self
            .shared
            .bank
            .lock()
            .unwrap()
            .memory
            .read_byte(p)
            .map_err(|_| "missing mutex flag")?
            != 0;
        if enter {
            if !recursive && self.word(p + 4).map_err(|_| "missing mutex owner")? == tid {
                return Err("native nonrecursive mutex re-entry");
            }
            let section = self
                .shared
                .locks
                .lock()
                .unwrap()
                .section(p + 8)
                .map_err(|e| self.failure(e, "missing critical section"))?;
            // Never hold the bank/map mutex while Windows waits on this lock.
            let guard = section.enter();
            if !recursive {
                Storage::write_word(self, p + 4, tid)
                    .map_err(|_| "mutex owner publication failed")?;
            }
            self.held.push((p, guard));
        } else {
            if self.held.last().map(|(a, _)| *a) != Some(p) {
                return Err("mutex release order mismatch");
            }
            if !recursive {
                if self.word(p + 4).map_err(|_| "missing mutex owner")? != tid {
                    return Err("native mutex owned by another thread");
                }
                self.mutate(p + 4, |_| 0)?;
            }
            drop(self.held.pop());
        }
        Ok(())
    }
    fn options(&mut self, launch: &thread::Launch) -> Result<u32, String> {
        let p = {
            let mut bank = self.shared.bank.lock().unwrap();
            let p = bank.next_scratch;
            let next = p.checked_add(64).ok_or("scratch exhausted")?;
            bank.memory
                .reserve_at(p, 40)
                .map_err(|e| format!("option scratch: {e:?}"))?;
            bank.next_scratch = next;
            p
        };
        let result = (|| {
            for (i, v) in launch.tag.into_iter().enumerate() {
                self.write_byte(p + i as u32, v)
                    .map_err(|e| format!("tag: {e:?}"))?;
            }
            engine::initialize_name(self, p + 16)
                .map_err(|e| format!("name initialization: {e:?}"))?;
            let len = u32::try_from(launch.name.len()).map_err(|_| "thread name too long")?;
            let data = if len > 15 {
                let capacity = len | 15;
                let size = capacity
                    .checked_add(1)
                    .ok_or("thread name allocation overflow")?;
                let data = self
                    .allocate(size)
                    .map_err(|e| format!("name allocation: {e:?}"))?;
                Storage::write_word(self, p + 16, data)
                    .map_err(|e| format!("name pointer: {e:?}"))?;
                Storage::write_word(self, p + 36, capacity)
                    .map_err(|e| format!("name capacity: {e:?}"))?;
                data
            } else {
                p + 16
            };
            for (i, v) in launch
                .name
                .iter()
                .copied()
                .chain(std::iter::once(0))
                .enumerate()
            {
                self.write_byte(data + i as u32, v)
                    .map_err(|e| format!("name byte: {e:?}"))?;
            }
            Storage::write_word(self, p + 32, len).map_err(|e| format!("name length: {e:?}"))?;
            Ok(p)
        })();
        if result.is_err() {
            let _ = engine::destroy_name(self, p + 16);
            let _ = self.shared.bank.lock().unwrap().memory.release(p);
        }
        result
    }
}
impl<N: startup::Network + Send + 'static> Memory for Backend<N> {
    fn word(&mut self, p: u32) -> Result<u32, read::Error> {
        self.shared
            .bank
            .lock()
            .map_err(|_| read::Error::InvalidLayout)?
            .memory
            .word(p)
    }
}
impl<N: startup::Network + Send + 'static> Storage for Backend<N> {
    fn allocate(&mut self, n: u32) -> Result<u32, init::Error> {
        let mut bank = self
            .shared
            .bank
            .lock()
            .map_err(|_| init::Error::Backend("engine bank poisoned"))?;
        let p = bank.memory.allocate(n)?;
        bank.owned.insert(p);
        Ok(p)
    }
    fn write_word(&mut self, p: u32, v: u32) -> Result<(), init::Error> {
        self.shared
            .bank
            .lock()
            .map_err(|_| init::Error::Backend("engine bank poisoned"))?
            .memory
            .write_word(p, v)
    }
    fn write_byte(&mut self, p: u32, v: u8) -> Result<(), init::Error> {
        self.shared
            .bank
            .lock()
            .map_err(|_| init::Error::Backend("engine bank poisoned"))?
            .memory
            .write_byte(p, v)
    }
    fn register_shutdown(&mut self, callback: u32) -> Result<(), init::Error> {
        if self.shared.diagnostics.is_some()
            || ![
                logger::SHUTDOWN,
                crate::audio_replay_path_registry::SHUTDOWN,
                crate::audio_replay_game_manager::SHUTDOWN,
            ]
            .contains(&callback)
        {
            return Err(init::Error::Backend(
                "shutdown callback has no runtime owner",
            ));
        }
        self.shared
            .bank
            .lock()
            .map_err(|_| init::Error::Backend("engine bank poisoned"))?
            .memory
            .register_shutdown(callback)
    }
}
impl<N: startup::Network + Send + 'static> remove::Backend for Backend<N> {
    fn write_word(&mut self, p: u32, v: u32) -> Result<(), remove::Error> {
        Storage::write_word(self, p, v).map_err(remove::Error::Owned)
    }
    fn deallocator(&mut self) -> Result<remove::Deallocator, remove::Error> {
        Ok(remove::Deallocator::Standard)
    }
    fn free(&mut self, p: u32, route: remove::Deallocator) -> Result<(), remove::Error> {
        if !matches!(route, remove::Deallocator::Standard) {
            return Err(remove::Error::Owned(init::Error::Backend(
                "custom deallocator is not attached",
            )));
        }
        if p == 0 {
            return Ok(());
        }
        let mut bank = self.shared.bank.lock().unwrap();
        if !bank.owned.contains(&p) {
            return Err(remove::Error::Owned(init::Error::Backend(
                "engine does not own allocation",
            )));
        }
        bank.memory.release(p).map_err(remove::Error::Owned)?;
        bank.owned.remove(&p);
        Ok(())
    }
}
impl<N: startup::Network + Send + 'static> ControlBoundary for Backend<N> {
    fn decrement_reference(&mut self, p: u32) -> Result<u32, &'static str> {
        self.mutate(p, |v| v.wrapping_sub(1))
    }
    fn dispose(&mut self, p: u32, f: u32) -> Result<(), &'static str> {
        if f == crate::audio_replay_loading_owner::WRAPPER_DISPOSE {
            return crate::audio_replay_loading_owner::dispose_wrapper(self, p)
                .map_err(|e| self.failure(e, "loading wrapper disposal failed"));
        }
        if f == crate::audio_replay_loading_owner::RECIPIENT_DISPOSE {
            return crate::audio_replay_loading_owner::dispose_recipient(self, p)
                .map_err(|e| self.failure(e, "loading recipient disposal failed"));
        }
        if f == crate::audio_replay_recording_resource::CONTROL_DISPOSE {
            return crate::audio_replay_recording_resource::dispose_control(self, p)
                .map_err(|e| self.failure(e, "recording control disposal failed"));
        }

        if f == crate::audio_replay_stream_transport::CONTROL_DISPOSE {
            return crate::audio_replay_stream_transport::dispose_control(self, p)
                .map_err(|e| self.failure(e, "stream control disposal failed"));
        }
        if f == crate::audio_replay_manager_control::DISPOSE {
            return crate::audio_replay_manager_control::dispose(self, p)
                .map_err(|e| self.failure(e, "manager control disposal failed"));
        }
        if f == control::DISPOSE {
            return control::dispose(self, p)
                .map_err(|e| self.failure(e, "shared object disposal failed"));
        }
        if f != thread::DISPOSE {
            return Err("unknown thread control disposal");
        }
        thread::dispose(self, p).map_err(|e| self.failure(e, "thread disposal failed"))
    }
    fn release_control(&mut self, p: u32, f: u32) -> Result<(), &'static str> {
        if f != control::RELEASE {
            return Err("unknown thread control release");
        }
        control::release(self, p).map_err(|e| self.failure(e, "thread control deletion failed"))
    }
}
impl<N: startup::Network + Send + 'static> thread::Boundary for Backend<N> {
    fn current_thread_id(&mut self) -> Result<u32, &'static str> {
        Ok(unsafe { GetCurrentThreadId() })
    }
    fn wait_handle(&mut self, h: u32, ms: u32) -> Result<u32, &'static str> {
        if h == 0 {
            let result = unsafe { WaitForSingleObject(std::ptr::null_mut(), ms) };
            self.last = unsafe { GetLastError() };
            return Ok(result);
        }
        let t = self
            .shared
            .handles
            .lock()
            .unwrap()
            .get(&h)
            .cloned()
            .ok_or("unknown canonical thread handle")?;
        let result = t.lock().unwrap().wait_only(ms);
        match result {
            Ok(true) => Ok(0),
            Ok(false) => Ok(258),
            Err(os::Failure::Windows { code, .. }) => {
                self.last = code;
                Ok(u32::MAX)
            }
            Err(os::Failure::UnexpectedWait(v)) => Ok(v),
            Err(e) => Err(self.failure(e, "thread wait adapter failed")),
        }
    }
    fn close_handle(&mut self, h: u32) -> Result<u32, &'static str> {
        let t = self
            .shared
            .handles
            .lock()
            .unwrap()
            .get(&h)
            .cloned()
            .ok_or("unknown canonical thread handle")?;
        let result = t.lock().unwrap().close();
        match result {
            Ok(()) => {
                self.shared.handles.lock().unwrap().remove(&h);
                Ok(1)
            }
            Err(os::Failure::Windows { code, .. }) => {
                self.last = code;
                Ok(0)
            }
            Err(e) => Err(self.failure(e, "thread close adapter failed")),
        }
    }
    fn last_error(&mut self) -> Result<u32, &'static str> {
        Ok(self.last)
    }
    fn mutex(&mut self, p: u32, enter: bool) -> Result<(), &'static str> {
        self.lock(p, enter)
    }
    fn delete_critical_section(&mut self, p: u32) -> Result<(), &'static str> {
        self.shared
            .locks
            .lock()
            .unwrap()
            .delete(p)
            .map_err(|e| self.failure(e, "critical section deletion failed"))
    }
    fn create_worker(&mut self, launch: &thread::Launch) -> Result<u32, &'static str> {
        let p = self
            .options(launch)
            .map_err(|e| self.failure(e, "thread options failed"))?;
        let result = engine::create(self, launch.callback, launch.argument, p);
        let cleanup = engine::destroy_name(self, p + 16);
        let scratch = self.shared.bank.lock().unwrap().memory.release(p);
        if let Err(e) = cleanup {
            return Err(self.failure(e, "source name cleanup failed"));
        }
        if let Err(e) = scratch {
            return Err(self.failure(e, "source option cleanup failed"));
        }
        result.map_err(|e| self.failure(e, "engine thread creation failed"))
    }
    fn exchange_status(&mut self, v: u32) -> Result<u32, &'static str> {
        self.mutate(startup::STATUS, |_| v)
    }
}
impl<N: startup::Network + Send + 'static> engine::Boundary for Backend<N> {
    fn allocate_engine(&mut self, n: u32) -> Result<u32, &'static str> {
        self.allocate(n)
            .map_err(|e| self.failure(e, "engine allocation failed"))
    }
    fn byte(&mut self, p: u32) -> Result<u8, &'static str> {
        self.shared
            .bank
            .lock()
            .unwrap()
            .memory
            .read_byte(p)
            .map_err(|_| "missing byte")
    }
    fn initialize_critical_section(&mut self, p: u32) -> Result<(), &'static str> {
        self.shared
            .locks
            .lock()
            .unwrap()
            .initialize(p, 0, None)
            .map(|_| ())
            .map_err(|e| self.failure(e, "critical section initialization failed"))
    }
    fn create_crt_worker(&mut self, f: u32, p: u32) -> Result<engine::Handle, &'static str> {
        if f != engine::CAPSULE_CALLBACK {
            return Err("unknown engine capsule callback");
        }
        self.shared.active.fetch_add(1, Ordering::AcqRel);
        let active = Active {
            shared: self.shared.clone(),
        };
        let result = self.shared.bridge.spawn(
            p,
            Box::new(move || {
                let mut b = Backend::new(active.shared.clone());
                let result = engine::run_capsule(&mut b, p);
                drop(b);
                drop(active);
                result.map_err(|e| format!("transport engine capsule: {e:?}"))
            }),
        );
        match result {
            Ok(Some(t)) => {
                let h = engine::Handle {
                    handle: t.label(),
                    id: t.id(),
                };
                let old = self
                    .shared
                    .handles
                    .lock()
                    .unwrap()
                    .insert(h.handle, Arc::new(Mutex::new(t)));
                assert!(
                    old.is_none(),
                    "exclusive CRT bridge reused a live handle label"
                );
                Ok(h)
            }
            Ok(None) => Ok(engine::Handle { handle: 0, id: 0 }),
            Err(e) => Err(self.failure(e, "CRT worker producer failed")),
        }
    }
    fn name_current_thread(&mut self, p: u32) -> Result<(), &'static str> {
        let mut name = Vec::new();
        let mut at = p;
        loop {
            let byte = self
                .shared
                .bank
                .lock()
                .unwrap()
                .memory
                .read_byte(at)
                .map_err(|_| "unterminated native thread name")?;
            if byte == 0 {
                break;
            }
            name.push(byte);
            at = at
                .checked_add(1)
                .ok_or("native thread name address overflow")?;
        }
        let name = CString::new(name).map_err(|_| "invalid native thread name")?;
        crate::audio_windows_engine_thread_name::name_current(&name)
    }
    fn invoke(&mut self, f: u32, a: u32) -> Result<(), &'static str> {
        if f == crate::audio_replay_stream_running::WORKER {
            return crate::audio_replay_stream_running::worker(self, a)
                .map_err(|e| self.failure(e, "stream worker failed"));
        }
        if (f, a) != (0x8fc100, 0) {
            return Err("unknown engine worker function");
        }
        startup::worker(self).map_err(|e| self.failure(e, "global transport worker failed"))
    }
}
impl<N: startup::Network + Send + 'static> startup::Network for Backend<N> {
    fn winsock_startup(&mut self, v: u16) -> Result<startup::Negotiation, startup::Error> {
        self.shared.network.lock().unwrap().winsock_startup(v)
    }
    fn winsock_cleanup(&mut self) -> Result<u32, startup::Error> {
        self.shared.network.lock().unwrap().winsock_cleanup()
    }
    fn timer_begin(&mut self, p: u32) -> Result<u32, startup::Error> {
        self.shared.network.lock().unwrap().timer_begin(p)
    }
    fn timer_end(&mut self, p: u32) -> Result<u32, startup::Error> {
        self.shared.network.lock().unwrap().timer_end(p)
    }
}
impl<N: startup::Network + Send + 'static> startup::Backend for Backend<N> {
    fn read(&self, p: u32) -> Result<u32, startup::Error> {
        self.shared
            .bank
            .lock()
            .unwrap()
            .memory
            .word(p)
            .map_err(|_| startup::Error::Boundary("global word unavailable"))
    }
    fn write(&mut self, p: u32, v: u32) -> Result<(), startup::Error> {
        Storage::write_word(self, p, v)
            .map_err(|_| startup::Error::Boundary("global word write failed"))
    }
    fn exchange(&mut self, p: u32, v: u32) -> Result<u32, startup::Error> {
        self.mutate(p, |_| v).map_err(startup::Error::Boundary)
    }
    fn mutex(&mut self, p: u32, enter: bool) -> Result<(), startup::Error> {
        self.lock(p, enter).map_err(startup::Error::Boundary)
    }
    fn logger(&mut self) -> Result<u32, startup::Error> {
        if self.shared.diagnostics.is_some() {
            return Ok(self.shared.logger);
        }
        let shared = self.shared.clone();
        let _guard = shared
            .logger_init
            .lock()
            .map_err(|_| startup::Error::Boundary("logger initialization lock poisoned"))?;
        logger::initialize(self).map_err(|e| {
            startup::Error::Boundary(self.failure(e, "native logger initialization failed"))
        })
    }
    fn log(&mut self, p: u32, message: &str) -> Result<(), startup::Error> {
        if p != self.shared.logger {
            return Err(startup::Error::Boundary("foreign logger"));
        }
        if let Some(diagnostics) = &self.shared.diagnostics {
            diagnostics.emit(message).map_err(startup::Error::Boundary)
        } else {
            logger::write_message(self, p, message.as_bytes(), None, 0).map_err(|e| {
                startup::Error::Boundary(
                    self.failure(e, "native logger formatting or dispatch failed"),
                )
            })
        }
    }
}
impl<N: startup::Network + Send + 'static> callbacks::Boundaries for Backend<N> {
    fn allocate_callback_clone(&mut self, n: u32) -> Result<u32, &'static str> {
        engine::Boundary::allocate_engine(self, n)
    }
    fn register_listener(
        &mut self,
        service: u32,
        callback: u32,
        field: u32,
        temporary: &mut u32,
    ) -> Result<(), &'static str> {
        crate::audio_announcer_pending_service::register_virtual(
            self, service, callback, field, *temporary,
        )
        .map_err(|e| self.failure(e, "pending listener registration failed"))
    }
    fn unregister_listener(
        &mut self,
        service: u32,
        callback: u32,
        field: u32,
    ) -> Result<(), &'static str> {
        crate::audio_announcer_pending_service::unregister_virtual(self, service, callback, field)
            .map_err(|e| self.failure(e, "listener removal failed"))
    }
}
impl<N: startup::Network + Send + 'static> logger::Boundary for Backend<N> {
    fn byte(&mut self, p: u32) -> Result<u8, &'static str> {
        engine::Boundary::byte(self, p)
    }
    fn initialize_critical_section(&mut self, p: u32) -> Result<(), &'static str> {
        engine::Boundary::initialize_critical_section(self, p)
    }
    fn delete_critical_section(&mut self, p: u32) -> Result<(), &'static str> {
        thread::Boundary::delete_critical_section(self, p)
    }
}
impl<N: startup::Network + Send + 'static> logger::Output for Backend<N> {
    fn local_time(&mut self) -> Result<[u16; 8], &'static str> {
        Ok(logger::local_time())
    }
    fn invoke_member(&mut self, owner: u32, member: u32, message: u32) -> Result<u8, &'static str> {
        if member == crate::audio_replay_recording_resource::MEMBER {
            return crate::audio_replay_recording_resource::message(self, owner, message)
                .map_err(|e| self.failure(e, "recording file message failed"));
        }
        Err("configured native logger member has no attached dispatcher")
    }
}
