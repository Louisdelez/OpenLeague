"""Validate precise partial scope, source identities and extracted-helper evidence."""
import argparse,hashlib,json,pathlib
class ContractError(ValueError):pass
def require(value,reason):
 if not value:raise ContractError(reason)
def pin(path):
 p=pathlib.Path(path);b=p.read_bytes();return dict(path=str(p),bytes=len(b),sha256=hashlib.sha256(b).hexdigest())
def audit(inputs,verify_files=True):
 q=inputs
 require(q['schema']=='openleague_clock_transform_precise_link_inputs/v1' and q['passed'] is True,'schema/result')
 require(q['human_acceptance']=='not_given' and q['manual_state_mutated'] is False,'manual acceptance')
 require(q['native_qualifications_reexecuted'] is False and q['current_application_executed'] is False,'execution scope')
 require(q['full_task_scopes_closed']==q['questions_closed']==0,'scope closure')
 require(q['checks_count']==22 and len(q['checks'])==22 and len({c['case'] for c in q['checks']})==22 and all(c['result']=='pass' for c in q['checks']),'source controls')
 rows=q['associations'];require([r['task_id'] for r in rows]==[f'SYS-03.2-{i:02}' for i in range(1,9)],'task set')
 require([r['task_id'] for r in rows if r['entry_boundary_only']]==['SYS-03.2-07'],'namespace boundary')
 require(len({r['existing_unknown_id'] for r in rows})==8,'unknown identities')
 sources={str(pathlib.Path(s['path']).resolve()).casefold():s for s in q['source_identities']}
 require(len(sources)==len(q['source_identities']) and len(sources)>=40,'source identities')
 require(sum(len(r['anchors']) for r in rows)==25,'exact sites')
 for row in rows:
  require(row['full_task_scope_complete'] is False and row['native_server_policy_qualified'] is False and row['current_application_executed'] is False,'partial scope')
  require(row['task_package']=='D03-SYS-03-2' and row['basis'] and row['finding'] and row['remaining'],'source findings and limits')
  require(row['anchors'] and len({a['role'] for a in row['anchors']})==len(row['anchors']),'site roles')
  for a in row['anchors']:
   require(a['line']>0 and a['entry_boundary_only']==row['entry_boundary_only'],'site boundary/line')
   require(sources.get(str(pathlib.Path(a['source']['path']).resolve()).casefold())==a['source'],'site source pin')
   require(a['needle'] in a['excerpt'],'site excerpt')
   if verify_files:
    lines=pathlib.Path(a['source']['path']).read_text(encoding='utf-8').splitlines()
    require(a['needle'] in lines[a['line']-1] and lines[a['line']-1]==a['excerpt'],'current site changed')
  require(bool(row['native_bindings'])==(row['task_id'] in ['SYS-03.2-02','SYS-03.2-03','SYS-03.2-04','SYS-03.2-05']),'native versus local scope')
  for b in row['native_bindings']:
   require(b['qualification_inherited_not_reexecuted'] is True and b['selector'],'native proof provenance')
   require(b['native_source']['sha256']=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862','native binary')
 contracts=q['inherited_native_contracts'];require(set(contracts)=={'game_clock_source','game_clock_pause_incoming','terrain_transform','entity_yaw'},'native contract set')
 for name,c in contracts.items():
  require(c['qualification_inherited_not_reexecuted'] is True and c['limits'] and c['case_count']>0,'native scope limits')
  if verify_files:
   d=json.loads(pathlib.Path(c['source']['path']).read_bytes())
   require(d['passed'] is True and d['complete'] is False and len(d['cases'])==c['case_count'] and d['limits']==c['limits'],'inherited native contract changed')
 require(contracts['terrain_transform']['authored_bounds_redecoded']==[0.,-1440.2152099609375,-0.,15398.671875,0.,15398.671875],'SCB bounds')
 p=q['seconds_helper_observation']
 require(p['constant']=='pub const TICK_RATE: u64 = 30;' and p['helper']=='pub fn seconds(value: f32) -> u64 {\n    (value * TICK_RATE as f32).ceil() as u64\n}','exact local helper')
 require(p['invalid_inputs_explicitly_rejected'] is False and p['original_server_tick_rate_established'] is False and p['nonfinite_and_negative_values_follow_Rust_saturating_cast'] is True,'helper numerical limits')
 expected=[0,0,0,1,2,15,30,45,53,68,113,0,0,2**64-1,2**64-1]
 require(len(p['cases'])==15 and [x['expected'] for x in p['cases']]==expected and [x['observed'] for x in p['cases']]==expected and all(x['result']=='pass' for x in p['cases']),'helper numerical results')
 require(len(p['commands'])==2 and all(c['exit_code']==0 for c in p['commands']),'terminal compiler/helper commands')
 if verify_files:
  for s in sources.values():require(pin(s['path'])==s,'source hash changed: '+s['path'])
  for s in [p['compiler'],p['isolated_source'],p['executable']]+p['source_files']:
   require(pin(s['path'])==s,'helper provenance changed')
  for c in p['commands']:
   for key in ['stdout','stderr']:require(pin(c[key]['path'])==c[key],'helper log changed')
 return dict(verified=True,task_scopes=8,sites=25,source_identities=len(sources),source_controls=22,isolated_helper_cases=15,native_proof_inherited=True,full_scopes_closed=0)
def main():
 p=argparse.ArgumentParser();p.add_argument('--inputs',required=True);args=p.parse_args()
 try:r=audit(json.loads(pathlib.Path(args.inputs).read_bytes()))
 except (ContractError,KeyError,OSError,IndexError,ValueError) as e:print(json.dumps(dict(verified=False,error=str(e))));return 1
 print(json.dumps(r));return 0
if __name__=='__main__':raise SystemExit(main())
