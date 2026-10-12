from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/font-raster/src/native_font_sequence.rs';s=p.read_text(encoding='utf-8');assert 'pub fn prepare(' not in s
s+=r"""
#[derive(Clone,Debug)]
pub struct Prepared {pub cells:Vec<Option<Glyph>>,pub raw_dimensions:[i32;2],pub dimensions:[i32;2]}
/// Original8BF950 consumes stored UTF16 length. String setter/NUL termination are separate.
pub fn prepare(contents:&[u16],space_character:u16,space_advance:i32,line_height:i32,scale:[f32;2],mut lookup:impl FnMut(u16)->Option<Glyph>)->Result<Prepared,Error> {
    let mut width=0i32;let mut cells=Vec::with_capacity(contents.len());
    for &character in contents {
        let glyph=if character==space_character {None}else{lookup(character)};
        width=width.wrapping_add(glyph.as_ref().map_or(space_advance,|g|g.advance as i32));cells.push(glyph);
    }
    let convert=|v:i32,s:f32| {let value=v as f32*s;if !value.is_finite() || !(-2147483648.0..2147483648.0).contains(&value) {Err(Error("native scaled text dimension outside qualified conversion domain".into()))}else{Ok(value.trunc() as i32)}};
    Ok(Prepared {cells,raw_dimensions:[width,line_height],dimensions:[convert(width,scale[0])?,convert(line_height,scale[1])?]})
}
#[cfg(test)] mod prepare_tests {
    use super::*;
    #[test] fn prepared_cells_dimensions_and_lookup_match256_original_executions() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_font_prepare_contract.json")).unwrap();assert_eq!(p["case_count"],256);assert_eq!(p["passed"],true);
        for c in p["cases"].as_array().unwrap() {
            let contents=c["text_utf16"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u16).collect::<Vec<_>>();let mut calls=Vec::new();let failed=c["failed_character"].as_u64();
            let result=prepare(&contents,32,c["space_advance"].as_i64().unwrap() as i32,c["line_height"].as_i64().unwrap() as i32,[c["scale"][0].as_f64().unwrap() as f32,c["scale"][1].as_f64().unwrap() as f32],|character|{calls.push(character);if failed==Some(character as u64) {None}else{Some(Glyph {id:character as u32,bearing_x:0,advance:c["glyph_advance"].as_i64().unwrap() as u32})}}).unwrap();
            assert_eq!(result.cells.iter().map(|g|g.as_ref().map(|g|g.id)).collect::<Vec<_>>(),c["cell_ids"].as_array().unwrap().iter().map(|v|v.as_u64().map(|v|v as u32)).collect::<Vec<_>>());
            assert_eq!([result.raw_dimensions[0],result.raw_dimensions[1],result.dimensions[0],result.dimensions[1]],c["dimensions"].as_array().unwrap().iter().map(|v|v.as_i64().unwrap() as i32).collect::<Vec<_>>().as_slice());assert_eq!(calls,c["lookup_calls"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u16).collect::<Vec<_>>());
        }
    }
}
"""
p.write_text(s,encoding='utf-8');shutil.copy2(Path('E:/mapslol3v3/qualify_native_font_prepare.py'),r/'tools/qualify_native_font_prepare.py')
