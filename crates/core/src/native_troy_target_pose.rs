//! Second attach phase940AEE..940C15: target channels and horizontal rotation.
use crate::native_troy_properties::{Emitter,Source};
pub trait Backend {
    fn eligible(&mut self)->u8;
    fn position(&mut self)->Option<[u32;3]>;
}
fn arithmetic(left:u32,right:u32,operation:impl FnOnce(f32,f32)->f32)->u32 {
    let a=f32::from_bits(left);let b=f32::from_bits(right);
    if a.is_nan() {return left|0x00400000;}
    if b.is_nan() {return right|0x00400000;}
    let v=operation(a,b);if v.is_nan() {0xffc00000} else {v.to_bits()}
}
#[cfg(target_arch="x86_64")]
fn rotation(dx:u32,dz:u32)->Result<[u32;16],&'static str> {
    let mut angle=0u32;let mut out=[0u32;3];let mut saved=0u16;let control=0x037fu16;
    // Hardware counterparts of original FPATAN followed by8DF690. Balanced
    // x87 stack, f32 angle store before trig, original masked nearest mode.
    unsafe {core::arch::asm!(
        "fnstcw word ptr [{saved}]", "fldcw word ptr [{control}]",
        "fld dword ptr [{dx}]", "fld dword ptr [{dz}]", "fpatan", "fstp dword ptr [{angle}]",
        "fld dword ptr [{angle}]", "fld st(0)", "fsin", "fxch st(1)", "fcos",
        "fstp dword ptr [{out}]", "fld st(0)", "fchs", "fstp dword ptr [{out} + 4]", "fstp dword ptr [{out} + 8]",
        "fldcw word ptr [{saved}]",
        saved=in(reg) &mut saved,control=in(reg) &control,dx=in(reg) &dx,dz=in(reg) &dz,
        angle=in(reg) &mut angle,out=in(reg) out.as_mut_ptr(),options(nostack)
    );}
    let [c,negative_s,s]=out;
    Ok([c,0,negative_s,0,0,0x3f800000,0,0,s,0,c,0,0,0,0,0x3f800000])
}
#[cfg(not(target_arch="x86_64"))]
fn rotation(_dx:u32,_dz:u32)->Result<[u32;16],&'static str> {Err("native x87 target rotation is not qualified on this architecture")}
pub fn transfer(source:&mut Source,emitter:&mut Emitter,linked:bool,backend:&mut impl Backend)->Result<(),&'static str> {
    if !linked || backend.eligible()==0 {return Ok(());}
    if let Some(target)=backend.position() {source.channels=target;emitter.channels=target;}
    if source.flags&0x30==0x30 {
        let dx=arithmetic(source.channels[0],source.position[0],|a,b|a-b);
        let dz=arithmetic(source.channels[2],source.position[2],|a,b|a-b);
        let dx2=arithmetic(dx,dx,|a,b|a*b);let dz2=arithmetic(dz,dz,|a,b|a*b);
        if f32::from_bits(arithmetic(dx2,dz2,|a,b|a+b))>0. {
            source.matrix=rotation(dx,dz)?;
            emitter.matrix=source.matrix;
        }
    }
    Ok(())
}
#[cfg(test)]
mod tests {
    use super::*;
    use crate::native_troy_position_bounds::Bounds;
    use serde_json::Value;
    fn bits(v:&Value)->u32 {u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    fn words<const N:usize>(v:&Value)->[u32;N] {std::array::from_fn(|i|bits(&v[i]))}
    struct Captured<'a> {profile:&'a Value,events:Vec<&'static str>}
    impl Backend for Captured<'_> {
        fn eligible(&mut self)->u8 {self.events.push("eligible");self.profile["eligible"].as_u64().unwrap() as u8}
        fn position(&mut self)->Option<[u32;3]> {self.events.push("position");self.profile["position_ok"].as_bool().unwrap().then(||words(&self.profile["target"]))}
    }
    #[test]
    fn second_attach_phase_matches608_native_and_real_x87_reference_cases() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/troy_target_pose_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),608);assert_eq!(proof["actual_cpu_rotation_calls"],180);
        assert_eq!(proof["actual_cpu_sse_operations"],1120);assert_eq!(proof["actual_cpu_x87_copies"],6120);assert_eq!(bits(&proof["threshold_bits"]),0);
        for (index,row) in proof["cases"].as_array().unwrap().iter().enumerate() {
            let before=&row["before"];let expected=&row["cpu"];
            let mut source=Source {requests:0,flags:row["flags"].as_u64().unwrap() as u32,visibility:0,params:[0;3],color:[0;8],matrix:words(&before["source_matrix"]),channels:words(&before["source_channels"]),field_80:0,position:words(&row["position"]),direction:[0;3]};
            let mut emitter=Emitter {flags:0,source_flags:0,channels:words(&before["channels"]),field_80:0,params:[0;3],color:[0;8],matrix:words(&before["matrix"]),bounds:Bounds {position:[0;3],minimum:[0;3],maximum:[0;3]},direction:[0;3]};
            let mut backend=Captured {profile:&row["profile"],events:Vec::new()};
            transfer(&mut source,&mut emitter,row["owner_present"].as_bool().unwrap(),&mut backend).unwrap();
            assert_eq!(source.channels,words::<3>(&expected["source_channels"]),"case {index}");assert_eq!(emitter.channels,words::<3>(&expected["channels"]),"case {index}");
            assert_eq!(source.matrix,words::<16>(&expected["source_matrix"]),"case {index}");assert_eq!(emitter.matrix,words::<16>(&expected["matrix"]),"case {index}");
            assert_eq!(backend.events,expected["events"].as_array().unwrap().iter().map(|v|v.as_str().unwrap()).collect::<Vec<_>>(),"case {index}");
        }
    }
}
