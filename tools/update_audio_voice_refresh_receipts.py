from pathlib import Path
import json,hashlib,re,datetime
r=Path(__file__).resolve().parents[1]
def read(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def write(p,x):(r/p).write_text(json.dumps(x,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
proof=read('data/4.20/audio_voice_refresh_contract.json')
assert proof['passed'] and len(proof['cases'])==1440 and proof['parameter_name']=='seconds'
assert sha(proof['provenance']['executable'])==proof['provenance']['sha256']
log=(r/'logs/native-audio-voice-refresh-core-tests.log').read_text(encoding='utf-8-sig')
assert re.search(r'test result: ok\. 199 passed; 0 failed',log)
assert len(re.findall(r'test audio_voice_refresh::tests::\w+ \.\.\. ok',log))==2
now=datetime.datetime.now(datetime.timezone.utc).isoformat()
files=['tools/qualify_native_audio_voice_refresh.py','data/4.20/audio_voice_refresh_contract.json','crates/core/src/audio_voice_refresh.rs','logs/native-audio-voice-refresh-core-tests.log']
meta={'updated_utc':now,'native_refresh_cases':1440,'core_tests':199,'new_core_tests':2,
 'native_executable_sha256':proof['provenance']['sha256'],'files':{p:sha(p) for p in files},
 'native_regions':{a['start']:a['sha256'] for a in proof['regions']},
 'parameter_name':'seconds','parameter_id':745018932,'rtpc_packet_type':2,
 'native_refresh_behavior':'Original706D70 reads f32 time, subtracts creation timestamp+44, invokes706F00(seconds,value), queries playing ID throughAEBCA0/AF48C0, compares raw returned+8 with voice+C; mismatch sets+48=1. Matching does not clear prior flag. Setter unavailable/error does not change comparison.',
 'bridge':'Refresh updates existing audio_release::Voice released flag; release respects it. Raw record meaning not inferred.',
 'native_stubs':proof['stubs'],'client_integration_enabled':False,'ambient_playback_enabled':False,
 'complete':False,'limits':proof['limits']+['Rust rejects nonfinite/overflowing clocks before mutations; native fatal/assertion and nonfinite inputs not part of1440 qualified cases.',
 'No new standalone executable or live audio capture; prior client13 tests remain historical.']}
write('docs/map_ambient_audio_voice_refresh_progress.json',meta)
c=read('docs/coverage.json');c['updated_utc']=now;c['current_evidence']['core_tests_passed']=199;c['current_evidence']['map_ambient_audio_voice_refresh']=meta
for p in files+['docs/map_ambient_audio_voice_refresh_progress.json']:
 if p not in c['evidence']:c['evidence'].append(p)
write('docs/coverage.json',c)
p=read('docs/completion_plan.json');p['updated_utc']=now;p['current_evidence']=c['current_evidence'];write('docs/completion_plan.json',p)
k=read('docs/resume_checkpoint.json');k['saved_utc']=now;k['last_verified'].update({'core_tests':199,'ambient_audio_voice_refresh_core_checks':2,'ambient_audio_native_voice_refresh_cases':1440})
k['latest_changes'].append('Original706D70 refresh/706F00 setter/AEB2B0/AEB240 RTPC packet2/AEBCA0/AF48C0 collision lookup qualified1440 cases; true parameter name seconds ID745018932, timestamp delta and raw-record comparison exact. audio_voice_refresh.rs links to release Voice flags; core199 pass. Raw record meaning not inferred; no live mixer.')
k['restart_next'].insert(0,'Qualify object factory7055D0 (manager vtable10AF384+28) and constructor707080 (vtable10AF310): wrapper ID from1224D20, factory increments even allocation failure, constructor copies orientation2D773B4 not source position, engine availability -> registerAEAEE0(object,1). Full original constructor/registration queue and worker needed before live bridge; inspect wrapperposition slot+C and destruction707170. Voice refreshseconds/record comparison now qualified1440 cases/core199. Full24-domain goal incomplete.')
write('docs/resume_checkpoint.json',k)
print('Recorded seconds voice-refresh qualification:1440 cases/core199; full game incomplete.')