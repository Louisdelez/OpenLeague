from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/native_effect_live_creation.rs';s=p.read_text(encoding='utf-8')
s=s.replace('flags24:0x80,dirty144:0,scalar148:0,scalar5c:0,scalar3c:0,','flags24:0,dirty144:0x2000,scalar148:0,scalar5c:1f32.to_bits(),scalar3c:1f32.to_bits(),')
s=s.replace('let mut a=Troy::default();configure(', 'let mut a=Troy{flags24:0x80,dirty144:0,scalar148:0,scalar5c:0,scalar3c:0,..Troy::default()};configure(')
s=s.replace('impl Default for Troy', '/// Verified93FD60 constructor fields before resource loading.\nimpl Default for Troy')
marker=' #[test]\n fn matches192_original_live_factory_executions()'
new=''' #[test]
 fn matches36_original_troy_constructor_executions(){
 let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/troy_constructor_contract.json")).unwrap();let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),36);
 for (n,c) in cases.iter().enumerate(){let a=Troy::default();let e=&c["troy"];
 for(k,v) in [("flags24",a.flags24),("dirty144",a.dirty144),("scalar148",a.scalar148),("scalar5c",a.scalar5c),("scalar3c",a.scalar3c)]{assert_eq!(v,e[k].as_u64().unwrap() as u32,"case{n} {k}");}
 for i in 0..16{assert_eq!(a.matrix_words[i],e["matrix_words"][i].as_u64().unwrap() as u32,"case{n} matrix{i}");}
 }
 }
'''
assert marker in s;s=s.replace(marker,new+marker);p.write_text(s,encoding='utf-8')
print(p)
