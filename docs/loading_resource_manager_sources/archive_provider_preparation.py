"""Copy the frozen next-step preparation into this lot's evidence staging."""
from pathlib import Path
import hashlib
import json
import shutil

SOURCE = Path('E:/mapslol3v3/loading_resource_provider_next')
DEST = Path(__file__).resolve().parent / 'next_provider_preparation'
PIN = 'dde701270da710c68c49890a8eb4669a89b91da4c582fa7670904a5aeff61232'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


manifest = SOURCE / 'manifest.json'
assert sha(manifest) == PIN
data = json.loads(manifest.read_text(encoding='utf-8'))
assert data['complete'] is False and data['integrated'] is False
assert len(data['files']) == 14
paths = {'manifest.json': {'bytes': manifest.stat().st_size, 'sha256': PIN}, **data['files']}
for relative, row in paths.items():
    path = SOURCE / relative
    target = DEST / relative
    assert path.resolve().is_relative_to(SOURCE.resolve())
    assert target.resolve().is_relative_to(DEST.resolve())
    assert path.stat().st_size == row['bytes'] and sha(path) == row['sha256']
    if target.exists():
        assert sha(target) == row['sha256']
for relative, row in paths.items():
    path = SOURCE / relative
    target = DEST / relative
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(path, target)
    assert sha(target) == row['sha256']
print(json.dumps({'archived_in_staging': len(paths), 'manifest_sha256': PIN, 'production_modified': False}))
