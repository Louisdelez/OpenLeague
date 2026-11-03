"""Verify exact native graph-owner component observations and current references."""
import argparse,copy,importlib.util,json,pathlib
def load(p):return json.loads(pathlib.Path(p).read_bytes())
def audit(evidence_root,model_path):
 v=pathlib.Path(evidence_root).resolve();p=v.parent/'revision29';spec=importlib.util.spec_from_file_location('owner_model',model_path);m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
 native=load(v/'original-graph-owner-all-v2.json');execution=load(v/'original-graph-owner-all-v2-execution.json');previous=load(p/'native-graph-predicate-audit-qualified.json');previous_receipt=load('E:/OpenLeague/docs/reference_native_skin_loader_sources/native-graph-predicate-reference.json')
 def checked(pin):m.require(m.pin(pin['path'])==pin,'Changed source: '+pin['path']);return pin
 m.require(previous_receipt['audit']==m.pin(p/'native-graph-predicate-audit-qualified.json'),'Changed prior predicate reference')
 m.require(execution['exit_code']==0 and native['execution_completed'] and not native['invalid_access'],'Owner experiment incomplete or invalid')
 m.require(native['binary']['sha256']=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862','Wrong native binary')
 m.require(not native['historical_OS_process_launched'] and not native['native_heap_OS_allocator_executed'] and not native['resource_ANM_loader_or_cast_selection_playback_qualified'],'Overbroad runtime claim')
 m.require(len(native['cases'])==121,'Exact121realgraphs required')
 required={'0x896130','0x896b70','0x8961d0','0x5bd9b0','0x8962a0','0x77e5d0','0x896430','0x564c20','0x564900','0xc9cf31','0xca1ef0','0xca1d00','0xc975f5'};m.require(required.issubset(native['original_PCs']),'Missing original owner/map/string/copy/cookie component entry')
 pins=[*previous['source_identities'],native['producer'],native['owner_VM'],native['binary'],native['parent_native_probe'],native['parent_model'],native['inputs'],native['source'],execution['log'],execution['producer'],previous_receipt['audit']]
 graphs=[];lookups=queries=allocations=pair_count=0;graph_by_path={str(pathlib.Path(g['source']['path']).resolve()).casefold():g for g in previous['graphs']}
 for case in native['cases']:
  checked(case['source']);key=str(pathlib.Path(case['source']['path']).resolve()).casefold();m.require(key in graph_by_path and case['source']==graph_by_path[key]['source'],'Graph not in original corpus');g=m.PredicateGraph(pathlib.Path(case['source']['path']).read_bytes())
  m.require(case['constructor_defaults_and_empty_maps_verified'] and case['original_owner_constructor_population_lookups_and_destructor_executed'] and case['body_pointer_and_nonzero_resource_tokens_are_supplied_inputs'],'Wrong constructor/owner boundary')
  node_entries=case['native_node_map']['entries'];name_entries=case['native_name_map']['entries'];m.require(len(node_entries)==len(g.nodes),'Native node map size mismatch')
  base={e['value']-g.nodes[e['key']]['record_offset'] for e in node_entries};m.require(len(base)==1,'Divergent relocated graph base');base=next(iter(base));m.require([e['key'] for e in node_entries]==list(range(len(g.nodes))),'Native node order mismatch')
  groups={}
  for n in reversed(g.nodes):
   folded=n['name'].lower()
   if folded not in groups:groups[folded]={'stored_key':n['name'],'value':n['table_index']}
   else:groups[folded]['value']=n['table_index']
  if 'none' not in groups:groups['none']={'stored_key':'none','value':0xfffffffe}
  else:groups['none']['value']=0xfffffffe
  m.require({e['key']:e['value'] for e in name_entries}=={p['stored_key']:p['value'] for p in groups.values()},'Native case-equivalent name binding mismatch')
  m.require(case['native_comparator_case_equivalence_and_order_verified'],'Native comparator control missing')
  m.require(len(case['lookups'])==len(g.nodes),'Missing lookup observations')
  for n,lookup in zip(g.nodes,case['lookups'],strict=True):
   m.require(lookup['name']==n['name'] and lookup['key']==n['table_index'] and lookup['expected_pointer_offset']==lookup['observed_pointer_offset']==n['record_offset'],'Original integer lookup mismatch')
   m.require(lookup['expected_name_value']==lookup['observed_name_value']==groups[n['name'].lower()]['value'],'Original string lookup mismatch')
  m.require(case['missing_integer_key_null'] and case['missing_name_refused'] and case['builtin_none_value']==0xfffffffe,'Lookup refusal/default observations missing')
  count=g.graph.u32(12+0x10);table=g.relative(12+0x30);m.require(len(case['pair_records'])==count and case['dense_pair_index_verified'],'Original pair table control missing')
  for i,pair in enumerate(case['pair_records']):
   at=table+i*16;m.require(pair=={'from_raw':g.graph.u32(at),'to_raw':g.graph.u32(at+4),'table_index':i+1,'source_offset':at},'Pair record source mismatch')
  observed={(q['node_key'],q['compared_u32']):q for q in case['queries']};words={n['predicate_compared_u32'] for n in g.nodes if n['predicate_compared_u32'] is not None};miss={q['compared_u32'] for q in case['queries']}-words;m.require(len(miss)==1,'Exactlyone absent comparison word required');allwords=words|miss
  m.require(len(observed)==len(case['queries'])==len(g.nodes)*len(allwords),'Predicate coverage incomplete')
  for n in g.nodes:
   for word in allwords:
    q=observed[(n['table_index'],word)];m.require(q['expected_AL']==q['observed_AL']==int(word in g.values(n['table_index'])),'Predicate mismatch on original maps')
  live={};ever={}
  for event in case['heap_events']:
   at=int(event['address'],16)
   if event['leaf']=='bounded_guest_allocation':
    m.require(at not in live and at not in ever and 0<event['bytes']<=0x100000 and event['entry'] in ['0x9933e0','0xc9f39b'],'Guest allocation event invalid');live[at]=event['bytes'];ever[at]=event['bytes']
   else:
    m.require(event['leaf']=='bounded_guest_free' and (at==0 or at in live),'Guest free ownership invalid')
    if at:live.pop(at)
  m.require(not live and case['live_allocations_after_destructor']==0 and case['canaries_unchanged'],'Destructor or output guard failed')
  for tree,minimum in [(case['native_node_map'],24),(case['native_name_map'],44)]:
   m.require(int(tree['sentinel'],16) in ever and tree['black_height']>=2,'Native sentinel provenance invalid')
   m.require(all(ever.get(int(e['node'],16),0)>=minimum for e in tree['entries']),'Tree entries not native-allocated in this guest profile')
  lookups+=len(case['lookups']);queries+=len(observed);allocations+=len(ever);pair_count+=count
  graphs.append({'source':case['source'],'nodes':len(g.nodes),'native_name_entries':len(name_entries),'lookup_pairs':len(case['lookups']),'predicate_queries':len(observed),'pair_records':count,'native_constructor_population_destructor_verified':True,'live_guest_allocations_final':0,'native_heap_allocator_equivalence_claimed':False})
 rows=copy.deepcopy(previous['rows']);by_graph={str(pathlib.Path(g['source']['path']).resolve()).casefold():i for i,g in enumerate(graphs)}
 for row in rows:
  row['original_owner_component_references']=[{'graph_index':by_graph[str(pathlib.Path(c['source']['path']).resolve()).casefold()],'source':c['source'],'alias':c['alias'],'node_key':c['node_key'],'constructor_population_lookup_destructor_verified':True,'historical_caller_resource_loading_cast_selection_playback_qualified':False} for c in row['configured_alias_candidates']]
 unique={str(pathlib.Path(p['path']).resolve()).casefold():p for p in pins};identities=[checked(p) for p in unique.values()]
 return {'schema':'openleague_original_graph_owner_reference_audit/v1','counts':{'graphs':len(graphs),'base_slots':len(rows),'nodes':lookups,'node_name_lookup_pairs':lookups,'predicate_queries':queries,'pair_records':pair_count,'guest_allocations_released':allocations,'original_PCs':len(native['original_PCs']),'original_instructions':native['original_instructions'],'fresh_source_files':len(identities)},'graphs':graphs,'rows':rows,'source_identities':identities,'native_result':m.pin(v/'original-graph-owner-all-v2.json'),'native_execution':m.pin(v/'original-graph-owner-all-v2-execution.json'),'model':m.pin(model_path),'original_game_binary':native['binary'],'declared_boundaries':native['declared_boundaries'],'original_constructor_population_lookup_destructor_components_qualified':True,'historical_owner_caller_ANM_resource_loading_cast_choice_pose_playback_qualified':False,'all_Goal_objectives_completed':False}
def main():
 p=argparse.ArgumentParser();p.add_argument('--evidence-root',required=True);p.add_argument('--model',required=True);p.add_argument('--output',required=True);args=p.parse_args();out=pathlib.Path(args.output)
 if out.exists():raise ValueError('Preserve previous result')
 result=audit(args.evidence_root,args.model);out.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');print(json.dumps(result['counts']));return 0
if __name__=='__main__':raise SystemExit(main())
