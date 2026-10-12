"""Publish a frozen incomplete RADS heap preparation. Never run a probe."""
from pathlib import Path, PurePosixPath
import copy
import datetime
import hashlib
import json
import struct
import sys
import uuid

S = Path(__file__).resolve().parent
W = Path('E:/mapslol3v3')
R = Path('E:/OpenLeague')
N = W / 'loading_rads_heap_probe'
A = R / 'docs/loading_rads_heap_preparation'
RECEIPT = R / 'docs/loading_rads_heap_preparation_receipt.json'
FIELD = 'loading_rads_heap_preparation'
NATIVE_SHA = '74cda6f69c1528da36fef6d11faefc548b9cd56d38bc73bdffc90d6e4cfc4dbf'
FINAL_REVIEW_SHA = '7eee93d2ec60aa96b582dba3d4c43044c3a3cb09a0c4bbae5a75b8cd9b8375e5'
PE_SHA = '402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
DLL_SHA = '60833cd552d93b93304d4937912951e144e38db5d70793eb60a0c5f5d579e521'
PRIOR_SHA = '3eb1ff246d2c20f572bb814d5c36a90d0048dde0f8848d80df9b1fa7554820ef'
SHUTDOWN_SHA = '8b072427f8a4f7b6804ffa39e71cbe6752ccc4546e05671cc77eac7f9ebbb809'
ASSET_RECEIPT_SHA = '3b6c9045619956bd1b6d7b2c72a53fd2f4c216add93a65bbf7bc59766944c06f'
ASSETS = 'native_champion_loading_assets_import'


def require(condition, message):
    if not condition:
        raise ValueError(message)


def sha_bytes(raw):
    return hashlib.sha256(raw).hexdigest()


def sha(path):
    with Path(path).open('rb') as source:
        return hashlib.file_digest(source, 'sha256').hexdigest()


def decode(raw):
    def pairs(items):
        value = {}
        for key, item in items:
            require(key not in value, 'duplicate JSON key: ' + key)
            value[key] = item
        return value
    def invalid(value):
        raise ValueError('non-finite JSON value: ' + value)
    return json.loads(raw.decode('utf-8-sig'), object_pairs_hook=pairs, parse_constant=invalid)


def encode(value):
    return (json.dumps(value, ensure_ascii=False, indent=2, allow_nan=False) + '\n').encode('utf-8')


def inside(root, name):
    rel = PurePosixPath(name)
    require(name and not rel.is_absolute() and '..' not in rel.parts and ':' not in name
            and '\\' not in name, 'unsafe relative path: ' + name)
    path = root.joinpath(*rel.parts)
    require(path.resolve().is_relative_to(root.resolve()), 'outside expected root: ' + str(path))
    return path


def pe_region(raw, address, size):
    """Read source bytes from a file-backed PE32 section; never load or execute it."""
    require(raw[:2] == b'MZ' and len(raw) >= 64, 'invalid PE DOS header')
    pe = struct.unpack_from('<I', raw, 0x3c)[0]
    require(raw[pe:pe+4] == b'PE\0\0', 'invalid PE signature')
    sections = struct.unpack_from('<H', raw, pe+6)[0]
    optional_size = struct.unpack_from('<H', raw, pe+20)[0]
    optional = pe+24
    require(struct.unpack_from('<H', raw, optional)[0] == 0x10b, 'expected original PE32')
    base = struct.unpack_from('<I', raw, optional+28)[0]
    rva = address-base
    for index in range(sections):
        offset = optional+optional_size+index*40
        va, raw_size, raw_offset = struct.unpack_from('<III', raw, offset+12)
        if va <= rva and rva+size <= va+raw_size:
            begin = raw_offset+rva-va
            result = raw[begin:begin+size]
            require(len(result) == size, 'truncated PE source region')
            return result
    raise ValueError('source region not fully file-backed: ' + hex(address))


