"""Check actual local data scopes without promoting unrelated version namespaces."""
import argparse,hashlib,json,pathlib
class ContractError(ValueError):pass
def require(v,why):
 if not v:raise ContractError(why)
def pin(path):
 p=pathlib.Path(path);b=p.read_bytes();return dict(path=str(p),bytes=len(b),sha256=hashlib.sha256(b).hexdigest())
def audit(inputs,verify_files=True):
 q=inputs
 require(q['schema']=='openleague_data_schema_precise_link_inputs/v1' and q['passed'] is True,'schema/result')
 require(q['human_acceptance']=='not_given' and q['manual_state_mutated'] is False,'manual acceptance')
 require(q['native_qualifications_reexecuted'] is False and q['current_application_executed'] is False,'execution scope')
 require(q['full_task_scopes_closed']==q['questions_closed']==0,'scope closure')
 require(q['checks_count']==22 and len(q['checks'])==22 and len({c['case'] for c in q['checks']})==22 and all(c['result']=='pass' for c in q['checks']),'source controls')
 rows=q['associations'];require([r['task_id'] for r in rows]==[f'SYS-03.3-{i:02}' for i in range(1,9)],'task set')
 require([r['task_id'] for r in rows if r['entry_boundary_only']]==['SYS-03.3-01','SYS-03.3-02','SYS-03.3-03','SYS-03.3-05','SYS-03.3-07'],'five feature boundaries')
 require(len({r['existing_unknown_id'] for r in rows})==8,'unknown IDs')
 sources={str(pathlib.Path(s['path']).resolve()).casefold():s for s in q['source_identities']}
 require(len(sources)==35 and len(q['source_identities'])==35,'source identities')
 require(sum(len(r['anchors']) for r in rows)==23,'site count')
 for row in rows:
  require(row['full_task_scope_complete'] is False and row['native_server_policy_qualified'] is False and row['current_application_executed'] is False,'partial scope')
  require(row['task_package']=='D03-SYS-03-3' and row['basis'] and row['finding'] and row['remaining'],'findings and limits')
  require(row['native_bindings']==[],'local construction is not native Riot specification')
  for a in row['anchors']:
   require(a['line']>0 and a['entry_boundary_only']==row['entry_boundary_only'],'site boundary/line')
   require(sources.get(str(pathlib.Path(a['source']['path']).resolve()).casefold())==a['source'],'site source pin')
   require(a['needle'] in a['excerpt'],'site excerpt')
   if verify_files:
    lines=pathlib.Path(a['source']['path']).read_text(encoding='utf-8').splitlines();require(a['excerpt']==lines[a['line']-1],'site moved')
 ds=q['dataset_observations'];require(len(ds)==6 and q['inherited_native_contracts']=={},'local dataset scope')
 require(ds['data/4.20/champions.json']['root_type']=='list' and ds['data/4.20/champions.json']['row_count']==122 and ds['data/4.20/champions.json']['version_fields']=={},'champion array is not schema envelope')
 require(ds['data/4.20/map10_shop_admission.json']['version_fields']=={'schema':1,'map_id':10},'item admission subschema')
 require(ds['data/4.20/shop_foundation.json']['version_fields']=={} and ds['data/4.20/map10_world.json']['version_fields']=={},'unversioned inspected roots')
 require(ds['data/4.20/map10_dense_height/navigation_metadata.json']['version_fields']=={'version':'3.1'},'native navigation format namespace')
 require(ds['assets-manifest.json']['version_fields']['schema_version']==1,'distribution manifest schema')
 p=q['data_parser_observation'];require(p['passed'] is True and p['source_unchanged'] is True and p['checks_count']==15 and p['refusals']==14,'actual parser result')
 require(p['native_FP_parity_qualified'] is False and p['current_application_executed'] is False,'synthetic parser scope')
 expected={'nominal_center':'40700000','dimensions':'DimensionsTooSmall','overflow':'SampleCountOverflow','index_precision':'DimensionExceedsF32IndexPrecision { axis: X, count: 16777218 }','bounds_X':'InvalidBounds { axis: X }','bounds_Z':'InvalidBounds { axis: Z }','spacing_X':'InvalidSpacing { axis: X }','spacing_Z':'InvalidSpacing { axis: Z }','missing_payload':'PayloadLength { expected: 16, actual: 0 }','truncated_payload':'PayloadLength { expected: 16, actual: 15 }','extra_payload':'PayloadLength { expected: 16, actual: 20 }','nonfinite_sample':'NonFiniteSample { index: 0, bits: 2143289344 }','missing_coverage':'LastSampleNotCovered { axis: X, expected_last: 1, normalized_max: 2.0 }','nonfinite_coordinate':'NonFiniteCoordinate { axis: X }','outside_coordinate':'OutsideBounds { axis: Z }'}
 require(p['observed']==expected,'numerical/refusal observations')
 require(len(p['commands'])==2 and all(c['exit_code']==0 for c in p['commands']),'terminal parser commands')
 if verify_files:
  for s in sources.values():require(pin(s['path'])==s,'source changed: '+s['path'])
  for name,d in ds.items():
   require(pin(d['source']['path'])==d['source'],'dataset changed')
   actual=json.loads(pathlib.Path(d['source']['path']).read_bytes())
   require(type(actual).__name__==d['root_type'],'dataset root type')
   if isinstance(actual,dict):require(list(actual)==d['root_keys'] and {k:v for k,v in actual.items() if k in ['schema','schema_version','version','map_id','release']}==d['version_fields'],'dataset version fields')
  for s in [p['source'],p['compiler'],p['isolated_source'],p['executable']]:require(pin(s['path'])==s,'parser source/tool identity')
  for c in p['commands']:
   for k in ['stdout','stderr']:require(pin(c[k]['path'])==c[k],'parser terminal log')
 return dict(verified=True,task_scopes=8,sites=23,source_identities=35,source_controls=22,isolated_parser_cases=15,parser_refusals=14,entry_boundaries=5,full_scopes_closed=0)
def main():
 p=argparse.ArgumentParser();p.add_argument('--inputs',required=True);args=p.parse_args()
 try:r=audit(json.loads(pathlib.Path(args.inputs).read_bytes()))
 except (ContractError,KeyError,OSError,IndexError,ValueError) as e:print(json.dumps(dict(verified=False,error=str(e))));return 1
 print(json.dumps(r));return 0
if __name__=='__main__':raise SystemExit(main())
