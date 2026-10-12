"""Publish frozen CRT preparation only. Does not run any provider, probe or compiler.

The parent must review this script and invoke it explicitly with the pinned CRT
manifest SHA. All source/document checks finish before the first filesystem write.
"""
from pathlib import Path, PurePosixPath
import copy
import datetime
import hashlib
import html
import json
import sys
import uuid

S = Path(__file__).resolve().parent
W = Path('E:/mapslol3v3')
R = Path('E:/OpenLeague')
A = R / 'docs/loading_provider_crt_preparation'
RECEIPT = R / 'docs/loading_provider_crt_preparation_receipt.json'
CRT = W / 'loading_provider_crt_integration'
CRT_SHA = 'c3a585b8ec8fd5e1b9859680fdbc7e588563be1c9d1c42e24b3c4a0c978fd486'
SEM_SHA = 'b6a75c6820c67f903e007a960e86dcff8ad2362927e121fe56dd98716a6dd0f1'
RADS_SHA = 'ccb4ef66d7e34406f3d039b6d8254a93cafe3783b86e7aab60a782cfc3145d78'
PE_SHA = '402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
DLL_SHA = '60833cd552d93b93304d4937912951e144e38db5d70793eb60a0c5f5d579e521'
READINESS_SHA = '924ed4867ce7e26d9349af4d841b0d5db4627a4b0fa2fc0e0cc75af1d819b183'
LOWIO = {
    'extract_lowio.py': '9d70f854195237dde529e5147fd8cf8f908b1c1e6dd46f9e7a81cf7d0ea00329',
    'lowio_disassembly.txt': 'd14b1ae4c5d8bec1e39b3930a8bfbc155201d867c76189199c1fae10be5f9f42',
    'lowio_source.json': 'f1d2a2edde94b2aafafdc1b198f1584171bb9f48263bf047c005d2f6808d7acb',
    'README.md': '25d511a4a1e7381804347fcf16f2e508284311e86516bdcd63626fa4c9a98bf2',
}
FIELD = 'loading_provider_crt_preparation'
ASSET_FIELD = 'native_champion_loading_assets_import'
NEXT = (
    'Continue in a fresh confined scratch copy by mapping and initializing the original x86 '
    'RiotRadsIO.dll inside the same Unicorn machine as the real CRT/provider execution. '
    'Qualify PE imports, relocations, entry/lifetime and real RADS exports; do not substitute '
    'a host64 LoadLibrary result, invented module handle or INI/provider result. The frozen '
    'run completed CA92CB=1 and CAFF53=0, then stopped at actual LoadLibraryA/9529F4 before '
    'DLL execution or INIBIN read. Preserve canonical process/thread/lowIO state, explicit '
    'primitive boundaries, confined Config/Logs and the no-concurrent-filesystem-mutation '
    'condition. Then resume actual INI8B0630, provider56 factory90B520/9034D0, '
    'context9063E0/global2D78F20 and directory32 population, original [Package]FallbackPackage '
    'selection/recursion, parent905000, hash-index publication and synchronous visitor90B270. '
    'Preserve cache publication at90B651 before INI and qualify partial failure, recursion '
    'and populated-provider destruction before directory destruction. Integrate only proven '
    'contracts into the existing Rust CRT owner and Windows resource manager, then connect '
    'real resources to57D775/57D77A loading UI and rendering. The1178 imported original files '
    'remain available; their provider connection and rendering remain false. Full normal '
    'startup/shutdown callers, screen selection/factories5765F0, service-global publication, '
    'actual transport/event delivery, complete UI/audio/gameplay fidelity and all24 domains, '
    '114 tasks and37 supplementary requirements remain. Qualify the unintegrated GUI '
    'shutdown/error-exit proposal separately. No complete screen or game is claimed.'
)
ERRATUM = (
    '90B270 synchronously visits active entries and destroys its by-value callable; it does '
    'not register a persistent callback. Earlier frozen prose is preserved as historical '
    'evidence and superseded by semantics/semantics_review.json for this interpretation.'
)


def require(condition, message):
    if not condition:
        raise ValueError(message)


def digest(data):
    return hashlib.sha256(data).hexdigest()


