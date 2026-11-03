//! Independent control-flow oracle over the archived 155 original body bytes.
//! No original executable, emulator, host or native instructions are executed.
//! Only the byte patterns consumed below are modeled; unrecognized bytes fail.
use super::{raw_al, RawInputs};
use std::collections::BTreeSet;

// PE SHA256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862.
// PE_additional_windows.json SHA256 95f317910c7b3ba6663f029f033ced0865dfe67cfa83f730d35401ef69def9fb.
// The comparison operand at 0x01138960 is shipped bytes 00 00 00 00.
const BODY: [u8; 155] = [
    0xf3,0x0f,0x10,0x41,0x40,0x0f,0x2e,0x05,0x60,0x89,0x13,0x01,0x9f,0xf6,0xc4,0x44,
    0x7b,0x04,0xb0,0x01,0xeb,0x02,0x32,0xc0,0x53,0x83,0xfa,0x02,0x75,0x19,0x84,0x51,
    0x44,0x74,0x14,0xb4,0x01,0x32,0xdb,0x84,0xc0,0x74,0x1d,0x84,0xe4,0x75,0x04,0x84,
    0xdb,0x74,0x15,0xb7,0x01,0xeb,0x13,0x32,0xe4,0x83,0xfa,0x03,0x75,0xe7,0xf6,0x41,
    0x44,0x01,0x74,0xe1,0xb3,0x01,0xeb,0xdf,0x32,0xff,0x85,0xd2,0x75,0x22,0x84,0xc0,
    0x75,0x1e,0x39,0x51,0x28,0x7d,0x19,0xb4,0x01,0x32,0xdb,0x83,0xfa,0x01,0x75,0x23,
    0x84,0xc0,0x75,0x1f,0x38,0x81,0x78,0x01,0x00,0x00,0x74,0x17,0x8a,0xc2,0xeb,0x15,
    0x32,0xe4,0x83,0xfa,0x04,0x75,0xe2,0x84,0xc0,0x75,0xde,0x83,0x79,0x28,0x00,0x7c,
    0xd8,0xb3,0x01,0x32,0xc0,0x84,0xff,0x75,0x0e,0x84,0xe4,0x75,0x0a,0x84,0xdb,0x75,
    0x06,0x84,0xc0,0x75,0x02,0x5b,0xc3,0xb0,0x01,0x5b,0xc3,
];

#[derive(Default)]
struct Flags { zf: bool, pf: bool, sf: bool, of: bool, cf: bool }
impl Flags {
    fn test8(&mut self, value: u8) {
        self.zf = value == 0;
        self.pf = value.count_ones() & 1 == 0;
        self.sf = value & 0x80 != 0;
        self.of = false;
        self.cf = false;
    }
    fn cmp32(&mut self, left: u32, right: u32) {
        let value = left.wrapping_sub(right);
        self.zf = value == 0;
        self.pf = (value as u8).count_ones() & 1 == 0;
        self.sf = value & 0x8000_0000 != 0;
        self.of = ((left ^ right) & (left ^ value)) & 0x8000_0000 != 0;
        self.cf = left < right;
    }
    fn ucomiss_zero(&mut self, bits: u32) {
        let magnitude = bits & 0x7fff_ffff;
        let unordered = magnitude > 0x7f80_0000;
        self.zf = magnitude == 0 || unordered;
        self.pf = unordered;
        self.cf = (bits & 0x8000_0000 != 0 && magnitude != 0) || unordered;
        self.sf = false;
        self.of = false;
    }
    fn lahf(&self) -> u8 {
        (u8::from(self.sf) << 7) | (u8::from(self.zf) << 6)
            | (u8::from(self.pf) << 2) | 2 | u8::from(self.cf)
    }
}

