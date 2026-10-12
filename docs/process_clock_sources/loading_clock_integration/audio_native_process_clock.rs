//! Native993C70/993CE0 with the actual CE298A guard/callback/publication order.
//! CE5247/CE290B/CE2934 synchronization remains an explicit host boundary.
//! No Windows producer or private epoch is installed by this module.
pub const INITIALIZE: u32 = 0x993c70;
pub const SAMPLE: u32 = 0x993ce0;
pub const ORIGIN: u32 = 0x14bef48;
pub const FREQUENCY: u32 = 0x14bef50;
pub const CACHE_READY: u32 = 0x2d79080;
pub const CACHE: u32 = 0x2d79158;
pub const ONCE_READY: u32 = 0x2d75530;
pub const CALLBACK_VTABLE: u32 = 0x10de608;
pub const CALLBACK: u32 = 0x995850;

#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    Boundary(&'static str),
    UnknownCallback(u32),
    UnsupportedArchitecture,
    Cleanup { primary: Box<Error>, cleanup: Box<Error> },
}
impl From<&'static str> for Error { fn from(value: &'static str) -> Self { Self::Boundary(value) } }

/// Final two words present in the native API output buffer, even if BOOL is0.
/// Unknown untouched QPF bytes must be an error at the provider, never a guess.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Query { pub return_value: u32, pub words: [u32; 2] }

/// One observation from the canonical process clock. Consumers share the same
/// origin/frequency and this QPC result; pause and scale belong above this layer.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct RawSample {
    pub counter: u64,
    pub origin: u64,
    pub frequency: u64,
}
impl RawSample {
    pub fn f32_bits(self) -> Result<u32, Error> {
        divide_to_f32_bits(self.counter.wrapping_sub(self.origin), self.frequency)
    }
}

pub trait Boundary {
    fn word(&mut self, address: u32) -> Result<u32, &'static str>;
    fn byte(&mut self, address: u32) -> Result<u8, &'static str>;
    fn write_word(&mut self, address: u32, value: u32) -> Result<(), &'static str>;
    fn write_byte(&mut self, address: u32, value: u8) -> Result<(), &'static str>;
    /// Native QPF uses an uninitialized stack8. A successful full write supplies
    /// both words. Controlled partial/failure cases need explicit prior bytes.
    fn query_frequency(&mut self) -> Result<Query, &'static str>;
    /// Native QPC always starts with two zero words. Preserve unwritten bytes.
    fn query_counter(&mut self, initial_words: [u32; 2]) -> Result<Query, &'static str>;
    /// Implements CE5247(&14AF61C,CE2961), then CE290B(&14AF620), in that order.
    /// On Err, the host owns partial initialization/lock rollback. No lock is
    /// considered acquired by the caller until this method returns Ok.
    fn enter_once(&mut self) -> Result<(), &'static str> {
        Err("native clock once synchronization is not connected")
    }
    /// Implements CE2934(&14AF620), and reports failure without hiding it.
    fn leave_once(&mut self) -> Result<(), &'static str> {
        Err("native clock once synchronization is not connected")
    }
}

/// Original993C70. The source ignores both API BOOL values. Errors here mean
/// unavailable host observations, not a reinterpretation of native BOOL0.
pub fn initialize(b: &mut impl Boundary) -> Result<(), Error> {
    let [lo, hi] = if b.byte(CACHE_READY)? == 0 {
        let words = b.query_frequency()?.words;
        b.write_word(CACHE, words[0])?;
        b.write_word(CACHE + 4, words[1])?;
        b.write_byte(CACHE_READY, 1)?;
        words
    } else {
        // Source reads the high word before the low word on a cache hit.
        let hi = b.word(CACHE + 4)?;
        let lo = b.word(CACHE)?;
        [lo, hi]
    };
    b.write_word(FREQUENCY, lo)?;
    // Native zeroes the stack buffer between these two writes; it has no host
    // callback in between. The API receives the exact initial two words below.
    b.write_word(FREQUENCY + 4, hi)?;
    let query = b.query_counter([0, 0])?;
    b.write_word(ORIGIN, query.words[0])?;
    b.write_word(ORIGIN + 4, query.words[1])?;
    Ok(())
}

