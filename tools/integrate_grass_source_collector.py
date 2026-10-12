from pathlib import Path
r=Path('E:/OpenLeague')
source='''//! Native73AD90collector. Raw eligibility and AABB producers must be supplied explicitly.
use crate::grass_rectangle::Rectangle;
#[derive(Clone,Copy)]
pub struct Eligibility { pub enabled:u8,pub flags_b0:u32,pub flags_e0:u8,pub virtual74:u32,pub virtual1e0:bool,pub virtual90:bool }
impl Eligibility {
    pub fn eligible(self)->bool {self.enabled!=0 && self.flags_b0&0x20==0 && self.flags_e0&0x40!=0 && self.virtual74!=0 && self.virtual1e0 && self.virtual90}
}
#[derive(Clone,Copy)] pub struct Actor {pub eligibility:Eligibility,pub aabb:[f32;6]}
pub const MARGIN:f32=f32::from_bits(0x3e99999a);
pub fn collect_into(actors:&[Actor],out:&mut Vec<Rectangle>,mut project:impl FnMut([f32;6],f32)->Rectangle) {
    out.clear();
    for actor in actors {if actor.eligibility.eligible() {out.push(project(actor.aabb,MARGIN));}}
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn actor_gates_match_every_native_collector_case() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_mask_sources_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["margin_bits"],MARGIN.to_bits());
        for c in p["cases"].as_array().unwrap() {
            let gates=Eligibility {enabled:c["enabled_byte"].as_u64().unwrap() as u8,flags_b0:c["flags_b0"].as_u64().unwrap() as u32,flags_e0:c["flags_e0"].as_u64().unwrap() as u8,virtual74:c["virtual74"].as_u64().unwrap() as u32,virtual1e0:c["virtual1e0"]==1,virtual90:c["virtual90"]==1};assert_eq!(gates.eligible(),c["eligible"].as_bool().unwrap());
        }
    }
    #[test] fn collector_preserves_native_order_duplicates_sentinel_and_inverted_rectangles() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_source_order_contract.json")).unwrap();assert_eq!(p["passed"],true);
        for c in p["cases"].as_array().unwrap() {
            let actors:Vec<_>=c["registry_indices"].as_array().unwrap().iter().map(|id| {let i=id.as_u64().unwrap() as usize;Actor {eligibility:Eligibility {enabled:1,flags_b0:if i==1 {0x20} else {0},flags_e0:0x40,virtual74:1,virtual1e0:true,virtual90:i!=2},aabb:std::array::from_fn(|axis|p["actor_aabbs"][i][axis].as_f64().unwrap() as f32)}}).collect();
            let mut out=vec![Rectangle([99;4])];let mut calls=Vec::new();
            collect_into(&actors,&mut out,|aabb,margin| {assert_eq!(margin.to_bits(),p["margin_bits"].as_u64().unwrap() as u32);let index=aabb[0] as usize;calls.push(index);Rectangle(std::array::from_fn(|axis|p["actor_rectangles"][index][axis].as_i64().unwrap() as i32))});
            let expected:Vec<_>=c["rectangles"].as_array().unwrap().iter().map(|row|Rectangle(std::array::from_fn(|axis|row[axis].as_i64().unwrap() as i32))).collect();assert_eq!(out,expected);
            let indices:Vec<_>=c["eligible_indices"].as_array().unwrap().iter().map(|id|id.as_u64().unwrap() as usize).collect();assert_eq!(calls,indices);
        }
    }
}
'''
p=r/'crates/client/src/grass_sources.rs';assert not p.exists();p.write_text(source,encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8').replace('mod grass_constants;','mod grass_constants;\n#[allow(dead_code)] // Registry/actor semantics and live camera remain pending.\nmod grass_sources;');p.write_text(s,encoding='utf-8');print('Native source collector port installed with explicit raw producers.')
