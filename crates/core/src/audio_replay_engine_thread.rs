//! Native8A8B80/8A9040/8A8D40 engine thread and8A8F90 owning callback capsule.
//! Fresh24-byte names follow564AF0/564F30; this is not general string assignment.
use crate::audio_announcer_object_lookup as read;
use crate::audio_announcer_registry_init::{self as init, Storage};
use crate::audio_announcer_registry_remove as removal;
use crate::audio_replay_transport_thread as thread;
pub const CAPSULE_CALLBACK: u32 = 0x8a8f90;
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Handle {
    pub handle: u32,
    pub id: u32,
}
#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    Read(read::Error),
    Write(init::Error),
    Free(removal::Error),
    Boundary(&'static str),
    AddressOverflow,
    InvalidLength,
    AllocationFailed(u32),
    Started {
        thread: Handle,
        error: Box<Error>,
    },
    Cleanup {
        primary: Box<Error>,
        cleanup: Box<Error>,
    },
}
impl From<read::Error> for Error {
    fn from(e: read::Error) -> Self {
        Self::Read(e)
    }
}
impl From<init::Error> for Error {
    fn from(e: init::Error) -> Self {
        Self::Write(e)
    }
}
impl From<removal::Error> for Error {
    fn from(e: removal::Error) -> Self {
        Self::Free(e)
    }
}
pub trait Boundary: thread::Boundary {
    /// Engine operator-new routing, distinct from9933E0 string allocations.
    fn allocate_engine(&mut self, bytes: u32) -> Result<u32, &'static str>;
    fn byte(&mut self, address: u32) -> Result<u8, &'static str>;
    fn initialize_critical_section(&mut self, address: u32) -> Result<(), &'static str>;
    /// C9C27C security0/stack0/flags0, callback8A8F90, argument=capsule.
    /// Return handle0 on Windows failure. Err guarantees no worker was started.
    /// On success the worker owns the capsule and invokes run_capsule exactly once.
    fn create_crt_worker(&mut self, callback: u32, capsule: u32) -> Result<Handle, &'static str>;
    fn name_current_thread(&mut self, name: u32) -> Result<(), &'static str>;
    fn invoke(&mut self, function: u32, argument: u32) -> Result<(), &'static str>;
}
fn add(a: u32, n: u32) -> Result<u32, Error> {
    a.checked_add(n).ok_or(Error::AddressOverflow)
}
fn put(b: &mut impl Boundary, p: u32, v: u32) -> Result<(), Error> {
    Ok(Storage::write_word(b, p, v)?)
}
fn free(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    let route = b.deallocator()?;
    Ok(b.free(p, route)?)
}
fn combine<T>(result: Result<T, Error>, cleanup: Result<(), Error>) -> Result<T, Error> {
    match (result, cleanup) {
        (Ok(v), Ok(())) => Ok(v),
        (Err(e), Ok(())) | (Ok(_), Err(e)) => Err(e),
        (Err(primary), Err(cleanup)) => Err(Error::Cleanup {
            primary: Box::new(primary),
            cleanup: Box::new(cleanup),
        }),
    }
}
pub fn initialize_name(b: &mut impl Boundary, name: u32) -> Result<(), Error> {
    put(b, add(name, 20)?, 15)?;
    put(b, add(name, 16)?, 0)?;
    b.write_byte(name, 0)?;
    Ok(())
}
/// Fresh capacity15/length0 destination, disjoint from source. Native allocation
/// retry/exception behavior is an explicit error, never a fabricated empty name.
pub fn copy_fresh_name(b: &mut impl Boundary, destination: u32, source: u32) -> Result<(), Error> {
    if b.word(add(destination, 20)?)? != 15 || b.word(add(destination, 16)?)? != 0 {
        return Err(Error::Boundary("name destination is not fresh"));
    }
    let length = b.word(add(source, 16)?)?;
    if length > u32::MAX - 1 {
        return Err(Error::InvalidLength);
    }
    if length > 15 {
        let rounded = length | 15;
        let capacity = if rounded > u32::MAX - 1 {
            length
        } else {
            rounded
        };
        let size = add(capacity, 1)?;
        let data = b.allocate(size)?;
        if data == 0 {
            return Err(Error::AllocationFailed(size));
        }
        b.write_byte(destination, 0)?;
        put(b, destination, data)?;
        put(b, add(destination, 20)?, capacity)?;
        put(b, add(destination, 16)?, 0)?;
        b.write_byte(data, 0)?;
    }
    let from = if b.word(add(source, 20)?)? >= 16 {
        b.word(source)?
    } else {
        source
    };
    let to = if b.word(add(destination, 20)?)? >= 16 {
        b.word(destination)?
    } else {
        destination
    };
    for i in 0..length {
        let value = b.byte(add(from, i)?).map_err(Error::Boundary)?;
        b.write_byte(add(to, i)?, value)?;
    }
    put(b, add(destination, 16)?, length)?;
    b.write_byte(add(to, length)?, 0)?;
    Ok(())
}
pub fn destroy_name(b: &mut impl Boundary, name: u32) -> Result<(), Error> {
    if b.word(add(name, 20)?)? >= 16 {
        let data = b.word(name)?;
        free(b, data)?;
    }
    initialize_name(b, name)
}
fn destroy_capsule(b: &mut impl Boundary, capsule: u32) -> Result<(), Error> {
    let result = destroy_name(b, add(capsule, 24)?);
    let cleanup = free(b, capsule);
    combine(result, cleanup)
}
fn capsule(
    b: &mut impl Boundary,
    function: u32,
    argument: u32,
    options: u32,
) -> Result<u32, Error> {
    let p = b.allocate_engine(48).map_err(Error::Boundary)?;
    if p == 0 {
        return Err(Error::AllocationFailed(48));
    }
    let mut named = false;
    let result = (|| {
        put(b, p, function)?;
        put(b, add(p, 4)?, argument)?;
        for offset in (0..16).step_by(4) {
            let value = b.word(add(options, offset)?)?;
            put(b, add(p, 8 + offset)?, value)?;
        }
        initialize_name(b, add(p, 24)?)?;
        named = true;
        copy_fresh_name(b, add(p, 24)?, add(options, 16)?)?;
        Ok(p)
    })();
    match result {
        Ok(p) => Ok(p),
        Err(e) => {
            let cleanup = if named {
                destroy_capsule(b, p)
            } else {
                free(b, p)
            };
            combine(Err(e), cleanup)
        }
    }
}
///8A8D40 in already-allocated80-byte storage. Windows opaque state is supplied
/// by its adapter, not copied from a host pointer into the PE32 object.
pub fn construct_at(
    b: &mut impl Boundary,
    object: u32,
    handle: Handle,
    options: u32,
) -> Result<u32, Error> {
    put(b, object, handle.handle)?;
    b.write_byte(add(object, 4)?, 1)?;
    put(b, add(object, 8)?, 0)?;
    b.initialize_critical_section(add(object, 12)?)
        .map_err(Error::Boundary)?;
    let mut named = false;
    let result = (|| {
        put(b, add(object, 0x24)?, handle.id)?;
        for offset in (0..16).step_by(4) {
            let value = b.word(add(options, offset)?)?;
            put(b, add(object, 0x28 + offset)?, value)?;
        }
        initialize_name(b, add(object, 0x38)?)?;
        named = true;
        copy_fresh_name(b, add(object, 0x38)?, add(options, 16)?)?;
        Ok(object)
    })();
    match result {
        Ok(p) => Ok(p),
        Err(e) => {
            let name_cleanup = if named {
                destroy_name(b, add(object, 0x38)?)
            } else {
                Ok(())
            };
            let section_cleanup = b
                .delete_critical_section(add(object, 12)?)
                .map_err(Error::Boundary);
            combine(Err(e), combine(name_cleanup, section_cleanup))
        }
    }
}
///8A8B80/8A9040 normal-return composition. Failure to create the Windows thread
/// frees its capsule and returns0. Post-start allocation errors retain the
/// started handle in the error so the caller can retire the live worker safely.
pub fn create(
    b: &mut impl Boundary,
    function: u32,
    argument: u32,
    options: u32,
) -> Result<u32, Error> {
    let capsule = capsule(b, function, argument, options)?;
    let handle = match b.create_crt_worker(CAPSULE_CALLBACK, capsule) {
        Ok(handle) => handle,
        Err(e) => {
            let cleanup = destroy_capsule(b, capsule);
            return combine(Err(Error::Boundary(e)), cleanup);
        }
    };
    if handle.handle == 0 {
        destroy_capsule(b, capsule)?;
        return Ok(0);
    }
    let result = (|| {
        let object = b.allocate_engine(80).map_err(Error::Boundary)?;
        if object == 0 {
            return Err(Error::AllocationFailed(80));
        }
        match construct_at(b, object, handle, options) {
            Ok(p) => Ok(p),
            Err(e) => {
                let cleanup = free(b, object);
                combine(Err(e), cleanup)
            }
        }
    })();
    result.map_err(|error| Error::Started {
        thread: handle,
        error: Box::new(error),
    })
}
///8A8F90 names the current thread before calling its cdecl function. An empty
/// name selects the16-byte tag instead. The callback's numeric result is ignored.
pub fn run_capsule(b: &mut impl Boundary, capsule: u32) -> Result<u32, Error> {
    let result = (|| {
        let options = add(capsule, 8)?;
        let string = add(options, 16)?;
        let name = if b.word(add(options, 32)?)? == 0 {
            options
        } else if b.word(add(string, 20)?)? >= 16 {
            b.word(string)?
        } else {
            string
        };
        b.name_current_thread(name).map_err(Error::Boundary)?;
        let function = b.word(capsule)?;
        let argument = b.word(add(capsule, 4)?)?;
        b.invoke(function, argument).map_err(Error::Boundary)?;
        Ok(0)
    })();
    let cleanup = destroy_capsule(b, capsule);
    combine(result, cleanup)
}
#[cfg(test)]
#[path = "audio_replay_engine_thread_tests.rs"]
pub(crate) mod tests;
