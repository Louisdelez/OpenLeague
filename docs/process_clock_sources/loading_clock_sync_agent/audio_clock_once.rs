//! Source CE5247/CE2961/CE290B/CE2934 once synchronization.
//! The private ConCRT queue is an explicit service, not emulated by these bytes.
//! No clock, epoch, frequency cache or process-global host singleton is created.

pub const OUTER_STATE: u32 = 0x14b1840;
pub const OUTER_SECTION: u32 = 0x14b1844;
pub const MUTEX_READY: u32 = 0x14af61c;
pub const MUTEX_POINTER: u32 = 0x14af620;
pub const OUTER_CLEANUP: u32 = 0xce52c1;
pub const MUTEX_CLEANUP: u32 = 0xce2955;
pub const CLOCK_FLAG: u32 = 0x2d75530;
pub const COOKIE: u32 = 0x1222ed0;
pub const CS_DISPATCH: u32 = 0x2da5310;

#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    Boundary(&'static str),
    AddressOverflow,
    UnsupportedMutexType(u32),
    /// Original CE2961 would invoke nonreturning CE13ED on calloc failure.
    NativeFatalMutexAllocation,
    Cleanup { action: Box<Error>, cleanup: Box<Error> },
}
impl From<&'static str> for Error { fn from(v: &'static str) -> Self { Self::Boundary(v) } }

/// Every method acts on the same canonical bank. Blocking services must not
/// retain its non-reentrant map mutex while another participant needs the bank.
/// Failed word/byte writes must leave that destination unchanged. Source-memory
/// validation is performed before mutation; partial writes cannot be rolled back.
pub trait Boundary {
    fn word(&mut self, address: u32) -> Result<u32, &'static str>;
    fn byte(&mut self, address: u32) -> Result<u8, &'static str>;
    fn put_word(&mut self, address: u32, value: u32) -> Result<(), &'static str>;
    fn put_byte(&mut self, address: u32, value: u8) -> Result<(), &'static str>;
    /// Must be one atomic RMW on the canonical word, with full ordering.
    fn exchange(&mut self, address: u32, value: u32) -> Result<u32, &'static str>;
    fn sleep(&mut self, milliseconds: u32) -> Result<(), &'static str>;
    /// Source CABD7A. function=0 selects legacy API, flags=None; otherwise Ex.
    /// Native ignores the integer BOOL; an unavailable host primitive must err.
    fn initialize_outer(&mut self, function: u32, address: u32, spin: u32, flags: Option<u32>) -> Result<u32, &'static str>;
    fn enter_outer(&mut self, address: u32) -> Result<(), &'static str>;
    fn leave_outer(&mut self, address: u32) -> Result<(), &'static str>;
    fn delete_outer(&mut self, address: u32) -> Result<(), &'static str>;
    /// Calls the existing original CRT calloc/free adapters, not the engine new.
    fn calloc(&mut self, count: u32, size: u32) -> Result<u32, &'static str>;
    fn free(&mut self, address: u32) -> Result<(), &'static str>;
    /// Preserve atexit publication order; the source ignores its integer result.
    fn register_atexit(&mut self, callback: u32) -> Result<u32, &'static str>;
    fn current_thread_id(&mut self) -> Result<u32, &'static str>;
    /// CBEE12 contract for CE2702/type1: indefinite, non-recursive acquisition.
    /// FIFO among live queued nodes; owner recursion is handled before this call.
    /// The source inner bytes belong to ConCRT; a host adaptation must be declared.
    fn inner_lock(&mut self, address: u32) -> Result<(), &'static str>;
    /// CBEEED: release current owner; handoff to one next live queued participant.
    fn inner_unlock(&mut self, address: u32) -> Result<(), &'static str>;
    /// Source5642D0 is RET. A host adaptation needs real lifetime retirement here.
    /// It must reject destruction while held/queued and never free waiter storage.
    fn retire_inner(&mut self, address: u32) -> Result<(), &'static str>;
}
fn add(p: u32, offset: u32) -> Result<u32, Error> { p.checked_add(offset).ok_or(Error::AddressOverflow) }
fn finish<T>(action: Result<T, Error>, cleanup: Result<(), Error>) -> Result<T, Error> {
    match (action, cleanup) {
        (Ok(v), Ok(())) => Ok(v),
        (Err(e), Ok(())) | (Ok(_), Err(e)) => Err(e),
        (Err(action), Err(cleanup)) => Err(Error::Cleanup { action: Box::new(action), cleanup: Box::new(cleanup) }),
    }
}

/// CE5247. State 0/1/2, XCHG, Sleep(1), registration, flag-byte publication.
/// The host Result cleanup is an explicit extension; native SEH is not claimed.
pub fn outer_once<B: Boundary>(b: &mut B, flag: u32, callback: impl FnOnce(&mut B) -> Result<(), Error>) -> Result<(), Error> {
    if b.word(OUTER_STATE)? != 2 {
        let previous = b.exchange(OUTER_STATE, 1)?;
        if previous == 0 {
            let function = b.word(CS_DISPATCH)? ^ b.word(COOKIE)?;
            let _ = b.initialize_outer(function, OUTER_SECTION, 4000, if function == 0 { None } else { Some(0) })?;
            let _ = b.register_atexit(OUTER_CLEANUP)?;
            b.put_word(OUTER_STATE, 2)?;
        } else if previous == 2 {
            // The initial load raced with publication; XCHG temporarily wrote1.
            b.put_word(OUTER_STATE, 2)?;
        } else {
            while b.word(OUTER_STATE)? != 2 { b.sleep(1)?; }
        }
    }
    b.enter_outer(OUTER_SECTION)?;
    let action = (|| {
        if b.byte(flag)? == 0 { callback(b)?; b.put_byte(flag, 1)?; }
        Ok(())
    })();
    let cleanup = b.leave_outer(OUTER_SECTION).map_err(Error::from);
    finish(action, cleanup)
}

