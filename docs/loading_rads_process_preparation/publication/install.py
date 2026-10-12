"""Publish a frozen incomplete RADS process/CRT preparation. Never run a probe."""
from pathlib import Path, PurePosixPath
import copy
import datetime
import hashlib
import json
import sys
import uuid

S = Path(__file__).resolve().parent
W = Path('E:/mapslol3v3')
R = Path('E:/OpenLeague')
N = W / 'loading_rads_commandline_probe'
A = R / 'docs/loading_rads_process_preparation'
RECEIPT = R / 'docs/loading_rads_process_preparation_receipt.json'
FIELD = 'loading_rads_process_preparation'
NATIVE_SHA = 'de3171f52c7387491f4be3883996bbee71209270f3f64293ae4679a85ba1c71c'
AUDIT_SHA = 'a09060fecef18a5f4ad7b639cccf9bb349e762db451a6cc5374ed233e906250f'
FINAL_REVIEW_SHA = '64f3041a4f00a1a102ba3c98cdaf07140a44d6eca42e15ee156a4a2eb5f05de8'
PE_SHA = '402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
DLL_SHA = '60833cd552d93b93304d4937912951e144e38db5d70793eb60a0c5f5d579e521'
PRIOR_SHA = '3d7d242042879ee3dcbd18a113f1677a4c3046a27ed9faa2f9dc0e7e54b0df5f'
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


