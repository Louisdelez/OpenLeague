//! Application-owned source game manager, service callbacks and stream lifetime.
use super::*;
use crate::{
    audio_replay_game_manager as manager, audio_replay_metadata as metadata,
    audio_replay_service_manager as service, audio_replay_stream as stream,
};
pub(super) struct Record {
    pub(super) pointer: u32,
    code: Option<u32>,
}
pub struct GameReplayRequest<'a> {
    pub arguments: [u32; 2],
    pub key: [u8; 16],
    pub host: Option<&'a [u8]>,
    pub start: [u32; 6],
    pub flag: u32,
    pub recording_path: Option<&'a [u8]>,
    pub recording: bool,
}
#[derive(Debug, Clone, serde::Serialize)]
pub struct GameManagerSnapshot {
    pub pointer: u32,
    pub stream: u32,
    pub state: u32,
    pub code: Option<u32>,
    pub metadata: [u32; 2],
    pub metadata_references: u32,
    pub service_callbacks: [[u32; 4]; 2],
}
impl<N: startup::Network + Send + 'static> metadata::Boundary for Backend<N> {
    fn read_byte(&mut self, p: u32) -> Result<u8, read::Error> {
        crate::audio_replay_object_manager::Boundary::read_byte(self, p)
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
}
impl<N: startup::Network + Send + 'static> manager::Boundary for Backend<N> {}
impl<N: startup::Network + Send + 'static> Runtime<N> {
    fn begin_game_manager_owned(&self, b: &mut Backend<N>) -> Result<u32, String> {
        if self.shared.diagnostics.is_some()
            || self.shared.active.load(Ordering::Acquire) != 0
            || self.shared.stream.lock().unwrap().is_some()
            || self.shared.configuration.lock().unwrap().is_some()
        {
            return Err(
                "game manager requires idle owned runtime without standalone stream/configuration"
                    .into(),
            );
        }
        let mut attempted = self.shared.game_manager_attempted.lock().unwrap();
        if *attempted {
            return Err("game manager initialization already attempted; a fresh application lifetime is required".into());
        }
        let s = self
            .shared
            .service
            .lock()
            .unwrap()
            .as_ref()
            .ok_or("configured service required")?
            .pointer;
        if b.word(startup::STATUS)
            .map_err(|e| format!("transport status: {e:?}"))?
            == 2
        {
            return Err("game manager cannot adopt a previously used transport".into());
        }
        if b.word(logger::POINTER)
            .map_err(|e| format!("logger pointer: {e:?}"))?
            != 0
        {
            return Err("game manager requires an unused logger lifetime".into());
        }
        *attempted = true;
        let p = manager::get(b).map_err(|e| format!("game manager singleton: {e:?}"))?;
        *self.shared.game_manager.lock().unwrap() = Some(Record {
            pointer: p,
            code: None,
        });
        Ok(s)
    }
    /// Source72A800, including the service-owned callbacks installed on its parent.
    pub fn initialize_game_manager(&self) -> Result<(), String> {
        let closed = self
            .shared
            .launch
            .lock()
            .map_err(|_| "launch lock poisoned")?;
        if *closed {
            return Err("transport runtime is shut down".into());
        }
        let mut b = Backend::new(self.shared.clone());
        let s = self.begin_game_manager_owned(&mut b)?;
        let scratch = b.recording_scratch(8).map_err(str::to_string)?;
        let result = service::initialize(&mut b, s, scratch);
        let cleanup = self.shared.bank.lock().unwrap().memory.release(scratch);
        match (result, cleanup) {
            (Ok(()), Ok(())) => Ok(()),
            (a, c) => Err(format!(
                "game manager initialization: {a:?}; scratch: {c:?}"
            )),
        }
    }
    /// Source72A780 derives mode from real service fields. Active host creation is
    /// still unavailable and is rejected before any source lifetime is changed.
    pub fn open_game_replay(&self, r: GameReplayRequest<'_>) -> Result<u32, String> {
        let closed = self
            .shared
            .launch
            .lock()
            .map_err(|_| "launch lock poisoned")?;
        if *closed {
            return Err("transport runtime is shut down".into());
        }
        if r.host.is_some() {
            return Err("active replay host creation/connection is not connected".into());
        }
        Self::validate_game_path(r.recording_path)?;
        let mut b = Backend::new(self.shared.clone());
        let (path, scratch) = self.game_scratch(&mut b, r.recording_path)?;
        let s = match self.begin_game_manager_owned(&mut b) {
            Ok(s) => s,
            Err(e) => {
                self.release_game_scratch(path, scratch)?;
                return Err(e);
            }
        };
        let result = service::open(
            &mut b,
            s,
            service::Request {
                arguments: r.arguments,
                key: &r.key,
                host: r.host,
                start: r.start,
                flag: r.flag,
                recording_path: path,
                recording: r.recording as u32,
            },
            scratch,
        );
        self.shared
            .game_manager
            .lock()
            .unwrap()
            .as_mut()
            .unwrap()
            .code = result.as_ref().ok().copied();
        let mut bank = self.shared.bank.lock().unwrap();
        let cleanup = bank.memory.release(scratch);
        let path_cleanup = if path != 0 {
            bank.memory.release(path)
        } else {
            Ok(())
        };
        match (result, cleanup, path_cleanup) {
            (Ok(v), Ok(()), Ok(())) => Ok(v),
            (a, c, p) => Err(format!(
                "game replay opening: {a:?}; scratch: {c:?}; path: {p:?}"
            )),
        }
    }
    fn validate_game_path(path: Option<&[u8]>) -> Result<(), String> {
        if let Some(bytes) = path {
            if bytes.contains(&0) {
                return Err("recording path contains NUL".into());
            }
            u32::try_from(bytes.len())
                .ok()
                .and_then(|n| n.checked_add(1))
                .ok_or("recording path too long")?;
        }
        Ok(())
    }
    fn game_scratch(&self, b: &mut Backend<N>, path: Option<&[u8]>) -> Result<(u32, u32), String> {
        let path = self.game_recording_path(b, path)?;
        match b.recording_scratch(24) {
            Ok(p) => Ok((path, p)),
            Err(e) => {
                if path != 0 {
                    self.shared
                        .bank
                        .lock()
                        .unwrap()
                        .memory
                        .release(path)
                        .map_err(|c| format!("scratch failure {e}; path cleanup {c:?}"))?;
                }
                Err(e.into())
            }
        }
    }
    fn release_game_scratch(&self, path: u32, scratch: u32) -> Result<(), String> {
        let mut bank = self.shared.bank.lock().unwrap();
        let a = bank.memory.release(scratch);
        let c = if path != 0 {
            bank.memory.release(path)
        } else {
            Ok(())
        };
        match (a, c) {
            (Ok(()), Ok(())) => Ok(()),
            (a, c) => Err(format!("game scratch cleanup: {a:?}/{c:?}")),
        }
    }
    fn game_recording_path(&self, b: &mut Backend<N>, path: Option<&[u8]>) -> Result<u32, String> {
        let Some(bytes) = path else {
            return Ok(0);
        };
        if bytes.contains(&0) {
            return Err("recording path contains NUL".into());
        }
        let size = u32::try_from(bytes.len())
            .ok()
            .and_then(|n| n.checked_add(1))
            .ok_or("recording path too long")?;
        let p = b.recording_scratch(size).map_err(str::to_string)?;
        for (i, v) in bytes.iter().chain(std::iter::once(&0)).enumerate() {
            Storage::write_byte(b, p + i as u32, *v)
                .map_err(|e| format!("recording path: {e:?}"))?;
        }
        Ok(p)
    }
    pub fn game_manager_snapshot(&self) -> Result<Option<GameManagerSnapshot>, String> {
        let _launch = self
            .shared
            .launch
            .lock()
            .map_err(|_| "launch lock poisoned")?;
        let owner = self.shared.game_manager.lock().unwrap();
        let Some(r) = owner.as_ref() else {
            return Ok(None);
        };
        let mut b = Backend::new(self.shared.clone());
        self.game_manager_snapshot_owned(&mut b, r.pointer, r.code)
            .map(Some)
    }
    fn game_manager_snapshot_owned(
        &self,
        b: &mut Backend<N>,
        p: u32,
        code: Option<u32>,
    ) -> Result<GameManagerSnapshot, String> {
        let mut w = |p| {
            b.word(p)
                .map_err(|e| format!("game manager snapshot: {e:?}"))
        };
        let stream = w(p + 0x30)?;
        let node = if stream != 0 { w(stream + 0x44)? } else { 0 };
        let state = if node != 0 { w(node + 12)? } else { u32::MAX };
        let metadata = [w(p + 0x34)?, w(p + 0x38)?];
        let metadata_references = if metadata[1] != 0 {
            w(metadata[1] + 4)?
        } else {
            0
        };
        let mut service_callbacks = [[0; 4]; 2];
        for (i, o) in [0x20, 0x24].into_iter().enumerate() {
            let c = w(p + o)?;
            if c != 0 {
                for j in 0..4 {
                    service_callbacks[i][j] = w(c + j as u32 * 4)?;
                }
            }
        }
        Ok(GameManagerSnapshot {
            pointer: p,
            stream,
            state,
            code,
            metadata,
            metadata_references,
            service_callbacks,
        })
    }
    pub fn close_game_manager(&self) -> Result<(), String> {
        let closed = self
            .shared
            .launch
            .lock()
            .map_err(|_| "launch lock poisoned")?;
        if *closed {
            return Ok(());
        }
        let mut b = Backend::new(self.shared.clone());
        self.close_game_manager_owned(&mut b)
    }
    pub(super) fn close_game_manager_owned(&self, b: &mut Backend<N>) -> Result<(), String> {
        let mut owner = self
            .shared
            .game_manager
            .lock()
            .map_err(|_| "game manager owner poisoned")?;
        let Some(r) = owner.as_ref() else {
            return Ok(());
        };
        let nested = b
            .word(r.pointer + 0x30)
            .map_err(|e| format!("parent stream: {e:?}"))?;
        if nested != 0 {
            stream::stop(b, nested).map_err(|e| format!("parent stream stop: {e:?}"))?;
        }
        if self.shared.active.load(Ordering::Acquire) != 0 {
            return Err("parent worker did not retire; retaining its owner".into());
        }
        manager::shutdown(b).map_err(|e| format!("game manager shutdown: {e:?}"))?;
        *owner = None;
        // Source logger callbacks hold raw resource pointers. Retire immediately after
        // the parent; no later message may access the freed recording resource.
        if b.word(logger::POINTER)
            .map_err(|e| format!("parent logger: {e:?}"))?
            != 0
        {
            logger::shutdown(b).map_err(|e| format!("parent logger shutdown: {e:?}"))?;
        }
        Ok(())
    }
    /// Diagnostic only: explicit source no-op mode1, not a fabricated normal game
    /// mode. Uses the configured service's real initialization and canonical bank.
    pub fn probe_game_manager(
        &self,
        path: Option<&[u8]>,
        messages: &[&[u8]],
    ) -> Result<serde_json::Value, String> {
        let closed = self
            .shared
            .launch
            .lock()
            .map_err(|_| "launch lock poisoned")?;
        if *closed {
            return Err("transport runtime is shut down".into());
        }
        Self::validate_game_path(path)?;
        let mut b = Backend::new(self.shared.clone());
        let (path, scratch) = self.game_scratch(&mut b, path)?;
        let s = match self.begin_game_manager_owned(&mut b) {
            Ok(s) => s,
            Err(e) => {
                self.release_game_scratch(path, scratch)?;
                return Err(e);
            }
        };
        let work = (|| -> Result<serde_json::Value, String> {
            service::initialize(&mut b, s, scratch)
                .map_err(|e| format!("parent service initialization: {e:?}"))?;
            let p = self
                .shared
                .game_manager
                .lock()
                .unwrap()
                .as_ref()
                .unwrap()
                .pointer;
            let code = manager::open(
                &mut b,
                p,
                manager::Request {
                    arguments: [0, 0],
                    key: &[0; 16],
                    host: None,
                    start: [0; 6],
                    mode: 1,
                    flag: 0,
                    extra: 0,
                    recording_path: path,
                    recording: 1,
                },
                scratch,
            )
            .map_err(|e| format!("parent source no-op open/start: {e:?}"))?;
            self.shared
                .game_manager
                .lock()
                .unwrap()
                .as_mut()
                .unwrap()
                .code = Some(code);
            if code != 0 {
                return Err(format!("source no-op returned {code}"));
            }
            let started = self.game_manager_snapshot_owned(&mut b, p, Some(code))?;
            let resource = b
                .word(started.stream + 0x30)
                .map_err(|e| format!("parent file: {e:?}"))?;
            let enabled = logger::Boundary::byte(&mut b, resource + 36).map_err(str::to_string)?;
            let logger = b
                .word(logger::POINTER)
                .map_err(|e| format!("parent logger: {e:?}"))?;
            for message in messages {
                b.lock(logger, true).map_err(str::to_string)?;
                let result = logger::write_message(&mut b, logger, message, None, 0);
                let unlock = b.lock(logger, false);
                result.map_err(|e| format!("parent log: {e:?}"))?;
                unlock.map_err(str::to_string)?;
            }
            stream::stop(&mut b, started.stream).map_err(|e| format!("parent stop: {e:?}"))?;
            let stopped = self.game_manager_snapshot_owned(&mut b, p, Some(code))?;
            Ok(
                serde_json::json!({"source_noop_diagnostic":true,"service_pointer":s,"started":started,"stopped":stopped,"resource_enabled":enabled}),
            )
        })();
        let cleanup = self.close_game_manager_owned(&mut b);
        let mut bank = self.shared.bank.lock().unwrap();
        let a = bank.memory.release(scratch);
        let c = if path != 0 {
            bank.memory.release(path)
        } else {
            Ok(())
        };
        drop(bank);
        match (work, cleanup, a, c) {
            (Ok(mut report), Ok(()), Ok(()), Ok(())) => {
                let f = self.shared.files.lock().unwrap().statistics();
                report["files"] =
                    serde_json::json!({"opened":f.0,"closed":f.1,"writes":f.2,"remaining":f.3});
                Ok(report)
            }
            (a, b, c, d) => Err(format!(
                "parent diagnostic: {a:?}; cleanup: {b:?}; scratch: {c:?}/{d:?}"
            )),
        }
    }
}
#[cfg(test)]
#[path = "audio_replay_windows_game_manager_tests.rs"]
mod tests;
