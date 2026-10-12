//! First93F2F0 phase; stops at continue/skip/stop boundaries before frame writes.
use crate::{native_troy_resume as audio,native_troy_reset as reset,native_troy_scratch::Scratch};
#[derive(Debug,Copy,Clone,PartialEq,Eq)]
pub enum Path {Continue,Skip,Stop}
#[derive(Debug,Copy,Clone,PartialEq,Eq)]
pub struct Decision {pub visible:bool,pub path:Path}
pub trait Backend:audio::Backend+reset::PauseBackend {
    fn root_clock(&mut self)->u32;
    fn phase(&mut self,_:&'static str) {}
}
/// Original93F2F0 visibility predicate; camera bounds and source flags are separate inputs.
pub fn source_visible(in_view:bool,source_flags:u32,instance_flags:u8)->bool {
 (in_view || source_flags&0x40!=0) && instance_flags&8==0
}
pub struct Input {pub time:u32,pub start:u32,pub lifetime:u32,pub delay:u32,pub source_flags:u32,pub config_flags:u32,pub owner_present:bool,pub bounds:[u32;6]}
/// Qualified phases are composed, with explicit child filters and owned queues.
/// Producer backends and final skip/stop clock/flag writes remain separate.
pub fn update(input:&Input,clock:&mut u32,state:&mut audio::State,scratch:&Scratch,complex:&mut [reset::ComplexChild],complex_filters:&[reset::PauseFilter],simple:&mut [reset::SimpleChild],simple_filters:&[reset::PauseFilter],pending:&mut Vec<u32>,backend:&mut impl Backend)->Result<Decision,&'static str> {
    *clock=backend.root_clock();let in_view=scratch.contains_bounds(input.bounds)?;
    let visible=source_visible(in_view,input.source_flags,state.flags_1dc);
    if state.flags_1dc&2==0 && !visible {
        let stop=state.flags_1dc&0x10!=0 || (state.flags_1dc&1==0 && input.source_flags&2==0 && input.config_flags&1==0 && f32::from_bits(subtract(input.time,input.start))>=f32::from_bits(input.lifetime));
        if stop {state.flags_1dc|=2;}
    }
    if state.flags_1dc&2!=0 {return Ok(Decision {visible,path:Path::Stop});}
    if input.config_flags&0x20!=0 {
        backend.phase("acquire");audio::acquire(state,input.owner_present,backend);
        for key in state.handles {if key!=u32::MAX {audio::Backend::audio_pause(backend,key,u32::from(!visible));}}
    }
    if visible!=(state.flags_1dc&4!=0) {
        if visible {backend.phase("resume");backend.phase("acquire");audio::resume(state,input.source_flags,input.config_flags,input.delay,input.owner_present,backend);}
        else {
            backend.phase("pause");let mut temporary=reset::ResetState {handles:state.handles,times:[0;3],reset_b8:0,position:state.position,previous_position:[0;3],flags_1dd:state.flags_1dd,field_ec:state.field_ec};
            reset::pause(&mut temporary,&mut state.flags_1dc,input.config_flags,complex,complex_filters,simple,simple_filters,pending,backend)?;state.handles=temporary.handles;
        }
    }
    let path=if !visible && input.source_flags&2==0 && input.config_flags&1==0 {Path::Skip}else{Path::Continue};Ok(Decision {visible,path})
}
fn subtract(a:u32,b:u32)->u32 {
    let x=f32::from_bits(a);let y=f32::from_bits(b);if x.is_nan(){return a|0x00400000;}if y.is_nan(){return b|0x00400000;}let v=x-y;if v.is_nan(){0xffc00000}else{v.to_bits()}
}
#[cfg(test)]
mod tests {
    use super::*;
    use crate::native_complex_particle_storage::TrailBackend;
    use serde_json::{Value,json};
    #[derive(Default)]struct Adapter {events:Vec<Value>}
    impl audio::Backend for Adapter {
        fn owner_eligible(&mut self)->u8{panic!("descriptors disabled")}
        fn owner_id(&mut self)->u32{panic!("descriptors disabled")}
        fn create_primary(&mut self,_:&[u8;24],_:[u32;3],_:u32)->u32{panic!("descriptors disabled")}
        fn create_secondary(&mut self,_:&[u8;24],_:u32,_:[u32;3],_:u32)->u32{panic!("descriptors disabled")}
        fn audio_pause(&mut self,key:u32,paused:u32){self.events.push(json!({"event":"audio_pause","key":key,"paused":paused}));}
    }
    impl TrailBackend for Adapter {
        fn release_particle_trail(&mut self,_:[u32;2]){panic!("empty children")}
        fn set_particle_index(&mut self,_:[u32;2],_:usize){panic!("empty children")}
        fn drop_slot(&mut self,_:[u32;2]){panic!("empty children")}
    }
    impl reset::Backend for Adapter {fn audio_release(&mut self,key:u32){self.events.push(json!({"event":"audio_release","key":key}));}}
    impl reset::PauseBackend for Adapter {fn audio_pause(&mut self,key:u32,paused:u32){audio::Backend::audio_pause(self,key,paused);}}
    impl Backend for Adapter {
        fn root_clock(&mut self)->u32{self.events.push(json!({"event":"clock"}));99}
        fn phase(&mut self,event:&'static str){self.events.push(json!({"event":event}));}
    }
    fn bits(v:&Value)->u32{u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    #[test]
    fn first_frame_phase_matches1280_native_cases_with_real_pause_resume_composition() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/troy_frame_gate_contract.json")).unwrap();assert_eq!(proof["cases"].as_array().unwrap().len(),1280);
        for (i,row) in proof["cases"].as_array().unwrap().iter().enumerate() {
            let input=Input {time:bits(&row["time"]),start:bits(&row["start"]),lifetime:bits(&row["lifetime"]),delay:0.5f32.to_bits(),source_flags:row["source_flags"].as_u64().unwrap() as u32,config_flags:row["config_flags"].as_u64().unwrap() as u32,owner_present:false,bounds:[0;6]};
            let mut state=audio::State {handles:std::array::from_fn(|j|row["initial_handles"][j].as_u64().unwrap() as u32),descriptors:[[0;24];2],times:[input.start,0],position:[0;3],flags_1dc:row["flags"].as_u64().unwrap() as u8,flags_1dd:row["initial_flags_1dd"].as_u64().unwrap() as u8,field_ec:0.25f32.to_bits(),global_last_primary:0};
            let mut scratch=Scratch::default();if !row["visible"].as_bool().unwrap(){scratch.words[0x78/4]=(-1f32).to_bits();}
            let mut clock=0x12345678;let mut backend=Adapter::default();let decision=update(&input,&mut clock,&mut state,&scratch,&mut [],&[],&mut [],&[],&mut vec![],&mut backend).unwrap();let e=&row["cpu"];
            assert_eq!(decision.path,match e["path"].as_str().unwrap(){"continue"=>Path::Continue,"skip"=>Path::Skip,_=>Path::Stop},"case{i}");assert_eq!(decision.visible,u64::from(e["visible"].as_u64().unwrap())!=0,"case{i}");assert_eq!(clock,e["clock"].as_u64().unwrap() as u32);assert_eq!(state.flags_1dc,e["flags_1dc"].as_u64().unwrap() as u8,"case{i}");assert_eq!(state.flags_1dd,e["flags_1dd"].as_u64().unwrap() as u8,"case{i}");assert_eq!(state.field_ec,bits(&e["field_ec"]),"case{i}");assert_eq!(state.handles,std::array::from_fn(|j|e["handles"][j].as_u64().unwrap() as u32),"case{i}");assert_eq!(backend.events,e["events"].as_array().unwrap().clone(),"case{i}");
        }
    }
}
