//! Native HUD effect parameter copy and BGRA-to-RGBA conversion (9A3496..9A3574).
//! Lookup/allocation, instance lifetime, textures and GPU drawing are separate.
pub struct EffectUniforms {pub params_bits:[u32;4],pub colors_rgba:[[f32;4];2]}
pub fn from_storage(storage:&crate::native_hud_element_storage::ElementStorage)->Result<EffectUniforms,&'static str> {
    if storage.kind()!=2 {return Err("native HUD effect uniforms require Effect storage");}
    let bytes=storage.bytes();let mut params_bits=[0;4];let mut colors_rgba=[[0.0;4];2];
    for (i,bits) in params_bits.iter_mut().enumerate() {*bits=u32::from_le_bytes(bytes[0x204+i*4..0x208+i*4].try_into().unwrap());}
    let factor=f32::from_bits(0x3b808081);
    for (i,color) in colors_rgba.iter_mut().enumerate() {
        let bgra=&bytes[0x214+i*4..0x218+i*4];
        *color=[bgra[2] as f32*factor,bgra[1] as f32*factor,bgra[0] as f32*factor,bgra[3] as f32*factor];
    }
    Ok(EffectUniforms {params_bits,colors_rgba})
}
#[cfg(test)] mod tests {
    use super::*;
    fn decode(s:&str)->Vec<u8> {(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
    #[test] fn real_effects_and_every_color_byte_match_original_postload_instructions() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_effect_uniforms_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],374);assert_eq!(proof["factor_bits"],0x3b808081u32);
        for case in proof["cases"].as_array().unwrap() {
            let mut storage=crate::native_hud_element_storage::ElementStorage::new(2).unwrap();
            storage.write_bytes(0x204,&decode(case["params_hex"].as_str().unwrap()));storage.write_bytes(0x214,&decode(case["colors_bgra_hex"].as_str().unwrap()));
            let actual=from_storage(&storage).unwrap();let output=actual.params_bits.into_iter().chain(actual.colors_rgba.into_iter().flatten().map(f32::to_bits)).flat_map(u32::to_le_bytes).collect::<Vec<_>>();
            assert_eq!(output,decode(case["output_hex"].as_str().unwrap()),"{}",case["label"]);
        }
        assert!(from_storage(&crate::native_hud_element_storage::ElementStorage::new(1).unwrap()).is_err());
    }
}
