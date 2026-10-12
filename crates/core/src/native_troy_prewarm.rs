//! Native940C2B..940D19 orchestration. Producer bodies remain explicit backends.
use crate::native_troy_reset::FrameControl;
pub trait Backend {
    type Scratch;
    fn pause(&mut self);
    fn scratch_create(&mut self)->Self::Scratch;
    fn update(&mut self,time:u32,scratch:&mut Self::Scratch,flags:&mut u8);
    fn resume(&mut self);
    fn scratch_destroy(&mut self,scratch:Self::Scratch);
}
#[derive(Debug,Copy,Clone,PartialEq,Eq)]
pub struct Timing {pub step:u32,pub cursor:u32}
fn quiet(v:u32)->u32 {if f32::from_bits(v).is_nan(){v|0x00400000}else{v}}
fn arithmetic(a:u32,b:u32,op:u8)->u32 {
    let x=f32::from_bits(a);let y=f32::from_bits(b);
    if x.is_nan(){return quiet(a);}if y.is_nan(){return quiet(b);}
    let v=match op {0=>x*y,1=>x-y,_=>x+y};if v.is_nan(){0xffc00000}else{v.to_bits()}
}
/// A stalled positive-time loop is explicitly rejected, never silently truncated.
/// Caller is responsible for supplying qualified producer backends.
pub fn prewarm(time:u32,rewind:u32,control:&mut FrameControl,flags:&mut u8,backend:&mut impl Backend)->Result<Option<Timing>,&'static str> {
    if control.ebx&0xff00==0 {return Ok(None);}
    let paused=*flags>>7;control.ebx=(control.ebx&!0xff)|u32::from(paused);
    if paused!=0 {backend.pause();}
    let mut scratch=backend.scratch_create();
    let step=arithmetic(rewind,0x3dcccccd,0);let mut cursor=arithmetic(time,rewind,1);
    let result=(||{
        if f32::from_bits(time)>f32::from_bits(cursor) {
            loop {
                backend.update(quiet(cursor),&mut scratch,flags);
                let next=arithmetic(cursor,step,2);
                let repeats=*flags&2==0 && f32::from_bits(time)>f32::from_bits(next);
                let stalled=repeats && next==cursor;cursor=next;
                if stalled {return Err("native prewarm loop does not advance");}
                if !repeats {break;}
            }
        }
        Ok(Some(Timing {step,cursor}))
    })();
    if paused!=0 {backend.resume();}backend.scratch_destroy(scratch);result
}
#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::{Value,json};
    struct Adapter {events:Vec<Value>,updates:usize,stop_after:usize,pointer:u32}
    impl Backend for Adapter {
        type Scratch=();
        fn pause(&mut self){self.events.push(json!({"event":"pause"}));}
        fn scratch_create(&mut self){self.events.push(json!({"event":"scratch_create"}));}
        fn update(&mut self,time:u32,_:&mut (),flags:&mut u8){self.events.push(json!({"event":"update","time":format!("0x{time:x}"),"scratch":self.pointer,"flag":0}));self.updates+=1;if self.stop_after!=0 && self.updates>=self.stop_after {*flags|=2;}}
        fn resume(&mut self){self.events.push(json!({"event":"resume"}));}
        fn scratch_destroy(&mut self,_:()){self.events.push(json!({"event":"scratch_destroy"}));}
    }
    fn bits(v:&Value)->u32{u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    #[test]
    fn prewarm_order_and_timing_match240_native_captures() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/troy_prewarm_contract.json")).unwrap();assert_eq!(proof["cases"].as_array().unwrap().len(),240);assert_eq!(proof["actual_cpu_sse_operations"],392);
        for (i,row) in proof["cases"].as_array().unwrap().iter().enumerate() {
            let bh=row["bh"].as_u64().unwrap() as u32;let mut control=FrameControl {ebx:0xa5b600d8|(bh<<8),local_time:bits(&row["time"])};let mut flags=row["initial_flags"].as_u64().unwrap() as u8;
            let mut backend=Adapter {events:vec![],updates:0,stop_after:row["stop_after"].as_u64().unwrap() as usize,pointer:proof["scratch_pointer"].as_u64().unwrap() as u32};
            let result=prewarm(bits(&row["time"]),bits(&row["rewind"]),&mut control,&mut flags,&mut backend).unwrap();let expected=&row["cpu"];
            assert_eq!(control.ebx,bits(&expected["ebx"]),"case{i}");assert_eq!(flags,expected["flags"].as_u64().unwrap() as u8,"case{i}");assert_eq!(backend.events,expected["events"].as_array().unwrap().clone(),"case{i}");
            if let Some(t)=result {assert_eq!(t,Timing {step:bits(&expected["step"]),cursor:bits(&expected["cursor"])},"case{i}");}else{assert_eq!(bits(&expected["step"]),0x12345678);assert_eq!(bits(&expected["cursor"]),0x87654321);}
        }
    }
    #[test]
    fn stalled_loop_returns_explicit_error_and_destroys_scratch() {
        // Subnormal duration gives a positive interval but its 10% step rounds to zero.
        let mut control=FrameControl {ebx:0x100,local_time:0};let mut flags=128;let mut backend=Adapter {events:vec![],updates:0,stop_after:0,pointer:0};
        assert!(prewarm(0,1,&mut control,&mut flags,&mut backend).is_err());assert_eq!(backend.updates,1);assert_eq!(backend.events.last().unwrap()["event"],"scratch_destroy");assert!(backend.events.iter().any(|e|e["event"]=="resume"));
    }
}
