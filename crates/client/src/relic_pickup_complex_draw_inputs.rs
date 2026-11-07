//! Original92491E..9249A5 type2 system scale inputs and924027..924064 corner flag.
//! The two system scalars and auxiliary texture pointer need their real producers.
pub fn scales(live:[f32;3],system_bc:f32,system_c0:f32)->Result<[f32;3],&'static str> {
 if live.into_iter().chain([system_bc,system_c0]).any(|v|!v.is_finite()){return Err("nonfinite native Complex draw scale");}
 let factor=system_c0*system_bc;let value=live.map(|v|factor*v);
 if value.iter().any(|v|!v.is_finite()){return Err("Complex draw scale overflow");}Ok(value)
}
pub fn channel_corners(primary_mult_texture_pointer:u32)->bool {primary_mult_texture_pointer!=0}
