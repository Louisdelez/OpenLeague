from pathlib import Path
import json,hashlib,re,datetime
r=Path(__file__).resolve().parents[1]
def read(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def write(p,v):(r/p).write_text(json.dumps(v,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
proof=read('data/4.20/audio_object_lifecycle_contract.json')
counts={'position_cases':48,'unregister_packet_cases':4,'acquire_cases':20,'unregister_cases':40,'unregister_all_cases':40}
assert proof['passed'] and all(len(proof[k])==v for k,v in counts.items())
assert sha(proof['provenance']['executable'])==proof['provenance']['sha256']
log=(r/'logs/native-audio-object-lifecycle-core-tests.log').read_text(encoding='utf-8-sig')
assert re.search(r'test result: ok\. 206 passed; 0 failed',log)
assert len(re.findall(r'test audio_object_registration::lifecycle_tests::\w+ \.\.\. ok',log))==4
now=datetime.datetime.now(datetime.timezone.utc).isoformat()
files=['tools/qualify_native_audio_object_lifecycle.py','data/4.20/audio_object_lifecycle_contract.json','crates/core/src/audio_object_registration.rs','logs/native-audio-object-lifecycle-core-tests.log']
meta={'updated_utc':now,'native_case_counts':counts,'native_cases_total':152,'core_tests':206,'new_core_tests':4,
 'files':{p:sha(p) for p in files},'native_executable_sha256':proof['provenance']['sha256'],
 'native_regions':{a['start']:a['sha256'] for a in proof['regions']},
 'native_position_behavior':'707420 caches suppliedXYZ, submits[X,field14*-2500,Z], opaque orientation stack tail; engine unavailable cachesXYZ only; ID0 rejected,FFFFFFFF accepted on this path.',
 'native_reference_behavior':'B099D0 increments low30 bits, preserves high2 flags. Single unregisterB0A1A0 removes hash node, clears bit31 and decrements low30, destroys only count0. GlobalB0A0C0 skipsID0, decrements low30 preserving high2 flags, removes other nodes; retained source descriptors returned as Rust owned values.',
 'native_stubs':proof['stubs'],'client_integration_enabled':False,'ambient_playback_enabled':False,'complete':False,
 'limits':proof['limits']+[
 'Registry source ownership represented as returned Rust values; actual retained voice handles, final reference release, native full object destructor and callback scheduling still missing.',
 'Wrapper cached-vector field renamed from initial_orientation_words to cached_vector_words because707420 overwrites it with pointXYZ.',
 'Rust finite guards explicit; original nonfinite/fatal behavior not qualified.',
 'No new client build, scene-source capture or audible PCM proof; prior client13 tests remain historical.']}
write('docs/map_ambient_audio_object_lifecycle_progress.json',meta)
c=read('docs/coverage.json');c['updated_utc']=now;c['current_evidence']['core_tests_passed']=206;c['current_evidence']['map_ambient_audio_object_lifecycle']=meta
for p in files+['docs/map_ambient_audio_object_lifecycle_progress.json']:
 if p not in c['evidence']:c['evidence'].append(p)
write('docs/coverage.json',c)
p=read('docs/completion_plan.json');p['updated_utc']=now;p['current_evidence']=c['current_evidence'];write('docs/completion_plan.json',p)
k=read('docs/resume_checkpoint.json');k['saved_utc']=now;k['last_verified'].update({'core_tests':206,'ambient_audio_object_lifecycle_core_checks':4,'ambient_audio_native_object_lifecycle_cases':152})
k['latest_changes'].append('Native object lifecycle qualified152 cases:707420 cachedXYZ vs submitted field14*-2500 height; packet12 formatting; B099D0 low30 reference increment; B0A1A0 single unregister removes node/clears bit31 and retains source if referenced; B0A0C0 global unregister skipsID0 and preserves high2 flags. Rust Registry supports both, returns retained source ownership. Core206 pass, actual retained voice handles/final destructor/audio consumer unimplemented.')
k['restart_next'].insert(0,'Qualify native wrapper height producer7075B0/field14 and final retained-source release/refcount path; map source lifetime to actual voice ownership, not emitter end. Wrapper position707420 uses field14*-2500 while ambient voice706DF0 submits suppliedXYZ; keep routes distinct. Single/global unregister now implemented and152 cases/core206 verified, destructor stubbed. Need actual client request/voice/registry consumer and audible PCM integration. Full24-domain game remains incomplete.')
write('docs/resume_checkpoint.json',k)
print('Recorded native object lifecycle:152 cases/core206; full goal incomplete.')