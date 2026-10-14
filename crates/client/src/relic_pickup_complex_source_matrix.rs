//! Original934340 primary-field copy and932F50 instance matrix arithmetic.
//! Primary+10 Euler values are distinct from the e-rotation1 rotation list.
//! Callers must supply actual primary fields or an already-owned source matrix;
//! neither sampling cadence nor factory/owner policy is invented here.
#[derive(Clone,Copy,Debug)]
pub struct PrimaryFields{
 pub position:[u32;3],
 pub rotation_degrees:[u32;3],
 pub scale:[u32;3],
}
#[derive(Clone,Copy,Debug)]pub struct Matrix([u32;16]);
impl Matrix{
 /// No identity fallback. This admission keeps unqualified producers explicit.
 pub fn supplied(words:[u32;16])->Result<Self,&'static str>{
  if words.iter().any(|word|!f32::from_bits(*word).is_finite()){return Err("unqualified nonfinite Complex source matrix");}Ok(Self(words))
 }
 pub fn words(self)->[u32;16]{self.0}
}
/// Bounded finite numeric producer. Sampling primary fields is caller-owned.
pub fn compose(fields:PrimaryFields)->Result<Matrix,&'static str>{
 let position=fields.position.map(f32::from_bits);let degrees=fields.rotation_degrees.map(f32::from_bits);let scale=fields.scale.map(f32::from_bits);
 if position.iter().chain(degrees.iter()).chain(scale.iter()).any(|v|!v.is_finite()){return Err("unqualified nonfinite Complex primary fields");}
 //934395..9343B4 supplies Y,X,Z;932F99 multiplies by native1138A68.
 let to_radian=f32::from_bits(0x3c8efa35);
 let angles=[degrees[1]*to_radian,degrees[0]*to_radian,degrees[2]*to_radian];
 let rotation=openleague_core::native_particle_euler_matrix::compose(angles)?;
 let mut scaling=[0.;16];scaling[0]=scale[0];scaling[5]=scale[1];scaling[10]=scale[2];scaling[15]=1.;
 // Original8DF790: separate scalar SSE multiply/adds, row-major Scale*Euler.
 let mut output=std::array::from_fn::<_,16,_>(|i|{
  let row=(i/4)*4;let col=i%4;
  let mut v=rotation[col]*scaling[row];v+=rotation[4+col]*scaling[row+1];v+=rotation[8+col]*scaling[row+2];v+=rotation[12+col]*scaling[row+3];v
 });
 output[12..15].copy_from_slice(&position);
 Matrix::supplied(output.map(f32::to_bits))
}
