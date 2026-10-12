"""Publish only a completed, evidence-backed normal client shutdown check."""
from pathlib import Path
import json, hashlib, datetime, re, uuid, importlib.util

ROOT = Path(r'E:\OpenLeague')
HERE = Path(__file__).parent
STAGE = Path(r'E:\mapslol3v3\client_shutdown_refresh')
FIELD = 'normal_client_shutdown_validation'
ARCHIVE = ROOT / 'docs/normal_client_shutdown_validation'
RECEIPT = ROOT / 'docs/normal_client_shutdown_validation.json'

def sha(raw): return hashlib.sha256(raw).hexdigest()
def read(path): return json.loads(path.read_text(encoding='utf-8-sig'))
def encode(obj): return (json.dumps(obj, ensure_ascii=False, indent=2)+'\n').encode('utf-8')
def require(ok, why):
    if not ok: raise ValueError(why)

require(not ARCHIVE.exists() and not RECEIPT.exists(), 'Preserve existing evidence')
installed = read(HERE / 'installed_sources.json')
for row in installed['files']:
    require(sha(Path(row['path']).read_bytes()) == row['sha256'], 'Installed source changed')
manifest = read(STAGE / 'manifest.json')
test_log = (HERE / 'tests.log').read_text(encoding='utf-8-sig', errors='replace')
require('test result: ok. 6 passed; 0 failed;' in test_log, 'Six shutdown tests not passed')
for name in manifest['prepared_tests']:
    require('::'+name+' ... ok' in test_log, 'Required shutdown test missing: '+name)
regression_count = 0
for log, expected in [('regression-tests.log',6),('regression-clock-tests.log',4)]:
    regression = (HERE / log).read_text(encoding='utf-8-sig', errors='replace')
    matches = re.findall(r'test result: ok\. (\d+) passed; 0 failed;', regression)
    require(len(matches) == 1 and int(matches[0]) == expected, 'Regression suite did not pass: '+log)
    regression_count += int(matches[0])
build_log = (HERE / 'build.log').read_text(encoding='utf-8-sig', errors='replace')
require('Finished `dev` profile' in build_log, 'No successful client build')
commands = read(HERE / 'client-shutdown-command-run.json')
require(len(commands['commands']) == 11, 'Expected eleven CLI regressions')
exe = ROOT / 'target/debug/openleague-client.exe'
exe_sha = sha(exe.read_bytes())
require(commands['sha256'] == exe_sha, 'CLI executable changed')
for row in commands['commands']:
    require(row['exit_code'] == 0 and row['sha256'] == exe_sha, 'CLI regression failed')
    require(isinstance(read(Path(row['output'])), dict), 'CLI output missing')
require(sha((HERE/'verify_client_commands.py').read_bytes()) ==
        'ef0dc38d291541c2382a3b719a5195e7d6eba7dc648cf894a7b60174b6d48de7', 'Reviewed CLI verifier changed')
spec = importlib.util.spec_from_file_location('shutdown_cli_verification', HERE/'verify_client_commands.py')
verifier = importlib.util.module_from_spec(spec)
spec.loader.exec_module(verifier)
strict_commands = verifier.verify(root=ROOT, expected_executable_sha256=exe_sha)
require(strict_commands['passed'] is True and strict_commands['commands'] == 11,
        'Strict command contracts did not pass')
require(strict_commands['executable_sha256'] == exe_sha, 'Strict verifier used a different executable')
gui = read(HERE / 'gui-final/qualification.json')
require(sha((HERE/'gui_observer_v2.py').read_bytes()) ==
        '999fe14007e60aacfbafc87e9c5c34aa8daf1dd168ab35e39083c62c5fd04206', 'GUI observer changed')
require(gui['passed'] and gui['exit_code'] == 0 and gui['wm_close_posted'], 'Real normal-window close failed')
require(not gui['process_still_running'] and not gui['forced_termination'], 'Client still running or killed')
require(gui['executable_sha256'] == gui['executable_sha256_after'] == exe_sha, 'GUI executable differs')
for row in gui['logs'].values():
    require(row['final'] and sha(Path(row['path']).read_bytes()) == row['sha256'], 'GUI log changed')

