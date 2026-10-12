from pathlib import Path
import datetime, hashlib, json, shutil

R = Path('E:/OpenLeague')
S = Path('E:/mapslol3v3/loading_clock_integration')
P = S.parent / 'process_clock_client_probe_retirement_fix'

def sha(p):
    with p.open('rb') as f:
        return hashlib.file_digest(f, 'sha256').hexdigest()

def save(p, value):
    p.write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

assert sha(P / 'manifest.json') == '67eb038953b3361ac42c76ddcefa6580e76553366caef6dfb04c521028733c05'
assert sha(P / 'main_probe.rs.txt') == '8f7de6c80997cb9525f30fd5c0e56480a001d37b81e7294ddef844acec3c054a'
rel = 'crates/client/src/main.rs'
main = R / rel
before = sha(main)
assert before == sha(S / 'production' / rel) == '9f55e460d1222984b1684ac138539686e6d721b2ad62d9d81641094ec1469b8f'
anchor = '#[cfg(windows)]\nfn native_process_clock_probe('
body = main.read_text(encoding='utf-8')
old = (S.parent / 'process_clock_client_probe/main_probe.rs.txt').read_text(encoding='utf-8')
new = (P / 'main_probe.rs.txt').read_text(encoding='utf-8')
assert body.count(anchor) == old.count(anchor) == new.count(anchor) == 1
assert body[body.index(anchor):].strip() == old[old.index(anchor):].strip()
updated = body[:body.index(anchor)] + new[new.index(anchor):]
now = datetime.datetime.now(datetime.timezone.utc)
backup = R / 'docs/plan_history' / ('process-clock-probe-retirement-' + now.strftime('%Y%m%dT%H%M%S%fZ'))
backup.mkdir(parents=True)
archived = {}
for path in [main, R/'logs/client-process-clock-clock.json', R/'logs/client-process-clock-clock.stderr.log', R/'logs/client-process-clock-build.log']:
    destination = backup / path.relative_to(R)
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(path, destination)
    archived[path.relative_to(R).as_posix()] = {'path': destination.relative_to(R).as_posix(), 'sha256': sha(destination)}
failed = json.loads((R/'logs/client-process-clock-clock.json').read_text(encoding='utf-8-sig'))
assert failed['passed'] is False and failed['exercise_error'] is None
assert failed['cleanup_errors'] == ['runtime cleanup: runtime retained allocations, workers, handles or critical sections']
exe_before = sha(R/'target/debug/openleague-client.exe')
stage = S / 'production' / rel
stage.write_text(updated, encoding='utf-8')
shutil.copyfile(stage, main)
assert sha(main) == sha(stage)
save(S/'probe_retirement_fix_installed.json', {
    'saved_utc': now.isoformat(), 'backup': str(backup), 'files': {rel: {'before': before, 'after': sha(main)}},
    'previous_executable_sha256': exe_before, 'archived_failed_attempt': archived,
    'selected_tests_before_probe_only_repair': True, 'previous_runtime_sources_unchanged': True,
    'probe_compilation_and_execution_pending': True,
})
print(json.dumps({'changed': rel, 'sha256': sha(main), 'backup': str(backup), 'previous_executable_sha256': exe_before}))
