"""Install one reviewed test-only cache-ownership correction; never run tests."""
from pathlib import Path
import datetime, hashlib, json, re, sys

S = Path(__file__).resolve().parent
R = Path('E:/OpenLeague')
P = S / 'production'
REL = 'crates/core/src/audio_replay_windows_loading_retirement_tests.rs'
def sha(path): return hashlib.sha256(path.read_bytes()).hexdigest()
def load(path): return json.loads(path.read_text(encoding='utf-8-sig'))
def inside(root, relative):
    path = root / relative
    assert path.resolve().is_relative_to(root.resolve()), relative
    return path
def replace(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    temp = path.with_suffix(path.suffix + '.metadata-cache-repair-pending')
    temp.write_bytes(data);assert temp.read_bytes() == data
    temp.replace(path);assert path.read_bytes() == data

def main():
    assert __debug__ and len(sys.argv) == 2
    expected_manifest_sha = sys.argv[1]
    assert re.fullmatch('[0-9a-f]{64}', expected_manifest_sha)
    path = S / 'metadata_cache_repair.json'
    assert sha(path) == expected_manifest_sha
    repair = load(path);installed = load(S / 'installed.json')
    index = load(S / 'review/index_read_repair/repair_manifest.json')
    order = load(S / 'test_order_repair.json')
    assert repair['schema'] == 1 and repair['complete'] is False
    assert repair['assembled_sha256'] == sha(S / 'assembled.json') == installed['assembled_sha256']
    assert repair['installed_sha256'] == sha(S / 'installed.json')
    assert repair['index_repair_manifest_sha256'] == sha(S / 'review/index_read_repair/repair_manifest.json')
    assert repair['index_repair_installed_sha256'] == sha(S / 'index_repair_installed.json')
    assert repair['test_order_repair_manifest_sha256'] == sha(S / 'test_order_repair.json')
    assert repair['test_order_repair_installed_sha256'] == sha(S / 'test_order_repair_installed.json')
    assert set(repair['files']) == {REL} and repair['added_tests'] == []
    row = repair['files'][REL]
    assert row['before_sha256'] == order['files'][REL]['after_sha256']
    expected = {rel: row['after'] for rel, row in installed['files'].items()}
    for addition in [index, order]:
        expected.update({rel: row['after_sha256'] for rel, row in addition['files'].items()})
    assert len(expected) == 26
    assert {p.relative_to(P).as_posix() for p in P.rglob('*') if p.is_file()} == set(expected)
    for relative, digest in expected.items():
        assert sha(inside(R, relative)) == sha(inside(P, relative)) == digest, relative
    candidate = inside(S, row['candidate'])
    assert candidate.resolve().is_relative_to((S / 'review/metadata_cache_repair').resolve())
    assert candidate.stat().st_size == row['bytes'] and sha(candidate) == row['after_sha256']
    for relative, proof in repair['proof_files'].items():
        item = inside(S, relative)
        assert item.stat().st_size == proof['bytes'] and sha(item) == proof['sha256'], relative
    decision = load(S / 'review/metadata_cache_repair/decision.json')
    assert decision['before_sha256'] == row['before_sha256'] and decision['after_sha256'] == row['after_sha256']
    assert decision['real_runtime_changes'] is False and decision['test_names_unchanged'] is True
    for filename, proof in decision['unchanged_source_guards'].items():
        item = R / 'crates/core/src' / filename
        assert item.stat().st_size == proof['bytes'] and sha(item) == proof['sha256'], filename
    tests = lambda data: re.findall(rb'#\[test\]\s*fn\s+(\w+)\s*\(', data)
    assert tests(candidate.read_bytes()) == tests((R / REL).read_bytes())
    checkpoint = R / 'docs/resume_checkpoint.json';state = load(checkpoint)
    assert state['in_progress']['assembled_sha256'] == repair['assembled_sha256']
    assert state['in_progress']['test_order_repair']['sha256'] == repair['test_order_repair_manifest_sha256']
    now = datetime.datetime.now(datetime.timezone.utc)
    backup = R / 'docs/plan_history' / ('resource-metadata-cache-repair-' + now.strftime('%Y%m%dT%H%M%S%fZ'))
    backup.mkdir(parents=True)
    state['in_progress']['metadata_cache_repair'] = {
        'manifest': str(path), 'sha256': expected_manifest_sha, 'backup': str(backup), 'tests_pending': True,
    }
    payloads = {R / REL: candidate.read_bytes(), P / REL: candidate.read_bytes(),
                checkpoint: (json.dumps(state, ensure_ascii=False, indent=2) + '\n').encode('utf-8')}
    originals = {p: p.read_bytes() for p in payloads}
    for p, data in originals.items():
        root, label = (R, 'installed') if p.resolve().is_relative_to(R.resolve()) else (P, 'staged')
        target = backup / label / p.relative_to(root)
        target.parent.mkdir(parents=True, exist_ok=True);target.write_bytes(data)
        assert target.read_bytes() == data
    manifest_backup = backup / 'repair_manifest.json';manifest_backup.write_bytes(path.read_bytes())
    assert sha(manifest_backup) == expected_manifest_sha
    receipt = {'installed_utc': now.isoformat(), 'manifest': str(path),
               'manifest_sha256': expected_manifest_sha, 'backup': str(backup),
               'files': repair['files'], 'tests_pending': True}
    receipt_path = S / 'metadata_cache_repair_installed.json'
    payloads[receipt_path] = (json.dumps(receipt, indent=2) + '\n').encode()
    originals[receipt_path] = receipt_path.read_bytes() if receipt_path.exists() else None
    if originals[receipt_path] is not None:
        (backup / 'previous_metadata_cache_repair_installed.json').write_bytes(originals[receipt_path])
    published = []
    try:
        # All 26 files and proof guards were checked before preparing writes;
        # immediately reread the four transaction targets before replacement.
        for p, data in payloads.items():
            assert (p.read_bytes() if p.exists() else None) == originals[p], str(p)
            published.append(p);replace(p, data)
    except BaseException as primary:
        errors = []
        for p in reversed(published):
            try:
                if originals[p] is None: p.unlink(missing_ok=True)
                else: replace(p, originals[p])
            except BaseException as error: errors.append(error)
        if errors: raise BaseExceptionGroup('Metadata-cache correction failed; rollback needs recovery', [primary, *errors])
        raise
    print(json.dumps({'metadata_cache_repair_installed': True, 'tests_pending': True, 'backup': str(backup)}))

if __name__ == '__main__': main()
