from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/font-raster/src/native_font_quad.rs';s=p.read_text(encoding='utf-8');assert 'pub fn align(' not in s
s+=r"""
/// Native8BE3C0, preserving integer half-width/height truncation before float conversion.
/// Metric fields are named by their operation; their original producers remain separate.
pub fn align(position:[f32;2],dimensions:[i32;2],vertical_add:i32,vertical_subtract:i32,horizontal:u32,vertical:u32)->[f32;2] {
    let [x,y]=position;
    let x=match horizontal {0=>x,1=>x-(dimensions[0]/2) as f32,_=>x-dimensions[0] as f32};
    let y=match vertical {0=>y,1=>y+vertical_add as f32,2=>{let y=y+vertical_add as f32;y-(dimensions[1]/2) as f32},_=>y-vertical_subtract as f32};
    [x,y]
}
#[cfg(test)] mod alignment_tests {
    use super::*;
    #[test] fn text_origin_bits_match3072_original_alignment_executions() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_font_alignment_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],3072);
        for c in p["cases"].as_array().unwrap() {
            let position=[c["position"][0].as_f64().unwrap() as f32,c["position"][1].as_f64().unwrap() as f32];let dimensions=[c["dimensions"][0].as_i64().unwrap() as i32,c["dimensions"][1].as_i64().unwrap() as i32];
            let actual=align(position,dimensions,c["font_vertical_add"].as_i64().unwrap() as i32,c["font_vertical_subtract"].as_i64().unwrap() as i32,c["horizontal"].as_u64().unwrap() as u32,c["vertical"].as_u64().unwrap() as u32).map(f32::to_bits);
            assert_eq!(actual,[c["output_bits"][0].as_u64().unwrap() as u32,c["output_bits"][1].as_u64().unwrap() as u32]);
        }
    }
}
"""
p.write_text(s,encoding='utf-8');shutil.copy2(Path('E:/mapslol3v3/qualify_native_font_alignment.py'),r/'tools/qualify_native_font_alignment.py')
