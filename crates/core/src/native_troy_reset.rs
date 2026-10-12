//! Whole native93E6F0 reset. Audio endpoints and GPU destruction remain adapters.
use crate::native_complex_particle_storage::{Storage,ClearState,TrailBackend};
#[derive(Debug,Clone,PartialEq,Eq)]
pub struct ResetState {pub handles:[u32;2],pub times:[u32;3],pub reset_b8:u32,pub position:[u32;3],pub previous_position:[u32;3],pub flags_1dd:u8,pub field_ec:u32}
#[derive(Debug,Clone)]
pub struct ComplexChild {pub flag:u8,pub times:[u32;2],pub counters:[u32;2],pub last_update:u32,pub storage:Storage,pub storage_frame:ClearState,pub death_emitters_enabled:bool}
#[derive(Debug,Clone,PartialEq,Eq)]
pub struct SimpleChild {pub flag:u8,pub times:[u32;2],pub resource:u32}
pub trait Backend:TrailBackend {fn audio_release(&mut self,key:u32);}
#[derive(Debug,Copy,Clone)]
pub struct PauseFilter {pub source_flags:u32,pub config_flags:u32}
impl PauseFilter {fn clears(self)->bool {self.source_flags&2==0 && self.config_flags&1==0}}
pub trait PauseBackend:Backend {fn audio_pause(&mut self,key:u32,paused:u32);}
/// Whole93EF80: filtered clear, then audio pause, optional release, bit7 clear.
pub fn pause(state:&mut ResetState,flags_1dc:&mut u8,audio_config:u32,complex:&mut [ComplexChild],complex_filters:&[PauseFilter],simple:&mut [SimpleChild],simple_filters:&[PauseFilter],pending:&mut Vec<u32>,backend:&mut impl PauseBackend)->Result<(),&'static str> {
    if complex.len()!=complex_filters.len() || simple.len()!=simple_filters.len() {return Err("pause filter count mismatch");}
    for (child,filter) in complex.iter().zip(complex_filters) {
        if !filter.clears() {continue;}
        if child.death_emitters_enabled {return Err("pause with death emitters is not qualified");}
        if let Some(first)=child.storage.particles.first() {if child.storage.particles.iter().any(|r|r.trail_slots.len()!=first.trail_slots.len()) {return Err("inconsistent particle trail slot count");}}
    }
    for (child,filter) in complex.iter_mut().zip(complex_filters) {
        if !filter.clears() {continue;}
        child.flag=0;child.times=[0;2];child.counters=[0;2];child.last_update=0xff7fffff;child.storage_frame=child.storage.clear_native(false,backend)?;
    }
    for (child,filter) in simple.iter_mut().zip(simple_filters) {
        if !filter.clears() {continue;}
        child.flag=0;child.times=[0;2];if child.resource!=0 {pending.push(child.resource);child.resource=0;}
    }
    for handle in state.handles {if handle!=u32::MAX {backend.audio_pause(handle,1);}}
    if audio_config&0x20==0 {for handle in &mut state.handles {if *handle!=u32::MAX {backend.audio_release(*handle);*handle=u32::MAX;}}}
    *flags_1dc&=0x7f;Ok(())
}
/// Native caller locals: BH marks prewarm and the frame-local time preserves raw bits.
#[derive(Debug,Copy,Clone,PartialEq,Eq)]
pub struct FrameControl {pub ebx:u32,pub local_time:u32}
/// Original9408E8..940938. Request flags remain set until final copyback.
/// Callback receives x87-copied arguments; prewarm comparison uses raw rewind.
pub fn reset_request(requests:u32,time:u32,rewind:u32,control:&mut FrameControl,mut invoke:impl FnMut(u32,u32)->Result<(),&'static str>)->Result<(),&'static str> {
    if requests&0x200==0 {return Ok(());}
    invoke(x87_copy(time),x87_copy(rewind))?;
    if f32::from_bits(rewind)>f32::from_bits(0x3dcccccd) {
        control.ebx=(control.ebx&!0xff00)|0x100;control.local_time=time;
    }
    Ok(())
}
fn x87_copy(v:u32)->u32 {if v&0x7f800000==0x7f800000 && v&0x007fffff!=0 {v|0x00400000} else {v}}
fn subtract(a:u32,b:u32)->u32 {
    if f32::from_bits(a).is_nan() {return a|0x00400000;}
    if f32::from_bits(b).is_nan() {return b|0x00400000;}
    let v=f32::from_bits(a)-f32::from_bits(b);if v.is_nan() {0xffc00000} else {v.to_bits()}
}
pub fn reset(time:u32,rewind:u32,state:&mut ResetState,complex:&mut [ComplexChild],simple:&mut [SimpleChild],pending:&mut Vec<u32>,backend:&mut impl Backend)->Result<(),&'static str> {
    for child in complex.iter() {
        if child.death_emitters_enabled {return Err("reset with death emitters is not qualified");}
        if let Some(first)=child.storage.particles.first() {
            if child.storage.particles.iter().any(|r|r.trail_slots.len()!=first.trail_slots.len()) {return Err("inconsistent particle trail slot count");}
        }
    }
    for handle in &mut state.handles {if *handle!=u32::MAX {backend.audio_release(*handle);*handle=u32::MAX;}}
    let t=subtract(time,rewind);state.times=[t;3];state.reset_b8=1;
    state.previous_position=state.position.map(x87_copy);state.flags_1dd&=0xfe;state.field_ec=0;
    for child in complex {
        child.flag=0;child.last_update=0xff7fffff;child.times=[t;2];child.counters=[0;2];
        child.storage_frame=child.storage.clear_native(false,backend)?;
    }
    for child in simple {child.flag=0;child.times=[t;2];if child.resource!=0 {pending.push(child.resource);child.resource=0;}}
    Ok(())
}
#[cfg(test)]
mod tests {
    use super::*;
    use crate::native_complex_particle_storage::Record;
    use crate::native_complex_trail_resources::{TroyTrailResources,Resource,State};
    use serde_json::{Value,json};
    #[derive(Default)]
    struct Adapter {trails:TroyTrailResources,events:Vec<Value>}
    impl Adapter {fn capture(&mut self,start:usize){self.events.extend(self.trails.events[start..].iter().map(|e|serde_json::to_value(e).unwrap()));}}
    impl TrailBackend for Adapter {
        fn release_particle_trail(&mut self,s:[u32;2]){let n=self.trails.events.len();self.trails.release_particle_trail(s);self.capture(n);}
        fn set_particle_index(&mut self,s:[u32;2],i:usize){let n=self.trails.events.len();self.trails.set_particle_index(s,i);self.capture(n);}
        fn drop_slot(&mut self,s:[u32;2]){let n=self.trails.events.len();self.trails.drop_slot(s);self.capture(n);}
    }
    impl Backend for Adapter {fn audio_release(&mut self,key:u32){self.events.push(json!({"event":"audio_release","key":key}));}}
    impl PauseBackend for Adapter {fn audio_pause(&mut self,key:u32,paused:u32){self.events.push(json!({"event":"audio_pause","key":key,"paused":paused}));}}
    fn bits(v:&Value)->u32 {u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    fn words<const N:usize>(v:&Value)->[u32;N] {std::array::from_fn(|i|bits(&v[i]))}
    fn nums<const N:usize>(v:&Value)->[u32;N] {std::array::from_fn(|i|v[i].as_u64().unwrap() as u32)}
    #[test]
    fn request_reset_arguments_and_prewarm_branch_match363_native_cases() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/troy_reset_caller_contract.json")).unwrap();assert_eq!(p["cases"].as_array().unwrap().len(),363);assert_eq!(bits(&p["threshold"]),0x3dcccccd);
        for (i,row) in p["cases"].as_array().unwrap().iter().enumerate() {
            let mut control=FrameControl {ebx:0xa5b6c7d8,local_time:0x12345678};let mut events=vec![];
            reset_request(row["requests"].as_u64().unwrap() as u32,bits(&row["time"]),bits(&row["rewind"]),&mut control,|time,rewind|{events.push(json!({"event":"reset","target":p["target"],"time":format!("0x{time:x}"),"rewind":format!("0x{rewind:x}")}));Ok(())}).unwrap();
            assert_eq!(control,FrameControl {ebx:bits(&row["cpu"]["ebx"]),local_time:bits(&row["cpu"]["local_time"])},"case{i}");assert_eq!(events,row["cpu"]["events"].as_array().unwrap().clone(),"case{i}");assert_eq!(row["requests"],row["cpu"]["requests"]);
        }
    }
    #[test]
    fn unsupported_death_emitter_rejects_before_audio_or_state_mutation() {
        let mut state=ResetState {handles:[7,8],times:[9;3],reset_b8:10,position:[11;3],previous_position:[12;3],flags_1dd:255,field_ec:13};let before=state.clone();
        let make=|enabled|ComplexChild {flag:7,times:[8;2],counters:[9;2],last_update:10,storage:Storage::default(),storage_frame:ClearState {last_update_bits:11,live_count:0},death_emitters_enabled:enabled};
        let mut complex=[make(false),make(true)];let mut simple=[SimpleChild {flag:7,times:[8;2],resource:9}];let mut pending=vec![42];let mut backend=Adapter::default();
        assert!(reset(0,0,&mut state,&mut complex,&mut simple,&mut pending,&mut backend).is_err());assert_eq!(state,before);assert!(backend.events.is_empty());assert_eq!(pending,vec![42]);assert_eq!(complex[0].flag,7);assert_eq!(simple[0].resource,9);
    }
    fn record(buffers:&Value,index:usize,slots:usize)->Record {
        let at=|off|&buffers.as_array().unwrap().iter().find(|b|bits(&b["offset"])==off).unwrap()["records"][index];
        let trails=&buffers.as_array().unwrap().iter().find(|b|bits(&b["offset"])==0x94).unwrap()["records"];
        Record {life:words(at(4)),motion:words(at(0x10)),surface:words(at(0x1c)),color:words(at(0x28)),scale:words(at(0x34)),uv:words(at(0x40)),atlas:words(at(0x4c)),field_58:words(at(0x58)),field_64:words(at(0x64)),field_70:words(at(0x70)),field_7c:words(at(0x7c)),field_88:words(at(0x88)),trail_slots:(index*slots..(index+1)*slots).map(|i|words(&trails[i])).collect()}
    }
    #[test]
    fn reset_matches432_native_cpu_cases_and_complete_trail_graph() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/troy_reset_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),432);
        assert_eq!(proof["actual_cpu_sse_operations"],432);assert_eq!(proof["actual_cpu_x87_copies"],1296);
        for (i,row) in proof["cases"].as_array().unwrap().iter().enumerate() {
            let b=&row["before"];let e=&row["cpu"];
            let mut state=ResetState {handles:nums(&b["handles"]),times:words(&b["times"]),reset_b8:b["reset_b8"].as_u64().unwrap() as u32,position:words(&row["position"]),previous_position:words(&b["previous_position"]),flags_1dd:b["flags_1dd"].as_u64().unwrap() as u8,field_ec:b["field_ec"].as_u64().unwrap() as u32};
            let slots=row["trail_slots"].as_u64().unwrap() as usize;
            let mut complex:Vec<_>=b["complex"].as_array().unwrap().iter().map(|c|ComplexChild {flag:c["flag"].as_u64().unwrap() as u8,times:words(&c["times"]),counters:nums(&c["counters"]),last_update:bits(&c["last_update"]),storage:Storage {particles:(0..c["live_count"].as_u64().unwrap() as usize).map(|n|record(&c["buffers"],n,slots)).collect()},storage_frame:ClearState {last_update_bits:bits(&c["storage_last_update"]),live_count:c["live_count"].as_u64().unwrap() as u32},death_emitters_enabled:false}).collect();
            let mut simple:Vec<_>=b["simple"].as_array().unwrap().iter().map(|c|SimpleChild {flag:c["flag"].as_u64().unwrap() as u8,times:words(&c["times"]),resource:c["resource"].as_u64().unwrap() as u32}).collect();
            let mut pending:Vec<_>=b["pending"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect();let mut backend=Adapter::default();
            for r in row["resources"].as_array().unwrap() {
                let n=|k:&str|r[k].as_u64().unwrap() as u32;let alive=r["alive"].as_bool().unwrap();let sa=r["state_alive"].as_bool().unwrap();
                backend.trails.resources.insert(n("control"),Resource {object:n("object"),id:n("id"),strong:u32::from(alive),weak:if alive {2}else{1},state:[n("state"),n("state_control")],requests:n("initial_flags")});
                backend.trails.states.insert(n("state_control"),State {object:n("state"),strong:u32::from(sa),weak:if sa {2}else{1},owner_index:n("initial_owner"),dead:0});
            }
            reset(bits(&row["time"]),bits(&row["rewind"]),&mut state,&mut complex,&mut simple,&mut pending,&mut backend).unwrap();
            assert_eq!(state,ResetState {handles:nums(&e["handles"]),times:words(&e["times"]),reset_b8:e["reset_b8"].as_u64().unwrap() as u32,position:words(&row["position"]),previous_position:words(&e["previous_position"]),flags_1dd:e["flags_1dd"].as_u64().unwrap() as u8,field_ec:e["field_ec"].as_u64().unwrap() as u32},"case{i}");
            assert_eq!(serde_json::to_value(pending).unwrap(),e["pending"],"case{i}");assert_eq!(backend.events,e["events"].as_array().unwrap().clone(),"case{i}");
            for (c,expected) in complex.iter().zip(e["complex"].as_array().unwrap()) {
                assert_eq!(c.flag,expected["flag"].as_u64().unwrap() as u8);assert_eq!(c.times,words::<2>(&expected["times"]));assert_eq!(c.counters,nums::<2>(&expected["counters"]));assert_eq!(c.last_update,bits(&expected["last_update"]));assert_eq!(c.storage_frame.last_update_bits,bits(&expected["storage_last_update"]));assert_eq!(c.storage_frame.live_count,expected["live_count"].as_u64().unwrap() as u32);
                for buffer in expected["buffers"].as_array().unwrap() {let actual:Vec<_>=c.storage.particles.iter().flat_map(|r|r.native_words(bits(&buffer["offset"]) as usize).unwrap()).collect();assert!(actual.is_empty());assert!(buffer["records"].as_array().unwrap().is_empty());}
            }
            for (c,expected) in simple.iter().zip(e["simple"].as_array().unwrap()) {assert_eq!(c,&SimpleChild {flag:expected["flag"].as_u64().unwrap() as u8,times:words(&expected["times"]),resource:expected["resource"].as_u64().unwrap() as u32});}
            for r in row["resources"].as_array().unwrap() {let n=|k:&str|r[k].as_u64().unwrap() as u32;let resource=&backend.trails.resources[&n("control")];let s=&backend.trails.states[&n("state_control")];for (k,v) in [("resource_strong",resource.strong),("resource_weak",resource.weak),("state_strong",s.strong),("state_weak",s.weak),("final_flags",resource.requests),("final_owner",s.owner_index),("final_dead",u32::from(s.dead))] {assert_eq!(v,n(k),"case{i} {k}");}}
        }
    }
    #[test]
    fn pause_matches432_native_cases_filters_audio_and_trail_graph() {
        let proof:Value=serde_json::from_str({
            static FIXTURE: std::sync::OnceLock<String> = std::sync::OnceLock::new();
            FIXTURE.get_or_init(|| {
                const PATH: &str = concat!(env!("CARGO_MANIFEST_DIR"), "/../../data/4.20/troy_pause_contract.json");
                let text = std::fs::read_to_string(PATH)
                    .unwrap_or_else(|error| panic!("cannot read frozen test fixture {PATH}: {error}"));
                assert_eq!(text.len(), 13180081, "frozen test fixture byte length: {PATH}");
                text
            }).as_str()
        }).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),432);
        assert_eq!(proof["actual_cpu_sse_operations"],0);assert_eq!(proof["actual_cpu_x87_copies"],0);
        for (i,row) in proof["cases"].as_array().unwrap().iter().enumerate() {
            let b=&row["before"];let e=&row["cpu"];
            let mut state=ResetState {handles:nums(&b["handles"]),times:words(&b["times"]),reset_b8:b["reset_b8"].as_u64().unwrap() as u32,position:words(&row["position"]),previous_position:words(&b["previous_position"]),flags_1dd:b["flags_1dd"].as_u64().unwrap() as u8,field_ec:b["field_ec"].as_u64().unwrap() as u32};
            let slots=row["trail_slots"].as_u64().unwrap() as usize;
            let mut complex:Vec<_>=b["complex"].as_array().unwrap().iter().map(|c|ComplexChild {flag:c["flag"].as_u64().unwrap() as u8,times:words(&c["times"]),counters:nums(&c["counters"]),last_update:bits(&c["last_update"]),storage:Storage {particles:(0..c["live_count"].as_u64().unwrap() as usize).map(|n|record(&c["buffers"],n,slots)).collect()},storage_frame:ClearState {last_update_bits:bits(&c["storage_last_update"]),live_count:c["live_count"].as_u64().unwrap() as u32},death_emitters_enabled:false}).collect();
            let mut simple:Vec<_>=b["simple"].as_array().unwrap().iter().map(|c|SimpleChild {flag:c["flag"].as_u64().unwrap() as u8,times:words(&c["times"]),resource:c["resource"].as_u64().unwrap() as u32}).collect();
            let mut pending:Vec<_>=b["pending"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect();let mut backend=Adapter::default();
            for r in row["resources"].as_array().unwrap() {
                let n=|k:&str|r[k].as_u64().unwrap() as u32;let alive=r["alive"].as_bool().unwrap();let sa=r["state_alive"].as_bool().unwrap();
                backend.trails.resources.insert(n("control"),Resource {object:n("object"),id:n("id"),strong:u32::from(alive),weak:if alive {2}else{1},state:[n("state"),n("state_control")],requests:n("initial_flags")});
                backend.trails.states.insert(n("state_control"),State {object:n("state"),strong:u32::from(sa),weak:if sa {2}else{1},owner_index:n("initial_owner"),dead:0});
            }
            let filters=|name:&str|row[name].as_array().unwrap().iter().map(|f|PauseFilter {source_flags:f["source_flags"].as_u64().unwrap() as u32,config_flags:f["config_flags"].as_u64().unwrap() as u32}).collect::<Vec<_>>();let mut flags=b["flags_1dc"].as_u64().unwrap() as u8;
            pause(&mut state,&mut flags,row["audio_config_flags"].as_u64().unwrap() as u32,&mut complex,&filters("complex_filters"),&mut simple,&filters("simple_filters"),&mut pending,&mut backend).unwrap();assert_eq!(flags,e["flags_1dc"].as_u64().unwrap() as u8);
            assert_eq!(state,ResetState {handles:nums(&e["handles"]),times:words(&e["times"]),reset_b8:e["reset_b8"].as_u64().unwrap() as u32,position:words(&row["position"]),previous_position:words(&e["previous_position"]),flags_1dd:e["flags_1dd"].as_u64().unwrap() as u8,field_ec:e["field_ec"].as_u64().unwrap() as u32},"case{i}");
            assert_eq!(serde_json::to_value(pending).unwrap(),e["pending"],"case{i}");assert_eq!(backend.events,e["events"].as_array().unwrap().clone(),"case{i}");
            for (c,expected) in complex.iter().zip(e["complex"].as_array().unwrap()) {
                assert_eq!(c.flag,expected["flag"].as_u64().unwrap() as u8);assert_eq!(c.times,words::<2>(&expected["times"]));assert_eq!(c.counters,nums::<2>(&expected["counters"]));assert_eq!(c.last_update,bits(&expected["last_update"]));assert_eq!(c.storage_frame.last_update_bits,bits(&expected["storage_last_update"]));assert_eq!(c.storage_frame.live_count,expected["live_count"].as_u64().unwrap() as u32);
                for buffer in expected["buffers"].as_array().unwrap() {let actual:Vec<_>=c.storage.particles.iter().flat_map(|r|r.native_words(bits(&buffer["offset"]) as usize).unwrap()).collect();let expected:Vec<_>=buffer["records"].as_array().unwrap().iter().flat_map(|r|r.as_array().unwrap().iter().map(bits)).collect();assert_eq!(actual,expected,"case{i} buffer{}",buffer["offset"]);}
            }
            for (c,expected) in simple.iter().zip(e["simple"].as_array().unwrap()) {assert_eq!(c,&SimpleChild {flag:expected["flag"].as_u64().unwrap() as u8,times:words(&expected["times"]),resource:expected["resource"].as_u64().unwrap() as u32});}
            for r in row["resources"].as_array().unwrap() {let n=|k:&str|r[k].as_u64().unwrap() as u32;let resource=&backend.trails.resources[&n("control")];let s=&backend.trails.states[&n("state_control")];for (k,v) in [("resource_strong",resource.strong),("resource_weak",resource.weak),("state_strong",s.strong),("state_weak",s.weak),("final_flags",resource.requests),("final_owner",s.owner_index),("final_dead",u32::from(s.dead))] {assert_eq!(v,n(k),"case{i} {k}");}}
        }
    }
}