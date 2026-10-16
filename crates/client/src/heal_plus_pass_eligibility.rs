//! Raw field fragment of original FUN_0092f030 (0x92f030..0x92f0ca).
//! This is not native receiver admission or a Rune/material/producer integration.

/// The caller must explicitly supply the inspected register/field values.
/// Offsets name the original ECX-relative reads, not recovered semantic types.
/// No default, memory dereference, authored-value mapping or owner is supplied.
#[derive(Clone, Copy, Debug)]
pub struct RawInputs {
    pub f32_at_40: f32,
    pub u8_at_44: u8,
    pub i32_at_28: i32,
    pub u8_at_178: u8,
    pub selector_edx: u32,
}

/// Preserve the observed AL result using the shipped read-only +0.0 constant.
/// Equality accepts both signed zeros; inequality includes unordered NaNs.
/// This models the continuing comparison's value result, not MXCSR traps,
/// exception state or an unqualified native denormals-are-zero environment.
pub fn raw_al(inputs: RawInputs) -> u8 {
    let not_equal_or_unordered = inputs.f32_at_40 != 0.0_f32;
    let accepted = match inputs.selector_edx {
        0 => !not_equal_or_unordered && inputs.i32_at_28 < 0,
        1 => !not_equal_or_unordered && inputs.u8_at_178 != 0,
        2 => not_equal_or_unordered && inputs.u8_at_44 & 2 != 0,
        3 => not_equal_or_unordered && inputs.u8_at_44 & 1 != 0,
        4 => !not_equal_or_unordered && inputs.i32_at_28 >= 0,
        _ => false,
    };
    u8::from(accepted)
}

#[cfg(test)]
#[path = "heal_plus_pass_eligibility_tests.rs"]
mod tests;
