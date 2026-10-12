//!941F00 contextual and attribute factors, selected finite paths.
use crate::{native_particle_attributes::Attributes,native_simple_emission_lifecycle::Birth};
pub struct AttributeFactor<'a> {pub key:u32,pub multiplier:u32,pub attributes:&'a Attributes}
pub struct Sources<'a> {pub context:[u32;3],pub offset_coefficients:[u32;3],pub bounds_coefficients:[u32;3],pub life_multiplier:Option<u32>,pub offset_attribute:Option<AttributeFactor<'a>>,pub size_attribute:Option<AttributeFactor<'a>>}
#[derive(Clone,Copy,Debug)]
pub struct Prepared {pub offset_context:u32,pub bounds:u32,pub offset_attribute:u32,pub size_attribute:u32,pub life_multiplier:Option<u32>}
fn finite(v:u32)->Result<f32,&'static str>{let f=f32::from_bits(v);if f.is_finite(){Ok(f)}else{Err("unqualified nonfinite birth factor")}}
fn context(c:[u32;3],weights:[u32;3])->Result<u32,&'static str>{
    let c=[finite(c[0])?,finite(c[1])?,finite(c[2])?];
    let w=[finite(weights[0])?,finite(weights[1])?,finite(weights[2])?];
    let a=c[1]*w[1];let b=c[0]*w[0];let d=c[2]*w[2];
    let result=(a+b)+d;finite(result.to_bits())?;Ok(result.to_bits())
}
fn attribute(source:Option<&AttributeFactor>)->Result<u32,&'static str>{
    match source {None=>Ok(0),Some(a)=>{let value=finite(a.attributes.read(a.key))?;let multiplier=finite(a.multiplier)?;let result=((value as f64)*(multiplier as f64)) as f32;finite(result.to_bits())?;Ok(result.to_bits())}}
}
pub fn prepare(s:&Sources)->Result<Prepared,&'static str>{
    let offset_context=context(s.context,s.offset_coefficients)?;let mut bounds=context(s.context,s.bounds_coefficients)?;
    if f32::from_bits(bounds)<=0.{bounds=1f32.to_bits();}
    if let Some(v)=s.life_multiplier{finite(v)?;}
    Ok(Prepared {offset_context,bounds,offset_attribute:attribute(s.offset_attribute.as_ref())?,size_attribute:attribute(s.size_attribute.as_ref())?,life_multiplier:s.life_multiplier})
}
impl Prepared {
    /// Life scaling precedes the negative-life fallback. Offset scaling precedes
    /// auxiliary RNG, rotation lists and owner transform. D8 is the size factor.
    /// No random draws. Commit only after all selected finite values pass.
    pub fn apply(&self,birth:&mut Birth)->Result<(),&'static str>{
        let raw=finite(birth.life)?;let life=if let Some(v)=self.life_multiplier{raw*finite(v)?}else{raw};finite(life.to_bits())?;
        let mut offset=birth.offset;let context=finite(self.offset_context)?;let attribute=finite(self.offset_attribute)?;
        let threshold=f32::from_bits(925353388);
        for v in &mut offset {let mut f=finite(*v)?;if context>0.{f*=context;}if attribute>threshold{f*=attribute;}finite(f.to_bits())?;*v=f.to_bits();}
        let mut factor=finite(birth.factor)?;let size=finite(self.size_attribute)?;if size>threshold{factor*=size;}finite(factor.to_bits())?;
        birth.life=crate::native_simple_birth_parameters::lifetime(life.to_bits());birth.offset=offset;birth.factor=factor.to_bits();Ok(())
    }
}
