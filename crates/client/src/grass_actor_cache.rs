//! Original6197B0 cache; caller supplies position/radii and actual terrain predicate.
#[derive(Clone,Copy,Debug)]
pub struct Cache {pub x:f32,pub z:f32,pub radius:f32,pub result:u8}
pub const EPSILON:f32=f32::from_bits(0x3727c5ac);
impl Cache {
    pub fn update(&mut self,position:[f32;3],radius_override:f32,fallback:f32,mut query:impl FnMut(f32,f32,f32)->u8)->u8 {
        let radius=if radius_override>0.0 {radius_override} else {fallback};
        let radius_close=(self.radius-radius).abs()<EPSILON;
        let position_close=(self.x-position[0]).abs()<=EPSILON && (self.z-position[2]).abs()<=EPSILON;
        if !radius_close || !position_close {
            self.result=query(position[0],position[2],radius);
            self.x=position[0];self.z=position[2];self.radius=radius;
        }
        self.result
    }
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn cache_matches_original_method_and_position_getter_all_cases() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_actor_cache_contract.json")).unwrap();
        assert_eq!(p["passed"],true);assert_eq!(p["epsilon_bits"],EPSILON.to_bits());
        let f=|v:&serde_json::Value|f32::from_bits(v.as_u64().unwrap() as u32);
        for c in p["cases"].as_array().unwrap() {
            let mut cache=Cache{x:f(&c["initial_cache_bits"][0]),z:f(&c["initial_cache_bits"][1]),radius:f(&c["initial_cache_bits"][2]),result:c["initial_result"].as_u64().unwrap() as u8};
            let position=std::array::from_fn(|i|f(&c["position_bits"][i]));let mut calls=Vec::new();
            let result=cache.update(position,f(&c["override_bits"]),f(&c["fallback_bits"]),|x,z,radius|{calls.push([x.to_bits(),z.to_bits(),radius.to_bits()]);c["query_response"].as_u64().unwrap() as u8});
            assert_eq!(result,c["result"].as_u64().unwrap() as u8);
            let expected:Vec<[u32;3]>=c["query_calls"].as_array().unwrap().iter().map(|row|std::array::from_fn(|i|row[i].as_u64().unwrap() as u32)).collect();assert_eq!(calls,expected);
            assert_eq!([cache.x.to_bits(),cache.z.to_bits(),cache.radius.to_bits()],std::array::from_fn(|i|c["final_cache_bits"][i].as_u64().unwrap() as u32));
        }
    }
}
