"""Verify exact Garen community component requests and native source roles; no gameplay execution."""
import argparse, datetime, hashlib, json, pathlib, sys
R = pathlib.Path('E:/OpenLeague')
S = pathlib.Path('E:/mapslol3v3')

def allowed(p):
    p = pathlib.Path(p)
    roots = [R, S, pathlib.Path('D:/LeagueOfLegendsV2/4.20'), pathlib.Path('C:/Program Files/dotnet')]
    if not any((p.resolve().is_relative_to(r.resolve()) for r in roots)):
        raise ValueError('Source outside explicit roots')
    return p

def load(p):
    return json.loads(allowed(p).read_bytes())

def pin(p):
    p = allowed(p)
    b = p.read_bytes()
    return dict(path=str(p), bytes=len(b), sha256=hashlib.sha256(b).hexdigest())

def same(a, b):
    return json.dumps(a, sort_keys=True, separators=(',', ':')) == json.dumps(b, sort_keys=True, separators=(',', ':'))

def audit(evidence_root, inputs_override=None, execution_override=None, observation_override=None):
    V = pathlib.Path(evidence_root).resolve(strict=True)
    if not V.is_relative_to(S.resolve()):
        raise ValueError('Evidence root outside workspace')
    checks = {}

    def check(name, value):
        assert value, name
        checks[name] = True
    execution = load(V / 'garen-component-execution.json') if execution_override is None else execution_override
    inputs = load(execution['inputs']['path']) if inputs_override is None else inputs_override
    observation = load(execution['observation']['path']) if observation_override is None else observation_override
    check('execution_and_input_schemas', execution['schema'] == 'openleague_garen_full_class_component_execution/v1' and inputs['schema'] == 'openleague_garen_full_class_component_inputs/v1')
    identities = [execution['producer'], execution['inputs'], execution['dotnet'], execution['csc'], execution['assembly'], execution['observation']]
    identities += execution['host_sources']
    for pair in execution['exact_original_CSharp_inputs']:
        identities.extend([pair['original'], pair['copy']])
    check('all_execution_sources_and_copies_exact', all((pin(x['path']) == x for x in identities)))
    check('ten_exact_original_files', len(execution['exact_original_CSharp_inputs']) == 10 and all((pathlib.Path(x['original']['path']).read_bytes() == pathlib.Path(x['copy']['path']).read_bytes() for x in execution['exact_original_CSharp_inputs'])))
    check('Q_class_matches_prior_semantic_snapshot', next((x['original'] for x in execution['exact_original_CSharp_inputs'] if pathlib.Path(x['original']['path']).name == 'Q.cs')) == inputs['previous_semantic_case']['community_source'])
    check('original_interface_metadata_and_enums_present', {'ISpellScript.cs', 'SpellScriptMetadata.cs', 'DamageType.cs', 'DamageSource.cs', 'TeamId.cs', 'ChannelingStopSource.cs', 'IMissileType.cs', 'SectorType.cs', 'SpellDataFlags.cs'}.issubset({pathlib.Path(x['original']['path']).name for x in execution['exact_original_CSharp_inputs']}))
    check('three_terminal_commands_and_exact_logs', len(execution['commands']) == 3 and all((c['exit_code'] == 0 and pin(c['log']['path']) == c['log'] for c in execution['commands'])))
    check('run_log_equals_observation', same(json.loads(pathlib.Path(execution['commands'][-1]['log']['path']).read_bytes()), observation))
    check('offline_sources_cleared', '<clear />' in (V / 'garen-component/NuGet.Config').read_text() and execution['offline_package_sources_cleared'] is True)
    check('original_setup_failure_retained', pin(inputs['initial_setup_failure']['path']) == inputs['initial_setup_failure'] and pin(inputs['initial_failed_producer']['path']) == inputs['initial_failed_producer'])
    check('seventeen_distinct_cases', observation['casesCount'] == len(observation['cases']) == 17 and len({c['id'] for c in observation['cases']}) == 17)
    negative = {'targets_null', 'targets_empty', 'first_target_null', 'first_target_non_AI', 'first_target_dead_enemy', 'first_target_ally', 'ally_then_enemy', 'metadata_and_empty_OnActivate'}
    positive = {f'enemy_rank_{rank}' for rank in range(1, 6)} | {'enemy_then_ally', 'null_silence_return_does_not_stop_method'}
    refusal = {'refuse_unqualified_damage_API', 'refuse_unqualified_haste_API'}
    check('exact_profile_set', {c['id'] for c in observation['cases']} == negative | positive | refusal)

    def request(api, name='', target='supplied_enemy', from_='supplied_owner', amount=0, count=0, type_='', source='', flag=False):
        return dict(api=api, name=name, target=target, from_=from_, amount=amount, count=count, type=type_, source=source, flag=flag)

    def requests(damage):
        rows = [request('TakeDamage', amount=damage, type_='DAMAGE_TYPE_PHYSICAL', source='DAMAGE_SOURCE_SPELL'), request('AddBuff', name='Silence', amount=1.5, count=1), request('AddBuff', name='GarenQHaste', target='supplied_owner', amount=4, count=1), request('AddParticleTarget', name='Garen_Q_tar')]
        for row in rows:
            row['from'] = row.pop('from_')
        return rows
    case_results = []
    for case in observation['cases']:
        name = case['id']
        rank = case['suppliedRank']
        expected_exception = None
        check(name + '_supplied_AD', type(case['suppliedAttackDamage']) in [int, float] and case['suppliedAttackDamage'] == 50)
        check(name + '_rank', type(rank) is int and 1 <= rank <= 5)
        expected = [] if name in negative else requests([100, 125, 150, 175, 200][rank - 1])
        if name == 'refuse_unqualified_damage_API':
            expected = expected[:1]
            expected[0]['api'] = 'REFUSED:TakeDamage'
            expected_exception = 'REFUSED:TakeDamage'
        if name == 'refuse_unqualified_haste_API':
            expected = expected[:3]
            expected[2]['api'] = 'REFUSED:AddBuff'
            expected_exception = 'REFUSED:AddBuff'
        for row in case['observedRequests']:
            check(name + '_numeric_types_' + str(len(case_results)) + row['api'] + row['name'], type(row['amount']) in [int, float] and type(row['count']) is int and (type(row['flag']) is bool))
            row = dict(row)

        def numeric_normalized(rows):
            normalized = []
            for row in rows:
                item = dict(row)
                item['amount'] = float(item['amount'])
                normalized.append(item)
            return normalized
        check(name + '_ordered_exact_requests', same(numeric_normalized(case['observedRequests']), numeric_normalized(expected)))
        check(name + '_driver_expected_agrees', same(numeric_normalized(case['expectedRequests']), numeric_normalized(expected)))
        check(name + '_exception', case['observedException'] == case['expectedException'] == expected_exception and case['passed'] is True)
        case_results.append(dict(id=name, requests_checked=len(expected), exception=expected_exception))
    check('no_engine_dispatch_or_complete_game_claims', all((observation[k] is False for k in ['actualEventDispatcherExecuted', 'realEngineAPIsExecuted', 'nativeOrRustGameplayExecuted', 'fullCommunityServerExecuted'])) and all((execution[k] is False for k in ['real_engine_APIs_executed', 'full_community_server_executed', 'original_game_dispatch_executed', 'current_Rust_gameplay_executed', 'historical_game_launched', 'script_fully_semantically_qualified', 'integrated_into_registry'])))
    check('native_files_membership_recorded', len(inputs['native_field_roles']) == 5 and len(inputs['native_Lua_static_observations']) == 4 and all((x['membership']['status'] == 'matches_selected_project_manifest' for x in inputs['native_field_roles'] + inputs['native_Lua_static_observations'])))
    for row in inputs['native_field_roles'] + inputs['native_Lua_static_observations']:
        check(pathlib.Path(row['source']['path']).name + '_native_identity', pin(row['source']['path']) == row['source'])

    def field(file, section, name):
        row = next((x for x in inputs['native_field_roles'] if pathlib.Path(x['source']['path']).name == file))
        return next((x for x in row['field_candidates'] if x['section'] == section and x['property'] == name))
    check('native_character_Spell1_references_GarenQ', field('Garen.inibin', 'Data', 'Spell1')['value'] == 'GarenQ')
    check('Q_and_QAttack_direct_dynamic_tooltip_main_key', all((field(f, 'SpellData', 'DynamicTooltip')['value'] == 'game_spell_tooltip_GarenQ' for f in ['GarenQ.inibin', 'GarenQAttack.inibin'])))
    check('buff_resource_string_is_different_key', next((x for x in inputs['native_field_roles'] if pathlib.Path(x['source']['path']).name == 'GarenQBuff.inibin'))['actual_string_entries'] == {'2287725201': 'game_buff_tooltip_GarenQBuff'})
    check('no_native_UI_or_original_server_template_claim', inputs['native_UI_template_selection_executed'] is False and inputs['original_game_dispatch_or_engine_qualified'] is False)
    for anchor in inputs['community_loader_API_anchors']:
        lines = pathlib.Path(anchor['source']['path']).read_text(encoding='utf-8-sig').splitlines()
        check(anchor['needle'], pin(anchor['source']['path']) == anchor['source'] and lines[anchor['line'] - 1] == anchor['excerpt'] and (anchor['needle'] in anchor['excerpt']))
    sys.path.insert(0, str(R / 'tools/project-plan'))
    from reference_inibin import read, hashkey
    from lua51_reference import inspect
    from rads_reference_membership import RadsReferenceMembership
    check('original_component_compilation_claims_exact', observation['exactWholeQClassCompiled'] is True and observation['exactOriginalInterfaceAndMetadataCompiled'] is True and (execution['exact_whole_Q_class_compiled'] is True) and (execution['exact_original_interface_and_metadata_compiled'] is True))
    check('no_invented_human_acceptance', execution.get('human_acceptance', 'not_given') == 'not_given' and inputs.get('human_acceptance', 'not_given') == 'not_given')
    check('prior_semantic_case_is_exact_current_ledger_row', pin(R / 'docs/fidelity_community_semantics_4_20.json') == inputs['previous_semantic_ledger'] and inputs['previous_semantic_case'] == next((x for x in load(R / 'docs/fidelity_community_semantics_4_20.json')['named_cases'] if x['id'] == 'GarenQ_literal_duration_contradictions')))
    check('reference_and_prior_delivery_roles_bound', pin(R / 'docs/reference_client_4_20.json') == inputs['reference'] and pin(R / 'docs/fidelity_registry_mastery_native_research_revision_4_20.json') == inputs['previous_delivery'])
    check('dotnet_and_csc_roles_bound', execution['dotnet']['path'] == str(pathlib.Path('C:/Program Files/dotnet/dotnet.exe')) and execution['csc']['path'] == str(pathlib.Path('C:/Program Files/dotnet/sdk/8.0.419/Roslyn/bincore/csc.dll')))
    check('initial_input_scope_retained', inputs['component_execution_pending'] is True and inputs['integrated_into_registry'] is False and (inputs['current_Rust_gameplay_executed'] is False) and (inputs['script_fully_semantically_qualified'] is False))
    membership = RadsReferenceMembership(R)
    dep = pathlib.Path(membership.deploy)
    for row in inputs['native_field_roles']:
        p = pathlib.Path(row['source']['path'])
        values = read(p)
        check(p.name + '_fields_decoded_exactly', all((f['hash'] == hashkey(f['section'], f['property']) and f['present'] == (f['hash'] in values) and same(f['value'], values.get(f['hash'])) for f in row['field_candidates'])))
        check(p.name + '_string_entries_exact', same(row['actual_string_entries'], {k: v for k, v in values.items() if isinstance(v, str)}))
        check(p.name + '_membership_recomputed', membership.inspect(p.relative_to(dep).as_posix(), p, row['source']) == row['membership'])
    for row in inputs['native_Lua_static_observations']:
        p = pathlib.Path(row['source']['path'])
        check(p.name + '_static_observation_recomputed', inspect(p) == row['observation'])
        check(p.name + '_membership_recomputed', membership.inspect(p.relative_to(dep).as_posix(), p, row['source']) == row['membership'])
    for anchor in inputs['previous_semantic_case']['current_consumers']:
        p = pathlib.Path(anchor['path'])
        lines = p.read_text(encoding='utf-8').splitlines()
        check(anchor['needle'] + '_current_Rust_site_unchanged', pin(p) == {k: anchor[k] for k in ['path', 'bytes', 'sha256']} and lines[anchor['line'] - 1] == anchor['excerpt'] and (anchor['needle'] in anchor['excerpt']))
    all_sources = {}

    def source_walk(value):
        if isinstance(value, dict):
            if {'path', 'bytes', 'sha256'}.issubset(value):
                ident = {k: value[k] for k in ['path', 'bytes', 'sha256']}
                p = pathlib.Path(ident['path'])
                key = str(p.resolve()).casefold()
                check('source_identity:' + key, pin(p) == ident)
                if key in all_sources:
                    check('source_not_rebound:' + key, all_sources[key] == ident)
                all_sources[key] = ident
            for v in value.values():
                source_walk(v)
        elif isinstance(value, list):
            for v in value:
                source_walk(v)
    source_walk(inputs)
    source_walk(execution)
    for p in [V / 'garen-component-inputs.json', V / 'garen-component-execution.json', V / 'garen-component-observation.json', R / 'tools/project-plan/reference_inibin.py', R / 'tools/project-plan/lua51_reference.py', R / 'tools/project-plan/rads_reference_membership.py']:
        all_sources[str(p.resolve()).casefold()] = pin(p)
    result = dict(schema='openleague_garen_component_independent_observation_qualification/v1', utc=datetime.datetime.now(datetime.timezone.utc).isoformat(), passed=True, producer=pin(__file__), execution=pin(V / 'garen-component-execution.json'), checks_count=len(checks), checks=checks, cases_count=17, case_results=case_results, source_identities_checked=len(identities), source_role_findings=['Native Garen Data.Spell1=GarenQ; Q and QAttack DynamicTooltip point directly to game_spell_tooltip_GarenQ.', 'GarenQBuff.inibin contains game_buff_tooltip_GarenQBuff, not game_spell_tooltip_GarenQBuff; UI selection/other template use remains unexecuted.', 'Under supplied inputs the exact community Q class uses only the first target,requests damage/Silence/haste/particle for an enemy and ignores a null AddBuff return.', 'Host observations are requests only; original event dispatch and real damage,buff,particle effects remain unqualified.'], integrated_into_registry=False, fully_semantically_qualified=False, human_acceptance_inferred=False, gameplay_modified=False)
    result['schema'] = 'openleague_garen_component_reference_audit/v1'
    result['source_identities'] = list(all_sources.values())
    result['qualification_scope'] = 'Read-only verification of exact source observations and17 inherited C# host profiles;no compilation or gameplay execution by this reader.'
    result['original_or_community_gameplay_qualified'] = False
    result['native_dynamic_tooltip_role_qualified'] = True
    result['global_alternate_template_absence_proven'] = False
    result['source_code_or_component_reexecuted'] = False
    return result
if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument('--evidence-root', required=True)
    p.add_argument('--output')
    a = p.parse_args()
    try:
        r = audit(a.evidence_root)
    except (AssertionError, ValueError, OSError, KeyError, IndexError, StopIteration) as e:
        print(json.dumps(dict(verified=False, error=str(e))))
        raise SystemExit(1)
    if a.output:
        out = pathlib.Path(a.output)
        if out.exists():
            raise ValueError('Preserve previous output')
        out.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(json.dumps(dict(verified=True, checks=r['checks_count'], inherited_CSharp_cases=17, sources=len(r['source_identities']), whole_gameplay_qualified=False)))
