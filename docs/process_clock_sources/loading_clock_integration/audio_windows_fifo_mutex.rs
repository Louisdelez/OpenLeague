//! OS-thread adapter for ConCRT's blocking FIFO acquisition contract.
//! Native type/owner/depth storage belongs to the caller. ConCRT scheduler,
//! stack nodes and fiber contexts are deliberately not represented as PE bytes.
use std::{collections::VecDeque, ffi::c_void, sync::{Arc, Mutex, atomic::{AtomicUsize, Ordering}}};

#[link(name = "kernel32")]
unsafe extern "system" {
    fn CreateEventW(attributes: *const c_void, manual: i32, initial: i32, name: *const u16) -> *mut c_void;
    fn SetEvent(event: *mut c_void) -> i32;
    fn WaitForSingleObject(handle: *mut c_void, milliseconds: u32) -> u32;
    fn CloseHandle(handle: *mut c_void) -> i32;
    fn GetCurrentThreadId() -> u32;
    fn GetLastError() -> u32;
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub enum Error { Poisoned, Closed, Recursive, NotOwner, Busy, Windows(&'static str, u32), InvalidHandoff, Aborted(Box<Error>), Cleanup(Box<Error>, Box<Error>) }
#[derive(Default)]
struct Counters { created: AtomicUsize, closed: AtomicUsize, close_failures: AtomicUsize }
struct Event { handle: usize, counters: Arc<Counters> }
impl Event {
    fn new(counters: Arc<Counters>) -> Result<Self, Error> {
        let handle = unsafe { CreateEventW(std::ptr::null(), 0, 0, std::ptr::null()) };
        if handle.is_null() { return Err(Error::Windows("CreateEventW", unsafe { GetLastError() })); }
        counters.created.fetch_add(1, Ordering::Relaxed);
        Ok(Self { handle: handle as usize, counters })
    }
    fn signal(&self) -> Result<(), Error> {
        if unsafe { SetEvent(self.handle as *mut c_void) } == 0 { Err(Error::Windows("SetEvent", unsafe { GetLastError() })) } else { Ok(()) }
    }
    fn wait(&self) -> Result<bool, Error> {
        // Bounded observation permits error propagation even when SetEvent itself
        // fails. This is not a source acquisition timeout: normal waits continue.
        match unsafe { WaitForSingleObject(self.handle as *mut c_void, 100) } {
            0 => Ok(true),
            258 => Ok(false),
            u32::MAX => Err(Error::Windows("WaitForSingleObject", unsafe { GetLastError() })),
            result => Err(Error::Windows("unexpected event wait result", result)),
        }
    }
}
impl Drop for Event {
    fn drop(&mut self) {
        if unsafe { CloseHandle(self.handle as *mut c_void) } != 0 { self.counters.closed.fetch_add(1, Ordering::Relaxed); }
        else { self.counters.close_failures.fetch_add(1, Ordering::Relaxed); }
    }
}
struct Waiter { thread: u32, event: Arc<Event> }
#[derive(Default)]
struct State { owner: Option<u32>, queue: VecDeque<Waiter>, closed: bool, failure: Option<Error>, #[cfg(test)] fail_signal: bool }
#[derive(Default)]
pub struct FifoMutex { state: Mutex<State>, counters: Arc<Counters> }
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Snapshot { pub owner: Option<u32>, pub queued: usize, pub closed: bool, pub events_created: usize, pub events_closed: usize, pub close_failures: usize }
impl FifoMutex {
    pub fn enter(&self) -> Result<(), Error> {
        let thread = unsafe { GetCurrentThreadId() };
        let event = {
            let mut state = self.state.lock().map_err(|_| Error::Poisoned)?;
            if state.closed { return Err(Error::Closed); }
            if let Some(e) = &state.failure { return Err(Error::Aborted(Box::new(e.clone()))); }
            if state.owner == Some(thread) { return Err(Error::Recursive); }
            if state.owner.is_none() { state.owner = Some(thread); return Ok(()); }
            let event = Arc::new(Event::new(self.counters.clone())?);
            state.queue.push_back(Waiter { thread, event: event.clone() });
            event
        };
        // No bank/map/state mutex is held during the actual Windows wait.
        let waited = (|| {
            loop {
                let signaled = event.wait()?;
                let state = self.state.lock().map_err(|_| Error::Poisoned)?;
                if let Some(e) = &state.failure { return Err(Error::Aborted(Box::new(e.clone()))); }
                if signaled { return Ok(()); }
            }
        })();
        if let Err(primary) = waited {
            let cleanup = (|| {
                let mut state = self.state.lock().map_err(|_| Error::Poisoned)?;
                if state.owner == Some(thread) { Self::handoff(&mut state) }
                else {
                    if let Some(i) = state.queue.iter().position(|w| Arc::ptr_eq(&w.event, &event)) { state.queue.remove(i); }
                    Ok(())
                }
            })();
            return Err(match cleanup { Ok(()) => primary, Err(e) => Error::Cleanup(Box::new(primary), Box::new(e)) });
        }
        let state = self.state.lock().map_err(|_| Error::Poisoned)?;
        if state.owner != Some(thread) { return Err(Error::InvalidHandoff); }
        Ok(())
    }
    fn handoff(state: &mut State) -> Result<(), Error> {
        if let Some(next) = state.queue.front() {
            #[cfg(test)]
            let signal = if state.fail_signal { state.fail_signal = false; Err(Error::Windows("SetEvent injected", 6)) } else { next.event.signal() };
            #[cfg(not(test))]
            let signal = next.event.signal();
            if let Err(error) = signal {
                // Native owner/depth has already been released. Wake failures
                // abort all queued acquisitions; each observes failure within
                // the bounded wait above, removes itself and closes its event.
                state.owner = None; state.failure = Some(error.clone()); return Err(error);
            }
            state.owner = Some(next.thread);
            state.queue.pop_front();
        } else { state.owner = None; }
        Ok(())
    }
    pub fn leave(&self) -> Result<(), Error> {
        let mut state = self.state.lock().map_err(|_| Error::Poisoned)?;
        if state.closed { return Err(Error::Closed); }
        if state.owner != Some(unsafe { GetCurrentThreadId() }) { return Err(Error::NotOwner); }
        Self::handoff(&mut state)
    }
    /// Runtime shutdown is serialized after all workers/callbacks stop. Reject
    /// destroying a live wait instead of closing a handle under Windows' wait.
    pub fn close(&self) -> Result<(), Error> {
        let mut state = self.state.lock().map_err(|_| Error::Poisoned)?;
        if state.owner.is_some() || !state.queue.is_empty() { return Err(Error::Busy); }
        state.closed = true;
        Ok(())
    }
    pub fn snapshot(&self) -> Result<Snapshot, Error> {
        let state = self.state.lock().map_err(|_| Error::Poisoned)?;
        Ok(Snapshot { owner: state.owner, queued: state.queue.len(), closed: state.closed,
            events_created: self.counters.created.load(Ordering::Relaxed), events_closed: self.counters.closed.load(Ordering::Relaxed), close_failures: self.counters.close_failures.load(Ordering::Relaxed) })
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::{sync::mpsc, thread, time::{Duration, Instant}};
    #[test]
    fn audio_windows_fifo_mutex_real_contention_preserves_queue_and_retires_every_event() {
        let lock = Arc::new(FifoMutex::default()); lock.enter().unwrap();
        let (tx, rx) = mpsc::channel(); let mut threads = vec![];
        for index in 0..16 {
            let lock = lock.clone(); let tx = tx.clone(); let observing = lock.clone();
            threads.push(thread::spawn(move || { lock.enter().unwrap(); tx.send(index).unwrap(); lock.leave().unwrap(); }));
            let deadline = Instant::now() + Duration::from_secs(5);
            while observing.snapshot().unwrap().queued != index + 1 { assert!(Instant::now() < deadline, "waiter did not enter queue"); thread::yield_now(); }
        }
        assert_eq!(lock.close(), Err(Error::Busy)); lock.leave().unwrap();
        for index in 0..16 { assert_eq!(rx.recv_timeout(Duration::from_secs(5)).unwrap(), index); }
        for t in threads { t.join().unwrap(); }
        lock.close().unwrap(); let s = lock.snapshot().unwrap();
        assert_eq!((s.owner, s.queued, s.events_created, s.events_closed, s.close_failures), (None, 0, 16, 16, 0));
        assert_eq!(lock.enter(), Err(Error::Closed));
    }
    #[test]
    fn audio_windows_fifo_mutex_real_threads_exclude_each_other_and_reject_wrong_owner() {
        let lock = Arc::new(FifoMutex::default()); lock.enter().unwrap();
        assert_eq!(lock.enter(), Err(Error::Recursive));
        let other = lock.clone(); assert_eq!(thread::spawn(move || other.leave()).join().unwrap(), Err(Error::NotOwner));
        lock.leave().unwrap();
        let active = Arc::new(AtomicUsize::new(0)); let count = Arc::new(AtomicUsize::new(0)); let mut threads = vec![];
        for _ in 0..8 {
            let (lock, active, count) = (lock.clone(), active.clone(), count.clone());
            threads.push(thread::spawn(move || for _ in 0..128 {
                lock.enter().unwrap(); assert_eq!(active.fetch_add(1, Ordering::SeqCst), 0);
                thread::yield_now(); count.fetch_add(1, Ordering::SeqCst);
                assert_eq!(active.fetch_sub(1, Ordering::SeqCst), 1); lock.leave().unwrap();
            }));
        }
        for t in threads { t.join().unwrap(); }
        assert_eq!(count.load(Ordering::SeqCst), 1024); lock.close().unwrap();
        let s = lock.snapshot().unwrap(); assert_eq!(s.events_created, s.events_closed); assert_eq!(s.close_failures, 0);
    }
    #[test]
    fn audio_windows_fifo_mutex_signal_failure_unblocks_all_real_waiters_without_retrying_native_unlock() {
        let lock = Arc::new(FifoMutex::default()); lock.enter().unwrap(); let mut workers = vec![];
        for _ in 0..4 { let other = lock.clone(); workers.push(thread::spawn(move || other.enter())); }
        let deadline = Instant::now() + Duration::from_secs(5);
        while lock.snapshot().unwrap().queued != 4 { assert!(Instant::now() < deadline); thread::yield_now(); }
        lock.state.lock().unwrap().fail_signal = true;
        assert_eq!(lock.leave(), Err(Error::Windows("SetEvent injected", 6)));
        for worker in workers { assert!(matches!(worker.join().unwrap(), Err(Error::Aborted(_)))); }
        assert!(matches!(lock.enter(), Err(Error::Aborted(_)))); lock.close().unwrap();
        let s = lock.snapshot().unwrap(); assert_eq!((s.owner, s.queued, s.events_created, s.events_closed, s.close_failures), (None, 0, 4, 4, 0));
    }
}
