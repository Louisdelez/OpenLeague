//! Additive tests; include as a separate cfg(test) module of the core crate.
use crate::native_simple_type11_draw::{prepare_frame, prepare, Frame, Transform};
use crate::native_simple_type11_pose::Pose;
use serde_json::Value;

fn words(v: &Value) -> Vec<u32> {
    v.as_array().unwrap().iter().map(|x| u32::from_str_radix(x.as_str().unwrap(), 16).unwrap()).collect()
}
fn floats<const N: usize>(v: &Value) -> [u32; N] {
    std::array::from_fn(|i| (v[i].as_f64().unwrap() as f32).to_bits())
}
fn close(actual: &[u32], expected: &[u32], absolute: f32, relative: f32) {
    assert_eq!(actual.len(), expected.len());
    for (i, (&a, &e)) in actual.iter().zip(expected).enumerate() {
        let (a, e) = (f32::from_bits(a), f32::from_bits(e));
        assert!(a.is_finite() && e.is_finite());
        let tolerance = absolute.max(relative * e.abs());
        assert!((a-e).abs() <= tolerance, "component {i}: {a} != {e}, tolerance {tolerance}");
    }
}
#[test]
fn native_type11_frame_cardinal_turns_cover_nonpositive_quaternion_trace() {
    let proof: Value = serde_json::from_str(include_str!("../../../data/4.20/type11_frame_turns_contract.json")).unwrap();
    let rows = proof["cases"].as_array().unwrap();
    assert_eq!(rows.len(), 3);
    assert_eq!(proof["trace_nonpositive_yaws"], serde_json::json!([180]));
    for row in rows {
        let p = &row["inputs"];
        let frame = Frame { position: floats(&p["position"]), right: floats(&p["right"]), up: floats(&p["up"]), scale: (p["scale"].as_f64().unwrap() as f32).to_bits(), matrix: floats(&p["matrix"]) };
        assert_eq!(frame.up, [0, 0x3f800000, 0x80000000]);
        assert_eq!(frame.right, [0x3f800000, 0, 0x80000000]);
        let native = words(&row["frame_words"][0]);
        close(&prepare_frame(frame).unwrap().0, &native, 1e-5, 3e-6);
        let raw = words(&row["input_joint_words"]);
        let joints = raw.chunks_exact(10).map(|j| Transform(j.try_into().unwrap()).to_joint()).collect::<Vec<_>>();
        let pose = Pose::new(1, joints.clone()).unwrap();
        let prepared = prepare(frame, Transform(floats(&p["inverse"])), &pose).unwrap();
        close(&prepared.combined.0, &words(&row["combined_transform_words"][0]), 1e-5, 3e-6);
        let actual = prepared.palette.iter().flat_map(|j| Transform::from_joint(j).0).collect::<Vec<_>>();
        close(&actual, &words(&row["draws"][0]["joint_words"]), 2e-5, 5e-6);
        assert_eq!(pose.joints(), joints);
        if row["yaw_degrees"] == 180 {
            // The native trace<=0 branch selects the Y axis for this exact matrix.
            assert_eq!(&native[6..], &[0, 0x3f800000, 0, 0]);
        }
    }
}
