"""Actual reference consumer for bounded BLND fixup/predicate observations."""
import argparse,collections,importlib.util,json,pathlib,sys
def load(p):return json.loads(pathlib.Path(p).read_bytes())
def audit(evidence_root,model_path):
 v=pathlib.Path(evidence_root).resolve();model_path=pathlib.Path(model_path).resolve();spec=importlib.util.spec_from_file_location('qualified_graph_model',model_path);m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
 inputs=load(v/'graph-predicate-inputs.json');native=load(v/'original-graph-predicate-all.json');execution=load(v/'original-graph-predicate-all-execution.json');prior=load(inputs['prior_audit']['path'])
 def checked(pin):
  m.require(m.pin(pin['path'])==pin,'Changed reference: '+pin['path']);return pin
 checked(inputs['model']);m.require(m.pin(model_path)==inputs['model']==native['model'],'Different model source')
 m.require(execution['exit_code']==0 and native['execution_completed'] and native['invalid_access']==[],'Native component failed')
 m.require(native['binary']['sha256']=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862','Wrong game binary')
 m.require(all(native[k] is False for k in ['historical_OS_process_launched','resource_loader_or_ANM_executed','runtime_owner_or_tree_construction_executed','animation_choice_weight_timing_blending_or_playback_qualified','compared_u32_resource_or_animation_semantics_qualified']),'Overbroad runtime claim')
 m.require({'0x894d90','0x894a90','0x5bdbf0','0x896430'}.issubset(native['original_instruction_addresses']),'Missing original component PC')
 source_files=[checked(p) for p in [inputs['prior_audit'],prior['BLND_reader'],inputs['model'],inputs['producer'],native['binary'],native['producer'],native['inputs'],native['source_contract'],execution['log']]]
 m.require(len(inputs['graphs'])==len(native['cases'])==121 and not inputs['refused_real_graphs'],'Exact121realgraphs required')
 by={str(pathlib.Path(r['source']['path']).resolve()).casefold():r for r in native['cases']};graphs=[];models={};queries=0
 for row in inputs['graphs']:
  checked(row['source']);source_files.append(row['source']);key=str(pathlib.Path(row['source']['path']).resolve()).casefold();case=by[key];m.require(case['source']==row['source'],'Divergent graph identity');g=m.PredicateGraph(pathlib.Path(row['source']['path']).read_bytes());models[key]=g
  m.require(case['summary']==json.loads(json.dumps(g.summary())),'Divergent graph summary');words=set(case['summary']['distinct_compared_u32']);actual={(q['node_key'],q['compared_u32']):q for q in case['queries']};m.require(len(actual)==len(case['queries']),'Duplicate query')
  expected_words=words|{q['compared_u32'] for q in case['queries'] if q['compared_u32'] not in words};m.require(len(expected_words-words)==1,'Exactlyone out-of-corpus comparison word required')
  m.require(len(actual)==len(g.nodes)*len(expected_words),'Incomplete node/word Cartesian coverage')
  for node in g.nodes:
   for word in expected_words:
    q=actual[(node['table_index'],word)];m.require(q['node_name']==node['name'] and q['payload_kind']==node['payload_kind'] and q['expected_AL']==q['observed_AL']==int(word in g.values(node['table_index'])),'Native recursive predicate result mismatch')
  m.require(case['original_fixup_verified'] and case['serialized_copy_canaries_unchanged'] and case['missing_node_key_returns_false'] and case['disabled_owner_returns_false'] and case['owner_tree_and_nonzero_handle_tokens_are_declared_inputs'],'Missing fixup/fixture/refusal evidence')
  queries+=len(case['queries']);graphs.append({'source':row['source'],'summary':g.summary(),'queries_verified':len(case['queries']),'nodes':[{'key':n['table_index'],'name':n['name'],'kind':n['payload_kind'],'children':n['predicate_children'],'compared_u32':n['predicate_compared_u32'],'comparison_word_offset':n['predicate_u32_serialized_offset'],'reachable_u32':sorted(g.values(n['table_index']))} for n in g.nodes]})
 rows=[]
 for old in prior['rows']:
  candidates=[]
  for candidate in old['named_graph_candidates']:
   pin=candidate['graph_source'];key=str(pathlib.Path(pin['path']).resolve()).casefold();m.require(key in models,'Graph candidate outside qualified realcorpus');g=models[key];alias=old['native_spell_sources'][0]['fields']['AnimationName']['value'];nodes=[n for n in g.nodes if n['name']==alias]
   for node in nodes:
    descendants=set()
    def walk(k):
     if k in descendants:return
     descendants.add(k)
     for child in g.nodes[k]['predicate_children']:walk(child)
    walk(node['table_index'])
    leaves=[{'node_key':k,'name':g.nodes[k]['name'],'resource_index':g.nodes[k]['resource_index_raw'],'resource_name':g.nodes[k]['resource']['name']} for k in sorted(descendants) if g.nodes[k]['payload_kind']==1]
    candidates.append({'source':pin,'alias':alias,'node_key':node['table_index'],'payload_kind':node['payload_kind'],'children':node['predicate_children'],'reachable_uninterpreted_u32':sorted(g.values(node['table_index'])),'reachable_type1_source_references':leaves,'effective_animation_selection_qualified':False})
  rows.append({'champion':old['champion'],'slot':old['slot'],'presentation_task_id':old['presentation_task_id'],'role_task_id':old['role_task_id'],'configured_alias_candidates':candidates,'no_alias_is_not_no_animation':True,'graph_choice_and_playback_qualified':False})
 unique={str(pathlib.Path(p['path']).resolve()).casefold():p for p in source_files}
 return {'schema':'openleague_native_graph_predicate_reference_audit/v1','graphs':graphs,'rows':rows,'counts':{'graphs':len(graphs),'base_slots':len(rows),'nodes':sum(g['summary']['nodes'] for g in graphs),'queries_verified':queries,'original_instructions':native['original_instructions'],'original_PCs':len(native['original_instruction_addresses']),'fresh_input_files':len(unique)},'source_identities':list(unique.values()),'native_execution':m.pin(v/'original-graph-predicate-all-execution.json'),'native_result':m.pin(v/'original-graph-predicate-all.json'),'model':m.pin(model_path),'original_game_binary':native['binary'],'declared_guest_inputs':native['declared_guest_inputs'],'resource_loader_cast_choice_pose_or_playback_qualified':False,'compared_u32_semantics_qualified':False,'all_Goal_objectives_completed':False}
def main():
 p=argparse.ArgumentParser();p.add_argument('--evidence-root',required=True);p.add_argument('--model',required=True);p.add_argument('--output',required=True);args=p.parse_args();out=pathlib.Path(args.output)
 if out.exists():raise ValueError('Preserve previous output')
 result=audit(args.evidence_root,args.model);out.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');print(json.dumps(result['counts']));return 0
if __name__=='__main__':raise SystemExit(main())
