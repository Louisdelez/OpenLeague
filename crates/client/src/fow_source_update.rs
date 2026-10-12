//! Original 6198F0 source parameters. Source creation and actor field producers
//! are separate contracts; callers supply a live reference only after resolution.
use crate::fow_shapes::Circle;
#[derive(Clone, Copy, Debug)]
pub struct Parameters {
    pub radius: f32,
    pub secondary_metric: f32,
    pub source_metric: f32,
    pub scale: f32,
    pub bias: f32,
    pub generation_dirty: bool,
}
pub struct ActorParameters {
    pub character_radius: Option<f32>,
    pub metric_override: f32,
    pub secondary_override: f32,
    pub metric_fallback: f32,
    pub secondary_fallback: f32,
    pub modifiers: openleague_core::vision::RadiusModifiers,
}
impl Parameters {
    pub fn circle(&self, center: [f32;2])->Circle {
        Circle {center,radius:self.radius,scale:self.scale,bias:self.bias}
    }
    pub fn bits(&self)->[u32;5] {
        [self.radius,self.secondary_metric,self.source_metric,self.scale,self.bias].map(f32::to_bits)
    }
}
pub fn update(source: Option<&mut Parameters>, actor: &ActorParameters) {
    let Some(source)=source else {return;};
    // Native missing CharacterData uses 100 here, not the resource fallback 1350.
    let radius=actor.character_radius.unwrap_or(100.);
    let [scale,bias]=actor.modifiers.parameters();
    let old_effective=source.scale*source.radius+source.bias;
    let new_effective=radius*scale+bias;
    // Unordered native comparisons also invalidate the source; do not use an epsilon.
    source.generation_dirty |= new_effective!=old_effective;
    source.radius=radius;
    source.secondary_metric=if actor.secondary_override>0. {actor.secondary_override}else{actor.secondary_fallback};
    source.source_metric=if actor.metric_override>0. {actor.metric_override}else{actor.metric_fallback};
    source.scale=scale;
    source.bias=bias;
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn source_update_matches_complete_original_method() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_source_update_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),216);
        for c in proof["cases"].as_array().unwrap() {
            let value=|key:&str|c[key].as_f64().unwrap() as f32;
            let mut source=Parameters {radius:value("old_radius"),secondary_metric:9.,source_metric:8.,scale:1.,bias:0.,generation_dirty:c["initial_dirty"].as_bool().unwrap()};
            let actor=ActorParameters {character_radius:c["data_radius"].as_f64().map(|v|v as f32),metric_override:c["overrides"][0].as_f64().unwrap() as f32,secondary_override:c["overrides"][1].as_f64().unwrap() as f32,metric_fallback:c["fallback_metrics"][0].as_f64().unwrap() as f32,secondary_fallback:c["fallback_metrics"][1].as_f64().unwrap() as f32,modifiers:openleague_core::vision::RadiusModifiers {percent_bubble_radius_mod:value("percent"),flat_bubble_radius_mod:value("flat")}};
            update(if c["status"]=="live" {Some(&mut source)}else{None},&actor);
            let expected:[u32;5]=std::array::from_fn(|i|c["result_bits"][i].as_u64().unwrap() as u32);
            assert_eq!(source.bits(),expected,"source update {c}");
            assert_eq!(source.generation_dirty,c["generation_dirty"].as_bool().unwrap(),"dirty {c}");
        }
    }
    #[test] fn updated_sources_feed_native_map10_masks() {
        use crate::fow_terrain_ray::TerrainGrid;
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_map10_owned_contract.json")).unwrap();
        let metadata=&proof["terrain"];
        let compact=include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin");
        let flags:Vec<u16>=compact.chunks_exact(11).map(|c|u16::from_le_bytes([c[4],c[5]])).collect();
        let terrain=TerrainGrid {width:metadata["width"].as_u64().unwrap() as usize,height:metadata["height"].as_u64().unwrap() as usize,origin:std::array::from_fn(|i|metadata["origin"][i].as_f64().unwrap() as f32),cell_size:metadata["cell_size"].as_f64().unwrap() as f32,flags:&flags};
        for c in proof["cases"].as_array().unwrap() {
            let mut source=Parameters {radius:c["radius"].as_f64().unwrap() as f32,secondary_metric:128.,source_metric:c["source_metric"].as_f64().unwrap() as f32,scale:1.,bias:0.,generation_dirty:false};
            let actor=ActorParameters {character_radius:Some(source.radius),metric_override:-1.,secondary_override:0.,metric_fallback:source.source_metric,secondary_fallback:source.secondary_metric,modifiers:openleague_core::vision::RadiusModifiers {percent_bubble_radius_mod:c["owner_percent"].as_f64().unwrap() as f32,flat_bubble_radius_mod:c["owner_flat"].as_f64().unwrap() as f32}};
            update(if c["owner_valid"].as_bool().unwrap() {Some(&mut source)}else{None},&actor);
            let circle=source.circle(std::array::from_fn(|i|c["center"][i].as_f64().unwrap() as f32));
            let flag=crate::fow_terrain_ray::source_flag(circle.center,source.source_metric,&terrain).unwrap();
            let actual=crate::fow_occluded::circle_stencil(&circle,c["dimension"].as_u64().unwrap() as usize,c["extent"].as_f64().unwrap() as f32,source.source_metric,flag,&terrain).unwrap();
            let expected:Vec<u32>=c["words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect();
            assert_eq!(actual.words,expected,"updated Map10 source {c}");
        }
    }
}
