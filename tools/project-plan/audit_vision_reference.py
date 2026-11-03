"""Vision source associations. Local CPU evidence does not certify historical server or GPU behavior."""
import pathlib,json,hashlib,sys
R=pathlib.Path('F:/OpenLeague');V=pathlib.Path('F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision104')
sys.path[:0]=[str(R/'tools/project-plan')]
from reference_inibin import read
from rads_reference_membership import RadsReferenceMembership
TARGETS=[f'SYS-13.1-{i:02}' for i in range(1,8)]
load=lambda p:json.loads(pathlib.Path(p).read_bytes())
def require(v,m):
 if not v:raise ValueError(m)
def pin(p):
 p=pathlib.Path(p).resolve();b=p.read_bytes();return dict(path=str(p),bytes=len(b),sha256=hashlib.sha256(b).hexdigest())
CANDIDATE_SHA='2bbf2dd675875dc86bd45a22467eb096410a7cc010283dbc4e5312076a79cbe3'
def collect(root=R):
 root=pathlib.Path(root);pins={};checks=[]
 def keep(p):s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(k,v):require(v,k);checks.append(k)
 candidates=load(V/'vision-association-candidates.json');check('fixed_candidate_review',keep(V/'vision-association-candidates.json')['sha256']==CANDIDATE_SHA)
 native=load(V/'vision-radius-source-review.json');membership=load(V/'vision-membership-and-contracts.json');core=load(V/'vision-rust-tests.json');client=load(V/'vision-client-tests.json')
 for name,d in [('vision-radius-source-review.json',native),('vision-membership-and-contracts.json',membership),('vision-association-candidates.json',candidates)]:
  keep(V/name);check('producer_'+name,keep(d['producer']['path'])==d['producer'])
 for name in ['vision-rust-tests.json','vision-client-tests.json']:keep(V/name)
 check('native_scope',native['passed'] is True and not native['errors'] and native['catalog_profiles']==len(native['profiles'])==150)
 for s in native['source_pins']+native['current_sources']+candidates['current_source_pins']:check('pin_'+s['path'],keep(s['path'])==s)
 catalog=load(root/'data/4.20/native_vision_radii.json');key=str(int(catalog['inibin_key'],16));check('default',catalog['default_radius']==1350 and 'PerceptionBubbleRadius = 1350' in pathlib.Path(catalog['default_source']).read_text(encoding='utf-8-sig'))
 for p in native['profiles']:
  actual=read(p['source']['path']).get(key);number=None if actual is None else float(actual);resolved=number if number is not None and number>0 else 1350
  expected=catalog['profiles'][p['name']];check('field_'+p['name'],actual==p['native_value'] and number==expected['explicit_radius'] and resolved==p['resolved_radius']==expected['resolved_radius'] and p['matches_catalog'])
 loc=load(root/'docs/project_location.json');keep(root/'docs/project_location.json');check('active_root',pathlib.Path(loc['active_root']).resolve()==root.resolve());m=RadsReferenceMembership(loc['previous_root'])
 check('membership_census',len(membership['membership'])==151 and membership['membership_counts']=={'matches_selected_project_manifest':151})
 for row,s in zip(membership['membership'],native['source_pins']):
  actual=m.inspect(pathlib.Path(s['path']).relative_to(m.deploy).as_posix(),s['path'],s);check('member_'+row['logical_path'],actual==row and actual['status']=='matches_selected_project_manifest')
 check('native_binary',keep(membership['native_binary']['path'])==membership['native_binary'])
 check('contracts',len(membership['contracts'])==64)
 for c in membership['contracts']:
  check('contract_'+c['source']['path'],keep(c['source']['path'])==c['source'] and c['reexecuted'] is False)
  if c['native_sha256'] is not None:check('contract_native_'+c['source']['path'],c['native_sha256']==membership['native_binary']['sha256'])
 for group,d,count in [('core',core,9),('client',client,14)]:
  check(group+'_result',d['passed'] is True and d['complete'] is True)
  observed=0
  for c in d['cases']:
   for k in ['log','binary']:check(group+'_'+k+'_'+c.get('name',c.get('group')),keep(c[k]['path'])==c[k])
   text=pathlib.Path(c['log']['path']).read_text(encoding='utf8');check(group+'_exit_'+str(observed),c['exit_code']==0 and c['passed'] is True and '--offline' in c['command'] and '--locked' in c['command'])
   names=[c['name']] if group=='core' else c['tests']
   for name in names:check('test_'+name,'test '+name+' ... ok' in text)
   observed+=len(names)
  check(group+'_count',observed==count)
 for s in [m.catalogue_identity,m.solution_identity,m.configuration_identity,*[x['identity'] for x in m.manifests],*m.provenance]:keep(s['path'])
 for rel in ['tools/project-plan/reference_inibin.py','tools/project-plan/rads_reference_membership.py','tools/project-plan/frontend_builds.py']:keep(root/rel)
 for a in candidates['associations']:
  for anchor in a['anchors']:check('anchor_'+anchor['role'],anchor['needle'] in (root/anchor['path']).read_text(encoding='utf8').splitlines()[anchor['line']-1])
 facts=dict(native=native,membership=membership,core=core,client=client,candidates=candidates,source_checks=checks,historical_server_policy_qualified=False,original_instructions_rerun=False,game_or_gpu_executed=False,complete=False)
 return facts,list(pins.values())
def bindings(f,t):
 if t==TARGETS[0]:return [dict(path=s['path'],role='native_perception_radius_resource',selector='INIBIN0x6c2dcde3 or GamePermanent.cfg PerceptionBubbleRadius;selection and activation limits in receipt') for s in f['native']['source_pins']]
 if t in [TARGETS[1],TARGETS[2]]:return [dict(path=f['membership']['native_binary']['path'],role='native_client_mask_traversal_not_server_visibility',selector='0x6b09e0 / 0x8f3390;inherited vector contracts,not fresh original execution')]
 if t==TARGETS[6]:return [dict(path=f['membership']['native_binary']['path'],role='native_fow_contract_binary_not_gpu_pixel_acceptance',selector='64 inherited fow contracts indexed in facts/membership/contracts;CPU renderer tests only')]
 return []
def associations(f):
 out=[]
 for row in f['candidates']['associations']:out.append(dict(row,native_bindings=bindings(f,row['task_id'])))
 return out
_CACHE={}
def audit(q,root='F:/OpenLeague',verify_files=True):
 require(verify_files,'source verification cannot be disabled');root=pathlib.Path(root);key=str(root.resolve())
 require(q['schema']=='openleague_vision_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported claim '+k)
 if key not in _CACHE:_CACHE[key]=collect(root)
 f,p=_CACHE[key]
 for s in p:require(pin(s['path'])==s,'source changed '+s['path'])
 require(q['facts']==f and q['source_identities']==p,'changed evidence')
 require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'check census')
 require(q['associations']==associations(f),'associations changed')
 require([a['task_id'] for a in q['associations']]==TARGETS,'task census')
 um={u['unknown_id']:u for u in load(root/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  u=um[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==a['task_id'],'unknown binding')
 return dict(verified=True,checks_count=len(q['checks']),tasks=7,roles=15,source_pins=len(p),core_tests=9,client_tests=14,original_game_executed=False)
