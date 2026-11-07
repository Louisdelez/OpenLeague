"""Animation evaluation trace with preserved rotation diagnostics;no universal fidelity claim."""
import pathlib,json,hashlib
R=pathlib.Path('F:/OpenLeague');V=pathlib.Path('F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision111')
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
 candidate=load(V/'animation-evaluation-associations.json');verify(pin(V/'animation-evaluation-associations.json'));walk(candidate)
 receipts={}
 for s in candidate['receipts']:
  d=load(s['path']);walk(d);receipts[pathlib.Path(s['path']).name]=d
 structure=receipts['structure-clock-test-receipt.json'];ezreal=receipts['ezreal-r-animation-test-receipt.json'];census=receipts['current-animation-samplers.json'];detail=receipts['rotation-anomaly-detail.json'];influence=receipts['rotation-influence-research.json']
 for name,t,n in [('structure',structure,3),('ezreal_r',ezreal,6)]:
  log=pathlib.Path(t['log']['path']).read_text(encoding='utf8');check(name+'_tests',t['exit_code']==0 and len(t['tests'])==n and str(n)+' passed; 0 failed' in log)
 check('sampler_census',census['summary']==dict(entries=164,assets=156,errors=0,clips=4503,clips_with_issues=21))
 check('rotation_diagnostics_retained',len(detail['rows'])==3 and sum(len(x['animations']) for x in detail['rows'])==21)
 check('influence_scope',len(influence['rows'])==3 and influence['rows'][0]['nodes'][0]['subtree_weighted_vertices']==39 and all(x['nodes'][0]['subtree_weighted_vertices']==0 for x in influence['rows'][1:]))
 check('eight_associations',len(candidate['associations'])==8)
 for row in receipts['animation-evaluation-research.json']['anchors']:
  check('research_anchor_'+str(row['line']),row['needle'] in pathlib.Path(row['source']['path']).read_text(encoding='utf8').splitlines()[row['line']-1])
 for i,a in enumerate(candidate['associations']):
  check('task_'+a['task_id'],a['task_id']==f'SYS-14.4-{i+1:02}' and a['full_task_scope_complete'] is False)
  for anchor in a['anchors']:check('anchor_'+anchor['role'],anchor['needle'] in (root/anchor['path']).read_text(encoding='utf8').splitlines()[anchor['line']-1])
 return dict(candidates=candidate,receipts=receipts,source_checks=checks,all_animation_fidelity_qualified=False,all_skins_qualified=False),list(pins.values())
_CACHE={}
def audit(q,root='F:/OpenLeague',verify_files=True):
 require(verify_files,'no bypass');require(q['schema']=='openleague_animation_evaluation_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported '+k)
 key=str(pathlib.Path(root).resolve())
 if key not in _CACHE:_CACHE[key]=collect(root)
 f,p=_CACHE[key]
 for s in p:require(pin(s['path'])==s,'source changed '+s['path'])
 require(q['facts']==f and q['source_identities']==p,'changed evidence');require(q['associations']==f['candidates']['associations'],'changed associations');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'check census')
 unknowns={u['unknown_id']:u for u in load(pathlib.Path(root)/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  u=unknowns[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==a['task_id'],'unknown binding')
 return dict(verified=True,tasks=8,roles=16,source_pins=len(p),checks_count=len(q['checks']),rust_tests_retained=9,all_animation_fidelity_qualified=False)
