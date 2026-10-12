"""Import reviewed original loading files; preserve prior assets and progress."""
from pathlib import Path
import datetime, hashlib, json, shutil, sys

S = Path(__file__).resolve().parent
R = Path('E:/OpenLeague')
ASSETS = R / 'assets'
DEST = ASSETS / 'ui/native420/loading_source'
INV = S / 'candidate_inventory.json'
MANIFEST = R / 'data/4.20/native_champion_loading_assets.json'
RECEIPT = R / 'docs/native_champion_loading_assets_import.json'
ARCHIVE = R / 'docs/native_loading_assets_sources'

def sha(p):
    with p.open('rb') as f: return hashlib.file_digest(f, 'sha256').hexdigest()
def load(p): return json.loads(p.read_text(encoding='utf-8-sig'))
def encoded(v): return (json.dumps(v, ensure_ascii=False, indent=2) + '\n').encode('utf-8')
def inside(root, rel):
    p = root / rel
    assert p.resolve().is_relative_to(root.resolve()) and not Path(rel).is_absolute(), rel
    return p
def publish(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    temp = path.with_suffix(path.suffix + '.loading-assets-pending')
    assert not temp.exists(), str(temp)
    temp.write_bytes(data)
    assert temp.read_bytes() == data
    temp.replace(path)
    assert path.read_bytes() == data

assert __debug__ and len(sys.argv) == 2
assert sha(INV) == sys.argv[1]
v = load(INV)
assert (v['roster_count'], v['selected_files'], v['images'], v['inibin']) == (122, 1178, 720, 458)
assert not v['failures'] and v['production_modified'] is False and v['complete'] is False
assert sha(S / 'prepare.py') == v['tool']['script_sha256']
for row in v['source_inputs']:
    p = Path(row['path']); assert p.stat().st_size == row['bytes'] and sha(p) == row['sha256']
assert not MANIFEST.exists() and not RECEIPT.exists() and not DEST.exists()
assert not ARCHIVE.exists()
native_root = Path(v['native_deploy'])
keys = set()
for row in v['files']:
    p = Path(row['source'])
    assert p.resolve().is_relative_to(native_root.resolve())
    assert p.relative_to(native_root).as_posix() == row['native_path']
    assert row['native_path'].casefold() not in keys
    keys.add(row['native_path'].casefold())
    assert p.stat().st_size == row['bytes'] and sha(p) == row['sha256'], str(p)
    if row['kind'] == 'loading_image': assert 'decoded_top_mip' in row and 'decode_error' not in row
    else: assert row['kind'] == 'inibin' and 'community_parser_only' in row and 'parse_error' not in row

now = datetime.datetime.now(datetime.timezone.utc)
tag = now.strftime('%Y%m%dT%H%M%S%fZ')
backup = R / 'docs/plan_history' / ('native-loading-assets-' + tag)
backup.mkdir(parents=True)
staging = DEST.with_name(DEST.name + '.pending-' + tag)
# The only directory rename is this fresh owned import inside native420.
for path in [staging, DEST]:
    assert path.resolve().is_relative_to((ASSETS / 'ui/native420').resolve())
assert not staging.exists()

files = [{**row, 'asset': (DEST / row['native_path']).relative_to(ASSETS).as_posix()}
         for row in v['files']]
manifest = {**v, 'generated_utc': now.isoformat(), 'production_modified': True,
            'physical_import_verified': True, 'provider_connected': False, 'rendered': False,
            'asset_root': DEST.relative_to(ASSETS).as_posix(), 'files': files}
manifest_data = encoded(manifest)
summary = {'saved_utc': now.isoformat(), 'physical_import_verified': True, 'complete': False,
           'champions': 122, 'files': 1178, 'images': 720, 'inibin': 458,
           'bytes': v['selected_bytes'], 'manifest': MANIFEST.relative_to(R).as_posix(),
           'manifest_sha256': hashlib.sha256(manifest_data).hexdigest(),
           'receipt': RECEIPT.relative_to(R).as_posix(), 'provider_connected': False, 'rendered': False}
payloads, expected_originals = {}, {}
for filename in ['prepare.py', 'install.py', 'candidate_inventory.json']:
    payloads[ARCHIVE / filename] = (S / filename).read_bytes()
payloads[MANIFEST] = manifest_data
for name in ['coverage.json', 'resume_checkpoint.json', 'completion_plan.json']:
    path = R / 'docs' / name
    old = path.read_bytes(); data = json.loads(old.decode('utf-8-sig'))
    expected_originals[path] = old
    (backup / name).write_bytes(old)
    data['native_champion_loading_assets_import'] = summary
    data['updated_utc'] = now.isoformat()
    if name == 'completion_plan.json':
        for domain in data['domains']:
            if domain['id'] not in ['02', '17']: continue
            items = domain.setdefault('progress_evidence', [])
            if summary['receipt'] not in items: items.append(summary['receipt'])
    if name == 'resume_checkpoint.json':
        assert data['state'] == 'active' and 'in_progress' not in data
        assert 'Do not repeat' in data['communication_preferences']['progress_dashboard_repetition']
        data['saved_utc'] = now.isoformat()
    payloads[path] = encoded(data)
html = R / 'docs/completion_plan.html'
old_html = html.read_bytes(); (backup / html.name).write_bytes(old_html)
expected_originals[html] = old_html
body = old_html.decode('utf-8')
assert body.count('</body>') == 1 and 'native-loading-assets-import' not in body
section = '<section id="native-loading-assets-import"><h2>Ressources des écrans de chargement</h2><p>1178 fichiers originaux récupérés pour les 122 champions : 720 images et 458 INIBIN. Copie vérifiée octet pour octet, images décodées hors moteur et configurations inventoriées. Le raccordement au fournisseur natif et le rendu restent à terminer.</p></section>'
payloads[html] = body.replace('</body>', section + '</body>').encode('utf-8')
receipt = {**summary, 'backup': str(backup), 'source_inventory_sha256': sha(INV),
           'script_sha256': sha(Path(__file__)), 'asset_directory_published': True,
           'limits': v['limits'], 'evidence': {p.relative_to(R).as_posix(): hashlib.sha256(b).hexdigest()
                                            for p, b in payloads.items() if p.is_relative_to(ARCHIVE)}}
payloads[RECEIPT] = encoded(receipt)
originals = {p: p.read_bytes() if p.exists() else None for p in payloads}
for p, old in expected_originals.items(): assert originals[p] == old, str(p)
for p in payloads: assert not p.with_suffix(p.suffix + '.loading-assets-pending').exists(), str(p)
# All document, schema and path conditions have passed before copying assets.
staging.mkdir(parents=True)
for row in v['files']:
    source = Path(row['source']); target = inside(staging, row['native_path'])
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source, target)
    assert target.stat().st_size == row['bytes'] and sha(target) == sha(source) == row['sha256']
assert sum(p.is_file() for p in staging.rglob('*')) == len(v['files'])
for p, old in originals.items(): assert (p.read_bytes() if p.exists() else None) == old, str(p)
assert not DEST.exists() and staging.resolve().is_relative_to(ASSETS.resolve())
staging.rename(DEST)
for row in v['files']:
    assert sha(inside(DEST, row['native_path'])) == row['sha256']
published = []
try:
    for p, data in payloads.items():
        assert (p.read_bytes() if p.exists() else None) == originals[p], str(p)
        published.append(p); publish(p, data)
except BaseException as primary:
    errors = []
    for p in reversed(published):
        try:
            if originals[p] is None: p.unlink(missing_ok=True)
            else: publish(p, originals[p])
        except BaseException as e: errors.append(e)
    # Verified new asset bytes remain recoverable; never delete a directory on error.
    if errors: raise BaseExceptionGroup('Import metadata publication and rollback failed', [primary, *errors])
    raise
print(json.dumps(summary))
