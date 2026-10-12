//! Native944A10 motion helper. Different alignment threshold, no tangent sign flip.
pub fn update(axis:[u32;3],position:[u32;3],velocity:&mut [u32;3],center:[u32;3])->Result<(),&'static str> {
    crate::native_particle_axis_force::reorient(axis,position,velocity,center,814313567,false)
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::Value;
    fn words(v:&Value)->[u32;3]{std::array::from_fn(|j|v[j].as_u64().unwrap() as u32)}
    #[test]
    fn motion_reorientation_matches784_native_cpu_cases() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_motion_axis_contract.json")).unwrap();let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),784);
        for (i,r) in rows.iter().enumerate() {
            let mut velocity=words(&r["velocity"]);update(words(&r["axis"]),words(&r["position"]),&mut velocity,words(&r["parameters"])).unwrap();
            assert_eq!(velocity,words(&r["cpu"]["velocity"]),"velocity case{i}");assert_eq!(words(&r["position"]),words(&r["cpu"]["position"]));assert_eq!(words(&r["parameters"]),words(&r["cpu"]["parameters"]));
        }
    }
}
