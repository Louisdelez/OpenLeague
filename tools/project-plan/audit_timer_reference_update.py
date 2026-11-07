"""Read-only verification of real reference operations and bounded original update."""
import argparse, copy, hashlib, itertools, json, math, pathlib, struct, sys
R = pathlib.Path('E:/OpenLeague'); S = pathlib.Path('E:/mapslol3v3')
sys.path.insert(0, str(R / 'tools/pythonlibs'))
import pefile, capstone

def load(p): return json.loads(pathlib.Path(p).read_bytes())
def pin(p):
    p = pathlib.Path(p); b = p.read_bytes()
    return {'path': str(p), 'bytes': len(b), 'sha256': hashlib.sha256(b).hexdigest()}
def need(ok, why):
    if not ok: raise ValueError(why)
def f32(n): return struct.unpack('<f', struct.pack('<f', n))[0]
def sha(b): return hashlib.sha256(b).hexdigest()

def audit(evidence_root, inputs_override=None, real_override=None, update_override=None, trace_override=None):
    v = pathlib.Path(evidence_root).resolve(strict=True)
    need(v.is_relative_to(S.resolve()), 'Evidence outside workspace')
    inputs = load(v / 'timer-reference-update-inputs.json') if inputs_override is None else inputs_override
    need(inputs['schema'] == 'openleague_timer_reference_update_inputs/v1', 'Wrong input schema')
    need(all(inputs[k] is False for k in ['actual_Lua_VM_callback_executed', 'historical_epoch_qualified', 'named_active_timer_behavior_qualified', 'current_gameplay_qualified', 'historical_OS_process_launched']), 'Unsupported whole/historical claim')
    identities = {}; tools = {}
    def keep(x, tool=False):
        p = pathlib.Path(x['path']).resolve(strict=True)
        need(any(p.is_relative_to(a.resolve()) for a in [R, S, pathlib.Path('D:/LeagueOfLegendsV2/4.20')]) or tool and p == pathlib.Path(sys.executable).resolve(), 'Source outside allowed roots')
        observed = pin(p)
        need(all(observed[k] == x[k] for k in ['bytes', 'sha256']), 'Changed source identity')
        (tools if tool else identities)[str(p).casefold()] = x
        return p
    for k in ['producer', 'reference', 'prior_delivery', 'prior_audit', 'prior_trace', 'real_references', 'update', 'trace']: keep(inputs[k])
    for x in inputs['tools']: keep(x)
    reference = load(inputs['reference']['path'])
    need(reference['client']['version'] == '4.20.0.315' and reference['reference'] == {'date': '2014-11-17', 'date_kind': 'embedded_client_build_date', 'region': 'EUW', 'locale': 'en_GB'}, 'Wrong original reference')
    prior = load(inputs['prior_delivery']['path']); inherited = load(inputs['prior_audit']['path'])
    need(prior['delivery_audit']['passed'] and not prior['delivery_audit_pending'] and not prior['integration_pending'] and prior['counts'] == inherited['counts'], 'Unqualified inherited delivery')
    for x in inherited['source_identities']: keep(x)
    need(inherited['verified'] and inherited['counts']['total_original_code_profiles'] == 321, 'Wrong inherited scope')
    real = load(inputs['real_references']['path']) if real_override is None else real_override
    update = load(inputs['update']['path']) if update_override is None else update_override
    need(real['schema'] == 'openleague_original_timer_real_references/v1' and update['schema'] == 'openleague_original_timer_update_call_boundary/v1', 'Wrong observation schema')
    need(real['reference_operation_hooks_installed'] is False and update['original_reference_operation_hooks_installed'] is False, 'Reference operations intercepted')
    need(real['cases_count'] == len(real['cases']) == 156 and real['contexts_with_reference'] == 144 and real['ownerless_control_profiles'] == 12, 'Wrong reference profiles')
    need(update['cases_count'] == len(update['cases']) == 128 and update['entry_VA'] == 0x593bf0, 'Wrong update profiles/entry')
    need(real['original_reference_entries_executed'] == [0x48d050, 0x48d100, 0x48d1d0, 0x492be0], 'Wrong reference entries')
    ctx = {'context': 0x32001000, 'state': 0x32002000, 'list_head': 0x32002118, 'context_state_pointer_offset': 0x10, 'state_list_head_offset': 0x118, 'value_tag': 6, 'source_object': 0x31008004, 'pool': 0x2d5e1e8, 'stride': 0x48}
    need(real['provided_reference_context'] == ctx, 'Wrong supplied reference layout')
    need(real['source'] == update['source'] and real['runtime'] == update['runtime'], 'Mixed source/runtime')
    source = keep(real['source'])
    need(source.name == 'League of Legends.exe' and sha(source.read_bytes()) == next(x['sha256'] for x in reference['sources'] if x['path'] == reference['client']['binary']), 'Wrong original PE')
    for record in [real, update]:
        keep(record['producer']); runtime = record['runtime']; keep(runtime['python'], True)
        keep(runtime['unicorn_python_module']); keep(runtime['pefile_module'])
        need(runtime['unicorn_version'] == '2.1.4', 'Wrong emulation runtime')
        for x in runtime['backend_dll_candidates']: keep(x)
    for k in ['actual_historical_Lua_VM_or_GC_qualified', 'scheduler_callback_or_whole_update_executed', 'historical_epoch_or_initial_clock_anchor_qualified', 'native_OS_game_process_launched', 'current_Rust_or_CSharp_gameplay_executed', 'integrated_into_registry']: need(real[k] is False, 'Unsupported real-reference scope')
    for k in ['actual_Lua_VM_callback_executed', 'named_active_timer_behavior_qualified', 'historical_delta_source_or_epoch_qualified', 'native_OS_game_process_launched', 'current_Rust_or_CSharp_gameplay_executed', 'integrated_into_registry']: need(update[k] is False, 'Unsupported update scope')
    need(update['single_declared_boundary'] == {'entry_VA': 0x5bf450, 'scope': 'Observe requested zero-argument Lua function call and supply an unowned nil result object. Actual Lua VM, function execution and native return-object ownership are unqualified.'}, 'Wrong Lua-call boundary')
    need(real['prior_opaque_boundary_probe'] == next(x for x in prior['fresh_native_experiments_current_goal_turn'] if pathlib.Path(x['path']).name == 'original-neutral-timer-body.json'), 'Wrong reference experiment lineage')
    need(update['real_reference_probe'] == inputs['real_references'], 'Wrong update lineage')
    pool, stride, head, context, sp = 0x2d5e1e8, 0x48, 0x32002118, 0x32001000, 0x31008000
    expected_profiles = [(True, *a) for a in itertools.product([0, 1], [-1., 85.], [100., 100.25], [50., 90., 300.], [False, True], [0, 2, None])]
    expected_profiles += [(False, dispatch, 85., 100.25, 50., flag, slot) for dispatch, flag, slot in itertools.product([0, 1], [False, True], [0, 2, None])]
    normalized = []; original_pcs = set(); fresh_count = 0; excluded_count = 0
    def safe(case, delta):
        need(case['invalid_accesses'] == [] and case['stack_delta'] == delta and case['SEH_chain_restored'] is True and case['canary_preserved'] is True and case['whole_pool_matches_expected'] is True, 'Memory/stack/SEH/pool mismatch')
        pcs = case['executed_PCs']; need(pcs == sorted(set(pcs)) and pcs, 'Invalid instruction identities')
    for i, (c, profile) in enumerate(zip(real['cases'], expected_profiles, strict=True)):
        owned, dispatch, epoch, current, delay, flag, slot = profile
        need(tuple(c[k] for k in ['supplied_source_has_context', 'supplied_dispatch_global', 'supplied_epoch', 'supplied_current_clock', 'supplied_delay', 'supplied_repeat', 'supplied_first_nil_slot']) == profile, 'Wrong reference input profile')
        before = bytearray(b'\xa7' * (64 * stride))
        for n in range(64):
            obj = n * stride + 0x28; struct.pack_into('<II', before, obj, 0, 0); struct.pack_into('<I', before, obj + 0x10, 0 if n == slot else 6); struct.pack_into('<I', before, obj + 0x18, 0)
        blob = bytearray(range(0x40, 0x60)); struct.pack_into('<II', blob, 0, head if owned else 0, head if owned else 0); struct.pack_into('<I', blob, 0x10, 6); struct.pack_into('<I', blob, 0x18, context if owned else 0)
        elapsed = 0. if epoch < 0 else f32(f32(current) - f32(epoch)); duration = f32(math.ceil(elapsed) + delay - elapsed); expected = bytearray(before)
        if slot is not None:
            offset = slot * stride; obj = offset + 0x28; struct.pack_into('<ffBB', expected, offset, 0., duration, int(flag), 1)
            if owned:
                struct.pack_into('<II', expected, obj, head, head); expected[obj + 8:obj + 0x14] = blob[8:0x14]; struct.pack_into('<I', expected, obj + 0x18, context)
        expected_head = pool + slot * stride + 0x28 if owned and slot is not None else head
        need(c['expected_duration'] == duration and c['expected_slot_type'] == c['observed_slot_type'] == (None if slot is None else 6 if owned else 0), 'Reference duration/type mismatch')
        need(c['before_pool_sha256'] == sha(before) and c['expected_pool_sha256'] == c['after_pool_sha256'] == sha(expected), 'Reference whole-pool mismatch')
        need(c['expected_list_head'] == expected_head and c['observed_list_links'] == [expected_head] * 2 and c['predicate_slots'] == list(range(64 if slot is None else slot + 1)), 'Reference list/scan mismatch')
        calls = c['original_reference_calls']; entries = [x['entry_VA'] for x in calls]
        need(set(entries) <= {0x48d050, 0x48d100, 0x48d1d0, 0x492be0} and entries.count(0x48d050) == 1 and entries.count(0x48d100) == int(slot is not None) and entries.count(0x48d1d0) == 2 and entries.count(0x492be0) == (1 + int(slot is not None) if owned else 0), 'Wrong original reference call counts')
        need(all(x['receiver'] > 0 for x in calls) and all(x['entry_VA'] in c['executed_PCs'] for x in calls), 'Reference entry/trace mismatch')
        safe(c, 4); count = c['executed_instruction_count']; need(count >= len(c['executed_PCs']), 'Wrong instruction count')
        normalized.append({'probe': 'references', 'case_index': i, 'recorded_code_hook_visits': count, 'excluded_visits': 0, 'original_instruction_count': count, 'excluded_PC_values': []}); original_pcs.update(c['executed_PCs']); fresh_count += count
    request_total = 0
    for i, (c, profile) in enumerate(zip(update['cases'], itertools.product([0, 63], [0., 9.75, 10., 25.], [0., .25, 1., 25.], [False, True], [False, True]), strict=True)):
        slot, elapsed, delta, flag, active = profile
        need(tuple(c[k] for k in ['supplied_slot', 'supplied_elapsed', 'supplied_delta', 'supplied_keep_active_flag', 'supplied_active']) == profile and c['supplied_duration'] == 10., 'Wrong update input profile')
        before = bytearray(b'\xa7' * (64 * stride))
        for n in range(64):
            off = n * stride; before[off + 9] = 0; struct.pack_into('<II', before, off + 0x28, 0, 0); struct.pack_into('<I', before, off + 0x38, 0); struct.pack_into('<I', before, off + 0x40, 0)
        start = slot * stride; obj = pool + start + 0x28
        struct.pack_into('<ffBB', before, start, elapsed, 10., int(flag), int(active)); struct.pack_into('<II', before, start + 0x28, head, head); struct.pack_into('<III', before, start + 0x30, 0x12345678, 0, 6); struct.pack_into('<I', before, start + 0x40, context)
        value = f32(elapsed + delta) if active else elapsed; subtractions = 0; expired = active and value >= 10
        if active:
            while value >= 10: value = f32(value - 10); subtractions += 1
        expected = bytearray(before); struct.pack_into('<f', expected, start, value)
        if expired:
            if not flag: expected[start + 9] = 0
            struct.pack_into('<I', expected, start + 0x38, 0)
        need(c['expected_expired'] == expired and c['duration_subtractions'] == subtractions and c['expected_elapsed'] == c['observed_elapsed'] == value and c['observed_active_byte'] == expected[start + 9] and c['observed_callback_type'] == (0 if expired else 6), 'Wrong expiry/reset/active result')
        need(c['before_pool_sha256'] == sha(before) and c['expected_pool_sha256'] == c['after_pool_sha256'] == sha(expected), 'Update whole-pool mismatch')
        need(c['reference_list_links'] == [obj] * 2 and c['named_timer_family_unchanged_inactive'] is True, 'Update list/named-family mismatch')
        calls = c['call_requests']; need(len(calls) == int(expired), 'Wrong Lua-call request count')
        for call in calls:
            need(call['boundary_VA'] == 0x5bf450 and call['observed_type_tag'] == 6 and call['observed_value_bytes'] == struct.pack('<III', 0x12345678, 0, 6).hex() and call['provided_result'] == 'unowned_nil_object' and call['provided_call_receiver'] > 0 and call['result_object'] > 0, 'Wrong Lua-call boundary observation')
        entries = c['original_reference_entries']; need(set(entries) <= {0x48d050, 0x48d100, 0x48d1d0, 0x492be0, 0x490800} and entries.count(0x490800) == int(expired) and all(x in c['executed_PCs'] for x in entries), 'Wrong original reset/reference path')
        safe(c, 8); visits = c['executed_instruction_count_including_boundary_visits']; removed = len(calls); need(visits >= len(c['executed_PCs']), 'Wrong update instruction count')
        normalized.append({'probe': 'update', 'case_index': i, 'recorded_code_hook_visits': visits, 'excluded_visits': removed, 'original_instruction_count': visits - removed, 'excluded_PC_values': [0x5bf450] if expired else []})
        need((0x5bf450 in c['executed_PCs']) == expired, 'Boundary trace mismatch')
        original_pcs.update(set(c['executed_PCs']) - {0x5bf450}); fresh_count += visits - removed; excluded_count += removed; request_total += len(calls)
    trace = load(inputs['trace']['path']) if trace_override is None else trace_override
    need(trace['schema'] == 'openleague_timer_reference_update_trace/v1' and trace['source'] == real['source'] and trace['inherited_trace'] == inputs['prior_trace'], 'Wrong trace source/lineage')
    keep(trace['producer']); keep(trace['decoder'])
    need(trace['fresh_profiles'] == normalized, 'Wrong normalized instruction counts')
    old_trace = load(inputs['prior_trace']['path']); old_pcs = {x['VA'] for x in old_trace['original_PC_instructions']}; expected_pcs = old_pcs | original_pcs
    rows = trace['original_PC_instructions']; need(len(rows) == len(expected_pcs) and {x['VA'] for x in rows} == expected_pcs, 'Wrong original PC coverage')
    raw = source.read_bytes(); pe = pefile.PE(data=raw); md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    for row in rows:
        address = row['VA']; off = pe.get_offset_from_rva(address - pe.OPTIONAL_HEADER.ImageBase)
        need(pe.get_section_by_rva(address - pe.OPTIONAL_HEADER.ImageBase).Characteristics & 0x20000000, 'Trace outside executable PE')
        ins = next(md.disasm(raw[off:off + 15], address, count=1))
        need(row == {'VA': address, 'file_offset': off, 'bytes': bytes(ins.bytes).hex(), 'mnemonic': ins.mnemonic, 'operands': ins.op_str}, 'Changed original instruction identity')
    result = copy.deepcopy(inherited)
    result['schema'] = 'openleague_timer_reference_update_audit/v1'
    result['counts'].update(inherited_original_code_profiles=321, fresh_real_reference_profiles=156, fresh_whole_update_profiles=128,
        total_original_code_profiles=605, original_PC_identities=len(expected_pcs),
        original_instruction_count_excluding_boundaries=inherited['counts']['original_instruction_count_excluding_boundaries'] + fresh_count,
        fresh_original_instruction_count_excluding_boundaries=fresh_count, excluded_Lua_boundary_visits=excluded_count, observed_Lua_call_requests=request_total)
    result['source_identities'] = list(identities.values()); result['tool_identities'] = list(tools.values())
    result['inherited_native_experiments'] = inherited['inherited_native_experiments'] + inherited['fresh_native_experiments']
    result['fresh_native_experiments'] = [inputs['real_references'], inputs['update']]
    result['comparison'].update(reference_operations='Original copy/assignment/list insertion/destruction execute on supplied layouts without interception.', whole_update='Original 0x593bf0 completes with named timers inactive and one declared zero-argument Lua-call boundary.', flag_offset8='Controls active-byte clearing on expiry; repeating callback semantics not established.', reset_type='Original 0x490800 sets slot callback type to nil after the provided call result.', remaining_catchup='Elapsed durations continue to be subtracted; no additional request after type reset in these provided profiles.')
    result['declared_boundaries'] = [
        '321 inherited profiles remain qualified in their exact earlier scopes; 284 new completed profiles are separately checked without replay.',
        'Original reference bookkeeping executes on supplied Lua-state-like/global-state-like lists and opaque typed function values, without a historical Lua VM or GC lifecycle.',
        'Whole update runs both loops and epilogue with all named timers inactive; only 0x5bf450 is bypassed with an unowned nil return object.',
        'The bypassed 0x5bf450 visit is excluded once per call from original instruction execution counts.',
        'The byte provisionally called repeat only controls active-flag clearing in these paths. Original type reset prevents additional call requests in the provided catch-up profiles; actual callback side effects/rescheduling remain unknown.',
        'Historical epoch/delta production, named active timer behavior, argument conversion and full original server/Lua callbacks remain unqualified.',
        'Current Rust and community source anchors remain source inspection; no whole gameplay equivalence or human acceptance.'
    ]
    return result

def main():
    p = argparse.ArgumentParser(); p.add_argument('--evidence-root', required=True); p.add_argument('--output', required=True); a = p.parse_args()
    try: result = audit(a.evidence_root)
    except (OSError, ValueError, KeyError, IndexError, StopIteration, struct.error) as e:
        print(json.dumps({'verified': False, 'error': str(e)}, ensure_ascii=False)); return 1
    pathlib.Path(a.output).write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(json.dumps({'verified': True, 'counts': result['counts']})); return 0
if __name__ == '__main__': raise SystemExit(main())
