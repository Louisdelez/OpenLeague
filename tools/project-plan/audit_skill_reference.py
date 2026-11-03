"""Read-only proof of specific skill source/consumer links, not all champion mechanics."""
import argparse,hashlib,json,pathlib,re,struct,sys
class ContractError(ValueError):pass
def require(v,why):
 if not v:raise ContractError(why)
def pin(p):
 p=pathlib.Path(p);b=p.read_bytes();return dict(path=str(p.resolve()),bytes=len(b),sha256=hashlib.sha256(b).hexdigest())
TARGETS=[f'SYS-05.{p}-{i:02}' for p,n in [(1,5),(2,6),(3,7)] for i in range(1,n+1)]
CHAMPIONS=['Garen','Annie','Trundle','Ezreal','Elise','Jayce','Nidalee','Udyr','Karma']
BOUNDARIES=['SYS-05.2-03','SYS-05.2-04','SYS-05.2-05','SYS-05.3-07']
def audit(q,root='E:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);key=lambda p:str(pathlib.Path(p).resolve()).casefold()
 require(q['schema']=='openleague_skill_links/v1' and q['passed'] is True,'schema/result')
 for k in ['current_application_executed','native_binary_executed','global_feature_absence_proven','native_server_policy_qualified','native_default_rank_table_qualified','free_grants_qualified','alternate_form_ranks_qualified','dynamic_tooltips_qualified','rank_table_entries_equal_playable_ranks']:require(q[k] is False,'scope: '+k)
 require(q['full_task_scopes_closed']==q['questions_closed']==0,'no scope/question closure')
 require(q['checks_count']==553==len(q['checks'])==len(set(q['checks'])),'source checks')
 rows=q['associations'];require([a['task_id'] for a in rows]==TARGETS,'task set')
 require([a['task_id'] for a in rows if a['entry_boundary_only']]==BOUNDARIES,'boundary scope')
 require(len({a['existing_unknown_id'] for a in rows})==18,'distinct open questions')
 pins={key(s['path']):s for s in q['source_identities']};require(len(pins)==len(q['source_identities']),'unique source pins')
 native=q['native_inputs'];require(set(native)==set(CHAMPIONS+[c+str(i) for c in CHAMPIONS for i in range(4)]+['xp']),'native source census')
 const=q['native_constants'];allnative=native|{'constants':const}
 bindings=[['xp'],[],[],[],[],['Garen','Annie','Trundle','Ezreal'],['Elise','Jayce','Nidalee','Udyr','Karma'],['Elise','Jayce','Nidalee','Karma'],['Elise','Jayce','Nidalee','Udyr','Karma'],['Elise','Jayce','Nidalee'],CHAMPIONS,['Ezreal0','Ezreal3'],['Ezreal0','Ezreal3'],['Ezreal0','Ezreal3'],['constants','Ezreal0'],['constants'],['Garen2','Annie3','Elise','Jayce','Nidalee'],['Ezreal0','Ezreal3','Elise3','Jayce3','Nidalee3','Udyr3','Karma3']]
 require(sum(len(a['anchors']) for a in rows)==36,'consumer roles')
 for i,a in enumerate(rows):
  require(a['full_task_scope_complete'] is False and a['native_server_policy_qualified'] is False,'partial scope')
  require(a['finding'] and a['remaining'] and a['anchors'],'findings/limits/roles')
  require([key(b['path']) for b in a['native_bindings']]==[key(allnative[n]['source']['path']) for n in bindings[i]],'native association')
  for b in a['native_bindings']:require(b['selector'] and b['role']=='native_authoring_input_not_server_policy','native authority')
  for a in a['anchors']:
   p=(root/a['path']).resolve();require(p.is_relative_to(root.resolve()) and key(p) in pins,'consumer identity/path')
   require(a['line']>0 and a['role'].startswith('skill_reference_') and a['needle'],'consumer role')
   if verify_files:
    lines=p.read_text(encoding='utf8').splitlines();require(a['line']<=len(lines) and a['needle'] in lines[a['line']-1],'consumer anchor moved')
 for n in allnative.values():
  require(n['source']==pins[key(n['source']['path'])],'native source identity')
  require(n['membership']['status']=='matches_selected_project_manifest' and n['fields'],'native membership/fields')
 for c in CHAMPIONS[:4]:require(all(native[c]['fields'][f'Data.SpellsUpLevels{i}'] is None for i in range(1,5)),'absent query not default')
 for c in ['Elise','Jayce','Nidalee','Karma']:require(native[c]['fields']['Data.SpellsUpLevels4']==[1.,6.,11.,16.],'native special table')
 require(native['Udyr']['fields']['Data.SpellsUpLevels4']=='1 3 5 7 9 99','native sentinel retained')
 require(const['fields']=={'gcd_CooldownMinimum':0.,'gcd_PercentCooldownModMinimum':-0.4},'native signed constants')
 values=q['scalar_comparisons'];require(len(values)==360 and len({(x['native_name'],x['native_field']) for x in values})==360,'numeric query census')
 statuses=[]
 for x in values:
  require(x['current_path']=='data/4.20/native_spells_420.json' and key(root/x['current_path']) in pins,'current table')
  require(x['native']==native[x['native_name']]['fields'][x['native_field']] and x['runtime_semantics_qualified'] is False,'native scalar binding')
  expected='missing_field' if x['native'] is None or x['current'] is None else 'compared'
  try:eq=None if expected=='missing_field' else struct.pack('<f',float(x['native']))==struct.pack('<f',float(x['current']))
  except ValueError:expected='malformed_numeric';eq=None
  require(x['comparison_status']==expected and x['binary32_equal']==eq and eq is not False,'comparison meaning')
  statuses.append(expected)
 require(statuses.count('compared')==344 and statuses.count('missing_field')==14 and statuses.count('malformed_numeric')==2,'numeric limits retained')
 require([(x['native_name'],x['native_field'],x['native'],x['current']) for x in values if x['comparison_status']=='malformed_numeric']==[('Karma0','SpellData.Cooldown2','6.5.0000','6.5.0000'),('Karma0','SpellData.Cooldown4','5.5.0000','5.5.0000')],'malformed originals preserved')
 text=q['native_text'];require(text['relative']=='DATA/Menu/fontconfig_en_GB.txt' and text['membership']['status']=='matches_selected_project_manifest','locale identity')
 require(text['source']==pins[key(text['source']['path'])] and len(text['entries'])==14,'locale source/hooks')
 for name,e in text['entries'].items():
  c,f=name.split('/');require(e['key']==native[c]['fields']['SpellData.'+f] and e['present'] is True and isinstance(e['text'],str),'native text association')
 if verify_files:
  sys.path.append(str(root/'tools/project-plan'))
  from reference_inibin import read,hashkey
  from rads_reference_membership import RadsReferenceMembership
  for s in pins.values():require(pin(s['path'])=={k:s[k] for k in ['path','bytes','sha256']},'source changed: '+s['path'])
  m=RadsReferenceMembership(root)
  for name,n in allnative.items():
   require(m.inspect(n['relative'],m.deploy/n['relative'],n['source'])==n['membership'],'native manifest membership changed')
   if name=='constants':
    raw=pathlib.Path(n['source']['path']).read_text();require(all(float(re.search(r'^'+f+r'\s*=\s*([-0-9.]+)',raw,re.M)[1])==v for f,v in n['fields'].items()),'native constants changed')
   else:
    raw=read(n['source']['path'])
    for f,v in n['fields'].items():
     sec,k=f.split('.',1);require(raw.get(hashkey(sec,k))==v,'native field changed: '+name+'/'+f)
  actual=json.loads((root/'data/4.20/native_spells_420.json').read_bytes())
  for x in values:
   idx,_,f=x['current_keys'];row=actual[idx];require(row['values'].get(f)==x['current'],'local scalar changed')
   name=x['native_name'];require(row['champion']==name[:-1] and row['slot']==int(name[-1]) and row['spell']==native[name[:-1]]['fields'][f'Data.Spell{int(name[-1])+1}'] and row['native_resource']==native[name]['relative'],'primary row binding')
  xp=json.loads((root/'data/4.20/experience_curve_map10.json').read_bytes())
  require(all(float(native['xp']['fields'][f'EXP.Level{i}'])==float(xp['Values']['EXP'][f'Level{i}']) for i in range(2,19)),'XP thresholds')
  rules=json.loads((root/'data/4.20/cooldown_rules.json').read_bytes());require(rules['maximum_reduction']==-const['fields']['gcd_PercentCooldownModMinimum'] and rules['minimum_seconds']==const['fields']['gcd_CooldownMinimum'],'signed to positive local convention')
  require(m.inspect(text['relative'],m.deploy/text['relative'],text['source'])==text['membership'],'locale membership')
  strings=dict(re.findall(r'^tr "([^"]+)" = "(.*)"$',pathlib.Path(text['source']['path']).read_text(encoding='utf-8-sig'),re.M))
  require(all(e['key'] in strings and strings[e['key']]==e['text'] for e in text['entries'].values()),'native texts changed')
 return dict(verified=True,task_scopes=18,partial_feature_scopes=14,boundary_only_scopes=4,source_identities=len(pins),native_inibin=46,native_constants=1,native_locale_files=1,text_hooks=14,scalar_queries=360,numeric_equal_binary32=344,missing_queries=14,malformed_numeric=2,anchors=36,full_scopes_closed=0,native_server_policy_qualified=False)
def main():
 p=argparse.ArgumentParser();p.add_argument('--inputs',required=True);p.add_argument('--root',default='E:/OpenLeague');a=p.parse_args()
 try:r=audit(json.loads(pathlib.Path(a.inputs).read_bytes()),a.root)
 except (ContractError,KeyError,ValueError,OSError,IndexError) as e:print(json.dumps(dict(verified=False,error=str(e))));return 1
 print(json.dumps(r));return 0
if __name__=='__main__':raise SystemExit(main())
