from pathlib import Path
import json,hashlib,datetime
r=Path(__file__).resolve().parents[1]
def read(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def write(p,d):(r/p).write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
proof=read('data/4.20/audio_direction_contract.json');assert proof['passed'] and len(proof['cases'])==8
for log,count in [('logs/native-audio-direction-core-tests.log',168),('logs/native-audio-direction-client-tests.log',9)]:assert f'{count} passed; 0 failed' in (r/log).read_text(encoding='utf-8-sig')
build=(r/'logs/native-audio-direction-client-build.log').read_text(encoding='utf-8-sig');assert 'Finished' in build and 'error:' not in build
now=datetime.datetime.now(datetime.timezone.utc).isoformat()
meta={'updated_utc':now,'contract':'data/4.20/audio_direction_contract.json','contract_sha256':sha('data/4.20/audio_direction_contract.json'),'native_direction_cases':8,'default_listener_angle':0.,'core_tests_passed':168,'client_tests_passed':9,'core_tests_log':'logs/native-audio-direction-core-tests.log','client_tests_log':'logs/native-audio-direction-client-tests.log','client_build_log':'logs/native-audio-direction-client-build.log','client_sha256':sha('target/debug/openleague-client.exe'),'core_module_sha256':sha('crates/core/src/audio_listener.rs'),'client_module_sha256':sha('crates/client/src/map_audio.rs'),'position_direction_up_integrated':True,'ambient_playback_enabled':False,'complete':False,'limits':proof['limits']+['Default angle0 used; historical user audio settings not implemented.','Camera render-eye geometry remains current OpenLeague geometry, not qualified as matching original pitch/distance.','Core/client tests validate arithmetic and ECS integration; no new GPU/audio acceptance capture. Old GPU captures retain their original executable hashes.']}
for key in ['core_tests_log','client_tests_log','client_build_log']:meta[key+'_sha256']=sha(meta[key])
write('docs/map_ambient_audio_direction_progress.json',meta)
c=read('docs/coverage.json');c['updated_utc']=now;c['current_evidence']['map_ambient_audio_direction']=meta;c['current_evidence']['core_tests_passed']=168;c['current_evidence']['client_tests_passed']=9
for f in [meta['contract'],'docs/map_ambient_audio_direction_progress.json',meta['core_tests_log'],meta['client_tests_log'],meta['client_build_log']]:
 if f not in c['evidence']:c['evidence'].append(f)
write('docs/coverage.json',c)
p=read('docs/completion_plan.json');p['updated_utc']=now;p['current_evidence']=c['current_evidence'];write('docs/completion_plan.json',p)
k=read('docs/resume_checkpoint.json');k['saved_utc']=now;k['last_verified'].update({'core_tests':168,'client_tests':9,'native_audio_direction_cases':8})
k['latest_changes'].append('Original normal-camera view extraction tail7cfde1..7cfe79 plus native reciprocal root executed for eight focus/eye samples; audio constructor angle0 byte verified. Rust direction_from_positions and two core tests added. NativeListener now computes direction cache and projected up after camera, with one ECS rotation test. Core168/client9 pass; client rebuilt. Original camera geometry/shake/settings and ambient mixer/playback remain incomplete.')
k['restart_next'].insert(0,'Continue ambient audio native distance/gain/pitch/LPF/range/voice-limits integration. NativeListener position/direction/up computed after current camera; eight original view-direction tail samples qualified, core168/client9 pass. Default audio angle0 is constructor verified; original camera pitch/distance, shake finalizer7d2be0 and user settings remain unqualified. No ambient playback enabled. Use source sound graphs and original attenuation curves, not flat WAV looping. Preserve previous GPU proof hashes; rebuilt client hash in direction progress.')
k['build']='Client rebuilt with camera audio position/direction/up integration. Core168/client9 tests passed. Full game, historical camera geometry and ambient mixer/playback remain incomplete; historical GPU captures refer to their original executable hashes.'
for e in k['executables']:
 if e['path']=='target/debug/openleague-client.exe':e['sha256']=meta['client_sha256'];e['bytes']=(r/e['path']).stat().st_size
write('docs/resume_checkpoint.json',k)
print('Direction integration receipts recorded; full game incomplete.')
