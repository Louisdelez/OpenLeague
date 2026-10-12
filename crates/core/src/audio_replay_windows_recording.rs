//! Windows narrow-CRT file boundary for native LogOut_File diagnostic messages.
//! FILE pointers remain host-owned; only canonical integer labels enter the bank.
use super::*;
use crate::audio_replay_recording_resource as resource;
use std::ffi::c_void;
#[path = "audio_replay_windows_stdio.rs"]
mod host_stdio;
struct File {
    pointer: *mut c_void,
    api: &'static host_stdio::Api,
}
// Every access, including close, is serialized by Shared.files. FILE is not
// dereferenced in Rust and always passed back to the same Windows CRT DLL.
unsafe impl Send for File {}
impl Drop for File {
    fn drop(&mut self) {
        if !self.pointer.is_null() {
            unsafe {
                (self.api.fclose)(self.pointer);
            }
        }
    }
}
#[derive(Default)]
pub(super) struct Files {
    next: u32,
    live: BTreeMap<u32, File>,
    opens: u32,
    closes: u32,
    writes: u32,
}
#[derive(Debug, Clone, serde::Serialize)]
pub struct RecordingFileProbe {
    pub opened: u8,
    pub opened_again: u8,
    pub closed: u8,
    pub files_opened: u32,
    pub files_closed: u32,
    pub writes: u32,
    pub remaining_files: usize,
}
impl Files {
    pub(super) fn statistics(&self) -> (u32, u32, u32, usize) {
        (self.opens, self.closes, self.writes, self.live.len())
    }
    fn open(&mut self, path: &std::ffi::CStr, mode: &std::ffi::CStr) -> Result<u32, &'static str> {
        let api = host_stdio::get()?;
        let p = unsafe { (api.fopen)(path.as_ptr(), mode.as_ptr()) };
        if p.is_null() {
            return Ok(0);
        }
        let next = self
            .next
            .checked_add(1)
            .filter(|n| *n < 0x01000000)
            .ok_or("file label space exhausted");
        let next = match next {
            Ok(n) => n,
            Err(e) => {
                unsafe {
                    (api.fclose)(p);
                }
                return Err(e);
            }
        };
        self.next = next;
        let label = 0x76000000 + next;
        self.live.insert(label, File { pointer: p, api });
        self.opens += 1;
        Ok(label)
    }
    fn close(&mut self, p: u32) -> Result<i32, &'static str> {
        let mut file = self.live.remove(&p).ok_or("unknown canonical file")?;
        let result = unsafe { (file.api.fclose)(file.pointer) };
        file.pointer = std::ptr::null_mut();
        self.closes += 1;
        Ok(result)
    }
    fn message(&mut self, p: u32, message: &std::ffi::CStr) -> Result<i32, &'static str> {
        let file = self.live.get(&p).ok_or("unknown canonical file")?;
        let result =
            unsafe { (file.api.fprintf)(file.pointer, b"%s\0".as_ptr().cast(), message.as_ptr()) };
        self.writes += 1;
        Ok(result)
    }
}
impl<N: startup::Network + Send + 'static> Backend<N> {
    fn file_cstring(&self, p: u32) -> Result<CString, &'static str> {
        let bank = self
            .shared
            .bank
            .lock()
            .map_err(|_| "file string bank poisoned")?;
        let mut bytes = Vec::new();
        let mut at = p;
        loop {
            let b = bank
                .memory
                .read_byte(at)
                .map_err(|_| "unterminated canonical file string")?;
            if b == 0 {
                break;
            }
            bytes.push(b);
            at = at.checked_add(1).ok_or("file string address overflow")?;
        }
        CString::new(bytes).map_err(|_| "invalid canonical file string")
    }
}
impl<N: startup::Network + Send + 'static> resource::Boundary for Backend<N> {
    fn lock(&mut self, p: u32, enter: bool) -> Result<(), &'static str> {
        Backend::lock(self, p, enter)
    }
    fn file_open(&mut self, p: u32, mode: &[u8]) -> Result<u32, &'static str> {
        let path = self.file_cstring(p)?;
        let mode = CString::new(mode).map_err(|_| "invalid file mode")?;
        self.shared
            .files
            .lock()
            .map_err(|_| "file owner poisoned")?
            .open(&path, &mode)
    }
    fn file_close(&mut self, p: u32) -> Result<i32, &'static str> {
        self.shared
            .files
            .lock()
            .map_err(|_| "file owner poisoned")?
            .close(p)
    }
    fn file_message(&mut self, p: u32, message: u32) -> Result<i32, &'static str> {
        let message = self.file_cstring(message)?;
        self.shared
            .files
            .lock()
            .map_err(|_| "file owner poisoned")?
            .message(p, &message)
    }
}
impl<N: startup::Network + Send + 'static> Runtime<N> {
    /// Qualify the source resource on the normal runtime bank with actual disk I/O.
    /// Requires an idle runtime. This is not8FB650 full stream preparation: its
    /// pathname-registration singleton and parent replay manager remain pending.
    pub fn probe_recording_file(
        &self,
        path: &[u8],
        messages: &[&[u8]],
    ) -> Result<RecordingFileProbe, String> {
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
            || self.shared.stream.lock().unwrap().is_some()
            || self.shared.configuration.lock().unwrap().is_some()
        {
            return Err("file resource probe requires idle owned runtime".into());
        }
        let mut b = Backend::new(self.shared.clone());
        if b.word(logger::POINTER)
            .map_err(|e| format!("logger pointer: {e:?}"))?
            != 0
            || !self.has_only_service_allocations()
            || *self.shared.game_manager_attempted.lock().unwrap()
        {
            return Err("file resource probe requires an unused logger lifetime".into());
        }
        let length = u32::try_from(path.len())
            .map_err(|_| "file path too long")?
            .checked_add(9)
            .ok_or("file path size overflow")?;
        let scratch = {
            let mut bank = self.shared.bank.lock().unwrap();
            let p = bank.next_scratch;
            bank.next_scratch = p
                .checked_add(length)
                .and_then(|n| n.checked_add(63))
                .map(|n| n & !63)
                .ok_or("file scratch exhausted")?;
            bank.memory
                .reserve_at(p, length)
                .map_err(|e| format!("file scratch: {e:?}"))?;
            p
        };
        for (i, v) in path.iter().chain(std::iter::once(&0)).enumerate() {
            Storage::write_byte(&mut b, scratch + 8 + i as u32, *v)
                .map_err(|e| format!("path bytes: {e:?}"))?;
        }
        let p = b
            .allocate(40)
            .map_err(|e| format!("file resource allocation: {e:?}"))?;
        let mut constructed = false;
        let work = (|| -> Result<(u8, u8, u8), String> {
            resource::construct(&mut b, p, scratch)
                .map_err(|e| format!("file constructor: {e:?}"))?;
            constructed = true;
            let opened =
                resource::open(&mut b, p, scratch + 8).map_err(|e| format!("file open: {e:?}"))?;
            let owner = b
                .word(logger::POINTER)
                .map_err(|e| format!("file logger: {e:?}"))?;
            for message in messages {
                b.lock(owner, true).map_err(str::to_string)?;
                let result = logger::write_message(&mut b, owner, message, None, 0);
                let unlock = b.lock(owner, false);
                result.map_err(|e| format!("file log: {e:?}"))?;
                unlock.map_err(str::to_string)?;
            }
            let opened_again = resource::open(&mut b, p, scratch + 8)
                .map_err(|e| format!("file repeated open: {e:?}"))?;
            let closed = resource::close(&mut b, p).map_err(|e| format!("file close: {e:?}"))?;
            assert_eq!(
                resource::close(&mut b, p).map_err(|e| format!("file repeated close: {e:?}"))?,
                closed
            );
            Ok((opened, opened_again, closed))
        })();
        let cleanup = (|| -> Result<(), String> {
            if constructed {
                if work.is_err() {
                    resource::close(&mut b, p).map_err(|e| format!("file error close: {e:?}"))?;
                }
                resource::destroy(&mut b, p).map_err(|e| format!("file destruction: {e:?}"))?;
                // After freeing the resource no logger message may be emitted.
                logger::shutdown(&mut b).map_err(|e| format!("file logger shutdown: {e:?}"))?;
            }
            self.shared
                .bank
                .lock()
                .unwrap()
                .memory
                .release(scratch)
                .map_err(|e| format!("file scratch release: {e:?}"))?;
            Ok(())
        })();
        let values = match (work, cleanup) {
            (Ok(v), Ok(())) => v,
            (v, c) => return Err(format!("file resource result: {v:?}; cleanup: {c:?}")),
        };
        let f = self.shared.files.lock().unwrap();
        Ok(RecordingFileProbe {
            opened: values.0,
            opened_again: values.1,
            closed: values.2,
            files_opened: f.opens,
            files_closed: f.closes,
            writes: f.writes,
            remaining_files: f.live.len(),
        })
    }
}

