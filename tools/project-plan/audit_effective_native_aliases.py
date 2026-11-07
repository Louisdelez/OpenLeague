"""Reference consumer for effective native fields queried against original tables."""
import argparse,collections,importlib.util,json,pathlib
def load(p):return json.loads(pathlib.Path(p).read_bytes())
def audit(evidence_root,model_path):
 v=pathlib.Path(evidence_root).resolve();spec=importlib.util.spec_from_file_location('alias_model',model_path);m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
 inputs=load(v/'effective-native-alias-inputs-v2.json');native=load(v/'original-effective-alias-queries.json');execution=load(v/'original-effective-alias-queries-execution.json');config=load(v/'renekton-original-Animations-getters.json');config_execution=load(v/'renekton-original-Animations-getters-execution.json');research=load(v/'renekton-graph-binding-research.json')
 def checked(pin):m.require(m.pin(pin['path'])==pin,'Changed reference: '+pin['path']);return pin
 m.require(inputs['schema']=='openleague_effective_native_alias_inputs/v2','Wrong input schema');m.require(execution['exit_code']==config_execution['exit_code']==0 and native['execution_completed'] and config['execution_completed'],'Native experiment incomplete');m.require(native['invalid_access']==config['invalid_access']==[],'Native unmapped memory access')
 m.require(native['binary']==config['binary'] and native['binary']['sha256']=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862','Wrong original game binary')
 m.require(not native['historical_OS_process_launched'] and not native['resource_ANM_loader_cast_graph_priority_clip_selection_pose_playback_qualified'],'Overbroad native alias claim')
 m.require(not config['historical_OS_process_launched'] and not config['full_skin_priority_or_scale_name_resolution_qualified'],'Overbroad config claim')
 m.require(len(inputs['rows'])==len(native['cases'])==488 and len(native['graphs'])==122,'Full122champions/488slots required')
 pins=[*inputs['input_sources'].values(),inputs['producer'],inputs['prior_preparation'],inputs['renekton_research'],native['inputs'],native['producer'],native['binary'],native['owner_VM'],native['base_VM'],native['model'],native['fixup_VM'],execution['log'],execution['producer'],config['producer'],config['research'],config_execution['log'],research['producer'],research['reference_client'],research['skin_registry'],research['resolver'],research['membership_consumer']]
 r=pathlib.Path('E:/OpenLeague/tools/project-plan')
 for name in ['original_config_cache_reference.py','original_config_reader_reference.py','original_directory_reference.py','original_skin_provider_reference.py','native_skin_loader_reference.py']:pins.append(m.pin(r/name))
 m.require(m.pin(model_path)==native['model'],'Different graph model')
 source_slots=load(inputs['input_sources']['native_field_inputs']['path']);field_outputs=load(inputs['input_sources']['native_fields']['path']);old_rows=load(inputs['input_sources']['slot_audit']['path'])['rows']
 field_inputs={(x['champion'],x['slot']):x for x in source_slots['rows']};fields={(x['champion'],x['slot']):x for x in field_outputs['cases']};old_by={(x['champion'],x['slot']):x for x in old_rows};cases={(x['champion'],x['slot']):x for x in native['cases']};m.require(len(cases)==488,'Duplicate alias slot');models={};graph_results={str(pathlib.Path(x['source']['path']).resolve()).casefold():x for x in native['graphs']};m.require(len(graph_results)==122,'Duplicate graph observation')
 for key,case in graph_results.items():
  checked(case['source']);pins.append(case['source']);models[key]=m.PredicateGraph(pathlib.Path(case['source']['path']).read_bytes());m.require(case['node_count']==len(models[key].nodes) and case['original_constructor_population_destructor_executed'] and case['live_allocations_after_destructor']==0 and case['canaries_unchanged'],'Owner lifecycle guard failed')
  live={}
  for e in case['guest_heap_events']:
   if e['leaf']=='bounded_guest_allocation':m.require(e['address'] not in live and 0<e['bytes']<=0x100000,'Invalid allocation event');live[e['address']]=e['bytes']
   else:
    m.require(e['leaf']=='bounded_guest_free' and (e['address']=='0x0' or e['address'] in live),'Unowned free event')
    if e['address']!='0x0':live.pop(e['address'])
  m.require(not live,'Guest-owned allocations remain')
 rows=[]
 for index,row in enumerate(inputs['rows']):
  key=(row['champion'],row['slot']);m.require(type(row['slot']) is int and row['slot'] in range(1,5),'Invalid base slot');case=cases[key];fi=field_inputs[key];f=fields[key];old=old_by[key];alias=row['native_effective_wrapper_AnimationName'];m.require(isinstance(alias,str) and alias.isascii() and '\0' not in alias and len(alias)<4096,'Unqualified alias input')
  m.require(row['presentation_task_id']==case['presentation_task_id']==old['presentation_task_id'] and row['role_task_id']==case['role_task_id']==old['role_task_id'] and row['spell_name']==case['spell_name']==fi['spell_name'],'Stable requirement/spell binding mismatch');m.require(type(row['native_field_present']) is bool and type(case['native_field_present']) is bool,'Nonboolean native field presence')
  expected=fi['native_AnimationName']['value'] if fi['native_AnimationName']['present'] else 'Attack1';m.require(alias==expected==f['observed']==case['native_effective_wrapper_AnimationName'],'Effective field value mismatch')
  m.require(row['native_field_source']==f['source']==case['native_field_source'] and row['native_field_present']==fi['native_AnimationName']['present']==case['native_field_present'] and row['native_raw_AnimationName']==fi['native_AnimationName']['value']==case['native_raw_AnimationName'],'Native raw field identity mismatch');pins.append(row['native_field_source']);m.require(len(row['graph_candidates'])==1,'Unresolved graph candidate set')
  candidate=row['graph_candidates'][0];m.require(candidate['graph_source']==case['graph_source'] and candidate['configuration_sources']==case['configuration_sources'],'Graph/config source binding mismatch');pins.extend(candidate['configuration_sources']);gkey=str(pathlib.Path(candidate['graph_source']['path']).resolve()).casefold();g=models[gkey];groups={}
  for n in reversed(g.nodes):
   folded=n['name'].lower()
   if folded not in groups:groups[folded]={'key':n['name'],'value':n['table_index']}
   else:groups[folded]['value']=n['table_index']
  if 'none' not in groups:groups['none']={'key':'none','value':0xfffffffe}
  else:groups['none']['value']=0xfffffffe
  matching=groups.get(alias.lower());expected_value=matching['value'] if matching else None;kind='missing_alias' if expected_value is None else 'builtin_none' if expected_value==0xfffffffe else 'node_key'
  m.require(all(value is None or type(value) is int and 0<=value<=0xffffffff for value in [case['original_name_lookup_value'],case['case_variant_lookup_value']]),'Non-u32 native lookup result');m.require(case['original_name_lookup_value']==case['case_variant_lookup_value']==expected_value and case['classification']==kind,'Original alias lookup result mismatch');m.require(case['original_table_stored_key']==(matching['key'] if matching else None),'Stored key mismatch')
  recovered=bool(matching) and matching['key']!=alias;m.require(case['lookup_recovered_by_case_equivalence']==recovered,'Case-equivalence observation mismatch')
  exact_nodes=[n for n in g.nodes if n['name']==alias];node=g.nodes[expected_value] if kind=='node_key' else None;leaves=[]
  if node is not None:
   m.require(0<=expected_value<len(g.nodes),'Native node key out of range');m.require(case['resolved_node_key']==node['table_index'] and case['resolved_node_name']==node['name'] and case['resolved_node_payload_kind']==node['payload_kind'] and case['resolved_node_record_offset']==node['record_offset'],'Native get-by-index result mismatch')
   visited=set()
   def walk(k):
    if k in visited:return
    visited.add(k)
    for child in g.nodes[k]['predicate_children']:walk(child)
   walk(expected_value);leaves=[{'node_key':k,'node_name':g.nodes[k]['name'],'resource_name':g.nodes[k]['resource']['name']} for k in sorted(visited) if g.nodes[k]['payload_kind']==1]
  else:m.require(all(case[k] is None for k in ['resolved_node_key','resolved_node_name','resolved_node_payload_kind','resolved_node_record_offset']),'Missing/builtin alias falsely indexed into graph')
  m.require(case['original_name_and_index_lookup_executed'] is True and case['effective_cast_or_clip_selection_qualified'] is False,'Wrong query qualification scope')
  rows.append({**case,'exact_serialized_alias_node_count':len(exact_nodes),'reachable_type1_source_references':leaves,'input_field_value_is_from_prior_original_wrapper_profile':True,'actual_game_cast_caller_or_pipeline_composition_qualified':False})
 b=research['binding'];cs=[c for c in b['candidates'] if c['status']=='matches_explicit_skin_id'];m.require(b['status']=='ambiguous_native_skin_bindings' and len(cs)==2 and {c['fields']['Animations'] for c in cs}=={'RenektonBase.blnd'},'Renekton field consensus not established')
 differing=[k for k in cs[0]['fields'] if cs[0]['fields'][k]!=cs[1]['fields'][k]];m.require(differing==['ChampionSkinName','SkinScale'],'Different unresolved Renekton fields');m.require(len(config['cases'])==2 and all(c['source'] in [x['source'] for x in cs] and c['expected']==c['observed']=='RenektonBase.blnd' and c['canary_unchanged'] and c['native_wrapper_executed'] for c in config['cases']),'Renekton original config getters not verified')
 counts={'base_champions':len({r['champion'] for r in rows}),'base_slots':len(rows),'graph_candidates_executed':len(graph_results),'node_key_hits':sum(r['classification']=='node_key' for r in rows),'missing_aliases':sum(r['classification']=='missing_alias' for r in rows),'builtin_none_hits':sum(r['classification']=='builtin_none' for r in rows),'case_equivalence_recoveries':sum(r['lookup_recovered_by_case_equivalence'] for r in rows),'absent_fields_defaulted_to_Attack1':sum(not r['native_field_present'] for r in rows),'explicit_empty_fields':sum(r['native_field_present'] and r['native_raw_AnimationName']=='' for r in rows),'original_PCs':len(native['original_PCs']),'original_instructions':native['original_instructions']}
 unique={str(pathlib.Path(p['path']).resolve()).casefold():p for p in pins};identities=[checked(p) for p in unique.values()];counts['fresh_source_files']=len(identities)
 return {'schema':'openleague_effective_native_alias_reference_audit/v1','counts':counts,'rows':rows,'source_identities':identities,'native_alias_execution':m.pin(v/'original-effective-alias-queries-execution.json'),'native_alias_result':m.pin(v/'original-effective-alias-queries.json'),'Renekton_config_execution':m.pin(v/'renekton-original-Animations-getters-execution.json'),'Renekton_config_result':m.pin(v/'renekton-original-Animations-getters.json'),'model':m.pin(model_path),'original_game_binary':native['binary'],'Renekton_field_consensus':inputs['renekton_Animations_field_consensus'],'Renekton_full_skin_binding_priority_resolved':False,'declared_boundaries':native['declared_boundaries'],'lookup_composition_is_declared_reference_probe_not_observed_cast_pipeline':True,'cast_selection_pose_or_playback_qualified':False,'all_Goal_objectives_completed':False}
def main():
 p=argparse.ArgumentParser();p.add_argument('--evidence-root',required=True);p.add_argument('--model',required=True);p.add_argument('--output',required=True);args=p.parse_args();out=pathlib.Path(args.output)
 if out.exists():raise ValueError('Preserve previous output')
 result=audit(args.evidence_root,args.model);out.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');print(json.dumps(result['counts']));return 0
if __name__=='__main__':raise SystemExit(main())
