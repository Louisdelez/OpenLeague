//! Composes 93F2F0 phases. Concrete producers, profiler and client binding remain separate.
use crate::{native_troy_frame_gate as gate,native_troy_frame_timing as timing,native_troy_substeps as steps,native_troy_resume as audio,native_troy_reset as reset,native_troy_oneshot as oneshot,native_troy_frame_finish as tail,native_troy_scratch::Scratch};
pub struct State {pub audio:audio::State,pub motion:steps::State,pub clock:u32,pub counter:u32}
pub struct Input {pub gate:gate::Input,pub rate:u32,pub emit:bool,pub one_shot_descriptors:[[u8;24];2],pub bounds_coefficient:u32}
pub trait Backend:gate::Backend+steps::Backend+oneshot::Backend {
    fn audio_position(&mut self,key:u32,position:[u32;3]);
    /// Commit owned child storage after the gate, before any child update.
    fn commit_simple_gate(&mut self,_:&[reset::SimpleChild],_:&[u32])->Result<(),&'static str>{Ok(())}
}
pub fn update(state:&mut State,input:&Input,scratch:&Scratch,complex:&mut [reset::ComplexChild],complex_filters:&[reset::PauseFilter],simple:&mut [reset::SimpleChild],simple_filters:&[reset::PauseFilter],pending:&mut Vec<u32>,complex_done:&mut [u8],simple_done:&mut [u8],backend:&mut impl Backend)->Result<gate::Decision,&'static str> {
    if complex.len()!=complex_done.len() || simple.len()!=simple_done.len() {return Err("child completion arrays do not match frame children");}
    state.audio.position=state.motion.position;
    let decision=gate::update(&input.gate,&mut state.clock,&mut state.audio,scratch,complex,complex_filters,simple,simple_filters,pending,backend)?;
    backend.commit_simple_gate(simple,pending)?;
    state.motion.flags=state.audio.flags_1dc;
    if decision.path==gate::Path::Continue {
        let calculated=timing::calculate(timing::Input {time:input.gate.time,last:state.motion.last,offset:state.audio.field_ec,cap:input.gate.delay,rate:input.rate,flags:input.gate.config_flags,source_flags:input.gate.source_flags},||steps::Backend::status(backend));
        state.audio.field_ec=calculated.offset;
        steps::run(&mut state.motion,calculated.iterations,calculated.step,input.bounds_coefficient,complex_done,simple_done,backend)?;
        state.audio.flags_1dc=state.motion.flags;state.audio.position=state.motion.position;
        for key in state.audio.handles {if key!=u32::MAX {backend.audio_position(key,state.motion.position);}}
    }
    let mut finish_state=tail::State {last_input_time:state.audio.times[1],flags:state.audio.flags_1dc,counter:state.counter};
    oneshot::finish(&mut finish_state,&tail::Input {time:input.gate.time,visible:u8::from(decision.visible),emit:input.emit,stopped:decision.path==gate::Path::Stop,one_shot_descriptors_enabled:[false;2]},input.gate.start,input.one_shot_descriptors,state.motion.position,input.gate.owner_present,backend);
    state.audio.times[1]=finish_state.last_input_time;state.audio.flags_1dc=finish_state.flags;state.motion.flags=finish_state.flags;state.counter=finish_state.counter;
    Ok(decision)
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::{Value,json};use crate::native_complex_particle_storage::TrailBackend;
    struct Adapter {events:Vec<Value>,done:u8,trails:crate::native_complex_trail_resources::TroyTrailResources}
    impl Adapter {
        fn child_event(&mut self,event:&str,index:usize,time:u32,last:Option<bool>,state:&steps::State)->u8 {
            self.events.push(json!({"event":event,"id":index+1,"time":format!("0x{time:x}"),"last_step":last.map(u8::from),"position":state.position.map(|v|format!("0x{v:x}")),"minimum":state.minimum.map(|v|format!("0x{v:x}")),"maximum":state.maximum.map(|v|format!("0x{v:x}"))}));self.done
        }
    }
    impl audio::Backend for Adapter {
        fn owner_eligible(&mut self)->u8{panic!("disabled descriptors")}
        fn owner_id(&mut self)->u32{panic!("disabled descriptors")}
        fn create_primary(&mut self,_:&[u8;24],_:[u32;3],_:u32)->u32{panic!("disabled descriptors")}
        fn create_secondary(&mut self,_:&[u8;24],_:u32,_:[u32;3],_:u32)->u32{panic!("disabled descriptors")}
        fn audio_pause(&mut self,key:u32,paused:u32){self.events.push(json!({"event":"audio_pause","key":key,"paused":paused}));}
    }
    impl TrailBackend for Adapter {
        fn release_particle_trail(&mut self,slot:[u32;2]){let start=self.trails.events.len();self.trails.release_particle_trail(slot);self.events.extend(self.trails.events[start..].iter().map(|e|serde_json::to_value(e).unwrap()));}
        fn set_particle_index(&mut self,slot:[u32;2],index:usize){let start=self.trails.events.len();self.trails.set_particle_index(slot,index);self.events.extend(self.trails.events[start..].iter().map(|e|serde_json::to_value(e).unwrap()));}
        fn drop_slot(&mut self,slot:[u32;2]){let start=self.trails.events.len();self.trails.drop_slot(slot);self.events.extend(self.trails.events[start..].iter().map(|e|serde_json::to_value(e).unwrap()));}
    }
    impl reset::Backend for Adapter {fn audio_release(&mut self,key:u32){self.events.push(json!({"event":"audio_release","key":key}));}}
    impl reset::PauseBackend for Adapter {fn audio_pause(&mut self,key:u32,paused:u32){audio::Backend::audio_pause(self,key,paused)}}
    impl gate::Backend for Adapter {fn root_clock(&mut self)->u32{self.events.push(json!("clock"));99}}
    impl steps::Backend for Adapter {
        fn status(&mut self)->u8{self.events.push(json!("engine_status"));0}
        fn complex_update(&mut self,i:usize,t:u32,s:&steps::State)->u8{self.child_event("complex_update",i,t,None,s)}
        fn simple_update(&mut self,i:usize,t:u32,last:bool,s:&steps::State)->u8{self.child_event("simple_update",i,t,Some(last),s)}
    }
    impl oneshot::Backend for Adapter {
        fn owner_eligible(&mut self)->u8{panic!("disabled descriptors")}
        fn owner_id(&mut self)->u32{panic!("disabled descriptors")}
        fn play_primary(&mut self,_:&[u8;24],_:[u32;3],_:u32){panic!("disabled descriptors")}
        fn play_secondary(&mut self,_:&[u8;24],_:u32,_:[u32;3],_:u32){panic!("disabled descriptors")}
    }
    impl Backend for Adapter {fn audio_position(&mut self,key:u32,position:[u32;3]){self.events.push(json!({"event":"audio_position","key":key,"position":position.map(|v|format!("0x{v:x}"))}));}}
    fn bits(v:&Value)->u32{u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    fn words<const N:usize>(v:&Value)->[u32;N]{std::array::from_fn(|i|bits(&v[i]))}
    #[test]
    fn composed_frame_matches2560_whole_native_empty_child_captures() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/troy_frame_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),2560);
        for (i,row) in rows.iter().enumerate() {
            let flags=row["flags"].as_u64().unwrap() as u8;
            let mut s=State {audio:audio::State {handles:std::array::from_fn(|n|row["initial_handles"][n].as_u64().unwrap() as u32),descriptors:[[0;24];2],times:[bits(&row["start"]),0x3e800000],position:[0x40000000,0x40800000,0x40c00000],flags_1dc:flags,flags_1dd:row["initial_flags_1dd"].as_u64().unwrap() as u8,field_ec:0x3e800000,global_last_primary:0},motion:steps::State {previous:[0x3f800000,0x40000000,0x40400000],position:[0x40000000,0x40800000,0x40c00000],direction:[0x3f800000,0,0],minimum:[0;3],maximum:[0;3],last:0x3f400000,flags,metrics:[0x7fa01234;2]},clock:0,counter:u32::MAX};
            let mut scratch=Scratch::default();if !row["visible"].as_bool().unwrap(){scratch.words[0x78/4]=0xbf800000;}
            let mut b=Adapter {events:vec![],trails:Default::default(),done:0};
            update(&mut s,&Input {gate:gate::Input {time:bits(&row["time"]),start:bits(&row["start"]),lifetime:bits(&row["lifetime"]),delay:0x3f000000,source_flags:row["source_flags"].as_u64().unwrap() as u32,config_flags:row["config_flags"].as_u64().unwrap() as u32,owner_present:false,bounds:[0;6]},rate:0x41200000,emit:row["emit"].as_bool().unwrap(),one_shot_descriptors:[[0;24];2],bounds_coefficient:0x40000000},&scratch,&mut [],&[],&mut [],&[],&mut vec![],&mut [],&mut [],&mut b).unwrap();
            let e=&row["cpu"];
            assert_eq!(s.audio.flags_1dc,e["flags"].as_u64().unwrap() as u8,"flags case{i}");assert_eq!(s.audio.flags_1dd,e["flags_1dd"].as_u64().unwrap() as u8,"flagsdd case{i}");assert_eq!(s.audio.field_ec,bits(&e["offset"]),"offset case{i}");assert_eq!(s.motion.last,bits(&e["last"]),"last case{i}");assert_eq!(s.audio.times[1],bits(&e["time"]),"time case{i}");
            assert_eq!(s.motion.previous,words::<3>(&e["previous"]),"prev case{i}");assert_eq!(s.motion.position,words::<3>(&e["position"]),"pos case{i}");assert_eq!(s.motion.minimum,words::<3>(&e["minimum"]),"min case{i}");assert_eq!(s.motion.maximum,words::<3>(&e["maximum"]),"max case{i}");assert_eq!(s.motion.metrics,words::<2>(&e["metrics"]),"metrics case{i}");assert_eq!(s.counter,e["counter"].as_u64().unwrap() as u32,"counter case{i}");assert_eq!(s.clock,e["clock"].as_u64().unwrap() as u32,"clock case{i}");assert_eq!(s.audio.handles,std::array::from_fn(|n|e["handles"][n].as_u64().unwrap() as u32),"handles case{i}");assert_eq!(b.events,e["events"].as_array().unwrap().clone(),"events case{i}");
        }
    }
    #[test]
    fn composed_frame_matches1296_native_filtered_child_captures() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/troy_frame_children_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),1296);
        for (i,row) in rows.iter().enumerate() {
            let flags=row["flags"].as_u64().unwrap() as u8;
            let mut s=State {audio:audio::State {handles:std::array::from_fn(|n|row["initial_handles"][n].as_u64().unwrap() as u32),descriptors:[[0;24];2],times:[bits(&row["start"]),0x3e800000],position:[0x40000000,0x40800000,0x40c00000],flags_1dc:flags,flags_1dd:row["initial_flags_1dd"].as_u64().unwrap() as u8,field_ec:0x3e800000,global_last_primary:0},motion:steps::State {previous:[0x3f800000,0x40000000,0x40400000],position:[0x40000000,0x40800000,0x40c00000],direction:[0x3f800000,0,0],minimum:[0;3],maximum:[0;3],last:0x3f400000,flags,metrics:[0x7fa01234;2]},clock:0,counter:u32::MAX};
            let mut scratch=Scratch::default();if !row["visible"].as_bool().unwrap(){scratch.words[0x78/4]=0xbf800000;}
            let mut b=Adapter {events:vec![],trails:Default::default(),done:row["done_marker"].as_u64().unwrap() as u8};
            let cn=row["complex_count"].as_u64().unwrap() as usize;let sn=row["simple_count"].as_u64().unwrap() as usize;
            let mut complex=(0..cn).map(|_|reset::ComplexChild {flag:0,times:[0;2],counters:[0;2],last_update:0,storage:crate::native_complex_particle_storage::Storage::default(),storage_frame:crate::native_complex_particle_storage::ClearState {last_update_bits:0,live_count:0},death_emitters_enabled:false}).collect::<Vec<_>>();
            let mut simple=vec![reset::SimpleChild {flag:0,times:[0;2],resource:0};sn];let mut complex_done=vec![0;cn];let mut simple_done=vec![0;sn];let filter=reset::PauseFilter {source_flags:2,config_flags:0};
            update(&mut s,&Input {gate:gate::Input {time:bits(&row["time"]),start:bits(&row["start"]),lifetime:bits(&row["lifetime"]),delay:0x3f000000,source_flags:row["source_flags"].as_u64().unwrap() as u32,config_flags:row["config_flags"].as_u64().unwrap() as u32,owner_present:false,bounds:[0;6]},rate:0x41200000,emit:row["emit"].as_bool().unwrap(),one_shot_descriptors:[[0;24];2],bounds_coefficient:0x40000000},&scratch,&mut complex,&vec![filter;cn],&mut simple,&vec![filter;sn],&mut vec![],&mut complex_done,&mut simple_done,&mut b).unwrap();
            let e=&row["cpu"];
            assert_eq!(complex_done,e["complex_done"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<_>>(),"complex done case{i}");
            assert_eq!(simple_done,e["simple_done"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<_>>(),"simple done case{i}");
            assert_eq!(s.audio.flags_1dc,e["flags"].as_u64().unwrap() as u8,"flags case{i}");assert_eq!(s.audio.flags_1dd,e["flags_1dd"].as_u64().unwrap() as u8,"flagsdd case{i}");assert_eq!(s.audio.field_ec,bits(&e["offset"]),"offset case{i}");assert_eq!(s.motion.last,bits(&e["last"]),"last case{i}");assert_eq!(s.audio.times[1],bits(&e["time"]),"time case{i}");
            assert_eq!(s.motion.previous,words::<3>(&e["previous"]),"prev case{i}");assert_eq!(s.motion.position,words::<3>(&e["position"]),"pos case{i}");assert_eq!(s.motion.minimum,words::<3>(&e["minimum"]),"min case{i}");assert_eq!(s.motion.maximum,words::<3>(&e["maximum"]),"max case{i}");assert_eq!(s.motion.metrics,words::<2>(&e["metrics"]),"metrics case{i}");assert_eq!(s.counter,e["counter"].as_u64().unwrap() as u32,"counter case{i}");assert_eq!(s.clock,e["clock"].as_u64().unwrap() as u32,"clock case{i}");assert_eq!(s.audio.handles,std::array::from_fn(|n|e["handles"][n].as_u64().unwrap() as u32),"handles case{i}");assert_eq!(b.events,e["events"].as_array().unwrap().clone(),"events case{i}");
        }
    }
    #[test]
    fn composed_frame_matches5184_native_clear_and_preserve_child_captures() {
        let proof:Value=serde_json::from_str({
            static FIXTURE: std::sync::OnceLock<String> = std::sync::OnceLock::new();
            FIXTURE.get_or_init(|| {
                const PATH: &str = concat!(env!("CARGO_MANIFEST_DIR"), "/../../data/4.20/troy_frame_clear_contract.json");
                let text = std::fs::read_to_string(PATH)
                    .unwrap_or_else(|error| panic!("cannot read frozen test fixture {PATH}: {error}"));
                assert_eq!(text.len(), 58282345, "frozen test fixture byte length: {PATH}");
                text
            }).as_str()
        }).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),5184);
        for (i,row) in rows.iter().enumerate() {
            let flags=row["flags"].as_u64().unwrap() as u8;
            let mut s=State {audio:audio::State {handles:std::array::from_fn(|n|row["initial_handles"][n].as_u64().unwrap() as u32),descriptors:[[0;24];2],times:[bits(&row["start"]),0x3e800000],position:[0x40000000,0x40800000,0x40c00000],flags_1dc:flags,flags_1dd:row["initial_flags_1dd"].as_u64().unwrap() as u8,field_ec:0x3e800000,global_last_primary:0},motion:steps::State {previous:[0x3f800000,0x40000000,0x40400000],position:[0x40000000,0x40800000,0x40c00000],direction:[0x3f800000,0,0],minimum:[0;3],maximum:[0;3],last:0x3f400000,flags,metrics:[0x7fa01234;2]},clock:0,counter:u32::MAX};
            let mut scratch=Scratch::default();if !row["visible"].as_bool().unwrap(){scratch.words[0x78/4]=0xbf800000;}
            let mut b=Adapter {events:vec![],trails:Default::default(),done:row["done_marker"].as_u64().unwrap() as u8};
            let cn=row["complex_count"].as_u64().unwrap() as usize;let sn=row["simple_count"].as_u64().unwrap() as usize;
            let mut complex=(0..cn).map(|_|reset::ComplexChild {flag:7,times:[8;2],counters:[9;2],last_update:10,storage:crate::native_complex_particle_storage::Storage::default(),storage_frame:crate::native_complex_particle_storage::ClearState {last_update_bits:11,live_count:0},death_emitters_enabled:false}).collect::<Vec<_>>();
            let mut simple=(0..sn).map(|i|reset::SimpleChild {flag:7,times:[8;2],resource:1000+i as u32}).collect::<Vec<_>>();let mut complex_done=vec![0;cn];let mut simple_done=vec![0;sn];let filters=row["filters"].as_array().unwrap();let make_filter=|v:&Value|reset::PauseFilter {source_flags:v["source_flags"].as_u64().unwrap() as u32,config_flags:v["config_flags"].as_u64().unwrap() as u32};
            let complex_filters=filters.iter().filter(|v|!v["simple"].as_bool().unwrap()).map(make_filter).collect::<Vec<_>>();let simple_filters=filters.iter().filter(|v|v["simple"].as_bool().unwrap()).map(make_filter).collect::<Vec<_>>();let mut pending=vec![99];
            update(&mut s,&Input {gate:gate::Input {time:bits(&row["time"]),start:bits(&row["start"]),lifetime:bits(&row["lifetime"]),delay:0x3f000000,source_flags:row["source_flags"].as_u64().unwrap() as u32,config_flags:row["config_flags"].as_u64().unwrap() as u32,owner_present:false,bounds:[0;6]},rate:0x41200000,emit:row["emit"].as_bool().unwrap(),one_shot_descriptors:[[0;24];2],bounds_coefficient:0x40000000},&scratch,&mut complex,&complex_filters,&mut simple,&simple_filters,&mut pending,&mut complex_done,&mut simple_done,&mut b).unwrap();
            let e=&row["cpu"];
            assert_eq!(json!(complex.iter().map(|c|json!({"flag":c.flag,"times":c.times,"counters":c.counters,"last_update":c.last_update,"storage_last_update":c.storage_frame.last_update_bits,"storage_count":c.storage_frame.live_count})).collect::<Vec<_>>()),e["complex_state"],"complex state case{i}");
            assert_eq!(json!(simple.iter().map(|c|json!({"flag":c.flag,"times":c.times,"resource":c.resource})).collect::<Vec<_>>()),e["simple_state"],"simple state case{i}");assert_eq!(json!(pending),e["pending"],"queue case{i}");
            assert_eq!(complex_done,e["complex_done"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<_>>(),"complex done case{i}");
            assert_eq!(simple_done,e["simple_done"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<_>>(),"simple done case{i}");
            assert_eq!(s.audio.flags_1dc,e["flags"].as_u64().unwrap() as u8,"flags case{i}");assert_eq!(s.audio.flags_1dd,e["flags_1dd"].as_u64().unwrap() as u8,"flagsdd case{i}");assert_eq!(s.audio.field_ec,bits(&e["offset"]),"offset case{i}");assert_eq!(s.motion.last,bits(&e["last"]),"last case{i}");assert_eq!(s.audio.times[1],bits(&e["time"]),"time case{i}");
            assert_eq!(s.motion.previous,words::<3>(&e["previous"]),"prev case{i}");assert_eq!(s.motion.position,words::<3>(&e["position"]),"pos case{i}");assert_eq!(s.motion.minimum,words::<3>(&e["minimum"]),"min case{i}");assert_eq!(s.motion.maximum,words::<3>(&e["maximum"]),"max case{i}");assert_eq!(s.motion.metrics,words::<2>(&e["metrics"]),"metrics case{i}");assert_eq!(s.counter,e["counter"].as_u64().unwrap() as u32,"counter case{i}");assert_eq!(s.clock,e["clock"].as_u64().unwrap() as u32,"clock case{i}");assert_eq!(s.audio.handles,std::array::from_fn(|n|e["handles"][n].as_u64().unwrap() as u32),"handles case{i}");assert_eq!(b.events,e["events"].as_array().unwrap().clone(),"events case{i}");
        }
    }
    fn native_record(buffers:&Value,index:usize,slots:usize)->crate::native_complex_particle_storage::Record {
        let at=|off|&buffers.as_array().unwrap().iter().find(|b|bits(&b["offset"])==off).unwrap()["records"][index];
        let trails=&buffers.as_array().unwrap().iter().find(|b|bits(&b["offset"])==0x94).unwrap()["records"];
        crate::native_complex_particle_storage::Record {life:words(at(4)),motion:words(at(0x10)),surface:words(at(0x1c)),color:words(at(0x28)),scale:words(at(0x34)),uv:words(at(0x40)),atlas:words(at(0x4c)),field_58:words(at(0x58)),field_64:words(at(0x64)),field_70:words(at(0x70)),field_7c:words(at(0x7c)),field_88:words(at(0x88)),trail_slots:(index*slots..(index+1)*slots).map(|i|words(&trails[i])).collect()}
    }
    #[test]
    fn composed_frame_matches768_native_nonempty_trail_graph_captures() {
        let proof:Value=serde_json::from_str({
            static FIXTURE: std::sync::OnceLock<String> = std::sync::OnceLock::new();
            FIXTURE.get_or_init(|| {
                const PATH: &str = concat!(env!("CARGO_MANIFEST_DIR"), "/../../data/4.20/troy_frame_trails_contract.json");
                let text = std::fs::read_to_string(PATH)
                    .unwrap_or_else(|error| panic!("cannot read frozen test fixture {PATH}: {error}"));
                assert_eq!(text.len(), 43531248, "frozen test fixture byte length: {PATH}");
                text
            }).as_str()
        }).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),768);
        for (i,row) in rows.iter().enumerate() {
            let flags=row["flags"].as_u64().unwrap() as u8;
            let mut s=State {audio:audio::State {handles:std::array::from_fn(|n|row["initial_handles"][n].as_u64().unwrap() as u32),descriptors:[[0;24];2],times:[bits(&row["start"]),0x3e800000],position:[0x40000000,0x40800000,0x40c00000],flags_1dc:flags,flags_1dd:row["initial_flags_1dd"].as_u64().unwrap() as u8,field_ec:0x3e800000,global_last_primary:0},motion:steps::State {previous:[0x3f800000,0x40000000,0x40400000],position:[0x40000000,0x40800000,0x40c00000],direction:[0x3f800000,0,0],minimum:[0;3],maximum:[0;3],last:0x3f400000,flags,metrics:[0x7fa01234;2]},clock:0,counter:u32::MAX};
            let mut scratch=Scratch::default();if !row["visible"].as_bool().unwrap(){scratch.words[0x78/4]=0xbf800000;}
            let mut b=Adapter {events:vec![],trails:Default::default(),done:row["done_marker"].as_u64().unwrap() as u8};
            let cn=row["complex_count"].as_u64().unwrap() as usize;let sn=row["simple_count"].as_u64().unwrap() as usize;
            let mut complex=(0..cn).map(|child_index|reset::ComplexChild {flag:7,times:[8;2],counters:[9;2],last_update:10,storage:crate::native_complex_particle_storage::Storage {particles:(0..2).map(|n|native_record(&row["before_complex"][child_index],n,1)).collect()},storage_frame:crate::native_complex_particle_storage::ClearState {last_update_bits:11,live_count:2},death_emitters_enabled:false}).collect::<Vec<_>>();
            let mut simple=(0..sn).map(|i|reset::SimpleChild {flag:7,times:[8;2],resource:1000+i as u32}).collect::<Vec<_>>();let mut complex_done=vec![0;cn];let mut simple_done=vec![0;sn];let filters=row["filters"].as_array().unwrap();let make_filter=|v:&Value|reset::PauseFilter {source_flags:v["source_flags"].as_u64().unwrap() as u32,config_flags:v["config_flags"].as_u64().unwrap() as u32};
            let complex_filters=filters.iter().filter(|v|!v["simple"].as_bool().unwrap()).map(make_filter).collect::<Vec<_>>();let simple_filters=filters.iter().filter(|v|v["simple"].as_bool().unwrap()).map(make_filter).collect::<Vec<_>>();let mut pending=vec![99];
            for resource in row["resources_before"].as_array().unwrap() {
                let n=|k:&str|resource[k].as_u64().unwrap() as u32;let alive=resource["alive"].as_bool().unwrap();let sa=resource["state_alive"].as_bool().unwrap();
                b.trails.resources.insert(n("control"),crate::native_complex_trail_resources::Resource {object:n("object"),id:n("id"),strong:u32::from(alive),weak:if alive {2}else{1},state:[n("state"),n("state_control")],requests:0});
                b.trails.states.insert(n("state_control"),crate::native_complex_trail_resources::State {object:n("state"),strong:u32::from(sa),weak:if sa {2}else{1},owner_index:n("initial_owner"),dead:0});
            }
            update(&mut s,&Input {gate:gate::Input {time:bits(&row["time"]),start:bits(&row["start"]),lifetime:bits(&row["lifetime"]),delay:0x3f000000,source_flags:row["source_flags"].as_u64().unwrap() as u32,config_flags:row["config_flags"].as_u64().unwrap() as u32,owner_present:false,bounds:[0;6]},rate:0x41200000,emit:row["emit"].as_bool().unwrap(),one_shot_descriptors:[[0;24];2],bounds_coefficient:0x40000000},&scratch,&mut complex,&complex_filters,&mut simple,&simple_filters,&mut pending,&mut complex_done,&mut simple_done,&mut b).unwrap();
            let e=&row["cpu"];
            for resource in e["resources"].as_array().unwrap() {
                let n=|k:&str|resource[k].as_u64().unwrap() as u32;let r=&b.trails.resources[&n("control")];let t=&b.trails.states[&n("state_control")];
                for (key,value) in [("resource_strong",r.strong),("resource_weak",r.weak),("state_strong",t.strong),("state_weak",t.weak),("final_flags",r.requests),("final_owner",t.owner_index),("final_dead",u32::from(t.dead))] {assert_eq!(value,n(key),"case{i} {key}");}
            }
            for (child_index,c) in complex.iter().enumerate() {
                for buffer in &e["complex_buffers"].as_array().unwrap()[child_index*13..(child_index+1)*13] {
                    let actual=c.storage.particles.iter().map(|r|r.native_words(bits(&buffer["offset"]) as usize).unwrap().into_iter().map(|v|format!("0x{v:x}")).collect::<Vec<_>>()).collect::<Vec<_>>();
                    assert_eq!(json!(actual),buffer["records"],"case{i} particle companion buffers");
                }
            }
            assert_eq!(json!(complex.iter().map(|c|json!({"flag":c.flag,"times":c.times,"counters":c.counters,"last_update":c.last_update,"storage_last_update":c.storage_frame.last_update_bits,"storage_count":c.storage_frame.live_count})).collect::<Vec<_>>()),e["complex_state"],"complex state case{i}");
            assert_eq!(json!(simple.iter().map(|c|json!({"flag":c.flag,"times":c.times,"resource":c.resource})).collect::<Vec<_>>()),e["simple_state"],"simple state case{i}");assert_eq!(json!(pending),e["pending"],"queue case{i}");
            assert_eq!(complex_done,e["complex_done"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<_>>(),"complex done case{i}");
            assert_eq!(simple_done,e["simple_done"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<_>>(),"simple done case{i}");
            assert_eq!(s.audio.flags_1dc,e["flags"].as_u64().unwrap() as u8,"flags case{i}");assert_eq!(s.audio.flags_1dd,e["flags_1dd"].as_u64().unwrap() as u8,"flagsdd case{i}");assert_eq!(s.audio.field_ec,bits(&e["offset"]),"offset case{i}");assert_eq!(s.motion.last,bits(&e["last"]),"last case{i}");assert_eq!(s.audio.times[1],bits(&e["time"]),"time case{i}");
            assert_eq!(s.motion.previous,words::<3>(&e["previous"]),"prev case{i}");assert_eq!(s.motion.position,words::<3>(&e["position"]),"pos case{i}");assert_eq!(s.motion.minimum,words::<3>(&e["minimum"]),"min case{i}");assert_eq!(s.motion.maximum,words::<3>(&e["maximum"]),"max case{i}");assert_eq!(s.motion.metrics,words::<2>(&e["metrics"]),"metrics case{i}");assert_eq!(s.counter,e["counter"].as_u64().unwrap() as u32,"counter case{i}");assert_eq!(s.clock,e["clock"].as_u64().unwrap() as u32,"clock case{i}");assert_eq!(s.audio.handles,std::array::from_fn(|n|e["handles"][n].as_u64().unwrap() as u32),"handles case{i}");assert_eq!(b.events,e["events"].as_array().unwrap().clone(),"events case{i}");
        }
    }
}
