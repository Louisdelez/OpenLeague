//! Whole944E20 composition with concrete consumers; resource producers explicit.
use crate::{native_random::Rng55,native_probability_curve::ProbabilityCurve,native_particle_force_graph as graph,native_simple_bounds_policy as bounds};
#[derive(Clone)]
pub struct State {
    pub last_time:u32,pub life:Vec<u32>,pub ages:Vec<u32>,pub active:u32,
    pub positions:Vec<[u32;3]>,pub velocities:Vec<[u32;3]>,pub scales:Vec<u32>,pub factors:Vec<u32>,
    pub scalar:Vec<u32>,pub rates:Vec<u32>,pub auxiliary:Vec<u32>,pub attribute_a:Vec<u32>,pub attribute_b:Vec<u32>,pub previous_heights:Vec<u32>,
    pub bounds:bounds::State,pub counter:u32,
}
#[derive(Clone,Copy)]
pub struct Table<'a> {pub values:&'a [f32],pub probability:Option<&'a ProbabilityCurve>}
#[derive(Clone,Copy)]
pub struct Attribute {pub mode:u32,pub multiplier:u32,pub offset:u32}
pub struct Input<'a> {
    pub time:u32,pub cap:u32,pub birth:&'a [u32],pub bounds_flag:u8,
    pub previous_position:[u32;3],pub current_position:[u32;3],pub initial_inverse:[u32;16],pub current_matrix:[u32;16],
    pub bind_begin:u32,pub bind_end:u32,pub sticky:u8,pub local:u8,pub circular:u8,pub direction:u32,
    pub force_resource:u32,pub force_graph:Option<&'a graph::Input<'a>>,
    pub scalar_enabled:u8,pub scalar_table:Table<'a>,pub scale_table:Table<'a>,pub attributes:[Attribute;2],pub bounds_factor:u32,pub terrain_enabled:u8,
}
#[derive(Debug,Clone,Copy)]
pub enum Event {Entry(u32),Force(crate::native_simple_concrete_forces::Call),Movement(crate::native_simple_movement::Call)}
/// Failure preserves particle arrays and RNG. The external height provider and
/// observer may have received attempted calls; they are not simulated producers.
pub fn update(input:&Input,state:&mut State,rng:&mut Rng55,height:&mut impl FnMut([u32;3])->Result<u32,&'static str>,observer:&mut impl FnMut(Event))->Result<bool,&'static str> {
    let mut s=state.clone();let mut random=rng.clone();
    let mut age=crate::native_simple_particle_age::State {last_time:s.last_time,life:s.life.clone(),ages:s.ages.clone(),active:s.active};
    let ran=crate::native_simple_particle_age::prepare(&mut age,input.time,input.cap,input.birth)?;
    s.last_time=age.last_time;s.life=age.life;s.ages=age.ages;s.active=age.active;
    if ran {
        let delta=(f32::from_bits(input.time)-f32::from_bits(s.last_time)).to_bits();
        observer(Event::Entry(0x944600));
        crate::native_simple_attachment::bind(input.bind_begin,input.bind_end,input.sticky,input.previous_position,input.current_position,&s.ages,&mut s.positions)?;
        observer(Event::Entry(0x944760));
        crate::native_simple_attachment::local(input.local,&input.initial_inverse,&input.current_matrix,&s.ages,&mut s.positions)?;
        observer(Event::Entry(0x945620));
        crate::native_simple_concrete_forces::update(input.force_resource,input.force_graph,input.time,s.last_time,&s.ages,&mut s.positions,&mut s.velocities,input.current_position,&mut random,&mut |c|observer(Event::Force(c)))?;
        crate::native_simple_movement::update(input.circular,input.direction,delta,input.current_position,&s.ages,&mut s.positions,&mut s.velocities,&mut |c|observer(Event::Movement(c)))?;
        crate::native_simple_scalar_phase::update(input.scalar_enabled,input.scalar_table.values,input.scalar_table.probability,&s.ages,&mut s.scalar,&mut random)?;
        crate::native_simple_scalar_integration::update(delta,&s.ages,&s.rates,&mut s.scalar)?;
        crate::native_simple_scaled_scalar::update(input.scale_table.values,input.scale_table.probability,&s.ages,&s.factors,&mut s.scales,&mut random)?;
        for (policy,output) in input.attributes.iter().zip([&mut s.attribute_a,&mut s.attribute_b]) {
            crate::native_simple_attribute_policy::update(policy.mode,policy.multiplier,policy.offset,&s.ages,&s.velocities,&s.auxiliary,output)?;
        }
        crate::native_simple_bounds_policy::update(input.bounds_flag,input.time,input.current_position,input.bounds_factor,&s.ages,&s.positions,&s.scales,&mut s.bounds,&mut |_|observer(Event::Entry(0x944c80)))?;
    }
    observer(Event::Entry(0x9456e0));
    crate::native_simple_terrain_follow::update(true,input.terrain_enabled,input.sticky,input.bind_begin,input.bind_end,&s.ages,&mut s.positions,&mut s.previous_heights,height)?;
    crate::native_simple_particle_tail::finish(input.time,s.active,&mut s.last_time,&mut s.counter);
    *state=s;*rng=random;Ok(ran)
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::{Value,json};use crate::native_simple_particle_bounds::Bounds;
    fn words(v:&Value)->Vec<u32>{v.as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect()}
    fn triples(v:&Value)->Vec<[u32;3]>{words(v).chunks_exact(3).map(|v|v.try_into().unwrap()).collect()}
    fn exercise(source:&str,expected:usize,extended:bool,terrain:bool) {
        let p:Value=serde_json::from_str(source).unwrap();let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),expected);assert_eq!(p["adapters"].as_array().unwrap().len(),usize::from(terrain));
        let identity=[1f32,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.].map(f32::to_bits);let mut inverse=identity;inverse[12..15].copy_from_slice(&[-100f32,-200.,-300.].map(f32::to_bits));let mut current=identity;current[12..15].copy_from_slice(&[110f32,220.,330.].map(f32::to_bits));
        for (i,r) in rows.iter().enumerate() {
            let n=|key:&str|r[key].as_u64().unwrap() as u32;let count=r["birth"].as_array().unwrap().len();
            let mode=r["probability_mode"].as_u64().unwrap_or(1);let force_enabled=r["force_enabled"].as_bool().unwrap_or(false);
            let probability=ProbabilityCurve {present:true,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let force=graph::Input {body:crate::native_particle_force_body::Input {acceleration:Some([1f32,-2.,0.5].map(f32::to_bits)),points:&[],dampings:&[],children:&[],final_children:&[],delta:0},random_forces:&[],axis_forces:&[]};
            let mut s=State {last_time:n("last"),life:words(&r["life"]),ages:vec![0xcccccccc;count],active:99,positions:triples(&r["positions"]),velocities:triples(&r["velocities"]),scales:vec![1f32.to_bits();count],factors:words(&r["factors"]),scalar:vec![(-0.5f32).to_bits();count],rates:vec![0.25f32.to_bits();count],auxiliary:vec![0;count],attribute_a:vec![0xcccccccc;count],attribute_b:vec![0xcccccccc;count],previous_heights:vec![0;count],bounds:bounds::State {bounds:Bounds {minimum:[-1f32,-2.,-3.].map(f32::to_bits),maximum:[1f32,2.,3.].map(f32::to_bits)},center:[100f32,200.,300.].map(f32::to_bits),last:0},counter:7};
            let birth=words(&r["birth"]);let input=Input {time:n("time"),cap:n("cap"),birth:&birth,bounds_flag:n("flag") as u8,previous_position:[100f32,200.,300.].map(f32::to_bits),current_position:[110f32,220.,330.].map(f32::to_bits),initial_inverse:inverse,current_matrix:current,bind_begin:0,bind_end:1f32.to_bits(),sticky:n("sticky") as u8,local:n("local") as u8,circular:r["circular"].as_u64().unwrap_or(0) as u8,direction:r["direction"].as_u64().unwrap_or(0) as u32,force_resource:if force_enabled {0x30000}else{0},force_graph:if force_enabled {Some(&force)}else{None},scalar_enabled:n("scalar_enabled") as u8,scalar_table:Table {values:&[1.,2.,3.],probability:Some(&probability)},scale_table:Table {values:&[1.,2.,3.],probability:if extended {Some(&probability)}else{None}},attributes:[Attribute {mode:0,multiplier:1f32.to_bits(),offset:0},Attribute {mode:0,multiplier:2f32.to_bits(),offset:0}],bounds_factor:1f32.to_bits(),terrain_enabled:u8::from(terrain)};
            let mut events=vec![];let mut height_events=vec![];let height_values=if terrain {words(&r["heights"])}else{vec![]};let mut rng=if extended {Rng55 {words:words(&r["rng"]).try_into().unwrap(),first:0,second:0}}else{Rng55::seeded(17)};let original=rng.clone();
            update(&input,&mut s,&mut rng,&mut |arguments|{if !terrain{return Err("terrain is disabled");}let height=height_values[height_events.len()];height_events.push(json!({"arguments":arguments,"height":height}));Ok(height)},&mut |e|match e {Event::Entry(a)=>events.push(json!(format!("0x{a:x}"))),_=>assert!(extended,"unexpected force or circular child")}).unwrap();let e=&r["cpu"];
            for (actual,key) in [(&s.life,"life"),(&s.ages,"ages"),(&s.scales,"scales"),(&s.scalar,"scalar"),(&s.attribute_a,"attribute_a"),(&s.attribute_b,"attribute_b")] {assert_eq!(*actual,words(&e[key]),"{key} case{i}");}
            if terrain {assert_eq!(s.previous_heights,words(&e["previous_heights"]),"heights case{i}");assert_eq!(height_events,e["height_events"].as_array().unwrap().clone(),"height events case{i}");}
            assert_eq!(s.positions,triples(&e["positions"]),"position case{i}");assert_eq!(s.velocities,triples(&e["velocities"]),"velocity case{i}");
            for (actual,key) in [(s.last_time,"last_time"),(s.active,"active"),(s.counter,"counter"),(s.bounds.last,"bounds_last")] {assert_eq!(actual as u64,e[key].as_u64().unwrap(),"{key} case{i}");}
            assert_eq!(s.bounds.bounds.minimum.as_slice(),words(&e["minimum"]),"minimum case{i}");assert_eq!(s.bounds.bounds.maximum.as_slice(),words(&e["maximum"]),"maximum case{i}");assert_eq!(s.bounds.center.as_slice(),words(&e["center"]),"center case{i}");assert_eq!(events,e["events"].as_array().unwrap().clone(),"events case{i}");if extended {assert_eq!(rng.words.as_slice(),words(&e["rng"]),"rng case{i}");assert_eq!(rng.first as u64,e["first"].as_u64().unwrap(),"first case{i}");assert_eq!(rng.second as u64,e["second"].as_u64().unwrap(),"second case{i}");}else{assert_eq!((rng.words,rng.first,rng.second),(original.words,original.first,original.second));}
        }
    }
    #[test]
    fn whole_update_matches480_original_cases_all_arrays_and_call_order() {
        exercise(include_str!("../../../data/4.20/simple_particle_update_contract.json"),480,false,false);
    }
    #[test]
    fn extended_update_matches1152_original_cpu_cases_including_shared_rng() {
        exercise(include_str!("../../../data/4.20/simple_particle_update_extended_contract.json"),1152,true,false);
    }

    #[test]
    fn terrain_update_matches480_original_cases_and_height_provider_order() {
        exercise(include_str!("../../../data/4.20/simple_particle_update_terrain_contract.json"),480,false,true);
    }

}
