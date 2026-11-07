"""Troy consumer source trace; whole effect coverage and native runtime remain open."""
import pathlib,json,hashlib
R=pathlib.Path('F:/OpenLeague');V=pathlib.Path('F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision113')
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
 candidate=load(V/'troy-runtime-associations.json');verify(pin(V/'troy-runtime-associations.json'));walk(candidate)
 receipts={}
 for s in candidate['receipts']:
  d=load(s['path']);walk(d);receipts[pathlib.Path(s['path']).name]=d
 inventory=receipts['compiled-troy-inventory.json'];missing=receipts['missing-troy-section-native-research.json']
 check('literal_inventory',inventory['troy_files']==12 and inventory['groups']==48 and inventory['missing_sections']==2 and inventory['all_required_troy_covered'] is False)
 check('native_missing_sections',len(missing['rows'])==2 and all(not r['matching_candidates'] and r['candidate_names_checked']==6674 for r in missing['rows']))
 count=0
 for name in ['particle-class-test-receipt.json','simple-consumer-test-receipt.json','complex-mesh-color-test-receipt.json','attribute-policy-test-receipt.json','trail-attachment-test-receipt.json']:
  receipt=receipts[name]
  for run in receipt.get('runs',[receipt]):
   n=len(run['tests']);check('tests_'+str(count),run['exit_code']==0 and n>0 and f'{n} passed; 0 failed' in pathlib.Path(run['log']['path']).read_text(encoding='utf8'));count+=n
 check('52_rust_tests',count==52)
 check('nine_associations',len(candidate['associations'])==9)
 for i,a in enumerate(candidate['associations']):
  check('task_'+a['task_id'],a['task_id']==f'SYS-15.1-{i+1:02}' and a['full_task_scope_complete'] is False)
  for anchor in a['anchors']:check('anchor_'+anchor['role'],anchor['needle'] in (root/anchor['path']).read_text(encoding='utf8').splitlines()[anchor['line']-1])
 return dict(candidates=candidate,receipts=receipts,source_checks=checks,all_troy_consumers_qualified=False,all_required_effects_covered=False),list(pins.values())
_CACHE={}
def audit(q,root='F:/OpenLeague',verify_files=True):
 require(verify_files,'no bypass');require(q['schema']=='openleague_troy_runtime_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported '+k)
 key=str(pathlib.Path(root).resolve())
 if key not in _CACHE:_CACHE[key]=collect(root)
 f,p=_CACHE[key]
 for s in p:require(pin(s['path'])==s,'source changed '+s['path'])
 require(q['facts']==f and q['source_identities']==p,'changed evidence');require(q['associations']==f['candidates']['associations'],'changed associations');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'check census')
 unknowns={u['unknown_id']:u for u in load(pathlib.Path(root)/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  u=unknowns[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==a['task_id'],'unknown binding')
 return dict(verified=True,tasks=9,roles=18,source_pins=len(p),checks_count=len(q['checks']),rust_tests_retained=52,all_troy_consumers_qualified=False)
