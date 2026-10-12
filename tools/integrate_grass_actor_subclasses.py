from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
p=r/'crates/client/src/grass_actor_visibility.rs';s=p.read_text(encoding='utf-8')
start=s.index('    let source_pass=if service()==0 {');end=s.index('\n#[cfg(test)]',start)
s=s[:start]+'''    source_pass(input.source_flag24,input.source_flag2c,input.selector,input.source_mask28,&mut service) && simple(input.actor_flags5ea)
}
pub fn source_pass(flag24:u8,flag2c:u8,selector:i32,mask28:u32,service:&mut impl FnMut()->u8)->bool {
    if service()==0 {flag2c!=0 || flag24!=0}
    else {
        if flag24==0 {return false;}
        if service()==0 || selector == -1 {true}
        else if selector == -2 {mask28&3!=0}
        else {mask28 & 1u32.wrapping_shl(selector as u32)!=0}
    }
}
'''+s[end:];p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/grass_actor_subclasses.rs';assert not p.exists()
p.write_text('''//! Original644E40/62DC80 criteria and62DF30 candidate bit; producers explicit.
use crate::grass_actor_visibility::{self,Inputs};
use std::sync::Weak;
pub struct Associated<T> {pub flags1c:u32,pub value:T}
pub fn resolve_associated<T:Clone>(weak:&Weak<Option<Associated<T>>>)->Option<T> {
    let lease=weak.upgrade()?;let actor=lease.as_ref().as_ref()?;
    (actor.flags1c&0x400!=0).then(||actor.value.clone())
}
#[derive(Clone,Copy)] pub struct Source {pub flag24:u8,pub flag2c:u8,pub mask28:u32}
pub fn id_filtered(base:Inputs,actor_id:u32,flags2314:u32,global_present:bool,mut identifier:impl FnMut()->u32,service:impl FnMut()->u8)->bool {
    if global_present && actor_id!=0 && actor_id!=identifier() {return false;}
    flags2314&4!=0 || grass_actor_visibility::eligible(base,service)
}
pub fn linked(base:Inputs,associated:Option<Source>,mut service:impl FnMut()->u8)->bool {
    let Some(source)=associated else {return false;};
    grass_actor_visibility::source_pass(source.flag24,source.flag2c,base.selector,source.mask28,&mut service) && grass_actor_visibility::eligible(base,service)
}
#[cfg(test)] mod tests {
 use super::*;use std::sync::Arc;
 fn proof()->serde_json::Value {serde_json::from_str(include_str!("../../../data/4.20/grass_actor_subclasses_contract.json")).unwrap()}
 fn primary(flag24:u8,flag2c:u8,selector:i32,mask28:u32)->Inputs {Inputs{override_byte:0,source_flag24:flag24,source_flag2c:flag2c,actor_flags5ea:0,selector,source_mask28:mask28}}
 #[test] fn associated_candidate_matches_original_weak_recovery_cases_without_leaking_lease() {
    let p=proof();assert_eq!(p["passed"],true);
    for c in p["source_cases"].as_array().unwrap() {
        let mode=c["mode"].as_str().unwrap();
        let holder=Arc::new(if mode=="null_pointee" {None} else {Some(Associated{flags1c:if mode=="wrong_flags"{0}else{0x400},value:123u32})});
        let weak=if mode=="empty"{Weak::new()}else{Arc::downgrade(&holder)};
        let retained=if mode=="expired" {drop(holder);None}else{Some(holder)};
        let before=retained.as_ref().map(Arc::strong_count);
        assert_eq!(resolve_associated(&weak).is_some(),c["result_present"].as_bool().unwrap());
        assert_eq!(retained.as_ref().map(Arc::strong_count),before);
    }
 }
 #[test] fn identifier_gate_matches_original_results_identifier_and_service_calls() {
    let p=proof();for c in p["id_cases"].as_array().unwrap() {
        let mut base=primary(128,0,0,0);base.actor_flags5ea=c["actor_flags5ea"].as_u64().unwrap() as u8;base.override_byte=c["override_byte"].as_u64().unwrap() as u8;
        let(mut ids,mut calls)=(0,Vec::new());
        let result=id_filtered(base,c["actor_id"].as_u64().unwrap() as u32,c["flags2314"].as_u64().unwrap() as u32,c["global_present"].as_bool().unwrap(),||{ids+=1;c["target_id"].as_u64().unwrap() as u32},||{calls.push(0u8);0});
        assert_eq!(result,c["result"].as_bool().unwrap());assert_eq!(ids,c["id_calls"].as_u64().unwrap());
        let expected:Vec<u8>=c["service_calls"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect();assert_eq!(calls,expected);
    }
 }
 #[test] fn linked_source_and_primary_gates_match_original_results_and_call_order() {
    let p=proof();for c in p["linked_cases"].as_array().unwrap() {
        let byte=|key:&str,i:usize|c[key][i].as_u64().unwrap() as u8;
        let base=primary(byte("primary_flags",0),byte("primary_flags",1),c["selector"].as_i64().unwrap() as i32,c["mask28"].as_u64().unwrap() as u32);
        let source=(c["mode"]=="valid").then_some(Source{flag24:byte("related_flags",0),flag2c:byte("related_flags",1),mask28:base.source_mask28});
        let mut calls=Vec::new();let result=linked(base,source,||{let seq=c["service_sequence"].as_array().unwrap();let v=seq[calls.len().min(seq.len()-1)].as_u64().unwrap() as u8;calls.push(v);v});
        assert_eq!(result,c["result"].as_bool().unwrap());
        let expected:Vec<u8>=c["service_calls"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect();assert_eq!(calls,expected);
    }
 }
}
''',encoding='utf-8')
main=r/'crates/client/src/main.rs';s=main.read_text(encoding='utf-8');assert 'mod grass_actor_subclasses;' not in s
main.write_text('#[allow(dead_code)]\nmod grass_actor_subclasses;\n'+s,encoding='utf-8')
for name in ['probe_native_grass_actor_subclasses.py','integrate_grass_actor_subclasses.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print('Subclass gates share qualified source selector; Weak adapter retains lease safely.')
