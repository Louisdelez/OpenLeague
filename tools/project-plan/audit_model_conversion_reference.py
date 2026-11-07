"""Partial conversion source trace with preserved Veigar failure; no all-skin claim."""
import pathlib,json,hashlib
R=pathlib.Path('F:/OpenLeague');V=pathlib.Path('F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision109')
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
 candidate=load(V/'model-conversion-associations.json');verify(pin(V/'model-conversion-associations.json'));walk(candidate)
 receipts={}
 for s in candidate['receipts']:
  d=load(s['path']);walk(d);receipts[pathlib.Path(s['path']).name]=d
 mesh=receipts['native-mesh-comparison.json'];rig=receipts['native-rig-comparison.json'];hom=receipts['homonymous-joint-comparison.json'];structure=receipts['current-glb-structure.json'];scale=receipts['scale-test-receipt.json'];current=receipts['current-scale-comparison.json']
 check('122_meshes',len(mesh['rows'])==122 and all(r['all_compared_fields_equal'] for r in mesh['rows']))
 check('120_initial_rigs',len(rig['rows'])==122 and sum(r['qualified_compared_fields'] for r in rig['rows'])==120)
 ez=next(r for r in hom['rows'] if r['champion']=='ezreal');ve=next(r for r in hom['rows'] if r['champion']=='veigar')
 check('ezreal_identity_resolved',ez['native_joint_count']==ez['current_joint_count']==72 and not ez['missing_native_paths'] and not ez['extra_current_paths'] and not ez['influence_path_differences'])
 check('veigar_defect_open',ve['native_joint_count']==50 and ve['current_joint_count']==49 and len(ve['missing_native_paths'])==1 and len(ve['influence_path_differences'])==33)
 check('156_structure_census',len(structure['entries'])==164 and len(structure['assets'])==156 and all('error' not in r for r in structure['assets']))
 log=pathlib.Path(scale['log']['path']).read_text(encoding='utf8');check('ten_scale_tests',scale['passed'] and scale['tests']==10 and 'Ran 10 tests' in log and '\nOK\n' in log)
 check('current_scale_matches',current['all_122_bits_match'] and not current['changes'] and len(current['rows'])==122)
 for i,a in enumerate(candidate['associations']):
  check('task_'+a['task_id'],a['task_id']==f'SYS-14.2-{i+1:02}' and a['full_task_scope_complete'] is False)
  for anchor in a['anchors']:check('anchor_'+anchor['role'],anchor['needle'] in (root/anchor['path']).read_text(encoding='utf8').splitlines()[anchor['line']-1])
 return dict(candidates=candidate,receipts=receipts,source_checks=checks,veigar_defect_resolved=False,all_skins_qualified=False),list(pins.values())
_CACHE={}
def audit(q,root='F:/OpenLeague',verify_files=True):
 require(verify_files,'no bypass');require(q['schema']=='openleague_model_conversion_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported '+k)
 key=str(pathlib.Path(root).resolve())
 if key not in _CACHE:_CACHE[key]=collect(root)
 f,p=_CACHE[key]
 for s in p:require(pin(s['path'])==s,'source changed '+s['path'])
 require(q['facts']==f and q['source_identities']==p,'changed evidence');require(q['associations']==f['candidates']['associations'],'changed associations');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'check census')
 unknowns={u['unknown_id']:u for u in load(pathlib.Path(root)/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  u=unknowns[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==a['task_id'],'unknown binding')
 return dict(verified=True,tasks=6,roles=12,source_pins=len(p),checks_count=len(q['checks']),python_tests=10,veigar_defect_resolved=False)
