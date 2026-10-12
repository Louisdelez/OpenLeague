//! Native9A1D10 post-validation UV flips for supplied finite UV state.
use crate::native_hud_element_storage::ElementStorage;
pub fn apply(element:&mut ElementStorage)->Result<(),&'static str> {
    if !matches!(element.kind(),1|2) {return Ok(());}
    let offset=if element.kind()==1 {0x204}else {0x264};let mut v:[u32;8]=std::array::from_fn(|i|element.word(offset+i*4));
    if v.iter().any(|b|!f32::from_bits(*b).is_finite()) {return Err("unqualified nonfinite native HUD UV flip state");}
    if element.flags()&0x400!=0 {v.swap(0,2);v.swap(4,6);}
    if element.flags()&0x800!=0 {v.swap(1,3);v.swap(5,7);}
    for (i,b) in v.iter().enumerate() {element.set_word(offset+i*4,*b);}
    Ok(())
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn native_post_validation_flips_match_entire_element_storage() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_uv_flips_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],30);
        let decode=|s:&str|(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect::<Vec<_>>();
        for c in p["cases"].as_array().unwrap() {
            let mut element=ElementStorage::new(c["kind"].as_u64().unwrap() as u32).unwrap();let size=element.bytes().len();element.write_bytes(0,&decode(c["initial_hex"].as_str().unwrap())[..size]);apply(&mut element).unwrap();assert_eq!(element.bytes(),&decode(c["output_hex"].as_str().unwrap())[..size]);
        }
    }
}