files = {}
def archive(source, name):
    require(name not in files and '..' not in Path(name).parts, 'Duplicate/unsafe archive name')
    source = Path(source)
    raw = source.read_bytes()
    files[name] = (raw, {'source':str(source), 'bytes':len(raw), 'sha256':sha(raw)})
for name in ['installed_sources.json','install_sources.py','tests.log','regression-tests.log','regression-clock-tests.log','build.log',
             'run_probes.ps1','client-shutdown-command-run.json','verify_client_commands.py','verify_client_commands_adaptation.json',
             'strict_cli_validation.json','verify_published.py','publish_validation.py',
             'gui_observer_v2.py','gui_observer_v2.preparation.json','close_first_gui_attempt.py']:
    archive(HERE/name, name)
archive(STAGE/'manifest.json', 'candidate_manifest.json')
archive(STAGE/'README.md', 'candidate_README.md')
archive(STAGE/'main.patch', 'main.patch')
for row in installed['files']: archive(row['path'], 'sources/'+Path(row['path']).name)
for row in commands['commands']:
    for key in ['output','stderr']: archive(row[key], 'cli/'+Path(row[key]).name)
archive(HERE/'gui-final/qualification.json', 'gui/qualification.json')
for name in ['qualification.json','recovery-close.json','stdout.log','stderr.log']:
    archive(HERE/'gui'/name, 'gui_first_attempt/'+name)
for key, row in gui['logs'].items(): archive(row['path'], 'gui/'+key+'.log')
for path in (STAGE/'gui_qualification').iterdir():
    if path.is_file(): archive(path, 'gui_observer/'+path.name)

now = datetime.datetime.now(datetime.timezone.utc).isoformat()
summary = {'saved_utc':now, 'passed':True, 'complete':False,
    'receipt':'docs/normal_client_shutdown_validation.json',
    'source_integrated':True, 'client_rebuilt':True, 'client_executable_sha256':exe_sha,
    'shutdown_tests_passed':6, 'related_client_tests_passed':regression_count,
    'cli_commands_passed':11, 'real_normal_client_wm_close_passed':True,
    'normal_client_exit_code':0, 'normal_client_pid':gui['pid'],
    'normal_client_close_forced':False,
    'existing_error_codes_preserved_in_headless_tests':255,
    'injected_os_failure_tested':False, 'framebuffer_fidelity_qualified':False,
    'full_native_game_shutdown_complete':False,
    'limits':['One normal Windows client close, not all OS event-loop failure paths.',
              'Independent diagnostics observe ownership/error reports, not direct OS deletion counts.',
              'No new complete gameplay, loading UI, audio or asset-provider claim.']}
documents = {}
originals = {}
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
    path = ROOT/'docs'/name
    raw = path.read_bytes()
    data = json.loads(raw.decode('utf-8-sig'))
    require(FIELD not in data and data.get('complete') is False, 'Unexpected document state')
    originals[path] = raw
    data[FIELD] = summary
    data['updated_utc'] = now
    old_phrase = 'Qualify the unintegrated GUI shutdown/error-exit proposal separately.'
    if old_phrase in data.get('next_action',''):
        data['next_action'] = data['next_action'].replace(old_phrase,
            'Normal Windows WM_CLOSE and the preserved AppExit result are qualified on the recorded client; retain this regression while completing native startup, loading providers and gameplay.')
    bucket = 'last_verified' if name == 'resume_checkpoint.json' else 'current_evidence'
    data[bucket]['normal_client_shutdown_tests'] = 6
    data[bucket]['normal_client_shutdown_related_tests'] = regression_count
    data[bucket]['normal_client_shutdown_wm_close'] = True
    if name == 'resume_checkpoint.json':
        require(data['state'] == 'active', 'Goal checkpoint must remain active')
        require('Do not repeat' in data['communication_preferences']['progress_dashboard_repetition'], 'Communication preference lost')
        data['saved_utc'] = now
    if name == 'completion_plan.json':
        require(len(data['domains']) == 24 and sum(len(d['tasks']) for d in data['domains']) == 114, 'Plan scope changed')
        data['next_execution_steps'][0] = data['next_action']
    documents[path] = encode(data)
