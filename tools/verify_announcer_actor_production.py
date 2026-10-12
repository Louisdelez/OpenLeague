from pathlib import Path
import subprocess,shutil
r=Path('E:/OpenLeague')
source=r'''#[path="E:/OpenLeague/crates/core/src/audio_announcer_actor_tokens.rs"] mod native;
fn main(){
 let root=std::path::Path::new("E:/OpenLeague");let mut count=0;
 let proof:serde_json::Value=serde_json::from_str(&std::fs::read_to_string(root.join("data/4.20/audio_announcer_actor_tokens_contract.json")).unwrap()).unwrap();
 for c in proof["cases"].as_array().unwrap(){
  let actor=if c["actor"]=="null" {None} else {Some(0u8)};
  let local=match c["local"].as_str().unwrap(){"null"=>None,"actor"=>Some(0),_=>Some(1)};let mut calls=vec![];
  let value=native::source_actor_token(actor,local,c["mode"].as_u64().unwrap() as u32,|_|c["flags"].as_u64().unwrap() as u32,|_|{calls.push("actor");c["team"].as_u64().unwrap() as u32});
  assert_eq!(value,c["output"].as_str().unwrap());assert_eq!(serde_json::json!(calls),c["getter_calls"]);count+=1;
 }
 let proof:serde_json::Value=serde_json::from_str(&std::fs::read_to_string(root.join("data/4.20/audio_announcer_actor_binding_contract.json")).unwrap()).unwrap();
 for c in proof["cases"].as_array().unwrap(){
  let actor=if c["actor"]=="null" {None} else {Some(0u8)};
  let local=match c["local"].as_str().unwrap(){"null"=>None,"actor"=>Some(0),_=>Some(1)};
  let mut flag_reads=0;let mut calls=vec![];let mut localization=vec![];let input=c["input"].as_str().unwrap();
  let value=if c["entry"]=="0x6d4dc0"{
   native::bind_destination_actor_token(input,actor,local,|_|{flag_reads+=1;c["flags"].as_u64().unwrap() as u32},|key|{localization.push(key);Ok(proof["translations"][key].as_str().unwrap().to_owned())}).unwrap()
  }else{
   native::bind_source_actor_token(input,actor,local,c["mode"].as_u64().unwrap() as u32,|_|{flag_reads+=1;c["flags"].as_u64().unwrap() as u32},|_|{calls.push("actor");c["team"].as_u64().unwrap() as u32}).map(str::to_owned)
  };
  assert_eq!(value.is_some(),c["matched"].as_bool().unwrap());assert_eq!(serde_json::json!(value.into_iter().collect::<Vec<_>>()),c["appends"]);assert_eq!(flag_reads,c["flag_reads"].as_u64().unwrap());assert_eq!(serde_json::json!(calls),c["getter_calls"]);assert_eq!(serde_json::json!(localization),c["localization_calls"]);count+=1;
 }
 assert_eq!(count,7128);println!("{count} native actor outputs/accessor/localization calls match production Rust");
}'''
p=r/'tools/announcer_actor_production_probe.rs';p.write_text(source,encoding='utf-8');exe=r/'logs/announcer_actor_production_probe.exe'
subprocess.run(['C:/Users/loicd/.cargo/bin/rustc.exe','--edition=2021',str(p),'--extern','serde_json='+str(r/'target/debug/deps/libserde_json-06e1b1b57f0ae5f7.rlib'),'-L','dependency='+str(r/'target/debug/deps'),'-o',str(exe)],check=True)
result=subprocess.run([str(exe)],capture_output=True,text=True,check=True);(r/'logs/announcer-actor-production-comparison.log').write_text(result.stdout,encoding='utf-8');shutil.copy2(Path(__file__),r/'tools/verify_announcer_actor_production.py');print(result.stdout)
