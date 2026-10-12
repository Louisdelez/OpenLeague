from pathlib import Path
import json,hashlib,datetime,re
r=Path(__file__).resolve().parents[1]
def read(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def write(p,x):(r/p).write_text(json.dumps(x,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
proof=read('docs/map_ambient_audio_routing_validation.json');assert proof['passed'] and proof['native_routing_cases']==64 and proof['native_mask_storage_cases']==12
log=(r/'logs/native-audio-routing-tests.log').read_text(encoding='utf-8-sig');assert re.search(r'test result: ok\. 154 passed; 0 failed',log)
assert len(re.findall(r'test audio_routing::tests::\w+ \.\.\. ok',log))==3
now=datetime.datetime.now(datetime.timezone.utc).isoformat()
meta={'updated_utc':now,'contract':'data/4.20/audio_routing_contract.json','contract_sha256':sha('data/4.20/audio_routing_contract.json'),'module':'crates/core/src/audio_routing.rs','module_sha256':sha('crates/core/src/audio_routing.rs'),'native_routing_cases':64,'native_mask_storage_cases':12,'instruction_anchors':15,'jump_table_entries':1,'rust_routing_tests':3,'core_tests':154,'test_log':'logs/native-audio-routing-tests.log','test_log_sha256':sha('logs/native-audio-routing-tests.log'),'native_executable_sha256':proof['provenance']['sha256'],'runtime_audio_enabled':False,'client_integration_enabled':False,'complete':False,'limits':proof['limits']}
write('docs/map_ambient_audio_routing_progress.json',meta)
c=read('docs/coverage.json');c['updated_utc']=now;c['current_evidence']['map_ambient_audio_routing']=meta;c['current_evidence']['core_tests_passed']=154
for p in ['docs/map_ambient_audio_routing_validation.json','docs/map_ambient_audio_routing_progress.json','logs/native-audio-routing-tests.log']:
 if p not in c['evidence']:c['evidence'].append(p)
write('docs/coverage.json',c)
p=read('docs/completion_plan.json');p['updated_utc']=now;p['current_evidence']=c['current_evidence'];write('docs/completion_plan.json',p)
k=read('docs/resume_checkpoint.json');k['saved_utc']=now;k['last_verified'].update({'core_tests':154,'ambient_audio_routing_checks':3,'ambient_audio_native_routing_cases':64,'ambient_audio_native_mask_cases':12})
k['latest_changes'].append('Resolved original audio backend: 2d78aa4 -> concrete vtable 10a48e4; Wwise manager factory 6fa520/704b10 -> 10af384; voice factory 705a10/706c70 -> 10af338. Boolean callback 706e60 inverts low byte into listener mask 1/0, message 14 aeb0a0 -> dispatch b07474 -> registered object update af6270 stores mask +0xa and dirty bit 0x40000000. Distinct from release 6ce2d0 ->706ea0/706f90. Rust audio_routing.rs matches 64 native routes/12 mask stores, three new tests; core 154 passed. No voice pause or audible playback claim.')
k['restart_next'].insert(0,'Integrate native ambient audio request/routing/selection/curves after qualifying remaining mixer/lifetimes: boolean signal is listener-mask routing, NOT pause. Original release 706f90 may post end event (field +0x28) then fallback aeb740 action4; inspect registrations/post flags, distance listener coordinates, scalar ranges/LPF and bus gains. Do not replay Persistent simply because WAV ended. 154 core tests; full 24-domain goal incomplete.')
write('docs/resume_checkpoint.json',k)
print('Recorded native routing: 64 route cases, 12 mask stores, 154 core tests; full game incomplete.')
