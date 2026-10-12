"""Inventory and decode actual loading inputs for the canonical 4.20 roster.

Reads source and production; writes this candidate report only. No native
provider or rendering result is inferred from the community decoder.
"""
from pathlib import Path
import datetime, hashlib, importlib.util, io, json, struct, sys
from PIL import Image, __version__ as pillow_version

sys.dont_write_bytecode = True
R = Path('E:/OpenLeague')
S = Path(__file__).resolve().parent
INVENTORY = R / 'docs/content_reference_inventory.json'
PARSER = R / 'tools/references/lolpytools/lolpytools_inibin2.py'
inventory = json.loads(INVENTORY.read_text(encoding='utf-8-sig'))
deploy = Path(inventory['native_root'])
spec = importlib.util.spec_from_file_location('loading_ini_inventory', PARSER)
ini = importlib.util.module_from_spec(spec)
spec.loader.exec_module(ini)

def sha(data): return hashlib.sha256(data).hexdigest()
def file_proof(p):
    b = p.read_bytes()
    return {'path': str(p), 'bytes': len(b), 'sha256': sha(b)}

rows, champions, failures, casefolded = [], [], [], set()
canonical = json.loads((R / 'data/4.20/champions.json').read_text(encoding='utf-8-sig'))
assert {r['id'] for r in inventory['champions']} == {r['id'] for r in canonical}
assert len(inventory['champions']) == 122
for champion in inventory['champions']:
    folder = Path(champion['native_directory'])
    assert folder.resolve().is_relative_to((deploy / 'DATA/Characters').resolve())
    paths = {folder / (folder.name + '.inibin')}
    for p in folder.rglob('*'):
        if not p.is_file(): continue
        rel = p.relative_to(folder)
        if 'loadscreen' in p.name.casefold(): paths.add(p)
        elif rel.parts[0].casefold() == 'skins' and p.suffix.casefold() == '.inibin': paths.add(p)
    image_count = 0
    for p in sorted(paths, key=lambda p: str(p).casefold()):
        assert p.is_file(), str(p)
        native = p.relative_to(deploy).as_posix()
        assert native.casefold() not in casefolded, native
        casefolded.add(native.casefold())
        raw = p.read_bytes()
        row = {'champion': champion['id'], 'native_path': native, 'source': str(p),
               'bytes': len(raw), 'sha256': sha(raw),
               'relative_to_champion': p.relative_to(folder).as_posix(),
               'deprecated_directory': any(v.casefold() == 'deprecated' for v in p.relative_to(folder).parts)}
        if p.suffix.casefold() == '.inibin':
            row['kind'] = 'inibin'
            try:
                values = ini.from_file(str(p))['UNKNOWN_HASHES']
                fallback = ini.ihash('Package', 'FallbackPackage')
                row['community_parser_only'] = {
                    'version': raw[0], 'flags': struct.unpack_from('<H', raw, 3)[0],
                    'entries': len(values), 'fallback_key_present': fallback in values,
                    'fallback_value': values.get(fallback),
                    'loading_strings': {str(k): v for k, v in values.items() if isinstance(v, str) and 'loadscreen' in v.casefold()},
                }
            except Exception as e:
                row['parse_error'] = repr(e)
                failures.append({'path': native, 'stage': 'community_parser', 'error': repr(e)})
        else:
            row['kind'] = 'loading_image'; image_count += 1
            try:
                with Image.open(io.BytesIO(raw)) as image:
                    image.load()
                    rgba = image.convert('RGBA')
                    row['decoded_top_mip'] = {'format': image.format, 'width': image.width,
                                              'height': image.height, 'rgba_sha256': sha(rgba.tobytes())}
                if raw[:4] == b'DDS ':
                    assert len(raw) >= 128 and struct.unpack_from('<I', raw, 4)[0] == 124
                    h, w = struct.unpack_from('<II', raw, 12)
                    levels = max(1, struct.unpack_from('<I', raw, 28)[0])
                    fourcc = raw[84:88].decode('ascii', errors='replace')
                    row['dds_header'] = {'width': w, 'height': h, 'mip_levels': levels, 'fourcc': fourcc}
                    assert [w, h] == [row['decoded_top_mip']['width'], row['decoded_top_mip']['height']]
                    if fourcc in ('DXT1', 'DXT3', 'DXT5'):
                        assert levels <= max(w, h).bit_length()
                        block = 8 if fourcc == 'DXT1' else 16
                        payload = sum(((max(1,w>>i)+3)//4)*((max(1,h>>i)+3)//4)*block for i in range(levels))
                        assert len(raw) >= 128 + payload, 'truncated declared mip payload'
                        row['dds_header']['declared_payload_bytes'] = payload
                        row['dds_header']['trailing_bytes'] = len(raw)-128-payload
            except Exception as e:
                row['decode_error'] = repr(e)
                failures.append({'path': native, 'stage': 'image_decode', 'error': repr(e)})
        rows.append(row)
    champions.append({'id': champion['id'], 'native_directory': str(folder),
                      'selected_files': len(paths), 'loading_images': image_count})
    if not image_count: failures.append({'champion': champion['id'], 'stage': 'selection', 'error': 'no loose loadscreen filename found'})

proof = {'schema': 1, 'generated_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
         'complete': False, 'production_modified': False, 'roster_count': 122,
         'native_deploy': str(deploy), 'files': rows, 'champions': champions, 'failures': failures,
         'selected_files': len(rows), 'selected_bytes': sum(r['bytes'] for r in rows),
         'images': sum(r['kind'] == 'loading_image' for r in rows),
         'inibin': sum(r['kind'] == 'inibin' for r in rows),
         'source_inputs': [file_proof(INVENTORY), file_proof(R / 'data/4.20/champions.json'), file_proof(PARSER)],
         'tool': {'script_sha256': sha(Path(__file__).read_bytes()), 'pillow_version': pillow_version},
         'selection': 'Canonical champion root INIBIN; every INIBIN under its Skins directory; all loose filenames containing LoadScreen under that champion.',
         'limits': ['Files discovered in this actual 4.20 deployment, not proof of every historical skin or alternate resource name.',
                    'Pillow decodes the top mip only; BC block-length checks cover declared mip payload sizes, not native GPU parity.',
                    'INIBIN parser output is inventory only, not a substitute for native provider/INI execution.',
                    'No provider binding, texture upload, rendered loading screen or champion gameplay is qualified.']}
(S / 'candidate_inventory.json').write_text(json.dumps(proof, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(json.dumps({k: proof[k] for k in ['roster_count', 'selected_files', 'selected_bytes', 'images', 'inibin', 'failures']}))
