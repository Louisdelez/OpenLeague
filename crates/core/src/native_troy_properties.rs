//! Property phase94071E..9408E8 with original helper composition.
//! Reset, audio-map, child-byte, owner pose and final request reset are later phases.
use crate::native_troy_scalar::{self,Child};
use crate::native_troy_position_bounds::{self,Bounds};
#[derive(Debug,Clone,PartialEq,Eq)]
pub struct Source {
    pub requests:u32,pub flags:u32,pub visibility:u8,
    pub params:[u32;3],pub color:[u32;8],pub matrix:[u32;16],
    pub channels:[u32;3],pub field_80:u32,pub position:[u32;3],pub direction:[u32;3],
}
#[derive(Debug,Clone,PartialEq,Eq)]
pub struct Emitter {
    pub flags:u8,pub source_flags:u32,pub channels:[u32;3],pub field_80:u32,
    pub params:[u32;3],pub color:[u32;8],pub matrix:[u32;16],
    pub bounds:Bounds,pub direction:[u32;3],
}
#[derive(Debug,Copy,Clone,PartialEq,Eq)]
pub struct Config {
    pub lower:u32,pub upper:u32,pub scale_cap:u32,pub group_vis:u32,
}
fn x87_copy(value:u32)->u32 {
    if value&0x7f800000==0x7f800000 && value&0x007fffff!=0 {value|0x00400000} else {value}
}
/// Execute only this property phase, retaining the request word for later phases.
/// `owner_status` is present only for a linked owner and is called only when
/// native wrapper virtual98 (flags bit80) enables owner visibility control.
pub fn transfer(source:&Source,emitter:&mut Emitter,config:Config,first:&mut [Child],second:&mut [Child],mut owner_status:Option<&mut dyn FnMut()->u8>) {
    let requests=source.requests;
    if requests&1!=0 {emitter.flags|=1;}
    if requests&2!=0 {emitter.params[0]=source.params[0];}
    if requests&4!=0 {emitter.params[1]=source.params[1];}
    if requests&8!=0 {
        emitter.params[2]=native_troy_scalar::apply(x87_copy(source.params[2]),config.lower,config.upper,config.scale_cap,first,second);
    }
    if requests&0x4000!=0 {emitter.color=source.color.map(x87_copy);}
    let visibility=if source.flags&0x80!=0 && owner_status.is_some() {
        Some(u8::from(owner_status.as_mut().unwrap()()==0))
    } else if requests&0x10!=0 {Some(source.visibility)} else {None};
    if let Some(value)=visibility {emitter.flags=(emitter.flags&!8)|((value&1)<<3);}
    if requests&0x20!=0 {
        emitter.matrix=source.matrix.map(x87_copy);
        emitter.matrix[12..15].fill(0);
    }
    if requests&0x80!=0 {emitter.channels=source.channels;}
    if requests&0x100!=0 {emitter.field_80=source.field_80;}
    if requests&0x800!=0 {emitter.source_flags=source.flags;}
    if requests&0x1000!=0 {emitter.bounds=native_troy_position_bounds::apply(source.position,config.group_vis);}
    if requests&0x20000!=0 {emitter.direction=source.direction;}
}
#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::Value;
    fn bits(v:&Value)->u32 {u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    fn words<const N:usize>(v:&Value)->[u32;N] {std::array::from_fn(|i|bits(&v[i]))}
    fn emitter(v:&Value)->Emitter {Emitter {
        flags:v["flags"].as_u64().unwrap() as u8,source_flags:v["source_flags"].as_u64().unwrap() as u32,
        channels:words(&v["channels"]),field_80:bits(&v["field_80"]),params:words(&v["params"]),color:words(&v["color"]),matrix:words(&v["matrix"]),direction:words(&v["direction"]),
        bounds:Bounds {position:words(&v["position"]),minimum:words(&v["minimum"]),maximum:words(&v["maximum"])},
    }}
    fn children(v:&Value)->Vec<Child> {v.as_array().unwrap().iter().map(|c|Child {coefficients:words(&c["coefficients"]),owner:words(&c["owner"]),value:bits(&c["previous"])}).collect()}
    #[test]
    fn property_phase_and_complete_helpers_match428_native_cpu_reference_cases() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/troy_properties_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),428);
        assert_eq!(proof["actual_cpu_sse_operations"],1774);assert_eq!(proof["actual_cpu_x87_copies"],3062);
        assert_eq!(proof["emulator_cpu_case_disagreements"],168);
        for (index,row) in proof["cases"].as_array().unwrap().iter().enumerate() {
            let s=&row["source"];
            let source=Source {requests:s["requests"].as_u64().unwrap() as u32,flags:s["flags"].as_u64().unwrap() as u32,visibility:s["visibility"].as_u64().unwrap() as u8,params:words(&s["params"]),color:words(&s["color"]),matrix:words(&s["matrix"]),channels:words(&s["channels"]),field_80:bits(&s["field_80"]),position:words(&s["position"]),direction:words(&s["direction"])};
            let c=&row["scalar_config"];let config=Config {lower:bits(&c["lower"]),upper:bits(&c["upper"]),scale_cap:bits(&c["target"]),group_vis:bits(&row["coefficient"])};
            let mut actual=emitter(&row["before"]);let mut first=children(&row["children"][0]);let mut second=children(&row["children"][1]);
            let mut calls=0;let mut query=|| {calls+=1;s["owner_status"].as_u64().unwrap() as u8};
            let callback:Option<&mut dyn FnMut()->u8>=if s["owner_status"].is_null() {None} else {Some(&mut query)};
            transfer(&source,&mut actual,config,&mut first,&mut second,callback);
            assert_eq!(actual,emitter(&row["cpu"]),"case {index}");
            assert_eq!(source.requests,row["cpu"]["requests"].as_u64().unwrap() as u32);
            assert_eq!(calls,row["cpu"]["events"].as_array().unwrap().len(),"case {index}");
            for (kind,group) in [first,second].iter().enumerate() {
                for (child,value) in group.iter().zip(row["cpu"]["children"][kind].as_array().unwrap()) {assert_eq!(child.value,bits(value),"case {index} family {kind}");}
            }
        }
    }
}
