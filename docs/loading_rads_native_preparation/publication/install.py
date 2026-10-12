"""Archive a frozen, incomplete RADS attach preparation. Never execute probes."""
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
N = W / 'loading_rads_native_probe'
A = R / 'docs/loading_rads_native_preparation'
RECEIPT = R / 'docs/loading_rads_native_preparation_receipt.json'
NATIVE_SHA = 'c3d545178f5f37a25bd331a8af4a6a6cf3b282ba0fa6d118e71594708762f3ea'
AUDIT_SHA = 'b788ebc670a9d8fc8b5364f0029382844dad84d89393920168b31c9d797d1eca'
PE_SHA = '402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
DLL_SHA = '60833cd552d93b93304d4937912951e144e38db5d70793eb60a0c5f5d579e521'
PRIOR_RECEIPT_SHA = '2ec8d6bc0fec17b59fb9d5e0dcd50c40490ac517c169696a21e8f8de01edc327'
FIELD = 'loading_rads_native_preparation'
ASSETS = 'native_champion_loading_assets_import'
NEXT = (
    'Resume the original RiotRadsIO.dll CRT initialization in a fresh confined scratch copy '
    'at the actual GetCommandLineA boundary during process attach, in the same Unicorn x86 '
    'machine as the EXE CRT/provider. Translate pointer-bearing command-line/environment '
    'results into native32 storage with explicit lifetime and a legitimate virtual game '
    'command-line profile; never substitute Python host arguments. Preserve separate EXE/DLL CRT '
    'globals, FLS/TLS namespaces and native callback order. Then qualify DLL lowIO, the five '
    'C and68 C++ static initializer entries and their actual effects, including synchronization '
    'and ETW callbacks where reached; never substitute successful no-ops or fabricated flags. '
    'Complete native attach before publishing its module handle, then execute genuine RADS '
    'exports/logger/manifest loaders, INI8B0630 and the actual provider56 factory90B520/9034D0. '
    'Continue context9063E0/global2D78F20, directory32 population, original '
    '[Package]FallbackPackage selection/recursion, parent905000, hash-index publication and '
    'synchronous visitor90B270. Preserve cache publication90B651 before INI; qualify partial '
    'failure and populated-provider destruction before directory destruction. Integrate proven '
    'contracts into the existing Rust CRT owner/Windows resource manager, then connect real '
    'resources to57D775/57D77A loading UI and rendering. Keep confined Config/Logs and the '
    'no-concurrent-filesystem-mutation condition; host hygiene does not prove native detach '
    'or complete teardown. The1178 imported original files remain available, with provider '
    'connection/rendering false. Full normal startup/shutdown callers, screen factories5765F0, '
    'service publication, actual transport/event delivery, complete UI/audio/gameplay fidelity '
    'and all24 domains,114 tasks and37 supplementary requirements remain. Qualify the '
    'unintegrated GUI shutdown/error-exit proposal separately. No complete screen/game is claimed.'
)


def require(ok, message):
    if not ok:
        raise ValueError(message)


def sha_bytes(raw):
    return hashlib.sha256(raw).hexdigest()


