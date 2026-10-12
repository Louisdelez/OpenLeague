from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/grass_spatial_bounds.rs';assert not p.exists()
p.write_text('''//! Original95F370 integer X/Z bounds; CPU conversion profile is explicit.
#[derive(Clone,Copy)] pub enum IntegerProfile {Sse,LegacyCrt}
pub fn recalculate(center:[f32;3],local:[f32;6],profile:IntegerProfile)->Result<[i32;4],&'static str> {
    if center.iter().chain(local.iter()).any(|v|!v.is_finite()){return Err("nonfinite native spatial bounds CRT path unqualified");}
    let values=[center[0]+local[0],center[2]+local[2],center[0]+local[3],center[2]+local[5]];
    if values.iter().any(|v|!v.is_finite()){return Err("native spatial bounds sum overflow");}
    let minimum=|v:f32|crate::grass_rectangle::truncate_screen(v.floor());
    let maximum=|v:f32| {let rounded=(v as f64).ceil();match profile {
        IntegerProfile::Sse=>if !(-2147483648.0..2147483648.0).contains(&rounded){i32::MIN}else{rounded as i32},
        IntegerProfile::LegacyCrt=>if !(-9223372036854775808.0..9223372036854775808.0).contains(&rounded){0}else{(rounded as i64) as i32}
    }};
    Ok([minimum(values[0]),minimum(values[1]),maximum(values[2]),maximum(values[3])])
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn original_crt_and_sse_profiles_match_finite_bounds_and_conversion_limits() {
    let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_spatial_rounding_contract.json")).unwrap();assert_eq!(p["passed"],true);
    for c in p["cases"].as_array().unwrap() {
        let decode=|v:&serde_json::Value|f32::from_bits(v.as_u64().unwrap() as u32);
        let center=std::array::from_fn(|i|decode(&c["center_bits"][i]));let local=std::array::from_fn(|i|decode(&c["local_bounds_bits"][i]));
        let profile=if c["integer_sse"].as_bool().unwrap(){IntegerProfile::Sse}else{IntegerProfile::LegacyCrt};
        assert_eq!(recalculate(center,local,profile).unwrap(),std::array::from_fn(|i|c["integer_bounds"][i].as_i64().unwrap() as i32),"native bounds {c}");
    }
    let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_spatial_bounds_contract.json")).unwrap();
    for c in p["cases"].as_array().unwrap(){assert_eq!(recalculate(std::array::from_fn(|i|c["center"][i].as_f64().unwrap() as f32),std::array::from_fn(|i|c["local_bounds"][i].as_f64().unwrap() as f32),IntegerProfile::LegacyCrt).unwrap(),std::array::from_fn(|i|c["integer_bounds"][i].as_i64().unwrap() as i32));}
 }
}
''',encoding='utf-8')
main=r/'crates/client/src/main.rs';s=main.read_text(encoding='utf-8');assert 'mod grass_spatial_bounds;' not in s
main.write_text('#[allow(dead_code)]\nmod grass_spatial_bounds;\n'+s,encoding='utf-8')
for name in ['probe_native_grass_spatial_rounding.py','integrate_grass_spatial_bounds.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print('Native finite spatial bounds port installed; nonfinite CRT paths return explicit unqualified error.')
