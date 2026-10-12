from pathlib import Path
import json,shutil,hashlib
r=Path('E:/OpenLeague');contract=json.loads((r/'data/4.20/native_fog_consumer_contract.json').read_text());assert contract['passed'] and contract['fog_rgb']==[34,62,84] and contract['opacity']==1.
p=r/'data/4.20/map_fog_settings.json';settings=json.loads(p.read_text());assert hashlib.sha256(Path(contract['source']).read_bytes()).hexdigest()==contract['source_sha256']
backup=r/'data/4.20/map_fog_settings.before_native_consumer.json';assert not backup.exists();shutil.copy2(p,backup)
settings['fog_data0']=contract['shader_field_vectors']['0x14beed4'];settings['fog_data1']=contract['shader_field_vectors']['0x14beee4'];settings['native_parameter_contract']='data/4.20/native_fog_consumer_contract.json';settings['native_parameter_policy']='Exact original f32 vectors from native config loader, typed/high-level getters, key hash and fog consumer. Screen radius uses saturated1-dot(screenXY,screenXY), with native1-radius offset. Top-layer shader still not integrated; x=0 for Map10.'
p.write_text(json.dumps(settings,indent=2)+'\n',encoding='utf-8')
p=r/'tools/recover_native_fog.py';s=p.read_text();needle='b=(deploy/';assert needle in s
insertion="""# Preserve the qualified native SSE arithmetic and screen-radius convention.
consumer=json.loads((r/'data/4.20/native_fog_consumer_contract.json').read_text(encoding='utf-8'))
assert consumer['passed'] and consumer['source_sha256']==hashlib.sha256((m/'terrain.inibin').read_bytes()).hexdigest()
fog0=consumer['shader_field_vectors']['0x14beed4'];fog1=consumer['shader_field_vectors']['0x14beee4']
"""
assert 'consumer=json.loads' not in s;s=s.replace(needle,insertion+needle,1);p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/map_fog.rs';s=p.read_text();assert 'native_parameter_consistency_test' not in s
s+='''
#[cfg(test)] mod native_parameter_consistency_test {
 #[test] fn map10_fog_vectors_match_original_loaded_config_consumer_bits() {
  let settings:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/map_fog_settings.json")).unwrap();
  let native:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_fog_consumer_contract.json")).unwrap();
  assert_eq!(native["passed"],true);
  for (key,address) in [("fog_data0","0x14beed4"),("fog_data1","0x14beee4")] {
   for (actual,expected) in settings[key].as_array().unwrap().iter().zip(native["shader_field_vectors"][address].as_array().unwrap()) {
    assert_eq!((actual.as_f64().unwrap() as f32).to_bits(),(expected.as_f64().unwrap() as f32).to_bits());
   }
   assert_eq!(settings[key].as_array().unwrap().len(),4);
  }
 }
}
''';p.write_text(s,encoding='utf-8')
print(json.dumps(dict(fog_data0=settings['fog_data0'],fog_data1=settings['fog_data1'],full_fog_complete=False)))
