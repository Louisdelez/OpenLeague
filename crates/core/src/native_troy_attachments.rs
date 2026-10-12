//! Whole941210 attachment update;940C15 caller checks emitter stop bit10.
#[derive(Debug,Clone,PartialEq,Eq)]
pub struct Attachment {pub id:u32,pub descriptor:[u8;76]}
pub trait Backend {
    fn owner_eligible(&mut self)->u8;
    fn owner_key(&mut self)->u32;
    fn manager_2c(&mut self,id:u32,owner_key:u32,descriptor:&[u8;76]);
    fn manager_30(&mut self,id:u32);
}
/// `source_flags` is None only for a null linked emitter. Gate ordering is native.
pub fn refresh(owner_present:bool,source_flags:Option<u32>,visibility:u8,attachments:&[Attachment],backend:&mut impl Backend) {
    if !owner_present || backend.owner_eligible()==0 {return;}
    let key=backend.owner_key();
    if key==u32::MAX {return;}
    let Some(flags)=source_flags else {return;};
    if visibility!=0 {return;}
    for attachment in attachments {
        if flags&8==0 {backend.manager_2c(attachment.id,key,&attachment.descriptor);}
        else {backend.manager_30(attachment.id);}
    }
}
pub fn frame_refresh(emitter_flags:u8,owner_present:bool,source_flags:u32,visibility:u8,attachments:&[Attachment],backend:&mut impl Backend) {
    if emitter_flags&0x10==0 {refresh(owner_present,Some(source_flags),visibility,attachments,backend);}
}
#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::{json,Value};
    fn hex(bytes:&[u8])->String {bytes.iter().map(|v|format!("{v:02x}")).collect()}
    struct Captured<'a> {row:&'a Value,events:Vec<Value>}
    impl Backend for Captured<'_> {
        fn owner_eligible(&mut self)->u8 {self.events.push(json!({"event":"eligible"}));self.row["owner_eligible"].as_u64().unwrap() as u8}
        fn owner_key(&mut self)->u32 {self.events.push(json!({"event":"key"}));self.row["key"].as_i64().unwrap() as u32}
        fn manager_2c(&mut self,id:u32,owner_key:u32,descriptor:&[u8;76]) {self.events.push(json!({"event":"activate","id":id,"key":owner_key,"descriptor":hex(descriptor)}));}
        fn manager_30(&mut self,id:u32) {self.events.push(json!({"event":"pause","id":id}));}
    }
    #[test]
    fn attachment_update_and_caller_gate_match864_native_cases() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/troy_attachments_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),864);
        let mut event_count=0;
        for (index,row) in proof["cases"].as_array().unwrap().iter().enumerate() {
            let attachments:Vec<_>=row["attachments"].as_array().unwrap().iter().map(|v| {
                let text=v["descriptor"].as_str().unwrap();Attachment {id:v["id"].as_u64().unwrap() as u32,descriptor:std::array::from_fn(|i|u8::from_str_radix(&text[i*2..i*2+2],16).unwrap())}
            }).collect();
            let mut backend=Captured {row,events:Vec::new()};let present=row["owner_present"].as_bool().unwrap();let flags=row["source_flags"].as_u64().unwrap() as u32;let visibility=row["visibility"].as_u64().unwrap() as u8;
            if row["frame"].as_bool().unwrap() {frame_refresh(row["emitter_flags"].as_u64().unwrap() as u8,present,flags,visibility,&attachments,&mut backend);}
            else {refresh(present,row["linked"].as_bool().unwrap().then_some(flags),visibility,&attachments,&mut backend);}
            assert_eq!(backend.events,*row["events"].as_array().unwrap(),"case {index}");event_count+=backend.events.len();
        }
        assert_eq!(event_count,948);
    }
}
