//! Original 9A3080 structural file loop, creation mode only.
//! Resource/font/effect handles and group association are deliberately separate.
use crate::{native_hud_property_driver::{read_line,Cursor},native_hud_property_text::scan_pattern,native_hud_record_header,native_hud_record_population::{parse_record,PopulatedRecord}};

pub struct StructuredFile {
    pub header_assignments:i32,
    pub accepted:Vec<PopulatedRecord>,
    pub rejected:Vec<PopulatedRecord>,
    pub warnings:usize,
}
impl StructuredFile {
    pub fn effect_count(&self)->usize {self.accepted.iter().filter(|r|r.element.storage.kind()==2).count()}
}
pub fn parse(data:&[u8])->Result<StructuredFile,&'static str> {
    let mut cursor=Cursor {data,position:0};
    let first=read_line(&mut cursor)?;
    let header=scan_pattern(&first,b"BaseOffset:",b",")?;
    let mut file=StructuredFile {header_assignments:header.assignments,accepted:Vec::new(),rejected:Vec::new(),warnings:0};
    if header.assignments!=2 {return Ok(file);}
    let origin=[header.values[0],header.values[1]];
    while cursor.position<data.len() {
        // Outer comments are skipped bytewise to LF, without the header line cap.
        if data[cursor.position]==b'/' {
            while cursor.position<data.len() {let byte=data[cursor.position];cursor.position+=1;if byte==b'\n' {break;}}
            continue;
        }
        let start=cursor.position;
        let header=native_hud_record_header::read(&data[start..],0,[0;32])?;
        if !header.accepted {cursor.position+=header.consumed;}
        else {
            let record=parse_record(&data[start..],origin,1.0)?;
            cursor.position+=record.consumed;
            file.warnings+=record.warnings;
            if record.accepted {file.accepted.push(record);} else {file.rejected.push(record);}
        }
        if cursor.position<=start {return Err("native HUD structural loop made no progress");}
    }
    Ok(file)
}

#[cfg(test)] mod tests {
    use super::*;
    fn decode(s:&str)->Vec<u8> {(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
    #[test] fn original_whole_file_loop_matches_all_32_sources_and_two_provenance_repairs() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_file_loop_contract.json")).unwrap();
        assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],34);
        for case in proof["cases"].as_array().unwrap() {
            let label=format!("{}:{}",case["path"],case["variant"]);
            let actual=parse(&decode(case["input_hex"].as_str().unwrap())).unwrap();
            assert_eq!(actual.header_assignments,case["header_assignments"].as_i64().unwrap() as i32,"{label}");
            assert_eq!(actual.warnings,case["warnings"].as_u64().unwrap() as usize,"{label}");
            assert_eq!(actual.accepted.len(),case["live_general_list_count"].as_u64().unwrap() as usize,"{label}");
            assert_eq!(actual.effect_count(),case["live_effect_list_count"].as_u64().unwrap() as usize,"{label}");
            for (records,key) in [(&actual.accepted,"accepted"),(&actual.rejected,"rejected")] {
                let expected=case[key].as_array().unwrap();assert_eq!(records.len(),expected.len(),"{label}:{key}");
                for (record,expected) in records.iter().zip(expected) {
                    assert_eq!(record.element.storage.kind(),expected["kind"].as_u64().unwrap() as u32,"{label}");
                    let bytes=record.element.storage.bytes();let end=bytes[..32].iter().position(|b|*b==0).unwrap();
                    assert_eq!(&bytes[..end],expected["name"].as_str().unwrap().as_bytes(),"{label}");
                    assert_eq!(bytes,decode(expected["output_hex"].as_str().unwrap()),"{label}:{}",expected["name"]);
                }
            }
        }
    }
}
