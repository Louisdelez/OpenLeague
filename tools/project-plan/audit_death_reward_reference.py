"""Read-only qualification of partial reward/death associations; preserve empty native text."""
import argparse,hashlib,json,pathlib,re,struct
class ContractError(ValueError):pass
def require(v,why):
 if not v:raise ContractError(why)
def pin(p):
 p=pathlib.Path(p);b=p.read_bytes();return dict(path=str(p.resolve()),bytes=len(b),sha256=hashlib.sha256(b).hexdigest())
def audit(q,root='E:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);key=lambda p:str(pathlib.Path(p).resolve()).casefold()
 require(q['schema']=='openleague_death_reward_links/v1' and q['passed'] is True,'schema/result')
 require(q['current_application_executed'] is False and q['native_binary_executed'] is False,'execution scope')
 require(q['full_task_scopes_closed']==q['questions_closed']==0 and q['global_feature_absence_proven'] is False,'scope/absence claims')
 require(q['checks_count']==119==len(q['checks'])==len(set(q['checks'])),'source checks')
 require(all(q[k] is False for k in ['native_reward_algorithm_qualified','bounty_modifiers_consumed','native_death_scaling_consumed','recall_feature_qualified','special_revival_feature_qualified','owner_death_equals_departure']),'local policy scope')
 require(q['recap_scope']=='local_owner_only_atomic_OLSR_not_legacy_or_historical_UI','recap privacy/transport scope')
 rows=q['associations'];require([a['task_id'] for a in rows]==[f'SYS-04.7-{i:02}' for i in range(1,11)],'task set')
 require([a['task_id'] for a in rows if a['entry_boundary_only']]==[f'SYS-04.7-{i:02}' for i in [4,6,7]],'boundary scope')
 require(len({a['existing_unknown_id'] for a in rows})==10,'distinct unknowns')
 pins={key(s['path']):s for s in q['source_identities']};require(len(pins)==len(q['source_identities']),'unique pins')
 inputs=q['native_inputs'];scenes=q['native_scenes'];allnative=inputs|scenes
 require(set(inputs)=={'bounty','experience','death','recall','revival'} and set(scenes)=={'spawn1','spawn2'},'native coverage')
 roles=[['bounty','experience'],['bounty'],['bounty'],['bounty'],['death'],['revival'],['recall'],['spawn1','spawn2'],[],[]]
 require(sum(len(a['anchors']) for a in rows)==24,'role sites')
 for i,a in enumerate(rows):
  require(a['full_task_scope_complete'] is False and a['native_server_policy_qualified'] is False,'partial policy scope')
  require(a['finding'] and a['remaining'] and a['anchors'],'findings and consumers')
  require([key(b['path']) for b in a['native_bindings']]==[key(allnative[n]['source']['path']) for n in roles[i]],'native association/local-only policy')
  for c in a['anchors']:
   p=(root/c['path']).resolve();require(p.is_relative_to(root.resolve()) and key(p) in pins,'consumer source')
   require(c['line']>0 and c['needle'] and c['role'].startswith('death_reward_reference_'),'consumer role')
   if verify_files:
    lines=p.read_text(encoding='utf-8').splitlines();require(c['line']<=len(lines) and c['needle'] in lines[c['line']-1],'anchor moved')
  for b in a['native_bindings']:require(b['selector'] and b['role']=='native_authoring_input_not_server_policy','native binding authority')
 for n in allnative.values():
  require(pins.get(key(n['source']['path']))==n['source'],'native pin')
  require(n['membership']['status']=='matches_selected_project_manifest' and n['fields'],'native membership/fields')
 text=q['native_text'];require(text['relative']=='DATA/Menu/fontconfig_en_GB.txt' and text['membership']['status']=='matches_selected_project_manifest','locale identity')
 require(len(text['entries'])==4 and pins[key(text['source']['path'])]==text['source'],'locale pin/hooks')
 require(q['empty_text_hooks']==['recall/DynamicTooltip'] and q['missing_text_hooks']==[],'empty versus missing native text')
 for name in ['recall','revival']:
  for prop in ['Description','DynamicTooltip']:
   e=text['entries'][name+'/'+prop];require(e['key']==inputs[name]['fields']['SpellData.'+prop] and isinstance(e['text'],str) and e['source']==text['source'],'text hook binding')
 require(text['entries']['recall/DynamicTooltip']['text']=='' and text['entries']['recall/Description']['text']=='No description','unqualified recall text preserved')
 vals=q['scalar_comparisons'];require(len(vals)==72 and len({(x['native_name'],x['native_field'],x['current_path'],str(x['current_keys'])) for x in vals})==72,'scalar coverage')
 allowed={'data/4.20/champion_kill_rules.json','data/4.20/experience_curve_map10.json','data/4.20/death_times_map10.json','data/4.20/champion_spawns_map10.json'}
 for x in vals:
  require(x['current_path'] in allowed and key(root/x['current_path']) in pins,'current scalar path')
  require(x['native']==allnative[x['native_name']]['fields'][x['native_field']] and x['runtime_semantics_qualified'] is False,'scalar source/scope')
  require(x['binary32_equal'] is True and struct.pack('<f',float(x['native']))==struct.pack('<f',float(x['current'])),'scalar binary32 comparison')
  require(x['numeric_equal']==(float(x['native'])==float(x['current'])),'raw numeric discrepancy retained')
 if verify_files:
  from reference_inibin import read,hashkey
  from rads_reference_membership import RadsReferenceMembership
  for s in pins.values():require(pin(s['path'])=={k:s[k] for k in ['path','bytes','sha256']},'source changed: '+s['path'])
  m=RadsReferenceMembership(root)
  for name,n in allnative.items():
   require(m.inspect(n['relative'],m.deploy/n['relative'],n['source'])==n['membership'],'native member differs')
   if name in inputs:
    values=read(n['source']['path'])
    for f,v in n['fields'].items():
     sec,prop=f.split('.',1);require(values.get(hashkey(sec,prop))==v,'native field differs: '+f)
   else:
    at=re.findall(r'^CentralPoint=\s*([^\r\n]+)',pathlib.Path(n['source']['path']).read_text(encoding='utf-8'),re.M)
    require(len(at)==1 and dict(zip(['CentralPoint.x','CentralPoint.y','CentralPoint.z'],map(float,at[0].split())))==n['fields'],'native spawn differs')
  require(m.inspect(text['relative'],m.deploy/text['relative'],text['source'])==text['membership'],'locale member differs')
  strings=dict(re.findall(r'^tr "([^"]+)" = "(.*)"$',pathlib.Path(text['source']['path']).read_text(encoding='utf-8-sig'),re.M))
  require(all(e['key'] in strings and strings[e['key']]==e['text'] for e in text['entries'].values()),'localized text differs')
  for x in vals:
   v=json.loads((root/x['current_path']).read_bytes())
   for k in x['current_keys']:v=v[int(k)] if isinstance(v,list) else v[k]
   require(x['current']==v,'current scalar differs')
 return dict(verified=True,task_scopes=10,partial_feature_scopes=7,boundary_only_scopes=3,source_identities=len(pins),native_inibin=5,native_scenes=2,native_locale_files=1,text_hooks=4,empty_native_tooltips=1,scalar_comparisons=72,anchors=24,full_scopes_closed=0,native_server_policy_qualified=False)
def main():
 p=argparse.ArgumentParser();p.add_argument('--inputs',required=True);p.add_argument('--root',default='E:/OpenLeague');a=p.parse_args()
 try:r=audit(json.loads(pathlib.Path(a.inputs).read_bytes()),a.root)
 except (ContractError,KeyError,ValueError,OSError,IndexError) as e:print(json.dumps(dict(verified=False,error=str(e))));return 1
 print(json.dumps(r));return 0
if __name__=='__main__':raise SystemExit(main())
