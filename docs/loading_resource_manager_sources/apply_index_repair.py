"""Apply one explicitly pinned, reviewed repair; retain the original install receipt."""
from pathlib import Path
import datetime
import hashlib
import json
import shutil
import sys

S = Path(__file__).resolve().parent
R = Path('E:/OpenLeague')
P = S / 'production'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load(path):
    return json.loads(path.read_text(encoding='utf-8-sig'))


def inside(root, relative):
    path = root / relative
    assert path.resolve().is_relative_to(root.resolve()), relative
    return path


def replace(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    temp = path.with_suffix(path.suffix + '.index-repair-pending')
    temp.write_bytes(data)
    assert temp.read_bytes() == data
    temp.replace(path)
    assert path.read_bytes() == data


def main():
    assert __debug__
    assert len(sys.argv) == 3, 'manifest path and reviewed SHA256 required'
    manifest_path = Path(sys.argv[1])
    assert manifest_path.resolve().is_relative_to(S.resolve())
    assert sha(manifest_path) == sys.argv[2]
    repair = load(manifest_path)
    installed = load(S / 'installed.json')
    assert repair['assembled_sha256'] == installed['assembled_sha256'] == sha(S / 'assembled.json')
    assert repair['installed_sha256'] == sha(S / 'installed.json')
    for relative, row in installed['files'].items():
        assert sha(inside(R, relative)) == sha(inside(P, relative)) == row['after'], relative
    payloads = {}
    for relative, row in repair['files'].items():
        candidate = inside(manifest_path.parent, row['candidate'])
        data = candidate.read_bytes()
        assert len(data) == row['bytes'] and sha(candidate) == row['after_sha256'], relative
        assert row['before_sha256'] == installed['files'].get(relative, {}).get('after'), relative
        for root in [R, P]:
            path = inside(root, relative)
            assert (sha(path) if path.is_file() else None) == row['before_sha256'], relative
            payloads[path] = data
    now = datetime.datetime.now(datetime.timezone.utc)
    backup = R / 'docs/plan_history' / ('resource-index-read-repair-' + now.strftime('%Y%m%dT%H%M%S%fZ'))
    backup.mkdir(parents=True)
    checkpoint = R / 'docs/resume_checkpoint.json'
    state = load(checkpoint)
    assert state['in_progress']['assembled_sha256'] == repair['assembled_sha256']
    state['in_progress']['index_read_repair'] = {
        'manifest': str(manifest_path), 'sha256': sys.argv[2],
        'backup': str(backup), 'tests_pending': True,
    }
    payloads[checkpoint] = (json.dumps(state, ensure_ascii=False, indent=2) + '\n').encode('utf-8')
    originals = {p: p.read_bytes() if p.exists() else None for p in payloads}
    for path, data in originals.items():
        if data is None:
            continue
        root, label = (R, 'installed') if path.resolve().is_relative_to(R.resolve()) else (P, 'staged')
        target = backup / label / path.relative_to(root)
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(data)
        assert target.read_bytes() == data
    shutil.copyfile(manifest_path, backup / 'repair_manifest.json')
    published = []
    try:
        for path, data in payloads.items():
            assert (path.read_bytes() if path.exists() else None) == originals[path]
            published.append(path)
            replace(path, data)
    except BaseException as primary:
        rollback_errors = []
        for path in reversed(published):
            try:
                if originals[path] is None:
                    path.unlink(missing_ok=True)
                else:
                    replace(path, originals[path])
            except BaseException as error:
                rollback_errors.append(error)
        if rollback_errors:
            raise BaseExceptionGroup('Repair failed and rollback needs recovery', [primary, *rollback_errors])
        raise
    receipt = {
        'installed_utc': now.isoformat(), 'manifest': str(manifest_path),
        'manifest_sha256': sys.argv[2], 'backup': str(backup),
        'files': repair['files'], 'tests_pending': True,
    }
    replace(S / 'index_repair_installed.json', (json.dumps(receipt, indent=2) + '\n').encode('utf-8'))
    print(json.dumps({'repair_files_installed': len(repair['files']), 'backup': str(backup), 'tests_pending': True}))


if __name__ == '__main__':
    main()
