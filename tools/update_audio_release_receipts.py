from pathlib import Path
import json,hashlib,datetime,re
r=Path(__file__).resolve().parents[1]
def read(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def write(p,x):(r/p).write_text(json.dumps(x,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
proof=read('docs/map_ambient_audio_release_validation.json');assert proof['passed'] and proof['release_cases']==64 and proof['source_field_checks']==94
log=(r/'logs/native-audio-release-tests.log').read_text(encoding='utf-8-sig');assert re.search(r'test result: ok\. 159 passed; 0 failed',log)
assert len(re.findall(r'test audio_release::tests::\w+ \.\.\. ok',log))==5
now=datetime.datetime.now(datetime.timezone.utc).isoformat()
meta={'updated_utc':now,'contract':'data/4.20/audio_release_contract.json','contract_sha256':sha('data/4.20/audio_release_contract.json'),'module':'crates/core/src/audio_release.rs','module_sha256':sha('crates/core/src/audio_release.rs'),'native_release_cases':64,'native_release_invocations':128,'native_event_hash_samples':10,'source_stop_events':4,'source_stop_actions':6,'source_fields_byte_checked':94,'native_instruction_anchors':16,'rust_release_tests':5,'core_tests':159,'test_log':'logs/native-audio-release-tests.log','test_log_sha256':sha('logs/native-audio-release-tests.log'),'native_executable_sha256':proof['provenance']['sha256'],'runtime_audio_enabled':False,'client_integration_enabled':False,'complete':False,'limits':proof['limits']}
write('docs/map_ambient_audio_release_progress.json',meta)
c=read('docs/coverage.json');c['updated_utc']=now;c['current_evidence']['map_ambient_audio_release']=meta;c['current_evidence']['core_tests_passed']=159
for p in ['docs/map_ambient_audio_release_validation.json','docs/map_ambient_audio_release_progress.json','logs/native-audio-release-tests.log']:
 if p not in c['evidence']:c['evidence'].append(p)
write('docs/coverage.json',c)
p=read('docs/completion_plan.json');p['updated_utc']=now;p['current_evidence']=c['current_evidence'];write('docs/completion_plan.json',p)
k=read('docs/resume_checkpoint.json');k['saved_utc']=now;k['last_verified'].update({'core_tests':159,'ambient_audio_release_checks':5,'ambient_audio_native_release_cases':64,'ambient_audio_stop_events':4,'ambient_audio_stop_actions':6,'ambient_audio_stop_fields_byte_checked':94})
k['latest_changes'].append('Native voice release 706f90 executed in 64 scenarios/two invocations each with stubbed engine, PostEvent and queue: Stop event posting when available, fallback StopPlayingID duration0/curve4 when missing/failed, no repeated release, unavailable engine leaves pending. Original ASCII event hashes verified for ten names. Stop_ prefix replacement instruction-qualified at704a80; four source stop events/six actions recovered with94 byte checks: chains300ms, Shopkeeper500ms, linear4, scope259. Rust audio_release.rs matches source traces; five new tests, core159 passed. Live audio/fades unintegrated.')
k['restart_next'].insert(0,'Integrate audio lifetimes from audio_release.rs/audio_release_contract.json with audio_requests/routing/selection/curves. Persistent voice release uses Stop_sfx_TT_Shopkeeper_idle1/2 native 500ms linear actions on target8082/8083; chains Stop events300ms on two layers recovered but Create requests are not retained handles. Fallback StopPlayingID is immediate only when event unavailable/post fails. Routing boolean only toggles listener mask. Qualify mixer gain/pitch/LPF, listener/distance units, native voice limits and virtual timeline before enabling original playback. 159 core tests; full24-domain game remains incomplete.')
write('docs/resume_checkpoint.json',k)
print('Recorded original audio release and stop actions; 159 core tests, full game incomplete.')
