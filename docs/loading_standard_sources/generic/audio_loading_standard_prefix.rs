//! Bounded native57D6FE..57D775 selection for a nonempty standard loading name.
//! Returning Stop describes an unexecuted call boundary, never successful UI.
//! The caller continues to own its String24 and must retire it on every result.
use crate::audio_loading_metadata as names;
use crate::audio_loading_owned_string as owned;
pub use crate::audio_replay_metadata::Error;
pub trait Boundary: names::Boundary + owned::Boundary {}
impl<T: names::Boundary + owned::Boundary> Boundary for T {}

pub const PACKAGE_GLOBAL: u32 = 0x2d78f1c;
pub const NEGATIVE_DIAGNOSTIC: u32 = 0x991e60;
pub const RESOURCE_PROVIDER: u32 = 0x90ad00;
pub const DIAGNOSTIC_EMPTY: u32 = 0x1085b2d;
pub const DIAGNOSTIC_EXPRESSION: u32 = 0x10899d8;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Stop {
    /// At57D74C, before calling991E60. The override skin is not read yet.
    Diagnostic991E60 { skin: u32, arguments: [u32; 5] },
    /// At57D775, before calling90AD00. name24 remains caller-owned.
    /// Native third stack word is opaque and unread by90AD00; this portable
    /// request does not materialize machine-register residue or call that ABI.
    Resource90AD00 { manager: u32, name24: u32, skin: u32 },
}
impl Stop {
    pub fn unavailable(self) -> &'static str {
        match self {
            Self::Diagnostic991E60 { .. } => "native loading skin diagnostic991E60 is not connected",
            Self::Resource90AD00 { .. } => "native loading resource provider90AD00 is not connected",
        }
    }
}
fn add(p: u32, o: u32) -> Result<u32, Error> {
    p.checked_add(o).ok_or(Error::AddressOverflow)
}

/// First-name service resolution and the record update have already happened.
/// retained_service is the actual value read before that first lookup. Do not
/// reload SERVICE_GLOBAL here, even if a provider changes it during dispatch.
/// name24 and scratch8 are exclusive, disjoint caller storage. Except for the
/// explicit same-address skip below, the override and destination strings must
/// not alias, including their heap buffers. No fresh-string copy is substituted.
pub fn prepare(
    b: &mut impl Boundary,
    recipient: u32,
    retained_service: u32,
    payload: u32,
    name: &mut owned::Temporary,
    scratch8: u32,
) -> Result<Stop, Error> {
    let name24 = name.address();
    if b.word(add(recipient, 0x1b8)?)? != 0 {
        let source = add(recipient, 0x1a8)?;
        if name24 != source {
            owned::assign_owned_non_alias(b, name, source)?;
        }
    }
    //57D722 reads payload key, then the retained service's table and slot+4C.
    let key = b.word(payload)?;
    let table = b.word(retained_service)?;
    let target = b.word(add(table, 0x4c)?)?;
    if target != names::SERVICE_EXTRA {
        return Err(Error::Boundary("unknown loading service extra method"));
    }
    //72AE40's ECX service value is unused; its original body retains the global
    //parent metadata and resolves the key. Its scratch pair is caller-owned.
    let skin = names::service_extra(b, key, scratch8)?;
    if (skin as i32) < 0 {
        return Ok(Stop::Diagnostic991E60 {
            skin,
            arguments: [DIAGNOSTIC_EXPRESSION, DIAGNOSTIC_EMPTY, 0, DIAGNOSTIC_EMPTY, DIAGNOSTIC_EMPTY],
        });
    }
    //57D759 loads this global before57D75F reads override skin. A zero value
    //remains a real zero; it does not create a manager or make its call succeed.
    let manager = b.word(PACKAGE_GLOBAL)?;
    let override_skin = b.word(add(recipient, 0x1a0)?)?;
    let skin = if override_skin != u32::MAX { override_skin } else { skin };
    Ok(Stop::Resource90AD00 { manager, name24, skin })
}

#[cfg(test)]
#[path = "audio_loading_standard_prefix_tests.rs"]
mod tests;