def frozen_facts(native, read_input, check):
    require(len(NATIVE_SHA) == 64, 'final heap profiles and manifest have not been pinned')
    require(native['kind'] == 'partial_original_x86_RADS_heap_reallocation'
            and len(native['files']) == 75 and len(native['external_dependencies']) == 190,
            'frozen native package identity differs')
    require(all(native[k] is False for k in ['integrated', 'complete', 'rust_compiled',
                                           'provider_complete', 'dll_attached']), 'native preparation scope differs')
    require(native['source_exe_sha256'] == PE_SHA and native['source_dll_sha256'] == DLL_SHA,
            'original binary provenance differs')
    check(native['source_exe'], PE_SHA, 15973880)
    check(native['source_dll'], DLL_SHA, 1707520)
    for path, row in native['external_dependencies'].items():
        check(path, row['sha256'], row.get('bytes'))
    suites = check_recorded_suites(native, read_input, check)
    profiles = check_profiles(native, read_input, check)
    attempts = native['preserved_attempts']
    require(len(attempts) == len(set(attempts)) and all(name in native['files'] for name in attempts),
            'historical attempt evidence missing')
    facts = dict(native_preparation_files=len(native['files']), final_profiles=profiles,
                 native_stop="GetModuleHandleA('kernel32') in DLL initialization",
                 dll_entry_started=True, dll_process_attach_returned=False, dll_main_reached=False,
                 module_handle_published=False, rads_initialize_reached=False,
                 ini_entered=True, ini_returned=False, provider_returned=False,
                 native_teardown_complete=False, host_hygiene_passed=True,
                 engine_allocation_count_scope='Engine primitive arena only, separate from CRT heap mirrors.',
                 engine_arena_blocks_after_host_cleanup_per_profile=928,
                 crt_raw_owners_after_host_cleanup_per_profile=0,
                 crt_mapped_regions_after_host_cleanup_per_profile=0,
                 historical_attempts_preserved=len(attempts),
                 address_counts_are_before_host_cleanup=True,
                 native_sync_creation_reached=False, isolated_sync_checks=15,
                 original_exe_sha256=PE_SHA, original_dll_sha256=DLL_SHA, **suites)
    next_action = (
        "Qualifier la vraie frontiere GetModuleHandleA('kernel32') atteinte dans RiotRadsIO.dll : "
        'resoudre le module Windows deja charge et conserver son identite de handle ; cette requete '
        'ne publie pas le handle RADS. Reprendre ensuite le 51e initialiseur C++ interrompu et '
        'les suivants, leurs frontieres synchronisation/ETW, puis le retour reel process-attach avant '
        'publication du handle RADS, RadsSetLogger/RadsInitialize et le retour INI8B0630/provider90B520. '
        'Qualifier fallback et destructions peuplees avant raccord Rust/UI aux 1178 assets natifs '
        'deja importes. Conserver la preuve publiee de fermeture du client normal, puis poursuivre '
        'tous les domaines et exigences ouverts du plan sans declarer le provider, le rendu ou le jeu termines.'
    )
    html_section = (
        '<section id="loading-rads-heap-preparation"><h2>Preparation native RADS : memoire CRT</h2>'
        '<p>Deux profils scratch ont franchi une reallocation Win32 reelle de 128 vers 256 octets, '
        'avec deplacement observe dans chaque profil. Arret suivant : GetModuleHandleA(kernel32), '
        'module Windows deja charge. Cinq initialiseurs C et 50 C++ sont revenus ; le 51e C++ est interrompu.</p>'
        '<p>1034 controles dans 17 rapports : 667 adaptateurs ou snippets synthetiques, 13 controles SList x86 '
        'et une suite strlen mixte de 354 controles (68 invocations originales revenues, trois interrompues, '
        'deux contextes manuels). Aucun nouveau test Rust. Les instructions strlen originales restent '
        'executees ; seule une lecture physique bornee a deux adresses est autorisee avec les vrais octets '
        'padding lus par ReadProcessMemory.</p>'
        '<p>Avant nettoyage : 19167 adresses distinctes dont 5536 DLL pour le profil vide, 19254 dont 5624 DLL '
        'pour le profil controle. Nettoyage hote CRT : zero bloc raw et zero region miroir restante. '
        'Le moteur conserve 928 allocations dans son arene distincte, sans destruction native complete. '
        'Aucun retour attach ni handle RADS publie, aucun RadsInitialize ni retour INI/provider. '
        'Integration et completion restent fausses.</p>'
        '<p><a href="loading_rads_heap_preparation_receipt.json">Preuves et limites du lot</a>. '
        'Prochaine etape : qualifier la resolution de kernel32 deja charge, puis poursuivre '
        'les initialiseurs et la chaine RADS/INI/provider.</p></section>'
    )
    limits = list(native['limits']) + [
        'The 354 mixed strlen checks are not 354 native invocations: 68 original calls completed, 3 were interrupted, and 2 contexts were manually arranged.',
        'Engine arena allocations and CRT heap mirrors have distinct ownership/accounting; do not infer progress by subtracting the older combined counts.',
        'Terminal host cleanup does not qualify native CRT/DLL/provider destruction; 928 engine-arena allocations remain in each stopped profile.',
        'The next GetModuleHandleA query targets already-loaded Windows kernel32, not publication of a RADS module handle.',
        'No Rust build, client launch, provider integration or rendering is performed by this documentary publication.',
        'Historical attempts remain diagnostics of their respective revisions; only the final profiles bind the frozen common generators.',
    ]
    return facts, next_action, html_section, limits


