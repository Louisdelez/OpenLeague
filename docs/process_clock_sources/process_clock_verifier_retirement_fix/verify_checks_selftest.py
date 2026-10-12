"""Tests of verifier logic only. Synthetic reports are not client evidence."""
from pathlib import Path
import copy
import importlib.util
import json
import struct

STAGE = Path('E:/mapslol3v3/loading_clock_integration')
spec = importlib.util.spec_from_file_location('qualification_verifier', STAGE / 'verify_client_commands.py')
v = importlib.util.module_from_spec(spec)
spec.loader.exec_module(v)


def bits(value):
    return struct.unpack('<I', struct.pack('<f', value))[0]


def application():
    return dict(closed=True, transport=None, native_source_sha256=v.NATIVE_SHA,
                worker_failures=[], handle_failures=0, workers_created=0, workers_closed=0, worker_completions=0,
                crt=dict(heap_allocations=2, heap_frees=2, heap_blocks=0, retained_mirrors=0,
                         critical_sections=0, heap_failures=0, lock_failures=0))


def synthetic_clock():
    origin, frequency = 100000, 10000000
    blank = dict(initialized=False, origin=0, frequency=0, qpf_calls=0, qpc_calls=0,
                 crt_allocations=0, pending_mirrors=0, inner_mutexes=0, registered_cleanups=[],
                 events_created=0, events_closed=0, event_close_failures=0, failure=None)
    live = dict(blank, initialized=True, origin=origin, frequency=frequency, qpf_calls=1, qpc_calls=33,
                crt_allocations=1, inner_mutexes=1, registered_cleanups=[0xce52c1, 0xce2955])
    trace = [dict(phase='attached', process_clock=blank)]
    for index, phase in enumerate(['first_effect_frame', 'running', *['paused'] * 4, 'resumed']):
        counter = origin + 1 + index * 200000
        time = 0 if index == 0 else (0.02 if index < 6 else 0.04)
        delta = 0 if index == 0 or 2 <= index < 6 else 0.02
        clock = dict(time=v.f32(bits(time)), time_bits=bits(time), delta_bits=bits(delta),
                     paused=2 <= index < 6, resume_pending=False, remaining=30.,
                     ordinal=0 if index < 2 else (1 if index < 6 else 2), failed=False)
        row = dict(phase=phase, raw=dict(counter=counter, origin=origin, frequency=frequency,
                                        wall_f32_bits=v.native_ratio_bits(counter-origin, frequency)),
                   effects=dict(clock=clock, animation_delta_bits=bits(delta)))
        if phase == 'paused':
            row['frame'] = index - 2
        trace.append(row)
    trace[-1].update(process_clock=live, wall_clock_api_f32_bits=bits(0.13))
    final = dict(live, crt_allocations=0, inner_mutexes=0, registered_cleanups=[])
    return dict(probe='native-process-clock', passed=True, complete=False, normal_application_attachment=True,
                application_instances=1, exercise_error=None, cleanup_errors=[], service_allocations_after_close=0,
                scope=dict(canonical_windows_clock=True, effect_plugin_frames=True, pause_resume_delivery='local ordered adapter',
                           loading_packet_dispatched=False, network_packet_delivery=False, ui_rendered=False,
                           animation_clips_played=False, gameplay_complete=False, fifo_contention_exercised=False),
                configuration=dict(default_loaded=True, user_loaded=False, default_path='default/Game.cfg',
                                   user_path='user/Game.cfg', parse_warnings=0, layout_mode=0),
                exercise=dict(frame_updates=7, paused_frames=4, qpf_calls=1, origin=origin, frequency=frequency,
                              configured_service=dict(canonical_runtime_bank=True, live_allocations=1)),
                trace=trace, retired_runtime=dict(engine_allocations=0, active_workers=0, handles=0,
                                                 critical_sections=1, scope_critical_section_reference=0x2d6ed58,
                                                 critical_section_report_owners=3, errors=[]),
                shared_drop=dict(app_dropped=True, clock_handle_dropped=True,
                                 critical_section_report_owners=1, critical_section_failures=[],
                                 bank_and_sections_retired=True, direct_os_deletion_count_observed=False),
                closed=dict(process_clock=final, application=application(),
                            raw_handle_rejection='process clock runtime is shut down',
                            f32_handle_rejection='process clock runtime is shut down', rejected_calls_preserved_clock_snapshot=True))


