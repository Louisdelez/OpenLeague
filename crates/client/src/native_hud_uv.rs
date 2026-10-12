//! Native UV property (9A2590), after formatted scanner outputs.
//! The original scanner grammar and type construction remain separate.
pub fn apply(element_type:u32,scanned:&[f32],assignment_count:i32,type1:&mut [[f32;4];2],type2:&mut [[f32;4];2])->u32 {
    if !matches!(element_type,1|2) || !matches!(assignment_count,4|6) {return 0;}
    assert!(scanned.len()>=assignment_count as usize);
    let mut uv=[scanned[0],scanned[1],scanned[2],scanned[3]];
    if assignment_count==6 {let x=1.0/scanned[4];let y=1.0/scanned[5];uv=[x*uv[0],y*uv[1],x*uv[2],y*uv[3]];}
    if element_type==1 {*type1=[uv;2];} else {*type2=[uv;2];}
    64
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn original_uv_type_guards_math_and_storage_match() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_uv_property_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],240);
        for c in p["cases"].as_array().unwrap() {
            let floats=|key:&str|c[key].as_array().unwrap().iter().map(|v|f32::from_bits(v.as_u64().unwrap() as u32)).collect::<Vec<_>>();
            let mut scanned=floats("coordinates_bits");scanned.extend(floats("dimensions_bits"));let mut a=[[f32::from_bits(0xa5a5a5a5);4];2];let mut b=a;
            assert_eq!(apply(c["element_type"].as_u64().unwrap() as u32,&scanned,c["scan_count"].as_i64().unwrap() as i32,&mut a,&mut b),c["result"].as_u64().unwrap() as u32);
            for (out,key) in [(a,"type1_output_bits"),(b,"type2_output_bits")] {assert_eq!(out.into_iter().flatten().map(f32::to_bits).collect::<Vec<_>>(),c[key].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>());}
        }
    }
}
