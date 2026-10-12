"""Install the reviewed shutdown delta after checking its complete input set."""
from pathlib import Path
import hashlib, json, shutil, datetime

STAGE = Path(r'E:\mapslol3v3\client_shutdown_refresh')
ROOT = Path(r'E:\OpenLeague')
OUT = Path(__file__).parent

def digest(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()

manifest = STAGE / 'manifest.json'
assert digest(manifest) == '61949a1fd821779ef77cee94a82fce67b4b1ab1fadc840ba3ce5390fb2366367'
data = json.loads(manifest.read_text(encoding='utf-8'))
for row in data['sources'] + data['artifacts']:
    path = Path(row['path'])
    assert path.stat().st_size == row['bytes'] and digest(path) == row['sha256'], str(path)
dest = ROOT / 'crates/client/src'
assert not (OUT / 'installed_sources.json').exists(), 'Already installed'
for name in data['integration_files']:
    target = dest / name
    assert name == 'main.rs' or not target.exists(), f'Unexpected existing file: {target}'
backup = OUT / 'baseline'
backup.mkdir(parents=True, exist_ok=False)
shutil.copy2(dest / 'main.rs', backup / 'main.rs')
written = []
try:
    for name in data['integration_files']:
        target = dest / name
        shutil.copyfile(STAGE / name, target)
        written.append(target)
        assert digest(target) == digest(STAGE / name), str(target)
except BaseException:
    shutil.copyfile(backup / 'main.rs', dest / 'main.rs')
    for target in written:
        if target.name != 'main.rs':
            target.unlink()
    raise
receipt = {
    'saved_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'candidate_manifest_sha256': digest(manifest),
    'baseline_sha256': digest(backup / 'main.rs'),
    'files': [{'path': str(p), 'sha256': digest(p), 'bytes': p.stat().st_size} for p in written],
    'tests_run': False, 'client_executed': False,
}
(OUT / 'installed_sources.json').write_text(json.dumps(receipt, indent=2)+'\n', encoding='utf-8')
print(json.dumps(receipt, indent=2))