fn finish(action: Result<(), Error>, cleanup: Result<(), Error>) -> Result<(), Error> {
    match (action, cleanup) {
        (Ok(()), Ok(())) => Ok(()),
        (Err(e), Ok(())) | (Ok(()), Err(e)) => Err(e),
        (Err(primary), Err(cleanup)) => Err(Error::Cleanup { primary: Box::new(primary), cleanup: Box::new(cleanup) }),
    }
}

/// CE298A's clock-specialized body. Setup/lock are explicit boundaries, while
/// guard, virtual callback, publication and all host-error cleanup are real.
pub fn ensure_initialized(b: &mut impl Boundary) -> Result<(), Error> {
    b.enter_once()?;
    let action = (|| {
        if b.word(ONCE_READY)? == 0 {
            let target = b.word(CALLBACK_VTABLE)?;
            if target != CALLBACK { return Err(Error::UnknownCallback(target)); }
            initialize(b)?;
            b.write_word(ONCE_READY, 1)?;
        }
        Ok(())
    })();
    let cleanup = b.leave_once().map_err(Error::Boundary);
    finish(action, cleanup)
}

/// Native993CE0 followed directly by the consumer's FSTP f32. Qualified domain:
/// x87 CW037F. No intermediate f64 quotient; zero frequency yields native
/// masked-exception infinity/indefinite bits. Exception flags are not modeled.
pub fn sample_f32_bits(b: &mut impl Boundary) -> Result<u32, Error> {
    sample_raw(b)?.f32_bits()
}

/// Same source observation, retained as integers for consumers which apply the
/// original GameClock/TroyClock layers before their final floating-point store.
pub fn sample_raw(b: &mut impl Boundary) -> Result<RawSample, Error> {
    ensure_initialized(b)?;
    let words = b.query_counter([0, 0])?.words;
    let lo = b.word(ORIGIN)?;
    let hi = b.word(ORIGIN + 4)?;
    let current = u64::from(words[0]) | (u64::from(words[1]) << 32);
    let origin = u64::from(lo) | (u64::from(hi) << 32);
    // Source reads frequency high before low, after the final QPC callback.
    let hi = b.word(FREQUENCY + 4)?;
    let lo = b.word(FREQUENCY)?;
    Ok(RawSample { counter: current, origin, frequency: u64::from(lo) | (u64::from(hi) << 32) })
}

pub fn divide_to_f32_bits(elapsed: u64, frequency: u64) -> Result<u32, Error> {
    #[cfg(any(target_arch = "x86", target_arch = "x86_64"))]
    {
        let integers = [(elapsed & 0x7fff_ffff_ffff_ffff) as i64, (elapsed & 0x8000_0000_0000_0000) as i64,
                        (frequency & 0x7fff_ffff_ffff_ffff) as i64, (frequency & 0x8000_0000_0000_0000) as i64];
        let control = 0x037fu16;
        let mut saved = 0u16;
        let mut bits = 0u32;
        unsafe { core::arch::asm!(
            "fnstcw word ptr [{saved}]", "fldcw word ptr [{control}]",
            "fild qword ptr [{integers}]", "fild qword ptr [{integers}+8]", "fchs", "faddp st(1), st(0)",
            "fild qword ptr [{integers}+16]", "fild qword ptr [{integers}+24]", "fchs", "faddp st(1), st(0)",
            "fdivp st(1), st(0)", "fstp dword ptr [{bits}]", "fldcw word ptr [{saved}]",
            saved = in(reg) &mut saved, control = in(reg) &control, integers = in(reg) integers.as_ptr(),
            bits = in(reg) &mut bits, out("st(0)") _, out("st(1)") _, out("st(2)") _, options(nostack)); }
        Ok(bits)
    }
    #[cfg(not(any(target_arch = "x86", target_arch = "x86_64")))]
    { let _ = (elapsed, frequency); Err(Error::UnsupportedArchitecture) }
}

#[cfg(test)]
#[path = "audio_native_process_clock_tests.rs"]
mod tests;
