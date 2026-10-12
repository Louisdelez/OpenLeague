//! Native 6B1860 owner position refresh with primary and shared secondary providers.
use crate::fow_source_update::Parameters;
pub struct PositionOwner {pub key:u64,pub handle:u32,pub position:[f32;3],pub actor_ad:bool,pub actor_118:bool,pub secondary_position:Option<[f32;3]>}
pub struct SourcePosition {
    pub center:[f32;2],
    pub cached_owner:Option<u64>,
    pub owner_handle:u32,
    pub remaining_lifetime:f32,
}
impl SourcePosition {
    pub fn refresh(&mut self, parameters:&mut Parameters,registry:&[Option<PositionOwner>])->Result<(),&'static str> {
        let Some(key)=self.cached_owner else {return Ok(());};
        if self.owner_handle==u32::MAX {return Err("invalid native fog owner sentinel");}
        let owner=if self.owner_handle==0 {None}else{registry.get((self.owner_handle&0xffff) as usize).and_then(Option::as_ref).filter(|owner|owner.handle==self.owner_handle)};
        let Some(owner)=owner else {
            self.cached_owner=None;
            self.remaining_lifetime=f32::from_bits(0x34000000);
            return Ok(());
        };
        if owner.key!=key {return Err("native fog cached position owner mismatch");}
        // This original method checks registry/handle identity, not generation.
        let position=owner.secondary_position.unwrap_or(owner.position);
        let center=[position[0],position[2]];
        let epsilon=f32::from_bits(0x3727c5ac);
        if !((center[0]-self.center[0]).abs()<=epsilon && (center[1]-self.center[1]).abs()<=epsilon) {
            self.center=center;
            parameters.generation_dirty=true;
        }
        Ok(())
    }
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn primary_position_update_matches_original_owner_lifecycle() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_position_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),48);
        assert_eq!(proof["position_epsilon_bits"].as_u64().unwrap(),0x3727c5ac);
        for c in proof["cases"].as_array().unwrap() {
            let mode=c["mode"].as_str().unwrap();
            let handle=0x12340002;
            let mut source=SourcePosition {center:std::array::from_fn(|i|c["initial_center"][i].as_f64().unwrap() as f32),cached_owner:if mode=="uncached" {None}else{Some(17)},owner_handle:if mode=="no_owner" {0}else{handle},remaining_lifetime:f32::from_bits(c["initial_lifetime_bits"].as_u64().unwrap() as u32)};
            let mut parameters=Parameters {radius:1350.,secondary_metric:128.,source_metric:64.,scale:1.,bias:0.,generation_dirty:c["initial_dirty"].as_bool().unwrap()};
            let mut registry:Vec<Option<PositionOwner>>=(0..4).map(|_|None).collect();
            if mode!="empty_slot" {registry[2]=Some(PositionOwner {secondary_position:None,actor_ad:true,actor_118:false,key:17,handle:if mode=="handle_mismatch" {handle+0x10000}else{handle},position:std::array::from_fn(|i|c["owner_position"][i].as_f64().unwrap() as f32)});}
            source.refresh(&mut parameters,&registry).unwrap();
            let expected:[u32;2]=std::array::from_fn(|i|c["result_center_bits"][i].as_u64().unwrap() as u32);
            assert_eq!(source.center.map(f32::to_bits),expected,"position {c}");
            assert_eq!(parameters.generation_dirty,c["result_dirty"].as_bool().unwrap(),"dirty {c}");
            assert_eq!(source.cached_owner.is_some(),c["result_cached_owner"].as_bool().unwrap(),"cached {c}");
            assert_eq!(source.remaining_lifetime.to_bits(),c["result_lifetime_bits"].as_u64().unwrap() as u32,"lifetime {c}");
        }
    }
}

#[cfg(test)] mod secondary_tests {
    use super::*;
    #[test] fn secondary_position_matches_original_shared_provider_and_getter() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_secondary_position_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),48);
        for c in proof["cases"].as_array().unwrap() {
            let mut source=SourcePosition {center:[10.,20.],cached_owner:Some(17),owner_handle:0x12340002,remaining_lifetime:1.};
            let mut parameters=crate::fow_source_update::Parameters {radius:1350.,secondary_metric:128.,source_metric:64.,scale:1.,bias:0.,generation_dirty:c["initial_dirty"].as_bool().unwrap()};
            let mut registry:Vec<Option<PositionOwner>>=(0..4).map(|_|None).collect();
            if c["mode"]!="empty_slot" {registry[2]=Some(PositionOwner {key:17,handle:0x12340002,actor_ad:true,actor_118:false,position:std::array::from_fn(|i|c["owner_position"][i].as_f64().unwrap() as f32),secondary_position:if c["secondary_position"].is_null() {None}else{Some(std::array::from_fn(|i|c["secondary_position"][i].as_f64().unwrap() as f32))}});}
            source.refresh(&mut parameters,&registry).unwrap();
            assert_eq!(source.center.map(f32::to_bits),std::array::from_fn(|i|c["result_center_bits"][i].as_u64().unwrap() as u32),"secondary position {c}");
            assert_eq!(parameters.generation_dirty,c["result_dirty"].as_bool().unwrap(),"dirty {c}");
            assert_eq!(source.cached_owner.is_some(),c["result_cached_owner"].as_bool().unwrap(),"cached {c}");
            assert_eq!(source.remaining_lifetime.to_bits(),c["result_lifetime_bits"].as_u64().unwrap() as u32,"lifetime {c}");
        }
    }
}