def frozen_facts(native, read_input, check):
    require(native['kind'] == 'partial_original_x86_RADS_CRT_process_profile'
            and len(native['files']) == 55, 'native preparation identity changed')
    require(all(native[k] is False for k in ['integrated', 'complete', 'rust_compiled',
                                           'provider_complete', 'dll_attached']), 'native scope changed')
    require(native['source_exe_sha256'] == PE_SHA and native['source_dll_sha256'] == DLL_SHA,
            'native binary provenance mismatch')
    check(native['source_exe'], PE_SHA, 15973880)
    check(native['source_dll'], DLL_SHA, 1707520)
    for path, row in native['external_dependencies'].items():
        check(path, row['sha256'], row.get('bytes'))
    generators = native['common_generator_hashes']
    require(len(generators) == 10, 'generator set changed')
    for name, digest in generators.items():
        require(native['files'][name]['sha256'] == digest, 'generator not frozen: ' + name)

    expected_tests = {
        'loader_structure_tests.json':21, 'io_isolation_tests.json':36,
        'logs_bridge_tests.json':23, 'crt_heap_ownership_tests.json':9,
        'slot_namespaces_tests.json':12, 'callback_batch_tests.json':8,
        'process_profile_tests.json':17, 'environment_profile_tests.json':36,
        'nls_query_tests.json':78, 'sync_os_tests.json':15, 'heap_size_tests.json':21,
        'thread_query_tests.json':11, 'native_slist_tests.json':13,
    }
    require(native['tests'] == expected_tests and
            [native[k] for k in ['test_checks', 'static_adapter_checks', 'windows_x86_leaf_checks',
                                'windows_x86_leaf_profiles']] == [300, 287, 13, 3], 'suite scope changed')
    suite = read_input('adapter_checks.json')
    require(suite['passed'] is True and suite['checks'] == 300 and len(suite['runs']) == 13,
            'recorded suite did not pass')
    require({r['report'] for r in suite['runs']} == set(expected_tests), 'suite reports differ')
    for row in suite['runs']:
        name = row['report']
        report = read_input(name)
        require(row['exit_code'] == 0 and row['passed'] is True and row['checks'] == expected_tests[name]
                and row['report_sha256'] == native['files'][name]['sha256'], 'suite result mismatch: ' + name)
        require(report['passed'] is True and report['check_count'] == expected_tests[name]
                and len(report['checks']) == expected_tests[name], 'report checks differ: ' + name)
        for source, digest in report.get('source_hashes', report.get('sources', {})).items():
            require(native['files'][source]['sha256'] == digest, 'test source differs: ' + source)
    io = read_input('io_isolation_tests.json')
    require(io['source_sha256_before'] == io['source_sha256_after'], 'IO source changed')
    check(io['source_file'], io['source_sha256_after'])
    leaf = read_input('native_slist_tests.json')
    require(leaf['native_pe_execution'] is True and leaf['host_x86_dll_execution'] is False
            and len(leaf['cases']) == 3, 'leaf scope changed')
    for dll in ['kernel', 'ntdll']:
        check(leaf['source'][dll + '_path'], leaf['source'][dll + '_sha256'])
    require(leaf['source']['bytes'] == 19
            and sha_bytes(bytes.fromhex(leaf['source']['code_hex'])) == leaf['source']['code_sha256'],
            'leaf source bytes differ')

    profiles = [
        ('empty', 'rads_provider_oracle.json', '41d77b85aeccb9ba0afc1a89b4e9659d93768cce772010925c1f5185f274e8b3', 19043, 5426, 0, 959),
        ('controlled', 'rads_provider_controlled_oracle.json', '108200ff17bfdcb590ae4f94b635859ad61890835eedd6a077908a8716f790e1', 19127, 5514, 3, 962),
    ]
    expected_profiles = []
    for profile, name, digest, total, dll_count, env_count, remaining in profiles:
        expected = dict(profile=profile, file=name, sha256=digest, stop='HeapReAlloc', growth_bytes=[128, 256],
                        native_addresses_before_cleanup=total, dll_addresses_before_cleanup=dll_count,
                        c_calls_returned=5, cpp_calls_started=46, cpp_calls_returned=45, argc=1,
                        environment_entries=env_count, cleanup_passed=True, emulated_remaining=remaining,
                        sync_creation_reached=False, dll_attached=False, module_handle_published=False,
                        rads_initialize_reached=False, ini_entered=True, ini_returned=False, provider_returned=False)
        expected_profiles.append(expected)
        require(native['files'][name]['sha256'] == digest, 'final profile hash differs')
        report = read_input(name)
        require(report['generator_hashes'] == generators and report['source_sha256'] == PE_SHA
                and report['declared_environment_variant'] == profile, 'profile provenance differs')
        for path, source_digest in report['verified_input_files'].items():
            check(path, source_digest)
        require(all(report[k] is False for k in ['passed', 'complete', 'provider_returned', 'completed_path'])
                and report['cleanup_passed'] is True, 'profile claimed unsupported completion')
        module = report['rads_module']
        require(module['state'] == 'attaching' and module['sha256'] == DLL_SHA
                and module['image_base'] == 0x10000000 and module['entry'] == 0x100F2C22
                and module['events'] == [dict(operation='map', base=0x10000000, bytes=0x1AC000, imports=210),
                                         dict(operation='begin_native_attach', entry=0x100F2C22)],
                'module attached or publication sequence changed')
        addresses = report['executed_instruction_addresses']
        require(len(addresses) == len(set(addresses)) == total
                and sum(0x10000000 <= p < 0x101AC000 for p in addresses) == dll_count,
                'before-cleanup address count differs')
        require({0x8B0630, 0x100F2C22, 0x100FB602, 0x100FF3FC, 0x100FF62B} <= set(addresses)
                and not ({0x9529FA, 0x1003E3D0, 0x100FF7A8, 0x1005BFDF, 0x90B6DC} & set(addresses)),
                'actual reached/unreached stages differ')
        require([(r['entry'], r['result']) for r in report['crt_phases']] == [('CA92CB', 1), ('CAFF53', 0)]
                and [(r['stage'], r['eax']) for r in report['dll_crt_returns']] ==
                [('low_io100FB602', 0), ('argv100FF3FC', 0), ('environment_table100FF62B', 0)],
                'CRT return facts differ')
        calls = report['dll_initializer_calls']
        c, cpp = [r for r in calls if r['kind'] == 'C'], [r for r in calls if r['kind'] == 'C++']
        require(len(c) == 5 and all(r['returned'] is True and r['eax_after'] == 0 for r in c)
                and len(cpp) == 46 and all(r['returned'] is True for r in cpp[:45])
                and cpp[45]['returned'] is False, 'initializer count changed')
        stop = report['stop']
        require(stop['kind'] == 'unimplemented_import' and stop['import']['name'] == 'HeapReAlloc'
                and stop['import']['module'] == 'RiotRadsIO.dll'
                and stop['args'][1] == 0 and stop['args'][3] == 256, 'final native boundary differs')
        old_pointer = stop['args'][2]
        events = report['crt_events']
        require(any(e.get('api') == 'HeapAlloc' and e.get('result') == old_pointer and e.get('size') == 128 for e in events)
                and any(e.get('api') == 'HeapSize' and e.get('pointer') == old_pointer
                        and e.get('result') == e.get('mirror_capacity') == 128 for e in events),
                'old atexit capacity not established')
        state, process = report['dll_process_state'], report['process_profile_at_end']
        require(state['argc'] == 1 and len(state['argv_values_hex']) == 1 and state['argv_sentinel'] == 0
                and len(state['environment_values_hex']) == env_count and state['environment_acp_block'] == 0
                and state['environment_initialized'] == 1 and state['lowio_records'] == 32
                and state['attach_counter'] == 0 and state['commandline_pointer'] == process['pointer'],
                'process state differs')
        require(process['calls'] == 1 and process['memory_unchanged'] is True
                and process['host_argv_imported'] is False and process['host_environment_imported'] is False
                and process['environment_live_allocations'] == 0 and report['process_profile_retired'] is True,
                'process ownership differs')
        require(report['crt_host_backing_after_cleanup'] == dict(slots=0, locks=0, heap_blocks=0,
                unadopted_heap_blocks=0, pending_callbacks=0, interrupted_callbacks=0)
                and all(report[k] == 0 for k in ['sync_handles_after_cleanup', 'open_host_handles_after_cleanup',
                                                 'diagnostic_pipe_handles_after_cleanup'])
                and all(report[k] == [] for k in ['sync_cleanup_errors', 'sync_events', 'interrupted_callbacks',
                                                 'unstarted_callbacks_at_end'])
                and report['emulated_live_count_after_host_cleanup'] == remaining, 'cleanup facts differ')
        callbacks = [r['callback'] for r in events if r.get('api') == 'host_cleanup_native_callback_completed']
        require(callbacks == [0xCA9026, 0x100F5E10], 'native FLS callbacks differ')
    require(native['oracles'] == expected_profiles, 'manifest facts do not match validated profiles')
    expected_attempts = ['attempts/' + name + '.json' for name in
                         ['001', '002', '003', '005', '006', '007', '008', '009', '010', 'adapter_checks_001']]
    require(native['preserved_attempts'] == expected_attempts
            and all(name in native['files'] for name in expected_attempts), 'historical attempts not preserved')
    facts = dict(native_preparation_files=55, recorded_checks=300, static_or_adapter_checks=287,
                 windows_x86_leaf_checks=13, windows_x86_leaf_profiles=3, final_profiles=expected_profiles,
                 native_stop='HeapReAlloc: atexit buffer 128 to 256 bytes',
                 dll_entry_started=True, dll_process_attach_returned=False, dll_main_reached=False,
                 module_handle_published=False, rads_initialize_reached=False, ini_entered=True,
                 ini_returned=False, provider_returned=False, native_teardown_complete=False,
                 host_hygiene_passed=True, historical_attempts_preserved=10,
                 address_counts_are_before_host_cleanup=True,
                 native_sync_creation_reached=False, isolated_sync_checks=15,
                 original_exe_sha256=PE_SHA, original_dll_sha256=DLL_SHA)
    next_action = (
        'Reprendre la vraie frontiere HeapReAlloc de RiotRadsIO.dll : qualifier une nouvelle reserve '
        'invitée dans une copie scratch neuve, la croissance atexit de 128 a 256 octets, les donnees, '
        'la propriete et l\'identite du pointeur avec le vrai Win32, sans supposer une croissance sur place. '
        'Poursuivre ensuite les initialiseurs C++ restants, leurs frontieres synchronisation/ETW, '
        'le retour reel process-attach avant publication du handle, RadsSetLogger/RadsInitialize, '
        'le retour INI8B0630 et provider90B520, fallback et destructions peuplees, puis le raccord Rust '
        'et UI aux 1178 assets natifs deja importes. Conserver la qualification de fermeture du client '
        'normal deja publiee ; poursuivre ensuite tous les domaines et exigences ouverts du plan, '
        'sans declarer le jeu, le provider ou le rendu termines.'
    )
    html_section = (
        '<section id="loading-rads-process-preparation"><h2>Preparation native RADS : processus et CRT</h2>'
        '<p>Deux profils scratch figes atteignent HeapReAlloc lors de la croissance atexit 128 vers 256 octets. '
        'Les retours DLL lowIO, argv et environnement valent 0 ; 5 initialiseurs C et 45 C++ sont revenus, '
        'le 46e C++ est interrompu. 300 controles conserves : 287 statiques/adaptateurs et 13 controles '
        'de la primitive Windows x86 SList, aucun nouveau test Rust.</p>'
        '<p>Adresses distinctes avant nettoyage : vide 19043 dont 5426 DLL ; controle 19127 dont 5514 DLL. '
        'Nettoyage hote reussi, mais 959/962 allocations emulees restent sans destruction native. '
        'Aucun retour attach, aucun handle publie, aucun RadsInitialize ni retour INI/provider ; '
        'integration et completion restent fausses. Revue statique et revue finale archivees.</p>'
        '<p><a href="loading_rads_process_preparation_receipt.json">Preuves et limites du lot</a>. '
        'Prochaine etape : qualifier HeapReAlloc reel dans une copie scratch neuve, puis terminer '
        'les initialiseurs et la chaine RADS/INI/provider.</p></section>'
    )
    limits = list(native['limits']) + [
        'No Rust build, client launch, provider integration or rendering was performed by this publication.',
        'Static and final reviews did not independently rerun native profiles or adapter tests.',
        'Only the two final profile reports qualify the pinned common sources; historical attempts remain diagnostic evidence.',
    ]
    return facts, next_action, html_section, limits


