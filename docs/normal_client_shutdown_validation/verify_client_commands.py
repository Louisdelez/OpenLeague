"""Read-only verifier for the eleven completed normal-client shutdown regression commands.

Import and call verify() only after root's final build and runner finish. This
file never builds, launches a client, installs sources, or writes a receipt.
The nine old commands retain the recorder's verification predicates against an
in-memory commands[2:] view. Only its two command-log path assignments are
redirected to this stage; actual disk-output checks remain under ROOT/logs.
No old executable hash is hard-coded.
"""
from pathlib import Path
import ast
import hashlib
import json
import math
import struct

ROOT = Path('E:/OpenLeague')
PREFIX = 'client-shutdown-'
LOG_DIR = Path(__file__).resolve().parent
SOURCE_VERIFIER_SHA = '7701fcf6cec4fd862b5579f54f2f0018a2a8208672308abbd43bf0ec8b35966b'
NATIVE_SHA = '402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
LEGACY_SHA = '7f2502bb1739b712acce43d77e72c7f990d9efb7abe7a112315cf5273b4c8810'
LEGACY_COMMANDS = [
    ('probe', '--native-replay-game-manager-probe'),
    ('stream-regression', '--native-replay-recording-stream-probe'),
    ('file-regression', '--native-replay-recording-file-probe'),
    ('running-regression', '--native-replay-stream-running-probe'),
    ('opening-regression', '--native-replay-stream-opening-probe'),
    ('transport-regression', '--native-replay-stream-transport-probe'),
    ('base-regression', '--native-replay-configuration-probe'),
    ('runtime-regression', '--native-replay-runtime-probe'),
    ('service-regression', '--native-replay-service-probe'),
]
COMMANDS = [('clock', '--native-process-clock-probe'), ('events', '--native-replay-events-probe'), *LEGACY_COMMANDS]


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def sha(path):
    with Path(path).open('rb') as source:
        return hashlib.file_digest(source, 'sha256').hexdigest()


def _pairs(items):
    value = {}
    for key, item in items:
        require(key not in value, f'duplicate JSON key: {key}')
        value[key] = item
    return value


def load(path):
    def invalid(token):
        raise ValueError(f'non-finite JSON token: {token}')
    return json.loads(Path(path).read_text(encoding='utf-8-sig'),
                      object_pairs_hook=_pairs, parse_constant=invalid)


def integer(value, bits=64):
    require(type(value) is int and 0 <= value < (1 << bits), f'invalid u{bits}: {value!r}')
    return value


def f32(bits):
    value = struct.unpack('<f', struct.pack('<I', integer(bits, 32)))[0]
    require(math.isfinite(value), f'non-finite f32: {bits}')
    return value


def _round_ratio(n, d):
    quotient, remainder = divmod(n, d)
    return quotient + int(2 * remainder > d or (2 * remainder == d and quotient & 1))


def native_ratio_bits(elapsed, frequency):
    """Exact unsigned ratio: x87 PC64 round-to-nearest, then f32 storage.

    All positive ratios of two u64 values are normal f32 values. Integer-only
    rounding avoids substituting the host Python binary64 division for x87.
    """
    integer(elapsed)
    require(integer(frequency) > 0, 'zero frequency')
    if elapsed == 0:
        return 0
    exponent = elapsed.bit_length() - frequency.bit_length()
    if (elapsed < frequency << exponent) if exponent >= 0 else (elapsed << -exponent < frequency):
        exponent -= 1
    shift = 63 - exponent
    extended = _round_ratio(elapsed << shift, frequency) if shift >= 0 else _round_ratio(elapsed, frequency << -shift)
    if extended == 1 << 64:
        extended >>= 1
        exponent += 1
    rounded = _round_ratio(extended, 1 << 40)
    if rounded == 1 << 24:
        rounded >>= 1
        exponent += 1
    require(-126 <= exponent <= 127, 'ratio outside normal finite f32 range')
    return ((exponent + 127) << 23) | (rounded - (1 << 23))