def main():
    legacy = v._legacy(v.ROOT, v.ROOT / 'logs/client-process-clock-command-run.json')
    good = synthetic_clock()
    summary = v.verify_clock(good, legacy['completed_application'])
    assert summary['qpc_calls'] == 33
    assert summary['scope_critical_section_reference'] == 0x2d6ed58
    assert summary['scope_critical_sections_before_drop'] == 1
    assert summary['critical_section_report_owners_before_drop'] == 3
    assert summary['critical_section_report_owners_after_drop'] == 1
    assert summary['bank_and_sections_retired'] is True
    assert summary['direct_os_deletion_count_observed'] is False
    mutations = [
        ('qpf', lambda r: r['trace'][-1]['process_clock'].update(qpf_calls=2)),
        ('qpc', lambda r: r['trace'][-1]['process_clock'].update(qpc_calls=32)),
        ('origin', lambda r: r['trace'][4]['raw'].update(origin=4)),
        ('frequency', lambda r: r['trace'][4]['raw'].update(frequency=0)),
        ('wall_bits', lambda r: r['trace'][4]['raw'].update(wall_f32_bits=0)),
        ('paused_time', lambda r: r['trace'][4]['effects']['clock'].update(time=0.5, time_bits=bits(0.5))),
        ('animation_delta', lambda r: r['trace'][4]['effects'].update(animation_delta_bits=bits(0.1))),
        ('pause_frame_order', lambda r: r['trace'][4].update(frame=0)),
        ('frames_count', lambda r: r['exercise'].update(frame_updates=6)),
        ('raw_stopped', lambda r: r['trace'][4]['raw'].update(counter=r['trace'][3]['raw']['counter'])),
        ('effect_failed', lambda r: r['trace'][3]['effects']['clock'].update(failed=True)),
        ('still_paused', lambda r: r['trace'][-1]['effects']['clock'].update(paused=True)),
        ('cleanup_leak', lambda r: r['closed']['process_clock'].update(crt_allocations=1)),
        ('pending_mirror', lambda r: r['closed']['process_clock'].update(pending_mirrors=1)),
        ('crt_leak', lambda r: r['closed']['application']['crt'].update(heap_blocks=1)),
        ('event_leak', lambda r: r['closed']['process_clock'].update(events_created=1)),
        ('closed_counter_changed', lambda r: r['closed']['process_clock'].update(qpc_calls=34)),
        ('closed_accepted', lambda r: r['closed'].update(raw_handle_rejection='')),
        ('second_application', lambda r: r.update(application_instances=2)),
        ('false_loading_claim', lambda r: r['scope'].update(loading_packet_dispatched=True)),
        ('false_completion', lambda r: r.update(complete=True)),
        ('early_zero_sections', lambda r: r['retired_runtime'].update(critical_sections=0)),
        ('extra_retained_section', lambda r: r['retired_runtime'].update(critical_sections=2)),
        ('wrong_scope_reference', lambda r: r['retired_runtime'].update(scope_critical_section_reference=0x2d6ed50)),
        ('wrong_report_owners_before_drop', lambda r: r['retired_runtime'].update(critical_section_report_owners=2)),
        ('boolean_retired_count', lambda r: r['retired_runtime'].update(critical_sections=True)),
        ('float_retired_count', lambda r: r['retired_runtime'].update(critical_sections=1.0)),
        ('missing_scope_reference', lambda r: r['retired_runtime'].pop('scope_critical_section_reference')),
        ('extra_retirement_field', lambda r: r['retired_runtime'].update(unqualified=True)),
        ('missing_shared_drop', lambda r: r.pop('shared_drop')),
        ('missing_shared_drop_field', lambda r: r['shared_drop'].pop('clock_handle_dropped')),
        ('app_not_dropped', lambda r: r['shared_drop'].update(app_dropped=False)),
        ('clock_handle_not_dropped', lambda r: r['shared_drop'].update(clock_handle_dropped=False)),
        ('owners_survive_shared_drop', lambda r: r['shared_drop'].update(critical_section_report_owners=2)),
        ('boolean_shared_owner_count', lambda r: r['shared_drop'].update(critical_section_report_owners=True)),
        ('float_shared_owner_count', lambda r: r['shared_drop'].update(critical_section_report_owners=1.0)),
        ('section_drop_failure', lambda r: r['shared_drop'].update(critical_section_failures=['OwnedAtDrop'])),
        ('bank_sections_not_retired', lambda r: r['shared_drop'].update(bank_and_sections_retired=False)),
        ('numeric_bank_sections_claim', lambda r: r['shared_drop'].update(bank_and_sections_retired=1)),
        ('false_direct_os_deletion_claim', lambda r: r['shared_drop'].update(direct_os_deletion_count_observed=True)),
        ('numeric_direct_os_deletion_limit', lambda r: r['shared_drop'].update(direct_os_deletion_count_observed=0)),
        ('extra_shared_drop_field', lambda r: r['shared_drop'].update(unqualified=True)),
    ]
    rejected = []
    for name, mutate in mutations:
        row = copy.deepcopy(good)
        mutate(row)
        try:
            v.verify_clock(row, legacy['completed_application'])
        except (AssertionError, ValueError, KeyError):
            rejected.append(name)
        else:
            raise AssertionError(f'bad clock report accepted: {name}')
    # Read archived real oracle output, but do not execute native code or client.
    oracle_path = Path('E:/mapslol3v3/loading_clock_port_agent/native_clock_results.json')
    oracle = json.loads(oracle_path.read_text())
    assert oracle['passed'] is True and oracle['native_sha256'] == v.NATIVE_SHA
    compared, frequency_zero_skipped = 0, 0
    for case in oracle['cases']:
        for sample in case['samples']:
            if sample['bits'] is None:
                continue
            events = case['events'][sample['events_start']:sample['events_end']]
            reads = {e['address']: e['value'] for e in events if e['op'] == 'read'}
            origin = reads[0x14bef48] | (reads[0x14bef4c] << 32)
            frequency = reads[0x14bef50] | (reads[0x14bef54] << 32)
            counter = int.from_bytes(bytes.fromhex([e['output_hex'] for e in events if e['op'] == 'qpc'][-1]), 'little')
            if frequency == 0:
                frequency_zero_skipped += 1
                continue
            actual = v.native_ratio_bits((counter-origin) & ((1 << 64)-1), frequency)
            assert actual == sample['bits'], (case['label'], actual, sample['bits'])
            compared += 1
    # The archived events report is schema-regression input only, never current evidence.
    event_path = v.ROOT / 'logs/client-loading-events.json'
    events = v.load(event_path)
    assert v.verify_events(events)['notifications'] == 4100
    event_rejections = []
    for key, bad in [('notifications', 4099), ('metadata_references', 2), ('network_decoder_connected', True)]:
        row = copy.deepcopy(events)
        row['consumers'][key] = bad
        try:
            v.verify_events(row)
        except AssertionError:
            event_rejections.append(key)
        else:
            raise AssertionError(f'bad events report accepted: {key}')
    report = dict(verifier_logic_selftest=True, passed=True, complete=False, current_client_qualified=False,
                  client_executed=False, compiler_executed=False, verify_full_commands_executed=False,
                  synthetic_clock_reports_accepted=1, corrupted_clock_reports_rejected=rejected,
                  corrupted_archived_event_reports_rejected=event_rejections,
                  archived_native_finite_samples_compared=compared, archived_zero_frequency_samples_excluded=frequency_zero_skipped,
                  oracle_path=str(oracle_path), oracle_sha256=v.sha(oracle_path),
                  archived_event_input=str(event_path), archived_event_sha256=v.sha(event_path),
                  verifier_sha256=v.sha(STAGE/'verify_client_commands.py'), selftest_sha256=v.sha(Path(__file__)))
    (STAGE/'verify_client_commands_selftest.json').write_text(json.dumps(report,indent=2)+'\n', encoding='utf-8')
    print(json.dumps(report,indent=2))


if __name__ == '__main__':
    main()
