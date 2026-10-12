use crate::{native_complex_surface_prepare as prepare, native_complex_surface_tail as tail};
use serde_json::Value;
fn array<const N:usize>(v:&Value)->[f32;N] {
    std::array::from_fn(|i|v[i].as_f64().unwrap() as f32)
}
fn identity()->[f32;16] {[1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.]}
#[test]
fn native_surface_matrix_and_translation_match_864_original_callbacks() {
    let path=std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .join("../../data/4.20/relic_runes/complex_surface_matrix_contract.json");
    let p:Value=serde_json::from_str(&std::fs::read_to_string(path).unwrap()).unwrap();
    assert_eq!(p["native_sha256"],"402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862");
    let rows=p["cases"].as_array().unwrap(); assert_eq!(rows.len(),864);
    for (index,r) in rows.iter().enumerate() {
        let bytes=r["before_hex"].as_str().unwrap();
        let mut owner=[0f32;16];
        for i in 0..16 {
            let raw:[u8;4]=std::array::from_fn(|j|u8::from_str_radix(&bytes[(i*4+j)*2..(i*4+j)*2+2],16).unwrap());
            owner[i]=f32::from_le_bytes(raw);
        }
        let mut motion=identity();motion[12..15].copy_from_slice(&[7.,11.,13.]);
        let actual=prepare::prepare(prepare::Input {owner_matrix:owner,
            motion_matrix:motion,motion_vector:[2.,3.,5.],direct:r["direct"].as_bool().unwrap()}).unwrap();
        assert_eq!(actual.matrix.map(f32::to_bits),array::<16>(&r["prepared"]["matrix"]).map(f32::to_bits),"matrix {index}");
        let expected=array::<3>(&r["prepared"]["rotated_vector"]);
        for i in 0..3 {
            assert!((actual.vector[i]-expected[i]).abs()<=1e-5,"rotation {index}/{i}");
        }
        let time=r["time"].as_f64().unwrap() as f32;let life=r["life"].as_f64().unwrap() as f32;
        let age=crate::native_complex_particle_age::evaluate(time,0.,life).normalized;
        let slot=((2.*age) as usize).min(1);
        let mut bind=r["bind_table"][slot].as_f64().unwrap() as f32;
        if let Some(f)=r["probability_constant"].as_f64(){bind*=f as f32;}
        let result=tail::compose_without_terrain(tail::Input {
            prepared_matrix:actual.matrix,rotated_motion_vector:actual.vector,
            accumulated_owner_translation:[29.,31.,37.],owner_delta:[3.,5.,7.],
            owner_extra_offset:[2.,4.,6.],default_vector:array(&p["default_vector"]),
            sampled_vector:[[1.,2.,3.],[4.,5.,6.]][slot],sampled_bind:bind,
            particle_life:life,frame_delta:if r["initialized"]==1 {time}else{0.},
        });
        assert_eq!(result.world_matrix.map(f32::to_bits),array::<16>(&r["world_matrix"]).map(f32::to_bits),"world {index}");
        assert_eq!(result.accumulated_owner_translation.map(f32::to_bits),array::<3>(&r["accumulated_owner_translation"]).map(f32::to_bits),"owner {index}");
        let expected=array::<3>(&r["surface_vector"]);
        for i in 0..3 {assert!((result.surface_vector[i]-expected[i]).abs()<=1e-5,"final {index}/{i}");}
    }
}
#[test]
fn surface_rejects_nonfinite_native_inputs_before_quaternion_helpers() {
    let mut input=prepare::Input {owner_matrix:identity(),
        motion_matrix:identity(),motion_vector:[0.;3],direct:false};
    input.owner_matrix[0]=f32::NAN;
    assert!(prepare::prepare(input).is_err());
}