/// CE28CF and CBE86C. Exact PE32 public layout and source write order.
/// Native calloc failure returns1 after clearing the destination; it does not throw.
pub fn allocate_mutex(b: &mut impl Boundary, destination: u32, kind: u32) -> Result<u32, Error> {
    b.put_word(destination, 0)?;
    let object = b.calloc(1, 44)?;
    if object == 0 { return Ok(1); }
    let action = (|| {
        let inner = add(object, 4)?;
        for offset in [0x18, 0x1c, 0, 4, 0x0c] { b.put_word(add(inner, offset)?, 0)?; }
        b.put_word(add(inner, 8)?, 2)?;
        for offset in [0x10, 0x14] { b.put_word(add(inner, offset)?, 0)?; }
        b.put_word(add(object, 0x24)?, u32::MAX)?;
        b.put_word(object, kind)?;
        b.put_word(destination, object)?;
        Ok(0)
    })();
    if action.is_err() { let cleanup = b.free(object).map_err(Error::from); finish(action, cleanup) } else { action }
}

/// CE2961. The nonreturning CRT fatal path stays an explicit error.
pub fn initialize_clock_mutex(b: &mut impl Boundary) -> Result<(), Error> {
    if allocate_mutex(b, MUTEX_POINTER, 1)? != 0 { return Err(Error::NativeFatalMutexAllocation); }
    let _ = b.register_atexit(MUTEX_CLEANUP)?;
    Ok(())
}

/// CE2702 type1 branch, selected by CE290B with timeout=null.
/// Source accepts type1|0x100 as the same branch. Other mutex types are explicit.
pub fn enter_mutex(b: &mut impl Boundary, pointer: u32) -> Result<(), Error> {
    let object = b.word(pointer)?;
    let kind = b.word(object)?;
    if kind & !0x100 != 1 { return Err(Error::UnsupportedMutexType(kind)); }
    let mut acquired = false;
    let mut restore_owner = None;
    let action = (|| {
        let thread = b.current_thread_id()?;
        if b.word(add(object, 0x24)?)? != thread {
            b.inner_lock(add(object, 4)?)?;
            acquired = true;
            // Source reads thread and destination again after potentially blocking.
            let thread = b.current_thread_id()?;
            let current = b.word(pointer)?;
            let owner = add(current, 0x24)?;
            let previous = b.word(owner)?;
            b.put_word(owner, thread)?;
            restore_owner = Some((owner, previous));
        }
        let current = b.word(pointer)?;
        let depth = add(current, 0x28)?;
        let value = b.word(depth)?.wrapping_add(1);
        b.put_word(depth, value)?;
        Ok(())
    })();
    if action.is_err() && acquired {
        // Host Result rollback only: preserve the owner visible immediately after
        // acquisition, release this invocation's lock, and retain both errors.
        let restore = if let Some((address, value)) = restore_owner { b.put_word(address, value).map_err(Error::from) } else { Ok(()) };
        let unlock = b.inner_unlock(add(object, 4)?).map_err(Error::from);
        return finish(action, finish(restore, unlock));
    }
    action
}

/// CE2934. No invented ownership check; host inner_unlock validates its contract.
pub fn leave_mutex(b: &mut impl Boundary, pointer: u32) -> Result<(), Error> {
    let object = b.word(pointer)?;
    let depth = add(object, 0x28)?;
    let value = b.word(depth)?.wrapping_sub(1);
    b.put_word(depth, value)?;
    if value == 0 {
        let object = b.word(pointer)?;
        b.put_word(add(object, 0x24)?, u32::MAX)?;
        let object = b.word(pointer)?;
        b.inner_unlock(add(object, 4)?)?;
    }
    Ok(())
}

/// The generic clock owns CE298A's supplied callback/flag logic between these.
pub fn prepare_and_enter_clock_mutex(b: &mut impl Boundary) -> Result<(), Error> {
    outer_once(b, MUTEX_READY, initialize_clock_mutex)?;
    enter_mutex(b, MUTEX_POINTER)
}
pub fn leave_clock_mutex(b: &mut impl Boundary) -> Result<(), Error> { leave_mutex(b, MUTEX_POINTER) }

/// CE289E, used by atexit CE2955. Native deliberately retains the stale pointer.
/// Caller shutdown must prevent further acquire and wait for all current users.
pub fn destroy_mutex(b: &mut impl Boundary, pointer: u32) -> Result<(), Error> {
    if pointer != 0 {
        let object = b.word(pointer)?;
        if object != 0 {
            b.retire_inner(add(object, 4)?)?;
            // Reload after the destructor boundary, as CE289E does.
            let object = b.word(pointer)?;
            b.free(object)?;
        }
    }
    Ok(())
}
pub fn dispatch_cleanup(b: &mut impl Boundary, callback: u32) -> Result<(), Error> {
    match callback {
        MUTEX_CLEANUP => destroy_mutex(b, MUTEX_POINTER),
        OUTER_CLEANUP => b.delete_outer(OUTER_SECTION).map_err(Error::from),
        _ => Err(Error::Boundary("unknown native clock once cleanup callback")),
    }
}

#[cfg(test)]
#[path="audio_clock_once_tests.rs"]
mod tests;
