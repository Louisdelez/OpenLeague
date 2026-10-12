use std::{fs,env};
fn main(){
    let input=fs::read_to_string(env::args().nth(1).expect("input bits")).unwrap();
    for line in input.lines(){let bits:u32=line.parse().unwrap();
        let value=f32::from_bits(bits);
        let estimate=unsafe{std::arch::x86_64::_mm_cvtss_f32(std::arch::x86_64::_mm_rsqrt_ss(std::arch::x86_64::_mm_set_ss(value)))};
        println!("{} {}",bits,estimate.to_bits());
    }
}
