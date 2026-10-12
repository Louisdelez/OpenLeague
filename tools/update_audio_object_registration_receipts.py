from pathlib import Path
import json,hashlib,re,datetime
r=Path(__file__).resolve().parents[1]
def read(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def write(p,v):(r/p).write_text(json.dumps(v,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
proof=read('data/4.20/audio_object_registration_contract.json')
assert proof['passed'] and len(proof['factory_cases'])==40 and len(proof['registration_cases'])==120
assert sha(proof['provenance']['executable'])==proof['provenance']['sha256']
log=(r/'logs/native-audio-object-registration-core-tests.log').read_text(encoding='utf-8-sig')
assert re.search(r'test result: ok\. 202 passed; 0 failed',log)
assert len(re.findall(r'test audio_object_registration::tests::\w+ \.\.\. ok',log))==3
now=datetime.datetime.now(datetime.timezone.utc).isoformat()
files=['tools/qualify_native_audio_object_registration.py','data/4.20/audio_object_registration_contract.json','crates/core/src/audio_object_registration.rs','logs/native-audio-object-registration-core-tests.log']
meta={'updated_utc':now,'native_factory_cases':40,'native_registration_worker_cases':120,'core_tests':202,'new_core_tests':3,
 'files':{p:sha(p) for p in files},'native_executable_sha256':proof['provenance']['sha256'],
 'native_regions':{a['start']:a['sha256'] for a in proof['regions']},
 'native_behavior':'7055D0/707080 counter1224D20 captures ID then advances even allocation failure/wrap. Constructor registers(object,mask1) only available;0/FFFFFFFF rejected byAEAEE0. Worker11 B09BF0 retains existing positions/mode and updates mask/dirty; newAF5CE0 has empty positions,mode low3 zero,mask1,dirtyC0000001; allocator upper5 mode bits retained.',
 'bridge':'Rust Factory -> Registry -> native point-only producer -> RegisteredSources -> native distance tested.',
 'native_stubs':proof['stubs'],'client_integration_enabled':False,'ambient_playback_enabled':False,
 'complete':False,'limits':proof['limits']+[
 'Core Rust registry uses BTreeMap for lookup; native hash layout is verified separately. Allocation callback supplies native allocation outcome/mode seed; actual Rust allocator failure behavior and native heap ownership not qualified.',
 'Registry represents source fields only, not every extended original100-byte object field.',
 'Factory orientation supplied explicitly; no initial counter/default direction global inferred.',
 'No current client runtime bridge, new standalone binary or audible evidence. Prior client13 tests remain historical.']}
write('docs/map_ambient_audio_object_registration_progress.json',meta)
c=read('docs/coverage.json');c['updated_utc']=now;c['current_evidence']['core_tests_passed']=202;c['current_evidence']['map_ambient_audio_object_registration']=meta
for f in files+['docs/map_ambient_audio_object_registration_progress.json']:
 if f not in c['evidence']:c['evidence'].append(f)
write('docs/coverage.json',c)
p=read('docs/completion_plan.json');p['updated_utc']=now;p['current_evidence']=c['current_evidence'];write('docs/completion_plan.json',p)
k=read('docs/resume_checkpoint.json');k['saved_utc']=now;k['last_verified'].update({'core_tests':202,'ambient_audio_object_registration_core_checks':3,'ambient_audio_native_object_factory_cases':40,'ambient_audio_native_object_registration_worker_cases':120})
k['latest_changes'].append('Native object factory7055D0/constructor707080/registrationAEAEE0 packet11/workerB09BF0/AF5CE0/pool insertionB09D10 qualified40 factory+120 worker cases. Rust audio_object_registration.rs preserves counter advancement/wrap even allocation failure, invalid register IDs, existing descriptor masks, new descriptor lower mode/default dirty semantics. ID->point->storage->distance bridge tested/core202 pass; client not integrated.')
k['restart_next'].insert(0,'Qualify game-object update707420 and destruction707170, unregister packet12 A EBC10 / workerB07417/B0A1A0 and registered-source ownership/refcount. Connect source positions/voice factories/seconds refresh to native request consumer after proving disposal and playable event lifetime. Core202; new registry captures only source fields, actual allocator callback semantics explicit. Full24-domain objective incomplete.')
write('docs/resume_checkpoint.json',k)
print('Recorded native object registration:160 cases/core202; full goal incomplete.')