def prepare():
    """Read-only: pin all inputs and prepare every byte before publication."""
    require(len(NATIVE_SHA) == 64, 'final native manifest not pinned')
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
    audit = package(W / 'loading_rads_commandline_review', 'static_review/', AUDIT_SHA)
    require(audit['kind'] == 'static_review_only' and audit['native_execution'] is False
            and audit['production_modified'] is False and len(audit['files']) == 5,
            'static audit scope changed')
    for path, row in audit['source_inputs'].items():
        check(path, row['sha256'], row['bytes'])
    review = decode(archives['static_review/REVIEW.json'])
    require(review['source_sha256'] == DLL_SHA and all(review[key] is False for key in
            ['native_execution', 'host_dll_load', 'probe_executed', 'production_modified']), 'review is not static only')
    final_manifest = package(W / 'loading_rads_commandline_final_review', 'final_review/', FINAL_REVIEW_SHA)
    require(final_manifest['kind'] == 'read_only_review_only' and len(final_manifest['files']) == 2
            and final_manifest['native_execution'] is False and final_manifest['production_modified'] is False
            and final_manifest['reviewed_native_manifest_sha256'] == NATIVE_SHA
            and final_manifest['reviewed_static_manifest_sha256'] == AUDIT_SHA, 'final review identity differs')
    final_review = decode(archives['final_review/REVIEW.json'])
    require(final_review['evidence_consistency_passed'] is True and final_review['unresolved_concrete_defects'] == []
            and final_review['frozen_native_manifest_sha256'] == NATIVE_SHA
            and final_review['static_review_manifest_sha256'] == AUDIT_SHA
            and all(final_review[k] is False for k in ['native_execution_by_reviewer',
                'adapter_execution_by_reviewer', 'tests_reexecuted_by_reviewer', 'production_modified']),
            'final review scope/conclusions differ')
    require(len(final_review['verified_files']) == 133, 'final review input count differs')
    for path, row in final_review['verified_files'].items():
        check(path, row['sha256'], row['bytes'])
    audit_raw = archives['static_review/manifest.json']
    require(len(audit_raw) == 1854 and audit_raw.count(b'\r\n') == 50
            and sha_bytes(audit_raw.replace(b'\r\n', b'\n')) ==
            'f08e3142b01e933efd9467a1d2a1b3e897b837988e742f5bc0a79e568b48bda7',
            'static audit CRLF provenance correction differs')

    def read_input(name):
        require(name in native['files'], 'oracle/report is not in frozen native files: ' + name)
        return decode(archives[name])
    facts, next_action, html_section, limits = frozen_facts(native, read_input, check)
    prior = decode(check(R / 'docs/loading_rads_native_preparation_receipt.json', PRIOR_SHA))
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
                   static_audit=(A / 'static_review/manifest.json').relative_to(R).as_posix(),
                   static_audit_sha256=AUDIT_SHA,
                   final_review=(A / 'final_review/manifest.json').relative_to(R).as_posix(),
                   final_review_sha256=FINAL_REVIEW_SHA, final_review_read_only=True,
                   static_audit_hash_correction=copy.deepcopy(final_review['resolved_reporting_issues'][1]),
                   **facts)
    originals, documents, assets = {}, {}, None
    for name in ['coverage.json', 'resume_checkpoint.json', 'completion_plan.json']:
        path = R / 'docs' / name
        raw = path.read_bytes()
        before = decode(raw)
        require(FIELD not in before and before['complete'] is False, 'unexpected document state: ' + name)
        require(before['loading_rads_native_preparation']['manifest_sha256'] == prior['manifest_sha256'], 'previous RADS proof missing')
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
    require(old.count(b'</body>') == 1 and b'id="loading-rads-process-preparation"' not in old, 'HTML marker conflict')
    require(b'id="normal-client-shutdown-validation"' in old, 'shutdown HTML proof missing')
    originals[page] = old
    documents[page] = old.replace(b'</body>', html_section.encode('utf-8') + b'</body>')
    for name in ['install.py', 'verify_published.py', 'README.md']:
        archive(S / name, 'publication/' + name, sha(S / name))
    backup = R / 'docs/plan_history' / ('loading-rads-process-' + now.strftime('%Y%m%dT%H%M%S%fZ'))
    require(not backup.exists(), 'backup collision')
    receipt = dict(summary, summary=summary, kind='frozen_incomplete_rads_process_preparation', archive_verified=True,
                   backup=str(backup), archived_files=archive_rows, verified_inputs=inputs,
                   prior_preparation_receipt_sha256=PRIOR_SHA, shutdown_receipt_sha256=SHUTDOWN_SHA,
                   physical_assets_preserved=assets, domain_statuses_changed=False,
                   rust_test_counts_changed=False, static_audit_is_runtime_qualification=False,
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
    pending = docs_root / ('.loading-rads-process-' + uuid.uuid4().hex)
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