def check_recorded_suites(native, read_input, check):
    """Check report consistency only; controlled tests stay distinct from PE runs."""
    expected = {
        'loader_structure_tests.json':21, 'io_isolation_tests.json':36,
        'logs_bridge_tests.json':23, 'crt_heap_ownership_tests.json':30,
        'slot_namespaces_tests.json':12, 'callback_batch_tests.json':8,
        'process_profile_tests.json':17, 'environment_profile_tests.json':36,
        'nls_query_tests.json':78, 'sync_os_tests.json':15, 'heap_size_tests.json':83,
        'thread_query_tests.json':11, 'native_slist_tests.json':13,
        'heap_mirrors_tests.json':245, 'heap_boundary_tests.json':29,
        'heap_realloc_x86_tests.json':23, 'native_strlen_tail_tests.json':354,
    }
    require(native['tests'] == expected
            and [native[k] for k in ['test_checks', 'static_adapter_checks', 'windows_x86_leaf_checks',
                                    'windows_x86_leaf_profiles', 'original_rads_strlen_checks',
                                    'original_rads_strlen_completed_invocations',
                                    'original_rads_strlen_interrupted_invocations', 'manual_strlen_context_setups']]
            == [1034, 667, 13, 3, 354, 68, 3, 2], 'manifest suite classification differs')
    suite = read_input('adapter_checks.json')
    require(suite['passed'] is True and suite['checks'] == sum(expected.values())
            and len(suite['runs']) == len(expected)
            and {r['report'] for r in suite['runs']} == set(expected), 'recorded suite differs')
    for row in suite['runs']:
        name = row['report']
        report = read_input(name)
        require(row['exit_code'] == 0 and row['passed'] is True and row['checks'] == expected[name]
                and row['report_sha256'] == native['files'][name]['sha256'], 'suite row differs: ' + name)
        require(report['passed'] is True and report['check_count'] == expected[name]
                and len(report['checks']) == expected[name], 'recorded checks differ: ' + name)
        for source, digest in report.get('source_hashes', report.get('sources', {})).items():
            require(native['files'][source]['sha256'] == digest, 'test source differs: ' + source)
    io = read_input('io_isolation_tests.json')
    require(io['source_sha256_before'] == io['source_sha256_after'], 'IO source changed')
    check(io['source_file'], io['source_sha256_after'])
    leaf = read_input('native_slist_tests.json')
    require(leaf['native_pe_execution'] is True and leaf['host_x86_dll_execution'] is False
            and len(leaf['cases']) == 3, 'SList scope differs')
    for dll in ['kernel', 'ntdll']:
        check(leaf['source'][dll+'_path'], leaf['source'][dll+'_sha256'])
    require(leaf['source']['bytes'] == 19
            and sha_bytes(bytes.fromhex(leaf['source']['code_hex'])) == leaf['source']['code_sha256'],
            'SList leaf bytes differ')
    abi = read_input('heap_realloc_x86_tests.json')
    require(abi['original_game_code_executed'] is False and abi['synthetic_x86_call_frames'] is True
            and abi['actual_heap_calls'] is True and abi['simulated_heap_results'] is False
            and abi['sources_unchanged'] is True and abi['source_hashes_after'] == abi['source_hashes'],
            'synthetic ABI suite scope differs')
    external = abi['external_finish_source']
    require(external['function'] == 'finish' and external['module_body_executed'] is False,
            'external ABI source scope differs')
    check(external['path'], external['sha256'])
    mirrors = read_input('heap_mirrors_tests.json')
    require(mirrors['actual_OS_null_realloc_observed'] is False and mirrors['injected_null_separate'] is True
            and mirrors['real_moves'] == 13 and mirrors['real_same_address'] == 7,
            'controlled heap result classification differs')
    strlen = read_input('native_strlen_tail_tests.json')
    require(strlen['completed_original_strlen_invocations'] == 68
            and strlen['interrupted_original_strlen_invocations'] == 3
            and strlen['manual_invocation_context_setups'] == 2
            and len(strlen['cases']) == 34 and len(strlen['executed_source_addresses']) == 43
            and strlen['cleanup_errors'] == [], 'mixed strlen suite differs')
    source = strlen['source']
    require(source['dll_sha256'] == DLL_SHA and source['va'] == 0x100F86D0 and source['bytes'] == 139
            and source['sha256'] == '5044fc769fb26ae1772d18e3e1ef5ffc16757c910207278cab8d90af3557a7f0',
            'strlen source identity differs')
    raw = check(source['path'], DLL_SHA)
    require(sha_bytes(pe_region(raw, source['va'], source['bytes'])) == source['sha256'], 'strlen source bytes differ')
    for name in ['heap_realloc_x86_tests.json', 'native_strlen_tail_tests.json']:
        state = read_input(name)['remaining']
        require(state['raw_owners'] == state['mapped_regions'] == state['live_owners'] == 0
                and state['interrupted'] == [], 'suite retained heap owner: ' + name)
    return dict(recorded_checks=1034, recorded_suite_reports=17,
                adapter_or_synthetic_checks=667, windows_x86_slist_leaf_checks=13,
                windows_x86_slist_leaf_profiles=3, mixed_original_strlen_suite_checks=354,
                original_strlen_completed_test_invocations=68,
                original_strlen_interrupted_test_invocations=3,
                strlen_manual_invocation_context_setups=2, controlled_heap_real_moves=13,
                controlled_heap_real_same_address=7, controlled_OS_null_realloc_observed=False,
                injected_heap_failures_separately_labelled=True)