def _legacy(root, command_path, log_dir):
    """Load only pure read-only definitions; never execute recorder main()."""
    path = root / 'tools/record_replay_game_manager.py'
    require(sha(path) == LEGACY_SHA, 'legacy recorder changed; review adaptation before qualification')
    tree = ast.parse(path.read_text(encoding='utf-8-sig'), filename=str(path))
    functions = {'sha', 'load', 'completed_application', 'parent_callbacks', 'checked_disk_output', 'verify_client'}
    selected = [node for node in tree.body if isinstance(node, ast.FunctionDef) and node.name in functions]
    require({node.name for node in selected} == functions and len(selected) == len(functions), 'legacy definitions missing/duplicated')
    listed = [node.value for node in tree.body if isinstance(node, ast.Assign)
              and any(isinstance(target, ast.Name) and target.id == 'COMMANDS' for target in node.targets)]
    require(len(listed) == 1 and ast.literal_eval(listed[0]) == LEGACY_COMMANDS, 'legacy command list changed')
    # Narrow AST adaptation: change exactly the two log-location assignments,
    # never ROOT itself or checked_disk_output/native file ownership checks.
    verifier = next(node for node in selected if node.name == 'verify_client')
    routing = ast.dump(ast.parse("ROOT / 'logs'", mode='eval').body)
    adapted = []
    for node in ast.walk(verifier):
        if (isinstance(node, ast.Assign) and len(node.targets) == 1
                and isinstance(node.targets[0], ast.Name)
                and node.targets[0].id in {'command_path', 'path'}
                and isinstance(node.value, ast.BinOp) and isinstance(node.value.op, ast.Div)):
            require(isinstance(node.value, ast.BinOp) and isinstance(node.value.op, ast.Div)
                    and ast.dump(node.value.left) == routing, 'legacy path expression changed')
            node.value.left = ast.copy_location(ast.Name(id='LOG_DIR', ctx=ast.Load()), node.value.left)
            adapted.append(node.targets[0].id)
    require(sorted(adapted) == ['command_path', 'path'], 'legacy log adaptation count changed')
    namespace = {'Path': Path, 'hashlib': hashlib, 'json': json,
                 'ROOT': root, 'LOG_DIR': log_dir, 'PREFIX': PREFIX, 'COMMANDS': LEGACY_COMMANDS}
    exec(compile(ast.Module(body=selected, type_ignores=[]), str(path), 'exec'), namespace)
    def command_view(path):
        value = load(path)
        if Path(path).resolve() == command_path.resolve():
            value = dict(value, commands=value['commands'][2:])
        return value
    namespace['load'] = command_view
    return namespace


def verify_events(report):
    require(report['passed'] is True and report['complete'] is False, 'events outcome/limit')
    require(report['retired'] == {'allocations': 0, 'workers': 0, 'handles': 0, 'errors': []}, 'events cleanup')
    consumers = report['consumers']
    for key in ['passed', 'scratch_bounded', 'decoded_event_ingress']:
        require(consumers[key] is True, f'events {key}')
    for key in ['complete', 'network_decoder_connected']:
        require(consumers[key] is False, f'events unsupported claim {key}')
    expected = {'notifications': 4100, 'array_frames': 1, 'text_frames': 2,
                'six_argument_callbacks': 1, 'counts': [2, 1, 41, 43],
                'samples': [17, 19, 23, 29, 31, 37], 'metadata_references': 1,
                'texts': ['restored-native-replay-metadata'] * 2,
                'states': {'0': 2, '7': 2, '4294967295': 2}}
    for key, value in expected.items():
        require(consumers[key] == value, f'events {key}')
    require(consumers['service_packets'] == {
        'passed': True, 'parent_callback_connected': True, 'filtered_or_dd_packets': 12,
        'truncated_packets_rejected': 5, 'filtered_context_unchanged': True,
        'packet95_empty_receiver_packets': 4, 'gameplay_actions': 0,
        'network_decoder_connected': False, 'complete': False,
    }, 'service packet consumer qualification changed')
    return {'notifications': 4100, 'array_frames': 1, 'text_frames': 2,
            'active_workers_after_close': 0, 'workers_created_reported': False}


def _snapshot(value):
    for key in ['origin', 'frequency', 'qpf_calls', 'qpc_calls', 'crt_allocations', 'pending_mirrors',
                'inner_mutexes', 'events_created', 'events_closed', 'event_close_failures']:
        integer(value[key])
    require(type(value['initialized']) is bool, 'snapshot initialized type')
    require(value['failure'] is None and value['event_close_failures'] == 0, 'clock failure/close failure')
    require(value['events_created'] == value['events_closed'], 'unclosed clock event')
    require(type(value['registered_cleanups']) is list, 'clock cleanups type')


