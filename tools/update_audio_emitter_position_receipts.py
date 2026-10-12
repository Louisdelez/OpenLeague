from pathlib import Path
import json,hashlib,re,datetime
r=Path(__file__).resolve().parents[1]
def read(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def write(p,v):(r/p).write_text(json.dumps(v,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
native=read('data/4.20/audio_emitter_position_contract.json')
assert native['passed'] and len(native['cases'])==72
assert sha(native['provenance']['executable'])==native['provenance']['sha256']
for path,count in [('logs/native-audio-emitter-position-core-tests.log',195),('logs/native-audio-emitter-position-client-tests.log',13)]:
 assert re.search(r'test result: ok\. '+str(count)+r' passed; 0 failed',(r/path).read_text(encoding='utf-8-sig'))
assert sum(len(c['messages']) for c in native['cases'])==3
context=read('data/4.20/ambient_audio_context.json')
cones=[]
def walk(x):
 if isinstance(x,dict):
  if x.get('name')=='bIsConeEnabled':cones.append(x)
  for k,v in x.items():
   if k!='schema_xml':walk(v)
 elif isinstance(x,list):
  for v in x:walk(v)
walk(context)
assert len(cones)==4 and all(c['value']=='0' and c['byte_verified'] for c in cones)
now=datetime.datetime.now(datetime.timezone.utc).isoformat()
files=['data/4.20/audio_emitter_position_contract.json','crates/core/src/audio_emitter_position.rs','crates/client/src/map_audio.rs','crates/client/src/main.rs','tools/qualify_native_audio_emitter_positions.py','logs/native-audio-emitter-position-core-tests.log','logs/native-audio-emitter-position-client-tests.log']
meta={'updated_utc':now,'native_route_cases':72,'native_queued_position_messages':3,
 'core_tests':195,'client_tests':13,'native_executable_sha256':native['provenance']['sha256'],
 'files':{p:sha(p) for p in files},'native_position_layout':native['position_layout'],
 'native_stubs':native['stubs'],'native_orientation':'uninitialized local stack tail; no authored orientation inferred',
 'attenuation_cones_disabled_fields':cones,'client_source_integration_enabled':True,
 'client_integration':'Active event-instance/record-offset source table; start/end consumed after timeline dispatch; GlobalTransform bone positions converted to native coordinates after TransformSystems::Propagate.',
 'standalone_client_rebuilt':False,'ambient_playback_enabled':False,'complete':False,
 'limits':native['limits']+[
 'New ECS tests verify lifecycle, two independent event offsets, moving source coordinates, missing/deleted/nonfinite bones and hierarchical transform scheduling. No actual scene/runtime capture for this new module.',
 'Source-coordinate table represents active emitters, not voice lifetimes. SoundOnCreate voices may outlive emitters; Persistent teardown needs separate request/release integration.',
 'No invented audio object IDs; the native position producer is exercised with an explicit test route only. Live object registration and queue worker remain missing.',
 'Four source attenuation cone flags are byte-verified zero; downstream cone/panning DSP not executed.',
 'Running standalone executable remains the prior listener build; no new framebuffer or audible evidence.']}
write('docs/map_ambient_audio_emitter_position_progress.json',meta)
c=read('docs/coverage.json')
c['updated_utc']=now;c['current_evidence']['map_ambient_audio_emitter_position']=meta
c['current_evidence']['core_tests_passed']=195;c['current_evidence']['client_tests_passed']=13
for p in files+['docs/map_ambient_audio_emitter_position_progress.json']:
 if p not in c['evidence']:c['evidence'].append(p)
write('docs/coverage.json',c)
p=read('docs/completion_plan.json')
p['updated_utc']=now;p['current_evidence']=c['current_evidence'];write('docs/completion_plan.json',p)
k=read('docs/resume_checkpoint.json');k['saved_utc']=now;k['state']='active'
k['last_verified'].update({'core_tests':195,'client_tests':13,'ambient_audio_native_emitter_position_cases':72,'ambient_audio_emitter_position_client_checks':3})
k['latest_changes'].append('Native 6CE200->706DF0->AEB1C0/AEB1E0 point-only queue13 qualified over72 cases: three message copies preserve XYZ, uninitialized orientation tail explicit, refresh callback stubbed. Core195/client13 pass. Client active-emitter table now consumes event start/end and follows bone GlobalTransform after propagation; unresolved/deleted/invalid bones have no fabricated position. No live audio registration/mixer or rebuilt standalone client.')
k['restart_next'].insert(0,'Implement native queue13 worker and source-object position descriptor storage, connect active-emitter source table with request/voice registration lifetimes; do not equate emitter end with SoundOnCreate voice stop. Qualified native producer tail is uninitialized. Four attenuation cone flags native zero. Core195/client13; prior running binary unchanged. Full24-domain goal remains incomplete.')
write('docs/resume_checkpoint.json',k)
print('Recorded emitter position qualification and client source integration: core195/client13; full game incomplete.')