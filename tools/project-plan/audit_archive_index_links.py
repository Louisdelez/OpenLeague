"""Qualify exact source/current-index associations, never a complete RADS inventory."""
import argparse, collections, hashlib, json, pathlib, sys, zipfile
R=pathlib.Path('E:/OpenLeague');sys.path.insert(0,str(R/'tools/project-plan'))
def load(p):return json.loads(pathlib.Path(p).read_bytes())
def pin(p):
 p=pathlib.Path(p);b=p.read_bytes();return {'path':str(p),'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest()}
def need(value,message):
 if not value:raise ValueError(message)

def audit(evidence_root,inputs_override=None,probe_override=None,projection_override=None):
 v=pathlib.Path(evidence_root);inputs=load(v/'archive-index-link-inputs.json') if inputs_override is None else inputs_override
 probe=load(v/'archive-index-component-probe.json') if probe_override is None else probe_override
 projection=load(v/'archive-index-source-projection.json') if projection_override is None else projection_override
 sources={};tools={}
 def keep(row,tool=False):
  p=pathlib.Path(row['path']).resolve();need(p.is_file(),'Missing evidence: '+str(p));need(pin(p)=={k:row[k] for k in ['path','bytes','sha256']},'Changed evidence: '+str(p))
  if tool:tools[str(p)]=pin(p)
  else:
   need(any(p.is_relative_to(a.resolve()) for a in [R,pathlib.Path('E:/mapslol3v3'),pathlib.Path('D:/LeagueOfLegendsV2/4.20')]),'Unqualified source root');sources[str(p)]=pin(p)
 need(inputs['schema']=='openleague_archive_index_link_inputs/v1','Wrong input schema')
 for k in ['all_future_inventory_tasks_qualified','historical_mount_order_qualified','arbitrary_nested_archive_inventory_qualified']:need(inputs[k] is False,'Unsupported inventory claim: '+k)
 need(inputs['human_acceptance']=='not_given','Human acceptance invented')
 for k in ['producer','reference','prior_delivery','catalogue','component_probe','source_projection','RADS_factory_reference','RADS_factory_inputs','RADS_factory_input_contract']:keep(inputs[k])
 for row in inputs['oracle_contracts']:keep(row)
 for k in ['original_oracles_reexecuted','historical_game_process_launched','current_Bevy_provider_executed','current_ZIP_decoder_executed','outputs_installed_in_project']:need(probe[k] is False,'Unsupported component claim: '+k)
 need(probe['schema']=='openleague_archive_index_component_probe/v1','Wrong probe schema')
 for k in ['producer','host_source','host_binary','source_projection']:keep(probe[k])
 keep(probe['compiler'],True)
 for k in ['build','execution','compiler_version']:
  need(probe[k]['exit_code']==0,'Component command failed: '+k);keep(probe[k]['log'])
  record_name={'compiler_version':'archive-index-rustc-version.json','build':'archive-index-build-final.json','execution':'archive-index-execution.json'}[k]
  keep(pin(v/record_name));need(load(v/record_name)==probe[k],'Command record changed: '+k)
 recovery=probe['collection_recovery'];need(recovery==inputs['collection_recovery'] and recovery['initial_build_exit_code']==1 and recovery['completed_commands_replayed'] is False and recovery['failed_compile_retried'] is True,'Compilation failure/recovery hidden')
 for k in ['original_collector','recovery_producer','failed_build_record','failed_build_log','failed_generated_source']:keep(recovery[k])
 need(load(recovery['failed_build_record']['path'])['exit_code']==1,'Initial compile failure promoted')
 need(len(recovery['failed_compilation_records'])==3,'Compilation history incomplete')
 for row in recovery['failed_compilation_records']:
  keep(row);failed=load(row['path']);need(failed['exit_code']==1,'Failed compilation promoted');keep(failed['log'])
 for k in ['second_failed_source','third_failed_source','first_repair_producer','second_repair_producer']:keep(recovery[k])
 expected={'lookup_oracle_profiles':720,'normalization_output_profiles':188,'duplicate_boundary_profiles':72,'archive_entries':1066,'unique_names':1065,'original_and_uppercase_archive_lookups':2132,'current_guard_refusals':7}
 need(probe['observed']==expected==json.loads(pathlib.Path(probe['execution']['log']['path']).read_bytes()),'Component counts/raw observation changed')
 keep(projection['source']);text=pathlib.Path(projection['source']['path']).read_text(encoding='utf-8');a,b=projection['normalised_character_span']
 need(text[a:b]==projection['snippet'] and hashlib.sha256(projection['snippet'].encode()).hexdigest()==projection['snippet_sha256'] and projection['snippet'].startswith('fn merged_rows('),'Projection span/body changed')
 need(projection['snippet'] in pathlib.Path(probe['host_source']['path']).read_text(encoding='utf-8'),'Compiled helper source mismatch')
 need(probe['source_projection']==inputs['source_projection'],'Projection binding changed')
 catalogue=load(inputs['catalogue']['path']);need(catalogue['complete'] is False and len(catalogue['archives'])==5,'Catalogue promoted beyond five archives')
 originals=load(inputs['oracle_contracts'][0]['path']);need(originals['native_sha256']=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862','Wrong native oracle')
 rows=[]
 for ordinal,archive in enumerate(inputs['archives']):
  keep(archive['native']);keep(archive['current']);need(archive['ordinal']==ordinal and pin(archive['native']['path'])['sha256']==catalogue['archives'][ordinal]['sha256']==archive['current']['sha256'],'Wrong native/current archive association')
  original=originals['original_archives'][ordinal];need(archive['native']=={k:original[k] for k in ['path','bytes','sha256']},'Wrong archive oracle source')
  with zipfile.ZipFile(archive['native']['path']) as z:
   current=[]
   for i,e in enumerate(z.infolist()):current.append({'archive':ordinal,'entry':i,'name':e.filename,'packed_id':ordinal<<16|i,'compressed_bytes':e.compress_size,'bytes':e.file_size,'crc32':e.CRC,'local_offset':e.header_offset})
  need(current==archive['entries'],'ZIP names/metadata changed');rows+=current
  need(archive['nested_archive_names']==[x['name'] for x in current if x['name'].lower().endswith(('.zip','.raf','.raf.dat','.wad'))],'Nested-name observation changed')
 need(len(inputs['archives'])==5 and len(rows)==1066,'Wrong bounded archive population')
 groups=collections.defaultdict(list)
 for row in rows:groups[row['name'].split('\0',1)[0].lower()].append(row)
 collisions=[{'folded_key':k,'entries':g,'different_spelling':len({x['name'] for x in g})>1,'selected_explicit_catalogue_entry':g[-1]} for k,g in groups.items() if len(g)>1]
 need(len(groups)==1065 and len(collisions)==1 and inputs['collisions']==collisions,'Collision origin/priority changed')
 need(inputs['native_normalization_underwrite_profiles']==4,'Original normalization defect omitted')
 from rads_reference_membership import RadsReferenceMembership
 verifier=RadsReferenceMembership(R);member=inputs['manifest_membership']
 for k in ['solution','configuration','catalogue']:keep(member[k])
 for row in member['manifests']:keep(row['identity'])
 for row in member['provenance']:keep(row)
 actual=[verifier.inspect(pathlib.Path(x['native']['path']).relative_to(verifier.deploy).as_posix(),x['native']['path'],x['native']) for x in inputs['archives']]
 need(actual==member['rows'] and all(x['status']=='not_listed_in_two_selected_projects' and not x['candidates'] for x in actual),'Selected project membership changed')
 need(inputs['manifest_scope']['archives_in_reference_copy']==5 and inputs['manifest_scope']['matches_selected_project_manifest']==0 and inputs['manifest_scope']['not_listed_in_two_selected_projects']==5 and inputs['manifest_scope']['released_in_selected_4_20_projects'] is False,'Unlisted reference-copy archives falsely promoted')
 correction=inputs['manifest_scope_correction'];need(correction['completed_component_or_native_commands_replayed'] is False and correction['original_files_changed'] is False,'Manifest scope correction replay or mutation hidden')
 for k in ['producer','previous_unqualified_input','initial_audit_failure']:keep(correction[k])
 need(member['manifests']==verifier.manifests and member['provenance']==verifier.provenance,'Manifest/version provenance changed')
 raf=load(inputs['RADS_factory_input_contract']['path']);need(inputs['missing_original_RAF_directory']==raf['original_missing_directory'] and not pathlib.Path(inputs['missing_original_RAF_directory']).exists() and raf['container_is_reconstructed'] is True,'Missing original RAF falsely resolved')
 need(inputs['reconstructed_RAF']==[raf['index'],raf['data']],'Reconstructed RAF identity/source role changed')
 for row in inputs['reconstructed_RAF']:keep(row)
 roles=set()
 for anchor in inputs['anchors']:
  keep(anchor['identity']);p=R/anchor['path'];lines=p.read_text(encoding='utf-8').splitlines()
  need(str(p)==anchor['identity']['path'] and 0<anchor['line']<=len(lines) and lines[anchor['line']-1]==anchor['excerpt'] and anchor['needle'] in anchor['excerpt'],'Current anchor changed')
  need(anchor['role'] not in roles and anchor['scope'],'Incomplete or duplicate consumer role');roles.add(anchor['role'])
 need(len(roles)==9,'Wrong consumer population')
 need([x['task_id'] for x in inputs['links']]==['SYS-02.1-01','SYS-02.1-02','SYS-02.1-06'] and [x['resolve_generic_anchor_question'] for x in inputs['links']]==[False,False,True],'Wrong task/association resolution scope')
 for link in inputs['links']:
  need(link['scope'] and link['native_samples'] and link['anchor_roles'] and all(x in roles for x in link['anchor_roles']),'Missing exact source/consumer association')
  for row in link['native_samples']:keep(row)
  if not link['resolve_generic_anchor_question']:need(bool(link['remaining_question']),'Open inventory question omitted')
 boundaries=['Five reference-copy ZIPs/1066children and selected project manifests are identified. All five ZIP containers are unlisted in both selected projects; supplied-copy presence is not selected-release delivery provenance. Not a complete original RADS archive/version inventory.',
  'Original RAF67 directory is absent. Reconstructed RAF/index bytes are labelled and never promoted to original archive bytes.',
  '720lookup and188normalization output oracles and72duplicate-boundary oracles are inherited; no original code experiment is rerun. Four native underwrite profiles match output bytes only, not safe memory writes.',
  'Actual index module and exact merged_rows projection execute; ZIP decoder, Bevy provider, arbitrary recursive containers and full insertion/rehash/aliases are not executed.',
  'One duplicate primary key uses explicit catalogue order. Historical process mount order and global case/collision inventory remain open.',
  'No future inventory task is accepted, no user checkbox changed, no complete game or delivery acceptance.']
 return {'schema':'openleague_archive_index_link_audit/v1','verified':True,'counts':{'archive_index_requirements_linked':3,'current_source_anchors':9,'reference_copy_archives':5,'selected_manifest_listed_archives':0,'selected_manifest_unlisted_archives':5,'archive_entries':1066,'unique_primary_names':1065,'collision_groups':1,**expected,'generic_anchor_questions_resolved':1,'generic_anchor_questions_refined_open':2,'future_inventory_tasks_accepted':0},'source_identities':list(sources.values()),'tool_identities':list(tools.values()),'current_consumer_evidence':inputs['anchors'],'links':inputs['links'],'observations':{'component':probe,'collisions':collisions,'selected_manifest_membership':actual,'manifest_scope':inputs['manifest_scope'],'missing_original_RAF_directory':inputs['missing_original_RAF_directory'],'reconstructed_RAF':inputs['reconstructed_RAF'],'native_normalization_underwrite_profiles':4},'declared_boundaries':boundaries,'historical_mount_order_qualified':False,'historical_game_process_launched':False,'current_production_Rust_or_C_changed':False,'all_Goal_requirements_completed':False,'human_acceptance':'not_given'}

def main():
 p=argparse.ArgumentParser();p.add_argument('--evidence-root',required=True);p.add_argument('--output',required=True);args=p.parse_args()
 try:result=audit(args.evidence_root)
 except (ValueError,OSError,KeyError,IndexError) as e:print(json.dumps({'verified':False,'error':str(e)}));return 1
 pathlib.Path(args.output).write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');print(json.dumps({'verified':True,'counts':result['counts']}));return 0
if __name__=='__main__':raise SystemExit(main())
