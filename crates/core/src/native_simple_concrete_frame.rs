//!9437E0 composed with actual943300 pose and944E20 particle consumers.
use crate::{native_simple_frame as frame,native_simple_pose as pose,native_simple_particle_update as particles,native_simple_control as control,native_simple_animation_policy as animation,native_simple_auxiliary::Helper,native_simple_animation_clock::Clip,native_random::Rng55,native_simple_emission_lifecycle as emission};
pub struct State {pub frame:frame::State,pub pose:pose::State,pub particles:Option<particles::State>,pub birth:Vec<u32>,pub emission:emission::State}
pub struct Input<'a> {pub frame:frame::Input,pub pose:pose::Input,pub particles:particles::Input<'a>}
/// Source-owned emission may allocate storage and append births. Animation
/// evaluators own their scratch context and expose their resulting owner pose.
/// None of these obligations is replaced with generated defaults.
pub trait Sources:animation::Backend {
    fn emission(&mut self,time:u32,progress:u32,resource:&mut u32,storage:&mut Option<particles::State>,birth:&mut Vec<u32>,pose:&pose::State,owner:&mut emission::State,rng:&mut Rng55)->Result<(),&'static str>;
    fn modifier(&mut self,resource:u32,time:u32,progress:u32,matrix:&mut [u32;16])->Result<(),&'static str>;
    fn initialize_manager(&mut self,helper:&mut Helper)->Result<u8,&'static str>;
    fn evaluated_pose(&mut self,base:[u32;16])->Result<[u32;16],&'static str>;
}
struct Adapter<'a,'b,S,H,O> {
    source:&'a mut S,input:&'a Input<'b>,pose:&'a mut pose::State,
    storage:&'a mut Option<particles::State>,birth:&'a mut Vec<u32>,rng:&'a mut Rng55,
    emission:&'a mut emission::State,
    height:&'a mut H,observer:&'a mut O,error:Option<&'static str>,animation_evaluated:bool,
}
impl<S:Sources,H:FnMut([u32;3])->Result<u32,&'static str>,O:FnMut(particles::Event)> control::Backend for Adapter<'_,'_,S,H,O> {
    fn attachment(&mut self,time:u32,progress:u32) {
        if self.error.is_some(){return;}(self.observer)(particles::Event::Entry(0x943300));
        let p=&self.input.pose;let input=pose::Input {emitter_local:p.emitter_local,warm:self.emission.emitted,system_matrix:p.system_matrix,position:p.position,inverse_fallback:p.inverse_fallback,modifier:p.modifier};
        self.error=pose::update(self.pose,&input,time,progress,&mut |r,t,p,m|self.source.modifier(r,t,p,m)).err();
    }
    fn emission(&mut self,time:u32,progress:u32,resource:&mut u32) {
        if self.error.is_none(){(self.observer)(particles::Event::Entry(0x941f00));self.error=self.source.emission(time,progress,resource,self.storage,self.birth,self.pose,self.emission,self.rng).err();}
    }
    fn particles(&mut self,_:u32,time:u32,cap:u32,last_step:u32) {
        if self.error.is_some(){return;}let Some(state)=self.storage.as_mut()else{self.error=Some("missing actual particle storage");return;};
        (self.observer)(particles::Event::Entry(0x944e20));
        let p=&self.input.particles;
        let input=particles::Input {time,cap,birth:self.birth,bounds_flag:last_step as u8,
            previous_position:self.pose.previous[12..15].try_into().unwrap(),current_position:self.pose.current[12..15].try_into().unwrap(),initial_inverse:self.pose.initial_inverse,current_matrix:self.pose.current,
            bind_begin:p.bind_begin,bind_end:p.bind_end,sticky:p.sticky,local:p.local,circular:p.circular,direction:p.direction,force_resource:p.force_resource,force_graph:p.force_graph,
            scalar_enabled:p.scalar_enabled,scalar_table:p.scalar_table,scale_table:p.scale_table,attributes:p.attributes,bounds_factor:self.emission.bounds_factor,terrain_enabled:p.terrain_enabled};
        self.error=particles::update(&input,state,self.rng,self.height,self.observer).err();
    }
}
impl<S:Sources,H:FnMut([u32;3])->Result<u32,&'static str>,O:FnMut(particles::Event)> animation::Backend for Adapter<'_,'_,S,H,O> {
    fn lookup(&mut self,index:u32)->Option<Clip>{if self.error.is_some(){None}else{self.source.lookup(index)}}
    fn special_kind11(&mut self,state:&mut animation::State){if let Err(e)=self.special_kind11_checked(state){self.error=Some(e);}}
    fn special_kind11_checked(&mut self,state:&mut animation::State)->Result<(),&'static str>{
        if let Some(e)=self.error{return Err(e)}
        //943760 only enqueues. The pose is copied later by the owner drain.
        //Do not run evaluated_pose synchronously for this branch.
        self.source.special_kind11_checked(state)
    }
    fn evaluate_uncompressed(&mut self,clip:Clip,time:u32,mapping:u32,state:&mut animation::State){if self.error.is_none(){self.source.evaluate_uncompressed(clip,time,mapping,state);self.animation_evaluated=true;}}
    fn evaluate_compressed(&mut self,clip:Clip,time:u32,mapping:u32,state:&mut animation::State){if self.error.is_none(){self.source.evaluate_compressed(clip,time,mapping,state);self.animation_evaluated=true;}}
}
impl<S:Sources,H:FnMut([u32;3])->Result<u32,&'static str>,O:FnMut(particles::Event)> frame::Backend for Adapter<'_,'_,S,H,O> {
    fn initialize_manager(&mut self,helper:&mut Helper)->u8 {
        if self.error.is_some(){return 0;}match self.source.initialize_manager(helper){Ok(v)=>v,Err(e)=>{self.error=Some(e);0}}
    }
    fn current_pose(&mut self)->[u32;16] {
        if self.error.is_none()&&self.animation_evaluated {match self.source.evaluated_pose(self.pose.current){Ok(p)=>self.pose.current=p,Err(e)=>self.error=Some(e)}}self.pose.current
    }
    fn active_particles(&mut self,_:u32)->u32{self.storage.as_ref().map_or(0,|s|s.active)}
}
/// State and RNG commit together after success. Source callbacks and observers
/// can see attempted calls on failure; external source effects are not rolled back.
pub fn update(state:&mut State,input:&Input,rng:&mut Rng55,source:&mut impl Sources,height:&mut impl FnMut([u32;3])->Result<u32,&'static str>,observer:&mut impl FnMut(particles::Event))->Result<(),&'static str> {
    let mut owner=frame::State {particles:state.frame.particles,helper:state.frame.helper,animation:state.frame.animation.clone(),tail:state.frame.tail.clone()};
    let mut pose=state.pose.clone();pose.previous=owner.tail.previous;pose.initial_inverse=owner.tail.previous_inverse;
    let mut storage=state.particles.clone();let mut birth=state.birth.clone();let mut random=rng.clone();let mut emission=state.emission.clone();
    let mut backend=Adapter {source,input,pose:&mut pose,storage:&mut storage,birth:&mut birth,rng:&mut random,emission:&mut emission,height,observer,error:None,animation_evaluated:false};
    frame::update(&mut owner,&input.frame,&mut backend)?;
    if let Some(error)=backend.error{return Err(error);}
    pose.previous=owner.tail.previous;pose.initial_inverse=owner.tail.previous_inverse;
    state.frame=owner;state.pose=pose;state.particles=storage;state.birth=birth;state.emission=emission;*rng=random;Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;use crate::{native_probability_curve::ProbabilityCurve,native_particle_force_graph as graph,native_simple_bounds_policy as bounds};use serde_json::{Value,json};use crate::native_simple_particle_bounds::Bounds;
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
            let s=particles::State {last_time:n("last"),life:words(&r["life"]),ages:vec![0xcccccccc;count],active:99,positions:triples(&r["positions"]),velocities:triples(&r["velocities"]),scales:vec![1f32.to_bits();count],factors:words(&r["factors"]),scalar:vec![(-0.5f32).to_bits();count],rates:vec![0.25f32.to_bits();count],auxiliary:vec![0;count],attribute_a:vec![0xcccccccc;count],attribute_b:vec![0xcccccccc;count],previous_heights:vec![0;count],bounds:bounds::State {bounds:Bounds {minimum:[-1f32,-2.,-3.].map(f32::to_bits),maximum:[1f32,2.,3.].map(f32::to_bits)},center:[100f32,200.,300.].map(f32::to_bits),last:0},counter:7};
            let birth=words(&r["birth"]);let input=particles::Input {time:n("time"),cap:n("cap"),birth:&birth,bounds_flag:n("flag") as u8,previous_position:[100f32,200.,300.].map(f32::to_bits),current_position:[110f32,220.,330.].map(f32::to_bits),initial_inverse:inverse,current_matrix:current,bind_begin:0,bind_end:1f32.to_bits(),sticky:n("sticky") as u8,local:n("local") as u8,circular:r["circular"].as_u64().unwrap_or(0) as u8,direction:r["direction"].as_u64().unwrap_or(0) as u32,force_resource:if force_enabled {0x30000}else{0},force_graph:if force_enabled {Some(&force)}else{None},scalar_enabled:n("scalar_enabled") as u8,scalar_table:particles::Table {values:&[1.,2.,3.],probability:Some(&probability)},scale_table:particles::Table {values:&[1.,2.,3.],probability:if extended {Some(&probability)}else{None}},attributes:[particles::Attribute {mode:0,multiplier:1f32.to_bits(),offset:0},particles::Attribute {mode:0,multiplier:2f32.to_bits(),offset:0}],bounds_factor:1f32.to_bits(),terrain_enabled:u8::from(terrain)};
            let mut events=vec![];let mut height_events=vec![];let height_values=if terrain {words(&r["heights"])}else{vec![]};let mut rng=if extended {Rng55 {words:words(&r["rng"]).try_into().unwrap(),first:0,second:0}}else{Rng55::seeded(17)};let original=rng.clone();
            let mut previous=[0;16];previous[12..15].copy_from_slice(&[100f32,200.,300.].map(f32::to_bits));
            let mut owner=State {emission:emission::State {previous:0,emitted:1,counter:0,bounds_factor:1f32.to_bits()},frame:frame::State {particles:1,helper:None,animation:animation::State {clock:0.25f32.to_bits(),resource:0,pose_flag:0},tail:crate::native_simple_finish::State {previous,previous_inverse:inverse,last_time:n("last"),finished:0}},pose:pose::State {current,previous,initial_inverse:inverse},particles:Some(s),birth:birth.clone()};
            let full=Input {frame:frame::Input {control:control::Input {flags:0x10,time:n("time"),start:0,life:1f32.to_bits(),lower:0.5f32.to_bits(),upper:1f32.to_bits(),delay:0,emitter_linger:0,particle_linger:n("cap"),last_step:n("flag")},position:[110f32,220.,330.].map(f32::to_bits),previous_position:[100f32,200.,300.].map(f32::to_bits),reset_value:0,manager_flag:None,definition_kind:0,clip_index:0,mapping:0,inverse_fallback:identity},pose:pose::Input {emitter_local:1,warm:1,system_matrix:identity,position:[110f32,220.,330.].map(f32::to_bits),inverse_fallback:identity,modifier:0},particles:input};
            update(&mut owner,&full,&mut rng,&mut NoSources,&mut |arguments|{if !terrain{return Err("terrain is disabled");}let height=height_values[height_events.len()];height_events.push(json!({"arguments":arguments,"height":height}));Ok(height)},&mut |e|match e {particles::Event::Entry(a)=>events.push(json!(format!("0x{a:x}"))),_=>assert!(extended,"unexpected force or circular child")}).unwrap();let e=&r["cpu"];let s=owner.particles.take().unwrap();
            assert_eq!(owner.pose.current.as_slice(),words(&e["emitter_current"]),"owner current case{i}");
            assert_eq!(owner.frame.tail.previous.as_slice(),words(&e["emitter_previous"]),"owner previous case{i}");
            assert_eq!(owner.frame.tail.previous_inverse.as_slice(),words(&e["emitter_inverse"]),"owner inverse case{i}");
            assert_eq!(owner.pose.previous,owner.frame.tail.previous,"shared previous matrix case{i}");
            assert_eq!(owner.pose.initial_inverse,owner.frame.tail.previous_inverse,"shared inverse matrix case{i}");
            assert_eq!(owner.frame.tail.last_time as u64,e["emitter_last_time"].as_u64().unwrap(),"owner time case{i}");
            assert_eq!(owner.frame.tail.finished as u64,e["emitter_finished"].as_u64().unwrap(),"owner finish case{i}");
            assert_eq!(owner.frame.animation.clock as u64,e["emitter_clock"].as_u64().unwrap(),"owner clock case{i}");
            for (actual,key) in [(&s.life,"life"),(&s.ages,"ages"),(&s.scales,"scales"),(&s.scalar,"scalar"),(&s.attribute_a,"attribute_a"),(&s.attribute_b,"attribute_b")] {assert_eq!(*actual,words(&e[key]),"{key} case{i}");}
            if terrain {assert_eq!(s.previous_heights,words(&e["previous_heights"]),"heights case{i}");assert_eq!(height_events,e["height_events"].as_array().unwrap().clone(),"height events case{i}");}
            assert_eq!(s.positions,triples(&e["positions"]),"position case{i}");assert_eq!(s.velocities,triples(&e["velocities"]),"velocity case{i}");
            for (actual,key) in [(s.last_time,"last_time"),(s.active,"active"),(s.counter,"counter"),(s.bounds.last,"bounds_last")] {assert_eq!(actual as u64,e[key].as_u64().unwrap(),"{key} case{i}");}
            assert_eq!(s.bounds.bounds.minimum.as_slice(),words(&e["minimum"]),"minimum case{i}");assert_eq!(s.bounds.bounds.maximum.as_slice(),words(&e["maximum"]),"maximum case{i}");assert_eq!(s.bounds.center.as_slice(),words(&e["center"]),"center case{i}");assert_eq!(events,e["events"].as_array().unwrap().clone(),"events case{i}");if extended {assert_eq!(rng.words.as_slice(),words(&e["rng"]),"rng case{i}");assert_eq!(rng.first as u64,e["first"].as_u64().unwrap(),"first case{i}");assert_eq!(rng.second as u64,e["second"].as_u64().unwrap(),"second case{i}");}else{assert_eq!((rng.words,rng.first,rng.second),(original.words,original.first,original.second));}
        }
    }

    struct NoSources;
    impl animation::Backend for NoSources {
        fn lookup(&mut self,_:u32)->Option<Clip>{panic!("no animation in native fixture")}
        fn special_kind11(&mut self,_:&mut animation::State){panic!("no animation in native fixture")}
        fn evaluate_uncompressed(&mut self,_:Clip,_:u32,_:u32,_:&mut animation::State){panic!("no animation in native fixture")}
        fn evaluate_compressed(&mut self,_:Clip,_:u32,_:u32,_:&mut animation::State){panic!("no animation in native fixture")}
    }
    impl Sources for NoSources {
        fn emission(&mut self,_:u32,_:u32,_:&mut u32,_:&mut Option<particles::State>,_:&mut Vec<u32>,_:&pose::State,_:&mut emission::State,_:&mut Rng55)->Result<(),&'static str>{panic!("native emitter is expired")}
        fn modifier(&mut self,_:u32,_:u32,_:u32,_:&mut [u32;16])->Result<(),&'static str>{panic!("native modifier is null")}
        fn initialize_manager(&mut self,_:&mut Helper)->Result<u8,&'static str>{panic!("native helper is null")}
        fn evaluated_pose(&mut self,_:[u32;16])->Result<[u32;16],&'static str>{panic!("native animation is null")}
    }
    #[test]
    fn complete_frame_matches384_native_end_of_life_cases() {
        exercise(include_str!("../../../data/4.20/simple_frame_particles_contract.json"),384,false,false);
    }

    struct ConstantSources {single:u32,rate:f32}
    impl animation::Backend for ConstantSources {
        fn lookup(&mut self,index:u32)->Option<Clip>{NoSources.lookup(index)}
        fn special_kind11(&mut self,state:&mut animation::State){NoSources.special_kind11(state)}
        fn evaluate_uncompressed(&mut self,c:Clip,t:u32,m:u32,s:&mut animation::State){NoSources.evaluate_uncompressed(c,t,m,s)}
        fn evaluate_compressed(&mut self,c:Clip,t:u32,m:u32,s:&mut animation::State){NoSources.evaluate_compressed(c,t,m,s)}
    }
    impl Sources for ConstantSources {
        fn emission(&mut self,time:u32,_:u32,resource:&mut u32,storage:&mut Option<particles::State>,birth:&mut Vec<u32>,pose:&pose::State,owner:&mut emission::State,rng:&mut Rng55)->Result<(),&'static str>{
            if *resource==0{return Err("native allocation unqualified");}let Some(storage)=storage else{return Err("missing native storage");};
            emission::update(owner,crate::native_simple_emission_count::Input {time:f32::from_bits(time),start:10.,previous:f32::from_bits(owner.previous),life:1.,delay:0.,period:100.,window:100.,rate:self.rate,single:self.single,emitted:owner.emitted},&emission::Prepared {life:2f32.to_bits(),scalar:0,rate:500f32.to_bits(),factor:0,offset:[10f32,20.,30.].map(f32::to_bits),position_offset:[0;3],velocity:[0;3],matrix:pose.current,previous_position:pose.previous[12..15].try_into().unwrap(),current_position:pose.current[12..15].try_into().unwrap(),bounds_factor:1f32.to_bits(),scale:particles::Table {values:&[1.],probability:None},terrain:0},storage,birth,rng,&mut |_|Err("native terrain disabled"))?;
            Ok(())
        }
        fn modifier(&mut self,r:u32,t:u32,p:u32,m:&mut [u32;16])->Result<(),&'static str>{NoSources.modifier(r,t,p,m)}
        fn initialize_manager(&mut self,h:&mut Helper)->Result<u8,&'static str>{NoSources.initialize_manager(h)}
        fn evaluated_pose(&mut self,p:[u32;16])->Result<[u32;16],&'static str>{NoSources.evaluated_pose(p)}
    }
    #[test]
    fn normal_frame_matches256_native_cases_with_shared_birth_update_rng() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_normal_frame_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),256);
        let identity=std::array::from_fn(|j|if [0,5,10,15].contains(&j){1f32.to_bits()}else{0});
        for (index,row) in rows.iter().enumerate(){let r=&row["cpu"];let f=|key:&str|r[key].as_f64().unwrap() as f32;let n=|key:&str|r[key].as_u64().unwrap() as u32;
            let mut previous=identity;previous[12..15].copy_from_slice(&[60f32,170.,280.].map(f32::to_bits));let mut inverse=identity;inverse[12..15].copy_from_slice(&[-60f32,-170.,-280.].map(f32::to_bits));let mut current=identity;current[12..15].copy_from_slice(&[110f32,220.,330.].map(f32::to_bits));
            let mut owner=State {emission:emission::State {previous:f("previous").to_bits(),emitted:n("latch") as u8,counter:0,bounds_factor:1f32.to_bits()},frame:frame::State {particles:1,helper:None,animation:animation::State {clock:0.25f32.to_bits(),resource:0,pose_flag:0},tail:crate::native_simple_finish::State {previous,previous_inverse:inverse,last_time:10f32.to_bits(),finished:0}},pose:pose::State {current,previous,initial_inverse:inverse},particles:Some(particles::State {last_time:10f32.to_bits(),life:vec![],ages:vec![],active:0,positions:vec![],velocities:vec![],scales:vec![],factors:vec![],scalar:vec![],rates:vec![],auxiliary:vec![],attribute_a:vec![],attribute_b:vec![],previous_heights:vec![],bounds:bounds::State {bounds:Bounds {minimum:[-1f32,-2.,-3.].map(f32::to_bits),maximum:[1f32,2.,3.].map(f32::to_bits)},center:[60f32,170.,280.].map(f32::to_bits),last:10f32.to_bits()},counter:0}),birth:vec![]};
            let time=(10.+f("age")).to_bits();let mut input=Input {frame:frame::Input {control:control::Input {flags:0,time,start:10f32.to_bits(),life:1f32.to_bits(),lower:100f32.to_bits(),upper:100f32.to_bits(),delay:0,emitter_linger:0,particle_linger:0,last_step:n("flag")},position:[110f32,220.,330.].map(f32::to_bits),previous_position:[60f32,170.,280.].map(f32::to_bits),reset_value:0,manager_flag:None,definition_kind:0,clip_index:0,mapping:0,inverse_fallback:identity},pose:pose::Input {emitter_local:1,warm:n("latch") as u8,system_matrix:identity,position:[110f32,220.,330.].map(f32::to_bits),inverse_fallback:identity,modifier:0},particles:particles::Input {time,cap:f32::MAX.to_bits(),birth:&[],bounds_flag:n("flag") as u8,previous_position:[60f32,170.,280.].map(f32::to_bits),current_position:[110f32,220.,330.].map(f32::to_bits),initial_inverse:inverse,current_matrix:current,bind_begin:0,bind_end:0,sticky:0,local:0,circular:0,direction:0,force_resource:0,force_graph:None,scalar_enabled:0,scalar_table:particles::Table {values:&[],probability:None},scale_table:particles::Table {values:&[1.],probability:None},attributes:[particles::Attribute {mode:0,multiplier:1f32.to_bits(),offset:0},particles::Attribute {mode:0,multiplier:2f32.to_bits(),offset:0}],bounds_factor:1f32.to_bits(),terrain_enabled:0}};
            let mut rng=Rng55 {words:std::array::from_fn(|j|12345+j as u32*13579),first:0,second:0};let mut events=vec![];

            if f("age")==0.125 && n("single")==0 && n("latch")==0 && n("flag")==0 && f("previous")==10. {
                let old_emission=owner.emission.clone();let old_pose=owner.pose.clone();let old_tail=owner.frame.tail.clone();let old_rng=rng.clone();
                input.particles.force_resource=1;
                assert!(update(&mut owner,&input,&mut rng,&mut ConstantSources {single:n("single"),rate:f("rate")},&mut |_|Err("native terrain disabled"),&mut |_|{}).is_err());
                assert_eq!(owner.emission,old_emission,"failed frame emission state case{index}");assert_eq!(owner.pose,old_pose);assert_eq!(owner.frame.tail,old_tail);assert!(owner.birth.is_empty());assert!(owner.particles.as_ref().unwrap().life.is_empty());
                assert_eq!((rng.words,rng.first,rng.second),(old_rng.words,old_rng.first,old_rng.second),"failed frame RNG case{index}");
                input.particles.force_resource=0;
            }
            update(&mut owner,&input,&mut rng,&mut ConstantSources {single:n("single"),rate:f("rate")},&mut |_|Err("native terrain disabled"),&mut |event|match event {particles::Event::Entry(a)=>events.push(json!(format!("0x{a:x}"))),_=>panic!("native fixture has no concrete force or circular child")}).unwrap();
            let s=owner.particles.as_ref().unwrap();let a=&r["arrays"];
            for (actual,key) in [(&owner.birth,"0x8"),(&s.life,"0x14"),(&s.ages,"0x20"),(&s.scales,"0x44"),(&s.factors,"0x50"),(&s.scalar,"0x5c"),(&s.rates,"0x68"),(&s.auxiliary,"0x74"),(&s.attribute_a,"0x80"),(&s.attribute_b,"0x8c"),(&s.previous_heights,"0x98")]{assert_eq!(*actual,words(&a[key]),"{key} case{index}");}
            assert_eq!(s.positions.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x2c"]),"position case{index}");assert_eq!(s.velocities.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x38"]),"velocity case{index}");
            for (actual,key) in [(s.last_time,"last_time"),(s.active,"active"),(s.counter,"update_counter"),(s.bounds.last,"bounds_last"),(owner.emission.previous,"last_emission"),(owner.emission.counter,"counter"),(owner.emission.bounds_factor,"bounds_factor"),(owner.emission.emitted as u32,"emitted"),(owner.frame.tail.last_time,"emitter_last_time"),(owner.frame.tail.finished as u32,"emitter_finished"),(owner.frame.animation.clock,"emitter_clock")]{assert_eq!(actual,n(key),"{key} case{index}");}
            for (actual,key) in [(s.bounds.bounds.minimum.as_slice(),"minimum"),(s.bounds.bounds.maximum.as_slice(),"maximum"),(s.bounds.center.as_slice(),"center"),(owner.pose.current.as_slice(),"emitter_current"),(owner.frame.tail.previous.as_slice(),"emitter_previous"),(owner.frame.tail.previous_inverse.as_slice(),"emitter_inverse")]{assert_eq!(actual,words(&r[key]),"{key} case{index}");}
            assert_eq!(rng.words.as_slice(),words(&r["rng"]),"rng case{index}");assert_eq!(rng.first,n("first"));assert_eq!(rng.second,n("second"));assert_eq!(events,r["events"].as_array().unwrap().clone(),"events case{index}");
        }
    }
}
