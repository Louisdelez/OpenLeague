from pathlib import Path
import json,hashlib,re,datetime
r=Path(__file__).resolve().parents[1]
def read(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def write(p,x):(r/p).write_text(json.dumps(x,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
proof=read('data/4.20/audio_source_storage_contract.json')
assert proof['passed'] and len(proof['cases'])==720 and len(proof['queue13_cases'])==48
assert sha(proof['provenance']['executable'])==proof['provenance']['sha256']
log=(r/'logs/native-audio-source-storage-core-tests.log').read_text(encoding='utf-8-sig')
assert re.search(r'test result: ok\. 197 passed; 0 failed',log)
assert len(re.findall(r'test audio_source_storage::tests::\w+ \.\.\. ok',log))==2
files=['tools/qualify_native_audio_source_storage.py','data/4.20/audio_source_storage_contract.json','crates/core/src/audio_source_storage.rs','logs/native-audio-source-storage-core-tests.log']
now=datetime.datetime.now(datetime.timezone.utc).isoformat()
meta={'updated_utc':now,'native_storage_cases':720,'native_queue13_cases':48,'core_tests':197,'new_core_tests':2,
 'native_executable_sha256':proof['provenance']['sha256'],'files':{p:sha(p) for p in files},
 'native_regions':{a['start']:a['sha256'] for a in proof['regions']},
 'native_storage_layout':'Object+4 pointer; +8 u16 count; +A listener mask; +B low3 mode bits (upper5 retained); +60 dirty flags OR40000000; each source24bytes XYZ/raw orientation.',
 'native_error_behavior':'Missing object returns2 unchanged; registered object returns1 even if resize allocator fails (internal52, old sources freed, count0, mode and dirty still updated).',
 'bridge':'Qualified point-only producer -> six-word RawSource -> existing object storage -> qualified distance API; opaque orientation words never interpreted as XYZ.',
 'ambient_playback_enabled':False,'client_integration_enabled':False,'complete':False,'limits':proof['limits']+[
 'Rust preserves descriptor data/mode/mask/dirty semantics; BTree/hash registration and full native queue scheduler are not ported.',
 'Guard for more than65535 sources returns explicit Rust error, instead of truncating a slice length to u16.',
 'No original constructor default state inferred: RegisteredSources::restore requires explicit source state.',
 'No new standalone binary, live audio output or current client rendering acceptance. Client13 tests from prior emitter integration remain historical.']}
write('docs/map_ambient_audio_source_storage_progress.json',meta)
c=read('docs/coverage.json');c['updated_utc']=now;c['current_evidence']['core_tests_passed']=197
c['current_evidence']['map_ambient_audio_source_storage']=meta
for p in files+['docs/map_ambient_audio_source_storage_progress.json']:
 if p not in c['evidence']:c['evidence'].append(p)
write('docs/coverage.json',c)
p=read('docs/completion_plan.json');p['updated_utc']=now;p['current_evidence']=c['current_evidence'];write('docs/completion_plan.json',p)
k=read('docs/resume_checkpoint.json');k['saved_utc']=now;k['last_verified'].update({'core_tests':197,'ambient_audio_source_storage_core_checks':2,'ambient_audio_native_source_storage_cases':720,'ambient_audio_native_source_queue13_cases':48})
k['latest_changes'].append('Qualified native queue13 B0743A->B09FE0->AF6400->AEEDC0:720 direct/48 queue cases with hash collision, absent object, resize/free/failure, mode bits and dirty flags; allocator/free/memcpy explicit stubs. Rust audio_source_storage.rs matches descriptor semantics and links point producer to distance. Core197 pass. No client registry/audio consumer or new standalone binary.')
k['restart_next'].insert(0,'Continue native audio object registration/constructor and voice refresh706D70/RTPC/lifetime integration, then connect registered source storage to ambient request handling and playback. Source positions and queue13 copying now qualified768 cases, dirty/mode semantics and ignored internal allocation error52 explicit. Need live source capture and final mixer PCM evidence; do not collapse SoundOnCreate lifetime to emitter lifetime. Core197; all24 domains incomplete.')
write('docs/resume_checkpoint.json',k)
print('Recorded native source storage:768 cases,197 core tests; full goal incomplete.')