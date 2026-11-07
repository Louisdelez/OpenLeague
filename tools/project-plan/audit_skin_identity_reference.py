"""Reproducible partial skin identity trace; no form ownership/availability inference."""
import pathlib,json,hashlib,sys
R=pathlib.Path('F:/OpenLeague');V=pathlib.Path('F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision108')
load=lambda p:json.loads(pathlib.Path(p).read_bytes())
def require(v,m):
 if not v:raise ValueError(m)
def pin(p):
 p=pathlib.Path(p).resolve();b=p.read_bytes();return dict(path=str(p),bytes=len(b),sha256=hashlib.sha256(b).hexdigest())
def collect(root=R):
 root=pathlib.Path(root);checks=[];pins={}
 def keep(p):s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(k,v):require(v,k);checks.append(k)
 def verify(s):
  n=keep(s['path']);check('identity_'+s['path'],n['bytes']==s['bytes'] and n['sha256']==s['sha256'] and pathlib.Path(n['path'])==pathlib.Path(s['path']))
 c=load(V/'skin-identity-associations.json');keep(V/'skin-identity-associations.json');verify(c['producer']);snap=c['registry_snapshot'];verify(snap['snapshot']);check('snapshot_exact',all(snap['snapshot'][k]==snap['original'][k] for k in ['bytes','sha256']))
 receipts=[]
 for receipt in c['receipts']:
  verify(receipt);d=load(receipt['path']);verify(d['producer'])
  for s in d['sources']:
   if pathlib.Path(s['path'])==pathlib.Path(snap['original']['path']):check('registry_historical_pin',s==snap['original'])
   else:verify(s)
  for s in d.get('native_files',d.get('native_sources',[])):verify(s)
  receipts.append(d)
 identity,runtime,preload=receipts
 verify(identity['official_catalogue']);verify(identity['tests']['log']);check('nine_tests',identity['tests']['passed'] and identity['tests']['count']==9 and 'Ran 9 tests' in pathlib.Path(identity['tests']['log']['path']).read_text() and '\nOK\n' in pathlib.Path(identity['tests']['log']['path']).read_text())
 check('668_identities',identity['result']['skin_identities_verified']==668 and identity['result']['statuses']==dict(resolved_explicit_native_skin_id=656,equivalent_native_skin_bindings=5,ambiguous_native_skin_bindings=7))
 models=load(root/'data/4.20/model_catalog.json')['models']
 check('12_aliases',len(preload['display_aliases'])==12)
 for a in preload['display_aliases']:check('alias_'+a['champion'],models[a['display_key']]==models[a['champion'].lower()] and a['present'] and a['equal_entry'])
 sys.path.insert(0,str(root/'tools/project-plan'));import reference_inibin
 check('parser_F',pathlib.Path(reference_inibin.__file__).resolve()==(root/'tools/project-plan/reference_inibin.py').resolve())
 parsed={}
 for p in preload['preloads']:
  path=p['source']['path']
  if path not in parsed:parsed[path]=reference_inibin.read(pathlib.Path(path))
  check('preload_'+p['champion']+'_'+str(p['skin_num'])+'_'+p['section']+'_'+path,parsed[path].get(reference_inibin.hashkey(p['section'],'ExtraCharacterPreloads'))==p['value'] and p['proves_transform_or_owner'] is False)
 check('71_preloads',len(preload['preloads'])==71)
 a=load(root/'data/4.20/animation_manifest.json');w=load(root/'data/4.20/world_animation_manifest.json');check('runtime_census',runtime['manifest_counts']==dict(champions=len(a),world=len(w),effective=len({**a,**w})))
 skin_tasks=[t for t in load(snap['snapshot']['path'])['tasks'] if t['id'].startswith('SKIN-')];optional=[dict(id=t['id'],entity=t.get('entity'),required_if=t.get('required_if'),evidence=t.get('evidence')) for t in skin_tasks if t.get('required') is False];check('conditional_scope_snapshot',len(skin_tasks)==10688 and optional==runtime['skin_plan']['optional_tasks'] and len(optional)==10020)
 for i,row in enumerate(c['associations']):
  check('task_scope_'+row['task_id'],row['task_id']==f'SYS-14.1-{i+1:02}' and row['full_task_scope_complete'] is False and row['entry_boundary_only']==(i==3))
  for anchor in row['anchors']:check('anchor_'+anchor['role'],anchor['needle'] in (root/anchor['path']).read_text(encoding='utf8').splitlines()[anchor['line']-1]);keep(root/anchor['path'])
 return dict(candidates=c,receipts=receipts,source_checks=checks,form_ownership_qualified=False,historical_availability_qualified=False),list(pins.values())
_CACHE={}
def audit(q,root='F:/OpenLeague',verify_files=True):
 require(verify_files,'no bypass');require(q['schema']=='openleague_skin_identity_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'overbroad '+k)
 key=str(pathlib.Path(root).resolve())
 if key not in _CACHE:_CACHE[key]=collect(root)
 f,p=_CACHE[key]
 for s in p:require(pin(s['path'])==s,'source changed '+s['path'])
 require(q['facts']==f and q['source_identities']==p,'changed evidence');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'check census');require(q['associations']==f['candidates']['associations'],'changed associations')
 unknowns={u['unknown_id']:u for u in load(pathlib.Path(root)/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  u=unknowns[a['existing_unknown_id']];require(u['task_id']==a['task_id'] and u['status']=='open','unknown binding')
 return dict(verified=True,tasks=4,roles=8,source_pins=len(p),checks_count=len(q['checks']),python_tests=9)
