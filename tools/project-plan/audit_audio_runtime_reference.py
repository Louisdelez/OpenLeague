"""Audio inventory provenance and exact consumer links; playback and complete language coverage remain open."""
import pathlib,json,hashlib
R=pathlib.Path('F:/OpenLeague');V=pathlib.Path('F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision118')
load=lambda p:json.loads(pathlib.Path(p).read_bytes())
def require(v,m):
 if not v:raise ValueError(m)
def pin(p):
 p=pathlib.Path(p).resolve();b=p.read_bytes();return dict(path=str(p),bytes=len(b),sha256=hashlib.sha256(b).hexdigest())
def collect(root=R):
 root=pathlib.Path(root);pins={};checks=[]
 def check(k,v):require(v,k);checks.append(k)
 def verify(s):
  key=str(pathlib.Path(s['path']).resolve()).casefold()
  if key not in pins:pins[key]=pin(s['path'])
  n=pins[key];check('pin_'+s['path'],n['bytes']==s['bytes'] and n['sha256']==s['sha256'])
 def walk(x):
  if isinstance(x,dict):
   if all(k in x for k in ['path','bytes','sha256']):verify(x)
   else:
    for v in x.values():walk(v)
  elif isinstance(x,list):
   for v in x:walk(v)
 candidate=load(V/'audio-runtime-associations.json');verify(pin(V/'audio-runtime-associations.json'));walk(candidate)
 receipts={}
 for s in candidate['receipts']:
  d=load(s['path']);walk(d);receipts[pathlib.Path(s['path']).name]=d
 check('nine_associations',len(candidate['associations'])==9)
 runs=receipts['audio-runtime-test-receipt.json']['runs']+receipts['audio-spatial-stop-test-receipt.json']['runs']
 check('twentyone_tests',sum(len(r['tests']) for r in runs)==21 and all(r['exit_code']==0 for r in runs))
 check('no_hardware_claim',receipts['runtime-consumer-research.json']['audio_device_executed'] is False)
 for i,a in enumerate(candidate['associations']):
  check('task_'+a['task_id'],a['task_id']==f'SYS-16.2-{i+1:02}' and a['full_task_scope_complete'] is False)
  for anchor in a['anchors']:check('anchor_'+anchor['role'],anchor['needle'] in (root/anchor['path']).read_text(encoding='utf8').splitlines()[anchor['line']-1])
 return dict(candidates=candidate,receipts=receipts,source_checks=checks,all_audio_runtimes_qualified=False,all_required_effects_covered=False),list(pins.values())
_CACHE={}
def audit(q,root='F:/OpenLeague',verify_files=True):
 require(verify_files,'no bypass');require(q['schema']=='openleague_audio_runtime_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported '+k)
 key=str(pathlib.Path(root).resolve())
 if key not in _CACHE:_CACHE[key]=collect(root)
 f,p=_CACHE[key]
 for s in p:require(pin(s['path'])==s,'source changed '+s['path'])
 require(q['facts']==f and q['source_identities']==p,'changed evidence');require(q['associations']==f['candidates']['associations'],'changed associations');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'check census')
 unknowns={u['unknown_id']:u for u in load(pathlib.Path(root)/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  u=unknowns[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==a['task_id'],'unknown binding')
 return dict(verified=True,tasks=9,roles=14,source_pins=len(p),checks_count=len(q['checks']),rust_tests_retained=21,all_audio_runtimes_qualified=False)