def check_profiles(native, read_input, check):
    """Validate the two stopped original PE compositions without running them."""
    generators = native['common_generator_hashes']
    require(len(generators) == 12, 'final generator count differs')
    for name, digest in generators.items():
        require(native['files'][name]['sha256'] == digest, 'generator is not frozen: ' + name)
    dll_raw = check(native['source_dll'], DLL_SHA, 1707520)
    require(pe_region(dll_raw, 0x10176C64, 9) == b'kernel32\0', 'module query source string differs')
    outcomes = []
    require(len(native['oracles']) == 2, 'native profile count differs')
    for profile, name, address_count, dll_count, env_count, raw_count, strlen_count, physical_count in [
            ('empty', 'rads_provider_oracle.json', 19167, 5536, 0, 36, 3, 2),
            ('controlled', 'rads_provider_controlled_oracle.json', 19254, 5624, 3, 39, 12, 7)]:
        report = read_input(name)
        require(report['source_sha256'] == PE_SHA and report['generator_hashes'] == generators
                and report['declared_environment_variant'] == profile, 'profile provenance differs')
        for path, digest in report['verified_input_files'].items():
            check(path, digest)
        require(all(report[k] is False for k in ['passed', 'complete', 'provider_returned', 'completed_path'])
                and report['cleanup_passed'] is True, 'unsupported profile completion')
        module = report['rads_module']
        require(module['state'] == 'attaching' and module['sha256'] == DLL_SHA
                and module['image_base'] == 0x10000000 and module['entry'] == 0x100F2C22
                and module['events'] == [dict(operation='map', base=0x10000000, bytes=0x1AC000, imports=210),
                                         dict(operation='begin_native_attach', entry=0x100F2C22)],
                'module state or handle publication differs')
        addresses = report['executed_instruction_addresses']
        require(len(addresses) == len(set(addresses)) == address_count
                and sum(0x10000000 <= p < 0x101AC000 for p in addresses) == dll_count,
                'before-cleanup address counts differ')
        require({0x8B0630, 0x100F2C22, 0x100FB602, 0x100FF3FC, 0x100FF62B, 0x100F86D0} <= set(addresses)
                and not ({0x9529FA, 0x1003E3D0, 0x100FF7A8, 0x1005BFDF, 0x90B6DC} & set(addresses)),
                'native reached/unreached stages differ')
        stop = report['stop']
        require(stop['kind'] == 'unimplemented_import' and stop['import']['name'] == 'GetModuleHandleA'
                and stop['import']['dll'].lower() == 'kernel32.dll'
                and stop['import']['module'] == 'RiotRadsIO.dll' and stop['args'][0] == 0x10176C64,
                'final module-query boundary differs')
        require([(r['entry'], r['result']) for r in report['crt_phases']] == [('CA92CB', 1), ('CAFF53', 0)]
                and [(r['stage'], r['eax']) for r in report['dll_crt_returns']] ==
                [('low_io100FB602', 0), ('argv100FF3FC', 0), ('environment_table100FF62B', 0)],
                'CRT initialization return facts differ')
        calls = report['dll_initializer_calls']
        c, cpp = [r for r in calls if r['kind'] == 'C'], [r for r in calls if r['kind'] == 'C++']
        require(len(c) == 5 and all(r['returned'] is True and r['eax_after'] == 0 for r in c)
                and len(cpp) == 51 and all(r['returned'] is True for r in cpp[:50])
                and cpp[-1]['returned'] is False, 'initializer prefix differs')
        reallocs = [r for r in report['crt_heap_mirror_events'] if r['operation'] == 'HeapReAlloc']
        require(len(reallocs) == 1, 'actual profile realloc count differs')
        realloc = reallocs[0]
        require(realloc['phase'] == 'live' and realloc['old_size'] == 128 and realloc['size'] == 256
                and realloc['moved'] is True and realloc['result'] == realloc['pointer']
                and realloc['pointer'] != realloc['old_pointer'], 'actual realloc transition differs')
        crt_reallocs = [r for r in report['crt_events'] if r.get('api') == 'HeapReAlloc']
        require(len(crt_reallocs) == 1 and crt_reallocs[0]['result'] == realloc['pointer']
                and crt_reallocs[0]['pointer'] == realloc['old_pointer']
                and crt_reallocs[0]['size'] == 256 and crt_reallocs[0]['flags'] == 0,
                'CRT realloc ABI result differs')
        state, process = report['dll_process_state'], report['process_profile_at_end']
        require(state['argc'] == 1 and len(state['argv_values_hex']) == 1 and state['argv_sentinel'] == 0
                and len(state['environment_values_hex']) == env_count and state['environment_acp_block'] == 0
                and state['environment_initialized'] == 1 and state['lowio_records'] == 32
                and state['attach_counter'] == 0 and state['commandline_pointer'] == process['pointer'],
                'native argument/environment state differs')
        require(process['calls'] == 1 and process['memory_unchanged'] is True
                and process['host_argv_imported'] is False and process['host_environment_imported'] is False
                and process['environment_live_allocations'] == 0 and report['process_profile_retired'] is True,
                'process ownership differs')
        strlen = report['native_strlen_tail']
        require(strlen['source'] == read_input('native_strlen_tail_tests.json')['source']
                and strlen['unretired_invocations'] == 0, 'native strlen scope differs')
        entries = [r for r in strlen['events'] if r['kind'] == 'entry']
        exits = [r for r in strlen['events'] if r['kind'] == 'native_return']
        require(len(entries) == len(exits) == strlen_count
                and {r['invocation'] for r in entries} == {r['invocation'] for r in exits},
                'strlen invocation retirement differs')
        reads = [r for r in strlen['events'] if r['kind'] == 'bounded_native_read']
        require(len(reads) == physical_count*2
                and all(r['pc'] in [0x100F8700, 0x100F8718]
                        and r['padding_source'] == 'real current-process ReadProcessMemory snapshot'
                        and len(bytes.fromhex(r['valid_hex'])) == r['valid_bytes']
                        and 0 < r['valid_bytes'] < 4
                        and len(bytes.fromhex(r['padding_hex'])) == 4-r['valid_bytes'] for r in reads),
                'strlen physical padding exception widened or changed')
        physical = strlen['physical_reads']
        require(len(physical) == physical_count
                and all(r['api'] == 'ReadProcessMemory' and r['injected'] is False and r['success'] is True
                        and r['requested'] == r['transferred'] == len(bytes.fromhex(r['bytes_hex']))
                        for r in physical), 'real padding reads differ')
        before, after = report['crt_heap_mirrors_at_stop'], report['crt_heap_mirrors_after_cleanup']
        require(before['raw_owners'] == before['mapped_regions'] == before['live_owners'] == raw_count
                and before['interrupted'] == [] and after['raw_owners'] == after['mapped_regions'] == after['live_owners'] == 0
                and after['interrupted'] == [], 'CRT heap retirement differs')
        require(report['crt_host_backing_after_cleanup'] == dict(slots=0, locks=0, heap_blocks=0,
                unadopted_heap_blocks=0, pending_callbacks=0, interrupted_callbacks=0,
                retained_heap_mappings=0, interrupted_heap_owners=0)
                and report['emulated_live_count_after_host_cleanup'] == 928
                and report['emulated_allocation_count_scope'] ==
                'Engine primitive arena only; imported CRT heap mirrors are separately counted in crt_heap_mirrors_after_cleanup.',
                'engine and CRT heap cleanup accounting differs')
        require(all(report[k] == 0 for k in ['sync_handles_after_cleanup', 'open_host_handles_after_cleanup',
                                            'diagnostic_pipe_handles_after_cleanup', 'strlen_invocations_abandoned_after_cleanup'])
                and all(report[k] == [] for k in ['sync_cleanup_errors', 'sync_events', 'interrupted_callbacks',
                'unstarted_callbacks_at_end', 'crt_heap_bounds_events', 'crt_heap_mirror_cleanup_errors']),
                'cleanup or boundary diagnostics differ')
        callbacks = [r['callback'] for r in report['crt_events'] if r.get('api') == 'host_cleanup_native_callback_completed']
        require(callbacks == [0xCA9026, 0x100F5E10], 'FLS cleanup callbacks differ')
        expected_manifest_profile = dict(profile=profile, file=name, sha256=native['files'][name]['sha256'],
            stop='GetModuleHandleA', argument_ascii='kernel32', argument_va=0x10176C64,
            iat_va=stop['import']['iat'], native_addresses_before_cleanup=address_count,
            dll_addresses_before_cleanup=dll_count, actual_reallocation=realloc,
            c_calls_returned=5, cpp_calls_started=51, cpp_calls_returned=50,
            rpm_observations=physical_count, native_strlen_returns=strlen_count, cleanup_passed=True,
            crt_raw_at_stop=raw_count, crt_mappings_at_stop=raw_count,
            crt_raw_after_cleanup=0, crt_mappings_after_cleanup=0, emulated_engine_remaining=928,
            dll_attached=False, module_handle_published=False, rads_initialize_reached=False,
            sync_creation_reached=False, ini_entered=True, ini_returned=False, provider_returned=False)
        require(native['oracles'][len(outcomes)] == expected_manifest_profile, 'manifest profile facts differ')
        outcomes.append(dict(profile=profile, file=name, sha256=native['files'][name]['sha256'],
            native_addresses_before_cleanup=address_count, dll_addresses_before_cleanup=dll_count,
            argc=1, environment_entries=env_count, c_calls_returned=5, cpp_calls_returned=50, cpp_calls_started=51,
            real_reallocations=1, real_realloc_moved=True, realloc_growth_bytes=[128, 256],
            native_strlen_completed_invocations=strlen_count, physical_padding_reads=physical_count,
            crt_raw_owners_at_stop=raw_count, crt_raw_owners_after_host_cleanup=0,
            crt_mapped_regions_after_host_cleanup=0, engine_arena_blocks_after_host_cleanup=928,
            cleanup_passed=True, dll_attached=False, module_handle_published=False,
            rads_initialize_reached=False, ini_entered=True, ini_returned=False, provider_returned=False))
    return outcomes


