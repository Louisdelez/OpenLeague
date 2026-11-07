"""Check seven actual local diagnostic links and one unresolved candidate scope."""
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
 require(q['schema']=='openleague_diagnostic_precise_link_inputs/v1' and q['passed'] is True,'schema/result')
 require(q['human_acceptance']=='not_given' and q['manual_state_mutated'] is False,'manual acceptance')
 require(q['native_qualifications_reexecuted'] is False and q['current_application_executed'] is False,'execution scope')
 require(q['full_task_scopes_closed']==q['questions_closed']==0,'scope closure')
 require(q['checks_count']==22 and len(q['checks'])==22 and len({c['case'] for c in q['checks']})==22 and all(c['result']=='pass' for c in q['checks']),'source controls')
 rows=q['associations'];require([r['task_id'] for r in rows]==[f'SYS-03.4-{i:02}' for i in range(1,9)],'task set')
 require([r['task_id'] for r in rows if r['entry_boundary_only']]==['SYS-03.4-08'],'restore feature boundary')
 require([r['task_id'] for r in rows if not r['anchors']]==['SYS-03.4-07'] and rows[6]['missing_required_input'],'generic candidate remains')
 require(len({r['existing_unknown_id'] for r in rows})==8,'unknown IDs')
 sources={str(pathlib.Path(s['path']).resolve()).casefold():s for s in q['source_identities']};require(len(sources)==len(q['source_identities'])==33,'source identities')
 require(sum(len(r['anchors']) for r in rows)==15,'actual role sites')
 for row in rows:
  require(row['full_task_scope_complete'] is False and row['native_server_policy_qualified'] is False and row['current_application_executed'] is False,'partial scope')
  require(row['task_package']=='D03-SYS-03-4' and row['basis'] and row['finding'] and row['remaining'],'findings and limits')
  require(row['native_bindings']==[],'local diagnostics are not native authority')
  for a in row['anchors']:
   require(a['line']>0 and a['entry_boundary_only']==row['entry_boundary_only'],'site boundary/line')
   require(sources.get(str(pathlib.Path(a['source']['path']).resolve()).casefold())==a['source'],'site source pin')
   require(a['needle'] in a['excerpt'],'site excerpt')
   if verify_files:require(pathlib.Path(a['source']['path']).read_text(encoding='utf-8').splitlines()[a['line']-1]==a['excerpt'],'site moved')
 obs=q['receipt_observations'];require(obs['current_binaries_are_not_live_process_observations'] is True,'disk is not liveness')
 require(set(obs['current_disk_binaries'])=={'target/debug/openleague-client.exe','target/debug/openleague-server.exe'},'disk binary set')
 stale=q['dated_receipt_current_disk_mismatches'];require(len(stale)==2,'two bounded dated mismatches')
 for r in stale:require(r['current_disk_identity_matches'] is False and r['recorded_client_sha256']!=r['observed_disk_client_sha256']==obs['current_disk_binaries']['target/debug/openleague-client.exe']['sha256'],'dated receipt scope')
 require('client_sha256' not in obs['receipt_sources']['docs/build_receipt.json']['recorded'],'general receipt top-level field absence')
 c=q['candidate_evaluation'];require(c['repo']=='ketd/AnvilKit' and c['commit']=='62ea6b1a11f6a722f655926f65b9c8926eb95430' and c['source']['sha256']=='a38b18c58278593480450cd9111012c7d639b4044ed796afe635cc776ff07379','candidate document provenance')
 require(c['task_candidate_identity_uniquely_established'] is False and c['actual_adoption_consumer_identified'] is False and c['dependency_or_results_installed'] is False and c['all_prior_12_adoption_decisions_stay_open'] is True,'candidate adoption remains unqualified')
 require(c['role'] and c['proposals'] and c['evaluation'] and q['inherited_native_contracts']=={},'candidate documentary scope')
 p=q['diagnostic_code_observation'];require(p['passed'] is True and p['source_unchanged'] is True and p['checks_count']==15,'classifier result')
 require(p['current_application_executed'] is False and p['diagnostic_lines_authenticated'] is False and p['actual_asset_failure_injected'] is False and p['raw_input_written_to_probe_output'] is False,'classifier scope')
 expected={'asset_upper':'asset_load_failed','asset_lower':'asset_load_failed','empty':'<unclassified>','unknown':'<unclassified>','lookalike':'<unclassified>','non_utf8_unmatched':'<unclassified>','asset_non_utf8':'asset_load_failed','forged_fixed':'r_cast_diag_request_asset_missing','embedded_fixed':'r_cast_diag_request_asset_missing','priority':'r_cast_diag_context_rejected','panic':'process_panic','server_started':'server_started','audio_unavailable':'audio_output_unavailable','arbitrary_secret':'<unclassified>','raw_path_only':'<unclassified>'}
 require(p['observed']==expected and all(c['expected']==c['observed']==expected[c['name']] for c in p['cases']) and len(p['cases'])==15,'classifier observations')
 require(len(p['commands'])==2 and all(c['exit_code']==0 for c in p['commands']),'terminal classifier commands')
 if verify_files:
  for s in sources.values():require(pin(s['path'])==s,'source changed: '+s['path'])
  for s in [p['source'],p['compiler'],p['isolated_source'],p['executable']]+list(obs['current_disk_binaries'].values()):require(pin(s['path'])==s,'classifier or disk identity')
  for c in p['commands']:
   for k in ['stdout','stderr']:require(pin(c[k]['path'])==c[k],'terminal classifier log')
 return dict(verified=True,task_scopes=8,precise_consumer_links=7,generic_candidate_still_open=True,sites=15,source_identities=33,source_controls=22,isolated_classifier_cases=15,dated_client_hash_mismatches=2,entry_boundaries=1,full_scopes_closed=0)
def main():
 p=argparse.ArgumentParser();p.add_argument('--inputs',required=True);a=p.parse_args()
 try:r=audit(json.loads(pathlib.Path(a.inputs).read_bytes()))
 except (ContractError,KeyError,OSError,IndexError,ValueError) as e:print(json.dumps(dict(verified=False,error=str(e))));return 1
 print(json.dumps(r));return 0
if __name__=='__main__':raise SystemExit(main())
