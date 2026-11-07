"""Read-only consumer of original graph preload dispatch observations.

The real manager is intentionally unqualified. No game runtime is modified by
this source/consumer registry tool.
"""
import argparse, collections, importlib.util, json, pathlib, sys

def load(p):return json.loads(pathlib.Path(p).read_bytes())

def audit(evidence_root,model_path,native_override=None,execution_override=None):
    v=pathlib.Path(evidence_root).resolve();spec=importlib.util.spec_from_file_location('preload_model',model_path)
    m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
    native=load(v/'original-preload-dispatch.json') if native_override is None else native_override
    execution=load(v/'original-preload-dispatch-execution.json') if execution_override is None else execution_override
    source=load(v/'preload-helper-source.json');aliases=load(v.parent/'revision31/effective-native-alias-audit-qualified.json')
    m.require(native['schema']=='openleague_original_preload_dispatch/v1','Wrong native result schema')
    m.require(native['execution_completed'] is True and type(execution['exit_code']) is int and execution['exit_code']==0,'Native experiment incomplete')
    m.require(native['invalid_access']==[] and native['heap_current']=={},'Native fault or remaining guest heap')
    m.require(native['binary']==source['binary'] and native['binary']['sha256']=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862','Wrong original game binary')
    for k in ['historical_OS_process_launched','real_manager_loader_executed','ANM_loader_executed','actual_outer_caller_executed','actual_event_firing_or_cast_selection_pose_playback_qualified']:
        m.require(native[k] is False,'Overbroad native scope: '+k)
    m.require(len(native['declared_boundaries'])==6 and type(native['original_instructions']) is int and native['original_instructions']>0,'Missing execution boundaries')
    pcs={int(p,16) for p in native['original_PCs']}
    m.require(len(pcs)==len(native['original_PCs']) and {0x5685f0,0x577af0,0x577c00,0x5cc140,0x896130,0x896b70,0x8961d0}<=pcs and 0x8b1910 not in pcs,'Wrong original components/initializer scope')
    pins=[native[k] for k in ['binary','producer','model','parent_VM','parent_owner_VM','native_source','alias_reference']]
    pins += [execution['log'],m.pin(model_path),m.pin(v/'original-preload-dispatch.json'),m.pin(v/'original-preload-dispatch-execution.json'),m.pin(v/'post-owner-binding-source.json'),m.pin(v/'preload-control-helper-source.json')]
    pins += [m.pin(v.parent/'revision29/graph_predicate_model.py'),m.pin(v.parent/'revision29/probe_original_graph_predicate.py'),m.pin('E:/mapslol3v3/champion_critical_blnd_graph_static_source_audit/bounded_blnd_type1_reader.py')]
    m.require(m.pin(model_path)==native['model'],'Different preload model')
    m.require(source['sentinel_0x12395cc']==0xffffffff,'Wrong relative null sentinel')
    expected_graphs={};tasks=collections.defaultdict(set)
    for row in aliases['rows']:
        if row['champion'] in expected_graphs:m.require(expected_graphs[row['champion']]==row['graph_source'],'Inconsistent graph candidates')
        expected_graphs[row['champion']]=row['graph_source'];tasks[row['champion']].add(row['presentation_task_id'])
        if row['role_task_id']:tasks[row['champion']].add(row['role_task_id'])
    cases={c['champion']:c for c in native['cases']}
    m.require(len(expected_graphs)==122 and len(native['cases'])==len(cases)==122 and cases.keys()==expected_graphs.keys(),'Missing/duplicate/wrong graph observation')
    rows=[];context=0x73124567
    for champion,identity in expected_graphs.items():
        case=cases[champion];m.require(case['source']==identity,'Graph source binding mismatch');pins.append(identity)
        parsed=m.parse_records(pathlib.Path(identity['path']).read_bytes());records=parsed['records']
        m.require(case['records']==records and type(case['record_count']) is int and case['record_count']==parsed['record_count'] and type(case['entry_count']) is int and case['entry_count']==sum(len(r['entries']) for r in records),'Serialized record observation mismatch')
        expected=[{'name':e['preload_name'],'name_offset':e['name_offset'],'context_u32':context} for e in parsed['selected']]
        m.require(type(case['selected_nonempty_kind2_count']) is int and case['selected_nonempty_kind2_count']==len(expected),'Wrong selected string count')
        m.require(type(case['live_allocations_after_destructor']) is int and case['live_allocations_after_destructor']==0 and type(case['guest_allocations']) is int and case['guest_allocations']>=2 and case['canaries_unchanged'] is True and case['original_owner_and_post_components_executed'] is True,'Owner/canary qualification failed')
        profiles=case['profiles'];names=['enabled_manager_spy','disabled_manager_spy','enabled_manager_absent','enabled_null_owner']
        m.require(len(profiles)==4 and [p['mode'] for p in profiles]==names,'Wrong/duplicate/missing profiles')
        markers=[]
        for e in expected:
            pair={k:e[k] for k in ['name','name_offset']}
            markers.extend([{'kind':'original_before',**pair},{'kind':'manager_spy',**e},{'kind':'original_after',**pair}])
        for p,disabled,manager in zip(profiles,[False,True,False,False],[True,True,False,True],strict=True):
            m.require(p['cached_DisablePreload'] is disabled and p['manager_supplied'] is manager,'Incorrect cached profile inputs')
            for event in p['dispatch']+p['markers']:
                m.require(type(event['name_offset']) is int and type(event.get('context_u32',context)) is int,'Noninteger native argument')
        m.require(profiles[0]['dispatch']==expected and profiles[0]['markers']==markers,'Enabled native dispatch order/arguments mismatch')
        m.require(profiles[1]['dispatch']==profiles[1]['markers']==[],'Disabled branch still dispatches')
        m.require(profiles[2]['dispatch']==[] and profiles[2]['markers']==[a for a in markers if a['kind']!='manager_spy'],'Manager-absent branch differs')
        m.require(profiles[3]['dispatch']==profiles[3]['markers']==[],'Null-owner branch still dispatches')
        kinds=collections.Counter(e.get('kind_raw') for r in records for e in r['entries'])
        rows.append({'champion':champion,'graph_source':identity,'task_ids':sorted(tasks[champion]),'record_count':len(records),'entry_count':case['entry_count'],'kind_counts':dict(kinds),'selected':parsed['selected'],'selected_nonempty_kind2_count':len(expected),'native_profiles_verified':names,'native_pre_manager_post_order_verified':True,'all_guest_owner_allocations_released':True,'resource_names_are_graph_wide_not_per_spell_trigger_binding':True,'actual_manager_loader_or_event_firing_qualified':False})
    roots=[pathlib.Path(p).resolve() for p in ['E:/OpenLeague','E:/mapslol3v3','D:/LeagueOfLegendsV2/4.20']]
    unique={str(pathlib.Path(p['path']).resolve()).casefold():p for p in pins};identities=[]
    for p in unique.values():
        target=pathlib.Path(p['path']).resolve();m.require(any(target.is_relative_to(r) for r in roots),'Reference outside declared roots')
        m.require(m.pin(target)==p,'Changed reference: '+str(target));identities.append(p)
    summary_lines=[json.loads(line) for line in pathlib.Path(execution['log']['path']).read_text('utf-8').splitlines() if line.startswith('{')]
    final=summary_lines[-1]
    m.require(final['completed'] is True and final['error'] is None and final['graphs']==122 and final['selected']==sum(r['selected_nonempty_kind2_count'] for r in rows) and final['instructions']==native['original_instructions'] and final['PCs']==len(pcs) and final['faults']==0,'Terminal log does not corroborate observations')
    counts={'graphs':len(rows),'records':sum(r['record_count'] for r in rows),'entries':sum(r['entry_count'] for r in rows),'selected_nonempty_kind2strings':sum(r['selected_nonempty_kind2_count'] for r in rows),'cached_profiles':4*len(rows),'guest_allocations_released':sum(c['guest_allocations'] for c in cases.values()),'original_instructions':native['original_instructions'],'original_PCs':len(pcs),'fresh_source_files':len(identities)}
    return {'schema':'openleague_native_preload_dispatch_audit/v1','counts':counts,'rows':rows,'source_identities':identities,'original_game_binary':native['binary'],'native_execution':m.pin(v/'original-preload-dispatch-execution.json'),'native_observations':m.pin(v/'original-preload-dispatch.json'),'model':m.pin(model_path),'declared_boundaries':native['declared_boundaries'],'real_manager_resource_loading_event_firing_cast_choice_pose_playback_qualified':False,'all_Goal_objectives_completed':False}

def main():
    p=argparse.ArgumentParser();p.add_argument('--evidence-root',required=True);p.add_argument('--model',required=True);p.add_argument('--output',required=True);a=p.parse_args();out=pathlib.Path(a.output)
    if out.exists():raise ValueError('Preserve previous output')
    result=audit(a.evidence_root,a.model);out.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');print(json.dumps(result['counts']))
if __name__=='__main__':main()
