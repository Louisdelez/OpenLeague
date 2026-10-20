//! Original 8E50F0 hash for a caller-supplied, already-resolved native resource
//! C string. This function performs no path/VFS or TGA-to-DDS resolution.
use std::ffi::CStr;
pub fn hash(name:&CStr)->u32 {
    name.to_bytes().iter().fold(0u32,|h,&c| {
        let c=if c.is_ascii_uppercase(){c+32}else{c};
        h.wrapping_mul(65599).wrapping_add(c as i8 as i32 as u32)
    })
}

/// Original 98A7F0 prefix: a nonempty provider name selects the key; otherwise
/// the original requested name survives. File-byte lookup is a separate step.
pub fn cache_key(requested:&CStr,canonical:&CStr)->u32 {
    hash(if canonical.to_bytes().is_empty(){requested}else{canonical})
}

#[cfg(test)]
#[path="relic_texture_name_tests.rs"]
mod tests;