def prepare():
    """Read-only: pin all inputs and prepare every byte before publication."""
    require(len(NATIVE_SHA) == 64, 'final native manifest not pinned')
    require(len(FINAL_REVIEW_SHA) == 64, 'final independent review not pinned')
    require(not A.exists() and not RECEIPT.exists(), 'preserve existing archive/receipt')
    inputs, archives, archive_rows = {}, {}, {}

    def check(path, expected, size=None):
        path = Path(path)
        require(path.is_file(), 'missing input: ' + str(path))
        raw = path.read_bytes()
        require(sha_bytes(raw) == expected and (size is None or len(raw) == size), 'input changed: ' + str(path))
        row = dict(bytes=len(raw), sha256=expected)
        require(str(path) not in inputs or inputs[str(path)] == row, 'conflicting input: ' + str(path))
        inputs[str(path)] = row
        return raw

    def archive(path, name, expected, size=None):
        inside(A, name)
        require(name.casefold() not in {key.casefold() for key in archives}, 'duplicate archive target: ' + name)
        raw = check(path, expected, size)
        archives[name] = raw
        archive_rows[name] = dict(source=str(path), bytes=len(raw), sha256=expected)
        return raw

    def package(directory, prefix, expected):
        manifest = decode(archive(directory / 'manifest.json', prefix + 'manifest.json', expected))
        for name, row in manifest['files'].items():
            archive(inside(directory, name), prefix + name, row['sha256'], row['bytes'])
        return manifest

    native = package(N, '', NATIVE_SHA)
    final_manifest = package(W / 'loading_rads_heap_final_review', 'final_review/', FINAL_REVIEW_SHA)
    require(final_manifest['kind'] == 'read_only_final_heap_evidence_review'
            and final_manifest['native_manifest_sha256'] == NATIVE_SHA and len(final_manifest['files']) == 2
            and final_manifest['review_passed'] is True
            and final_manifest['probe_executed_by_reviewer'] is False
            and final_manifest['production_modified'] is False, 'final review identity/scope differs')
    final_review = decode(archives['final_review/REVIEW.json'])
    require(final_review['review_passed'] is True and final_review['unresolved_concrete_defects'] == []
            and final_review['native_manifest_sha256'] == NATIVE_SHA
            and final_review['archived_native_files'] == 75 and final_review['external_dependencies_hashed'] == 190
            and final_review['common_generator_count'] == 12 and len(final_review['verified_files']) == 268,
            'final review conclusions differ')
    for path, row in final_review['verified_files'].items():
        check(path, row['sha256'], row['bytes'])
    def read_input(name):
        require(name in native['files'], 'oracle/report is not in frozen native files: ' + name)
        return decode(archives[name])
    facts, next_action, html_section, limits = frozen_facts(native, read_input, check)
    prior = decode(check(R / 'docs/loading_rads_process_preparation_receipt.json', PRIOR_SHA))
    shutdown = decode(check(R / 'docs/normal_client_shutdown_validation.json', SHUTDOWN_SHA))
    require(prior['integrated'] is False and prior['complete'] is False, 'prior RADS scope changed')
    require(shutdown['passed'] is True and shutdown['complete'] is False
            and (shutdown['shutdown_tests_passed'], shutdown['related_client_tests_passed'], shutdown['cli_commands_passed']) == (6, 10, 11)
            and shutdown['real_normal_client_wm_close_passed'] is True, 'normal shutdown proof changed')

    now = datetime.datetime.now(datetime.timezone.utc)
    summary = dict(saved_utc=now.isoformat(), receipt=RECEIPT.relative_to(R).as_posix(),
                   manifest=(A / 'manifest.json').relative_to(R).as_posix(), manifest_sha256=NATIVE_SHA,
                   integrated=False, complete=False, rust_compiled=False, new_rust_tests=0,
                   client_executed=False, provider_connected=False, rendered=False,
                   final_review=(A / 'final_review/manifest.json').relative_to(R).as_posix(),
                   final_review_sha256=FINAL_REVIEW_SHA, final_review_read_only=True,
                   independent_review_limits=copy.deepcopy(final_review['limits']),
                   **facts)
    originals, documents, assets = {}, {}, None
    for name in ['coverage.json', 'resume_checkpoint.json', 'completion_plan.json']:
        path = R / 'docs' / name
        raw = path.read_bytes()
        before = decode(raw)
        require(FIELD not in before and before['complete'] is False, 'unexpected document state: ' + name)
        require(before['loading_rads_process_preparation'] == prior['summary'], 'previous RADS process proof differs')
        shutdown_summary = before['normal_client_shutdown_validation']
        require(all(shutdown[key] == value for key, value in shutdown_summary.items()), 'shutdown proof differs between docs')
        imported = before[ASSETS]
        require((imported['champions'], imported['files'], imported['images'], imported['inibin']) == (122, 1178, 720, 458)
                and imported['physical_import_verified'] is True
                and all(imported[key] is False for key in ['complete', 'provider_connected', 'rendered']), 'assets changed')
        require(assets is None or assets == imported, 'asset summaries differ')
        assets = copy.deepcopy(imported)
        after = copy.deepcopy(before)
        after.update({FIELD: copy.deepcopy(summary), 'next_action': next_action, 'updated_utc': now.isoformat()})
        allowed = {FIELD, 'next_action', 'updated_utc'}
        if name == 'resume_checkpoint.json':
            require(before['state'] == 'active' and 'in_progress' not in before, 'checkpoint must remain active')
            require('Do not repeat' in before['communication_preferences']['progress_dashboard_repetition'], 'communication preference missing')
            after['saved_utc'] = now.isoformat()
            allowed.add('saved_utc')
        if name == 'completion_plan.json':
            require(len(before['domains']) == 24 and sum(len(d['tasks']) for d in before['domains']) == 114
                    and before['counts']['additional_requirements'] == 37, 'plan scope changed')
            require(before['next_execution_steps'][0] == before['next_action'], 'plan first action differs')
            after['next_execution_steps'][0] = next_action
            require(after['next_execution_steps'][1:] == before['next_execution_steps'][1:], 'plan tail changed')
            allowed.add('next_execution_steps')
            for old, domain in zip(before['domains'], after['domains']):
                if domain['id'] in ['02', '17']:
                    links = domain.setdefault('progress_evidence', [])
                    require(isinstance(links, list), 'domain evidence must be a list')
                    if summary['receipt'] not in links:
                        links.append(summary['receipt'])
                    require({k:v for k,v in old.items() if k != 'progress_evidence'} ==
                            {k:v for k,v in domain.items() if k != 'progress_evidence'}, 'domain state changed')
                else:
                    require(old == domain, 'unrelated domain changed')
            allowed.add('domains')
        require({k:v for k,v in before.items() if k not in allowed} ==
                {k:v for k,v in after.items() if k not in allowed}, 'unrelated plan/proof/preference changed')
        originals[path], documents[path] = raw, encode(after)

    check(inside(R, assets['manifest']), assets['manifest_sha256'])
    asset_receipt = decode(check(inside(R, assets['receipt']), ASSET_RECEIPT_SHA))
    require(all(asset_receipt[key] == value for key, value in assets.items()), 'asset receipt mismatch')
    page = R / 'docs/completion_plan.html'
    old = page.read_bytes()
    require(old.count(b'</body>') == 1 and b'id="loading-rads-heap-preparation"' not in old, 'HTML marker conflict')
    require(b'id="normal-client-shutdown-validation"' in old, 'shutdown HTML proof missing')
    require(b'id="loading-rads-process-preparation"' in old, 'prior RADS process HTML proof missing')
    originals[page] = old
    documents[page] = old.replace(b'</body>', html_section.encode('utf-8') + b'</body>')
    for name in ['install.py', 'verify_published.py', 'README.md']:
        archive(S / name, 'publication/' + name, sha(S / name))
    backup = R / 'docs/plan_history' / ('loading-rads-heap-' + now.strftime('%Y%m%dT%H%M%S%fZ'))
    require(not backup.exists(), 'backup collision')
    receipt = dict(summary, summary=summary, kind='frozen_incomplete_rads_heap_preparation', archive_verified=True,
                   backup=str(backup), archived_files=archive_rows, verified_inputs=inputs,
                   prior_preparation_receipt_sha256=PRIOR_SHA, shutdown_receipt_sha256=SHUTDOWN_SHA,
                   physical_assets_preserved=assets, domain_statuses_changed=False,
                   rust_test_counts_changed=False, publication_runs_native_or_adapter_code=False,
                   limits=limits, next_action=next_action,
                   original_document_sha256={p.relative_to(R).as_posix():sha_bytes(raw) for p,raw in originals.items()},
                   published_document_sha256={p.relative_to(R).as_posix():sha_bytes(raw) for p,raw in documents.items()},
                   transaction_limits='Per-file atomic replacement and caught-exception rollback; no multi-file power-loss atomicity. Detected concurrent edits are never rolled back as our own writes. Unpublished temporary evidence and backups are retained for inspection.')
    receipt_raw = encode(receipt)
    for path, raw in documents.items():
        require(path.resolve().is_relative_to((R / 'docs').resolve()), 'document outside docs')
        if path.suffix == '.json':
            decode(raw)
    decode(receipt_raw)
    return dict(archives=archives, originals=originals, documents=documents,
                inputs=inputs, backup=backup, summary=summary, receipt=receipt_raw)


