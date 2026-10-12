//! Owner phase94099A..940AEE, including93F1A0 status and deferred queue.
use crate::native_troy_properties::{Emitter,Source};
use crate::native_troy_position_bounds;
#[derive(Debug,Copy,Clone,PartialEq,Eq)]
pub struct DeferredCall {pub handler:u32,pub argument:u32}
#[derive(Debug,Copy,Clone,PartialEq,Eq)]
pub struct Config {pub group_vis:u32,pub flags:u32}
/// Virtual producer bodies and callback handlers remain owned by the runtime.
/// Handler IDs are explicit bindings, never executable host pointers.
pub trait Backend {
    fn eligible(&mut self)->u8;
    fn position(&mut self)->Option<[u32;3]>;
    fn direction(&mut self)->Option<[u32;3]>;
    fn orientation(&mut self)->Option<[u32;16]>;
    fn secondary_status(&mut self)->u8;
    fn primary_status(&mut self)->u8;
    fn deferred(&mut self,call:DeferredCall,pending:&mut Vec<DeferredCall>);
}
fn x87_copy(value:u32)->u32 {
    if value&0x7f800000==0x7f800000 && value&0x007fffff!=0 {value|0x00400000} else {value}
}
pub fn transfer(source:&mut Source,emitter:&mut Emitter,config:Config,linked:bool,pending:&mut Vec<DeferredCall>,backend:&mut impl Backend) {
    if !linked || backend.eligible()==0 {return;}
    if let Some(position)=backend.position() {
        emitter.bounds=native_troy_position_bounds::apply(position,config.group_vis);
        source.position=position;
    }
    if let Some(direction)=backend.direction() {emitter.direction=direction;source.direction=direction;}
    if source.flags&0x10!=0 && source.flags&0x20==0 {
        if let Some(matrix)=backend.orientation() {
            source.matrix=matrix.map(x87_copy);
            source.matrix[12..15].fill(0);
            emitter.matrix=source.matrix.map(x87_copy);
        }
    }
    let secondary=backend.secondary_status();
    let primary=backend.primary_status();
    let active=(primary!=0 && config.flags&2==0)||(secondary!=0 && config.flags&4==0);
    emitter.source_flags=(emitter.source_flags&!8)|if active {8} else {0};
    // Original vector is copied and emptied before any callback executes.
    // Newly enqueued work belongs to a later dispatch; no host code pointer call.
    let snapshot=pending.clone();
    pending.clear();
    for call in snapshot {backend.deferred(call,pending);}
}
#[cfg(test)]
mod tests {
    use super::*;
    use crate::native_troy_position_bounds::Bounds;
    use serde_json::{json,Value};
    fn bits(v:&Value)->u32 {u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    fn words<const N:usize>(v:&Value)->[u32;N] {std::array::from_fn(|i|bits(&v[i]))}
    struct Captured<'a> {profile:&'a Value,events:Vec<Value>}
    impl Backend for Captured<'_> {
        fn eligible(&mut self)->u8 {self.events.push(json!({"event":"eligible"}));self.profile["eligible"].as_u64().unwrap() as u8}
        fn position(&mut self)->Option<[u32;3]> {self.events.push(json!({"event":"position"}));self.profile["position_ok"].as_bool().unwrap().then(||words(&self.profile["position"]))}
        fn direction(&mut self)->Option<[u32;3]> {self.events.push(json!({"event":"direction"}));self.profile["direction_ok"].as_bool().unwrap().then(||words(&self.profile["direction"]))}
        fn orientation(&mut self)->Option<[u32;16]> {self.events.push(json!({"event":"orientation"}));self.profile["orientation_ok"].as_bool().unwrap().then(||words(&self.profile["orientation"]))}
        fn secondary_status(&mut self)->u8 {self.events.push(json!({"event":"secondary"}));self.profile["secondary"].as_u64().unwrap() as u8}
        fn primary_status(&mut self)->u8 {self.events.push(json!({"event":"primary"}));self.profile["primary"].as_u64().unwrap() as u8}
        fn deferred(&mut self,call:DeferredCall,pending:&mut Vec<DeferredCall>) {assert_eq!(call.handler,0x32000960);self.events.push(json!({"event":"callback","argument":call.argument,"queue_count":pending.len()}));}
    }
    #[test]
    fn owner_pose_and_status_deferred_phase_match288_native_cpu_cases() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/troy_owner_pose_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),288);
        assert_eq!(proof["actual_cpu_sse_operations"],768);assert_eq!(proof["actual_cpu_x87_copies"],1536);
        assert_eq!(proof["emulator_cpu_case_disagreements"],41);
        for (index,row) in proof["cases"].as_array().unwrap().iter().enumerate() {
            let before=&row["before"];let expected=&row["cpu"];
            let mut source=Source {requests:0,flags:row["flags"].as_u64().unwrap() as u32,visibility:0,params:[0;3],color:[0;8],matrix:words(&before["source_matrix"]),channels:[0;3],field_80:0,position:words(&before["source_position"]),direction:words(&before["source_direction"])};
            let mut emitter=Emitter {flags:0,source_flags:before["source_flags"].as_u64().unwrap() as u32,channels:[0;3],field_80:0,params:[0;3],color:[0;8],matrix:words(&before["matrix"]),bounds:Bounds {position:words(&before["position"]),minimum:words(&before["minimum"]),maximum:words(&before["maximum"])},direction:words(&before["direction"])};
            let mut pending:Vec<_>=row["pending_arguments"].as_array().unwrap().iter().map(|v|DeferredCall {handler:bits(&proof["callback_address"]),argument:v.as_u64().unwrap() as u32}).collect();
            let mut backend=Captured {profile:&row["profile"],events:Vec::new()};
            transfer(&mut source,&mut emitter,Config {group_vis:bits(&row["coefficient"]),flags:row["config_flags"].as_u64().unwrap() as u32},row["owner_present"].as_bool().unwrap(),&mut pending,&mut backend);
            assert_eq!(source.matrix,words::<16>(&expected["source_matrix"]),"case {index}");
            assert_eq!(source.position,words::<3>(&expected["source_position"]),"case {index}");
            assert_eq!(source.direction,words::<3>(&expected["source_direction"]),"case {index}");
            assert_eq!(emitter.matrix,words::<16>(&expected["matrix"]),"case {index}");
            assert_eq!(emitter.direction,words::<3>(&expected["direction"]),"case {index}");
            assert_eq!(emitter.bounds,Bounds {position:words(&expected["position"]),minimum:words(&expected["minimum"]),maximum:words(&expected["maximum"])},"case {index}");
            assert_eq!(emitter.source_flags,expected["source_flags"].as_u64().unwrap() as u32,"case {index}");
            assert_eq!(pending.len(),expected["pending_count"].as_u64().unwrap() as usize,"case {index}");
            assert_eq!(backend.events,*expected["events"].as_array().unwrap(),"case {index}");
        }
    }
}