fn oracle(inputs: RawInputs, visited: &mut BTreeSet<usize>) -> u8 {
    let (mut al, mut ah, mut bl, mut bh) = (0_u8, 0_u8, 0_u8, 0_u8);
    let mut xmm0_bits = 0_u32;
    let mut flags = Flags::default();
    let mut pc = 0_usize;
    for _ in 0..128 {
        assert!(pc < BODY.len(), "oracle left the admitted body");
        visited.insert(pc);
        let tail = &BODY[pc..];
        match tail {
            [0xf3,0x0f,0x10,0x41,0x40, ..] => {
                xmm0_bits = inputs.f32_at_40.to_bits(); pc += 5;
            }
            [0x0f,0x2e,0x05,0x60,0x89,0x13,0x01, ..] => {
                flags.ucomiss_zero(xmm0_bits); pc += 7;
            }
            [0x9f, ..] => { ah = flags.lahf(); pc += 1; }
            [0xf6,0xc4,imm, ..] => { flags.test8(ah & *imm); pc += 3; }
            [0xf6,0x41,0x44,imm, ..] => {
                flags.test8(inputs.u8_at_44 & *imm); pc += 4;
            }
            [0x84,0x51,0x44, ..] => {
                flags.test8(inputs.u8_at_44 & inputs.selector_edx as u8); pc += 3;
            }
            [0xb0,imm, ..] => { al = *imm; pc += 2; }
            [0xb4,imm, ..] => { ah = *imm; pc += 2; }
            [0xb3,imm, ..] => { bl = *imm; pc += 2; }
            [0xb7,imm, ..] => { bh = *imm; pc += 2; }
            [0x32,0xc0, ..] => { al = 0; flags.test8(0); pc += 2; }
            [0x32,0xe4, ..] => { ah = 0; flags.test8(0); pc += 2; }
            [0x32,0xdb, ..] => { bl = 0; flags.test8(0); pc += 2; }
            [0x32,0xff, ..] => { bh = 0; flags.test8(0); pc += 2; }
            [0x84,0xc0, ..] => { flags.test8(al); pc += 2; }
            [0x84,0xe4, ..] => { flags.test8(ah); pc += 2; }
            [0x84,0xdb, ..] => { flags.test8(bl); pc += 2; }
            [0x84,0xff, ..] => { flags.test8(bh); pc += 2; }
            [0x85,0xd2, ..] => {
                flags.zf = inputs.selector_edx == 0; pc += 2;
            }
            [0x83,0xfa,imm, ..] => {
                flags.cmp32(inputs.selector_edx, *imm as u32); pc += 3;
            }
            [0x39,0x51,0x28, ..] => {
                flags.cmp32(inputs.i32_at_28 as u32, inputs.selector_edx); pc += 3;
            }
            [0x83,0x79,0x28,0x00, ..] => {
                flags.cmp32(inputs.i32_at_28 as u32, 0); pc += 4;
            }
            [0x38,0x81,0x78,0x01,0x00,0x00, ..] => {
                flags.cmp32(inputs.u8_at_178 as u32, al as u32); pc += 6;
            }
            [0x8a,0xc2, ..] => { al = inputs.selector_edx as u8; pc += 2; }
            [opcode @ (0x7b | 0x74 | 0x75 | 0x7d | 0x7c | 0xeb),disp, ..] => {
                let taken = match *opcode {
                    0x7b => !flags.pf,
                    0x74 => flags.zf,
                    0x75 => !flags.zf,
                    0x7d => flags.sf == flags.of,
                    0x7c => flags.sf != flags.of,
                    0xeb => true,
                    _ => unreachable!(),
                };
                let next = pc + 2;
                pc = if taken { next.checked_add_signed((*disp as i8) as isize)
                    .expect("oracle relative branch below body") } else { next };
            }
            [0x53 | 0x5b, ..] => { pc += 1; }
            [0xc3, ..] => return al,
            _ => panic!("unadmitted original opcode at body+{pc:#x}"),
        }
    }
    panic!("admitted oracle did not return within its finite body");
}

fn supplied(bits: u32, flags: u8, signed: i32, byte: u8, selector: u32) -> RawInputs {
    RawInputs { f32_at_40: f32::from_bits(bits), u8_at_44: flags,
        i32_at_28: signed, u8_at_178: byte, selector_edx: selector }
}

