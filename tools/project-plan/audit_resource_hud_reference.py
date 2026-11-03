"""Qualify exact resource/HUD links, decoded-export provenance and inherited precision scope."""
import argparse,collections,hashlib,json,pathlib,struct,sys,zipfile
class ContractError(ValueError):pass
def require(v,why):
 if not v:raise ContractError(why)
def pin(p):
 p=pathlib.Path(p);b=p.read_bytes();return dict(path=str(p.resolve()),bytes=len(b),sha256=hashlib.sha256(b).hexdigest())
def compressed_byte(path,hashed_key):
 data=pathlib.Path(path).read_bytes();slen,flags=struct.unpack_from('<HH',data,1);off=5
 for bit,width in enumerate([4,4,1,2,1,None,3,12,2,8,4,16,2]):
  if not flags&(1<<bit):continue
  count=struct.unpack_from('<H',data,off)[0];off+=2;keys=struct.unpack_from('<'+'I'*count,data,off);off+=4*count
  if int(hashed_key) in keys:
   require(bit==2,'precision field type');offset=off+keys.index(int(hashed_key));require(offset<len(data)-slen,'field storage bounds')
   return dict(type_bit=bit,offset=offset,byte=data[offset])
  off+=(count+7)//8 if bit==5 else count*width
 raise ContractError('precision field missing')