def verify_clock(report, completed_application):
    require(report['probe'] == 'native-process-clock' and report['passed'] is True and report['complete'] is False,
            'clock outcome/limit')
    require(report['normal_application_attachment'] is True and report['application_instances'] == 1,
            'clock must use exactly one normal application')
    require(report['exercise_error'] is None and report['cleanup_errors'] == [], 'clock exercise/cleanup errors')
    require(report['service_allocations_after_close'] == 0, 'clock service allocation leak')
    require(report['scope'] == {
        'canonical_windows_clock': True, 'effect_plugin_frames': True,
        'pause_resume_delivery': 'local ordered adapter', 'loading_packet_dispatched': False,
        'network_packet_delivery': False, 'ui_rendered': False, 'animation_clips_played': False,
        'gameplay_complete': False, 'fifo_contention_exercised': False,
    }, 'clock unsupported scope claims')
    configuration = report['configuration']
    require(configuration['default_loaded'] is True and type(configuration['user_loaded']) is bool,
            'normal Game.cfg source missing')
    require(isinstance(configuration['default_path'], str) and configuration['default_path']
            and isinstance(configuration['user_path'], str) and configuration['user_path'], 'Game.cfg paths missing')
    integer(configuration['parse_warnings'])
    integer(configuration['layout_mode'], 32)
    exercise = report['exercise']
    require(exercise['frame_updates'] == 7 and exercise['paused_frames'] == 4 and exercise['qpf_calls'] == 1,
            'clock frame/QPF counts')
    require(exercise['configured_service']['canonical_runtime_bank'] is True
            and exercise['configured_service']['live_allocations'] > 0, 'canonical service missing')
    origin, frequency = integer(exercise['origin']), integer(exercise['frequency'])
    require(frequency > 0, 'clock frequency is zero')
    trace = report['trace']
    require([row['phase'] for row in trace] == ['attached', 'first_effect_frame', 'running', *['paused'] * 4, 'resumed'],
            'clock frame sequence differs')
    attached = trace[0]['process_clock']
    _snapshot(attached)
    require(attached['initialized'] is False and attached['qpf_calls'] == attached['qpc_calls'] == 0,
            'clock was initialized before first consumer')
    require(all(attached[key] == 0 for key in ['crt_allocations', 'pending_mirrors', 'inner_mutexes', 'events_created', 'events_closed'])
            and attached['registered_cleanups'] == [], 'clock owned objects before first consumer')
    previous_counter, held_time_bits, resumed_time = None, None, None
    for index, row in enumerate(trace[1:]):
        raw, effects = row['raw'], row['effects']
        require((integer(raw['origin']), integer(raw['frequency'])) == (origin, frequency), 'clock identity changed')
        counter = integer(raw['counter'])
        require(counter >= origin and (previous_counter is None or counter > previous_counter), 'raw clock did not advance')
        previous_counter = counter
        require(raw['wall_f32_bits'] == native_ratio_bits((counter - origin) & ((1 << 64) - 1), frequency),
                'raw wall f32 bits differ from PC64 native arithmetic')
        clock = effects['clock']
        require(clock['failed'] is False and clock['resume_pending'] is False, 'effect frame failure/resume pending')
        require(type(clock['time']) in (int, float) and math.isfinite(clock['time']), 'effect time invalid')
        require(clock['time'] == f32(clock['time_bits']), 'effect time differs from its native bits')
        require(effects['animation_delta_bits'] == clock['delta_bits'], 'published animation delta differs')
        delta = f32(clock['delta_bits'])
        require(math.isfinite(clock['remaining']), 'pause budget non-finite')
        if index == 0:
            require(clock['paused'] is False and clock['ordinal'] == 0 and clock['time'] == 0 and delta == 0,
                    'first effect frame advanced before its frame origin')
        elif index == 1:
            require(clock['paused'] is False and clock['ordinal'] == 0 and clock['time'] > 0 and delta > 0,
                    'running effect frame did not advance')
            held_time_bits = clock['time_bits']
        elif index < 6:
            require(row['frame'] == index - 2 and clock['paused'] is True and clock['ordinal'] == 1
                    and clock['time_bits'] == held_time_bits and delta == 0,
                    'paused effects/animation advanced or ordinal changed')
        else:
            require(clock['paused'] is False and clock['ordinal'] == 2
                    and clock['time'] > f32(held_time_bits) and delta > 0, 'effects failed to resume')
            resumed_time = clock['time']
    live = trace[-1]['process_clock']
    _snapshot(live)
    require(live['initialized'] is True and (live['origin'], live['frequency']) == (origin, frequency), 'live identity')
    # One initialization QPC; 7 explicit raw calls; 19 First samples; pause3,
    # resume2, and one public f32 API sample = 33 real QPC calls, QPF once.
    require((live['qpf_calls'], live['qpc_calls']) == (1, 33), 'unexpected QPF/QPC count for seven frames')
    require((live['crt_allocations'], live['pending_mirrors'], live['inner_mutexes']) == (1, 0, 1), 'live clock owners')
    require(live['registered_cleanups'] == [0xce52c1, 0xce2955], 'clock cleanup order')
    require(f32(trace[-1]['wall_clock_api_f32_bits']) >= f32(trace[-1]['raw']['wall_f32_bits']) > 0,
            'public f32 clock went backward or stopped')
    retired = report['retired_runtime']
    expected_retired = {'engine_allocations': 0, 'active_workers': 0, 'handles': 0,
                       'critical_sections': 1, 'scope_critical_section_reference': 0x2d6ed58,
                       'critical_section_report_owners': 3, 'errors': []}
    require(type(retired) is dict and set(retired) == set(expected_retired), 'runtime retirement schema differs')
    for key in expected_retired.keys() - {'errors'}:
        integer(retired[key])
    require(retired == expected_retired, 'runtime retirement differs from one Shared-scope section')
    closed = report['closed']
    final = closed['process_clock']
    _snapshot(final)
    expected_final = dict(live, crt_allocations=0, pending_mirrors=0, inner_mutexes=0, registered_cleanups=[])
    require(final == expected_final, 'shutdown changed clock identity/counters or retained ownership')
    require(closed['raw_handle_rejection'] == closed['f32_handle_rejection'] == 'process clock runtime is shut down',
            'closed handle refusal missing')
    require(closed['rejected_calls_preserved_clock_snapshot'] is True, 'closed handle mutated clock state')
    application = closed['application']
    require(application['native_source_sha256'] == NATIVE_SHA, 'clock application source mismatch')
    workers = completed_application(application)
    require(workers == 0, 'headless clock unexpectedly started a worker')
    shared_drop = report['shared_drop']
    expected_shared_drop = {'app_dropped': True, 'clock_handle_dropped': True,
                            'critical_section_report_owners': 1, 'critical_section_failures': [],
                            'bank_and_sections_retired': True, 'direct_os_deletion_count_observed': False}
    require(type(shared_drop) is dict and set(shared_drop) == set(expected_shared_drop), 'Shared drop schema differs')
    for key in ['app_dropped', 'clock_handle_dropped', 'bank_and_sections_retired']:
        require(shared_drop[key] is True, f'Shared drop did not confirm {key}')
    require(shared_drop['direct_os_deletion_count_observed'] is False, 'unsupported direct OS deletion claim')
    require(integer(shared_drop['critical_section_report_owners']) == 1, 'Bank/Section report ownership remains after drop')
    require(shared_drop['critical_section_failures'] == [], 'critical-section failure after final drop')
    return {'frame_updates': 7, 'paused_frames': 4, 'qpf_calls': 1, 'qpc_calls': 33,
            'origin': origin, 'frequency': frequency, 'workers': workers,
            'events_created': live['events_created'], 'events_closed': final['events_closed'],
            'effect_time_after_resume': resumed_time, 'closed_handle_refused_without_mutation': True,
            'scope_critical_section_reference': retired['scope_critical_section_reference'],
            'scope_critical_sections_before_drop': retired['critical_sections'],
            'critical_section_report_owners_before_drop': retired['critical_section_report_owners'],
            'critical_section_report_owners_after_drop': shared_drop['critical_section_report_owners'],
            'bank_and_sections_retired': True, 'direct_os_deletion_count_observed': False}


