"""Ward/stealth source links: candidate data and empty scripts do not prove game behavior."""
import pathlib,json,hashlib,sys
R=pathlib.Path('F:/OpenLeague');V=pathlib.Path('F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision105');sys.path[:0]=[str(R/'tools/project-plan')]
from reference_inibin import read
from lua51_reference import Reader
from rads_reference_membership import RadsReferenceMembership
load=lambda p:json.loads(pathlib.Path(p).read_bytes())
TARGETS=[f'SYS-13.2-{i:02}' for i in range(1,8)]
def require(v,m):
 if not v:raise ValueError(m)
def pin(p):
 p=pathlib.Path(p).resolve();b=p.read_bytes();return dict(path=str(p),bytes=len(b),sha256=hashlib.sha256(b).hexdigest())
CANDIDATE_SHA='21403ad5e157f888379289a82f6298ff70f90f32fdc9afecb49860dd92cefcd6'
def collect(root=R):
 root=pathlib.Path(root);pins={};checks=[]
 def keep(p):s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(k,v):require(v,k);checks.append(k)
 wards=load(V/'ward-source-inventory.json');stealth=load(V/'stealth-trap-source-inventory.json');candidate=load(V/'ward-association-candidates.json');tests=load(V/'ignite-reveal-tests.json')
 check('fixed_roles',keep(V/'ward-association-candidates.json')['sha256']==CANDIDATE_SHA)
 for name,d in [('ward-source-inventory.json',wards),('stealth-trap-source-inventory.json',stealth),('ward-association-candidates.json',candidate)]:
  keep(V/name);check('producer_'+name,keep(d['producer']['path'])==d['producer'])
 keep(V/'ignite-reveal-tests.json');loc=load(root/'docs/project_location.json');keep(root/'docs/project_location.json');check('active_root',pathlib.Path(loc['active_root']).resolve()==root.resolve());m=RadsReferenceMembership(loc['previous_root'])
 for name,d,count in [('wards',wards,93),('stealth',stealth,289)]:
  check('census_'+name,len(d['native_files'])==count and d['membership_counts']=={'matches_selected_project_manifest':count})
  for row in d['native_files']:
   s=row['source'];check('pin_'+row['logical'],keep(s['path'])==s);check('membership_'+row['logical'],m.inspect(row['logical'],s['path'],s)==row['membership'])
   if 'fields' in row:check('fields_'+row['logical'],read(s['path'])==row['fields'])
   else:check('lua_'+row['logical'],Reader(pathlib.Path(s['path']).read_bytes()).parse()==row['lua'])
 for s in wards['current_sources']+candidate['current_sources']:check('current_'+s['path'],keep(s['path'])==s)
 check('catalog_pin',keep(wards['catalog']['path'])==wards['catalog']);dd=load(wards['catalog']['path']);check('catalog_version',dd['version']=='4.20.1')
 admission={str(i['id']):i['allowed'] for i in load(root/'data/4.20/map10_shop_admission.json')['items']};implemented={str(i['id']) for i in load(root/'data/4.20/shop_foundation.json')['items']}
 check('item_census',len(wards['items'])==44)
 for item in wards['items']:
  d=dd['data'][item['id']];check('catalog_item_'+item['id'],item==dict(id=item['id'],name=d['name'],description=d.get('description'),declared_maps=d.get('maps'),explicit_map10=d.get('maps',{}).get('10'),local_admission=admission.get(item['id']),local_shop_definition=item['id'] in implemented,group=d.get('group')))
 check('green_pink_map10_excluded',all(dd['data'][i]['maps']['10'] is False for i in ['2043','2044']))
 check('42_empty_ward_scripts',sum(r.get('lua',{}).get('words')==[8388638] and not r['lua']['constants'] and not r['lua']['children'] for r in wards['native_files'])==42)
 check('correct_Tibbers',any(g['name']=='AnnieTibbers' and len(g['files'])==5 for g in stealth['groups']))
 check('four_tests',tests['passed'] is True and len(tests['cases'])==4)
 for c in tests['cases']:
  for k in ['log','binary']:check(k+'_'+c['name'],keep(c[k]['path'])==c[k])
  text=pathlib.Path(c['log']['path']).read_text(encoding='utf8');check('test_'+c['name'],c['passed'] is True and c['exit_code']==0 and '--exact' in c['command'] and '1 passed; 0 failed' in text and 'test '+c['name']+' ... ok' in text)
 for a in candidate['associations']:
  for anchor in a['anchors']:check('anchor_'+anchor['role'],anchor['needle'] in (root/anchor['path']).read_text(encoding='utf8').splitlines()[anchor['line']-1])
 for s in [m.catalogue_identity,m.solution_identity,m.configuration_identity,*[x['identity'] for x in m.manifests],*m.provenance]:keep(s['path'])
 for rel in ['tools/project-plan/reference_inibin.py','tools/project-plan/lua51_reference.py','tools/project-plan/rads_reference_membership.py','tools/project-plan/frontend_builds.py']:keep(root/rel)
 return dict(wards=wards,stealth=stealth,candidates=candidate,tests=tests,source_checks=checks,full_task_scope_complete=False,original_instructions_executed=False,game_or_gpu_executed=False),list(pins.values())
