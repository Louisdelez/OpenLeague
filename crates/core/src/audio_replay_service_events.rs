//! Source72B950 service notifications and metadata acquisition729C80.
//! The return contract is AL; unspecified upper EAX bits are not synthesized.
use crate::{
    audio_announcer_object_lookup as read,
    audio_announcer_registry_init::{self as init, Storage},
    audio_replay_events as events, audio_replay_game_manager as manager,
    audio_replay_shared_pair as pair,
};
#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    Read(read::Error),
    Write(init::Error),
    Pair(pair::Error),
    Manager(manager::Error),
    Boundary(&'static str),
    Overflow,
    UnconnectedEvent(u32),
    Cleanup {
        primary: Box<Error>,
        cleanup: Box<Error>,
    },
}
macro_rules! convert {
    ($t:ty,$v:ident) => {
        impl From<$t> for Error {
            fn from(e: $t) -> Self {
                Self::$v(e)
            }
        }
    };
}
convert!(read::Error, Read);
convert!(init::Error, Write);
convert!(pair::Error, Pair);
convert!(manager::Error, Manager);
fn add(p: u32, o: u32) -> Result<u32, Error> {
    p.checked_add(o).ok_or(Error::Overflow)
}
/// Source729C80. Output is fresh non-owning eight-byte temporary storage.
pub fn acquire_metadata<B: Storage + pair::Boundary>(
    b: &mut B,
    parent: u32,
    out: u32,
) -> Result<u32, Error> {
    b.write_word(out, 0)?;
    b.write_word(add(out, 4)?, 0)?;
    pair::copy(b, out, add(parent, 0x34)?)?;
    Ok(out)
}
/// Source branches3/4 and out-of-range events return AL0. Branch5 obtains the
/// canonical parent, temporarily retains its metadata, invokes vtable+5C with
/// context as a value, releases the reference and returns AL1. Other branches
/// require their real UI/network consumers and fail explicitly until connected.
pub fn notify<B: manager::Boundary + events::Boundary>(
    b: &mut B,
    _service: u32,
    event: u32,
    context: u32,
    scratch: u32,
) -> Result<u8, Error> {
    match event {
        1 | 2 => return Err(Error::UnconnectedEvent(event)),
        5 => {}
        _ => return Ok(0),
    }
    let parent = manager::get(b)?;
    acquire_metadata(b, parent, scratch)?;
    let action = (|| {
        let object = b.word(scratch)?;
        let vt = b.word(object)?;
        let member = b.word(add(vt, 0x5c)?)?;
        b.virtual_call(object, member, 0x5c, &[events::Argument::Word(context)])
            .map_err(Error::Boundary)?;
        Ok(1)
    })();
    let cleanup = pair::destroy(b, scratch).map_err(Error::Pair);
    match (action, cleanup) {
        (Ok(v), Ok(())) => Ok(v),
        (Err(e), Ok(())) | (Ok(_), Err(e)) => Err(e),
        (Err(primary), Err(cleanup)) => Err(Error::Cleanup {
            primary: Box::new(primary),
            cleanup: Box::new(cleanup),
        }),
    }
}
