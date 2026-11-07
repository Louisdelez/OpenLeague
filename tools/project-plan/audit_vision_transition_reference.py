"""Reader for scoped current vision-transition evidence; not server equivalence."""
import pathlib,json,hashlib,re
R=pathlib.Path('F:/OpenLeague');V=pathlib.Path('F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision107')
load=lambda p:json.loads(pathlib.Path(p).read_bytes())
def require(v,m):
 if not v:raise ValueError(m)
def pin(p):
 p=pathlib.Path(p).resolve();b=p.read_bytes();return dict(path=str(p),bytes=len(b),sha256=hashlib.sha256(b).hexdigest())
def collect(root=R):
 root=pathlib.Path(root);pins={};checks=[]
 def keep(p):s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(k,v):require(v,k);checks.append(k)
 candidate=load(V/'vision-transition-associations.json')
 check('producer',keep(candidate['producer']['path'])==candidate['producer']);keep(V/'vision-transition-associations.json')
 for s in candidate['current_sources']:check('source_'+s['path'],keep(s['path'])==s)
 tests=[]
 for s in candidate['receipts']:
  check('receipt_'+s['path'],keep(s['path'])==s);d=load(s['path'])
  for src in d['sources']:check('input_'+src['path'],keep(src['path'])==src)
  for c in d.get('checks',[d]):
   for k in ['binary','log']:check(k+'_'+c[k]['path'],keep(c[k]['path'])==c[k])
   text=pathlib.Path(c['log']['path']).read_text(encoding='utf-8-sig');names=c.get('test_names',c.get('tests'));check('test_exit_'+c['log']['path'],c['exit_code']==0 and f'{len(names)} passed; 0 failed' in text)
   for name in names:check('test_'+name,'test '+name+' ... ok' in text)
   tests.extend(names)
 check('seven_behavior_tests',len(tests)==7)
 for i,a in enumerate(candidate['associations']):
  check('scope_'+a['task_id'],a['full_task_scope_complete'] is False and a['entry_boundary_only']==(i==2) and a['native_bindings']==[])
  for anchor in a['anchors']:check('anchor_'+anchor['role'],anchor['needle'] in (root/anchor['path']).read_text(encoding='utf8').splitlines()[anchor['line']-1])
 check('task_census',[a['task_id'] for a in candidate['associations']]==[f'SYS-13.4-{i:02}' for i in range(1,8)])
 return dict(candidates=candidate,tests=tests,source_checks=checks,explicit_local_contract=True,historical_server_policy_qualified=False,delayed_spectator_qualified=False),list(pins.values())
def audit(q,root='F:/OpenLeague',verify_files=True):
 require(verify_files,'no bypass');require(q['schema']=='openleague_vision_transition_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported scope '+k)
 f,p=collect(root)
 require(q['facts']==f and q['source_identities']==p,'changed facts/sources');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'check census');require(q['associations']==f['candidates']['associations'],'associations changed')
 unknowns={u['unknown_id']:u for u in load(pathlib.Path(root)/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  u=unknowns[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==a['task_id'],'unknown binding')
 return dict(verified=True,checks_count=len(q['checks']),tasks=7,roles=14,source_pins=len(p),rust_tests=7)