TARGETS=[f'SYS-05.{p}-{i:02}' for p,n in [(4,8),(5,5)] for i in range(1,n+1)]
BOUNDARIES=[f'SYS-05.4-{i:02}' for i in [3,4,5,6]]
FIELDS=['PARType','PARNameString','BaseMP','MPPerLevel','BaseStaticMPRegen','MPRegenPerLevel','Passive1Name','Passive1LuaName','Passive1Desc']
MEMBERS=['HUD/defaults/FastHUD.ini','HUD/Elements/ShadowIslesEvolutionBar.ini','HUD/Elements/CenterHUD_AbilitiesPipBars.ini','HUD/Elements/CenterHUD_PARBar.ini','HUD/Elements/ShadowIslesCenterHUD_PARBar.ini','HUD/Elements/CenterHUD_HealthBar.ini','HUD/Elements/ShadowIslesCenterHUD_HealthBar.ini']
def audit(q,root='E:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);key=lambda p:str(pathlib.Path(p).resolve()).casefold()
 require(q['schema']=='openleague_resource_hud_links/v1' and q['passed'] is True,'schema/result')
 for k in ['native_default_resource_qualified','all_resource_events_qualified','all_secondary_fiches_complete','ordinary_learning_error_UI_qualified','debug_rejection_visible_by_default','current_application_executed','native_binary_executed','global_feature_absence_proven']:require(q[k] is False,'scope: '+k)
 require(q['full_task_scopes_closed']==q['questions_closed']==0,'no full scope closure')
 require(q['checks_count']==1073==len(q['checks'])==len(set(q['checks'])),'source check census')
 rows=q['associations'];require([a['task_id'] for a in rows]==TARGETS,'task census')
 require([a['task_id'] for a in rows if a['entry_boundary_only']]==BOUNDARIES,'resource boundary scopes')
 require(len({a['existing_unknown_id'] for a in rows})==13 and sum(len(a['anchors']) for a in rows)==37,'unknowns/roles')
 pins={key(s['path']):s for s in q['source_identities']};require(len(pins)==len(q['source_identities']),'unique pins')
 natives=q['native_inputs'];require(len(natives)==122,'122 native character sources')
 kinds={x['champion']:x for x in q['resource_kinds']};require(len(kinds)==len(q['resource_kinds'])==122 and set(kinds)==set(natives),'kind census')
 types=dict(collections.Counter(x['current'] for x in kinds.values()));require(types==q['current_types']=={'Mana':102,'None':6,'Energy':5,'BloodWell':1,'Gnarfury':1,'Shield':1,'Rage':1,'Ferocity':1,'Heat':1,'Dragonfury':1,'Battlefury':1,'Wind':1},'resource kind counts')
 for c,n in natives.items():
  require(n['source']==pins[key(n['source']['path'])] and n['membership']['status']=='matches_selected_project_manifest','character source/membership')
  require(set(n['fields'])==set(FIELDS),'character field queries')
  k=kinds[c];require(k['native']==n['fields']['PARType'] and k['native_runtime_default_qualified'] is False,'type source/default scope')
  if k['native'] is None:require(k['current']=='Mana' and k['basis']=='local_Mana_default_native_default_not_qualified','missing native type distinct from default')
  else:require(k['current']==k['native'] and k['basis']=='explicit_native_field','explicit type binding')
 require(sum(x['native'] is None for x in kinds.values())==102,'102 default queries')
 hud=q['native_hud'];require(hud['source']==pins[key(hud['source']['path'])] and hud['local_source']==pins[key(hud['local_source']['path'])],'archive pins')
 require(hud['membership']['status']=='not_listed_in_two_selected_projects' and hud['relative']=='DATA/Menu/HUD.zip','archive itself not a manifest member')
 require(hud['historical_mount_order_qualified'] is False and hud['rendering_executed'] is False,'archive/runtime scope')
 require(set(hud['members'])==set(MEMBERS),'selected HUD members')
 for name,m in hud['members'].items():
  require(m['relative']=='DATA/Menu/'+name and m['source']==pins[key(m['source']['path'])] and m['membership']['status']=='matches_selected_project_manifest','individual HUD member provenance')
  require(all(m[k]==m['source'][k] for k in ['bytes','sha256']),'member payload identity')
 allnative=natives|{'hud':hud}
 names=lambda typ:[c for c,x in kinds.items() if x['current']==typ]
 bindings=[names('Mana'),names('Energy'),['gnar','renekton'],['renekton','shyvana','tryndamere','rengar'],['rumble'],['drmundo','vladimir','zac','aatrox','mordekaiser'],names('None')+['hud'],['annie','ezreal','aatrox','mordekaiser','yasuo'],[],['hud'],[],[],['hud']]
 for i,a in enumerate(rows):
  require(a['finding'] and a['remaining'] and a['anchors'],'findings/remaining')
  require(a['full_task_scope_complete'] is False and a['native_server_policy_qualified'] is False,'partial feature scope')
  require([key(b['path']) for b in a['native_bindings']]==[key(allnative[n]['source']['path']) for n in bindings[i]],'precise source associations')
  for b in a['native_bindings']:require(b['selector'] and b['role']=='native_authoring_input_not_server_policy','source authority')
  for c in a['anchors']:
   p=(root/c['path']).resolve();require(p.is_relative_to(root.resolve()) and key(p) in pins and c['role'].startswith('resource_hud_reference_') and c['line']>0,'consumer identity/path/role')
   if verify_files:
    lines=p.read_text(encoding='utf8').splitlines();require(c['line']<=len(lines) and c['needle'] in lines[c['line']-1],'actual consumer anchor')
 vals=q['scalar_comparisons'];require(len(vals)==488 and len({(x['champion'],x['native_field']) for x in vals})==488,'scalar census')
 for x in vals:
  require(x['native']==natives[x['champion']]['fields'][x['native_field']] and x['runtime_semantics_qualified'] is False,'scalar binding/authority')
  nb=struct.unpack('<I',struct.pack('<f',float(x['native'])))[0];lb=struct.unpack('<I',struct.pack('<f',float(x['current'])))[0]
  require(x['native_binary32']==nb and x['current_binary32']==lb and x['binary32_equal']==(nb==lb) and x['ulp_difference']==abs(nb-lb),'analytical comparison')
  require(x['current_path'] in ['data/4.20/champions.json','data/4.20/champion_growth_420.json'] and key(root/x['current_path']) in pins,'current scalar path')
 diffs=[x for x in vals if not x['binary32_equal']];require([(x['champion'],x['native_field'],x['ulp_difference']) for x in diffs]==[(c,'BaseStaticMPRegen',1) for c in ['janna','nami','sona','soraka']],'analytical reader differences retained')
 exports=q['export_provenance'];require(len(exports)==122 and {x['champion'] for x in exports}==set(natives),'export provenance census')
 for x in exports:require(x['meaning']=='hash_of_decoded_Stats_JSON_not_INIBIN' and x['declared_sha256']==x['source']['sha256'] and x['source']==pins[key(x['source']['path'])] and x['native_source']==natives[x['champion']]['source'],'decoded export hash scope')
 precision=q['precision_evidence'];require(precision['source']==pins[key(precision['source']['path'])] and precision['case_byte']==18 and len(precision['bindings'])==4,'inherited precision source')
 case=precision['case'];require(case['byte']==18 and case['expected_f32_hex']==case['observed']['typed_float']['float32_hex']=='6766e63f' and case['binary64_normalized_cast_hex']=='6666e63f','byte18 native observation')
 for b,x in zip(precision['bindings'],diffs,strict=True):
  require(b['champion']==x['champion'] and b['native_field']==x['native_field'] and b['source']==natives[x['champion']]['source'],'precision field binding')
  require(b['storage']['type_bit']==2 and b['storage']['byte']==18 and b['analytical_reader_hex']=='6666e63f' and b['current_hex']==b['inherited_original_parser_hex']=='6766e63f','precision interpretation')
  require(b['current_matches_inherited_parser'] is True and b['original_parser_freshly_executed'] is False,'inherited not freshly run')
 if verify_files:
  sys.path.append(str(root/'tools/project-plan'))
  from reference_inibin import read,hashkey
  from rads_reference_membership import RadsReferenceMembership
  for s in pins.values():require(pin(s['path'])=={k:s[k] for k in ['path','bytes','sha256']},'source changed: '+s['path'])
  m=RadsReferenceMembership(root)
  for c,n in natives.items():
   require(m.inspect(n['relative'],m.deploy/n['relative'],n['source'])==n['membership'],'character membership changed');v=read(n['source']['path'])
   require(all(v.get(hashkey('Data',k))==value for k,value in n['fields'].items()),'character field changed')
  current=json.loads((root/'data/4.20/champion_resources.json').read_bytes())
  require(set(current)==set(kinds),'current resource roster')
  for x in exports:
   c=x['champion'];e=json.loads(pathlib.Path(x['source']['path']).read_bytes());require(current[c]['source_sha256']==x['declared_sha256'] and current[c]['type']==kinds[c]['current'] and current[c]['resource']==e['MetaData']['ResourcePath']==natives[c]['relative'],'current catalogue/export/native path')
  tables={p:json.loads((root/p).read_bytes()) for p in ['data/4.20/champions.json','data/4.20/champion_growth_420.json']}
  for x in vals:
   v=tables[x['current_path']]
   for k in x['current_keys']:v=v[k]
   require(v==x['current'],'local coefficient changed')
   if x['current_path'].endswith('/champions.json'):require(tables[x['current_path']][x['current_keys'][0]]['id']==x['champion'],'base row binding')
   else:require(x['current_keys'][0]==x['champion'],'growth row binding')
  previous=json.loads(pathlib.Path(precision['source']['path']).read_bytes());require(previous['passed'] and next(x for x in previous['supplemental_cases'] if x['byte']==18)==case,'inherited case changed')
  for p in [previous['binary'],previous['producer'],previous['helper'],previous['research'],case['input']]:require(pin(p['path'])==p,'inherited evidence pin changed')
  for b in precision['bindings']:require(compressed_byte(b['source']['path'],hashkey('Data',b['native_field']))==b['storage'],'actual compressed field storage')
  require(m.inspect(hud['relative'],m.deploy/hud['relative'],hud['source'])==hud['membership'],'archive membership')
  require(pathlib.Path(hud['source']['path']).read_bytes()==pathlib.Path(hud['local_source']['path']).read_bytes(),'archive copy differs')
  with zipfile.ZipFile(hud['source']['path']) as z:
   for name,item in hud['members'].items():
    require(len([n for n in z.namelist() if n==name])==1,'unique ZIP member');b=z.read(name)
    require(b==pathlib.Path(item['source']['path']).read_bytes() and hashlib.sha256(b).hexdigest()==item['sha256'] and len(b)==item['bytes'] and z.getinfo(name).CRC==item['crc32'],'ZIP payload')
    require(m.inspect(item['relative'],m.deploy/item['relative'],item['source'])==item['membership'],'individual HUD member manifest')
  cat=json.loads((root/'data/4.20/native_zip_catalog.json').read_bytes());require(next(x for x in cat['archives'] if x['path']=='data/4.20/archives/menu/HUD.zip')['sha256']==hud['source']['sha256'],'current HUD catalogue')
 return dict(verified=True,task_scopes=13,partial_feature_scopes=9,boundary_only_scopes=4,source_identities=len(pins),native_characters=122,decoded_export_provenances=122,numeric_queries=488,analytical_binary32_equal=484,inherited_byte18_equal=4,native_explicit_resource_types=20,local_Mana_defaults=102,hud_members=7,anchors=37,full_scopes_closed=0,native_or_current_application_executed=False)
def main():
 p=argparse.ArgumentParser();p.add_argument('--inputs',required=True);p.add_argument('--root',default='E:/OpenLeague');a=p.parse_args()
 try:r=audit(json.loads(pathlib.Path(a.inputs).read_bytes()),a.root)
 except (ContractError,KeyError,ValueError,OSError,IndexError) as e:print(json.dumps(dict(verified=False,error=str(e))));return 1
 print(json.dumps(r));return 0
if __name__=='__main__':raise SystemExit(main())
