"""Verify completed qualification, then save its receipt and plan evidence.

Run only after the final core/client tests, build and all nine commands finish.
This script neither runs tests nor launches probes. Counts are explicit inputs.
"""
from pathlib import Path
import argparse
import datetime
import hashlib
import json
import re
import shutil
import struct

import pefile

ROOT = Path('E:/OpenLeague')
NATIVE_SHA = '402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
IMAGE_SHA = '4f5ec7ba0ca814df2eb06a3c3f8dd88777e2e78b550459a0a6dbdf1f5ede7cb8'
KEY = 'replay_game_manager_validation'
RECEIPT = 'docs/' + KEY + '.json'
PREFIX = 'client-replay-game-manager-'
COMMANDS = [
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


def load(path):
    return json.loads(path.read_text(encoding='utf-8-sig'))


def sha(path):
    with path.open('rb') as source:
        return hashlib.file_digest(source, 'sha256').hexdigest()


def write_json(path, value):
    temporary = path.with_suffix(path.suffix + '.tmp')
    temporary.write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    assert load(temporary) == value
    temporary.replace(path)


def test_result(path, expected):
    text = path.read_text(encoding='utf-8-sig')
    matches = re.findall(
        r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored; (\d+) measured; (\d+) filtered out', text)
    rows = [tuple(map(int, row)) for row in matches]
    selected = [row for row in rows if row[0] == expected]
    assert expected > 0 and len(selected) == 1, (path, expected, rows)
    result = selected[0]
    assert result[1:4] == (0, 0, 0), (path, result)
    assert 'test result: FAILED' not in text
    matches = re.findall(r'Running unittests .*?\(([^)]+\.exe)\)', text)
    assert len(matches) == 1, (path, matches)
    executable = ROOT / matches[0].replace('\\', '/')
    assert executable.is_file(), executable
    return text, {'passed': result[0], 'filtered': result[4],
                  'executable': str(executable), 'sha256': sha(executable)}


def completed_application(value):
    assert value['closed'] and value['transport'] is None
    assert value['worker_failures'] == [] and value['handle_failures'] == 0
    assert value['workers_created'] == value['workers_closed'] == value['worker_completions']
    crt = value['crt']
    assert crt['heap_allocations'] == crt['heap_frees']
    for key in ['heap_blocks', 'retained_mirrors', 'critical_sections', 'heap_failures', 'lock_failures']:
        assert crt[key] == 0, (key, crt[key])
    return value['workers_created']


def parent_callbacks(snapshot, configured):
    owner = configured['pointer']
    assert configured['canonical_runtime_bank'] is True and configured['live_allocations'] > 0
    assert snapshot['service_callbacks'] == [[0x109b2d4, owner, 0x738a3a, 0], [0x10afcfc, owner, 0x72b950, 0]]
    assert snapshot['stream'] != 0 and all(snapshot['metadata'])
    assert snapshot['metadata_references'] == 1


def checked_disk_output(path, content, required):
    path = Path(path)
    assert path.resolve().is_relative_to((ROOT / 'logs').resolve()), path
    data = path.read_bytes()
    assert data.decode('utf-8') == content
    assert data.count(b'LogOut_File: : logfile started\r\n') == 1
    assert data.endswith(b'LogOut_File: : logfile stopped\r\n')
    assert b'old bytes' not in data
    for item in required:
        assert item in data, item
    return {'path': str(path), 'sha256': sha(path), 'bytes': len(data), 'lines': data.count(b'\r\n')}


def verify_client(expected_workers):
    executable = ROOT / 'target/debug/openleague-client.exe'
    digest = sha(executable)
    command_path = ROOT / 'logs' / (PREFIX + 'command-run.json')
    commands = load(command_path)
    assert len(commands['commands']) == 9 and commands['sha256'] == digest
    reports, paths = {}, []
    for (name, flag), command in zip(COMMANDS, commands['commands']):
        path = ROOT / 'logs' / (PREFIX + name + '.json')
        stderr = path.with_suffix('.stderr.log')
        assert command['command'] == flag and command['exit_code'] == 0 and command['sha256'] == digest
        assert Path(command['root']).resolve() == ROOT.resolve()
        assert Path(command['output']).resolve() == path.resolve()
        assert Path(command['stderr']).resolve() == stderr.resolve()
        assert not stderr.read_text(encoding='utf-8-sig').strip(), stderr
        reports[name] = load(path)
        paths.extend([path, stderr])
    paths.append(command_path)
    probe = reports['probe']
    for key in ['normal_application_attachment', 'canonical_configured_service',
                'native_service_manager_initialization', 'active_host_rejected_before_mutation', 'diagnostic_text_file']:
        assert probe[key] is True, key
    for key in ['active_network_host', 'replay_frame_serialization', 'simulation_frame_delivery', 'gameplay_complete']:
        assert probe[key] is False, key
    assert probe['source_noop_diagnostic_workers'] == 4 and probe['normal_null_host_return_code'] == 2
    assert len(probe['profiles']) == 7
    workers, disk, kinds, file_profiles = 0, [], [], []
    for row in probe['profiles']:
        kind = row['kind']
        kinds.append(kind)
        configured = row['configured_service']
        assert configured['canonical_runtime_bank'] is True
        retired = row['closed']['retired_runtime']
        for key in ['engine_allocations', 'active_workers', 'handles']:
            assert retired[key] == 0, (kind, key)
        assert retired['errors'] == []
        count = completed_application(row['closed']['application'])
        workers += count
        if kind == 'source_noop_diagnostic':
            profile, report = row['profile'], row['report']
            file_profiles.append(profile)
            enabled = profile == 1
            assert count == 1 and report['source_noop_diagnostic'] is True
            assert report['service_pointer'] == configured['pointer']
            assert [report['started']['state'], report['started']['code'], report['stopped']['state']] == [4, 0, 3]
            parent_callbacks(report['started'], configured)
            parent_callbacks(report['stopped'], configured)
            assert report['resource_enabled'] == int(enabled)
            files = report['files']
            assert files['opened'] == files['closed'] == (2 if enabled else 0)
            assert files['remaining'] == 0 and files['writes'] == (4 if enabled else 0)
            if enabled:
                output = checked_disk_output(row['requested_path'], row['content'], [
                    b'OpenLeague parent diagnostic %n %s\r\n',
                    b'Source service callbacks and canonical manager lifetime\r\n'])
                assert output['lines'] == files['writes'] == 4
                output['probe'] = 'game-manager'
                disk.append(output)
            else:
                assert row['content'] is None
                if profile == 0:
                    assert row['requested_path'] is None
                elif profile == 2:
                    path = Path(row['requested_path'])
                    assert path.resolve().is_relative_to((ROOT / 'logs').resolve())
                    assert not path.exists() and not path.parent.exists()
                elif profile == 3:
                    assert row['requested_path'] == ''
                else:
                    raise AssertionError(('unknown file profile', profile))
        else:
            assert count == (1 if kind == 'normal_null_host' else 0)
            outcome = row['outcome']
            if kind == 'reject_active_host':
                assert outcome['rejected'] is True and 'not connected' in outcome['error']
                assert row['before'] == row['after']
                assert row['after']['transport']['game_manager'] is None
            else:
                snapshot = outcome['snapshot']
                parent_callbacks(snapshot, configured)
                assert snapshot['state'] == 1
                if kind == 'initialize_only':
                    assert snapshot['code'] is None
                else:
                    assert kind == 'normal_null_host'
                    assert outcome['return_code'] == snapshot['code'] == 2
    assert sorted(file_profiles) == [0, 1, 2, 3]
    assert sorted(kinds) == sorted(['source_noop_diagnostic'] * 4 + ['initialize_only', 'normal_null_host', 'reject_active_host'])
    assert workers == 5
    # The seven existing runtime commands keep their original closure schema.
    for name, _ in COMMANDS[1:-1]:
        report = reports[name]
        assert report['normal_application_attachment'] is True
        for row in report.get('profiles', [report]):
            workers += completed_application(row['closed'])
    # Standalone service regression intentionally has no CRT application report.
    standalone = reports['service-regression']
    assert standalone['live_allocations_after_close'] == 0
    assert standalone['replay_service']['live_allocations'] > 0
    assert not standalone['replay_service'].get('canonical_runtime_bank', False)
    canonical = probe['profiles'][0]['configured_service']
    for key in ['float_bits', 'DisableCatchup', 'UseLookAhead', 'history_mode', 'PingTimeForReconnectMessage']:
        assert standalone['replay_service'][key] == canonical[key], key
    stream = reports['stream-regression']
    for key in ['source_optional_stream_preparation', 'source_noop_implementation', 'pathname_registration_singleton']:
        assert stream[key] is True
    assert len(stream['profiles']) == 3
    for row in stream['profiles']:
        if row['profile'] == 1:
            output = checked_disk_output(row['path'], row['content'], [
                b'OpenLeague stream diagnostic %n %s\r\n',
                b'Source optional preparation and worker lifetime\r\n'])
            assert output['lines'] == row['report']['writes']
            output['probe'] = 'recording-stream-regression'
            disk.append(output)
    assert workers == expected_workers == 16, workers
    return reports, paths, workers, disk, digest


def verify_fixtures():
    sizes = {
        'replay_metadata_probe.json': 24, 'replay_manager_initialization_probe.json': 2,
        'replay_game_manager_singleton_probe.json': 8, 'replay_game_manager_open_contract.json': 16,
        'replay_parent_open_lifetime_probe.json': 16,
        'replay_service_manager_native_probe.json': 72, 'replay_service_manager_contract.json': 72,
    }
    fixtures = {}
    for name, count in sizes.items():
        data = load(ROOT / 'data/4.20' / name)
        assert data['passed'] is True and data['native_sha256'] == NATIVE_SHA
        assert len(data['cases']) == count
        fixtures[name] = data
    for name in ['replay_game_manager_open_contract.json', 'replay_parent_open_lifetime_probe.json',
                 'replay_service_manager_native_probe.json', 'replay_service_manager_contract.json']:
        assert all(not case['retired_reads'] for case in fixtures[name]['cases']), name
    assert fixtures['replay_service_manager_native_probe.json']['stream_worker_creation_supplied_failure'] is False
    assert fixtures['replay_service_manager_contract.json']['stream_worker_creation_supplied_failure'] is True
    name = 'replay_callbacks_probe.json'
    callbacks = load(ROOT / 'data/4.20' / name)
    assert callbacks['passed'] is True and callbacks['native_sha256'] == NATIVE_SHA
    counts = {'factory_cases': 216, 'null_cases': 36, 'extra_clone_cases': 12, 'replace_cases': 48, 'bundle_cases': 8}
    for key, count in counts.items():
        assert len(callbacks[key]) == count
    assert sum(counts.values()) == 320
    fixtures[name] = callbacks
    return fixtures, counts


def verify_image():
    manifest = load(ROOT / 'data/4.20/runtime/replay_runtime_image_manifest.json')
    package = (ROOT / 'data/4.20/runtime/replay_runtime_image.bin').read_bytes()
    assert manifest['native_sha256'] == NATIVE_SHA
    assert manifest['package_sha256'] == hashlib.sha256(package).hexdigest() == IMAGE_SHA
    assert len(package) == 19354 and len(manifest['regions']) == 39
    source = Path(manifest['native_source'])
    assert sha(source) == NATIVE_SHA
    pe = pefile.PE(str(source))
    mapped = pe.get_memory_mapped_image()
    image = mapped + bytes(pe.OPTIONAL_HEADER.SizeOfImage - len(mapped))
    assert package[:48] == b'OL420RT\0' + struct.pack('<II', 1, 39) + bytes.fromhex(NATIVE_SHA)
    cursor = 48
    for region in manifest['regions']:
        address, size, offset = region['address'], region['size'], region['payload_offset']
        start = address - pe.OPTIONAL_HEADER.ImageBase
        assert offset == cursor + 12 and offset + size <= len(package)
        assert struct.unpack('<III', package[cursor:offset]) == (region['group'], address, size)
        assert package[offset:offset + size] == image[start:start + size]
        assert hashlib.sha256(package[offset:offset + size]).hexdigest() == region['sha256']
        cursor = offset + size
    assert cursor == len(package)


def verify_crt_imports():
    pe = pefile.PE(str(ROOT / 'target/debug/openleague-client.exe'), fast_load=True)
    pe.parse_data_directories(directories=[1])
    imports = {}
    for descriptor in pe.DIRECTORY_ENTRY_IMPORT:
        dll = descriptor.dll.decode().lower()
        for entry in descriptor.imports:
            symbol = (entry.name or b'').decode()
            if symbol in ['fopen', 'fopen_s', 'fclose', 'fprintf']:
                imports.setdefault(symbol, []).append(dll)
                assert dll != 'msvcrt.dll', (symbol, dll)
    for symbol in ['fopen_s', 'fclose']:
        assert imports.get(symbol) in [['api-ms-win-crt-stdio-l1-1-0.dll'], ['ucrtbase.dll']], (symbol, imports)
    before = load(ROOT / 'docs/replay_game_manager_crt_fault/before_fix.json')
    assert before['executable_sha256'] != sha(ROOT / 'target/debug/openleague-client.exe')
    assert {'dll': 'msvcrt.dll', 'symbol': 'fclose', 'iat_rva': 0x50b1920} in before['imports']
    return {'passed': True, 'default_crt_imports': imports,
            'private_recording_exports': ['msvcrt.dll!fopen', 'msvcrt.dll!fprintf', 'msvcrt.dll!fclose'],
            'resolved_via': 'LoadLibraryExW System32 + GetProcAddress; one module reference retained for process lifetime',
            'failed_executable_sha256': before['executable_sha256'],
            'diagnosis': 'Game.cfg reader fopen_s UCRT was paired with globally interposed msvcrt fclose; private replay function pointers remove this collision.'}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--expected-core-tests', type=int, required=True)
    parser.add_argument('--expected-client-tests', type=int, required=True)
    parser.add_argument('--expected-client-workers', type=int, required=True)
    args = parser.parse_args()
    assert Path(__file__).resolve() == (ROOT / 'tools/record_replay_game_manager.py').resolve(), 'Install the reviewed script before recording production evidence'
    core_path = ROOT / 'logs/core-replay-game-manager-tests.log'
    client_path = ROOT / 'logs/client-replay-game-manager-tests.log'
    build_path = ROOT / 'logs/client-replay-game-manager-build.log'
    core_text, core = test_result(core_path, args.expected_core_tests)
    client_text, client = test_result(client_path, args.expected_client_tests)
    assert re.search(r'Finished `dev` profile .* target', build_path.read_text(encoding='utf-8-sig'))
    new_test_files = ['audio_replay_callbacks_tests.rs', 'audio_replay_metadata_tests.rs',
                      'audio_replay_game_manager_tests.rs', 'audio_replay_service_manager_tests.rs',
                      'audio_replay_windows_game_manager_tests.rs']
    test_names = []
    for name in new_test_files:
        source = (ROOT / 'crates/core/src' / name).read_text(encoding='utf-8')
        test_names.extend(re.findall(r'fn (audio_replay_[A-Za-z0-9_]+)\s*\(', source))
    test_names.append('audio_replay_windows_private_msvcrt_files_coexist_with_default_ucrt_fopen_s_and_fclose')
    assert len(test_names) == 18
    for name in test_names:
        assert name + ' ... ok' in core_text, name
    assert 'native_replay_service_attachment_reconstructs_settings_and_retires_standalone_ownership ... ok' in client_text
    assert 'native_filesystem_provider::tests::real_files_through_crt_provider_match_native_full_text_pipeline ... ok' in client_text
    fixtures, callback_counts = verify_fixtures()
    verify_image()
    reports, client_logs, workers, disk, client_sha = verify_client(args.expected_client_workers)
    crt_imports = verify_crt_imports()
    plan = load(ROOT / 'docs/completion_plan.json')
    scope = {'domains': len(plan['domains']), 'tasks': sum(len(d['tasks']) for d in plan['domains']),
             'additional_requirements': sum(len(d.get('additional_requirements', [])) for d in plan['domains'])}
    assert list(scope.values()) == [24, 114, 37]
    now = datetime.datetime.now(datetime.timezone.utc)
    next_action = (
        'Connect the existing audio_replay_events dispatch729370/update_metadata729D70/invoke734130 ports to Windows Boundary '
        'and actual terminal consumers. Add source wrapper5CCEB0 for12-byte callbacks without reading+12; port729B70/729C50 '
        'and the service738A3A thunk(vtable+34)->72B2D0->72B2F0, registries72EC40/72EEC0, packet588290 and72B950. '
        'Connect actual mode+122/+12F producers through member+60 routines59CFE0/59D100/59D210/59D4A0 and '
        'wrappers72C990/72C9C0/72CA10; preserve source72A780 mode derivation and literal parent port0. '
        'The configured72A3B0 service now reconstructs from parsed settings inside the canonical '
        'Windows runtime bank, and source72A800 installs its callbacks on the68-byte parent728E20/728FD0;512-byte metadata, '
        'callback bundle/factories, singleton5CF1E0/5D81B0,7297E0 open-then-start and parent teardown are ported. '
        'Source normal null-host opening creates and retires its startup transport worker before returning2/state1; '
        'active hosts are rejected before mutation. Dedicated diagnostic mode1 '
        'covers four actual Windows worker/file profiles, with parent stop/destruction followed immediately by logger retirement. '
        f'{core["passed"]} selected core tests, {client["passed"]} selected client tests and nine final-client commands pass; '
        f'the commands retire{workers} workers. Initial production image39regions19354bytes is independently compared with native PE bytes. '
        'The Game.cfg access violation caused by a global msvcrt fclose import is corrected using private exports; UCRT and legacy files are exercised together. '
        'Native evidence includes metadata24, callbacks320, parent initialization2/singleton8/open-contract16 and service72 full-native '
        'plus72 supplied-worker contracts. These checks do not implement callback invocation, game frames or network play. '
        'Continue active ENet host8FD6A0/8F7060/8F75D0/8F7920, packet pool8FCB90/8FCC80, crypto/chaining/parser/producer/consumer '
        'and actual service-to-simulation frame delivery. Preserve stop-before-destroy and immediate retirement of logger raw '
        'resource callbacks. Ten Settings-provider failure positions now roll back private construction; broader OOM/custom allocator '
        'rollback, worker failures/timeouts, repeated game sessions, crash-report activation and game-wide atexit order remain '
        'unqualified. Continue all24domains114tasks37requirements, maps/champions/gameplay/launcher and final visual/audio/network '
        'acceptance; no domain or whole-game completion is claimed.'
    )
    next_action += ' Prepared next-source research and the uncompiled12-byte wrapper proposal are archived in docs/replay_followup_sources/index.json; they are not integrated or qualified Rust behavior.'
    prepared_manifest = ROOT / 'docs/replay_followup_sources/index.json'
    prepared = load(prepared_manifest)
    assert prepared['implemented_in_production'] is False and prepared['rust_tests_run'] is False
    for name, evidence in prepared['files'].items():
        assert sha(prepared_manifest.parent / name) == evidence['sha256']
    core_sources = [
        'audio_replay_callbacks.rs', 'audio_replay_callbacks_tests.rs', 'audio_replay_metadata.rs', 'audio_replay_metadata_tests.rs',
        'audio_replay_game_manager.rs', 'audio_replay_game_manager_tests.rs', 'audio_replay_service_manager.rs', 'audio_replay_service_manager_tests.rs',
        'audio_replay_opening.rs', 'audio_replay_opening_tests.rs', 'audio_replay_stream_transport.rs', 'audio_replay_stream_transport_tests.rs',
        'audio_replay_transport_configuration.rs', 'audio_replay_transport_configuration_tests.rs',
        'audio_replay_windows_game_manager.rs', 'audio_replay_windows_game_manager_tests.rs', 'audio_replay_windows_service.rs',
        'audio_replay_windows_opening.rs', 'audio_replay_windows_configuration.rs', 'audio_replay_windows_recording.rs',
        'audio_replay_windows_transport.rs', 'audio_replay_windows_application.rs', 'audio_replay_runtime_image.rs', 'audio_replay_windows_stdio.rs',
    ]
    assert len(core_sources) == 24
    generators = ['probe_replay_callbacks.py', 'probe_replay_metadata.py', 'extract_replay_metadata_tables.py',
                  'probe_replay_manager_initialization.py', 'probe_parent_order.py', 'probe_game_manager_singleton.py',
                  'probe_game_manager_open_contract.py', 'probe_replay_service_manager.py', 'extract_replay_runtime_image.py',
                  'record_replay_game_manager.py', 'run_replay_game_manager_probes.ps1']
    sources = ['crates/core/src/' + name for name in core_sources + ['lib.rs']]
    sources += ['crates/client/src/main.rs', 'crates/client/src/native_replay_service.rs', 'docs/replay_parent_order_report.md']
    sources += ['tools/' + name for name in generators]
    sources += [str(p.relative_to(ROOT)).replace('\\','/') for p in sorted((ROOT/'docs/replay_callback_invocation').glob('*')) if p.is_file()]
    sources += [str(p.relative_to(ROOT)).replace('\\','/') for p in sorted((ROOT/'docs/replay_game_manager_crt_fault').glob('*')) if p.is_file()]
    resources = ['data/4.20/' + name for name in fixtures]
    resources += ['data/4.20/replay_metadata_tables.json', 'data/4.20/runtime/replay_runtime_image.bin',
                  'data/4.20/runtime/replay_runtime_image_manifest.json']
    logs = [core_path, client_path, build_path] + client_logs
    receipt = {
        'saved_utc': now.isoformat(), 'passed': True, 'complete': False, 'scope': scope,
        'native_source_sha256': NATIVE_SHA, 'core_tests_passed': core['passed'], 'core_tests_filtered': core['filtered'],
        'client_tests_passed': client['passed'], 'client_tests_filtered': client['filtered'], 'new_core_tests_passed': 18,
        'new_core_test_names': test_names, 'native_metadata_lifetimes': 24, 'native_callback_cases': callback_counts,
        'native_callback_lifetimes': 320, 'native_parent_initialization_lifetimes': 2, 'native_parent_singleton_lifetimes': 8,
        'native_parent_open_contract_lifetimes': 16, 'native_parent_full_worker_lifetimes': 16,
        'native_service_full_worker_lifetimes': 72, 'native_service_supplied_worker_contract_lifetimes': 72,
        'native_monitored_retired_resource_reads': 0, 'new_windows_core_tests': 5, 'new_windows_game_manager_core_tests': 4, 'new_windows_stdio_core_tests': 1,
        'new_windows_initialization_profiles': 2, 'new_windows_null_host_recording_profiles': 2,
        'new_windows_file_profiles': 4, 'new_windows_recording_workers': 4, 'new_windows_settings_failure_positions': 10,
        'client_commands': 9, 'client_parent_profiles': 7, 'client_parent_workers': 5, 'client_parent_diagnostic_workers': 4,
        'client_parent_null_host_startup_workers': 1, 'client_workers': workers,
        'production_initial_regions': 39, 'production_initial_bytes': 19354, 'production_initial_sha256': IMAGE_SHA,
        'disk_outputs': disk, 'client_executable': str(ROOT / 'target/debug/openleague-client.exe'),
        'client_executable_sha256': client_sha, 'core_test_executable': core['executable'],
        'core_test_executable_sha256': core['sha256'], 'client_test_executable': client['executable'],
        'client_test_executable_sha256': client['sha256'],
        'source_hashes': {name: sha(ROOT / name) for name in sources},
        'resource_hashes': {name: sha(ROOT / name) for name in resources},
        'log_hashes': {str(path.relative_to(ROOT)): sha(path) for path in logs},
        'client_game_manager_probe': reports['probe'],
        'windows_crt_import_isolation': crt_imports,
        'unintegrated_followup_sources': {'manifest': str(prepared_manifest.relative_to(ROOT)), 'sha256': sha(prepared_manifest), 'implemented': False, 'rust_tests_run': False},
        'qualification_commands': [
            ['cargo', 'test', '-p', 'openleague-core', 'audio_', '--', '--test-threads=1'],
            ['cargo', 'test', '-p', 'openleague-client', '--bin', 'openleague-client', '-j', '1', '--', 'native_replay', 'native_filesystem_provider', '--test-threads=1'],
            ['cargo', 'build', '-p', 'openleague-client', '--bin', 'openleague-client', '-j', '1'],
        ],
        'behavior': [
            'The final client access violation in Game.cfg reading is corrected by private msvcrt FILE exports. Default UCRT fopen_s/fclose remain paired; a regression interleaves both CRT file domains and verifies literal messages, CRLF, append and closure.',
            'Normal application attachment reconstructs the configured service in the canonical runtime bank from parsed settings and releases the previous standalone object. Parent callback owners use that same service pointer.',
            'Source72A800 initializes the parent and installs actual service callbacks. Source72A780 preserves the+122/+12F mode rule, parent port0 and open-then-start only on return0. Normal null-host opening preserves return2/state1 after creating and retiring its startup worker:8FC640 calls8FC380 before8FC6A6 tests the null host. Unsupported active hosts and NUL paths reject before mutation.',
            'Metadata construction/teardown, callback factories/clones/replacements, shared controls, parent singleton and ordered teardown match native fixtures. Exact member invocation remains an explicit boundary.',
            'Four dedicated mode1 parent diagnostics exercise real Windows workers with disabled/valid/missing/empty file paths. The valid path is truncated and receives four timestamped literal-percent messages. Stop joins the worker; parent destruction is immediately followed by logger retirement.',
            'Ten independent Settings failure positions free private partial service allocations and scratch, reset the provider and permit a clean retry. Final commands preserve both the canonical application and standalone-service regression paths.',
        ],
        'limits': [
            'The mode1 file probe is diagnostic text, not replay frame serialization or normal gameplay. Active network hosts, replay playback/recording frames, simulation delivery, six-client matches and full-game completion remain unimplemented or unqualified.',
            'Native service fixtures supply caller-owned392-byte storage and mode flags; they do not prove the real gameplay producers of those flags. Derived host allocation explicitly fails. Full-native worker cases use logical scheduling; contract cases supply stream creation failure and null-worker join.',
            'Parent/service callback objects are installed and owned. Generic dispatch729370/update_metadata729D70/invoke734130 already exist in audio_replay_events, but their Windows Boundary and terminal consumers remain disconnected;12-byte wrapper5CCEB0,729B70/729C50 and service738A3A/72B950 still need connection or implementation. Metadata populated teardown snapshots do not constitute ports of metadata container update methods.',
            'Only one parent initialization is allowed per application. Repeated sessions, global atexit order, active crash-report service, broader OOM/custom allocator failures, worker timeouts and graphical exit remain unqualified.',
            'These selected core/client tests and command probes do not replace the full test suite or visual, audio, gameplay, fidelity and network acceptance. All24domains114tasks37additional requirements remain in scope.',
        ],
        'next_action': next_action,
    }
    # Prepare all document mutations and validate their existing structure before writing anything.
    updates = {}
    summary_keys = ['saved_utc', 'passed', 'complete', 'core_tests_passed', 'core_tests_filtered', 'client_tests_passed',
                    'client_tests_filtered', 'native_metadata_lifetimes', 'native_callback_lifetimes',
                    'native_parent_singleton_lifetimes', 'native_parent_open_contract_lifetimes',
                    'native_service_full_worker_lifetimes', 'native_service_supplied_worker_contract_lifetimes',
                    'client_commands', 'client_parent_profiles', 'client_workers', 'client_executable_sha256']
    summary = {key: receipt[key] for key in summary_keys}
    summary['receipt'] = RECEIPT
    for name in ['coverage.json', 'resume_checkpoint.json', 'completion_plan.json']:
        data = load(ROOT / 'docs' / name)
        data[KEY], data['updated_utc'], data['next_action'] = summary, now.isoformat(), next_action
        if name == 'resume_checkpoint.json':
            data['state'], data['saved_utc'] = 'active', now.isoformat()
            verified = data.setdefault('last_verified', {})
            verified['replay_game_manager_audio_selected_core_tests'] = core['passed']
            verified['replay_game_manager_selected_client_tests'] = client['passed']
            verified['replay_game_manager_receipt'] = RECEIPT
        if name == 'completion_plan.json':
            domain = next(domain for domain in data['domains'] if domain['id'] == '21')
            if isinstance(domain.get('progress_evidence'), list) and RECEIPT not in domain['progress_evidence']:
                domain['progress_evidence'].append(RECEIPT)
            for task in domain['tasks']:
                if task['id'] in ['21.3', '21.4'] and RECEIPT not in task['evidence']:
                    task['evidence'].append(RECEIPT)
            data['next_execution_steps'][0] = next_action
        updates[name] = data
    html_path = ROOT / 'docs/completion_plan.html'
    html = html_path.read_text(encoding='utf-8')
    marker = 'replay-game-manager-validation'
    assert marker not in html and '</body>' in html
    section = (
        f'<section id="{marker}"><h2>Replay : service et gestionnaire dans le même moteur</h2>'
        '<p>Le service configuré, le gestionnaire parent, ses métadonnées et les objets callback partagent désormais la même mémoire du moteur. '
        'L’ouverture sans hôte conserve le code natif 2. Quatre profils diagnostics exécutent et ferment leurs threads Windows et leur journal. '
        f'{core["passed"]} tests moteur ciblés, {client["passed"]} tests client ciblés et neuf commandes du client reconstruit passent. '
        'Les effets des callbacks, les trames de partie, le réseau actif et la validation complète du jeu restent à terminer.</p></section>'
    )
    html_updated = html.replace('</body>', section + '</body>')
    backup = ROOT / 'docs/plan_history' / ('replay-game-manager-' + now.strftime('%Y%m%dT%H%M%S%fZ'))
    backup.mkdir(parents=True, exist_ok=False)
    for name in ['coverage.json', 'resume_checkpoint.json', 'completion_plan.json', 'completion_plan.html']:
        shutil.copy2(ROOT / 'docs' / name, backup / name)
    if (ROOT / RECEIPT).exists():
        shutil.copy2(ROOT / RECEIPT, backup / Path(RECEIPT).name)
    write_json(ROOT / RECEIPT, receipt)
    for name, value in updates.items():
        write_json(ROOT / 'docs' / name, value)
    temporary = html_path.with_suffix('.html.tmp')
    temporary.write_text(html_updated, encoding='utf-8')
    temporary.replace(html_path)
    for group in ['source_hashes', 'resource_hashes', 'log_hashes']:
        for name, digest in receipt[group].items():
            assert sha(ROOT / name) == digest, name
    for name in updates:
        assert load(ROOT / 'docs' / name)['next_action'] == next_action
    assert load(ROOT / RECEIPT)['complete'] is False
    print(json.dumps({'passed': True, 'complete': False, 'core_tests': core['passed'],
                      'client_tests': client['passed'], 'client_commands': 9, 'client_workers': workers,
                      'disk_outputs': disk, 'scope': scope, 'receipt': str(ROOT / RECEIPT),
                      'backup': str(backup), 'client_sha256': client_sha}))


if __name__ == '__main__':
    main()