def sha(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def load(path):
    return json.loads(path.read_text(encoding='utf-8-sig'))


def encode(value):
    return (json.dumps(value, ensure_ascii=False, indent=2) + '\n').encode('utf-8')


def inside(root, name):
    rel = PurePosixPath(name)
    require(not rel.is_absolute() and '..' not in rel.parts and ':' not in name
            and '\\' not in name, 'unsafe relative path: ' + name)
    path = root.joinpath(*rel.parts)
    require(path.resolve().is_relative_to(root.resolve()), 'outside root: ' + str(path))
    return path


def prepare():
    """Read-only: build every payload and check all inputs before any write."""
    require(len(NATIVE_SHA) == 64, 'final native manifest not pinned')
    require(not A.exists() and not RECEIPT.exists(), 'preserve existing archive/receipt')
    payloads, inputs, archived = {}, {}, {}

    def check(path, expected, size=None):
        path = Path(path)
        require(path.is_file() and (size is None or path.stat().st_size == size), 'input missing/size changed: ' + str(path))
        require(sha(path) == expected, 'input hash changed: ' + str(path))
        row = {'bytes': path.stat().st_size, 'sha256': expected}
        require(str(path) not in inputs or inputs[str(path)] == row, 'conflicting input')
        inputs[str(path)] = row
        return path

    def archive(path, name, expected, size=None):
        path = check(path, expected, size)
        raw = path.read_bytes()
        require(sha_bytes(raw) == expected, 'source changed while reading')
        target = inside(A, name)
        require(target not in payloads, 'duplicate archive target')
        payloads[target] = raw
        archived[name] = {'source': str(path), 'bytes': len(raw), 'sha256': expected}

    def package(directory, prefix, expected):
        archive(directory / 'manifest.json', prefix + 'manifest.json', expected)
        manifest = load(directory / 'manifest.json')
        seen = set()
        for name, row in manifest['files'].items():
            require(name.casefold() not in seen, 'case-insensitive path collision')
            seen.add(name.casefold())
            archive(inside(directory, name), prefix + name, row['sha256'], row['bytes'])
        return manifest

    native = package(N, '', NATIVE_SHA)
    require(len(native['files']) == 26, 'native frozen file count changed')
    audit_dir = W / 'loading_rads_entry_review'
    audit = package(audit_dir, 'entry_review/', AUDIT_SHA)
    require(audit['complete'] is False and audit['native_execution'] is False
            and audit['production_modified'] is False, 'entry audit is static only')
    require((audit['decoded_function_entries'], audit['c_initializers'], audit['cpp_initializers'])
            == (137, 5, 68), 'static audit counts changed')
    check(audit['source']['path'], DLL_SHA, 1707520)
    for path, expected in audit['consulted_frozen_manifests'].items():
        check(path, expected)

    oracle = load(N / 'rads_provider_oracle.json')
    require(oracle['source_sha256'] == PE_SHA and oracle['passed'] is False
            and all(oracle[k] is False for k in ['complete', 'provider_returned', 'completed_path'])
            and oracle['cleanup_passed'] is True, 'provider stop/final cleanup changed')
    check(oracle['source'], PE_SHA)
    for path, expected in oracle['verified_input_files'].items():
        check(path, expected)
    for name, expected in oracle['generator_hashes'].items():
        check(inside(N, name), expected)
    module = oracle['rads_module']
    check(module['source'], DLL_SHA, 1707520)
    require(module['sha256'] == DLL_SHA and module['state'] == 'attaching'
            and module['image_base'] == 0x10000000 and module['entry'] == 0x100F2C22,
            'attach state changed')
    require(module['events'] == [
        {'operation': 'map', 'base': 0x10000000, 'bytes': 0x1AC000, 'imports': 210},
        {'operation': 'begin_native_attach', 'entry': 0x100F2C22}], 'attach has returned or changed')
    stop = oracle['stop']
    require(stop['kind'] == 'unimplemented_import'
            and stop['import'] == {'dll': 'KERNEL32.dll', 'name': 'GetCommandLineA',
                'iat': 0x10131230, 'iat_rva': 0x131230, 'module': 'RiotRadsIO.dll',
                'module_base': 0x10000000}, 'native stop changed')
    instructions = oracle['executed_instruction_addresses']
    require(len(instructions) == len(set(instructions)) == 14229
            and sum(0x10000000 <= pc < 0x101AC000 for pc in instructions) == 612,
            'DLL instruction count changed')
    require(all(pc not in instructions for pc in [0x9529FA, 0x1003E3D0, 0x100FF7A8, 0x100FB602]),
            'module publication, RadsInitialize, user DllMain or DLL lowIO reached')
    require([(x['entry'], x['result']) for x in oracle['crt_phases']]
            == [('CA92CB', 1), ('CAFF53', 0)], 'EXE CRT results changed')
    require(oracle['crt_host_backing_after_cleanup'] == {
                'slots': 0, 'locks': 0, 'heap_blocks': 0, 'unadopted_heap_blocks': 0,
                'pending_callbacks': 0, 'interrupted_callbacks': 0}
            and oracle['interrupted_callbacks'] == [] and oracle['unstarted_callbacks_at_end'] == []
            and oracle['open_host_handles_after_cleanup'] == 0
            and oracle['diagnostic_pipe_handles_after_cleanup'] == 0,
            'final host backing not retired')
    require(oracle['emulated_live_count_after_host_cleanup'] == 928,
            'native allocations remaining changed')
    callbacks = [x for x in oracle['crt_events'] if x.get('api') == 'host_cleanup_native_callback_completed']
    require([x['callback'] for x in callbacks] == [0xCA9026, 0x100F5E10]
            and all(x['reason'] == 'actual Windows FLS callback' for x in callbacks),
            'two genuine FLS cleanup callbacks not observed in order')
    require(len(oracle['diagnostic_pipe_events']) == 1
            and oracle['diagnostic_pipe_events'][0]['data_operations'] == 0
            and oracle['diagnostic_pipe_events'][0]['bytes_written'] == 0
            and oracle['diagnostic_pipe_events'][0]['last_error'] == 2,
            'pipe profile changed')
    attempt = load(N / 'attempts/001.json')
    require('attempts/001.json' in native['files'] and 'attempts/002.json' in native['files']
            and attempt['cleanup_passed'] is False
            and attempt['stop']['import']['name'] == 'GetCommandLineA',
            'historical cleanup failure must remain preserved')
    counts = {'loader_structure_tests.json': 21, 'io_isolation_tests.json': 36,
              'logs_bridge_tests.json': 23, 'crt_heap_ownership_tests.json': 9,
              'slot_namespaces_tests.json': 12, 'callback_batch_tests.json': 8}
    for name, count in counts.items():
        report = load(N / name)
        require(report['passed'] is True and report.get('error') is None
                and report['check_count'] == len(report['checks']) == count, 'check report changed: ' + name)
        for source, expected in report.get('source_hashes', {}).items():
            check(inside(N, source), expected)
        if name in ['loader_structure_tests.json', 'slot_namespaces_tests.json', 'callback_batch_tests.json']:
            require(report['native_execution'] is False, 'adapter/static checks are not native execution')
    require(native['kind'] == 'partial_original_x86_RADS_attach'
            and all(native[k] is False for k in ['integrated', 'complete', 'rust_compiled',
                'provider_complete', 'dll_attached']) and native['host_cleanup_passed'] is True,
            'frozen native preparation scope changed')
    require(native['tests'] == counts and native['native_dll_addresses_at_stop'] == 612
            and native['native_addresses_at_stop'] == 14229
            and native['native_stop'] == 'GetCommandLineA at100F2AE9 before supplying command line',
            'frozen native qualification changed')
    require(native['source_dll_sha256'] == DLL_SHA and native['source_exe_sha256'] == PE_SHA
            and Path(native['source_dll']) == Path(module['source'])
            and Path(native['source_exe']) == Path(oracle['source']), 'manifest provenance differs')
    prior_manifest = W / 'loading_provider_crt_integration/manifest.json'
    require(native['prior_manifest_sha256'] == 'c3a585b8ec8fd5e1b9859680fdbc7e588563be1c9d1c42e24b3c4a0c978fd486',
            'prior manifest differs')
    check(prior_manifest, native['prior_manifest_sha256'])
    for name, row in load(prior_manifest)['files'].items():
        check(inside(prior_manifest.parent, name), row['sha256'], row['bytes'])

    prior_path = check(R / 'docs/loading_provider_crt_preparation_receipt.json', PRIOR_RECEIPT_SHA)
    prior = load(prior_path)
    require(prior['complete'] is False and prior['integrated'] is False, 'prior receipt changed')
    now = datetime.datetime.now(datetime.timezone.utc)
    backup = R / 'docs/plan_history' / ('loading-rads-native-' + now.strftime('%Y%m%dT%H%M%S%fZ'))
    require(not backup.exists(), 'backup collision')
    summary = {
        'saved_utc': now.isoformat(), 'receipt': RECEIPT.relative_to(R).as_posix(),
        'manifest': (A / 'manifest.json').relative_to(R).as_posix(), 'manifest_sha256': NATIVE_SHA,
        'integrated': False, 'complete': False, 'dll_mapped': True, 'dll_entry_started': True,
        'dll_process_attach_returned': False, 'dll_main_reached': False, 'dll_lowio_reached': False,
        'module_handle_published': False, 'rads_initialize_reached': False, 'rads_initialize_completed': False,
        'ini_read': False, 'provider_returned': False, 'provider_connected': False, 'rendered': False,
        'stop': 'RiotRadsIO.dll process attach: GetCommandLineA', 'dll_instruction_addresses': 612,
        'structure_checks': 21, 'filesystem_pipe_checks': 59, 'heap_ownership_checks': 9,
        'real_fls_tls_namespace_checks': 12, 'python_callback_queue_checks': 8,
        'categorized_bridge_checks_total': 109,
        'new_rust_tests': 0, 'rust_compiled': False,
        'client_executed': False, 'final_host_cleanup_passed': True,
        'genuine_fls_cleanup_callbacks_completed': ['CA9026', '100F5E10'],
        'historical_first_cleanup_passed': False, 'native_teardown_complete': False,
        'emulated_allocations_remaining_after_host_hygiene': 928,
        'entry_static_audit': (A / 'entry_review/manifest.json').relative_to(R).as_posix(),
        'entry_static_audit_sha256': AUDIT_SHA,
    }
    originals, docs, assets = {}, {}, None
    for name in ['coverage.json', 'resume_checkpoint.json', 'completion_plan.json']:
        path = R / 'docs' / name
        old = path.read_bytes(); before = json.loads(old.decode('utf-8-sig'))
        require(FIELD not in before and before['complete'] is False, 'unexpected document state')
        require(before['loading_provider_crt_preparation']['manifest_sha256']
                == prior['manifest_sha256'], 'previous preparation missing')
        a = before[ASSETS]
        require((a['champions'], a['files'], a['images'], a['inibin']) == (122, 1178, 720, 458)
                and a['physical_import_verified'] is True
                and all(a[k] is False for k in ['complete', 'provider_connected', 'rendered']), 'assets changed')
        require(assets is None or assets == a, 'inconsistent assets'); assets = copy.deepcopy(a)
        after = copy.deepcopy(before)
        after.update({FIELD: copy.deepcopy(summary), 'next_action': NEXT, 'updated_utc': now.isoformat()})
        allowed = {FIELD, 'next_action', 'updated_utc'}
        if name == 'resume_checkpoint.json':
            require(before['state'] == 'active' and 'in_progress' not in before, 'checkpoint not active')
            require('Do not repeat' in before['communication_preferences']['progress_dashboard_repetition'], 'preference missing')
            after['saved_utc'] = now.isoformat(); allowed.add('saved_utc')
        if name == 'completion_plan.json':
            require(len(before['domains']) == 24 and sum(len(x['tasks']) for x in before['domains']) == 114,
                    'plan scope changed')
            require(before['next_execution_steps'][0] == before['next_action'], 'plan head differs')
            after['next_execution_steps'][0] = NEXT; allowed.add('next_execution_steps')
            require(after['next_execution_steps'][1:] == before['next_execution_steps'][1:], 'plan tail changed')
            for old_domain, domain in zip(before['domains'], after['domains']):
                if domain['id'] in ['02', '17']:
                    links = domain.setdefault('progress_evidence', [])
                    require(isinstance(links, list), 'domain evidence not list')
                    if summary['receipt'] not in links: links.append(summary['receipt'])
                    require({k: v for k, v in old_domain.items() if k != 'progress_evidence'}
                            == {k: v for k, v in domain.items() if k != 'progress_evidence'}, 'domain state changed')
                else: require(domain == old_domain, 'unrelated domain changed')
            allowed.add('domains')
        require({k: v for k, v in before.items() if k not in allowed}
                == {k: v for k, v in after.items() if k not in allowed}, 'unrelated evidence/state changed')
        originals[path] = old; docs[path] = encode(after)
    check(inside(R, assets['manifest']), assets['manifest_sha256'])
    asset_receipt = check(inside(R, assets['receipt']),
        '3b6c9045619956bd1b6d7b2c72a53fd2f4c216add93a65bbf7bc59766944c06f')
    asset_evidence = load(asset_receipt)
    require(all(asset_evidence[k] == v for k, v in assets.items()), 'asset receipt mismatch')
    plan = R / 'docs/completion_plan.html'; old = plan.read_bytes()
    require(old.count(b'</body>') == 1 and b'id="loading-rads-native-preparation"' not in old, 'HTML marker invalid')
    section = (
        '<section id="loading-rads-native-preparation"><h2>Initialisation native de RiotRadsIO.dll</h2>'
        '<p>La DLL x86 est mappée dans le même émulateur que le client original ; 612 adresses '
        'd’instructions DLL sont exécutées depuis l’entrée CRT100F2C22. Le DllMain applicatif '
        '100FF7A8 et le lowIO de la DLL100FB602 ne sont pas atteints. '
        'L’attachement s’arrête sur GetCommandLineA : '
        'aucun retour réussi d’attachement ni handle publié, aucune initialisation RADS, '
        'lecture INIBIN ou création complète du fournisseur.</p>'
        '<p>21 contrôles de structure, 59 du pont fichiers/pipe, 9 de propriété du tas et '
        '12 des espaces FLS/TLS passent, ainsi que 8 contrôles Python des files de callbacks '
        'avec réentrance et erreurs injectées. La première tentative avec nettoyage en échec est '
        'conservée ; le nettoyage hôte final réussit. 928 allocations émulées restent, '
        'sans destruction native complète. L’audit des initialiseurs est statique.</p>'
        '<p>Prochaine étape : reprendre le CRT de la DLL à GetCommandLineA, puis ses '
        'initialiseurs, RADS, INI, fournisseurs, fallback et destruction avant raccordement Rust/UI. '
        'Les 1178 ressources importées, le plan et les preuves antérieures sont conservés. '
        'Aucun nouveau test Rust, domaine terminé ou rendu complet n’est revendiqué.</p>'
        '<p><a href="loading_rads_native_preparation_receipt.json">Reçu de préparation</a></p></section>'
    ).encode('utf-8')
    originals[plan] = old; docs[plan] = old.replace(b'</body>', section + b'</body>')
    for name in ['install.py', 'README.md']:
        archive(S / name, 'publication/' + name, sha(S / name))
    payloads.update(docs)
    receipt = {**summary, 'kind': 'frozen_incomplete_native_attach_preparation',
        'archive_verified': True, 'backup': str(backup), 'archived_files': archived,
        'verified_inputs': inputs, 'prior_preparation_receipt_sha256': PRIOR_RECEIPT_SHA,
        'physical_assets_preserved': assets, 'domain_statuses_changed': False,
        'rust_test_counts_changed': False, 'entry_audit_is_runtime_qualification': False,
        'limits': oracle['limits'] + [
            '21 loader checks are structural, with no native execution.12 slot checks use real OS FLS/TLS and no emulated DLL instructions.',
            '8 Python callback-queue checks cover adapter reentrancy and injected faults only; they do not qualify native callback fault/SEH recovery.',
            'Callback records retained after a fault are diagnostic ownership evidence only; no native resumption after host backing release is qualified.',
            'The entry audit statically decodes137 function entries and inventories5 C/68 C++ initializers. It does not qualify all descendants, synchronization/ETW effects or native detach.',
            'Primitive allocation/memory/atexit boundaries and translated host handles remain explicit. Host cleanup after interrupted attach is not native CRT/provider teardown.',
            'Successful CREATE_ALWAYS/TRUNCATE_EXISTING and hostile concurrent filesystem mutations remain unqualified. No full provider, UI or game completion.',
        ], 'next_action': NEXT,
        'original_document_sha256': {p.relative_to(R).as_posix(): sha_bytes(b) for p, b in originals.items()},
        'published_document_sha256': {p.relative_to(R).as_posix(): sha_bytes(b) for p, b in docs.items()},
        'transaction_limits': 'Per-file atomic replacement/caught-exception rollback only; no cross-file power-loss atomicity or concurrent-writer guarantee. Receipt last; retain backups/empty directories on failure.'}
    payloads[RECEIPT] = encode(receipt)
    for path, raw in payloads.items():
        require(path.resolve().is_relative_to((R / 'docs').resolve()), 'publication outside docs')
        if path not in originals:
            require(not path.exists(), 'new target already exists'); originals[path] = None
        if path.suffix == '.json': json.loads(raw.decode('utf-8-sig'))
    require(list(payloads)[-1] == RECEIPT, 'receipt must be last')
    return payloads, originals, inputs, backup, summary


def replace_exact(path, raw):
    path.parent.mkdir(parents=True, exist_ok=True)
    temp = path.with_name(path.name + '.rads-' + uuid.uuid4().hex + '.tmp')
    try:
        with temp.open('xb') as stream: stream.write(raw); stream.flush()
        require(temp.read_bytes() == raw, 'temporary mismatch')
        temp.replace(path)
        require(path.read_bytes() == raw, 'publication mismatch')
    finally:
        if temp.exists(): temp.unlink()


def publish(payloads, originals, inputs, backup):
    for name, row in inputs.items():
        path = Path(name)
        require(path.stat().st_size == row['bytes'] and sha(path) == row['sha256'], 'input changed: ' + name)
    for path, raw in originals.items():
        require((path.read_bytes() if path.exists() else None) == raw, 'destination changed')
    require(not A.exists() and not RECEIPT.exists() and not backup.exists(), 'publication collision')
    backup.mkdir(parents=True)
    for path, raw in originals.items():
        if raw is not None:
            saved = inside(backup, path.relative_to(R / 'docs').as_posix())
            saved.parent.mkdir(parents=True, exist_ok=True); saved.write_bytes(raw)
            require(saved.read_bytes() == raw, 'backup mismatch')
    changed = []
    try:
        for path, raw in payloads.items():
            require((path.read_bytes() if path.exists() else None) == originals[path], 'destination changed during publication')
            changed.append(path); replace_exact(path, raw)
    except BaseException as primary:
        failures = []
        for path in reversed(changed):
            try:
                if originals[path] is None: path.unlink(missing_ok=True)
                else: replace_exact(path, originals[path])
            except BaseException as cleanup: failures.append(cleanup)
        if failures: raise BaseExceptionGroup('Publication and rollback failed; retain backups', [primary, *failures])
        raise


def main():
    require(len(NATIVE_SHA) == 64 and sys.argv[1:] == [NATIVE_SHA], 'explicit frozen manifest SHA required')
    payloads, originals, inputs, backup, summary = prepare()
    publish(payloads, originals, inputs, backup)
    print(json.dumps(summary, ensure_ascii=False))


if __name__ == '__main__':
    main()
