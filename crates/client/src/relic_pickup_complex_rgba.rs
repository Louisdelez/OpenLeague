//! Actual Complex923DE7..923E8A mode0 packet color producer, before type2.
//! Primary+A4 modulation is mandatory; its lifetime/owner source is separate.
#[derive(Clone,Copy,Debug)]pub struct Prepared([f32;4]);
impl Prepared {pub fn value(self)->[f32;4]{self.0}}
pub fn mode0(record_rgba:[f32;4],native_modulation:[f32;4])->Result<Prepared,&'static str> {
    if record_rgba.into_iter().chain(native_modulation).any(|v|!v.is_finite()) {return Err("nonfinite Complex native color producer");}
    // Native destination is modulation; preserve weighted component order.
    let weighted=std::array::from_fn::<_,4,_>(|i|native_modulation[i]*record_rgba[i]);
    let value=[weighted[0]*weighted[3],weighted[1]*weighted[3],weighted[2]*weighted[3],1.];
    if value.iter().any(|v|!v.is_finite() || !(0. ..=1.).contains(v)) {return Err("Complex prepared RGBA outside admitted packing subset");}
    Ok(Prepared(value))
}
