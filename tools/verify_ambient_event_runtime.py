"""Check actual source-timed dispatch counts, order and bone binding across loops."""
from pathlib import Path
import json,hashlib,datetime,math
r=Path(__file__).resolve().parents[1]
def read(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
trace=read('logs/ambient-events-runtime.json');data=read('data/4.20/ambient_events.json');placements=read('data/4.20/map_ambient_manifest.json')['placements'];expected={p['id']:p['native_asset'] for p in placements};bindings=trace['bindings']
assert set(bindings)==set(expected) and len(bindings)==17 and trace['sample_seconds']>=32
assert sum(len(b['events']) for b in bindings.values())==53
assert sum(e['attachment_resolved'] for b in bindings.values() for e in b['events'])==51
checks=[]
for instance,native in expected.items():
 binding=bindings[instance];model=data['models'][native];assert binding['native_asset']==native and binding['primary_clip']==model['primary_name'];assert abs(binding['period']-model['period'])<1e-5
 elapsed=binding['last_animation_elapsed'];assert elapsed>=32
 for source in model['events']:
  rows=[e for e in trace['cues'] if e['instance']==instance and e['record_offset']==source['record_offset']]
  assert rows and rows[0]['kind']=='start',(instance,source['name'])
  started=False;starts=0;stops=0;last_elapsed=-1
  for row in rows:
   assert row['elapsed_seconds']>=last_elapsed;last_elapsed=row['elapsed_seconds']
   assert row['name']==source['name'] and row['particle']==source['particle'] and row['flags']==source['flags']
   assert row['attachment_resolved']==source['attachment_source_resolved']
   if row['kind']=='start':
    assert not started;started=True;starts+=1
    assert row['evaluated_frame']>=source['start_frame']-1e-5
    assert not row['loop_reset']
   else:
    assert started;started=False;stops+=1
    if source['end_frame']<0:assert row['loop_reset'] and row['evaluated_frame']>=model['period']/model['time_step']-1e-4
    else:assert row['evaluated_frame']>=source['end_frame']-1e-5
  # Equality can lie within float accumulation noise: inspect both sides of a
  # 0.5ms boundary rather than turn that precision limit into missing events.
  def count(threshold, epsilon):
   if not source['flags']&1:return int(elapsed+epsilon>=threshold)
   return max(0,math.floor((elapsed+epsilon-threshold)/model['period'])+1)
  start_seconds=source['start_frame']*model['time_step'];assert starts in {count(start_seconds,-.0005),count(start_seconds,.0005)},(instance,source['name'],starts,elapsed)
  if source['end_frame']>=0:
   end_seconds=source['end_frame']*model['time_step'];expected_stops={count(end_seconds,-.0005),count(end_seconds,.0005)}
  elif source['flags']&1:
   expected_stops={max(0,math.floor((elapsed+epsilon)/model['period'])) for epsilon in [-.0005,.0005]}
  else:expected_stops={0}
  assert stops in expected_stops,(instance,source['name'],stops,expected_stops)
  if not source['flags']&1:assert starts==1
  checks.append({'instance':instance,'native_asset':native,'event':source['name'],'record_offset':source['record_offset'],'attachment_resolved':source['attachment_source_resolved'],'starts':starts,'stops':stops,'sample_elapsed':elapsed})
proof={'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'client_sha256':hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest(),'event_manifest_sha256':hashlib.sha256((r/'data/4.20/ambient_events.json').read_bytes()).hexdigest(),'trace_sha256':hashlib.sha256((r/'logs/ambient-events-runtime.json').read_bytes()).hexdigest(),'sample_seconds':trace['sample_seconds'],'players':17,'event_instances':len(checks),'resolved_attachments':51,'unresolved_attachments':2,'dispatch_rows':len(trace['cues']),'checks':checks,'passed':True,'complete':False,'limits':['This measures native source-timed callback dispatch; audio/particle emitters are not yet consuming those callbacks.','Primary native loops only; complete selector/secondary/wrapped/seek graph fidelity remains incomplete.','Two original Chain4-3 bone references remain unresolved without arbitrary aliases.']}
(r/'docs/map_ambient_event_runtime_validation.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS actual event runtime:',len(checks),'event instances;',len(trace['cues']),'start/stop dispatches;',trace['sample_seconds'],'seconds')
