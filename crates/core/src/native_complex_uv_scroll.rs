//! Original939DBE..939F75 RGB and multiplicative RGB UV scroll stages.
//! Stored origin/rate production and ordinary material/render binding are separate.
use serde_json::Value;
#[derive(Debug,Copy,Clone,PartialEq,Eq)]
pub struct Flags(pub u8);
#[derive(Debug,PartialEq,Eq)]
pub enum Error {InvalidGroup,UnsupportedField(String)}
impl Flags {
    ///914F83..914F9A and915026..91505B preserve unrelated bits; raw bool LSB wins.
    pub fn from_raw_bytes(prior:u8,rgb:u8,mult:u8)->Self {
        Self((prior&!6)|((rgb&1)<<1)|((mult&1)<<2))
    }
    /// Binary INIBIN bool/text source rules, default zero. Global overrides separate.
    pub fn from_binary_group(group:&Value,prior:u8)->Result<Self,Error> {
        if !group.is_object() {return Err(Error::InvalidGroup);}
        let read=|key:&str|->Result<u8,Error> {
            let Some(v)=group.get(key) else {return Ok(0);};
            if let Some(v)=v.as_bool() {return Ok(u8::from(v));}
            if let Some(v)=v.as_str() {return Ok(crate::native_complex_life_scale::LifeScale::from_binary_sources(true,None,Some(v.as_bytes())).raw_byte);}
            Err(Error::UnsupportedField(key.into()))
        };
        Ok(Self::from_raw_bytes(prior,read("p-uvscroll-rgb-clamp")?,read("p-uvscroll-rgb-clamp-mult")?))
    }
}
#[derive(Debug,Copy,Clone)]
pub struct Scroll {pub origin:[[f32;2];2],pub rate:[[f32;2];2]}
fn arithmetic(left:f32,right:f32,op:impl FnOnce(f32,f32)->f32)->f32 {
    // Actual SSE CPU destination wins when both operands contain a NaN.
    if left.is_nan() {return f32::from_bits(left.to_bits()|0x00400000);}
    if right.is_nan() {return f32::from_bits(right.to_bits()|0x00400000);}
    let result=op(left,right);
    if result.is_nan() {f32::from_bits(0xffc00000)} else {result}
}
fn fractional(value:f32)->f32 {
    if value.is_nan() {return f32::from_bits(value.to_bits()|0x00400000);}
    if value.is_infinite() {return 0f32.copysign(value);}
    // Native CRT preserves negative zero and negative fractional parts.
    value.fract().copysign(value)
}
impl Scroll {
    /// Elapsed particle time is distinct from normalized lifetime age.
    /// No random draws here: both stored origins and rates remain immutable.
    pub fn update(self,elapsed:f32,flags:Flags)->[[f32;2];2] {
        std::array::from_fn(|layer|std::array::from_fn(|axis| {
            let product=arithmetic(self.rate[layer][axis],elapsed,|a,b|a*b);
            let value=if layer==0&&axis==0 {arithmetic(product,self.origin[layer][axis],|a,b|a+b)} else {arithmetic(self.origin[layer][axis],product,|a,b|a+b)};
            if flags.0&(2<<layer)!=0 {
                if value>1. {1.} else if value< -1. {-1.} else {value}
            } else {fractional(value)}
        }))
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn proof()->Value {serde_json::from_str(include_str!("../../../data/4.20/complex_uv_update_contract.json")).unwrap()}
    fn bits(v:&Value)->u32 {u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    fn values(v:&Value)->[[f32;2];2] {std::array::from_fn(|layer|std::array::from_fn(|axis|f32::from_bits(bits(&v[2*layer+axis]))))}
    fn expected(v:&Value)->Vec<u32> {v.as_array().unwrap().iter().map(bits).collect()}
    #[test]
    fn native_scroll_matches_cpu_arithmetic_and_original_crt_fraction() {
        let p=proof();assert_eq!(p["cases"].as_array().unwrap().len(),512);
        for row in p["cases"].as_array().unwrap() {
            let state=Scroll {origin:values(&row["base_bits"]),rate:values(&row["rate_bits"])};
            let result=state.update(f32::from_bits(bits(&row["elapsed_bits"])),Flags(row["flags"].as_u64().unwrap() as u8));
            assert_eq!(result.into_iter().flatten().map(f32::to_bits).collect::<Vec<_>>(),expected(&row["cpu_arithmetic_native_crt_bits"]),"{row}");
            assert_eq!(state.origin.into_iter().flatten().map(f32::to_bits).collect::<Vec<_>>(),expected(&row["base_after_bits"]));
            assert_eq!(state.rate.into_iter().flatten().map(f32::to_bits).collect::<Vec<_>>(),expected(&row["rate_after_bits"]));
        }
    }
    #[test]
    fn clamp_flags_match_native_raw_byte_packing_and_preserved_bits() {
        let p=proof();assert_eq!(p["flag_cases"].as_array().unwrap().len(),64);
        for row in p["flag_cases"].as_array().unwrap() {
            assert_eq!(Flags::from_raw_bytes(row["prior"].as_u64().unwrap() as u8,row["first"].as_u64().unwrap() as u8,row["second"].as_u64().unwrap() as u8).0,row["flags"].as_u64().unwrap() as u8);
        }
    }
    #[test]
    fn actual_map10_groups_use_unclamped_scroll_defaults() {
        let root=std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");
        let catalog:Value=serde_json::from_str(&std::fs::read_to_string(root.join("data/4.20/map10_particle_catalog.json")).unwrap()).unwrap();let mut count=0;
        for definition in catalog["definitions"].as_array().unwrap() {
            let doc:Value=serde_json::from_str(&std::fs::read_to_string(root.join(definition["asset"].as_str().unwrap())).unwrap()).unwrap();
            for group in definition["groups"].as_array().unwrap() {
                if group["declared_type"]=="Simple" {continue;}
                let fields=&doc["sections"][group["name"].as_str().unwrap()];
                assert!(fields.get("p-uvscroll-rgb-clamp").is_none());assert!(fields.get("p-uvscroll-rgb-clamp-mult").is_none());
                assert_eq!(Flags::from_binary_group(fields,0).unwrap(),Flags(0));count+=1;
            }
        }
        assert_eq!(count,27);
    }
}
