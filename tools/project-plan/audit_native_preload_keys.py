"""Current read-only consumer of bounded original resource-key observations."""
import argparse, collections, json, pathlib, hashlib

def load(p):return json.loads(pathlib.Path(p).read_bytes())
def pin(p):
    p=pathlib.Path(p);b=p.read_bytes();return {'path':str(p),'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest()}
def require(ok,why):
    if not ok:raise ValueError(why)
def alias_entries(members):
    result={}
    for member in members:
        physical=member['member_path'];name=pathlib.PurePosixPath(physical).name
        require(name.lower().endswith('.troybin'),'Unexpected alias-registration resource type')
        for key,value in [(name,physical),(name[:-3],physical[:-3])]:
            folded=key.lower();require(folded not in result or result[folded]['value']==value,'Ambiguous declared reference aliases')
            result[folded]={'key':key,'value':value}
    return {v['key']:v['value'] for v in result.values()}

def audit(evidence_root,native_override=None,execution_override=None):
    v=pathlib.Path(evidence_root).resolve();inputs=load(v/'local-preload-resource-inputs.json')
    native=load(v/'original-preload-keys.json') if native_override is None else native_override
    execution=load(v/'original-preload-keys-execution.json') if execution_override is None else execution_override
    research=load(v/'unresolved-preload-name-research.json');static=load(v/'manager-source-qualification.json')
    require(native['schema']=='openleague_original_preload_key_execution/v1' and native['execution_completed'] is True and type(execution['exit_code']) is int and execution['exit_code']==0,'Native execution incomplete')
    require(native['invalid_access']==[] and native['guest_live_allocations']=={},'Native memory fault or unreleased guest allocation')
    require(native['binary']['sha256']=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862' and native['binary']==static['binary'],'Wrong reference binary')
    for k in ['historical_OS_process_launched','full_provider_bootstrap_or_actual_namespace_priority_qualified','real_manager_cache_template_loading_or_event_firing_qualified']:
        require(native[k] is False,'Overbroad runtime claim: '+k)
    require(len(native['boundaries'])==6,'Missing declared component boundaries')
    pcs={int(p,16) for p in native['original_PCs']};required={0x92bfe0,0x92bb60,0x92bbf1,0x92bbf9,0x903ee0,0x905090,0x8b5da0,0x5fa650,0xc98719,0x8b5d50}
    require(len(pcs)==len(native['original_PCs']) and required<=pcs and not ({0x918b30,0x918490,0x92bc0c}&pcs),'Incorrect original prefix/loader scope')
    require(static['passed'] is True and static['checks_count']==13 and all(static['checks'].values()) and static['runtime_executed'] is False,'Static method/vtable qualification missing')
    old=load(v/'preload-resource-inputs.json');old_names={r['name']:r for r in old['rows']}
    source_native=load(v.parent/'revision32/native-preload-dispatch-audit-qualified.json')
    source_graphs={r['champion']:r for r in source_native['rows']}
    coverage=load(v.parent/'revision25/complete-core-reference-coverage.json');members={r['member_path'].lower():r for r in coverage['selected_sources']}
    require(inputs['schema']=='openleague_local_preload_reference_inputs/v1' and inputs['counts']['graphs']==122 and len(inputs['graphs'])==122,'Wrong input corpus')
    cases={c['champion']:c for c in native['cases']};require(len(cases)==len(native['cases'])==122 and cases.keys()==source_graphs.keys(),'Missing/duplicate graph result')
    pins=[native[k] for k in ['binary','producer','provider_VM','parent_VM','inputs']]+inputs['input_sources']+inputs['payload_source_identities']
    pins += [execution['log'],pin(v/'original-preload-keys.json'),pin(v/'original-preload-keys-execution.json'),pin(v/'unresolved-preload-name-research.json'),pin(v/'manager-source-qualification.json'),pin(v/'provider-key-source.json'),pin(v/'key-transform-helper-source.json'),pin(v/'CRT-key-transform-source.json'),pin(v/'prototype_original_provider_v1.py'),pin(v/'prototype_original_provider_v2.py'),pin(v.parent/'revision30/probe_original_graph_owner.py'),pin(v.parent/'revision29/graph_predicate_model.py'),pin(v.parent/'revision29/probe_original_graph_predicate.py'),pin('E:/mapslol3v3/champion_critical_blnd_graph_static_source_audit/bounded_blnd_type1_reader.py')]
    require(pin(v/'local-preload-resource-inputs.json')==native['inputs'],'Input identity differs')
    global_expected=alias_entries(inputs['global_registration_members'])
    require({e['key']:e['value'] for e in native['original_global_reference_alias_entries']}==global_expected,'Original global reference alias registration differs')
    rows=[];classifications=collections.Counter();queries_count=0;occurrences_count=0;all_exact_names=set();missing=[]
    global_values={k.lower():value for k,value in global_expected.items()}
    for graph in inputs['graphs']:
        champion=graph['champion'];source=source_graphs[champion];case=cases[champion]
        require(graph['graph_source']==case['graph_source']==source['graph_source'],'Graph identity rebound');pins.append(graph['graph_source'])
        require(graph['task_ids']==source['task_ids'],'Requirement links rebound')
        require(case['local_reference_directory']==graph['local_reference_directory'] and case['local_alias_map_released_by_explicit_probe_cleanup'] is True and case['global_alias_map_retained_for_next_graph'] is True,'Wrong fixture scope/lifetime observation')
        expected_aliases=alias_entries(graph['local_registration_members'])
        require({e['key']:e['value'] for e in case['original_local_alias_entries']}==expected_aliases,'Original local alias registration differs')
        local_values={k.lower():value for k,value in expected_aliases.items()}
        expected_names=collections.OrderedDict()
        for e in source['selected']:expected_names.setdefault(e['preload_name'],[]).append({'record_index':e['record_index'],'entry_index':e['index'],'name_offset':e['name_offset']})
        require(len(graph['rows'])==len(expected_names) and {r['name'] for r in graph['rows']}==expected_names.keys(),'Source graph name set differs')
        require(len(case['queries'])==2*len(graph['rows']),'Incomplete nominal/case-variant queries')
        bindings=[]
        for i,row in enumerate(graph['rows']):
            name=row['name'];expected=local_values.get(name.lower()) or global_values.get(name.lower()) or ''
            require(isinstance(name,str) and name.isascii() and '\0' not in name and row['occurrences']==expected_names[name],'Wrong original graph string binding')
            require(row['expected_canonical_for_declared_profile']==expected and '\\' not in expected and '//' not in expected,'Declared canonical reference mismatch/outside qualified path profile')
            classification='unique_local_reference_candidate' if name.lower() in local_values else 'global_reference_candidate' if name.lower() in global_values else 'missing_in_declared_local_and_global_profiles'
            require(row['classification']==classification and row['real_runtime_priority_or_resource_loading_qualified'] is False,'Incorrect reference classification or runtime claim')
            candidate=row['selected_reference_candidate']
            if expected:
                require(candidate is not None and candidate==members[(expected+'bin').lower()],'Selected candidate does not match the exact core reference member')
                identity=candidate['selected_source'];b=pathlib.Path(identity['path']).read_bytes();require(len(b)==identity['bytes'] and hashlib.sha256(b).hexdigest()==identity['sha256'] and hashlib.md5(b).hexdigest()==identity['md5'],'Changed exact payload candidate')
            else:require(candidate is None,'Missing lookup falsely promoted to selected payload');missing.append((champion,name))
            for query,variant in zip(case['queries'][2*i:2*i+2],[name,name.swapcase()],strict=True):
                require(query['name']==name and query['query_variant']==variant and query['classification']==classification,'Native query/variant identity mismatch')
                require(query['expected_canonical']==query['canonical_before_normalization']==expected and query['expected_normalized_key']==query['normalized_key']==expected.lower(),'Native provider/key observation mismatch')
                require(type(query['provider_argument']) is int and query['provider_argument']==0x41020000 and query['original_stop_PC']=='0x92bbf9','Wrong provider/stop point')
                require(query['original_temporary_string_destructor_executed'] is True and query['caller_frame_discarded_and_FS_restored_by_probe'] is True,'Partial-prefix cleanup boundary hidden')
                queries_count+=1
            classifications[classification]+=1;occurrences_count+=len(row['occurrences']);all_exact_names.add(name)
            bindings.append({**row,'native_key':expected.lower(),'original_prefix_and_both_case_variants_verified':True,'per_spell_event_binding_qualified':False})
        rows.append({'champion':champion,'graph_source':graph['graph_source'],'task_ids':graph['task_ids'],'local_reference_directory':graph['local_reference_directory'],'bindings':bindings,'real_namespace_priority_manager_loading_or_event_firing_qualified':False})
    require(set(missing)=={(r['champion'],r['name']) for r in research['rows']} and len(missing)==19,'Unresolved-name research scope differs')
    require(research['counts']['names_with_exact_whole_core_basename_candidates']==1 and research['counts']['separate_suffix_hypotheses']==1 and research['runtime_priority_loading_or_effect_absence_qualified'] is False,'Unqualified missing-name resolution')
    roots=[pathlib.Path(p).resolve() for p in ['E:/OpenLeague','E:/mapslol3v3','D:/LeagueOfLegendsV2/4.20']]
    unique={str(pathlib.Path(p['path']).resolve()).casefold():p for p in pins};identities=[]
    for identity in unique.values():
        p=pathlib.Path(identity['path']).resolve();require(any(p.is_relative_to(root) for root in roots),'Reference outside declared roots');require(pin(p)==identity,'Changed reference: '+str(p));identities.append(identity)
    lines=[json.loads(line) for line in pathlib.Path(execution['log']['path']).read_text('utf-8').splitlines() if line.startswith('{')];final=lines[-1]
    require(final['completed'] is True and final['error'] is None and final['graphs']==122 and final['queries']==queries_count and final['instructions']==native['original_instructions'] and final['PCs']==len(pcs) and final['faults']==final['live_allocations']==0,'Actual terminal log does not corroborate result')
    require(type(native['original_instructions']) is int and native['original_instructions']>queries_count,'Invalid instruction-hook counter')
    counts={'graphs':len(rows),'unique_champion_names':sum(len(r['bindings']) for r in rows),'unique_exact_names':len(all_exact_names),'name_occurrences':occurrences_count,'native_prefix_queries':queries_count,'local_reference_matches':classifications['unique_local_reference_candidate'],'global_reference_matches':classifications['global_reference_candidate'],'empty_native_results':classifications['missing_in_declared_local_and_global_profiles'],'fresh_manifest_exact_payload_candidates':len(inputs['payload_source_identities']),'original_instruction_hooks_including_stop_PC':native['original_instructions'],'declared_stop_PC_hooks':queries_count,'original_instruction_hooks_excluding_stop_PC':native['original_instructions']-queries_count,'original_PCs':len(pcs),'fresh_source_files':len(identities)}
    return {'schema':'openleague_native_preload_key_audit/v1','counts':counts,'rows':rows,'unresolved_name_research':research,'source_identities':identities,'original_game_binary':native['binary'],'native_execution':pin(v/'original-preload-keys-execution.json'),'native_observations':pin(v/'original-preload-keys.json'),'declared_boundaries':native['boundaries'],'full_manager_return_loading_bootstrap_event_firing_qualified':False,'all_Goal_objectives_completed':False}

def main():
    p=argparse.ArgumentParser();p.add_argument('--evidence-root',required=True);p.add_argument('--output',required=True);a=p.parse_args();out=pathlib.Path(a.output)
    if out.exists():raise ValueError('Preserve previous output')
    result=audit(a.evidence_root);out.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');print(json.dumps(result['counts']))
if __name__=='__main__':main()
