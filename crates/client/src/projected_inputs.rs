//! Original Simple projected renderer arithmetic; factor producers are separate.
use bevy::prelude::*;
pub struct ProjectionInputs {pub position:Vec3,pub half_size:Vec2,pub angle:f32}
impl ProjectionInputs {
    pub fn new(position:Vec3,particle_scale:f32,emitter_scale:f32,system_c0:f32,system_bc:f32,bias:Vec2,angle:f32)->Result<Self,&'static str> {
        if !position.is_finite() || !bias.is_finite() || [particle_scale,emitter_scale,system_c0,system_bc,angle].iter().any(|v|!v.is_finite()) {return Err("nonfinite projected render input");}
        // Match separate native SSE multiplies and their rounding order.
        let system_scale=system_c0*system_bc;
        let particle_emitter_scale=particle_scale*emitter_scale;
        let scale=particle_emitter_scale*system_scale;
        let half_size=bias*scale;
        if !half_size.is_finite() || half_size.x<=0. || half_size.y<=0. {return Err("unsupported degenerate projected footprint");}
        Ok(Self{position,half_size,angle})
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn footprint_and_angle_match_original_render_input_segments() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/projected_inputs_contract.json")).unwrap();
        for c in p["cases"].as_array().unwrap() {
            let f=|k:&str| c[k].as_f64().unwrap() as f32;
            let v=|k:&str,i:usize| c[k][i].as_f64().unwrap() as f32;
            let a=ProjectionInputs::new(Vec3::new(v("position",0),v("position",1),v("position",2)),f("particle_scale"),f("emitter_scale"),f("system_c0"),f("system_bc"),Vec2::new(v("bias",0),v("bias",1)),f("angle")).unwrap();
            assert_eq!(a.half_size,Vec2::new(v("half_size",0),v("half_size",1)));
            assert_eq!(a.angle,f("render_angle"));
            assert_eq!(a.position,Vec3::new(100.,200.,300.));
        }
    }
}
