from pathlib import Path
import json,hashlib,datetime,re
r=Path(__file__).resolve().parents[1]
def read(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def write(p,x):(r/p).write_text(json.dumps(x,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
now=datetime.datetime.now(datetime.timezone.utc).isoformat()
proof=read('docs/map_ambient_audio_selection_validation.json');assert proof['passed'] and proof['fields_byte_checked']==343
log=(r/'logs/ambient-audio-selection-tests.log').read_text(encoding='utf-8-sig');assert re.search(r'test result: ok\. 141 passed; 0 failed',log)
assert len(re.findall(r'test audio_selection::tests::\w+ \.\.\. ok',log))==9
meta={'updated_utc':now,'native_events':5,'native_actions':8,'native_containers':8,'native_sound_nodes':42,'byte_verified_fields':343,'rust_selection_tests':9,'core_tests':141,'contract':'data/4.20/ambient_audio_selection.json','contract_sha256':sha('data/4.20/ambient_audio_selection.json'),'module':'crates/core/src/audio_selection.rs','module_sha256':sha('crates/core/src/audio_selection.rs'),'receipt':'docs/map_ambient_audio_selection_validation.json','test_log':'logs/ambient-audio-selection-tests.log','test_log_sha256':sha('logs/ambient-audio-selection-tests.log'),'runtime_audio_enabled':False,'client_integration_enabled':False,'native_rng_qualified':False,'complete':False,'limits':['Typed source graph and Rust selection primitives implemented; native RNG stream and reset_each_play semantics remain unqualified. Primitive selection preserves standard/shuffle modes, action probability gates, native weight-use flag and global/per-emitter scope. No live playback acceptance implied.','Source priority 35 on eight sounds, ranges, fades and reset flags preserved for future mixer/lifecycle integration; values are not silently replaced or discarded.','Spatial listener/attenuation conversion, gain/pitch/LPF ranges, voice limits, persistent/create lifetimes and native DSP still incomplete. All original 24 domains remain open.'],'primary_semantics_reference':'https://www.audiokinetic.com/en/public-library/2024.1.4_8780/?id=creating_random_container&source=Help','reference_scope':'Modern documentation describes selection semantics only; it does not prove native 2014 implementation identity. Historical PDF retrieval failed with HTTP 403 in this turn.'}
write('docs/map_ambient_audio_selection_progress.json',meta)
c=read('docs/coverage.json');c['updated_utc']=now;c['current_evidence']['map_ambient_audio_selection']=meta;c['current_evidence']['core_tests_passed']=141
for p in ['docs/map_ambient_audio_selection_validation.json','docs/map_ambient_audio_selection_progress.json','logs/ambient-audio-selection-tests.log']:
 if p not in c['evidence']:c['evidence'].append(p)
write('docs/coverage.json',c)
p=read('docs/completion_plan.json');p['updated_utc']=now;p['current_evidence']=c['current_evidence'];write('docs/completion_plan.json',p)
k=read('docs/resume_checkpoint.json');k['saved_utc']=now;k['last_verified'].update({'core_tests':141,'ambient_audio_selection_checks':9,'ambient_audio_selection_fields_byte_verified':343});k['latest_changes'].append('Typed native audio selection contract (5 events/8 actions/8 containers/42 sounds), 343 original scalar checks, nine Rust selection checks; complete core suite 141 passed. Source priorities, ranges and reset flags retained. Client playback not yet enabled.')
k['restart_next'].insert(0,'Continue native ambient audio mixer/lifecycle integration from audio_selection.rs and ambient_audio_selection.json. Nine selection checks pass, 343 scalar fields byte verified, sound-level priority 35 retained on eight sounds. Qualify native RNG/reset flags, action fades and probability defaults; do not infer live audible playback from selection tests. Resolve original attenuation scale=2 and Log3/listener plus persistent/create lifetime, inherited buses/RTPC/voice limits. Continue all original 24 domains.')
write('docs/resume_checkpoint.json',k)
print('Recorded native audio selection: 9 new checks, 141 total core tests; full game incomplete.')