path = ROOT/'docs/completion_plan.html'
raw = path.read_bytes(); originals[path] = raw
page = raw.decode('utf-8')
require('id="normal-client-shutdown-validation"' not in page and '</body>' in page, 'HTML marker conflict')
section = ('<section id="normal-client-shutdown-validation"><h2>Fermeture du client Windows</h2>'
    '<p>Le client conserve désormais le résultat de sa boucle de fenêtre et les erreurs de nettoyage. '
    f'Six tests de fermeture, {regression_count} tests client associés et onze commandes de diagnostic passent. '
    'Le véritable client reconstruit a été ouvert puis fermé par WM_CLOSE sur sa seule fenêtre identifiée : sortie 0, '
    'ressources suivies libérées et aucune erreur tardive signalée. Les autres chemins de panne Windows et la fidélité '
    'visuelle complète restent à qualifier.</p><p><a href="normal_client_shutdown_validation.json">Preuves de validation</a></p></section>')
documents[path] = page.replace('</body>', section+'</body>').encode('utf-8')
backup = ROOT/'docs/plan_history'/('normal-client-shutdown-'+datetime.datetime.now().strftime('%Y%m%d-%H%M%S'))
require(not backup.exists(), 'Backup already exists')
receipt = dict(summary, archived_files={name:row for name,(_,row) in files.items()},
    backup=str(backup), candidate_manifest_sha256=installed['candidate_manifest_sha256'],
    original_document_sha256={str(p.relative_to(ROOT)):sha(v) for p,v in originals.items()},
    published_document_sha256={str(p.relative_to(ROOT)):sha(v) for p,v in documents.items()},
    gui=gui, strict_cli_validation=strict_commands,
    first_gui_observer_attempt={'passed':False,'reason':'WaitForInputIdle returned ERROR_NOT_GUI_PROCESS for the console-subsystem client.',
                               'client_retired_by_targeted_wm_close':True,'exit_code':0,
                               'game_code_changed_to_fix_observer':False})
for p,raw in originals.items(): require(p.read_bytes()==raw, 'Document changed before publication')
backup.mkdir(parents=True)
for p,raw in originals.items(): (backup/p.name).write_bytes(raw)
pending_archive = ROOT/'docs'/('.normal-client-shutdown-'+uuid.uuid4().hex)
require(pending_archive.resolve().parent == (ROOT/'docs').resolve(), 'Temporary archive outside docs')
require(ARCHIVE.resolve().parent == (ROOT/'docs').resolve(), 'Archive outside docs')
pending_archive.mkdir()
for name,(raw,_) in files.items():
    path=pending_archive/name; path.parent.mkdir(parents=True,exist_ok=True); path.write_bytes(raw)
    require(sha(path.read_bytes()) == sha(raw), 'Prepared archive verification failed')
pending_receipt = RECEIPT.with_name(RECEIPT.name+'.'+uuid.uuid4().hex+'.tmp')
pending_receipt.write_bytes(encode(receipt))
archive_published = False
replaced_documents = []
for p,raw in originals.items(): require(p.read_bytes()==raw, 'Document changed before commit')
try:
    pending_archive.rename(ARCHIVE)
    archive_published = True
    for p,raw in documents.items():
        tmp=p.with_name(p.name+'.'+uuid.uuid4().hex+'.tmp'); tmp.write_bytes(raw); tmp.replace(p)
        replaced_documents.append(p)
    pending_receipt.replace(RECEIPT)
except BaseException:
    for p in replaced_documents: p.write_bytes(originals[p])
    if archive_published:
        # Both resolved targets were checked inside the intended docs directory.
        # Preserve the prepared evidence for inspection without occupying the
        # final archive path or deleting any user files.
        ARCHIVE.rename(pending_archive)
    raise
print(json.dumps({'published':str(RECEIPT),'sha256':sha(RECEIPT.read_bytes()),'archived_files':len(files),
                  'shutdown_tests':6,'related_tests':regression_count,'cli_commands':11,'wm_close_passed':True}))
