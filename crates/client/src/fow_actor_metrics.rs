//! Native617970 raw geometry initialization and614E40 fallback.
//! CharacterData loading, motion provider update and final callback remain open.
#[derive(Clone,Copy)] pub struct CharacterGeometry {pub shape:f32,pub radius:f32,pub secondary:f32,pub geometry_factor:f32}
#[derive(Clone,Copy)] pub struct ActorGeometry {pub min:[f32;3],pub max:[f32;3],pub model_scale:f32}
#[derive(Clone,Copy)] pub struct ActorMetrics {pub height:f32,pub resolved_radius:f32,pub raw_radius:f32,pub raw_shape:f32,pub raw_secondary:f32}
pub struct Initialization {pub notify:bool,pub invalid_radius_warning:bool}
impl ActorGeometry {
    pub fn fallback(self,factor:f32)->f32 {
        if factor!=0. {(f64::from(self.model_scale)*f64::from(factor)) as f32}
        else {(((f64::from(self.max[2])-f64::from(self.min[2]))+(f64::from(self.max[0])-f64::from(self.min[0])))*0.25) as f32}
    }
}
impl ActorMetrics {
    pub fn initialize(&mut self,character:Option<CharacterGeometry>,geometry:ActorGeometry)->Initialization {
        let Some(c)=character else {return Initialization {notify:false,invalid_radius_warning:false};};
        self.raw_shape=c.shape;self.raw_radius=c.radius;self.raw_secondary=c.secondary;
        self.height=if c.shape<=0. {let h=geometry.max[1]-geometry.min[1];if h< -0.00001 {geometry.fallback(c.geometry_factor)}else{h}}else{c.shape};
        self.resolved_radius=if c.radius<=0. {geometry.fallback(c.geometry_factor)}else{c.radius};
        if self.resolved_radius!= -1. && self.raw_secondary<0. {self.raw_secondary=self.resolved_radius*0.68;}
        Initialization {notify:true,invalid_radius_warning:!(self.resolved_radius>= -0.00001 && self.resolved_radius<1000.)}
    }
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn native_geometry_fallback_raw_metrics_and_notifications_match() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_actor_metrics_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),72);
        assert_eq!(proof["constants"]["0x1138b40"].as_u64().unwrap() as u32,0.25f32.to_bits());
        for c in proof["cases"].as_array().unwrap() {
            let val=|name:&str|c[name].as_f64().unwrap() as f32;
            let mut a=ActorMetrics {height:9.,resolved_radius:8.,raw_radius:7.,raw_shape:6.,raw_secondary:5.};
            let min=std::array::from_fn(|i|c["bounds_min"][i].as_f64().unwrap() as f32);let max=std::array::from_fn(|i|c["bounds_max"][i].as_f64().unwrap() as f32);
            let character=c["character_present"].as_bool().unwrap().then_some(CharacterGeometry {shape:val("shape"),radius:val("raw_radius"),secondary:val("raw_secondary"),geometry_factor:val("geometry_factor")});
            let report=a.initialize(character,ActorGeometry {min,max,model_scale:val("model_scale")});
            for (i,value) in [a.height,a.resolved_radius,a.raw_radius,a.raw_shape,a.raw_secondary].iter().enumerate() {assert_eq!(value.to_bits(),c["result_bits"][i].as_u64().unwrap() as u32,"metrics {c}");}
            assert_eq!(usize::from(report.notify),c["notifications"].as_u64().unwrap() as usize);assert_eq!(usize::from(report.invalid_radius_warning),c["warnings"].as_u64().unwrap() as usize);
        }
    }
}