def current_bytes(path):
    return path.read_bytes() if path.exists() else None


def write_new(path, raw):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open('xb') as stream:
        stream.write(raw)
        stream.flush()
    require(path.read_bytes() == raw, 'prepared byte verification failed: ' + str(path))


def publish(plan):
    """Prepare and verify all outputs before touching any live document."""
    docs_root = R / 'docs'
    originals, documents, backup = plan['originals'], plan['documents'], plan['backup']
    for path in [A, RECEIPT, backup]:
        require(path.resolve().is_relative_to(docs_root.resolve()) and not path.exists(), 'publication collision/outside docs')
    for path, raw in originals.items():
        require(current_bytes(path) == raw, 'document changed before preparation: ' + str(path))
    pending = docs_root / ('.loading-rads-heap-' + uuid.uuid4().hex)
    require(pending.resolve().parent == docs_root.resolve(), 'temporary preparation outside docs')
    pending.mkdir()
    staged_archive = pending / 'archive'
    staged_archive.mkdir()
    for name, raw in plan['archives'].items():
        write_new(inside(staged_archive, name), raw)
    for path, raw in originals.items():
        write_new(inside(pending / 'backup', path.relative_to(docs_root).as_posix()), raw)
    staged_documents = {}
    for path, raw in documents.items():
        staged = inside(pending / 'documents', path.relative_to(docs_root).as_posix())
        write_new(staged, raw)
        staged_documents[path] = staged
    staged_receipt = pending / 'receipt.json'
    write_new(staged_receipt, plan['receipt'])
    # ALL final preflight is outside the commit/rollback block. A foreign change
    # observed now must abort without writing our obsolete originals over it.
    for name, row in plan['inputs'].items():
        path = Path(name)
        require(path.stat().st_size == row['bytes'] and sha(path) == row['sha256'], 'input changed: ' + name)
    for path, raw in originals.items():
        require(current_bytes(path) == raw, 'document changed before commit: ' + str(path))
    require(not A.exists() and not RECEIPT.exists() and not backup.exists(), 'commit destination appeared')
    backup.parent.mkdir(parents=True, exist_ok=True)
    require((pending / 'backup').resolve().is_relative_to(docs_root.resolve())
            and backup.resolve().is_relative_to(docs_root.resolve()), 'backup move outside docs')
    (pending / 'backup').rename(backup)
    attempted, archive_intended = [], False
    writes = {**documents, RECEIPT:plan['receipt']}
    before = {**originals, RECEIPT:None}
    try:
        require(staged_archive.resolve().is_relative_to(docs_root.resolve())
                and A.resolve().is_relative_to(docs_root.resolve()), 'archive move outside docs')
        archive_intended = True
        staged_archive.rename(A)
        for path, raw in writes.items():
            require(current_bytes(path) == before[path], 'destination changed during commit: ' + str(path))
            # Track intent after the comparison, before atomic replacement. On
            # an interrupted replacement rollback only bytes identical to ours.
            attempted.append(path)
            staged = staged_receipt if path == RECEIPT else staged_documents[path]
            staged.replace(path)
            require(path.read_bytes() == raw, 'committed byte mismatch: ' + str(path))
    except BaseException as primary:
        failures = []
        for path in reversed(attempted):
            try:
                actual = current_bytes(path)
                if actual == before[path]:
                    continue
                require(actual == writes[path], 'rollback refuses foreign bytes: ' + str(path))
                if before[path] is None:
                    require(path.resolve() == RECEIPT.resolve() and path.parent.resolve() == docs_root.resolve(), 'unsafe new receipt removal')
                    path.unlink()
                else:
                    restore = pending / ('rollback-' + uuid.uuid4().hex)
                    write_new(restore, before[path])
                    require(current_bytes(path) == writes[path], 'destination changed during rollback: ' + str(path))
                    restore.replace(path)
                    require(path.read_bytes() == before[path], 'rollback byte mismatch')
            except BaseException as cleanup:
                failures.append(cleanup)
        if archive_intended and A.exists():
            try:
                require(not staged_archive.exists(), 'both archive locations exist')
                require(A.resolve().is_relative_to(docs_root.resolve())
                        and staged_archive.resolve().is_relative_to(docs_root.resolve()), 'archive rollback move outside docs')
                actual_names = {p.relative_to(A).as_posix() for p in A.rglob('*') if p.is_file()}
                require(actual_names == set(plan['archives']), 'archive changed during rollback')
                for name, raw in plan['archives'].items():
                    require(inside(A, name).read_bytes() == raw, 'archive bytes changed during rollback')
                A.rename(staged_archive)
            except BaseException as cleanup:
                failures.append(cleanup)
        if failures:
            raise BaseExceptionGroup('Publication failed; rollback conflict/failure, preserve backups', [primary, *failures])
        raise


def main():
    require(len(NATIVE_SHA) == 64 and sys.argv[1:] == [NATIVE_SHA], 'explicit frozen native manifest SHA required')
    plan = prepare()
    publish(plan)
    print(json.dumps(plan['summary'], ensure_ascii=False))


if __name__ == '__main__':
    main()
