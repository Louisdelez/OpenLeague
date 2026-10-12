//! Original99F4BB matrix preparation suffix; full clip matrix producer is separate.
use crate::Error;
pub fn matrix(mut matrix:[f32;16],viewport:[u32;2],scale:f32)->Result<[f32;16],Error> {
    if matrix.iter().any(|v|!v.is_finite()) || !scale.is_finite() || scale<=0.0 {return Err(Error("unqualified text projection matrix".into()))}
    matrix[0]*=scale;matrix[5]*=scale;matrix[12]=(matrix[12] as f64*viewport[0] as f64) as f32;matrix[13]=(matrix[13] as f64*viewport[1] as f64) as f32;Ok(matrix)
}
#[cfg(test)] mod tests {
    #[test] fn matrix_suffix_matches30_original_executions() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_text_projection_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],30);
        for c in p["cases"].as_array().unwrap() {let matrix=std::array::from_fn(|i|f32::from_bits(c["matrix_bits"][i].as_u64().unwrap() as u32));let actual=super::matrix(matrix,[c["viewport"][0].as_u64().unwrap() as u32,c["viewport"][1].as_u64().unwrap() as u32],f32::from_bits(c["scale_bits"].as_u64().unwrap() as u32)).unwrap().map(f32::to_bits);assert_eq!(actual,std::array::from_fn(|i|c["output_bits"][i].as_u64().unwrap() as u32));}
    }
}
