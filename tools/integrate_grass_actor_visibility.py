from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/grass_actor_visibility.rs';assert not p.exists()
p.write_text('''//! Original617F10/6B2C30 gates; raw field producers and service remain explicit.
#[derive(Clone,Copy)]
pub struct Inputs {pub override_byte:u8,pub source_flag24:u8,pub source_flag2c:u8,pub actor_flags5ea:u8,pub selector:i32,pub source_mask28:u32}
pub fn simple(actor_flags5ea:u8)->bool {actor_flags5ea&1==0}
pub fn eligible(input:Inputs,mut service:impl FnMut()->u8)->bool {
    if input.override_byte!=0 {return true;}
    let source_pass=if service()==0 {
        input.source_flag2c!=0 || input.source_flag24!=0
    } else {
        if input.source_flag24==0 {return false;}
        if service()==0 || input.selector == -1 {true}
        else if input.selector == -2 {input.source_mask28&3!=0}
        else {input.source_mask28 & 1u32.wrapping_shl(input.selector as u32)!=0}
    };
    source_pass && simple(input.actor_flags5ea)
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn gate_and_nested_selector_match_original_results_and_service_call_order() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_actor_visibility_contract.json")).unwrap();assert_eq!(p["passed"],true);
        for c in p["cases"].as_array().unwrap() {
            let byte=|key:&str|c[key].as_u64().unwrap() as u8;
            let input=Inputs{override_byte:byte("override_byte"),source_flag24:byte("source_flag24"),source_flag2c:byte("source_flag2c"),actor_flags5ea:byte("actor_flags5ea"),selector:c["selector"].as_i64().unwrap() as i32,source_mask28:c["source_mask28"].as_u64().unwrap() as u32};
            let mut calls=Vec::new();let actual=eligible(input,||{let sequence=c["service_sequence"].as_array().unwrap();let value=sequence[calls.len().min(sequence.len()-1)].as_u64().unwrap() as u8;calls.push(value);value});
            assert_eq!(actual,c["result"].as_bool().unwrap());
            let expected:Vec<u8>=c["service_calls"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect();assert_eq!(calls,expected);
        }
    }
    #[test] fn simple_virtual_gate_matches_all_native_byte_values() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_actor_visibility_contract.json")).unwrap();
        for c in p["simple_cases"].as_array().unwrap(){assert_eq!(simple(c["actor_flags5ea"].as_u64().unwrap() as u8),c["result"].as_bool().unwrap());}
    }
}
''',encoding='utf-8')
main=r/'crates/client/src/main.rs';s=main.read_text(encoding='utf-8');assert 'mod grass_actor_visibility;' not in s
main.write_text('#[allow(dead_code)]\nmod grass_actor_visibility;\n'+s,encoding='utf-8')
for name in ['probe_native_grass_actor_visibility.py','integrate_grass_actor_visibility.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print('Original actor visibility gates ported; producer integration remains open.')
