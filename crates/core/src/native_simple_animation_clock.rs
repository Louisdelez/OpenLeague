//! Native943A21..943A81 clock and x87 unsigned-frame duration, default rounding.
fn arithmetic(a:u32,b:u32,add:bool)->u32 {
    let x=f32::from_bits(a);let y=f32::from_bits(b);if x.is_nan(){return a|0x00400000;}if y.is_nan(){return b|0x00400000;}
    let v=if add{x+y}else{x-y};if v.is_nan(){0xffc00000}else{v.to_bits()}
}
/// Exact 32-bit unsigned integer × binary32 product, then one nearest-even
/// binary32 rounding. x87's 64-bit significand holds this <=56-bit product.
pub fn frame_duration(frames:u32,factor:u32)->u32 {
    let sign=factor&0x80000000;let exponent=(factor>>23)&255;let fraction=factor&0x7fffff;
    if exponent==255 {return if fraction!=0 {factor|0x00400000}else if frames==0 {0xffc00000}else{factor};}
    let mantissa=if exponent==0 {fraction}else{fraction|0x800000};
    let product=frames as u64*mantissa as u64;if product==0{return sign;}
    let power=if exponent==0 {-149}else{exponent as i32-150};
    let top=63-product.leading_zeros() as i32;let mut value_exponent=top+power;
    if value_exponent< -126 {return sign|product as u32;}
    let shift=top-23;
    let mut rounded=if shift<=0 {product<<(-shift)}else{
        let discarded=product&((1u64<<shift)-1);let halfway=1u64<<(shift-1);let retained=product>>shift;
        retained+u64::from(discarded>halfway || discarded==halfway && retained&1!=0)
    };
    if rounded==0x1000000 {rounded>>=1;value_exponent+=1;}
    if value_exponent>127{return sign|0x7f800000;}
    sign|(((value_exponent+127) as u32)<<23)|(rounded as u32&0x7fffff)
}
#[derive(Debug,Clone,Copy)]
pub struct Clip {pub kind:u32,pub frames:u32,pub factor:u32}
impl Clip {pub fn duration(self)->u32 {if self.kind==0x6d6e6163{self.factor}else{frame_duration(self.frames,self.factor)}}}
/// Invalid native wrap paths can stall indefinitely. Return an explicit error
/// on nonpositive duration, infinity, lost subtraction progress or huge loops.
pub fn advance(old:u32,time:u32,baseline:u32,clip:Clip)->Result<u32,&'static str> {
    let duration=clip.duration();let mut clock=arithmetic(arithmetic(time,baseline,false),old,true);
    let mut wraps=0;
    while f32::from_bits(clock)>=f32::from_bits(duration) {
        if f32::from_bits(duration)<=0.0 {return Err("nonterminating native animation wrap");}
        let next=arithmetic(clock,duration,false);if next==clock || wraps>=100000 {return Err("native animation wrap stalls or exceeds supported iteration count");}
        clock=next;wraps+=1;
    }
    Ok(clock)
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::Value;
    fn bits(v:&Value)->u32{u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    #[test]
    fn animation_clock_and_exact_duration_match_native_and_cpu_captures() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_animation_clock_contract.json")).unwrap();let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),782);
        for (i,r) in rows.iter().enumerate() {
            let clip=Clip {kind:r["kind"].as_u64().unwrap() as u32,frames:r["frames"].as_u64().unwrap() as u32,factor:bits(&r["rate"])};
            assert_eq!(clip.duration(),bits(&r["cpu"]["duration"]),"duration case{i}");
            assert_eq!(advance(bits(&r["old_clock"]),bits(&r["time"]),bits(&r["baseline"]),clip).unwrap(),bits(&r["cpu"]["clock"]),"clock case{i}");
        }
        let duration_rows=p["duration_cases"].as_array().unwrap();assert_eq!(duration_rows.len(),354);
        for (i,r) in duration_rows.iter().enumerate(){assert_eq!(frame_duration(r["frames"].as_u64().unwrap() as u32,bits(&r["factor"])),bits(&r["cpu"]),"x87 multiplication case{i}");}
    }
    #[test]
    fn nonterminating_wraps_return_explicit_errors() {
        for factor in [0,0x80000000,0xbf800000,1] {assert!(advance(0x3f800000,0,0,Clip {kind:0x6d6e6163,frames:0,factor}).is_err());}
        assert_eq!(advance(0x7f800000,0,0,Clip {kind:0,frames:1,factor:0x7f800000}),Ok(0xffc00000));
        assert!(advance(0x7f800000,0,0,Clip {kind:0,frames:1,factor:0x3f800000}).is_err());
    }
}
