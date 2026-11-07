"""Verify source associations for partial lifecycle mechanisms, without claiming server parity."""
import argparse,hashlib,json,pathlib,re,struct
class ContractError(ValueError):pass
def require(v,why):
 if not v:raise ContractError(why)
def pin(p):
 p=pathlib.Path(p);b=p.read_bytes();return dict(path=str(p.resolve()),bytes=len(b),sha256=hashlib.sha256(b).hexdigest())
def audit(q,root='E:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);key=lambda p:str(pathlib.Path(p).resolve()).casefold()
 require(q['schema']=='openleague_lifecycle_links/v1' and q['passed'] is True,'schema/result')
 require(q['current_application_executed'] is False and q['native_binary_executed'] is False,'execution scope')
 require(q['full_task_scopes_closed']==q['questions_closed']==0 and q['global_feature_absence_proven'] is False,'scope/absence claims')
 require(q['checks_count']==67==len(q['checks'])==len(set(q['checks'])),'source checks')
 require(q['native_death_scaling_consumed_by_baseline'] is False,'late-match scaling not consumed')
 require(q['local_disconnect_contract']==dict(legacy='remove_actor_after_30s',resumable='detach_endpoint_keep_actor_while_open',retirement='remove_actor_on_leave_abandon_or_owner_drain',control_clock='simulation_ticks_while_unpaused',silence_clock='host_elapsed_time',original_server_policy_qualified=False),'disconnect policy and clock distinction')
 rows=q['associations'];require([a['task_id'] for a in rows]==[f'SYS-04.5-{i:02}' for i in range(1,9)],'task set')
 require([a['task_id'] for a in rows if a['entry_boundary_only']]==[f'SYS-04.5-{i:02}' for i in range(1,5)],'boundary scope')
 require(len({a['existing_unknown_id'] for a in rows})==8,'distinct unknowns')
 pins={key(s['path']):s for s in q['source_identities']};require(len(pins)==len(q['source_identities']),'unique pins')
 natives={key(n['source']['path']):n for n in q['native_resources']};require(len(natives)==9==len(q['native_resources']),'native set')
 require(sum(len(a['anchors']) for a in rows)==23,'role sites')
 examples=q['selected_inputs'];names=['invulnerable','untargetable','CC_immunity','spell_shield','slow_cleanse','revival','transformation','cleanse']
 require(set(examples)==set(names),'example coverage')
 source_roles=[['invulnerable'],['untargetable'],['CC_immunity'],['spell_shield'],['slow_cleanse','cleanse'],[],['revival','transformation'],[]]
 for i,a in enumerate(rows):
  require(a['full_task_scope_complete'] is False and a['native_server_policy_qualified'] is False,'partial policy scope')
  require(a['finding'] and a['remaining'] and a['anchors'],'findings and consumers')
  require([key(b['path']) for b in a['native_bindings']]==[key(examples[n]['source']['path']) for n in source_roles[i]],'native example association / local-only policy')
  for c in a['anchors']:
   p=(root/c['path']).resolve();require(p.is_relative_to(root.resolve()) and key(p) in pins,'consumer source')
   require(c['line']>0 and c['needle'] and c['role'].startswith('lifecycle_reference_'),'consumer role')
   if verify_files:
    lines=p.read_text(encoding='utf-8').splitlines();require(c['line']<=len(lines) and c['needle'] in lines[c['line']-1],'anchor moved')
  for b in a['native_bindings']:require(key(b['path']) in natives and b['selector'] and b['role']=='native_authoring_input_not_server_policy','native binding authority')
 for n in natives.values():
  require(pins.get(key(n['source']['path']))==n['source'],'native pin')
  require(n['membership']['status']=='matches_selected_project_manifest' and n['fields'],'native membership/fields')
 for x in examples.values():
  n=natives[key(x['source']['path'])];require(all(x[k]==n[k] for k in ['source','relative','membership','fields']),'example matches source')
 text=q['native_text'];require(text['relative']=='DATA/Menu/fontconfig_en_GB.txt' and text['membership']['status']=='matches_selected_project_manifest','locale identity')
 require(len(text['entries'])==16 and pins[key(text['source']['path'])]==text['source'],'locale pin/hooks')
 for name in names:
  for prop in ['Description','DynamicTooltip']:
   e=text['entries'][name+'/'+prop];require(e['key']==examples[name]['fields']['SpellData.'+prop] and e['text'] and e['source']==text['source'],'native text hook binding')
 death=next(n for n in natives.values() if n['relative']=='LEVELS/Map10/DeathTimes.inibin')
 vals=q['death_comparisons'];require(len(vals)==24 and {x['field'] for x in vals}==set(death['fields']),'death field coverage')
 require([x['field'] for x in vals if not x['numeric_equal']]==['DeathTimeScaling.PercentIncrease'],'decimal/binary32 distinction retained')
 for x in vals:
  a=struct.pack('<f',float(x['native'])).hex();b=struct.pack('<f',float(x['current'])).hex()
  require(x['native']==death['fields'][x['field']] and x['native_binary32_hex']==a and x['current_binary32_hex']==b and x['binary32_equal']==(a==b) and a==b,'binary32 source comparison')
  require(x['numeric_equal']==(float(x['native'])==float(x['current'])) and x['comparison_scope'],'raw numeric comparison')
 if verify_files:
  from reference_inibin import read,hashkey
  from rads_reference_membership import RadsReferenceMembership
  for s in pins.values():require(pin(s['path'])=={k:s[k] for k in ['path','bytes','sha256']},'source changed: '+s['path'])
  m=RadsReferenceMembership(root)
  for n in natives.values():
   values=read(n['source']['path'])
   for f,v in n['fields'].items():
    sec,prop=f.split('.',1);require(values.get(hashkey(sec,prop))==v,'native field differs: '+f)
   require(m.inspect(n['relative'],m.deploy/n['relative'],n['source'])==n['membership'],'native member differs')
  require(m.inspect(text['relative'],m.deploy/text['relative'],text['source'])==text['membership'],'locale member differs')
  strings=dict(re.findall(r'^tr "([^"]+)" = "(.*)"$',pathlib.Path(text['source']['path']).read_text(encoding='utf-8-sig'),re.M))
  require(all(strings.get(e['key'])==e['text'] for e in text['entries'].values()),'localized description differs')
  current=json.loads((root/'data/4.20/death_times_map10.json').read_bytes())['Values']
  for x in vals:
   sec,p=x['field'].split('.',1);require(x['current']==current[sec][p],'current death table differs')
 return dict(verified=True,task_scopes=8,partial_feature_scopes=4,boundary_only_scopes=4,source_identities=len(pins),native_resources=9,native_locale_files=1,text_hooks=16,death_fields=24,anchors=23,full_scopes_closed=0,native_server_policy_qualified=False)
def main():
 p=argparse.ArgumentParser();p.add_argument('--inputs',required=True);p.add_argument('--root',default='E:/OpenLeague');a=p.parse_args()
 try:r=audit(json.loads(pathlib.Path(a.inputs).read_bytes()),a.root)
 except (ContractError,KeyError,ValueError,OSError,IndexError) as e:print(json.dumps(dict(verified=False,error=str(e))));return 1
 print(json.dumps(r));return 0
if __name__=='__main__':raise SystemExit(main())
