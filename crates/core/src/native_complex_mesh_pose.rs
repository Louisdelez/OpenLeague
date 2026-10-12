//! Actual97EC60..97EDDE model-matrix branch, before view/device operations.
//! Caller must supply the native fields, not infer them from a Bevy Transform.
type Matrix=[f32;16];
fn identity()->Matrix {[1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.]}
fn translation(value:[f32;3])->Matrix {let mut m=identity();m[12..15].copy_from_slice(&value);m}
#[derive(Debug,Clone,Copy)]
pub struct Inputs {
    /// render object+AD, +DD, +D1 and +F0 respectively; native row-major layout.
    pub centre:[f32;3], pub scale:[f32;3], pub post_offset:[f32;3],pub pose:Matrix,
}
/// Retains the four native8DF790 multiplications, with separate f32 operations.
/// No shader, projection, bone provider or97EA60 vertex packing is replaced here.
pub fn compose(input:Inputs)->Result<Matrix,&'static str> {
    if !input.centre.iter().chain(&input.scale).chain(&input.post_offset).chain(&input.pose).all(|v|v.is_finite()) {
        return Err("unsupported nonfinite Complex mesh pose");
    }
    let mut scale=identity();for i in 0..3 {scale[i*5]=input.scale[i];}
    let m=crate::camera_view::multiply(&translation(input.post_offset),&translation(input.centre.map(|v|-v)));
    let m=crate::camera_view::multiply(&m,&scale);
    let m=crate::camera_view::multiply(&m,&input.pose);
    Ok(crate::camera_view::multiply(&m,&translation(input.centre)))
}
/// Nonzero render object+EC bypasses all centre/scale/post calculations.
pub fn override_matrix(matrix:Matrix)->Result<Matrix,&'static str> {
    if matrix.iter().all(|v|v.is_finite()) {Ok(matrix)} else {Err("unsupported nonfinite Complex override pose")}
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn native_matrix_cases_preserve_centre_and_post_offset_order() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/nexus_crown/crown_native_vectors.json")).unwrap();let rows=p["mesh_matrices"].as_array().unwrap();assert_eq!(rows.len(),24);
        for row in rows {let v=|key:&str|std::array::from_fn(|i|row[key][i].as_f64().unwrap() as f32);
            let actual=compose(Inputs {centre:v("pivot"),scale:v("scale"),post_offset:v("post"),pose:std::array::from_fn(|i|row["pose"][i].as_f64().unwrap() as f32)}).unwrap();
            assert_eq!(actual.map(f32::to_bits).to_vec(),row["matrix"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>());
        }
        assert_eq!(override_matrix(identity()).unwrap().map(f32::to_bits).to_vec(),p["override"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>());
    }
}
