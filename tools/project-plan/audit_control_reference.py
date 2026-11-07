"""Qualify partial control links; never promote refusal boundaries to control implementations."""
import argparse,hashlib,json,pathlib,re
class ContractError(ValueError):pass
def require(value,reason):
 if not value:raise ContractError(reason)
def pin(p):
 p=pathlib.Path(p);b=p.read_bytes();return dict(path=str(p.resolve()),bytes=len(b),sha256=hashlib.sha256(b).hexdigest())
def audit(q,root='E:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);key=lambda p:str(pathlib.Path(p).resolve()).casefold()
 require(q['schema']=='openleague_control_links/v1' and q['passed'] is True,'schema/result')
 require(q['current_application_executed'] is False and q['native_binary_executed'] is False,'execution scope')
 require(q['full_task_scopes_closed']==q['questions_closed']==0 and q['global_feature_absence_proven'] is False,'scope/absence claims')
 # GarenQ, GarenW and Exhaust are inspected both as examples and disabled-cast rows.
 require(q['checks_count']==93==len(q['checks']) and len(set(q['checks']))==90,'source check inventory')
 rows=q['associations'];require([a['task_id'] for a in rows]==[f'SYS-04.4-{i:02}' for i in range(1,15)],'task set')
 boundaries=[f'SYS-04.4-{i:02}' for i in [3,6,7,8,9,10,12]]
 require([a['task_id'] for a in rows if a['entry_boundary_only']]==boundaries,'boundary-only scope')
 require(len({a['existing_unknown_id'] for a in rows})==14,'distinct unknowns')
 pins={key(s['path']):s for s in q['source_identities']};require(len(pins)==len(q['source_identities']),'source identities')
 natives={key(n['source']['path']):n for n in q['native_resources']};require(len(natives)==21==len(q['native_resources']),'native coverage')
 require(sum(len(a['anchors']) for a in rows)==37,'role sites')
 for a in rows:
  require(a['full_task_scope_complete'] is False and a['native_server_policy_qualified'] is False,'partial policy scope')
  require(a['finding'] and a['remaining'] and a['anchors'],'findings and consumers')
  require(bool(a['native_bindings'])==(a['task_id']!='SYS-04.4-14'),'local replication distinct from native policy')
  for c in a['anchors']:
   p=(root/c['path']).resolve();require(p.is_relative_to(root.resolve()) and key(p) in pins,'consumer source')
   require(c['line']>0 and c['needle'] and c['role'].startswith('control_reference_'),'consumer role')
   if verify_files:
    lines=p.read_text(encoding='utf-8').splitlines();require(c['line']<=len(lines) and c['needle'] in lines[c['line']-1],'anchor moved')
  for b in a['native_bindings']:require(key(b['path']) in natives and b['selector'] and b['role']=='native_authoring_input_not_server_policy','native binding authority')
 for n in natives.values():
  require(pins.get(key(n['source']['path']))==n['source'],'native pin')
  require(n['membership']['status']=='matches_selected_project_manifest' and n['fields'],'native membership/fields')
 text=q['native_text'];require(text['relative']=='DATA/Menu/fontconfig_en_GB.txt' and text['membership']['status']=='matches_selected_project_manifest','locale identity')
 require(len(text['entries'])==24 and all(e['key'] and e['text'] and e['source']==text['source'] for e in text['entries'].values()),'native descriptions')
 flags=q['disabled_cast_comparisons'];require(len(flags)==12 and len({x['spell'] for x in flags})==12,'disabled flag coverage')
 require([x['spell'] for x in flags if x['missing_policy_reconstructed']]==['RegenerationPotion','FlaskOfCrystalWater'],'missing defaults retained')
 for x in flags:
  raw=x['native']['fields']['CanCastWhileDisabled'];expected=bool(float(raw)) if raw is not None else False
  require(x['current']==x['expected']==expected and x['missing_policy_reconstructed']==(raw is None) and x['result']=='pass','flag comparison')
 require(q['search_inventory_files']>0,'bounded search scope')
 if verify_files:
  from reference_inibin import read,hashkey
  from rads_reference_membership import RadsReferenceMembership
  for s in pins.values():require(pin(s['path'])=={k:s[k] for k in ['path','bytes','sha256']},'source changed: '+s['path'])
  m=RadsReferenceMembership(root)
  for n in natives.values():
   values=read(n['source']['path'])
   for field,value in n['fields'].items():
    sec,prop=field.split('.',1);require(values.get(hashkey(sec,prop))==value,'native field differs: '+field)
   require(m.inspect(n['relative'],m.deploy/n['relative'],n['source'])==n['membership'],'native member differs')
  # Preserve the authored logical spelling; resolved Windows paths may normalize Menu to menu.
  require(m.inspect(text['relative'],m.deploy/text['relative'],text['source'])==text['membership'],'locale member differs')
  strings=dict(re.findall(r'^tr "([^"]+)" = "(.*)"$',pathlib.Path(text['source']['path']).read_text(encoding='utf-8-sig'),re.M))
  require(all(strings.get(e['key'])==e['text'] for e in text['entries'].values()),'localized description differs')
  rules=json.loads((root/'data/4.20/disabled_cast_rules.json').read_bytes())['allows']
  require(rules=={x['spell']:x['current'] for x in flags},'current disabled flags differ')
  for x in flags:
   n=natives[key(x['native']['source']['path'])]
   require(all(n['fields']['SpellData.'+k]==v for k,v in x['native']['fields'].items()),'disabled flag source mismatch')
  for x in q['selected_inputs'].values():
   n=natives[key(x['source']['path'])];require(all(n['fields']['SpellData.'+k]==v for k,v in x['fields'].items()),'example source mismatch')
 return dict(verified=True,task_scopes=14,partial_feature_scopes=7,boundary_only_scopes=7,source_identities=len(pins),native_resources=21,native_locale_files=1,text_hooks=24,disabled_flags=12,anchors=37,full_scopes_closed=0,native_server_policy_qualified=False)
def main():
 p=argparse.ArgumentParser();p.add_argument('--inputs',required=True);p.add_argument('--root',default='E:/OpenLeague');a=p.parse_args()
 try:r=audit(json.loads(pathlib.Path(a.inputs).read_bytes()),a.root)
 except (ContractError,KeyError,ValueError,OSError,IndexError) as e:print(json.dumps(dict(verified=False,error=str(e))));return 1
 print(json.dumps(r));return 0
if __name__=='__main__':raise SystemExit(main())
