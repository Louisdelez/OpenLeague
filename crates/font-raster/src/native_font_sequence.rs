//! Original8BE4C0 prepared-cell sequence. Text parsing/wrapping/lifecycle are separate.
use crate::Error;
#[derive(Clone,Debug)]
pub struct Glyph {pub id:u32,pub bearing_x:i32,pub advance:u32}
#[derive(Clone,Debug)]
pub struct Layout {pub position:[f32;2],pub dimensions:[i32;2],pub font_vertical_add:i32,pub font_vertical_subtract:i32,pub horizontal:u32,pub vertical:u32,pub font_scale_x:f32,pub owner_scale:f32,pub space_advance:i32}
#[derive(Clone,Debug,PartialEq)]
pub struct Draw {pub cell_index:usize,pub glyph_id:u32,pub position:[f32;2]}
/// Consume the already prepared native glyph-cell vector; None is the native NULL cell.
/// This does not infer line breaks or wrapping from a UTF16 string.
pub fn sequence(layout:&Layout,cells:&[Option<Glyph>],mut kerning:impl FnMut(u32,u32)->i32)->Result<Vec<Draw>,Error> {
    if layout.position.iter().any(|v|!v.is_finite()) || !layout.font_scale_x.is_finite() || !layout.owner_scale.is_finite() {return Err(Error("native sequence input outside finite domain".into()))}
    let [mut cursor,y]=crate::native_font_quad::align(layout.position,layout.dimensions,layout.font_vertical_add,layout.font_vertical_subtract,layout.horizontal,layout.vertical);
    let mut previous=None;let mut draws=Vec::new();
    for (cell_index,cell) in cells.iter().enumerate() {
        let Some(glyph)=cell else {cursor+=layout.space_advance as f32;previous=None;continue};
        let mut x=cursor+glyph.bearing_x as f32;let y=y-layout.font_vertical_add as f32;
        if let Some(left)=previous {let offset=kerning(left,glyph.id) as f32*layout.font_scale_x;x+=offset}
        if !x.is_finite()||!y.is_finite() {return Err(Error("native sequence position outside finite domain".into()))}
        draws.push(Draw {cell_index,glyph_id:glyph.id,position:[x,y]});
        // Native FILD u32 -> x87 owner scale -> store f32, then x87 scale/add -> store f32.
        let advance=(glyph.advance as f64*layout.owner_scale as f64) as f32;
        cursor=(advance as f64*layout.font_scale_x as f64+cursor as f64) as f32;
        if !cursor.is_finite() {return Err(Error("native sequence advance outside finite domain".into()))}
        previous=Some(glyph.id);
    }
    Ok(draws)
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn sequence_draw_bits_and_kerning_calls_match2016_native_executions() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_font_sequence_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],2016);
        for c in p["cases"].as_array().unwrap() {
            let cells=c["glyph_ids"].as_array().unwrap().iter().map(|id|id.as_u64().map(|id|Glyph {id:id as u32,bearing_x:if id==0 {-2}else{3},advance:if id==0 {13}else{17}})).collect::<Vec<_>>();
            let layout=Layout {position:[c["position"][0].as_f64().unwrap() as f32,c["position"][1].as_f64().unwrap() as f32],dimensions:[31,43],font_vertical_add:24,font_vertical_subtract:-5,horizontal:c["horizontal"].as_u64().unwrap() as u32,vertical:c["vertical"].as_u64().unwrap() as u32,font_scale_x:c["font_scale"].as_f64().unwrap() as f32,owner_scale:c["owner_scale"].as_f64().unwrap() as f32,space_advance:c["space_advance"].as_i64().unwrap() as i32};
            let mut calls=Vec::new();let draws=sequence(&layout,&cells,|left,right|{calls.push([left,right]);c["kerning"].as_i64().unwrap() as i32}).unwrap();let expected=c["draws"].as_array().unwrap();assert_eq!(draws.len(),expected.len());
            for (draw,expected) in draws.iter().zip(expected) {assert_eq!(draw.glyph_id,expected["glyph_id"].as_u64().unwrap() as u32);assert_eq!(draw.position.map(f32::to_bits),[expected["position_bits"][0].as_u64().unwrap() as u32,expected["position_bits"][1].as_u64().unwrap() as u32]);assert_eq!(cells[draw.cell_index].as_ref().unwrap().id,draw.glyph_id);}
            assert_eq!(calls,c["kerning_calls"].as_array().unwrap().iter().map(|a|[a[0].as_u64().unwrap() as u32,a[1].as_u64().unwrap() as u32]).collect::<Vec<_>>());
        }
    }
}

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

#[derive(Clone,Debug,PartialEq,Eq)]
pub struct FacePixels {pub ascender:i32,pub descent:i32,pub height:i32,pub space_advance:i32}
pub fn face_pixels(ascender:i32,descender:i32,height:i32,space_advance:i32)->FacePixels {
    FacePixels {ascender:ascender>>6,descent:descender.wrapping_neg()>>6,height:height>>6,space_advance:space_advance>>6}
}
#[cfg(test)] mod face_tests {
    use super::*;
    #[test] fn face_metric_pixels_match108_native_suffix_executions() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_font_face_metrics_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],108);
        for c in p["cases"].as_array().unwrap() {let v=c["metrics_26_6"].as_array().unwrap().iter().map(|v|v.as_i64().unwrap() as i32).collect::<Vec<_>>();let m=face_pixels(v[0],v[1],v[2],v[3]);assert_eq!([m.ascender,m.descent,m.height,m.space_advance],c["pixels"].as_array().unwrap().iter().map(|v|v.as_i64().unwrap() as i32).collect::<Vec<_>>().as_slice());}
    }
}
