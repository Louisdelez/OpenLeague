//! Whole9437E0 composition. Concrete producers remain explicit backend obligations.
use crate::{native_simple_control as control,native_simple_auxiliary as auxiliary,native_simple_animation_policy as animation,native_simple_finish as tail};
pub struct State {pub particles:u32,pub helper:Option<auxiliary::Helper>,pub animation:animation::State,pub tail:tail::State}
pub struct Input {pub control:control::Input,pub position:[u32;3],pub previous_position:[u32;3],pub reset_value:u32,pub manager_flag:Option<u8>,pub definition_kind:u32,pub clip_index:u32,pub mapping:u32,pub inverse_fallback:[u32;16]}
pub trait Backend:control::Backend+animation::Backend {
    fn initialize_manager(&mut self,helper:&mut auxiliary::Helper)->u8;
    fn current_pose(&mut self)->[u32;16];
    fn active_particles(&mut self,resource:u32)->u32;
}
pub fn update(state:&mut State,input:&Input,backend:&mut impl Backend)->Result<(),&'static str> {
    let expired=control::update(&input.control,&mut state.particles,backend);
    let baseline=auxiliary::update(&auxiliary::Input {time:input.control.time,previous_time:state.tail.last_time,position:input.position,previous_position:input.previous_position,reset_value:input.reset_value,manager_flag:input.manager_flag},state.helper.as_mut(),|h|backend.initialize_manager(h));
    animation::update(&mut state.animation,&animation::Input {definition_kind:input.definition_kind,clip_index:input.clip_index,time:input.control.time,baseline,mapping:input.mapping},backend)?;
    let pose=backend.current_pose();
    let active=if state.particles!=0 {backend.active_particles(state.particles)}else{0};
    tail::finish(&mut state.tail,&tail::Input {current_pose:pose,inverse_fallback:input.inverse_fallback,time:input.control.time,expired:u8::from(expired),storage_present:state.particles!=0,active_particles:active});
    Ok(())
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::{Value,json};use crate::native_simple_animation_clock::Clip;
    struct Adapter {events:Vec<Value>,create:bool,kind:u32,matrix:[u32;16],active:u32}
    impl Adapter {
        fn event(&mut self,name:&str,time:u32,value:u32,last:Option<u32>){self.events.push(json!({"event":name,"time":format!("0x{time:x}"),"value":format!("0x{value:x}"),"last_step":last}));}
        fn evaluate(&mut self,name:&str,time:u32,mapping:u32,state:&animation::State){self.events.push(json!({"event":name,"time":format!("0x{time:x}"),"mapping":mapping,"pose_flag":state.pose_flag}));}
    }
    impl control::Backend for Adapter {
        fn attachment(&mut self,t:u32,p:u32){self.event("attachment",t,p,None)}
        fn emission(&mut self,t:u32,p:u32,r:&mut u32){self.event("emission",t,p,None);if self.create {*r=1;}}
        fn particles(&mut self,_:u32,t:u32,c:u32,last:u32){self.event("particles",t,c,Some(last))}
    }
    impl animation::Backend for Adapter {
        fn lookup(&mut self,index:u32)->Option<Clip>{self.events.push(json!({"event":"lookup","index":index}));Some(Clip {kind:self.kind,frames:2,factor:0x3f000000})}
        fn special_kind11(&mut self,_:&mut animation::State){panic!("not in this fixture")}
        fn evaluate_uncompressed(&mut self,_:Clip,t:u32,m:u32,s:&mut animation::State){self.evaluate("uncompressed",t,m,s)}
        fn evaluate_compressed(&mut self,_:Clip,t:u32,m:u32,s:&mut animation::State){self.evaluate("compressed",t,m,s)}
    }
    impl Backend for Adapter {
        fn initialize_manager(&mut self,_:&mut auxiliary::Helper)->u8{panic!("fixture supplies manager")}
        fn current_pose(&mut self)->[u32;16]{self.matrix}
        fn active_particles(&mut self,_:u32)->u32{self.active}
    }
    fn bits(v:&Value)->u32{u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    fn words(v:&Value)->[u32;16]{std::array::from_fn(|i|v[i].as_u64().unwrap() as u32)}
    #[test]
    fn whole_simple_frame_matches1024_native_cpu_cases() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_frame_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),1024);
        let identity=std::array::from_fn(|i|if [0,5,10,15].contains(&i){0x3f800000}else{0});
        for (i,r) in rows.iter().enumerate() {
            let n=|k:&str|r[k].as_u64().unwrap() as u32;let b=|k:&str|r[k].as_bool().unwrap();
            let mut state=State {particles:u32::from(b("present")),helper:b("helper_present").then_some(auxiliary::Helper {delta:[0xcccccccc;3],flag:1,accumulator:0x3e800000}),animation:animation::State {clock:0x3e800000,resource:u32::from(b("pose_present")),pose_flag:0x7f},tail:tail::State {previous:[0xcccccccc;16],previous_inverse:[0xdddddddd;16],last_time:bits(&r["previous_time"]),finished:0}};
            let mut backend=Adapter {events:vec![],create:b("create"),kind:n("clip_kind"),matrix:words(&r["matrix"]),active:n("active")};
            update(&mut state,&Input {control:control::Input {flags:n("flags") as u8,time:bits(&r["time"]),start:0,life:0x3f800000,lower:0x3f000000,upper:0x3f800000,delay:0,emitter_linger:0x3f000000,particle_linger:0,last_step:n("last_step")},position:[2f32,4.,6.].map(f32::to_bits),previous_position:[1f32,2.,3.].map(f32::to_bits),reset_value:0x3d088889,manager_flag:Some(n("manager_flag") as u8),definition_kind:0,clip_index:42,mapping:0x12345678,inverse_fallback:identity},&mut backend).unwrap();
            let e=&r["cpu"];
            assert_eq!(state.particles!=0,e["particle_present"].as_bool().unwrap(),"storage case{i}");assert_eq!(state.animation.clock,bits(&e["clock"]),"clock case{i}");assert_eq!(state.animation.pose_flag,e["pose_flag"].as_u64().unwrap() as u8,"pose flag case{i}");
            if let Some(h)=state.helper {assert_eq!(h.delta,std::array::from_fn(|j|bits(&e["helper_delta"][j])),"delta case{i}");assert_eq!(h.flag,e["helper_flag"].as_u64().unwrap() as u8);assert_eq!(h.accumulator,bits(&e["helper_accumulator"]),"accumulator case{i}");}
            assert_eq!(state.tail,tail::State {previous:words(&e["previous"]),previous_inverse:words(&e["inverse"]),last_time:bits(&e["last_time"]),finished:e["finished"].as_u64().unwrap() as u8},"tail case{i}");assert_eq!(backend.events,e["events"].as_array().unwrap().clone(),"events case{i}");
        }
    }
}
