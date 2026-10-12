//! Actual QPC/QPF, canonical CRT allocation and FIFO OS-thread synchronization.
//! Native once flags/owner/depth are ported; ConCRT fiber internals are adapted.
use super::*;
use crate::{audio_clock_once as once, audio_native_process_clock as clock, audio_windows_fifo_mutex as fifo};
#[link(name = "kernel32")]
unsafe extern "system" {
    fn QueryPerformanceFrequency(value: *mut i64) -> i32;
    fn QueryPerformanceCounter(value: *mut i64) -> i32;
    fn Sleep(milliseconds: u32);
}
#[derive(Default)]
pub(super) struct HostState {
    allocations: BTreeMap<u32, u32>,
    pending_mirrors: BTreeSet<u32>,
    inner: BTreeMap<u32, Arc<fifo::FifoMutex>>,
    callbacks: Vec<u32>,
    retired: Vec<fifo::Snapshot>,
    failure: Option<String>,
    closing: bool,
    qpf: usize,
    qpc: usize,
    #[cfg(test)] fail_retirement: bool,
}
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct ProcessClockSnapshot {
    pub initialized: bool,
    pub origin: u64,
    pub frequency: u64,
    pub qpf_calls: usize,
    pub qpc_calls: usize,
    pub crt_allocations: usize,
    pub pending_mirrors: usize,
    pub inner_mutexes: usize,
    pub registered_cleanups: Vec<u32>,
    pub events_created: usize,
    pub events_closed: usize,
    pub event_close_failures: usize,
    pub failure: Option<String>,
}
impl<N: startup::Network + Send + 'static> Backend<N> {
    fn clock_crt_address(&self, p: u32, width: u32) -> Result<bool, &'static str> {
        if [once::COOKIE, once::CS_DISPATCH].contains(&p) && width == 4 { return Ok(true); }
        let state = self.shared.clock.lock().map_err(|_| "clock host state poisoned")?;
        Ok(state.allocations.iter().any(|(&base, &size)| p >= base && u64::from(p) + u64::from(width) <= u64::from(base) + u64::from(size)))
    }
    fn clock_read(&mut self, p: u32, width: u32) -> Result<u32, &'static str> {
        if self.clock_crt_address(p, width)? {
            self.shared.bridge.clock_crt_read(p, width).map_err(|e| self.failure(e, "clock CRT storage read failed"))
        } else if width == 4 { read::Memory::word(self, p).map_err(|e| self.failure(e, "clock global word missing")) }
        else { self.shared.bank.lock().map_err(|_| "engine bank poisoned")?.memory.read_byte(p).map(u32::from).map_err(|e| self.failure(e, "clock global byte missing")) }
    }
    fn clock_write(&mut self, p: u32, width: u32, value: u32) -> Result<(), &'static str> {
        if self.clock_crt_address(p, width)? {
            self.shared.bridge.clock_crt_write(p, width, value).map_err(|e| self.failure(e, "clock CRT storage write failed"))
        } else if width == 4 { Storage::write_word(self, p, value).map_err(|e| self.failure(e, "clock global write failed")) }
        else { Storage::write_byte(self, p, value as u8).map_err(|e| self.failure(e, "clock global byte write failed")) }
    }
    pub(super) fn clock_preflight(&self) -> Result<(), &'static str> {
        let state = self.shared.clock.lock().map_err(|_| "clock host state poisoned")?;
        if state.closing { return Err("process clock shutdown has started"); }
        if state.failure.is_some() {
            Err("process clock previously failed; its partial source state cannot be reused")
        } else { Ok(()) }
    }
    pub(super) fn clock_failed(&self, error: impl std::fmt::Debug) -> &'static str {
        let detail = format!("{error:?}");
        if let Ok(mut state) = self.shared.clock.lock() { if state.failure.is_none() { state.failure = Some(detail.clone()); } }
        self.failure(detail, "native process clock sample failed")
    }
    pub(super) fn shutdown_process_clock(&mut self) -> Result<(), String> {
        self.shared.clock.lock().map_err(|_| "clock host state poisoned")?.closing = true;
        loop {
            let callback = self.shared.clock.lock().map_err(|_| "clock host state poisoned")?.callbacks.last().copied();
            let Some(callback) = callback else { break; };
            once::dispatch_cleanup(self, callback).map_err(|e| format!("clock native shutdown: {e:?}"))?;
            self.shared.clock.lock().map_err(|_| "clock host state poisoned")?.callbacks.pop();
        }
        let state = self.shared.clock.lock().map_err(|_| "clock host state poisoned")?;
        if !state.allocations.is_empty() || !state.pending_mirrors.is_empty() || !state.inner.is_empty() { return Err("process clock ownership remains live at shutdown".into()); }
        if state.retired.iter().any(|s| s.events_created != s.events_closed || s.close_failures != 0) { return Err("process clock Windows event retirement failed".into()); }
        Ok(())
    }
}
impl<N: startup::Network + Send + 'static> clock::Boundary for Backend<N> {
    fn word(&mut self, p: u32) -> Result<u32, &'static str> { self.clock_read(p, 4) }
    fn byte(&mut self, p: u32) -> Result<u8, &'static str> { self.clock_read(p, 1).map(|v| v as u8) }
    fn write_word(&mut self, p: u32, value: u32) -> Result<(), &'static str> { self.clock_write(p, 4, value) }
    fn write_byte(&mut self, p: u32, value: u8) -> Result<(), &'static str> { self.clock_write(p, 1, value as u32) }
    fn query_frequency(&mut self) -> Result<clock::Query, &'static str> {
        let mut value = std::mem::MaybeUninit::<i64>::uninit();
        let result = unsafe { QueryPerformanceFrequency(value.as_mut_ptr()) };
        self.shared.clock.lock().map_err(|_| "clock host state poisoned")?.qpf += 1;
        // Windows documents a complete LARGE_INTEGER output on success. On
        // failure the native stack bytes are unknown: never read/invent them.
        if result == 0 { return Err("QueryPerformanceFrequency did not provide a known complete output"); }
        let value = unsafe { value.assume_init() } as u64;
        Ok(clock::Query { return_value: result as u32, words: [value as u32, (value >> 32) as u32] })
    }
    fn query_counter(&mut self, initial: [u32; 2]) -> Result<clock::Query, &'static str> {
        let mut value = (u64::from(initial[0]) | u64::from(initial[1]) << 32) as i64;
        let result = unsafe { QueryPerformanceCounter(&mut value) };
        self.shared.clock.lock().map_err(|_| "clock host state poisoned")?.qpc += 1;
        Ok(clock::Query { return_value: result as u32, words: [value as u32, ((value as u64) >> 32) as u32] })
    }
    fn enter_once(&mut self) -> Result<(), &'static str> {
        self.clock_preflight()?;
        once::prepare_and_enter_clock_mutex(self).map_err(|e| self.clock_failed(e))
    }
    fn leave_once(&mut self) -> Result<(), &'static str> {
        once::leave_clock_mutex(self).map_err(|e| self.clock_failed(e))
    }
}
impl<N: startup::Network + Send + 'static> once::Boundary for Backend<N> {
    fn word(&mut self, p: u32) -> Result<u32, &'static str> { self.clock_read(p, 4) }
    fn byte(&mut self, p: u32) -> Result<u8, &'static str> { self.clock_read(p, 1).map(|v| v as u8) }
    fn put_word(&mut self, p: u32, value: u32) -> Result<(), &'static str> { self.clock_write(p, 4, value) }
    fn put_byte(&mut self, p: u32, value: u8) -> Result<(), &'static str> { self.clock_write(p, 1, value as u32) }
    fn exchange(&mut self, p: u32, value: u32) -> Result<u32, &'static str> { self.mutate(p, |_| value) }
    fn sleep(&mut self, milliseconds: u32) -> Result<(), &'static str> { self.clock_preflight()?; unsafe { Sleep(milliseconds) }; Ok(()) }
    fn initialize_outer(&mut self, function: u32, p: u32, spin: u32, flags: Option<u32>) -> Result<u32, &'static str> {
        if (function == 0) != flags.is_none() { return Err("clock critical-section dispatch mismatch"); }
        self.shared.bridge.clock_validate_cs_dispatch(function).map_err(|e| self.failure(e, "clock critical-section target invalid"))?;
        self.shared.locks.lock().map_err(|_| "lock bank poisoned")?.initialize(p, spin, flags).map_err(|e| self.failure(e, "clock critical-section initialization failed"))
    }
    fn enter_outer(&mut self, p: u32) -> Result<(), &'static str> {
        let section = self.shared.locks.lock().map_err(|_| "lock bank poisoned")?.section(p).map_err(|e| self.failure(e, "clock critical section missing"))?;
        let guard = section.enter(); self.held.push((p, guard)); Ok(())
    }
    fn leave_outer(&mut self, p: u32) -> Result<(), &'static str> {
        if self.held.last().map(|(p, _)| *p) != Some(p) { return Err("clock critical-section release order mismatch"); }
        drop(self.held.pop()); Ok(())
    }
    fn delete_outer(&mut self, p: u32) -> Result<(), &'static str> {
        self.shared.locks.lock().map_err(|_| "lock bank poisoned")?.delete(p).map_err(|e| self.failure(e, "clock critical-section retirement failed"))
    }
    fn calloc(&mut self, count: u32, size: u32) -> Result<u32, &'static str> {
        let span = count.checked_mul(size).ok_or("clock CRT allocation overflow")?;
        let p = self.shared.bridge.clock_crt_calloc(count, size).map_err(|e| self.failure(e, "clock CRT allocation failed"))?;
        if p != 0 {
            match self.shared.clock.lock() {
                Ok(mut state) => { state.allocations.insert(p, span); }
                Err(_) => {
                    let cleanup = self.shared.bridge.clock_crt_free(p);
                    return Err(self.failure(cleanup, "clock allocation ownership publication failed"));
                }
            }
        }
        Ok(p)
    }
    fn free(&mut self, p: u32) -> Result<(), &'static str> {
        let physical = {
            let state = self.shared.clock.lock().map_err(|_| "clock host state poisoned")?;
            if !state.allocations.contains_key(&p) && !state.pending_mirrors.contains(&p) { return Err("clock cannot free an unowned CRT allocation"); }
            state.allocations.contains_key(&p)
        };
        if physical {
            self.shared.bridge.clock_crt_release(p).map_err(|e| self.failure(e, "clock CRT free failed"))?;
            let mut state = self.shared.clock.lock().map_err(|_| "clock host state poisoned")?;
            state.allocations.remove(&p); state.pending_mirrors.insert(p);
        }
        // A failed mirror retirement is retried without a second HeapFree.
        #[cfg(test)] {
            let mut state = self.shared.clock.lock().map_err(|_| "clock host state poisoned")?;
            if state.fail_retirement { state.fail_retirement = false; return Err("injected clock mirror retirement failure"); }
        }
        self.shared.bridge.clock_crt_retire().map_err(|e| self.failure(e, "clock CRT mirror retirement failed"))?;
        self.shared.clock.lock().map_err(|_| "clock host state poisoned")?.pending_mirrors.remove(&p); Ok(())
    }
    fn register_atexit(&mut self, callback: u32) -> Result<u32, &'static str> {
        if ![once::OUTER_CLEANUP, once::MUTEX_CLEANUP].contains(&callback) { return Err("unknown clock atexit callback"); }
        self.shared.clock.lock().map_err(|_| "clock host state poisoned")?.callbacks.push(callback); Ok(0)
    }
    fn current_thread_id(&mut self) -> Result<u32, &'static str> { Ok(unsafe { GetCurrentThreadId() }) }
    fn inner_lock(&mut self, p: u32) -> Result<(), &'static str> {
        let lock = {
            let mut state = self.shared.clock.lock().map_err(|_| "clock host state poisoned")?;
            if state.allocations.get(&p.wrapping_sub(4)) != Some(&44) { return Err("clock mutex is outside its owned CRT allocation"); }
            state.inner.entry(p).or_insert_with(|| Arc::new(fifo::FifoMutex::default())).clone()
        };
        lock.enter().map_err(|e| self.failure(e, "clock FIFO acquisition failed"))
    }
    fn inner_unlock(&mut self, p: u32) -> Result<(), &'static str> {
        let lock = self.shared.clock.lock().map_err(|_| "clock host state poisoned")?.inner.get(&p).cloned().ok_or("clock FIFO mutex missing")?;
        lock.leave().map_err(|e| self.failure(e, "clock FIFO release failed"))
    }
    fn retire_inner(&mut self, p: u32) -> Result<(), &'static str> {
        let mut state = self.shared.clock.lock().map_err(|_| "clock host state poisoned")?;
        if let Some(lock) = state.inner.get(&p) {
            lock.close().map_err(|e| self.failure(e, "clock FIFO retirement failed"))?;
            let snapshot = lock.snapshot().map_err(|e| self.failure(e, "clock FIFO retirement snapshot failed"))?;
            state.retired.push(snapshot); state.inner.remove(&p);
        }
        Ok(())
    }
}
fn snapshot<N: startup::Network + Send + 'static>(shared: &Arc<Shared<N>>) -> Result<ProcessClockSnapshot, String> {
        let _launch = shared.launch.lock().map_err(|_| "launch lock poisoned")?;
        let mut bank = shared.bank.lock().map_err(|_| "engine bank poisoned")?;
        let mut word = |p| bank.memory.word(p).map_err(|e| format!("process clock snapshot: {e:?}"));
        let initialized = word(clock::ONCE_READY)? != 0;
        let origin = u64::from(word(clock::ORIGIN)?) | u64::from(word(clock::ORIGIN + 4)?) << 32;
        let frequency = u64::from(word(clock::FREQUENCY)?) | u64::from(word(clock::FREQUENCY + 4)?) << 32;
        drop(bank);
        let state = shared.clock.lock().map_err(|_| "clock host state poisoned")?;
        let mut events = state.retired.clone();
        for lock in state.inner.values() { events.push(lock.snapshot().map_err(|e| format!("clock FIFO snapshot: {e:?}"))?); }
        Ok(ProcessClockSnapshot { initialized, origin, frequency, qpf_calls: state.qpf, qpc_calls: state.qpc,
            crt_allocations: state.allocations.len(), pending_mirrors: state.pending_mirrors.len(), inner_mutexes: state.inner.len(), registered_cleanups: state.callbacks.clone(),
            events_created: events.iter().map(|s| s.events_created).sum(), events_closed: events.iter().map(|s| s.events_closed).sum(),
            event_close_failures: events.iter().map(|s| s.close_failures).sum(), failure: state.failure.clone() })
}
impl<N: startup::Network + Send + 'static> Runtime<N> {
    pub fn process_clock_snapshot(&self) -> Result<ProcessClockSnapshot, String> { snapshot(&self.shared) }
}
impl<N: startup::Network + Send + 'static> ClockHandle<N> {
    /// Read-only storage remains observable after shutdown; this performs no QPC.
    pub fn process_clock_snapshot(&self) -> Result<ProcessClockSnapshot, String> { snapshot(&self.shared) }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::{thread, time::{Duration, Instant}};
    #[test]
    fn audio_process_clock_actual_concurrent_backend_samples_share_once_and_retire_all_windows_owners() {
        let mut owner = crate::audio_replay_windows_application::Application::new().unwrap();
        let r = owner.transport().unwrap(); let handle = r.clock_handle().unwrap();
        let before = r.process_clock_snapshot().unwrap();
        assert!(!before.initialized); assert_eq!((before.qpf_calls, before.qpc_calls, before.crt_allocations), (0, 0, 0));
        let first = handle.raw_clock_sample().unwrap(); assert!(first.frequency > 0);
        let mut backend = Backend::new(r.shared.clone());
        once::prepare_and_enter_clock_mutex(&mut backend).unwrap();
        let p = backend.clock_read(once::MUTEX_POINTER, 4).unwrap();
        let lock = r.shared.clock.lock().unwrap().inner[&(p + 4)].clone();
        let mut workers = Vec::new();
        for _ in 0..8 {
            let shared = r.shared.clone();
            workers.push(thread::spawn(move || {
                // The enclosing test owns Application until all workers join.
                // Internal callbacks enter the same source once without launch.
                let mut b = Backend::new(shared); let mut prior = 0;
                for _ in 0..32 {
                    let sample = b.raw_clock_sample().unwrap();
                    assert_eq!((sample.origin, sample.frequency), (first.origin, first.frequency));
                    assert!(sample.counter >= prior); prior = sample.counter;
                    assert!(f32::from_bits(sample.f32_bits().unwrap()).is_finite());
                }
            }));
        }
        let deadline = Instant::now() + Duration::from_secs(5);
        while lock.snapshot().unwrap().queued != 8 { assert!(Instant::now() < deadline, "clock participants did not queue"); thread::yield_now(); }
        once::leave_clock_mutex(&mut backend).unwrap();
        for worker in workers { worker.join().unwrap(); }
        drop(lock); drop(backend);
        let live = r.process_clock_snapshot().unwrap();
        assert_eq!((live.qpf_calls, live.qpc_calls, live.crt_allocations, live.inner_mutexes), (1, 258, 1, 1));
        assert!(live.events_created >= 8); assert_eq!(live.events_created, live.events_closed);
        assert_eq!(live.registered_cleanups, [once::OUTER_CLEANUP, once::MUTEX_CLEANUP]);
        assert!(live.failure.is_none()); owner.close().unwrap();
        let closed = handle.process_clock_snapshot().unwrap();
        assert_eq!((closed.crt_allocations, closed.inner_mutexes, closed.event_close_failures), (0, 0, 0));
        assert!(closed.registered_cleanups.is_empty()); assert_eq!(closed.events_created, closed.events_closed);
        assert_eq!((closed.origin, closed.frequency, closed.qpf_calls, closed.qpc_calls), (first.origin, first.frequency, 1, 258));
        assert!(handle.raw_clock_sample().is_err()); assert_eq!(closed, handle.process_clock_snapshot().unwrap());
        let diagnostic = owner.diagnostic().unwrap(); assert_eq!(diagnostic["crt"]["heap_blocks"], 0); assert_eq!(diagnostic["crt"]["retained_mirrors"], 0);
        assert_eq!(diagnostic["crt"]["heap_allocations"], diagnostic["crt"]["heap_frees"]);
    }
    #[test]
    fn audio_process_clock_bad_callback_releases_once_and_rejects_reuse_before_os_sampling() {
        let mut owner = crate::audio_replay_windows_application::Application::new().unwrap();
        let r = owner.transport().unwrap(); let handle = r.clock_handle().unwrap();
        r.shared.bank.lock().unwrap().memory.write_word(clock::CALLBACK_VTABLE, 0x12345678).unwrap();
        assert!(handle.raw_clock_sample().is_err());
        let failed = handle.process_clock_snapshot().unwrap();
        assert!(!failed.initialized); assert!(failed.failure.is_some()); assert_eq!((failed.qpf_calls, failed.qpc_calls), (0, 0));
        r.shared.bank.lock().unwrap().memory.write_word(clock::CALLBACK_VTABLE, clock::CALLBACK).unwrap();
        assert!(handle.raw_clock_sample().is_err());
        assert_eq!(failed, handle.process_clock_snapshot().unwrap());
        owner.close().unwrap(); let closed = handle.process_clock_snapshot().unwrap();
        assert_eq!((closed.crt_allocations, closed.inner_mutexes), (0, 0)); assert!(closed.registered_cleanups.is_empty());
    }
    #[test]
    fn audio_process_clock_shutdown_retries_mirror_retirement_without_double_heap_free() {
        let mut owner = crate::audio_replay_windows_application::Application::new().unwrap();
        let r = owner.transport().unwrap(); let handle = r.clock_handle().unwrap(); handle.raw_clock_sample().unwrap();
        r.shared.clock.lock().unwrap().fail_retirement = true;
        assert!(r.shutdown().is_err());
        let partial = handle.process_clock_snapshot().unwrap();
        assert_eq!((partial.crt_allocations, partial.pending_mirrors, partial.inner_mutexes), (0, 1, 0));
        assert!(handle.raw_clock_sample().is_err()); assert_eq!(partial, handle.process_clock_snapshot().unwrap());
        let before = owner.diagnostic().unwrap();
        assert_eq!(before["crt"]["retained_mirrors"], 1);
        owner.close().unwrap();
        let after = owner.diagnostic().unwrap(); assert_eq!(after["crt"]["retained_mirrors"], 0);
        // Only the application's initial CRT thread record is freed by close.
        assert_eq!(after["crt"]["heap_frees"].as_u64().unwrap(), before["crt"]["heap_frees"].as_u64().unwrap() + 1);
        assert_eq!(after["crt"]["heap_allocations"], after["crt"]["heap_frees"]);
        let closed = handle.process_clock_snapshot().unwrap(); assert_eq!((closed.crt_allocations, closed.pending_mirrors, closed.inner_mutexes), (0, 0, 0));
        assert!(closed.registered_cleanups.is_empty());
    }
}
