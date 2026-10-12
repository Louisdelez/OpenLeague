from pathlib import Path
import json,hashlib,re,datetime
r=Path(__file__).resolve().parents[1]
def read(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def write(p,v):(r/p).write_text(json.dumps(v,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
proof=read('data/4.20/audio_object_height_reference_contract.json')
counts={'setter_cases':36,'height_tick_cases':1080,'final_reference_cases':20}
assert proof['passed'] and all(len(proof[k])==v for k,v in counts.items())
assert sha(proof['provenance']['executable'])==proof['provenance']['sha256']
log=(r/'logs/native-audio-object-height-reference-core-tests.log').read_text(encoding='utf-8-sig')
assert re.search(r'test result: ok\. 209 passed; 0 failed',log)
assert len(re.findall(r'test audio_object_registration::height_reference_tests::\w+ \.\.\. ok',log))==3
now=datetime.datetime.now(datetime.timezone.utc).isoformat()
files=['tools/qualify_native_audio_object_height_reference.py','data/4.20/audio_object_height_reference_contract.json','crates/core/src/audio_object_registration.rs','logs/native-audio-object-height-reference-core-tests.log']
meta={'updated_utc':now,'native_case_counts':counts,'native_cases_total':1136,'core_tests':209,'new_core_tests':3,
 'files':{p:sha(p) for p in files},'native_executable_sha256':proof['provenance']['sha256'],
 'native_regions':{a['start']:a['sha256'] for a in proof['regions']},
 'native_height_behavior':'7074B0 raw flag setter optionally forces height0 (nonzero flag) or1 (zero flag), no position post.707610 nonzero flag resets positive height to0, otherwise unchanged; zero flag and height<1 increments by delta capped1, admits negative delta. On update posts[X,height*-2500,Z] only available/id!=0; local height still updated when unavailable.',
 'native_final_reference_behavior':'Two native final-voice release fragments decrement low30 references, preserve upper2 flag bits, destroy/free at zero. RegisteredSources::release_reference returns destruction decision; caller must discard after true.',
 'bridge':'Flag toggle -> native height tick -> point words -> registered sources -> scaled distance -> acquire -> single unregister retains -> final reference reaches zero tested.',
 'native_stubs':proof['stubs'],'client_integration_enabled':False,'ambient_playback_enabled':False,'complete':False,
 'limits':proof['limits']+[
 'Final release arithmetic/destruction decision qualified from bounded fragments; full surrounding voice teardown and object destructor callbacks not executed.',
 'Returned source descriptor ownership is explicit Rust value, not fully integrated native shared voice handle lifetime.',
 'Finite guards reject nonfinite height/delta/used source positions; unqualified original nonfinite behavior remains outside contract.',
 'No new client build, audible capture or human fidelity acceptance. Previous client13 checks remain historical.']}
write('docs/map_ambient_audio_object_height_reference_progress.json',meta)
c=read('docs/coverage.json');c['updated_utc']=now;c['current_evidence']['core_tests_passed']=209;c['current_evidence']['map_ambient_audio_object_height_reference']=meta
for p in files+['docs/map_ambient_audio_object_height_reference_progress.json']:
 if p not in c['evidence']:c['evidence'].append(p)
write('docs/coverage.json',c)
p=read('docs/completion_plan.json');p['updated_utc']=now;p['current_evidence']=c['current_evidence'];write('docs/completion_plan.json',p)
k=read('docs/resume_checkpoint.json');k['saved_utc']=now;k['last_verified'].update({'core_tests':209,'ambient_audio_height_reference_core_checks':3,'ambient_audio_native_height_reference_cases':1136})
k['latest_changes'].append('Qualified7074B0 flag/force setter36 cases;707610 height transition1080 cases with negative/zero deltas, zero/nonzero flags, ID0/123/FFFFFFFF, engine gate and opaque stack tail; two final-voice source-reference blocks20 cases. Rust set_flag/tick_height/release_reference integrated in source API and ID->height->position->distance->acquire->unregister->last release bridge tested/core209. No live consumer/full destruction callbacks.')
k['restart_next'].insert(0,'Implement actual client ambient audio request/voice/source registry consumer with explicit shared source ownership; capture real emitter positions and lifecycle before playback. Core object creation/positions/height/acquire/unregister/final-reference math now qualified, raw flags retained; no claim full destructor or voice callbacks. Remaining native RNG/reset flags, sound onset seek/loop/duration/fades, buses/voice limits, resampling/panning/PCM callback integration required. Core209; all24 domains incomplete.')
write('docs/resume_checkpoint.json',k)
print('Recorded native height and final reference:1136 cases/core209; full goal incomplete.')