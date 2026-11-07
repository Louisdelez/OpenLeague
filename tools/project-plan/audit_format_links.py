"""Readonly actual-consumer audit: precise source links, bounded observations and gaps."""
import argparse, copy, hashlib, json, pathlib, struct, sys
R=pathlib.Path('E:/OpenLeague'); S=pathlib.Path('E:/mapslol3v3')
def load(p): return json.loads(pathlib.Path(p).read_bytes())
def pin(p):
 p=pathlib.Path(p);b=p.read_bytes();return {'path':str(p),'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest()}
def need(ok,why):
 if not ok:raise ValueError(why)
def audit(evidence_root,inputs_override=None,offline_override=None,sco_override=None):
 v=pathlib.Path(evidence_root).resolve(strict=True);need(v.is_relative_to(S.resolve()),'Evidence outside workspace')
 inputs=load(v/'format-link-inputs.json') if inputs_override is None else inputs_override
 need(inputs['schema']=='openleague_format_link_inputs/v1','Wrong input schema')
 need(all(inputs[k] is False for k in ['all_future_format_tasks_qualified','historical_native_loader_version_acceptance_qualified','current_Rust_gameplay_or_GPU_executed']) and inputs['human_acceptance']=='not_given','Unqualified acceptance claim')
 identities={};tools={}
 def keep(x,tool=False):
  p=pathlib.Path(x['path']).resolve(strict=True)
  need(tool or any(p.is_relative_to(a.resolve()) for a in [R,S,pathlib.Path('D:/LeagueOfLegendsV2/4.20')]),'Source outside explicit roots')
  observed=pin(p);need(all(observed[k]==x[k] for k in ['bytes','sha256']),'Changed source identity')
  (tools if tool else identities)[str(p).casefold()]=x;return p
 for k in ['producer','reference','prior_delivery','offline_probe','sco_probe']:keep(inputs[k])
 for x in inputs['current_data']:keep(x)
 previous=load(inputs['prior_delivery']['path']);need(previous['delivery_audit']['passed'] and not previous['delivery_audit_pending'] and not previous['integration_pending'],'Prior delivery not qualified')
 reference=load(inputs['reference']['path']);need(reference['client']['version']=='4.20.0.315' and reference['reference']['region']=='EUW' and reference['reference']['locale']=='en_GB','Wrong reference client')
 offline=load(inputs['offline_probe']['path']) if offline_override is None else offline_override
 sco=load(inputs['sco_probe']['path']) if sco_override is None else sco_override
 need(offline['schema']=='openleague_existing_format_consumer_probes/v1' and sco['schema']=='openleague_existing_sco_decoder_probe/v1','Wrong observation schema')
 for d in [offline,sco]:
  keep(d['producer']);need(d['historical_game_process_launched'] is False,'Historical process claim')
 need(offline['originals_unchanged'] is True and offline['outputs_installed_in_project'] is False and offline['current_Rust_gameplay_or_GPU_executed'] is False,'Offline scope changed')
 for x in offline['source_identities']:keep(x)
 for k in ['prior_binding','current_manifest','current_installed_glb','executed_binary']:keep(offline[k])
 for x in offline['executed_managed_assemblies']:keep(x)
 for k in ['dotnet','inspector']:keep(offline['runtime'][k],k=='dotnet')
 need(offline['runtime']['framework'].startswith('.NET 8.'),'Wrong managed runtime')
 need(offline['cases_count']==len(offline['cases'])==13 and offline['nominal_accepts']==3 and offline['expected_refusals']==8 and len(offline['partial_cases'])==1,'Wrong observed case scope')
 cases=offline['cases'];need(sum(c['expected']=='accept' and c['exit_code']==0 for c in cases)==3 and sum(c['expected']=='refuse' and c['exit_code']==1 for c in cases)==8,'Nominal/refusal mismatch')
 partial=[c for c in cases if c['exit_code'] is None];need(len(partial)==1 and partial[0]['observed']=='output_created_exit_not_captured' and partial==offline['partial_cases'],'Partial SCB observation promoted')
 for c in cases:
  keep(c['log'])
  for k in ['raw_stdout','raw_stderr']:
   if k in c:keep(c[k])
  casefile=pathlib.Path(c['log']['path']).with_suffix('.json');keep(pin(casefile));need(load(casefile)==c,'Case receipt altered')
  for arg in c['command']:
   p=pathlib.Path(arg)
   if p.is_file():keep(pin(p))
 diagnostic=offline['unsupported_major_diagnostic'];need(diagnostic['observed']=='accepted','Importer diagnostic falsely refused')
 before=bytes.fromhex(diagnostic['original_header']);after=bytes.fromhex(diagnostic['mutated_header'])
 need(before[:4]==after[:4]==b'\x33\x22\x11\0' and struct.unpack_from('<HH',after,4)==(65535,1),'Wrong mutated SKN version')
 diagnostic_case=next(c for c in cases if c['expected']=='observe_only');need(diagnostic_case['exit_code']==0 and diagnostic_case['observed']=='accepted','Wrong actual diagnostic outcome')
 original_mesh=pathlib.Path(offline['source_identities'][0]['path']).read_bytes();mutated_mesh=pathlib.Path(diagnostic_case['command'][2]).read_bytes()
 need(before==original_mesh[:8] and after==mutated_mesh[:8] and len(mutated_mesh)==len(original_mesh) and mutated_mesh[:4]==original_mesh[:4] and mutated_mesh[6:]==original_mesh[6:],'Wrong actual mutation payload')
 need(offline['glb_comparison']=={'positions_match_current_installed_asset':True,'vertices':2885,'joints':21,'channels':63,'native_tracks':21,'unmatched_tracks':0,'invalid_rotation_samples':0},'Changed source/current GLB comparison')
 docs=offline['pdb_sources'];need(len(docs)==6 and all(d['source_matches'] and d['current_exists'] and d['expected_hash']==d['current_hash'] for d in docs),'PDB source correspondence unproved')
 for d in docs:
  p=pathlib.Path(d['path']);need(hashlib.sha256(p.read_bytes()).hexdigest()==d['expected_hash'],'Current parser source differs from PDB');keep(pin(p))
 for x in offline['pdb_receipts']:
  p=keep(x);d=load(p);need(d['pdb_matches_assembly'] and d['pdb_guid'] in d['codeview_guids'],'PDB/CodeView mismatch');keep(pin(d['assembly']));keep(pin(d['pdb']))
 for k in ['source_module','parent_source','host','source_data','executed_binary']:keep(sco[k])
 keep(sco['compiler'],True)
 need(sco['production_module_unchanged'] and not sco['current_client_Cargo_build_or_tests_run'],'SCO production scope altered')
 for k in ['compiler_version','build','execution']:need(sco[k]['exit_code']==0,'SCO command failed');keep(sco[k]['log'])
 need(load(sco['execution']['log']['path'])==sco['observed']=={'original_module_executed':True,'nominal_successes':1,'refusals':5,'corners':132,'all_corner_words_digest':'1a1a3e139b9c5bf0','GPU_executed':False,'generic_SCO_loader_qualified':False},'SCO results or scope altered')
 need(len(inputs['anchors'])==13 and len({a['role'] for a in inputs['anchors']})==13,'Ambiguous/missing source anchors')
 roles={a['role']:a for a in inputs['anchors']}
 for a in inputs['anchors']:
  p=keep(a['source']);need(p==(R/a['path']).resolve(),'Anchor outside current project');lines=p.read_text(encoding='utf-8').splitlines()
  need(a['needle'] in lines[a['line']-1] and lines[a['line']-1]==a['excerpt'],'Changed actual consumer anchor')
  if a['role']=='format_current_world_animation_catalogue':need('world_animation_manifest.json' in lines[a['line']],'Wrong catalogue include')
 need([x['task_id'] for x in inputs['links']]==[f'SYS-02.2-{i:02}' for i in range(1,6)],'Wrong target requirements')
 need([x['task_id'] for x in inputs['links'] if x['resolve_generic_anchor_question']]==['SYS-02.2-02','SYS-02.2-03','SYS-02.2-05'],'Wrong generic question resolution scope')
 for link in inputs['links']:
  need(link['native_samples'] and link['scope'] and link['anchor_roles'] and all(k in roles for k in link['anchor_roles']),'Incomplete precise task link')
  for x in link['native_samples']:keep(x)
 membership_path=v/'format-native-membership.json';keep(pin(membership_path));membership=load(membership_path)
 need(membership['schema']=='openleague_format_native_membership/v1' and membership['input']==pin(v/'format-link-inputs.json') and not membership['effective_runtime_precedence_qualified'] and not membership['native_process_launched'],'Wrong manifest scope')
 for k in ['producer','verifier','native_solution','native_configuration','catalogue']:keep(membership[k])
 for x in membership['manifests']:keep(x['identity'])
 for x in membership['provenance']:keep(x)
 sys.path.insert(0,str(R/'tools/project-plan'))
 from rads_reference_membership import RadsReferenceMembership
 verifier=RadsReferenceMembership(R)
 samples={str(pathlib.Path(x['path']).resolve()).casefold():x for link in inputs['links'] for x in link['native_samples']}
 observed=[verifier.inspect(pathlib.Path(x['path']).relative_to(verifier.deploy).as_posix(),x['path'],x) for x in samples.values()]
 need(observed==membership['rows'] and len(observed)==9 and all(r['status']=='matches_selected_project_manifest' for r in observed),'Wrong exact native manifest membership')
 need(inputs['library_snapshot']['upstream_blob_identity_assumed'] is False,'Upstream identity invented')
 return {'schema':'openleague_format_link_audit/v1','verified':True,'counts':{'format_requirements_linked':5,'current_source_anchors':13,'exact_manifest_native_samples':9,'offline_nominal_successes':3,'pure_SCO_nominal_successes':1,'input_refusals':13,'partial_SCB_observations':1,'unsupported_version_acceptances':1,'PDB_source_documents_matching':6,'generic_anchor_questions_resolved':3,'generic_anchor_questions_refined_open':2,'future_format_tasks_accepted':0},
  'source_identities':list(identities.values()),'tool_identities':list(tools.values()),'current_consumer_evidence':inputs['anchors'],'links':inputs['links'],
  'observations':{'current_importer_major65535_minor1':diagnostic,'SCO':sco['observed'],'GLB':offline['glb_comparison'],'SCB':partial[0]},
  'declared_boundaries':['Exact native sample/actual offline importer/installed GLB/current Rust consumer links; future SYS02.2 tasks remain unchanged and unaccepted.','The importer accepts mutated SKN major65535/minor1. No original Riot loader version acceptance is inferred.','SCB output exists but exit observation was lost; the completed command was not replayed and is not a strict nominal success.','SCO component executes the unchanged pure child decoder with explicit parent storage. It does not execute the full Bevy client or generic SCO parser.','PDB CodeView/document checksums establish the selected debug/source correspondence, not a reproducible binary build.','Current DDS plugin is enabled and exact data/request/validation sites are inspected. No fresh DDS GPU/client execution or full file/version validation matrix.'],
  'historical_game_process_launched':False,'current_production_Rust_or_C_changed':False,'all_Goal_requirements_completed':False,'human_acceptance':'not_given'}
def main():
 p=argparse.ArgumentParser();p.add_argument('--evidence-root',required=True);p.add_argument('--output',required=True);a=p.parse_args()
 try:d=audit(a.evidence_root)
 except (ValueError,OSError,KeyError,IndexError,StopIteration) as e:print(json.dumps({'verified':False,'error':str(e)}));return 1
 pathlib.Path(a.output).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');print(json.dumps({'verified':True,'counts':d['counts']}));return 0
if __name__=='__main__':raise SystemExit(main())
