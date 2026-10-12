use crate::{native_complex_movement as movement,native_particle_euler_matrix as euler};
use serde_json::Value;
fn read(name:&str)->Value {
    let path=std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../../data/4.20/relic_runes").join(name);
    serde_json::from_str(&std::fs::read_to_string(path).unwrap()).unwrap()
}
fn array<const N:usize>(v:&Value)->[f32;N] {std::array::from_fn(|i|v[i].as_f64().unwrap() as f32)}
fn setup(r:&Value)->([f32;53],movement::Input) {
    let mut record=[0.;53];
    for (offset,key) in [(0x58,"birth_velocity"),(0x64,"birth_acceleration"),(0x70,"birth_drag"),(0x88,"initial_stored_velocity")] {
        record[offset/4..offset/4+3].copy_from_slice(&array::<3>(&r[key]));
    }
    record[19..22].copy_from_slice(&[7.,11.,13.]);record[40..43].copy_from_slice(&[5.,10.,20.]);
    record[43..46].copy_from_slice(&[15.,-30.,45.]);record[49..52].copy_from_slice(&array::<3>(&r["orbit_velocity"]));
    let time=r["time"].as_f64().unwrap() as f32;let life=r["life"].as_f64().unwrap() as f32;
    let age=crate::native_complex_particle_age::evaluate(time,0.,life).normalized;
    let slot=((2.*age) as usize).min(1);
    (record,movement::Input {time,birth:0.,previous_time:r["previous_time"].as_f64().unwrap() as f32,
        initialized:r["initialized"]==1,sampled_acceleration:array(&r["acceleration_table"][slot]),
        sampled_velocity:array(&r["velocity_table"][slot]),sampled_drag:array(&r["drag_table"][slot]),
        force:false,lifetime_quad_rotation:false,local_rotation:r["local"].as_bool().unwrap(),
        owner_special_offset:false,attach_owner:r["attach"].as_bool().unwrap(),velocity_alignment:false,
        owner_matrix:Some(array(&r["owner_matrix"])),local_matrix:Some(array(&r["local_matrix"]))})
}
#[test]
fn movement_matches_1728_original_owner_local_orbit_callbacks_bit_exactly() {
    let p=read("complex_optional_movement_contract.json");
    assert_eq!(p["native_sha256"],"402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862");
    let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),1728);
    for (index,r) in rows.iter().enumerate() {
        let (mut record,input)=setup(r);movement::update(input,&mut record).unwrap();
        for (offset,key,n) in [(0,"motion_matrix",16),(16,"motion_vector",3),(37,"position_accumulator",3),(34,"stored_velocity",3)] {
            for axis in 0..n {
                let expected=r[key][axis].as_f64().unwrap() as f32;
                assert_eq!(record[offset+axis].to_bits(),expected.to_bits(),"row{index} {key}/{axis}");
            }
        }
        assert_eq!(record[52].to_bits(),(r["rotation_x_field"].as_f64().unwrap() as f32).to_bits());
    }
}
#[test]
fn unsupported_force_and_missing_owner_matrix_preserve_particle_record() {
    let p=read("complex_optional_movement_contract.json");let (record,mut input)=setup(&p["cases"][0]);
    input.force=true;let mut current=record;
    assert!(movement::update(input,&mut current).is_err());assert_eq!(current.map(f32::to_bits),record.map(f32::to_bits));
    input.force=false;input.attach_owner=true;input.owner_matrix=None;
    assert!(movement::update(input,&mut current).is_err());assert_eq!(current.map(f32::to_bits),record.map(f32::to_bits));
}
#[test]
fn euler_matrix_matches_125_original_x87_sse_helpers_bit_exactly() {
    let p=read("euler_matrix_contract.json");let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),125);
    for r in rows {
        let matrix=euler::compose(array(&r["angles"])).unwrap();
        for i in 0..16 {assert_eq!(matrix[i].to_bits(),r["matrix_bits"][i].as_u64().unwrap() as u32);}
    }
}
