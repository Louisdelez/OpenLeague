"""Validate partial stat links;authoring values and local math are separate authorities."""
import argparse,hashlib,json,pathlib
class ContractError(ValueError):pass
def require(v,why):
 if not v:raise ContractError(why)
def pin(path):
 p=pathlib.Path(path);h=hashlib.sha256()
 with p.open('rb') as f:
  for b in iter(lambda:f.read(1024*1024),b''):h.update(b)
 return dict(path=str(p),bytes=p.stat().st_size,sha256=h.hexdigest())
def audit(inputs,verify_files=True):
 q=inputs
 require(q['schema']=='openleague_stat_precise_link_inputs/v1' and q['passed'] is True,'schema/result')
 require(q['human_acceptance']=='not_given' and q['manual_state_mutated'] is False,'manual acceptance')
 require(q['native_qualifications_reexecuted'] is False and q['current_application_executed'] is False,'execution scope')
 require(q['historical_rounding_qualified'] is False and q['native_server_formula_or_order_qualified'] is False,'historical arithmetic authority')
 require(q['full_task_scopes_closed']==q['questions_closed']==0,'scope closure')
 require(q['checks_count']==34 and len(q['checks'])==34 and len({c['case'] for c in q['checks']})==34 and all(c['result']=='pass' for c in q['checks']),'source controls')
 rows=q['associations'];require([r['task_id'] for r in rows]==[f'SYS-04.1-{i:02}' for i in range(1,8)],'task set')
 require(all(r['anchors'] and r['entry_boundary_only'] is False for r in rows),'actual partial consumers')
 require(len({r['existing_unknown_id'] for r in rows})==7,'unknown IDs')
 sources={str(pathlib.Path(s['path']).resolve()).casefold():s for s in q['source_identities']};require(len(sources)==len(q['source_identities'])==45,'source identities')
 require(sum(len(r['anchors']) for r in rows)==18,'actual role sites')
 require([r['task_id'] for r in rows if r['native_bindings']]==['SYS-04.1-01','SYS-04.1-03','SYS-04.1-04','SYS-04.1-06','SYS-04.1-07'],'native versus local scope')
 for row in rows:
  require(row['full_task_scope_complete'] is False and row['native_server_policy_qualified'] is False and row['current_application_executed'] is False,'partial scope')
  require(row['task_package']=='D04-SYS-04-1' and row['basis'] and row['finding'] and row['remaining'],'findings and limits')
  for a in row['anchors']:
   require(a['line']>0 and a['entry_boundary_only'] is False,'site line/scope')
   require(sources.get(str(pathlib.Path(a['source']['path']).resolve()).casefold())==a['source'],'site source pin')
   require(a['needle'] in a['excerpt'],'site excerpt')
   if verify_files:require(pathlib.Path(a['source']['path']).read_text(encoding='utf-8').splitlines()[a['line']-1]==a['excerpt'],'site moved')
  for b in row['native_bindings']:require(b['selector'] and b['source_role'] and b['membership']['status']=='matches_selected_project_manifest','native membership/role')
 n=q['native_source_observation'];require(set(n['native'])=={'Garen','GarenW','TrundleR','ExpCurve','Map10Constants'},'native member set')
 require(all(x['membership']['status']=='matches_selected_project_manifest' for x in n['native'].values()),'selected manifest membership')
 compare=n['Garen_growth_comparisons'];require(len(compare)==10 and sum(x['within_1e_5'] for x in compare)==8 and [x['native_value'] for x in compare if not x['within_1e_5']]==[None,None],'missing named regen properties are not numeric mismatches')
 require(all(v is None for v in q['regeneration_alias_research']['observed'].values()) and len(q['regeneration_alias_research']['observed'])==6,'bounded alias research')
 xp=q['XP_threshold_comparisons'];require(len(xp)==17 and [x['level'] for x in xp]==list(range(2,19)) and all(x['matches'] and float(x['native'])==float(x['current']) for x in xp),'XP threshold equality')
 require(n['native']['ExpCurve']['fields']['Level1'] is None,'no Level1 invented')
 require(n['native']['Map10Constants']['fields']['gcd_PercentCooldownModMinimum']==-0.4 and n['current_cooldown_rules']['maximum_reduction']==0.4,'signed native versus local CDR')
 require(all(float(v)==20. for k,v in n['native']['GarenW']['fields'].items() if k.startswith('Effect1')),'native W scalar')
 p=q['stat_helper_observation'];require(p['passed'] is True and p['source_unchanged'] is True and p['checks_count']==27,'helper result')
 require(p['historical_rounding_qualified'] is False and p['native_server_formula_or_modifier_order_qualified'] is False and p['invalid_stat_inputs_explicitly_rejected'] is False and p['current_application_executed'] is False,'helper scope')
 require(len(p['growth_cases'])==21 and [x['level'] for x in p['growth_cases']]==[0]+list(range(1,19))+[19,255],'growth level coverage')
 require(p['max_growth_ULP_difference_from_rational']==1 and p['growth_cases_differing_from_ideal_rounded_rational']==5 and sum(x['ULP_difference_from_ideal_rounded_rational']!=0 for x in p['growth_cases'])==5 and all(x['absolute_error']<=1e-5 for x in p['growth_cases']),'local rational agreement is not native bit parity')
 expected=[[58.,102.,44.],[58.,110.,52.],[58.,0.,-58.],[10.,-10.,-20.],[10.,0.,-10.],['NaN','NaN','NaN']]
 require([x['expected'] for x in p['component_cases']]==expected and [x['observed'] for x in p['component_cases']]==expected,'signed component/branch observations')
 require(len(p['commands'])==2 and all(c['exit_code']==0 for c in p['commands']),'terminal helper commands')
 if verify_files:
  for s in sources.values():require(pin(s['path'])==s,'source changed: '+s['path'])
  for s in [p['source'],p['compiler'],p['isolated_source'],p['executable']]:require(pin(s['path'])==s,'helper provenance')
  text=pathlib.Path(p['source']['path']).read_text(encoding='utf-8');require(all(v in text for v in p['extracted_helpers'].values()),'unchanged extracted helpers')
  for c in p['commands']:
   for k in ['stdout','stderr']:require(pin(c[k]['path'])==c[k],'terminal helper log')
 return dict(verified=True,task_scopes=7,sites=18,source_identities=45,source_controls=34,isolated_helper_cases=27,native_authoring_members=5,historical_rounding_qualified=False,full_scopes_closed=0)
def main():
 p=argparse.ArgumentParser();p.add_argument('--inputs',required=True);a=p.parse_args()
 try:r=audit(json.loads(pathlib.Path(a.inputs).read_bytes()))
 except (ContractError,KeyError,OSError,IndexError,ValueError) as e:print(json.dumps(dict(verified=False,error=str(e))));return 1
 print(json.dumps(r));return 0
if __name__=='__main__':raise SystemExit(main())
