//! Native8FC100 global transport worker,900E00 network startup and8FC500 release.
//! Native status is independent from the reference count: release leaves status2.
//! Callers must provide actual shared storage, locking and logging boundaries.
pub const STATUS: u32 = 0x2d78f04;
pub const REFERENCES: u32 = 0x2d78f10;
pub const MUTEX: u32 = 0x2d6ed50;
pub const COUNTERS: [u32; 5] = [0x2d78f0c, 0x2d78f08, 0x2d78f14, 0x2d78efc, 0x2d78f18];
pub const ALLOCATOR: u32 = 0x1225878;
pub const DEALLOCATOR: u32 = 0x122587c;
pub const FAILURE_MESSAGE: &str = "Net Status: Initialize failed: low-level init";

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Error { Boundary(&'static str), Cleanup { primary: Box<Error>, cleanup: Box<Error> } }
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Negotiation { pub code: u32, pub version: u16 }
pub trait Network {
    fn winsock_startup(&mut self, version: u16) -> Result<Negotiation, Error>;
    fn winsock_cleanup(&mut self) -> Result<u32, Error>;
    fn timer_begin(&mut self, period: u32) -> Result<u32, Error>;
    fn timer_end(&mut self, period: u32) -> Result<u32, Error>;
}
pub trait Backend: Network {
    fn read(&self, address: u32) -> Result<u32, Error>;
    fn write(&mut self, address: u32, value: u32) -> Result<(), Error>;
    /// Real atomic exchange, or an explicitly single-threaded qualification backend.
    fn exchange(&mut self, address: u32, value: u32) -> Result<u32, Error>;
    fn mutex(&mut self, address: u32, enter: bool) -> Result<(), Error>;
    /// Return the existing logger, or run its native901A70 initialization.
    fn logger(&mut self) -> Result<u32, Error>;
    fn log(&mut self, logger: u32, message: &str) -> Result<(), Error>;
}
fn locked<B: Backend, T>(b: &mut B, address: u32, action: impl FnOnce(&mut B) -> Result<T, Error>) -> Result<T, Error> {
    b.mutex(address, true)?;
    let result = action(b);
    let cleanup = b.mutex(address, false);
    match (result, cleanup) {
        (Ok(v), Ok(())) => Ok(v), (Err(e), Ok(())) | (Ok(_), Err(e)) => Err(e),
        (Err(primary), Err(cleanup)) => Err(Error::Cleanup { primary: Box::new(primary), cleanup: Box::new(cleanup) }),
    }
}
fn log<B: Backend>(b: &mut B, message: &str) -> Result<(), Error> {
    let logger = b.logger()?;
    locked(b, logger, |b| b.log(logger, message))
}
/// WSAStartup errors and version mismatches return FFFFFFFF. Native ignores the
/// return codes of timeBeginPeriod and mismatch WSACleanup, but calls both exactly.
pub fn network_startup(b: &mut impl Network) -> Result<u32, Error> {
    let negotiation = b.winsock_startup(0x202)?;
    if negotiation.code != 0 { return Ok(u32::MAX); }
    if negotiation.version != 0x202 { b.winsock_cleanup()?; return Ok(u32::MAX); }
    b.timer_begin(1)?;
    Ok(0)
}
pub fn worker(b: &mut impl Backend) -> Result<(), Error> {
    locked(b, MUTEX, |b| {
        if b.read(REFERENCES)? == 0 {
            for address in COUNTERS { b.write(address, 0)?; }
            b.write(ALLOCATOR, 0x8fcb90)?;
            b.write(DEALLOCATOR, 0x8fcc80)?;
            if network_startup(b)? != 0 {
                log(b, FAILURE_MESSAGE)?;
                b.exchange(STATUS, 3)?;
                return Ok(());
            }
        }
        let references = b.read(REFERENCES)?.wrapping_add(1);
        b.write(REFERENCES, references)?;
        b.exchange(STATUS, 2)?;
        Ok(())
    })
}
/// Preserves native wrapping decrement, including an invalid zero-owner release.
/// Lifetime owners must pair successful initialization and release themselves.
pub fn release(b: &mut impl Backend) -> Result<(), Error> {
    locked(b, MUTEX, |b| {
        let references = b.read(REFERENCES)?.wrapping_sub(1);
        b.write(REFERENCES, references)?;
        if references == 0 {
            b.timer_end(1)?;
            b.winsock_cleanup()?;
            // Format arguments follow native push order, with signed32-bit %d.
            let [current, total, maximum, outside, freed] = [
                b.read(0x2d78f0c)? as i32, b.read(0x2d78f14)? as i32,
                b.read(0x2d78f08)? as i32, b.read(0x2d78efc)? as i32,
                b.read(0x2d78f18)? as i32,
            ];
            let message = format!("Memory Allocations \n Current Allocations = {current} \n Total Allocations = {total} \n Max Allocations = {maximum} \n Out of Pool Allocations = {outside} \n Out of Pool dealloc = {freed} \n");
            log(b, &message)?;
        }
        Ok(())
    })
}

/// Actual host APIs; PE32 WSADATA is not cast to the host's wider layout.
#[cfg(windows)]
pub mod windows {
    use super::*;
    use std::ffi::c_char;
    #[repr(C)]
    struct Data {
        version: u16, high_version: u16,
        #[cfg(target_pointer_width = "64")] max_sockets: u16,
        #[cfg(target_pointer_width = "64")] max_datagram: u16,
        #[cfg(target_pointer_width = "64")] vendor: *mut c_char,
        description: [c_char; 257], status: [c_char; 129],
        #[cfg(target_pointer_width = "32")] max_sockets: u16,
        #[cfg(target_pointer_width = "32")] max_datagram: u16,
        #[cfg(target_pointer_width = "32")] vendor: *mut c_char,
    }
    #[link(name = "ws2_32")]
    unsafe extern "system" { fn WSAStartup(version: u16, data: *mut Data) -> i32; fn WSACleanup() -> i32; }
    #[link(name = "winmm")]
    unsafe extern "system" { fn timeBeginPeriod(period: u32) -> u32; fn timeEndPeriod(period: u32) -> u32; }
    /// Tracks only references acquired through this instance. Drop balances any
    /// surviving host resources, without pretending the native globals changed.
    #[derive(Default)]
    pub struct WindowsNetwork { sockets: u32, timers: std::collections::BTreeMap<u32, u32> }
    impl WindowsNetwork {
        pub fn outstanding(&self) -> (u32, u32) { (self.sockets, self.timers.values().sum()) }
    }
    impl Network for WindowsNetwork {
        fn winsock_startup(&mut self, version: u16) -> Result<Negotiation, Error> {
            let mut data: Data = unsafe { std::mem::zeroed() };
            let code = unsafe { WSAStartup(version, &mut data) } as u32;
            if code == 0 { self.sockets += 1; }
            Ok(Negotiation { code, version: data.version })
        }
        fn winsock_cleanup(&mut self) -> Result<u32, Error> {
            if self.sockets == 0 { return Err(Error::Boundary("WSACleanup has no owned reference")); }
            let code = unsafe { WSACleanup() } as u32;
            if code == 0 { self.sockets -= 1; }
            Ok(code)
        }
        fn timer_begin(&mut self, period: u32) -> Result<u32, Error> {
            let code = unsafe { timeBeginPeriod(period) };
            if code == 0 { *self.timers.entry(period).or_default() += 1; }
            Ok(code)
        }
        fn timer_end(&mut self, period: u32) -> Result<u32, Error> {
            // Native release calls timeEndPeriod even if timeBeginPeriod failed.
            let code = unsafe { timeEndPeriod(period) };
            if code == 0 { if let Some(count) = self.timers.get_mut(&period) { *count -= 1; if *count == 0 { self.timers.remove(&period); } } }
            Ok(code)
        }
    }
    impl Drop for WindowsNetwork {
        fn drop(&mut self) {
            for (&period, &count) in &self.timers { for _ in 0..count { unsafe { timeEndPeriod(period); } } }
            for _ in 0..self.sockets { unsafe { WSACleanup(); } }
        }
    }
}
#[cfg(test)]
#[path = "audio_replay_transport_startup_tests.rs"]
pub(crate) mod tests;
