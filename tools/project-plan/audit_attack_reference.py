"""Verify attack requirement links, authoring inputs and local scope; no gameplay acceptance."""
import argparse,hashlib,json,pathlib
class ContractError(ValueError):pass
def require(value,reason):
 if not value:raise ContractError(reason)
def pin(p):
 p=pathlib.Path(p);b=p.read_bytes();return dict(path=str(p.resolve()),bytes=len(b),sha256=hashlib.sha256(b).hexdigest())
def audit(q,root='E:/OpenLeague',verify_files=True):
 root=pathlib.Path(root)
 require(q['schema']=='openleague_attack_links/v1' and q['passed'] is True,'schema/result')
 require(q['current_application_executed'] is False and q['native_binary_executed'] is False,'execution scope')
 require(q['full_task_scopes_closed']==q['questions_closed']==0,'scope closure')
 require(q['checks_count']==len(q['checks']) and len(set(q['checks']))==len(q['checks']),'source check inventory')
 rows=q['associations'];require([r['task_id'] for r in rows]==[f'SYS-04.2-{i:02}' for i in range(1,11)],'task set')
 require(len({r['existing_unknown_id'] for r in rows})==10,'distinct unknowns')
 key=lambda p:str(pathlib.Path(p).resolve()).casefold()
 pins={key(s['path']):s for s in q['source_identities']};require(len(pins)==len(q['source_identities']),'duplicate source')
 natives={key(n['source']['path']):n for n in q['native_resources']}
 require(len(natives)==365==len(q['native_resources']),'native coverage')
 for r in rows:
  require(r['full_task_scope_complete'] is False and r['native_server_policy_qualified'] is False,'partial policy scope')
  require(r['finding'] and r['remaining'] and r['anchors'] and r['native_bindings'],'findings/source/consumer')
  for a in r['anchors']:
   p=(root/a['path']).resolve();require(p.is_relative_to(root.resolve()) and key(p) in pins,'consumer source')
   require(a['line']>0 and a['role'].startswith('attack_reference_') and a['needle'],'anchor contract')
   if verify_files:
    lines=p.read_text(encoding='utf-8').splitlines()
    require(a['line']<=len(lines) and a['needle'] in lines[a['line']-1],'consumer anchor moved')
  for b in r['native_bindings']:
   require(key(b['path']) in natives and b['selector'] and b['role']=='native_authoring_input_not_server_policy','native binding authority')
 for n in natives.values():
  require(pins.get(key(n['source']['path']))==n['source'],'native source pin')
  require(n['membership']['status']=='matches_selected_project_manifest' and n['fields'],'native membership')
 comparisons=q['profile_comparisons']
 require(len(comparisons)==244 and len({(c['table'],c['champion']) for c in comparisons})==244,'profile coverage')
 require(q['missing_spell_profiles']==[],'missing spell scope')
 for c in comparisons:
  require(c['table'] in ['attack_contracts','critical_contracts'] and c['result']=='pass' and c['expected']==c['observed'],'profile comparison')
  require(c['historical_formula_qualified'] is False,'formula authority')
 require(q['missing_authored_fields'].get('collision/gameplay_radius')==89,'missing radii retained')
 require(q['missing_authored_fields'].get('attack_contracts/AttackCastTime')==120,'missing cast times retained')
 if verify_files:
  from reference_inibin import read,hashkey
  from rads_reference_membership import RadsReferenceMembership
  for s in pins.values():require(pin(s['path'])=={k:s[k] for k in ['path','bytes','sha256']},'source changed: '+s['path'])
  m=RadsReferenceMembership(root)
  for n in natives.values():
   values=read(n['source']['path'])
   for field,expected in n['fields'].items():
    section,name=field.split('.',1)
    require(values.get(hashkey(section,name))==expected,'native field changed: '+field)
   require(m.inspect(n['relative'],n['source']['path'],n['source'])==n['membership'],'native membership changed')
  tables={name:json.loads((root/'data/4.20'/f'{name}.json').read_bytes()) for name in ['attack_contracts','critical_contracts']}
  for c in comparisons:
   require(c['observed']=={k:tables[c['table']][c['champion']][k] for k in c['expected']},'current profile differs')
 return dict(verified=True,task_scopes=10,source_identities=len(pins),native_resources=len(natives),profile_rows=244,anchors=sum(len(r['anchors']) for r in rows),full_scopes_closed=0,native_server_policy_qualified=False)
def main():
 p=argparse.ArgumentParser();p.add_argument('--inputs',required=True);p.add_argument('--root',default='E:/OpenLeague');a=p.parse_args()
 try:result=audit(json.loads(pathlib.Path(a.inputs).read_bytes()),a.root)
 except (ContractError,OSError,KeyError,IndexError,ValueError) as e:print(json.dumps(dict(verified=False,error=str(e))));return 1
 print(json.dumps(result));return 0
if __name__=='__main__':raise SystemExit(main())
