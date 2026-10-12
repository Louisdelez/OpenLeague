//! LoL4.20 replay callback734130, manager dispatcher729370 and metadata729D70.
//! Addresses are canonical resource labels. Terminal virtual methods are explicit
//! boundaries; this module does not invent actor, network or replay-file consumers.
use crate::audio_announcer_object_lookup::{self as lookup, Memory};
use crate::audio_announcer_registry_init::{self as init, Storage};

#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    Read(lookup::Error), Write(init::Error), AddressOverflow, NullObject,
    Boundary(&'static str), UnterminatedString,
}
impl From<lookup::Error> for Error { fn from(e: lookup::Error) -> Self { Self::Read(e) } }
impl From<init::Error> for Error { fn from(e: init::Error) -> Self { Self::Write(e) } }
fn add(a: u32, b: u32) -> Result<u32, Error> { a.checked_add(b).ok_or(Error::AddressOverflow) }

/// Stack word references and temporary native strings are passed as owned values
/// at the boundary. Their addresses cannot escape the native invocation either.
/// Byte strings retain their original encoding; no lossy UTF8 conversion occurs.
#[derive(Clone, Debug, PartialEq, Eq)]
pub enum Argument { Word(u32), WordRef(u32), String(Vec<u8>) }
pub trait Boundary: Storage {
    fn byte(&mut self, address: u32) -> Result<u8, lookup::Error>;
    fn virtual_call(&mut self, object: u32, callback: u32, slot: u32, args: &[Argument]) -> Result<u32, &'static str>;
    fn member_call(&mut self, object: u32, callback: u32, args: [u32; 5]) -> Result<u32, &'static str>;
}
fn virtual_call(b: &mut impl Boundary, object: u32, slot: u32, args: &[Argument]) -> Result<u32, Error> {
    if object == 0 { return Err(Error::NullObject); }
    let vt = b.word(object)?;
    let callback = b.word(add(vt, slot)?)?;
    if callback == 0 { return Err(Error::NullObject); }
    b.virtual_call(object, callback, slot, args).map_err(Error::Boundary)
}
fn c_string(b: &mut impl Boundary, address: u32) -> Result<Vec<u8>, Error> {
    let mut result = Vec::new(); let mut cursor = address;
    loop {
        let value = b.byte(cursor)?;
        if value == 0 { return Ok(result); }
        result.try_reserve(1).map_err(|_| Error::Boundary("replay string allocation failed"))?;
        result.push(value);
        cursor = cursor.checked_add(1).ok_or(Error::UnterminatedString)?;
    }
}
/// Native734130 copies the first referenced word and uses wrapping32-bit this
/// adjustment. The complete member return is preserved, including upper bits.
pub fn invoke(b: &mut impl Boundary, callback: u32, args: [u32; 5]) -> Result<u32, Error> {
    let first = b.word(args[0])?;
    let adjustment = b.word(add(callback, 12)?)?;
    let owner = b.word(add(callback, 4)?)?;
    let target = b.word(add(callback, 8)?)?;
    b.member_call(owner.wrapping_add(adjustment), target, [first, args[1], args[2], args[3], args[4]]).map_err(Error::Boundary)
}
/// Native729D70. Setter results overwrite (rather than combine) the return byte.
/// Getter/setter callbacks can mutate object fields, so loop bounds are reread.
pub fn update_metadata(b: &mut impl Boundary, object: u32, packet: u32) -> Result<u8, Error> {
    use Argument::Word as W;
    let mut result = 1;
    for (id, offset) in [(100, 1), (200, 5)] {
        let value = b.word(add(packet, offset)?)?;
        if virtual_call(b, object, 12, &[W(id), W(1)])? != value {
            result = virtual_call(b, object, 8, &[W(id), W(value)])? as u8;
        }
    }
    for (id, source, destination) in [(100, 0x189, 0x1a8), (200, 0x18d, 0x1ac)] {
        let value = b.word(add(packet, source)?)?;
        if virtual_call(b, object, 12, &[W(id), W(0)])? != value {
            b.write_word(add(object, destination)?, value)?;
        }
    }
    for (count, source, destination) in [(0x1a0, 9, 0x20), (0x1a4, 0xc9, 0xe0)] {
        let mut i = 0u32;
        while i < b.word(add(object, count)?)? {
            let offset = i.checked_mul(8).ok_or(Error::AddressOverflow)?;
            let src = add(add(packet, source)?, offset)?;
            let dst = add(add(object, destination)?, offset)?;
            let low = b.word(src)?; b.write_word(dst, low)?;
            let high = b.word(add(src, 4)?)?; b.write_word(add(dst, 4)?, high)?;
            i = i.checked_add(1).ok_or(Error::AddressOverflow)?;
        }
    }
    Ok(result)
}
/// Native729370 uses only the low selector bytes. Successful normal returns are1,
/// including ignored selectors. Required absent callbacks/storage return errors.
pub fn dispatch(b: &mut impl Boundary, manager: u32, args: [u32; 5]) -> Result<u8, Error> {
    use Argument::{Word as W, WordRef as R, String as S};
    let context = args[3]; let packet = args[4];
    match args[1] as u8 {
        2 | 5 => {
            let object = b.word(add(manager, 0x24)?)?;
            virtual_call(b, object, 8, &[W(args[1] as u8 as u32), R(context)])?;
        }
        4 => {
            let object = b.word(add(manager, 0x24)?)?;
            b.write_word(add(manager, 4)?, context)?;
            b.write_byte(add(manager, 0x3c)?, 0)?;
            if object != 0 { virtual_call(b, object, 8, &[W(1), R(context)])?; }
        }
        3 => match args[2] as u8 {
            2..=4 => {
                let object = b.word(add(manager, 0x20)?)?;
                virtual_call(b, object, 8, &[W(context), W(packet)])?;
            }
            5 => {
                let listeners = b.word(add(manager, 0x28)?)?;
                // These reads precede the optional-listener check in the original.
                let second = b.word(add(packet, 5)?)?;
                let first = b.word(add(packet, 1)?)?;
                if listeners != 0 {
                    let flag = u32::from(b.word(add(packet, 10)?)? == 1);
                    let object = b.word(add(listeners, 4)?)?;
                    let byte = b.byte(add(packet, 9)?)? as u32;
                    virtual_call(b, object, 8, &[R(first), R(second), W(byte), W(flag), W(add(packet, 0x36)?), W(add(packet, 0x16)?)])?;
                }
            }
            6 => {
                let listeners = b.word(add(manager, 0x28)?)?;
                let first = b.word(add(packet, 1)?)?;
                if listeners != 0 {
                    let object = b.word(add(listeners, 8)?)?;
                    let short = u16::from_le_bytes([b.byte(add(packet, 5)?)?, b.byte(add(packet, 6)?)?]);
                    virtual_call(b, object, 8, &[R(first), W(short as u32)])?;
                }
            }
            7 => match b.byte(packet)? {
                opcode @ (101 | 102) => {
                    let text = c_string(b, add(packet, 0x11)?)?;
                    let object = b.word(add(manager, 0x34)?)?;
                    let third = if opcode == 101 { Some(b.word(add(packet, 9)?)?) } else { None };
                    let second = b.word(add(packet, 5)?)?;
                    let first = b.word(add(packet, 1)?)?;
                    let mut arguments = vec![W(first), W(second), S(text)];
                    if let Some(third) = third { arguments.push(W(third)); }
                    virtual_call(b, object, if opcode == 101 { 0x28 } else { 0x3c }, &arguments)?;
                }
                103 => {
                    let object = b.word(add(manager, 0x34)?)?;
                    update_metadata(b, object, packet)?;
                    let callback = b.word(add(manager, 0x2c)?)?;
                    virtual_call(b, callback, 8, &[])?;
                }
                _ => {}
            },
            _ => {}
        },
        _ => {}
    }
    Ok(1)
}

