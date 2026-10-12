//! Native 6B09E0 traversal. Flag meanings and actual Map10 provider are separate.
pub struct TerrainGrid<'a> {pub width:usize,pub height:usize,pub origin:[f32;3],pub cell_size:f32,pub flags:&'a [u16]}
// Native 8F3390 source flag query. Coordinates are X/Z; the third input
// chooses a point query below35, otherwise a circle capped at500 world units.
pub fn source_flag(center:[f32;2],metric:f32,terrain:&TerrainGrid<'_>)->Result<bool,&'static str> {
    if center.iter().chain(terrain.origin.iter()).any(|v|!v.is_finite())
        || terrain.width==0 || terrain.height==0 || terrain.width.checked_mul(terrain.height)!=Some(terrain.flags.len())
        || !terrain.cell_size.is_finite() || terrain.cell_size<=0. {return Err("invalid native source flag terrain");}
    let x=center[0]-terrain.origin[0];let z=center[1]-terrain.origin[2];let inverse=1./terrain.cell_size;
    let cell_flag=|x:f32,z:f32| {
        let ix=(x.trunc() as i64).clamp(0,terrain.width as i64-1) as usize;
        let iz=(z.trunc() as i64).clamp(0,terrain.height as i64-1) as usize;
        terrain.flags[iz*terrain.width+ix]
    };
    if metric.is_nan() || metric<35. {return Ok(cell_flag(x*inverse,z*inverse)&1!=0);}
    let radius=metric.min(500.);let square=radius*radius;
    let bounds=[(inverse*(x-radius)).trunc(),(inverse*(z-radius)).trunc(),(inverse*(x+radius)).trunc(),(inverse*(z+radius)).trunc()];
    if bounds.iter().any(|v|!v.is_finite() || v.abs()>i32::MAX as f32) {return Err("native source flag coordinates overflow");}
    let [low_x,low_z,high_x,high_z]=bounds.map(|v|v as i32);
    let mut budget=1000i32;
    let base=low_x as f32*terrain.cell_size;let half=terrain.cell_size*0.5;
    let mut sample_z=low_z as f32*terrain.cell_size+half;
    let (mut eligible,mut selected)=(0i32,0i32);
    'scan: for iz in low_z..=high_z {
        if budget<0 {break;}
        let dz=sample_z-z;let z_square=dz*dz;
        let mut sample_x=base+half;
        if z_square<=square {
            for ix in low_x..=high_x {
                if budget<0 {break 'scan;}
                budget-=1;
                let dx=sample_x-x;
                if square>=dx*dx+z_square {
                    let flag=cell_flag(ix as f32,iz as f32);
                    eligible+=1;
                    if flag&1!=0 {selected+=1;} else if flag&2!=0 {eligible-=1;}
                }
                sample_x+=terrain.cell_size;
            }
        } else {budget-=1;}
        sample_z+=terrain.cell_size;
    }
    Ok(selected>0 && selected>=(eligible as f32*0.4).trunc() as i32)
}
pub fn trace(dimension:usize,extent:f32,origin:[f32;2],delta:[f32;2],source_metric:f32,source_flag:bool,terrain:&TerrainGrid<'_>,rect:[usize;4],mut contains:impl FnMut([f32;2])->bool)->Result<Vec<u32>,&'static str> {
    if dimension==0 || dimension>4096 || !extent.is_finite() || extent<=0. || !source_metric.is_finite()
        || origin.into_iter().chain(delta).chain(terrain.origin).any(|v|!v.is_finite())
        || terrain.width==0 || terrain.height==0 || terrain.width.checked_mul(terrain.height)!=Some(terrain.flags.len())
        || !terrain.cell_size.is_finite() || terrain.cell_size<=0.
        || rect[0]>rect[2] || rect[1]>rect[3] || rect[2]>dimension || rect[3]>dimension {return Err("invalid native fog terrain ray");}
    let maximum=delta[0].abs().max(delta[1].abs());
    let steps=maximum*2.5;
    if !steps.is_finite() || steps<=0. || steps>1000000. {return Err("unsupported native fog ray length");}
    let inverse_steps=1./steps;let grid_cell=extent/dimension as f32;let inverse_cell=1./terrain.cell_size;
    let step=[inverse_steps*delta[0],inverse_steps*delta[1]];
    let nav_step=[(step[0]*grid_cell)*inverse_cell,(step[1]*grid_cell)*inverse_cell];
    let source_nav=[-((grid_cell*origin[0]-terrain.origin[0])*inverse_cell),-((grid_cell*origin[1]-terrain.origin[1])*inverse_cell)];
    // Original uses packed terrain origin+0x0B for the second source-distance
    // component, and +0x0F for sampling. Preserve that distinction.
    let mut nav=[((((step[0]*2.5)*0.4+origin[0])*grid_cell-terrain.origin[0])*inverse_cell)+nav_step[0]*0.4,
                 ((((step[1]*2.5)*0.4+origin[1])*grid_cell-terrain.origin[2])*inverse_cell)+nav_step[1]*0.4];
    let radius=source_metric*inverse_cell;let radius_squared=radius*radius;
    if nav.iter().chain(nav_step.iter()).chain(source_nav.iter()).any(|v|!v.is_finite()) || !radius_squared.is_finite() {return Err("fog terrain ray arithmetic overflow");}
    let scan_count=(steps-0.5).trunc() as i32;
    let(mut opaque_count,mut clear_count,mut stopped,mut flag_state)=(0i32,0i32,false,source_flag);
    for _ in 0..scan_count.max(0) {
        let world=[nav[0]*terrain.cell_size+terrain.origin[0],nav[1]*terrain.cell_size+terrain.origin[2]];
        if contains(world) {
            let x=(nav[0].trunc() as i64).clamp(0,terrain.width as i64-1) as usize;
            let z=(nav[1].trunc() as i64).clamp(0,terrain.height as i64-1) as usize;
            let flag=terrain.flags[z*terrain.width+x];
            if flag&512!=0 {stopped=true;break;}
            if flag&1==0 {
                let dx=source_nav[0]+nav[0];let dz=source_nav[1]+nav[1];
                flag_state&=dz*dz+dx*dx<=radius_squared;
            } else if !flag_state {stopped=true;break;}
            if flag&2!=0 && flag&64==0 {opaque_count+=1;stopped=true;}
            else {
                if opaque_count>0 {break;}
                clear_count+=1;
            }
        }
        nav[0]+=nav_step[0];nav[1]+=nav_step[1];
    }
    let write_count=(opaque_count-10).max(0)+i32::from(stopped)+clear_count;
    let mut words=vec![0u32;(dimension*dimension).div_ceil(32)];let mut advance=[0f32;2];let mut last_index=None;
    for _ in 0..write_count.max(0) {
        advance[0]+=step[0];advance[1]+=step[1];
        let x=advance[0].trunc() as i64+origin[0].trunc() as i64;
        let z=advance[1].trunc() as i64+origin[1].trunc() as i64;
        let index=z*dimension as i64+x;
        if index<0 || index>=dimension as i64*dimension as i64 {break;}
        if last_index!=Some(index) {
            last_index=Some(index);
            if x>=rect[0] as i64 && x<rect[2] as i64 && z>=rect[1] as i64 && z<rect[3] as i64 {let i=index as usize;words[i/32]|=1<<(i%32);}
        }
    }
    Ok(words)
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test] fn source_query_matches_native_thresholds_and_exhausted_scan_budget() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_terrain_budget_contract.json")).unwrap();assert_eq!(p["passed"],true);
        for c in p["cases"].as_array().unwrap() {
            let flags:Vec<u16>=p["patterns"][c["pattern"].as_u64().unwrap() as usize].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u16).collect();
            let terrain=TerrainGrid{width:8,height:8,origin:[0.;3],cell_size:c["cell_size"].as_f64().unwrap() as f32,flags:&flags};
            let center=std::array::from_fn(|i|f32::from_bits(c["position_bits"][i].as_u64().unwrap() as u32));
            let radius=f32::from_bits(c["radius_bits"].as_u64().unwrap() as u32);
            assert_eq!(source_flag(center,radius,&terrain).unwrap(),c["result"].as_bool().unwrap(),"native query {c}");
        }
    }
    #[test] fn actor_cache_uses_original_map10_terrain_query_and_reuses_result() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_actor_map10_contract.json")).unwrap();assert_eq!(p["passed"],true);
        let meta:serde_json::Value=serde_json::from_str(include_str!("../../../assets/maps/tt_navigation_grid.json")).unwrap();
        let flags:Vec<u16>=include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin").chunks_exact(11).map(|c|u16::from_le_bytes([c[4],c[5]])).collect();
        let terrain=TerrainGrid{width:meta["width"].as_u64().unwrap() as usize,height:meta["height"].as_u64().unwrap() as usize,origin:std::array::from_fn(|i|meta["min"][i].as_f64().unwrap() as f32),cell_size:meta["cellSize"].as_f64().unwrap() as f32,flags:&flags};
        for c in p["cases"].as_array().unwrap() {
            let mut cache=crate::grass_actor_cache::Cache{x:0.,z:0.,radius:0.,result:0};
            let position=std::array::from_fn(|i|c["position"][i].as_f64().unwrap() as f32);
            let radius=c["radius"].as_f64().unwrap() as f32;
            for frame in c["frames"].as_array().unwrap() {
                let mut calls=Vec::new();let result=cache.update(position,0.,radius,|x,z,r|{calls.push([x.to_bits(),z.to_bits(),r.to_bits()]);u8::from(source_flag([x,z],r,&terrain).unwrap())});
                assert_eq!(result,frame["result"].as_u64().unwrap() as u8);
                let expected:Vec<[u32;3]>=frame["query_calls"].as_array().unwrap().iter().map(|row|std::array::from_fn(|i|row[i].as_u64().unwrap() as u32)).collect();assert_eq!(calls,expected);
                assert_eq!([cache.x.to_bits(),cache.z.to_bits(),cache.radius.to_bits()],std::array::from_fn(|i|frame["cache_bits"][i].as_u64().unwrap() as u32));
            }
        }
    }
    #[test] fn terrain_traversal_matches_original_flag_column_masks() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_terrain_ray_contract.json")).unwrap();
        let pair=|v:&serde_json::Value|[v[0].as_f64().unwrap() as f32,v[1].as_f64().unwrap() as f32];
        for c in proof["cases"].as_array().unwrap() {
            let n=c["dimension"].as_u64().unwrap() as usize;let flags:Vec<u16>=(0..n*n).map(|i|if i%n==c["flag_column"].as_u64().unwrap() as usize {c["flag"].as_u64().unwrap() as u16}else{0}).collect();
            let terrain=TerrainGrid {width:n,height:n,origin:[0.;3],cell_size:c["terrain_cell_size"].as_f64().unwrap() as f32,flags:&flags};
            let actual=trace(n,c["extent"].as_f64().unwrap() as f32,pair(&c["origin"]),pair(&c["delta"]),c["source_height"].as_f64().unwrap() as f32,c["starts_in_brush"].as_bool().unwrap(),&terrain,[0,0,n,n],|p|{let dx=128.-p[0];let dz=128.-p[1];512f32*512.>dz*dz+dx*dx}).unwrap();
            let expected:Vec<u32>=c["words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect();assert_eq!(actual,expected,"native ray {}",c);
        }
    }
}