impl<N: startup::Network + Send + 'static> Backend<N> {
    pub(super) fn recording_scratch(&mut self, bytes: u32) -> Result<u32, &'static str> {
        let mut bank = self
            .shared
            .bank
            .lock()
            .map_err(|_| "recording bank poisoned")?;
        let p = bank.next_scratch;
        let next = p
            .checked_add(bytes)
            .and_then(|n| n.checked_add(63))
            .map(|n| n & !63)
            .ok_or("recording scratch exhausted")?;
        bank.memory
            .reserve_at(p, bytes)
            .map_err(|_| "recording scratch unavailable")?;
        bank.next_scratch = next;
        Ok(p)
    }
}
impl<N: startup::Network + Send + 'static> crate::audio_replay_path_registry::Boundary
    for Backend<N>
{
    fn read_byte(&mut self, p: u32) -> Result<u8, read::Error> {
        self.shared
            .bank
            .lock()
            .unwrap()
            .memory
            .read_byte(p)
            .map_err(|_| read::Error::MissingWord(p))
    }
}
impl<N: startup::Network + Send + 'static> resource::Preparation for Backend<N> {
    fn register_path(&mut self, path: u32) -> Result<(), &'static str> {
        let p = crate::audio_replay_path_registry::initialize(self)
            .map_err(|e| self.failure(e, "path singleton initialization failed"))?;
        crate::audio_replay_path_registry::register_path(self, p, path)
            .map(|_| ())
            .map_err(|e| self.failure(e, "path registration failed"))
    }
}
#[derive(Debug, Clone, PartialEq, Eq, serde::Serialize)]
pub struct RecordingStreamProbe {
    pub open_code: u32,
    pub start_code: u32,
    pub state_after_start: u32,
    pub state_after_stop: u32,
    pub resource_enabled: u8,
    pub resource_references: u32,
    pub registry_initialized: bool,
    pub files_opened: u32,
    pub files_closed: u32,
    pub writes: u32,
    pub remaining_files: usize,
}
impl<N: startup::Network + Send + 'static> Runtime<N> {
    /// Exercise native8FB650 through the source no-op stream implementation and
    /// a real Windows worker. Diagnostic text only; no replay frames or host.
    /// The launch lock covers the complete lifetime and raw callback retirement.
    pub fn probe_recording_stream(
        &self,
        path: Option<&[u8]>,
        messages: &[&[u8]],
    ) -> Result<RecordingStreamProbe, String> {
        use crate::{audio_replay_stream as stream, audio_replay_stream_running as running};
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
            || self.shared.stream.lock().unwrap().is_some()
            || self.shared.configuration.lock().unwrap().is_some()
            || !self.has_only_service_allocations()
            || *self.shared.game_manager_attempted.lock().unwrap()
        {
            return Err("recorded stream probe requires an idle owned runtime".into());
        }
        let mut b = Backend::new(self.shared.clone());
        if b.word(logger::POINTER)
            .map_err(|e| format!("logger pointer: {e:?}"))?
            != 0
        {
            return Err("recorded stream requires an unused logger lifetime".into());
        }
        let path_storage = if let Some(bytes) = path {
            let size = u32::try_from(bytes.len())
                .ok()
                .and_then(|n| n.checked_add(1))
                .ok_or("recording path too long")?;
            let p = b.recording_scratch(size).map_err(str::to_string)?;
            for (i, v) in bytes.iter().chain(std::iter::once(&0)).enumerate() {
                Storage::write_byte(&mut b, p + i as u32, *v)
                    .map_err(|e| format!("path storage: {e:?}"))?;
            }
            p
        } else {
            0
        };
        let work = (|| -> Result<RecordingStreamProbe, String> {
            let open_code = self.open_stream_owned(
                StreamOpenRequest {
                    mode: 1,
                    configuration: StreamConfigurationRequest {
                        transport: ConfigurationRequest {
                            callback: None,
                            arguments: [0, 0],
                            host: None,
                            port: 0,
                            sockaddr_frame: [0; 16],
                        },
                        key: [0; 16],
                        flag: 0,
                        extra: 0,
                    },
                },
                path_storage,
                1,
            )?;
            if open_code != 0 {
                return Err(format!("unexpected no-op opening code {open_code}"));
            }
            let p = self
                .shared
                .stream
                .lock()
                .unwrap()
                .as_ref()
                .ok_or("missing recorded stream")?
                .pointer;
            let start_code = running::start(&mut b, p, [0; 6])
                .map_err(|e| format!("recorded stream start: {e:?}"))?;
            if start_code != 0 {
                return Err(format!("unexpected no-op start code {start_code}"));
            }
            let node = b
                .word(p + 0x44)
                .map_err(|e| format!("started state: {e:?}"))?;
            let state_after_start = b
                .word(node + 12)
                .map_err(|e| format!("started state ID: {e:?}"))?;
            let resource = b
                .word(p + 0x30)
                .map_err(|e| format!("file resource: {e:?}"))?;
            let control = b
                .word(p + 0x34)
                .map_err(|e| format!("file control: {e:?}"))?;
            let resource_references = b
                .word(control + 4)
                .map_err(|e| format!("file references: {e:?}"))?;
            let resource_enabled =
                logger::Boundary::byte(&mut b, resource + 36).map_err(str::to_string)?;
            let owner = b
                .word(logger::POINTER)
                .map_err(|e| format!("logger pointer: {e:?}"))?;
            for message in messages {
                b.lock(owner, true).map_err(str::to_string)?;
                let result = logger::write_message(&mut b, owner, message, None, 0);
                let unlock = b.lock(owner, false);
                result.map_err(|e| format!("recorded stream log: {e:?}"))?;
                unlock.map_err(str::to_string)?;
            }
            stream::stop(&mut b, p).map_err(|e| format!("recorded stream stop: {e:?}"))?;
            let node = b
                .word(p + 0x44)
                .map_err(|e| format!("stopped state: {e:?}"))?;
            let state_after_stop = b
                .word(node + 12)
                .map_err(|e| format!("stopped state ID: {e:?}"))?;
            let registry_initialized = b
                .word(crate::audio_replay_path_registry::FLAG)
                .map_err(|e| format!("path flag: {e:?}"))?
                & 1
                != 0;
            Ok(RecordingStreamProbe {
                open_code,
                start_code,
                state_after_start,
                state_after_stop,
                resource_enabled,
                resource_references,
                registry_initialized,
                files_opened: 0,
                files_closed: 0,
                writes: 0,
                remaining_files: 0,
            })
        })();
        let cleanup = (|| -> Result<(), String> {
            self.close_stream_owned(&mut b)?;
            // No transport reference exists in this source no-op implementation.
            // Freeing the stream leaves raw logger owners; retire the chain now.
            if b.word(logger::POINTER)
                .map_err(|e| format!("recorded logger: {e:?}"))?
                != 0
            {
                logger::shutdown(&mut b).map_err(|e| format!("recorded logger shutdown: {e:?}"))?;
            }
            if path_storage != 0 {
                self.shared
                    .bank
                    .lock()
                    .unwrap()
                    .memory
                    .release(path_storage)
                    .map_err(|e| format!("recorded path cleanup: {e:?}"))?;
            }
            Ok(())
        })();
        match (work, cleanup) {
            (Ok(mut report), Ok(())) => {
                let f = self.shared.files.lock().unwrap();
                report.files_opened = f.opens;
                report.files_closed = f.closes;
                report.writes = f.writes;
                report.remaining_files = f.live.len();
                Ok(report)
            }
            (work, cleanup) => Err(format!("recorded stream: {work:?}; cleanup: {cleanup:?}")),
        }
    }
}
