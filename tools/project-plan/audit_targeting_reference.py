"""Verify source associations for partial targeting mechanisms, without claiming server parity."""
import argparse,hashlib,json,pathlib,re,struct
class ContractError(ValueError):pass
def require(v,why):
 if not v:raise ContractError(why)
def pin(p):
 p=pathlib.Path(p);b=p.read_bytes();return dict(path=str(p.resolve()),bytes=len(b),sha256=hashlib.sha256(b).hexdigest())
def audit(q,root='E:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);key=lambda p:str(pathlib.Path(p).resolve()).casefold()
 require(q['schema']=='openleague_targeting_links/v1' and q['passed'] is True,'schema/result')
 require(q['current_application_executed'] is False and q['native_binary_executed'] is False,'execution scope')
 require(q['full_task_scopes_closed']==q['questions_closed']==0 and q['global_feature_absence_proven'] is False,'scope/absence claims')
 require(q['checks_count']==59==len(q['checks'])==len(set(q['checks'])),'source checks')
 require(all(q[k] is False for k in ['native_flag_semantics_decoded','universal_targeting_policy_qualified','channel_and_charge_features_implemented','geometry_native_parity']),'local policy scope')
 require(q['replay_scope']=='local_authenticated_sequence_and_per_shot_tick_and_hit_gates_only','limited replay guarantee')
 rows=q['associations'];require([a['task_id'] for a in rows]==[f'SYS-04.6-{i:02}' for i in range(1,13)],'task set')
 require([a['task_id'] for a in rows if a['entry_boundary_only']]==[f'SYS-04.6-{i:02}' for i in [7,8]],'boundary scope')
 require(len({a['existing_unknown_id'] for a in rows})==12,'distinct unknowns')
 pins={key(s['path']):s for s in q['source_identities']};require(len(pins)==len(q['source_identities']),'unique pins')
 natives={key(n['source']['path']):n for n in q['native_resources']};require(len(natives)==13==len(q['native_resources']),'native set')
 require(sum(len(a['anchors']) for a in rows)==28,'role sites')
 examples=q['selected_inputs'];names=['garenE','garenR','annieW','annieR','ezrealQ','ezrealW','ezrealR','trundleE','charges','channel','heal','smite','garenCancel']
 require(set(examples)==set(names),'example coverage')
 source_roles=[['heal','ezrealW','ezrealQ'],['ezrealQ','smite'],['annieR'],['annieW'],['ezrealQ'],['garenR','trundleE','annieR'],['channel'],['charges'],['garenE','garenCancel','annieR'],['ezrealQ','ezrealR'],[],['trundleE']]
 for i,a in enumerate(rows):
  require(a['full_task_scope_complete'] is False and a['native_server_policy_qualified'] is False,'partial policy scope')
  require(a['finding'] and a['remaining'] and a['anchors'],'findings and consumers')
  require([key(b['path']) for b in a['native_bindings']]==[key(examples[n]['source']['path']) for n in source_roles[i]],'native example association / local-only policy')
  for c in a['anchors']:
   p=(root/c['path']).resolve();require(p.is_relative_to(root.resolve()) and key(p) in pins,'consumer source')
   require(c['line']>0 and c['needle'] and c['role'].startswith('targeting_reference_'),'consumer role')
   if verify_files:
    lines=p.read_text(encoding='utf-8').splitlines();require(c['line']<=len(lines) and c['needle'] in lines[c['line']-1],'anchor moved')
  for b in a['native_bindings']:require(key(b['path']) in natives and b['selector'] and b['role']=='native_authoring_input_not_server_policy','native binding authority')
 for n in natives.values():
  require(pins.get(key(n['source']['path']))==n['source'],'native pin')
  require(n['membership']['status']=='matches_selected_project_manifest' and n['fields'],'native membership/fields')
 for x in examples.values():
  n=natives[key(x['source']['path'])];require(all(x[k]==n[k] for k in ['source','relative','membership','fields']),'example matches source')
 text=q['native_text'];require(text['relative']=='DATA/Menu/fontconfig_en_GB.txt' and text['membership']['status']=='matches_selected_project_manifest','locale identity')
 require(len(text['entries'])==26 and pins[key(text['source']['path'])]==text['source'],'locale pin/hooks')
 for name in names:
  for prop in ['Description','DynamicTooltip']:
   e=text['entries'][name+'/'+prop];require(e['key']==examples[name]['fields']['SpellData.'+prop] and e['text'] and e['source']==text['source'],'native text hook binding')
 require(q['unresolved_text_hooks']==[],'text hooks resolved')
 vals=q['geometry_scalar_comparisons'];require(len(vals)==4,'geometry field coverage')
 expected=[('annieW','CastRange','annie_w_rules.json','range'),('annieW','CastConeAngle','annie_w_rules.json','half_angle'),('annieR','CastRange','annie_r_rules.json','range'),('annieR','CastRadius','annie_r_rules.json','radius')]
 for x,(name,field,file,prop) in zip(vals,expected,strict=True):
  require(x['example']==name and x['source_field']=='SpellData.'+field and x['current_path']=='data/4.20/'+file and x['current_key']==prop,'scalar association')
  require(x['native']==examples[name]['fields']['SpellData.'+field] and x['binary32_equal'] is True and x['interpretation_qualified'] is False,'scalar source and interpretation')
  require(struct.pack('<f',float(x['native']))==struct.pack('<f',float(x['current'])),'scalar binary32 equality')
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
  for x in vals:
   require(x['current']==json.loads((root/x['current_path']).read_bytes())[x['current_key']],'current geometry scalar differs')
 return dict(verified=True,task_scopes=12,partial_feature_scopes=10,boundary_only_scopes=2,source_identities=len(pins),native_resources=13,native_locale_files=1,text_hooks=26,geometry_scalars=4,anchors=28,full_scopes_closed=0,native_server_policy_qualified=False)

def main():
 p=argparse.ArgumentParser();p.add_argument('--inputs',required=True);p.add_argument('--root',default='E:/OpenLeague');a=p.parse_args()
 try:r=audit(json.loads(pathlib.Path(a.inputs).read_bytes()),a.root)
 except (ContractError,KeyError,ValueError,OSError,IndexError) as e:print(json.dumps(dict(verified=False,error=str(e))));return 1
 print(json.dumps(r));return 0
if __name__=='__main__':raise SystemExit(main())