def _claims(value):
    if isinstance(value, dict):
        for key, item in value.items():
            if key in {'complete', 'gameplay_complete', 'full_game_complete', 'whole_game_complete'}:
                require(item is False, f'unsupported completion claim: {key}')
            if key == 'native_source_sha256':
                require(item == NATIVE_SHA, 'application native source mismatch')
            _claims(item)
    elif isinstance(value, list):
        for item in value:
            _claims(item)


def verify(root=ROOT, expected_executable_sha256=None, log_dir=LOG_DIR):
    """Return a receipt only for new-prefix logs matching the current final PE.

    Optional expected_executable_sha256 lets the caller pin its independent
    build receipt. No client is executed and no file is written by this call.
    """
    require(__debug__, 'Python -O is forbidden: legacy verifier uses assertions')
    root = Path(root).resolve()
    log_dir = Path(log_dir).resolve()
    require(log_dir == LOG_DIR.resolve(), 'shutdown log directory differs from this stage')
    executable = root / 'target/debug/openleague-client.exe'
    digest = sha(executable)
    if expected_executable_sha256 is not None:
        require(digest == expected_executable_sha256.lower(), 'client differs from caller build receipt')
    command_path = log_dir / (PREFIX + 'command-run.json')
    command_digest = sha(command_path)
    commands = load(command_path)
    require(commands['sha256'] == digest and len(commands['commands']) == len(COMMANDS) == 11, 'runner count/current PE SHA mismatch')
    require(Path(commands['executable']).resolve() == executable.resolve(), 'runner executable path mismatch')
    reports, logs = {}, {command_path: command_digest}
    for (name, flag), command in zip(COMMANDS, commands['commands']):
        output = log_dir / (PREFIX + name + '.json')
        stderr = output.with_suffix('.stderr.log')
        require(command['command'] == flag and type(command['exit_code']) is int and command['exit_code'] == 0
                and command['sha256'] == digest, f'{name}: wrong flag, failure or executable SHA')
        for key, path in [('root', root), ('output', output), ('stderr', stderr)]:
            require(Path(command[key]).resolve() == path.resolve(), f'{name}: unexpected {key}')
        logs[output], logs[stderr] = sha(output), sha(stderr)
        require(not stderr.read_text(encoding='utf-8-sig').strip(), f'{name}: nonempty stderr')
        reports[name] = load(output)
        _claims(reports[name])
    legacy = _legacy(root, command_path, log_dir)
    legacy_reports, legacy_paths, old_workers, disk, legacy_digest = legacy['verify_client'](16)
    require(legacy_digest == digest and old_workers == 16, 'legacy executable/workers mismatch')
    require(all(legacy_reports[name] == reports[name] for name, _ in LEGACY_COMMANDS), 'legacy report changed during verification')
    require(set(legacy_paths) == {command_path, *[log_dir / (PREFIX + name + suffix)
                                                for name, _ in LEGACY_COMMANDS for suffix in ['.json', '.stderr.log']]},
            'legacy verifier read unexpected logs')
    event_summary = verify_events(reports['events'])
    clock_summary = verify_clock(reports['clock'], legacy['completed_application'])
    canonical = reports['probe']['profiles'][0]['configured_service']
    for key in ['float_bits', 'DisableCatchup', 'UseLookAhead', 'history_mode', 'PingTimeForReconnectMessage']:
        require(reports['clock']['exercise']['configured_service'][key] == canonical[key], f'clock Game.cfg drift: {key}')
    require(sha(executable) == digest and all(sha(path) == expected for path, expected in logs.items()),
            'executable/logs changed during verification')
    return {
        'passed': True, 'complete': False, 'commands': 11, 'workers': old_workers + clock_summary['workers'],
        'workers_scope': 'nine legacy commands plus clock; events publishes only final active workers',
        'events_workers_created_reported': False, 'executable_sha256': digest,
        'executable': str(executable), 'command_flags': [flag for _, flag in COMMANDS],
        'logs': {str(path): value for path, value in logs.items()},
        'command_report': str(command_path), 'log_directory': str(log_dir),
        'disk_outputs': disk, 'clock_summary': clock_summary, 'events_summary': event_summary,
        'clock_report': reports['clock'], 'event_report': reports['events'],
        'legacy_verifier': {'path': 'tools/record_replay_game_manager.py', 'sha256': LEGACY_SHA,
                            'prefix': PREFIX, 'command_slice_start': 2, 'body_modified': True,
                            'verification_predicates_modified': False,
                            'path_assignments_adapted': ['command_path', 'path'],
                            'actual_disk_output_root_unchanged': str(root / 'logs')},
        'source_verifier_sha256': SOURCE_VERIFIER_SHA,
        'verifier_sha256': sha(Path(__file__)), 'build_and_test_receipts_verified_here': False,
    }


if __name__ == '__main__':
    print(json.dumps(verify(), ensure_ascii=False, indent=2))
