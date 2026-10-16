//! Whole937120 raw56-word output from owned Complex buffers. No GPU admission.
//! The instance+8 primary+478 owner-attribute lookup is an obligatory source result. A
//! missing entry is valid only when the caller actually owns an empty/missing
//! lookup; this module never manufactures a missing native actor attribute.
use openleague_core::native_complex_particle_storage::Record;

#[derive(Debug,Clone,Copy)]
pub struct AttributeLookup {pub key:u32,pub value:Option<f32>}
#[derive(Debug,Clone,Copy)]
pub struct Inputs {pub attribute_enabled:bool,pub attribute_key:u32,pub lookup:Option<AttributeLookup>}

fn x87_copy(word:u32)->u32 {
    if word&0x7f800000==0x7f800000 && word&0x007fffff!=0 {word|0x00400000} else {word}
}
pub fn prepare(record:&Record,input:Inputs)->Result<[u32;56],&'static str> {
    let attribute=if input.attribute_enabled {
        let lookup=input.lookup.ok_or("mist owner attribute lookup not supplied")?;
        if lookup.key!=input.attribute_key {return Err("mist owner attribute lookup key mismatch");}
        let value=lookup.value.unwrap_or(0.);
        if !value.is_finite(){return Err("mist owner attribute lookup nonfinite");}
        Some(value)
    } else {
        if input.lookup.is_some(){return Err("mist lookup supplied for disabled native branch");}
        None
    };
    let mut out=[0;56];
    for i in 0..16{out[i]=x87_copy(record.surface[16+i]);out[16+i]=x87_copy(record.motion[i]);}
    out[32..36].copy_from_slice(&record.color[4..8]);
    out[36..39].copy_from_slice(&record.scale[3..6]);
    out[39..42].copy_from_slice(&record.surface[32..35]);
    let [x,y,z]=[out[39],out[40],out[41]].map(f32::from_bits);
    if ![x,y,z].iter().all(|v|v.is_finite()){return Err("nonfinite mist surface direction");}
    // Original937260..937301, separate SSE32 operations; no hardware rsqrt.
    let squared=((x*x)+(y*y))+(z*z);
    let magic=f32::from_bits(0x5f3759df_u32.wrapping_sub(((squared.to_bits() as i32)>>1)as u32));
    let half=squared*0.5;
    let inverse=(1.5-((half*magic)*magic))*magic;
    let length=1./inverse;
    out[51]=length.to_bits();
    if length>f32::from_bits(0x3089705f) {
        out[39]=(x*inverse).to_bits();out[40]=(inverse*y).to_bits();out[41]=(inverse*z).to_bits();
    }
    out[42..45].copy_from_slice(&record.field_70);
    // Original938820 uses the stored auxiliary pair and live first scroll,
    // unlike the second scroll which937120 copies directly.
    for axis in 0..2 {out[45+axis]=if let Some(value)=attribute {
        (f32::from_bits(record.uv[10+axis])+(f32::from_bits(record.uv[axis])*value)).to_bits()
    } else {record.uv[10+axis]};}
    out[47..49].copy_from_slice(&record.uv[12..14]);
    out[49..51].copy_from_slice(&record.field_64);
    out[52]=x87_copy(record.motion[52]);out[53]=x87_copy(record.atlas[1]);
    out[54]=x87_copy(record.field_7c[0]);out[55]=record.field_88[0];
    Ok(out)
}
