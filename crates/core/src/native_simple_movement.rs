//! Native944EF9..945120 movement policy, composed with both actual helpers.
#[derive(Debug,Clone,Copy)]
pub struct Call {pub kind:&'static str,pub index:usize,pub axis:Option<[u32;3]>,pub center:[u32;3],pub delta:Option<u32>,pub axis_a:Option<usize>,pub axis_b:Option<usize>}
pub fn circular_policy(direction:u32)->([u32;3],usize,usize) {
    match direction {
        0=>([0x3f800000,0,0],1,2),1=>([0,0x3f800000,0],0,2),2=>([0,0,0x3f800000],0,1),
        3=>([0xbf800000,0,0],1,2),4=>([0,0xbf800000,0],0,2),5=>([0,0,0xbf800000],0,1),
        _=>([0,0x3f800000,0],0,2),
    }
}
/// Raw definition152 controls circular mode;154 selects axis policy. Unknown
/// directions use the actual native Y/02 default. Unsupported active inputs do
/// not commit the batch; observer may receive attempted diagnostic calls.
pub fn update(circular:u8,direction:u32,delta:u32,center:[u32;3],ages:&[u32],positions:&mut [[u32;3]],velocities:&mut [[u32;3]],observer:&mut impl FnMut(Call))->Result<(),&'static str> {
    if ages.len()!=positions.len() || ages.len()!=velocities.len(){return Err("mismatched native Simple movement arrays");}
    let mut p=positions.to_vec();let mut v=velocities.to_vec();let (axis,a,b)=circular_policy(direction);
    for i in 0..ages.len() {
        if !(1.>f32::from_bits(ages[i])){continue;}
        if circular==0 {
            if !p[i].into_iter().chain(v[i]).chain([delta]).all(|x|f32::from_bits(x).is_finite()){return Err("unqualified nonfinite linear motion fields");}
            for j in 0..3 {p[i][j]=(f32::from_bits(v[i][j])*f32::from_bits(delta)+f32::from_bits(p[i][j])).to_bits();}
        }else{
            observer(Call {kind:"axis",index:i,axis:Some(axis),center,delta:None,axis_a:None,axis_b:None});
            crate::native_simple_motion_axis::update(axis,p[i],&mut v[i],center)?;
            observer(Call {kind:"circular",index:i,axis:None,center,delta:Some(delta),axis_a:Some(a),axis_b:Some(b)});
            crate::native_simple_circular_motion::update(&mut p[i],v[i],center,delta,a,b)?;
        }
    }
    positions.copy_from_slice(&p);velocities.copy_from_slice(&v);Ok(())
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::{Value,json};
    fn words(v:&Value)->Vec<u32>{v.as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect()}
    fn triples(v:&Value)->Vec<[u32;3]>{words(v).chunks_exact(3).map(|v|v.try_into().unwrap()).collect()}
    #[test]
    fn complete_movement_policy_matches864_native_cpu_cases() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_movement_contract.json")).unwrap();let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),864);assert!(p["adapters"].as_array().unwrap().is_empty());
        for (i,r) in rows.iter().enumerate() {
            let mut positions=triples(&r["positions"]);let mut velocities=triples(&r["velocities"]);let center=words(&r["center"]).try_into().unwrap();let mut events=vec![];
            update(u8::from(r["circular"].as_bool().unwrap()),r["direction"].as_u64().unwrap() as u32,r["delta"].as_u64().unwrap() as u32,center,&words(&r["ages"]),&mut positions,&mut velocities,&mut |c:Call|events.push(json!({"kind":c.kind,"index":c.index,"axis":c.axis,"center":c.center,"delta":c.delta,"axis_a":c.axis_a,"axis_b":c.axis_b}))).unwrap();
            assert_eq!(positions,triples(&r["cpu"]["positions"]),"positions case{i}");assert_eq!(velocities,triples(&r["cpu"]["velocities"]),"velocities case{i}");assert_eq!(events,r["cpu"]["events"].as_array().unwrap().clone(),"events case{i}");assert_eq!(center,words(&r["cpu"]["center"]).as_slice());
        }
    }
}