def sha(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def encoded(value):
    return (json.dumps(value, ensure_ascii=False, indent=2) + '\n').encode('utf-8')


def load(path):
    return json.loads(path.read_text(encoding='utf-8-sig'))


def inside(root, relative):
    rel = PurePosixPath(relative)
    require(not rel.is_absolute() and '..' not in rel.parts and '\\' not in relative
            and ':' not in relative, 'unsafe relative path: ' + relative)
    p = root.joinpath(*rel.parts)
    require(p.resolve().is_relative_to(root.resolve()), 'outside root: ' + str(p))
    return p


def prepare():
    """Read-only preparation; publication is a separate explicit operation."""
    require(not A.exists() and not RECEIPT.exists(), 'archive/receipt already exists; preserve it')
    payloads, inputs, archives = {}, {}, {}

    def checked(path, expected, size=None):
        path = Path(path)
        require(path.is_file(), 'missing input: ' + str(path))
        actual_size = path.stat().st_size
        require(size is None or actual_size == size, 'input size changed: ' + str(path))
        require(sha(path) == expected, 'input hash changed: ' + str(path))
        metadata = {'bytes': actual_size, 'sha256': expected}
        require(str(path) not in inputs or inputs[str(path)] == metadata, 'conflicting input')
        inputs[str(path)] = metadata
        return path

    def archive(source, relative, expected, size=None):
        source = checked(source, expected, size)
        raw = source.read_bytes()
        require(digest(raw) == expected, 'input changed while reading: ' + str(source))
        target = inside(A, relative)
        require(target not in payloads, 'duplicate archive target: ' + str(target))
        payloads[target] = raw
        archives[relative] = {'source': str(source), 'bytes': len(raw), 'sha256': expected}

    def package(directory, prefix, expected):
        manifest = checked(directory / 'manifest.json', expected)
        data = load(manifest)
        require(data['integrated'] is False, 'package already integrated')
        archive(manifest, prefix + 'manifest.json', expected)
        names = set()
        for rel, row in data['files'].items():
            require(rel.casefold() not in names, 'case-insensitive package path collision')
            names.add(rel.casefold())
            archive(inside(directory, rel), prefix + rel, row['sha256'], row['bytes'])
        return data

    crt = package(CRT, '', CRT_SHA)
    require(crt['complete'] is False and crt['rust_compiled'] is False, 'CRT scope changed')
    q = crt['qualification']
    require(q == {
        'bridge_checks': 59, 'bridge_heap_fault_checks': 9,
        'native_crt_thread_startup': True, 'native_low_io_startup': True,
        'provider_returned': False, 'ini_read': False, 'dll_loaded': False,
        'ipc_data_operations': 0, 'host_cleanup_passed': True,
        'stop': '9529F4 LoadLibraryA mapped original RiotRadsIO.dll',
        'native_lifecycle_complete': False,
    }, 'unexpected CRT qualification schema')
    require(crt['source_pe']['sha256'] == PE_SHA and crt['dll']['dll_sha256'] == DLL_SHA,
            'native provenance changed')
    checked(crt['source_pe']['path'], PE_SHA)
    checked(crt['dll']['dll'], DLL_SHA, 1707520)
    require(crt['dll']['machine'] == '0x14c', 'DLL is not x86')
    for path, expected in crt['verified_external_inputs'].items():
        checked(path, expected)
    require(len(crt['files']) == 34 and len(crt['verified_external_inputs']) == 36,
            'frozen CRT inventory changed')

    oracle = load(CRT / 'crt_provider_oracle.json')
    require(oracle['source_sha256'] == PE_SHA and oracle['passed'] is False
            and oracle['complete'] is False and oracle['provider_returned'] is False
            and oracle['completed_path'] is False and oracle['cleanup_passed'] is True,
            'stop must not become a completed provider claim')
    require(oracle['verified_input_files'] == crt['verified_external_inputs'], 'oracle inputs changed')
    require([(p['entry'], p['result']) for p in oracle['crt_phases']]
            == [('CA92CB', 1), ('CAFF53', 0)], 'native CRT phase order/results changed')
    require(oracle['crt_phases'][1]['lowio_allocated'] == 32, 'lowIO block count changed')
    stop = oracle['stop']
    require(stop['kind'] == 'unimplemented_import'
            and stop['import'] == {'dll': 'KERNEL32.dll', 'name': 'LoadLibraryA', 'iat': 0xFA43D4}
            and stop['path'].endswith('\\RADS\\RiotRadsIO.dll'), 'unexpected native stop')
    require(oracle['open_host_handles_after_cleanup'] == 0
            and oracle['diagnostic_pipe_handles_after_cleanup'] == 0
            and oracle['crt_host_backing_after_cleanup'] == {
                'slots': 0, 'locks': 0, 'heap_blocks': 0,
                'unadopted_heap_blocks': 0, 'pending_callbacks': 0}, 'host cleanup changed')
    require((len(oracle['executed_instruction_addresses']), len(oracle['allocations']),
             len(oracle['frees']), oracle['emulated_live_count_after_host_cleanup'])
            == (13629, 1916, 987, 928), 'native observation counts changed')
    require(len(oracle['diagnostic_pipe_events']) == 1, 'unexpected pipe attempt count')
    pipe = oracle['diagnostic_pipe_events'][0]
    require(pipe['succeeded'] is False and pipe['last_error'] == 2
            and pipe['data_operations'] == 0 and pipe['bytes_written'] == 0, 'pipe scope changed')
    for report, count in [('io_isolation_tests.json', 36), ('logs_bridge_tests.json', 23),
                          ('crt_heap_ownership_tests.json', 9)]:
        item = load(CRT / report)
        require(item['passed'] is True and item['error'] is None
                and item['check_count'] == len(item['checks']) == count, 'bridge checks changed')
        for rel, expected in item.get('source_hashes', {}).items():
            checked(inside(CRT, rel), expected)
    for rel, expected in oracle['generator_hashes'].items():
        checked(inside(CRT, rel), expected)

    sem = package(W / 'loading_provider_semantics_review', 'semantics/', SEM_SHA)
    require(sem['source_sha256'] == PE_SHA and sem['complete'] is False
            and all(sem[k] is False for k in ['native_executed', 'probes_with_io_executed',
                                             'compiler_executed', 'production_modified']),
            'semantics is static only')
    for path, row in sem['source_inputs'].items():
        checked(path, row['sha256'], row['bytes'])
    archive(W / 'loading_provider_rust_readiness/readiness.json',
            'readiness/readiness.json', READINESS_SHA)
    readiness = load(W / 'loading_provider_rust_readiness/readiness.json')
    require(readiness['native_source']['sha256'] == PE_SHA
            and all(readiness[k] is False for k in ['complete', 'production_changed',
                'rust_compiled', 'client_executed', 'native_probe_executed']), 'readiness scope changed')
    evidence = readiness['evidence']
    checked(evidence['core_log']['path'], evidence['core_log']['sha256'])
    for row in evidence['historical_client_tests'] + evidence['native_fixtures']:
        checked(row['path'], row['sha256'])
    for rel, expected in evidence['source_hashes_at_read'].items():
        checked(inside(R, rel), expected)
    for rel, expected in LOWIO.items():
        archive(W / 'loading_lowio_source_review' / rel, 'lowio/' + rel, expected)
    lowio = load(W / 'loading_lowio_source_review/lowio_source.json')
    require(lowio['source_sha256'] == PE_SHA
            and all(lowio[k] is False for k in ['execution_performed', 'rust_compiled',
                                               'production_integrated']), 'lowIO scope changed')
    checked(lowio['source_extractor'], lowio['source_extractor_sha256'])
    for region in lowio['functions'] + lowio['data'] + [lowio['caller_fragment']]:
        raw = bytes.fromhex(region['hex'])
        require(len(raw) == region['size'] and digest(raw) == region['sha256'], 'lowIO region corrupt')

    rads = package(W / 'loading_rads_loader_next', 'rads_next/', RADS_SHA)
    require(rads['native_execution'] is False and rads['source_dll_sha256'] == DLL_SHA
            and rads['source_exe_sha256'] == PE_SHA, 'RADS analysis is static only')
    loader = load(W / 'loading_rads_loader_next/loader_inventory.json')
    require(loader['native_execution'] is False and loader['dll_sha256'] == DLL_SHA
            and loader['exe_sha256'] == PE_SHA and loader['machine'] == 0x14C
            and loader['image_base'] == 0x10000000 and loader['image_size'] == 0x1AC000
            and len(loader['imports']) == 7
            and sum(len(x['symbols']) for x in loader['imports']) == 210
            and loader['tls'] is None and loader['delay_imports'] == [], 'RADS inventory changed')

    now = datetime.datetime.now(datetime.timezone.utc)
    backup = R / 'docs/plan_history' / ('loading-provider-crt-' + now.strftime('%Y%m%dT%H%M%S%fZ'))
    require(not backup.exists(), 'backup collision')
    summary = {
        'saved_utc': now.isoformat(), 'receipt': RECEIPT.relative_to(R).as_posix(),
        'manifest': (A / 'manifest.json').relative_to(R).as_posix(),
        'manifest_sha256': CRT_SHA, 'integrated': False, 'complete': False,
        'new_rust_tests': 0, 'rust_compiled': False, 'client_executed': False,
        'native_provider_returned': False, 'ini_read': False, 'dll_loaded': False,
        'provider_connected': False, 'rendered': False,
        'native_crt_returns': {'CA92CB': 1, 'CAFF53': 0},
        'bridge_checks': 59, 'bridge_heap_fault_checks': 9,
        'stop': q['stop'], 'host_cleanup_passed': True, 'native_lifecycle_complete': False,
        'emulated_allocations_remaining_after_host_hygiene': 928,
        'semantics_static_audit': (A / 'semantics/manifest.json').relative_to(R).as_posix(),
        'readiness_static_audit': (A / 'readiness/readiness.json').relative_to(R).as_posix(),
        'lowio_static_audit': (A / 'lowio/lowio_source.json').relative_to(R).as_posix(),
        'rads_static_preparation': (A / 'rads_next/manifest.json').relative_to(R).as_posix(),
        'rads_manifest_sha256': RADS_SHA, 'erratum': ERRATUM,
    }
    originals, documents = {}, {}
    asset_summary = None
    allowed = {FIELD, 'next_action', 'updated_utc'}
    for name in ['coverage.json', 'resume_checkpoint.json', 'completion_plan.json']:
        path = R / 'docs' / name
        original = path.read_bytes()
        before = json.loads(original.decode('utf-8-sig'))
        require(FIELD not in before and before['complete'] is False, 'unexpected document state')
        require(isinstance(before['next_action'], str) and before['next_action'], 'missing next action')
        assets = before[ASSET_FIELD]
        require((assets['champions'], assets['files'], assets['images'], assets['inibin'])
                == (122, 1178, 720, 458) and assets['physical_import_verified'] is True
                and all(assets[k] is False for k in ['complete', 'provider_connected', 'rendered']),
                'physical assets/status changed')
        require(asset_summary is None or asset_summary == assets, 'inconsistent asset summaries')
        asset_summary = copy.deepcopy(assets)
        after = copy.deepcopy(before)
        after[FIELD] = copy.deepcopy(summary)
        after['next_action'] = NEXT
        after['updated_utc'] = now.isoformat()
        allowed_here = set(allowed)
        if name == 'resume_checkpoint.json':
            require(before['state'] == 'active' and 'in_progress' not in before, 'checkpoint not active')
            require('Do not repeat' in before['communication_preferences']['progress_dashboard_repetition'],
                    'missing communication preference')
            after['saved_utc'] = now.isoformat()
            allowed_here.add('saved_utc')
        if name == 'completion_plan.json':
            require(len(before['domains']) == 24
                    and sum(len(d['tasks']) for d in before['domains']) == 114, 'plan scope changed')
            require(before['next_execution_steps'][0] == before['next_action'], 'plan head differs')
            after['next_execution_steps'][0] = NEXT
            allowed_here.add('next_execution_steps')
            require(after['next_execution_steps'][1:] == before['next_execution_steps'][1:], 'plan tail changed')
            for old_domain, new_domain in zip(before['domains'], after['domains']):
                if old_domain['id'] in ['02', '17']:
                    links = new_domain.setdefault('progress_evidence', [])
                    require(isinstance(links, list), 'domain evidence is not a list')
                    if summary['receipt'] not in links:
                        links.append(summary['receipt'])
                    require({k: v for k, v in old_domain.items() if k != 'progress_evidence'}
                            == {k: v for k, v in new_domain.items() if k != 'progress_evidence'},
                            'domain state changed')
                else:
                    require(old_domain == new_domain, 'unrelated domain changed')
            allowed_here.add('domains')
        require({k: v for k, v in before.items() if k not in allowed_here}
                == {k: v for k, v in after.items() if k not in allowed_here}, 'unrelated fields changed')
        require(after[ASSET_FIELD] == assets, 'assets changed')
        originals[path] = original
        documents[path] = encoded(after)
    checked(inside(R, asset_summary['manifest']), asset_summary['manifest_sha256'])
    asset_receipt = checked(inside(R, asset_summary['receipt']),
        '3b6c9045619956bd1b6d7b2c72a53fd2f4c216add93a65bbf7bc59766944c06f')
    asset_evidence = load(asset_receipt)
    for key, value in asset_summary.items():
        require(asset_evidence[key] == value, 'asset receipt/summary mismatch: ' + key)

    plan_html = R / 'docs/completion_plan.html'
    original_html = plan_html.read_bytes()
    require(original_html.count(b'</body>') == 1 and b'id="loading-provider-crt-preparation"' not in original_html,
            'HTML insertion marker invalid')
    section = (
        '<section id="loading-provider-crt-preparation"><h2>Préparation du fournisseur natif : CRT et RADS</h2>'
        '<p>Dans le même émulateur x86, CA92CB retourne 1 et CAFF53 retourne 0. '
        '59 contrôles du pont fichiers/pipe et 9 contrôles de propriété du tas passent. '
        'Le parcours du fournisseur s’arrête à LoadLibraryA sur RiotRadsIO.dll ; la DLL et '
        'le contenu INIBIN ne sont pas exécutés/lus dans cette preuve.</p>'
        '<p>Le nettoyage hôte est vérifié ; 928 allocations émulées restent après cet arrêt, '
        'sans destruction native complète. Les limites des primitives et de l’isolation '
        'restent explicites. Les audits de sémantique, de raccordement Rust, de lowIO et '
        'du chargeur RADS sont statiques. Aucun nouveau test Rust ni raccordement UI n’est revendiqué.</p>'
        '<p>Correction : 90B270 visite les entrées synchroniquement puis détruit son callable temporaire.</p>'
        '<p>Prochaine étape : initialiser la DLL x86 dans le même émulateur, puis qualifier INI, '
        'fournisseurs, fallback et destruction avant l’intégration Rust et l’UI. Les 1178 fichiers '
        'importés sont conservés ; le raccordement fournisseur et le rendu restent à terminer.</p>'
        '<p><a href="loading_provider_crt_preparation_receipt.json">Reçu de préparation</a> · '
        '<a href="loading_provider_crt_preparation/manifest.json">Manifest figé</a></p>'
        '<details><summary>Suite du plan conservée</summary><p>' + html.escape(NEXT) + '</p></details></section>'
    ).encode('utf-8')
    originals[plan_html] = original_html
    documents[plan_html] = original_html.replace(b'</body>', section + b'</body>')
    # The script and its instructions are audit material, never executed from the archive.
    for filename in ['install.py', 'README.md']:
        archive(S / filename, 'publication/' + filename, sha(S / filename))
    payloads.update(documents)
    receipt = {
        **summary, 'kind': 'frozen_preparation_archive_only', 'preparation_recorded': True,
        'archive_verified': True, 'backup': str(backup), 'script_sha256': sha(Path(__file__)),
        'native_source_sha256': PE_SHA, 'native_dll_sha256': DLL_SHA,
        'archived_files': archives, 'verified_inputs': inputs,
        'physical_assets_preserved': asset_summary,
        'rust_test_counts_changed': False, 'domain_statuses_changed': False,
        'static_audits_are_runtime_qualification': False,
        'historical_note': 'Frozen earlier inventories (31 Ahri/Annie assets) are historical; the current physical import is 1178 files for122 champions. Historical logs are not new tests.',
        'limits': oracle['limits'] + [
            'Engine allocation/free, memcpy/memmove/memset, CA8673 calloc and atexit registration are declared primitive boundaries; startup is bounded, not the normal application startup.',
            'No complete native CRT/provider/SEH destruction; host hygiene is not native teardown. No global lowIO-block destructor identified by the bounded static scan.',
            'Successful CREATE_ALWAYS/TRUNCATE_EXISTING remain untested. Writable link fixture creation was denied with Windows5; existing link guards were tested read-only.',
            'The DLL-loader note is static:210 imports from7 DLLs, image base0x10000000/size0x1AC000, no TLS/delay-import directory. No DllMain or RADS export execution in this archive.',
            'Provider return, INIBIN content/fallback, populated destruction, Rust provider integration, screen rendering and full game remain incomplete.',
        ],
        'next_action': NEXT,
        'document_original_sha256': {p.relative_to(R).as_posix(): digest(raw) for p, raw in originals.items()},
        'document_published_sha256': {p.relative_to(R).as_posix(): digest(raw) for p, raw in documents.items()},
        'transaction_limits': 'Per-file atomic replace and caught-exception rollback; not cross-file atomic on power loss or concurrent writers. Receipt is published last. Backups and empty new directories are retained on failure.',
    }
    payloads[RECEIPT] = encoded(receipt)  # Commit evidence comes after archive and every document.
    require(list(payloads)[-1] == RECEIPT, 'receipt must be last')
    for path in payloads:
        require(path.resolve().is_relative_to((R / 'docs').resolve()), 'publication outside docs')
        if path not in originals:
            require(not path.exists(), 'new destination already exists: ' + str(path))
            originals[path] = None
    for path, raw in payloads.items():
        require(isinstance(raw, bytes), 'payload not prepared')
        if path.suffix == '.json':
            json.loads(raw.decode('utf-8-sig'))
    return payloads, originals, inputs, backup, summary


def replace_exact(path, raw):
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(path.name + '.crt-preparation-' + uuid.uuid4().hex + '.tmp')
    try:
        with temporary.open('xb') as stream:
            stream.write(raw)
            stream.flush()
        require(temporary.read_bytes() == raw, 'temporary write mismatch')
        temporary.replace(path)
        require(path.read_bytes() == raw, 'published bytes mismatch')
    finally:
        if temporary.exists():
            temporary.unlink()


def publish(payloads, originals, inputs, backup):
    # Last read-only preflight. No source checks occur after publication begins.
    for name, row in inputs.items():
        path = Path(name)
        require(path.stat().st_size == row['bytes'] and sha(path) == row['sha256'],
                'input changed before publication: ' + name)
    for path, raw in originals.items():
        require((path.read_bytes() if path.exists() else None) == raw, 'destination changed: ' + str(path))
    require(not A.exists() and not RECEIPT.exists() and not backup.exists(), 'publication collision')
    backup.mkdir(parents=True)
    for path, raw in originals.items():
        if raw is not None:
            saved = backup / path.relative_to(R / 'docs')
            saved.parent.mkdir(parents=True, exist_ok=True)
            saved.write_bytes(raw)
            require(saved.read_bytes() == raw, 'backup mismatch')
    (backup / 'transaction_inputs.json').write_bytes(encoded({
        'destinations': {str(p): None if b is None else digest(b) for p, b in originals.items()},
        'payload_sha256': {str(p): digest(b) for p, b in payloads.items()},
        'verified_inputs': inputs,
    }))
    changed = []
    try:
        for path, raw in payloads.items():
            require((path.read_bytes() if path.exists() else None) == originals[path],
                    'destination changed during publication: ' + str(path))
            changed.append(path)  # Includes a failure after replace but before verification.
            replace_exact(path, raw)
    except BaseException as primary:
        failures = []
        for path in reversed(changed):
            try:
                if originals[path] is None:
                    path.unlink(missing_ok=True)
                else:
                    replace_exact(path, originals[path])
            except BaseException as cleanup:
                failures.append(cleanup)
        if failures:
            raise BaseExceptionGroup('Publication and rollback failed; retain backup', [primary, *failures])
        raise


def main():
    require(len(sys.argv) == 2 and sys.argv[1] == CRT_SHA,
            'explicit pinned CRT manifest SHA argument required')
    payloads, originals, inputs, backup, summary = prepare()
    publish(payloads, originals, inputs, backup)
    print(json.dumps(summary, ensure_ascii=False))


if __name__ == '__main__':
    main()
