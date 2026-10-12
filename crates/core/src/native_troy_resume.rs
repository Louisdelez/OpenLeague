//! Whole93EEE0/93ED60 policy; concrete audio/owner producers remain backends.
#[derive(Debug,Clone,PartialEq,Eq)]
pub struct State {pub handles:[u32;2],pub descriptors:[[u8;24];2],pub times:[u32;2],pub position:[u32;3],pub flags_1dc:u8,pub flags_1dd:u8,pub field_ec:u32,pub global_last_primary:u32}
pub trait Backend {
    fn owner_eligible(&mut self)->u8;
    fn owner_id(&mut self)->u32;
    fn create_primary(&mut self,descriptor:&[u8;24],position:[u32;3],elapsed:u32)->u32;
    fn create_secondary(&mut self,descriptor:&[u8;24],owner_id:u32,position:[u32;3],elapsed:u32)->u32;
    fn audio_pause(&mut self,key:u32,paused:u32);
}
fn arithmetic(a:u32,b:u32,add:bool)->u32 {
    let x=f32::from_bits(a);let y=f32::from_bits(b);
    if x.is_nan(){return a|0x00400000;}if y.is_nan(){return b|0x00400000;}
    let v=if add {x+y}else{x-y};if v.is_nan(){0xffc00000}else{v.to_bits()}
}
/// Original descriptor presence is the raw word at byte16, not a guessed string.
pub fn acquire(state:&mut State,owner_present:bool,backend:&mut impl Backend) {
    let present=|d:&[u8;24]|u32::from_le_bytes(d[16..20].try_into().unwrap())!=0;
    if state.handles[0]==u32::MAX && present(&state.descriptors[0]) {
        let key=backend.create_primary(&state.descriptors[0],state.position,arithmetic(state.times[1],state.times[0],false));state.handles[0]=key;
        if key!=0 {state.global_last_primary=key;}
    }
    if state.handles[1]==u32::MAX && present(&state.descriptors[1]) {
        let owner_id=if owner_present && backend.owner_eligible()!=0 {backend.owner_id()}else{0};
        state.handles[1]=backend.create_secondary(&state.descriptors[1],owner_id,state.position,arithmetic(state.times[1],state.times[0],false));
    }
}
pub fn resume(state:&mut State,source_flags:u32,config_flags:u32,delay:u32,owner_present:bool,backend:&mut impl Backend) {
    acquire(state,owner_present,backend);
    for key in state.handles {if key!=u32::MAX {backend.audio_pause(key,0);}}
    if state.flags_1dd&1==0 || (source_flags&2==0 && config_flags&1==0) {state.field_ec=arithmetic(delay,state.field_ec,true);}
    state.flags_1dc|=0x80;state.flags_1dd|=1;
}
#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::{Value,json};
    struct Adapter {events:Vec<Value>,eligibility:u8,returns:[u32;2]}
    impl Adapter {
        fn create(&mut self,kind:&str,d:&[u8;24],id:Option<u32>,position:[u32;3],elapsed:u32)->u32 {
            self.events.push(json!({"event":"audio_create","kind":kind,"owner_id":id,"elapsed":format!("0x{elapsed:x}"),"descriptor":d.iter().map(|b|format!("{b:02x}")).collect::<String>(),"position":position.map(|b|format!("0x{b:x}"))}));self.returns[usize::from(kind=="secondary")]
        }
    }
    impl Backend for Adapter {
        fn owner_eligible(&mut self)->u8{self.events.push(json!({"event":"eligible"}));self.eligibility}
        fn owner_id(&mut self)->u32{self.events.push(json!({"event":"owner_id"}));1234}
        fn create_primary(&mut self,d:&[u8;24],p:[u32;3],e:u32)->u32{self.create("primary",d,None,p,e)}
        fn create_secondary(&mut self,d:&[u8;24],id:u32,p:[u32;3],e:u32)->u32{self.create("secondary",d,Some(id),p,e)}
        fn audio_pause(&mut self,key:u32,paused:u32){self.events.push(json!({"event":"audio_pause","key":key,"paused":paused}));}
    }
    fn bits(v:&Value)->u32{u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    fn nums<const N:usize>(v:&Value)->[u32;N]{std::array::from_fn(|i|v[i].as_u64().unwrap() as u32)}
    #[test]
    fn acquire_and_resume_match1152_native_cpu_cases() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/troy_resume_contract.json")).unwrap();assert_eq!(proof["cases"].as_array().unwrap().len(),1152);assert_eq!(proof["actual_cpu_sse_operations"],1296);assert_eq!(proof["emulator_cpu_case_disagreements"],192);
        for (i,row) in proof["cases"].as_array().unwrap().iter().enumerate(){
            let before=&row["before"];let expected=&row["cpu"];
            let descriptors=std::array::from_fn(|n|{let mut d=[0x41+n as u8;24];d[16..20].copy_from_slice(&(row["descriptors"][n].as_u64().unwrap() as u32).to_le_bytes());d});
            let mut state=State {handles:nums(&before["handles"]),descriptors,times:std::array::from_fn(|n|bits(&row["times"][n])),position:std::array::from_fn(|n|bits(&row["position"][n])),flags_1dc:before["flags_1dc"].as_u64().unwrap() as u8,flags_1dd:before["flags_1dd"].as_u64().unwrap() as u8,field_ec:bits(&before["field_ec"]),global_last_primary:before["global_last_primary"].as_u64().unwrap() as u32};
            let mut backend=Adapter {events:vec![],eligibility:row["eligibility"].as_u64().unwrap() as u8,returns:nums(&row["returns"])};
            resume(&mut state,row["source_flags"].as_u64().unwrap() as u32,row["config_flags"].as_u64().unwrap() as u32,bits(&row["delay"]),row["owner_present"].as_bool().unwrap(),&mut backend);
            assert_eq!(state.handles,nums::<2>(&expected["handles"]),"case{i}");assert_eq!(state.flags_1dc,expected["flags_1dc"].as_u64().unwrap() as u8,"case{i}");assert_eq!(state.flags_1dd,expected["flags_1dd"].as_u64().unwrap() as u8,"case{i}");assert_eq!(state.field_ec,bits(&expected["field_ec"]),"case{i}");assert_eq!(state.global_last_primary,expected["global_last_primary"].as_u64().unwrap() as u32,"case{i}");assert_eq!(backend.events,expected["events"].as_array().unwrap().clone(),"case{i}");
        }
    }
}
