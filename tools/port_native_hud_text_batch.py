from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/native_hud_text_batch.rs';assert not p.exists()
p.write_text('''//! Original9A81B0 text packet preparation; Rust owns records and font handles.
//! Caller supplies initialized bounds and transformed rectangles; allocation is separate.
use crate::{native_hud_element_storage::ElementStorage,native_hud_layout};
pub struct Input<'a> {pub flags:u32,pub font:u32,pub alignment:u32,pub color:u32,pub rect:[f32;4],pub text:&'a [u8]}
pub struct Record {pub bytes:[u8;288],pub copy_error:Option<u32>}
pub struct Batch {pub records:Vec<Record>,pub fonts:Vec<u32>,pub bounds:[f32;4]}
pub fn prepare(inputs:&[Input<'_>],initial_bounds:[f32;4])->Result<Batch,&'static str> {
    if initial_bounds.iter().chain(inputs.iter().flat_map(|i|i.rect.iter())).any(|v|!v.is_finite()) {return Err("unqualified nonfinite HUD batch bounds")}
    let mut batch=Batch {records:Vec::new(),fonts:Vec::new(),bounds:initial_bounds};
    for input in inputs {
        for k in 0..2 {if batch.bounds[k]>input.rect[k] {batch.bounds[k]=input.rect[k];}}
        for k in 2..4 {if batch.bounds[k]<=input.rect[k] {batch.bounds[k]=input.rect[k];}}
        if input.flags&1==0 {continue}
        let mut bytes=[0u8;288];
        for (off,value) in [(0,input.font),(4,input.alignment),(8,input.color)] {bytes[off..off+4].copy_from_slice(&value.to_le_bytes());}
        for (k,value) in input.rect.iter().enumerate() {bytes[12+k*4..16+k*4].copy_from_slice(&value.to_bits().to_le_bytes());}
        let length=input.text.iter().position(|b|*b==0).unwrap_or(input.text.len());let copied=length.min(256);
        bytes[28..28+copied].copy_from_slice(&input.text[..copied]);
        let copy_error=if length>=256 {bytes[28]=0;Some(34)}else {None};bytes[284]=u8::from(input.flags&0x80!=0);
        batch.records.push(Record {bytes,copy_error});if !batch.fonts.contains(&input.font) {batch.fonts.push(input.font);}
    }
    Ok(batch)
}
/// Source element storage -> qualified normalized layout -> original packet fields.
/// Font handle assignment remains caller-owned, distinct from native pointer identity.
pub fn from_elements(elements:&mut [&mut ElementStorage],viewport:[u32;2],scalar:f32,batch_index:u32,bounds:[f32;4])->Result<Batch,&'static str> {
    let mut rects=Vec::with_capacity(elements.len());
    for storage in elements.iter_mut() {
        if storage.kind()!=3 {return Err("HUD text batch contains a non-Text element")}
        let float=|off|f32::from_bits(storage.word(off));
        rects.push(native_hud_layout::transform(&native_hud_layout::Input {flags:storage.flags(),width:viewport[0],height:viewport[1],owner_scalar:scalar,rect:[float(0x1c0),float(0x1c4),float(0x1c8),float(0x1cc)],anchors:[float(0x1a8),float(0x1ac),float(0x1b0),float(0x1b4)],motion_offset:[float(0x1b8),float(0x1bc)],include_motion:false,group_offset:None,fractions:storage.initial_fractions(),aspect:float(0x1d8)})?);
        storage.set_word(0x4c,batch_index);
    }
    let inputs=elements.iter().zip(rects).map(|(storage,rect)|Input {flags:storage.flags(),font:storage.word(0x200),alignment:storage.word(0x208),color:storage.word(0x1dc),rect,text:&storage.bytes()[0x20c..0x30c]}).collect::<Vec<_>>();
    prepare(&inputs,bounds)
}
#[cfg(test)] mod tests {
    use super::*;
    fn decode(s:&str)->Vec<u8> {(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
    #[test] fn all1210_original_batches_match_records_bounds_and_font_order() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_text_batch_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],1210);
        for c in p["cases"].as_array().unwrap() {
            let texts=c["inputs"].as_array().unwrap().iter().map(|i|decode(i["text_hex"].as_str().unwrap())).collect::<Vec<_>>();
            let inputs=c["inputs"].as_array().unwrap().iter().zip(&texts).map(|(i,text)|Input {flags:i["flags"].as_u64().unwrap() as u32,font:i["font"].as_u64().unwrap() as u32,alignment:i["alignment"].as_u64().unwrap() as u32,color:i["color"].as_u64().unwrap() as u32,rect:std::array::from_fn(|k|i["rect"][k].as_f64().unwrap() as f32),text}).collect::<Vec<_>>();
            let batch=prepare(&inputs,[1.0,1.0,0.0,0.0]).unwrap();assert_eq!(batch.records.len(),c["record_hex"].as_array().unwrap().len());
            for (record,expected) in batch.records.iter().zip(c["record_hex"].as_array().unwrap()) {assert_eq!(record.bytes.as_slice(),decode(expected.as_str().unwrap()));}
            assert_eq!(batch.fonts,c["font_handles"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>());
            assert_eq!(batch.bounds.map(f32::to_bits),std::array::from_fn(|i|(c["bounds"][i].as_f64().unwrap() as f32).to_bits()));
        }
        let b=prepare(&[Input {flags:1,font:0,alignment:0,color:0,rect:[0.0;4],text:&[65;256]}],[0.0;4]).unwrap();assert_eq!(b.records[0].copy_error,Some(34));assert_eq!(b.records[0].bytes[28],0);
        assert!(prepare(&[],[f32::NAN;4]).is_err());
    }
    #[test] fn all154_source_text_storages_connect_layout_and_batch_fields() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_source_records_contract.json")).unwrap();
        let cases=p["cases"].as_array().unwrap().iter().filter(|c|c["kind"]==3).collect::<Vec<_>>();assert_eq!(cases.len(),154);
        for viewport in [[1280,800],[1920,1080]] {
            let mut storages=cases.iter().map(|c|{let mut s=ElementStorage::new(3).unwrap();s.write_bytes(0,&decode(c["output_hex"].as_str().unwrap()));s}).collect::<Vec<_>>();
            let enabled=storages.iter().filter(|s|s.flags()&1!=0).count();let mut refs=storages.iter_mut().collect::<Vec<_>>();
            let batch=from_elements(&mut refs,viewport,1.0,7,[1.0,1.0,0.0,0.0]).unwrap();assert_eq!(batch.records.len(),enabled);
            assert!(storages.iter().all(|s|s.word(0x4c)==7));
            for (record,storage) in batch.records.iter().zip(storages.iter().filter(|s|s.flags()&1!=0)) {
                assert_eq!(&record.bytes[4..12],&storage.bytes()[0x208..0x20c].iter().copied().chain(storage.bytes()[0x1dc..0x1e0].iter().copied()).collect::<Vec<_>>());
                assert_eq!(record.bytes[284],u8::from(storage.flags()&0x80!=0));assert_eq!(record.copy_error,None);
            }
        }
    }
}
''',encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');s='mod native_hud_text_batch;\n'+s;p.write_text(s,encoding='utf-8')
for name in ['qualify_native_hud_text_batch.py','port_native_hud_text_batch.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print('Native text batch builder and source storage/layout bridge ported')
