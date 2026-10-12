from pathlib import Path
import json,hashlib,re,datetime
r=Path(__file__).resolve().parents[1]
def read(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def write(p,v):(r/p).write_text(json.dumps(v,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
proof=read('docs/map_ambient_audio_emitter_runtime_validation.json');launch=read('logs/emitter_runtime_processes.json')
assert proof['passed'] and proof['samples']==64 and proof['client_sha256']==sha('target/debug/openleague-client.exe')
assert proof['client_pid']==launch['client']==9696
assert len(proof['moving_source_instances'])==18 and len(proof['unresolved_source_instances'])==2
tests=(r/'logs/native-audio-emitter-runtime-client-tests.log').read_text(encoding='utf-8-sig')
build=(r/'logs/native-audio-emitter-runtime-client-build.log').read_text(encoding='utf-8-sig')
assert re.search(r'test result: ok\. 13 passed; 0 failed',tests)
assert re.search(r'Finished .*dev.*profile',build)
now=datetime.datetime.now(datetime.timezone.utc).isoformat()
files=['crates/client/src/map_audio.rs','crates/client/src/main.rs','tools/verify_audio_emitter_runtime.py','logs/audio_emitter_runtime_trace.json','docs/map_ambient_audio_emitter_runtime_validation.json','logs/native-audio-emitter-runtime-client-tests.log','logs/native-audio-emitter-runtime-client-build.log','logs/emitter_runtime_processes.json','logs/emitter-runtime-client.out.log','logs/emitter-runtime-client.err.log']
meta={'updated_utc':now,'files':{p:sha(p) for p in files},'client_pid':launch['client'],'server_pid':launch['server'],
 'client_sha256':proof['client_sha256'],'server_sha256':launch['server_sha256'],'core_tests':209,'client_tests':13,
 'runtime_samples':64,'runtime_coordinate_pairs':171,'runtime_event_records':460,
 'distinct_resolved_source_instances':26,'moving_source_instances':18,'unresolved_source_instances':2,
 'snapshot_tick_range':proof['snapshot_tick_range'],'capture_elapsed_range':proof['capture_elapsed_range'],
 'standalone_client_rebuilt':True,'client_source_position_integration_enabled':True,
 'client_voice_registry_playback_integration_enabled':False,'ambient_playback_enabled':False,'complete':False,
 'window_evidence':{'title':'OpenLeague - developpement 4.20','handle_observed':15991226,'foreground_verified':False},
 'limits':proof['limits']+[
 'New client binary SHA applies only to current emitter capture. Prior listener/GPU/terrain/fog/gameplay evidence keeps original binary hashes.',
 'Vulkan loader reports missing TikTok LIVE Studio layer JSON; this pre-existing driver-layer diagnostic persists. No global driver modification.',
 'Server binary not rebuilt or restarted; finished-match tick30473 constant while ambient skeleton animations advance.']}
write('docs/map_ambient_audio_emitter_runtime_progress.json',meta)
executables=[]
for p in ['target/debug/openleague-server.exe','target/debug/openleague-client.exe','launcher/src-tauri/target/debug/openleague-launcher.exe']:
 executables.append({'path':p,'bytes':(r/p).stat().st_size,'sha256':sha(p)})
old_path=r/'docs/build_receipt.json'
backup='docs/build_receipt.before-emitter-runtime.json'
if not (r/backup).exists():(r/backup).write_bytes(old_path.read_bytes())
b=read('docs/build_receipt.json');b['date']=now;b['executables']=executables;b['core_tests']=209;b['client_tests']=13
b['latest_build_log']='logs/native-audio-emitter-runtime-client-build.log';b['build_scope']='Client only; server and launcher unchanged'
b['current_client_runtime_validation']='docs/map_ambient_audio_emitter_runtime_validation.json'
b['evidence_notice']='Current client unit13/source-coordinate64-sample evidence recorded. Previous gameplay/network/GPU reports are historical and retain original hashes; no current full-game qualification claimed.'
for p in ['logs/native-audio-object-height-reference-core-tests.log','logs/native-audio-emitter-runtime-client-tests.log','docs/map_ambient_audio_emitter_runtime_validation.json']:
 if p not in b['test_logs']:b['test_logs'].append(p)
write('docs/build_receipt.json',b)
c=read('docs/coverage.json');c['updated_utc']=now;c['current_evidence']['map_ambient_audio_emitter_runtime']=meta
c['current_evidence']['client_tests_passed']=13
for p in files+['docs/map_ambient_audio_emitter_runtime_progress.json',backup]:
 if p not in c['evidence']:c['evidence'].append(p)
write('docs/coverage.json',c)
p=read('docs/completion_plan.json');p['updated_utc']=now;p['current_evidence']=c['current_evidence'];write('docs/completion_plan.json',p)
k=read('docs/resume_checkpoint.json');k['saved_utc']=now;k['executables']=executables
k['last_verified'].update({'client_tests':13,'ambient_audio_emitter_runtime_samples':64,'ambient_audio_emitter_runtime_coordinate_pairs':171,'ambient_audio_emitter_runtime_events':460,'ambient_audio_emitter_runtime_moving_sources':18})
k['latest_changes'].append('Rebuilt/launched client9696 SHAd2db57bdf7363fad868c6caedb27682dc340823f80c8da45ae04a07ef2db27a5 on verified server13040/UDP5896. Captured64 samples/32s after transforms;171 XYZ pairs bit-exact inverse scene mapping and original706DF0 packing on captured inputs;460 native event metadata records;26 resolved source instances/18 moving/two unresolved Chain4-3 attachments. Client13 tests pass. No source-registry playback/audio or new GPU pixel evidence; server tick30473 constant.')
k['restart_next'].insert(0,'Connect actual client ambient request/voice/source-registry consumer. Actual emitter source positions now runtime-verified64 samples/171 pairs/460 events on current client9696;18 sources move andtwo nativeChain4-3 references remain missing, no aliases. Core209/client13; live client built, server unchanged. Need full native RNG/reset/voice onset seek/fades/panning/resampling/PCM lifecycle, source ownership and audibility; retain all24-domain scope.')
write('docs/resume_checkpoint.json',k)
print('Recorded live emitter capture/current client binary; complete game remains unqualified.')