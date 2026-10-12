//! Native source-mask composition: radial fan -> clipping -> terrain traversal.
use crate::{fow_shapes::{Circle,Cone},fow_regions::StencilRegion,fow_terrain_ray::TerrainGrid};
pub fn circle_stencil(circle:&Circle,dimension:usize,extent:f32,source_metric:f32,source_flag:bool,terrain:&TerrainGrid<'_>)->Result<StencilRegion,&'static str> {
    compose(circle,dimension,extent,source_metric,source_flag,terrain,|_|Ok(true))
}
pub fn owned_circle_stencil(circle:&Circle,dimension:usize,extent:f32,source_metric:f32,terrain:&TerrainGrid<'_>,owner:&crate::fow_owner::Reference,registry:&[Option<crate::fow_owner::Owner>])->Result<StencilRegion,&'static str> {
    let [scale,bias]=crate::fow_owner::modifiers([circle.scale,circle.bias],owner,registry)?;
    let adjusted=Circle {center:circle.center,radius:circle.radius,scale,bias};
    let flag=crate::fow_terrain_ray::source_flag(circle.center,source_metric,terrain)?;
    circle_stencil(&adjusted,dimension,extent,source_metric,flag,terrain)
}
pub fn cone_stencil(cone:&Cone,dimension:usize,extent:f32,source_metric:f32,source_flag:bool,terrain:&TerrainGrid<'_>)->Result<StencilRegion,&'static str> {
    if cone.direction.iter().any(|v|!v.is_finite()) || !cone.threshold.is_finite() {return Err("invalid fog cone direction");}
    compose(&cone.circle,dimension,extent,source_metric,source_flag,terrain,|p|cone.direction_contains(p))
}
fn compose(circle:&Circle,dimension:usize,extent:f32,source_metric:f32,source_flag:bool,terrain:&TerrainGrid<'_>,mut direction_contains:impl FnMut([f32;2])->Result<bool,&'static str>)->Result<StencilRegion,&'static str> {
    let mut region=circle.stencil(dimension,extent)?;region.words.fill(0);
    let n=dimension as f32;let inverse=1./extent;
    let padded=((circle.radius as f64)*(circle.scale as f64)+(circle.bias as f64)+(n as f64)) as f32;
    let mut center=[0f32;2];
    for i in 0..2 {let lo=((circle.center[i]-padded)*inverse)*n;let hi=((circle.center[i]+padded)*inverse)*n;center[i]=(hi+lo)*0.5;}
    let radius_grid=(inverse*padded)*n;
    let radius=circle.radius*circle.scale+circle.bias;
    for ray in crate::fow_radial_fan::rays(center,radius_grid)? {
        let Some(clipped)=crate::fow_ray_clip::clip(dimension,ray.origin,ray.end)? else {continue;};
        let mut predicate_error=None;
        let words=crate::fow_terrain_ray::trace(dimension,extent,clipped.origin,clipped.delta,source_metric,source_flag,terrain,region.rect,|p| {
            let dx=circle.center[0]-p[0];let dz=circle.center[1]-p[1];
            if !(radius*radius>dz*dz+dx*dx) {return false;}
            match direction_contains(p) {Ok(value)=>value,Err(error)=>{predicate_error=Some(error);false}}
        })?;
        if let Some(error)=predicate_error {return Err(error);}
        for(dst,src) in region.words.iter_mut().zip(words) {*dst|=src;}
    }
    Ok(region)
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test] fn complete_occluded_circle_matches_original_generator_masks_and_counters() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_occluded_circle_contract.json")).unwrap();
        for c in p["cases"].as_array().unwrap() {
            let n=c["dimension"].as_u64().unwrap() as usize;let extent=c["extent"].as_f64().unwrap() as f32;
            let circle=Circle {center:[c["center"][0].as_f64().unwrap() as f32,c["center"][1].as_f64().unwrap() as f32],radius:c["radius"].as_f64().unwrap() as f32,scale:1.,bias:0.};
            let flags:Vec<u16>=(0..n*n).map(|i|if i%n==c["flag_column"].as_u64().unwrap() as usize {c["flag"].as_u64().unwrap() as u16}else{0}).collect();
            let terrain=TerrainGrid {width:n,height:n,origin:[0.;3],cell_size:32.,flags:&flags};
            let mut region=circle_stencil(&circle,n,extent,c["source_metric"].as_f64().unwrap() as f32,c["source_flag"].as_bool().unwrap(),&terrain).unwrap();
            let expected:Vec<u32>=c["words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect();assert_eq!(region.words,expected,"occluded {}",c);
            for i in 0..4 {assert_eq!(region.rect[i],c["rect"][i].as_u64().unwrap() as usize);}
            let rect=region.rect;let mut counts=vec![0u8;n*n];let mut pixels=vec![0u8;n*n];region.add_to(n,rect,&mut counts,&mut pixels).unwrap();
            assert_eq!(counts.iter().map(|v|u64::from(*v)).sum::<u64>(),c["selected_cells"].as_u64().unwrap());
            for z in 0..n {for x in 0..n {let index=z*n+x;assert_eq!(pixels[(n-z-1)*n+x],if expected[index/32]&(1<<(index%32))!=0 {255}else{0});}}
        }
    }

    #[test] fn map10_occluded_masks_match_original_generator() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_map10_occluded_contract.json")).unwrap();
        let metadata=&proof["terrain"];
        let compact=include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin");
        let flags:Vec<u16>=compact.chunks_exact(11).map(|c|u16::from_le_bytes([c[4],c[5]])).collect();
        let terrain=TerrainGrid {width:metadata["width"].as_u64().unwrap() as usize,height:metadata["height"].as_u64().unwrap() as usize,
            origin:std::array::from_fn(|i|metadata["origin"][i].as_f64().unwrap() as f32),cell_size:metadata["cell_size"].as_f64().unwrap() as f32,flags:&flags};
        for c in proof["query_cases"].as_array().unwrap() {
            let center=std::array::from_fn(|i|c["center"][i].as_f64().unwrap() as f32);
            assert_eq!(crate::fow_terrain_ray::source_flag(center,c["metric"].as_f64().unwrap() as f32,&terrain).unwrap(),c["result"].as_bool().unwrap(),"Map10 source query {c}");
        }
        for (case_index,c) in proof["cases"].as_array().unwrap().iter().enumerate() {
            let n=c["dimension"].as_u64().unwrap() as usize;
            let circle=Circle {center:std::array::from_fn(|i|c["center"][i].as_f64().unwrap() as f32),radius:c["radius"].as_f64().unwrap() as f32,scale:1.,bias:0.};
            let mut actual=circle_stencil(&circle,n,c["extent"].as_f64().unwrap() as f32,c["source_metric"].as_f64().unwrap() as f32,crate::fow_terrain_ray::source_flag(circle.center,c["source_metric"].as_f64().unwrap() as f32,&terrain).unwrap(),&terrain).unwrap();
            let expected:Vec<u32>=c["words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect();
            for (index,(a,b)) in actual.words.iter().zip(&expected).enumerate() {assert_eq!(a,b,"Map10 case {case_index}, word {index}");}
            for i in 0..4 {assert_eq!(actual.rect[i],c["rect"][i].as_u64().unwrap() as usize,"Map10 case {case_index}, rectangle");}
            let rect=actual.rect;let mut counts=vec![0;n*n];let mut pixels=vec![0;n*n];actual.add_to(n,rect,&mut counts,&mut pixels).unwrap();
            assert_eq!(counts.iter().map(|v|u64::from(*v)).sum::<u64>(),c["selected_cells"].as_u64().unwrap());
            for z in 0..n {for x in 0..n {let index=z*n+x;assert_eq!(pixels[(n-z-1)*n+x],if expected[index/32]&(1<<(index%32))!=0 {255}else{0});}}
        }
    }

    #[test] fn map10_occluded_cones_match_original_generator() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_map10_cone_contract.json")).unwrap();
        let metadata=&proof["terrain"];let compact=include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin");
        let flags:Vec<u16>=compact.chunks_exact(11).map(|c|u16::from_le_bytes([c[4],c[5]])).collect();
        let terrain=TerrainGrid {width:metadata["width"].as_u64().unwrap() as usize,height:metadata["height"].as_u64().unwrap() as usize,origin:std::array::from_fn(|i|metadata["origin"][i].as_f64().unwrap() as f32),cell_size:metadata["cell_size"].as_f64().unwrap() as f32,flags:&flags};
        for (case_index,c) in proof["cases"].as_array().unwrap().iter().enumerate() {
            let n=c["dimension"].as_u64().unwrap() as usize;
            let cone=Cone {circle:Circle {center:std::array::from_fn(|i|c["center"][i].as_f64().unwrap() as f32),radius:c["radius"].as_f64().unwrap() as f32,scale:1.,bias:0.},direction:std::array::from_fn(|i|c["direction"][i].as_f64().unwrap() as f32),threshold:c["threshold"].as_f64().unwrap() as f32};
            let metric=c["source_metric"].as_f64().unwrap() as f32;let flag=crate::fow_terrain_ray::source_flag(cone.circle.center,metric,&terrain).unwrap();
            assert_eq!(flag,c["source_flag"].as_bool().unwrap());
            let mut actual=cone_stencil(&cone,n,c["extent"].as_f64().unwrap() as f32,metric,flag,&terrain).unwrap();
            let expected:Vec<u32>=c["words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect();
            for (i,(a,b)) in actual.words.iter().zip(&expected).enumerate() {assert_eq!(a,b,"cone case {case_index}, word {i}");}
            for i in 0..4 {assert_eq!(actual.rect[i],c["rect"][i].as_u64().unwrap() as usize);}
            let rect=actual.rect;let mut counts=vec![0;n*n];let mut pixels=vec![0;n*n];actual.add_to(n,rect,&mut counts,&mut pixels).unwrap();
            assert_eq!(counts.iter().map(|v|u64::from(*v)).sum::<u64>(),c["selected_cells"].as_u64().unwrap());
            for z in 0..n {for x in 0..n {let index=z*n+x;assert_eq!(pixels[(n-z-1)*n+x],if expected[index/32]&(1<<(index%32))!=0 {255}else{0});}}
        }
    }
    #[test] fn map10_owned_masks_match_original_generator() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_map10_owned_contract.json")).unwrap();
        let metadata=&proof["terrain"];
        let compact=include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin");
        let flags:Vec<u16>=compact.chunks_exact(11).map(|c|u16::from_le_bytes([c[4],c[5]])).collect();
        let terrain=TerrainGrid {width:metadata["width"].as_u64().unwrap() as usize,height:metadata["height"].as_u64().unwrap() as usize,
            origin:std::array::from_fn(|i|metadata["origin"][i].as_f64().unwrap() as f32),cell_size:metadata["cell_size"].as_f64().unwrap() as f32,flags:&flags};
        for (case_index,c) in proof["cases"].as_array().unwrap().iter().enumerate() {
            let n=c["dimension"].as_u64().unwrap() as usize;
            let circle=Circle {center:std::array::from_fn(|i|c["center"][i].as_f64().unwrap() as f32),radius:c["radius"].as_f64().unwrap() as f32,scale:1.,bias:0.};
            let reference=crate::fow_owner::Reference {handle:0x12340002,cached_key:17,owner_tag:7};
            let mut registry:Vec<Option<crate::fow_owner::Owner>>=(0..4).map(|_|None).collect();
            registry[2]=Some(crate::fow_owner::Owner {key:17,handle:0x12340002,owner_tag:if c["owner_valid"].as_bool().unwrap() {7}else{8},percent:c["owner_percent"].as_f64().unwrap() as f32,flat:c["owner_flat"].as_f64().unwrap() as f32});
            let mut actual=owned_circle_stencil(&circle,n,c["extent"].as_f64().unwrap() as f32,c["source_metric"].as_f64().unwrap() as f32,&terrain,&reference,&registry).unwrap();
            let expected:Vec<u32>=c["words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect();
            for (index,(a,b)) in actual.words.iter().zip(&expected).enumerate() {assert_eq!(a,b,"Map10 case {case_index}, word {index}");}
            for i in 0..4 {assert_eq!(actual.rect[i],c["rect"][i].as_u64().unwrap() as usize,"Map10 case {case_index}, rectangle");}
            let rect=actual.rect;let mut counts=vec![0;n*n];let mut pixels=vec![0;n*n];actual.add_to(n,rect,&mut counts,&mut pixels).unwrap();
            assert_eq!(counts.iter().map(|v|u64::from(*v)).sum::<u64>(),c["selected_cells"].as_u64().unwrap());
            for z in 0..n {for x in 0..n {let index=z*n+x;assert_eq!(pixels[(n-z-1)*n+x],if expected[index/32]&(1<<(index%32))!=0 {255}else{0});}}
        }
    }

}