def bindings(f,t):
 i=TARGETS.index(t);ward=f['wards']['native_files'];stealth=f['stealth']['native_files']
 if i==0:chosen=[r for r in ward if r['logical'] in ['DATA/Items/2044.inibin','DATA/Items/2044.luaobj','DATA/Characters/SightWard/SightWard.inibin','DATA/Characters/SightWard/CharScriptSightWard.luaobj']]
 elif i==1:chosen=[r for r in ward if r['logical'] in ['DATA/Items/2043.inibin','DATA/Items/2043.luaobj','DATA/Characters/VisionWard/VisionWard.inibin','DATA/Characters/VisionWard/CharScriptVisionWard.luaobj']]
 elif i==2:chosen=[r for r in ward if pathlib.Path(r['logical']).stem in ['2047','3159','3185','3187','3340','3341','3342','3361','3362','3363','3364']]
 elif i==3:chosen=[r for r in ward if '/Characters/' in r['logical']]
 elif i==4:chosen=[r for r in stealth if r['group'] in ['Akali','Evelynn','Khazix','MonkeyKing','Rengar','Shaco','Twitch','Vayne']]
 elif i==5:chosen=[r for r in stealth if r['group']=='SummonerDot']
 else:chosen=[r for r in stealth if r['group'] in ['CaitlynTrap','JinxMine','TeemoMushroom','ShacoBox','AnnieTibbers']]
 require(chosen,'native source selection '+t)
 return [dict(path=r['source']['path'],role='native_ward_stealth_candidate_not_complete_server_behavior',selector=r['logical']+';parsed fields/instructions in receipt;empty callbacks and producer limits preserved') for r in chosen]
def associations(f):return [dict(row,native_bindings=bindings(f,row['task_id'])) for row in f['candidates']['associations']]
_CACHE={}
def audit(q,root='F:/OpenLeague',verify_files=True):
 require(verify_files,'no bypass');root=pathlib.Path(root);key=str(root.resolve());require(q['schema']=='openleague_ward_stealth_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported scope '+k)
 if key not in _CACHE:_CACHE[key]=collect(root)
 f,p=_CACHE[key]
 for s in p:require(pin(s['path'])==s,'source changed '+s['path'])
 require(q['facts']==f and q['source_identities']==p,'changed facts/sources');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'check census');require(q['associations']==associations(f),'associations changed');require([a['task_id'] for a in q['associations']]==TARGETS,'task census')
 um={u['unknown_id']:u for u in load(root/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:u=um[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==a['task_id'],'unknown binding')
 return dict(verified=True,checks_count=len(q['checks']),tasks=7,roles=14,source_pins=len(p),rust_tests=4,native_files=382,original_game_executed=False)
