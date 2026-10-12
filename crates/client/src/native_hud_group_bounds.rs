//! Native 9A7960 lazy group bounds union, using qualified 9A4B30 element layout.
//! Owner dimensions/scalar are explicit; cache allocation, settings and drawing are separate.
use crate::{native_hud_element_storage::ElementStorage,native_hud_layout::{self,Input}};
pub const EMPTY:[u32;4]=[0x7f7fffff,0x7f7fffff,0xff7fffff,0xff7fffff];
pub fn refresh<'a,I>(cache:&mut [u32;4],flags:&mut u32,width:u32,height:u32,scalar:f32,members:I)->Result<bool,&'static str>
where I:IntoIterator<Item=Result<&'a ElementStorage,&'static str>> {
    if *flags&2==0 {return Ok(false);}
    let mut bounds=EMPTY.map(f32::from_bits);
    for storage in members {
        let storage=storage?;
        let float=|off|f32::from_bits(storage.word(off));
        let input=Input {flags:storage.flags(),width,height,owner_scalar:scalar,rect:[float(0x1c0),float(0x1c4),float(0x1c8),float(0x1cc)],anchors:[float(0x1a8),float(0x1ac),float(0x1b0),float(0x1b4)],motion_offset:[float(0x1b8),float(0x1bc)],include_motion:false,group_offset:None,fractions:[float(0x1d0),float(0x1d4)],aspect:float(0x1d8)};
        let rect=native_hud_layout::transform(&input)?;
        // Preserve native equality choices (including signed-zero bit patterns).
        for k in 0..2 {if bounds[k]>rect[k] {bounds[k]=rect[k];}}
        for k in 2..4 {if bounds[k]<=rect[k] {bounds[k]=rect[k];}}
    }
    *cache=bounds.map(f32::to_bits);*flags&=!2;Ok(true)
}
#[cfg(test)] mod tests {
    use super::*;
    fn decode(s:&str)->Vec<u8> {(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
    #[test] fn all_1152_native_source_group_unions_dirty_and_cached_cases_match_bitwise() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_group_bounds_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],1152);
        let elements=p["elements"].as_array().unwrap().iter().map(|e|{let bytes=decode(e["output_hex"].as_str().unwrap());let mut storage=ElementStorage::new(e["kind"].as_u64().unwrap() as u32).unwrap();storage.write_bytes(0,&bytes);storage}).collect::<Vec<_>>();assert_eq!(elements.len(),703);
        for case in p["cases"].as_array().unwrap() {
            let group=case["group"].as_str().unwrap();let dirty=case["dirty"].as_bool().unwrap();
            let mut cache:[u32;4]=case["initial_bits"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>().try_into().unwrap();let mut flags=case["output_flags"].as_u64().unwrap() as u32|if dirty {2}else {0};
            let members=p["members"][group].as_array().unwrap().iter().map(|i|Ok(&elements[i.as_u64().unwrap() as usize]));
            let refreshed=refresh(&mut cache,&mut flags,case["width"].as_u64().unwrap() as u32,case["height"].as_u64().unwrap() as u32,f32::from_bits(case["owner_scalar_bits"].as_u64().unwrap() as u32),members).unwrap();
            assert_eq!(refreshed,dirty);assert_eq!(cache.to_vec(),case["output_bits"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>(),"{group}");assert_eq!(flags,case["output_flags"].as_u64().unwrap() as u32);
        }
    }
}
