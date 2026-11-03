fn same_bits_or_nan(actual:f32, bits:u32) { let expected=f32::from_bits(bits); if expected.is_nan() {assert!(actual.is_nan());} else {assert_eq!(actual.to_bits(),bits);} }
#[test]
fn native_native_endgame_target0_duration2() {
 let mut state=OpacityState::begin(f32::from_bits(0x3f800000),f32::from_bits(0x00000000),f32::from_bits(0x40000000),f32::from_bits(0x40600000));
 same_bits_or_nan(state.deadline,0x40b00000);
 same_bits_or_nan(state.current,0x3f800000);
 same_bits_or_nan(state.target,0x00000000);
 same_bits_or_nan(state.rate,0xbf000000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40600000)),0x3f800000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40700000)),0x3f600000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40800000)),0x3f400000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40900000)),0x3f000000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40a00000)),0x3e800000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40aff7cf)),0x3a031000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40b00000)),0x00000000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40b00831)),0x00000000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40e00000)),0x00000000);
}
#[test]
fn native_nonunit_initial_alpha() {
 let mut state=OpacityState::begin(f32::from_bits(0x3f4ccccd),f32::from_bits(0x00000000),f32::from_bits(0x40000000),f32::from_bits(0x442f0000));
 same_bits_or_nan(state.deadline,0x442f8000);
 same_bits_or_nan(state.current,0x3f4ccccd);
 same_bits_or_nan(state.target,0x00000000);
 same_bits_or_nan(state.rate,0xbecccccd);
 same_bits_or_nan(state.sample(f32::from_bits(0x442ee000)),0x3f800000);
 same_bits_or_nan(state.sample(f32::from_bits(0x442f0000)),0x3f4ccccd);
 same_bits_or_nan(state.sample(f32::from_bits(0x442f0800)),0x3f400000);
 same_bits_or_nan(state.sample(f32::from_bits(0x442f4000)),0x3ecccccd);
 same_bits_or_nan(state.sample(f32::from_bits(0x442f8000)),0x00000000);
 same_bits_or_nan(state.sample(f32::from_bits(0x442fc000)),0x00000000);
}
#[test]
fn native_fade_in() {
 let mut state=OpacityState::begin(f32::from_bits(0x00000000),f32::from_bits(0x3f800000),f32::from_bits(0x40000000),f32::from_bits(0x41400000));
 same_bits_or_nan(state.deadline,0x41600000);
 same_bits_or_nan(state.current,0x00000000);
 same_bits_or_nan(state.target,0x3f800000);
 same_bits_or_nan(state.rate,0x3f000000);
 same_bits_or_nan(state.sample(f32::from_bits(0x41400000)),0x00000000);
 same_bits_or_nan(state.sample(f32::from_bits(0x41440000)),0x3e000000);
 same_bits_or_nan(state.sample(f32::from_bits(0x41500000)),0x3f000000);
 same_bits_or_nan(state.sample(f32::from_bits(0x41600000)),0x3f800000);
 same_bits_or_nan(state.sample(f32::from_bits(0x41700000)),0x3f800000);
}
#[test]
fn native_constant_target() {
 let mut state=OpacityState::begin(f32::from_bits(0x3f333333),f32::from_bits(0x3f333333),f32::from_bits(0x40000000),f32::from_bits(0x40600000));
 same_bits_or_nan(state.deadline,0x40b00000);
 same_bits_or_nan(state.current,0x3f333333);
 same_bits_or_nan(state.target,0x3f333333);
 same_bits_or_nan(state.rate,0x00000000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40400000)),0x3f333333);
 same_bits_or_nan(state.sample(f32::from_bits(0x40600000)),0x3f333333);
 same_bits_or_nan(state.sample(f32::from_bits(0x40900000)),0x3f333333);
 same_bits_or_nan(state.sample(f32::from_bits(0x40b00000)),0x3f333333);
}
#[test]
fn native_negative_target() {
 let mut state=OpacityState::begin(f32::from_bits(0x3f000000),f32::from_bits(0xbe800000),f32::from_bits(0x3f400000),f32::from_bits(0x42200000));
 same_bits_or_nan(state.deadline,0x42230000);
 same_bits_or_nan(state.current,0x3f000000);
 same_bits_or_nan(state.target,0xbe800000);
 same_bits_or_nan(state.rate,0xbf800000);
 same_bits_or_nan(state.sample(f32::from_bits(0x421f999a)),0x3f199980);
 same_bits_or_nan(state.sample(f32::from_bits(0x42200000)),0x3f000000);
 same_bits_or_nan(state.sample(f32::from_bits(0x42208000)),0x3ec00000);
 same_bits_or_nan(state.sample(f32::from_bits(0x42220000)),0x00000000);
 same_bits_or_nan(state.sample(f32::from_bits(0x42230000)),0xbe800000);
 same_bits_or_nan(state.sample(f32::from_bits(0x42240000)),0xbe800000);
}
#[test]
fn native_short_duration() {
 let mut state=OpacityState::begin(f32::from_bits(0x3f800000),f32::from_bits(0x00000000),f32::from_bits(0x3d088888),f32::from_bits(0x42c7cccd));
 same_bits_or_nan(state.deadline,0x42c7ddde);
 same_bits_or_nan(state.current,0x3f800000);
 same_bits_or_nan(state.target,0x00000000);
 same_bits_or_nan(state.rate,0xc1f00001);
 same_bits_or_nan(state.sample(f32::from_bits(0x42c7cccd)),0x3f7fff01);
 same_bits_or_nan(state.sample(f32::from_bits(0x42c7d1ec)),0x3f332e01);
 same_bits_or_nan(state.sample(f32::from_bits(0x42c7d70a)),0x3eccd801);
 same_bits_or_nan(state.sample(f32::from_bits(0x42c7ddde)),0x00000000);
 same_bits_or_nan(state.sample(f32::from_bits(0x42c80000)),0x00000000);
}
#[test]
fn native_large_clock_rounding() {
 let mut state=OpacityState::begin(f32::from_bits(0x3f800000),f32::from_bits(0x00000000),f32::from_bits(0x40000000),f32::from_bits(0x47800000));
 same_bits_or_nan(state.deadline,0x47800100);
 same_bits_or_nan(state.current,0x3f800000);
 same_bits_or_nan(state.target,0x00000000);
 same_bits_or_nan(state.rate,0xbf000000);
 same_bits_or_nan(state.sample(f32::from_bits(0x477fff00)),0x3fc00000);
 same_bits_or_nan(state.sample(f32::from_bits(0x47800000)),0x3f800000);
 same_bits_or_nan(state.sample(f32::from_bits(0x47800020)),0x3f600000);
 same_bits_or_nan(state.sample(f32::from_bits(0x47800080)),0x3f000000);
 same_bits_or_nan(state.sample(f32::from_bits(0x478000c0)),0x3e800000);
 same_bits_or_nan(state.sample(f32::from_bits(0x47800100)),0x00000000);
}
#[test]
fn native_zero_duration_fade() {
 let mut state=OpacityState::begin(f32::from_bits(0x3f800000),f32::from_bits(0x00000000),f32::from_bits(0x00000000),f32::from_bits(0x40600000));
 same_bits_or_nan(state.deadline,0x40600000);
 same_bits_or_nan(state.current,0x3f800000);
 same_bits_or_nan(state.target,0x00000000);
 same_bits_or_nan(state.rate,0xff800000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40400000)),0x7f800000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40600000)),0x00000000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40800000)),0x00000000);
}
#[test]
fn native_zero_duration_equal() {
 let mut state=OpacityState::begin(f32::from_bits(0x3f800000),f32::from_bits(0x3f800000),f32::from_bits(0x00000000),f32::from_bits(0x40600000));
 same_bits_or_nan(state.deadline,0x40600000);
 same_bits_or_nan(state.current,0x3f800000);
 same_bits_or_nan(state.target,0x3f800000);
 same_bits_or_nan(state.rate,0xffc00000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40400000)),0xffc00000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40600000)),0x3f800000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40800000)),0x3f800000);
}
#[test]
fn native_negative_duration() {
 let mut state=OpacityState::begin(f32::from_bits(0x3f800000),f32::from_bits(0x00000000),f32::from_bits(0xc0000000),f32::from_bits(0x40600000));
 same_bits_or_nan(state.deadline,0x3fc00000);
 same_bits_or_nan(state.current,0x3f800000);
 same_bits_or_nan(state.target,0x00000000);
 same_bits_or_nan(state.rate,0x3f000000);
 same_bits_or_nan(state.sample(f32::from_bits(0x3f800000)),0xbe800000);
 same_bits_or_nan(state.sample(f32::from_bits(0x3fc00000)),0x00000000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40000000)),0x00000000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40600000)),0x00000000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40800000)),0x00000000);
}
#[test]
fn native_out_of_range_target() {
 let mut state=OpacityState::begin(f32::from_bits(0x3f800000),f32::from_bits(0x3fc00000),f32::from_bits(0x40000000),f32::from_bits(0x40600000));
 same_bits_or_nan(state.deadline,0x40b00000);
 same_bits_or_nan(state.current,0x3f800000);
 same_bits_or_nan(state.target,0x3fc00000);
 same_bits_or_nan(state.rate,0x3e800000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40600000)),0x3f800000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40800000)),0x3f900000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40900000)),0x3fa00000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40b00000)),0x3fc00000);
}
#[test]
fn native_retarget_after_actual_sample() {
 let mut state=OpacityState::begin(f32::from_bits(0x3f400000),f32::from_bits(0x3f800000),f32::from_bits(0x3f000000),f32::from_bits(0x40800000));
 same_bits_or_nan(state.deadline,0x40900000);
 same_bits_or_nan(state.current,0x3f400000);
 same_bits_or_nan(state.target,0x3f800000);
 same_bits_or_nan(state.rate,0x3f000000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40800000)),0x3f400000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40840000)),0x3f500000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40880000)),0x3f600000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40900000)),0x3f800000);
 same_bits_or_nan(state.sample(f32::from_bits(0x40a00000)),0x3f800000);
}