#[test]
fn heal_plus_pass_raw_all_five_partitions_and_unknown_selectors() {
    let vectors = [
        (0x0000_0000, 0, -1, 0, 0, 1),
        (0x8000_0000, 0, 0, 7, 1, 1),
        (0x3f80_0000, 2, 0, 0, 2, 1),
        (0xbf80_0000, 1, 0, 0, 3, 1),
        (0x0000_0000, 0, 0, 0, 4, 1),
        (0x0000_0000, 3, -1, 255, 5, 0),
        (0x7fc0_0001, 255, i32::MIN, 255, u32::MAX, 0),
    ];
    let mut visited = BTreeSet::new();
    for (bits, flags, signed, byte, selector, expected) in vectors {
        let input = supplied(bits, flags, signed, byte, selector);
        assert_eq!(oracle(input, &mut visited), expected);
        assert_eq!(raw_al(input), expected);
    }
}

#[test]
fn heal_plus_pass_raw_float_words_signed_zero_nan_and_infinities() {
    // qNaN/sNaN payloads, signed zero, signed subnormals, normals and infinities.
    // Signaling exception state and DAZ are intentionally outside this oracle.
    let words = [0, 0x8000_0000, 1, 0x8000_0001, 0x007f_ffff, 0x807f_ffff,
        0x0080_0000, 0x8080_0000, 0x3f80_0000, 0xbf80_0000,
        0x7f7f_ffff, 0xff7f_ffff, 0x7f80_0000, 0xff80_0000,
        0x7fc0_0000, 0xffc0_0001, 0x7f80_0001, 0xff80_0001, 0x7fff_ffff];
    let mut visited = BTreeSet::new();
    for bits in words { for selector in 0..=5 { for signed in [-1, 0] {
        let input = supplied(bits, 3, signed, 255, selector);
        assert_eq!(raw_al(input), oracle(input, &mut visited),
            "bits={bits:#x}, selector={selector}, signed={signed}");
    } } }
}

#[test]
fn heal_plus_pass_raw_entire_flag_and_shadow_bytes_do_not_collapse_to_bool() {
    let mut visited = BTreeSet::new();
    for byte in 0..=255_u8 { for selector in 0..=5 { for bits in [0, 0x3f80_0000] {
        let flags_input = supplied(bits, byte, -1, 0, selector);
        assert_eq!(raw_al(flags_input), oracle(flags_input, &mut visited));
        let shadow_input = supplied(bits, 0, 0, byte, selector);
        assert_eq!(raw_al(shadow_input), oracle(shadow_input, &mut visited));
    } } }
}

#[test]
fn heal_plus_pass_raw_signed_boundary_and_full_edx_do_not_use_unsigned_shortcuts() {
    let mut visited = BTreeSet::new();
    for signed in [i32::MIN, i32::MIN + 1, -1, 0, 1, i32::MAX] {
        for selector in [0, 1, 2, 3, 4, 5, 0x100, 0x101, 0x102, 0x103,
            0x104, 0x8000_0000, u32::MAX] {
            for bits in [0, 0x8000_0000, 0x3f80_0000, 0x7fc0_0001] {
                let input = supplied(bits, 255, signed, 255, selector);
                assert_eq!(raw_al(input), oracle(input, &mut visited));
            }
        }
    }
}

#[test]
fn heal_plus_pass_raw_partitions_visit_every_admitted_instruction() {
    let mut visited = BTreeSet::new();
    for bits in [0, 0x3f80_0000] { for flags in 0..=3 { for signed in [-1, 0] {
        for byte in [0, 255] { for selector in 0..=5 {
            let input = supplied(bits, flags, signed, byte, selector);
            let result = oracle(input, &mut visited);
            assert!(result <= 1);
            assert_eq!(raw_al(input), result);
        } }
    } } }
    assert_eq!(visited.len(), 69, "cover the archived 69 instruction starts");
    assert_eq!(visited.iter().next().copied(), Some(0));
    assert_eq!(visited.iter().next_back().copied(), Some(154));
}
