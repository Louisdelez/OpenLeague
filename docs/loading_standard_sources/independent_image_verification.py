"""Read-only source verification; only its independent JSON report is written."""
from pathlib import Path
from datetime import datetime, timezone
import ast
import hashlib
import json
import re
import struct

STAGE = Path(__file__).resolve().parent
PRODUCTION = STAGE / 'production'
REPORT = STAGE / 'independent_image_verification.json'
EXPECTED_PACKAGE = 'a23f6215d9a876ee38115a3350b7330c9af795da09645dcc8c3e541f715c9c97'
EXPECTED_NATIVE = '402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
errors = []
def check(condition, label, detail=None):
    if not condition:
        errors.append({'check': label, 'detail': detail})
    return bool(condition)
def sha(raw):
    return hashlib.sha256(raw).hexdigest()
def file_sha(path):
    return sha(path.read_bytes()) if path.is_file() else None
def read_json(path):
    return json.loads(path.read_text(encoding='utf-8-sig'))
def number(node):
    if isinstance(node, ast.Constant):
        return node.value
    if isinstance(node, (ast.Tuple, ast.List)):
        return [number(item) for item in node.elts]
    if isinstance(node, ast.BinOp) and isinstance(node.op, ast.Mult):
        return number(node.left) * number(node.right)
    raise ValueError(f'Unexpected extractor data expression: {ast.dump(node)}')

started = datetime.now(timezone.utc).isoformat()
image_path = PRODUCTION / 'data/4.20/runtime/replay_runtime_image.bin'
manifest_path = image_path.with_name('replay_runtime_image_manifest.json')
extractor_path = PRODUCTION / 'tools/extract_replay_runtime_image.py'
rust_path = PRODUCTION / 'crates/core/src/audio_replay_runtime_image.rs'
manifest = read_json(manifest_path)
package = image_path.read_bytes()
native_path = Path(manifest['native_source'])
native = native_path.read_bytes()
check(sha(native) == EXPECTED_NATIVE == manifest['native_sha256'], 'native_source_sha256', sha(native))
check(sha(package) == EXPECTED_PACKAGE == manifest['package_sha256'], 'package_sha256', sha(package))
check(len(package) == 20872 == manifest['package_bytes'], 'package_byte_count', len(package))
check(package[:8] == b'OL420RT\0', 'package_magic')
schema, count = struct.unpack_from('<II', package, 8)
check(schema == 1, 'package_schema', schema)
check(count == 62 == len(manifest['regions']), 'region_count', count)
check(package[16:48].hex() == EXPECTED_NATIVE, 'package_native_hash_header')

# Independently decode DOS/COFF/PE32 section records. Do not execute the installed
# extractor or reuse pefile.get_memory_mapped_image from its implementation.
check(native[:2] == b'MZ', 'dos_signature')
pe_offset = struct.unpack_from('<I', native, 0x3c)[0]
check(native[pe_offset:pe_offset+4] == b'PE\0\0', 'pe_signature')
machine, section_count = struct.unpack_from('<HH', native, pe_offset + 4)
optional_size = struct.unpack_from('<H', native, pe_offset + 20)[0]
optional = pe_offset + 24
magic = struct.unpack_from('<H', native, optional)[0]
base = struct.unpack_from('<I', native, optional + 28)[0]
image_size = struct.unpack_from('<I', native, optional + 56)[0]
check((machine, magic, base) == (0x14c, 0x10b, 0x400000), 'PE32_machine_magic_base', [machine, magic, base])
check(base == manifest['image_base'], 'manifest_image_base')
sections = []
for i in range(section_count):
    at = optional + optional_size + i * 40
    name = native[at:at+8].split(b'\0', 1)[0].decode('ascii')
    virtual_size, rva, raw_size, raw_offset = struct.unpack_from('<IIII', native, at + 8)
    sections.append({'name': name, 'rva': rva, 'virtual_size': virtual_size,
                     'raw_size': raw_size, 'raw_offset': raw_offset})

# Parse static extractor declarations without importing/running the script.
assignments = {}
for statement in ast.parse(extractor_path.read_text(encoding='utf-8-sig')).body:
    if isinstance(statement, ast.Assign) and len(statement.targets) == 1 and isinstance(statement.targets[0], ast.Name):
        name = statement.targets[0].id
        if name in ('expected', 'regions'):
            assignments[name] = number(statement.value)
        elif name == 'source':
            assignments[name] = number(statement.value.args[0])
check(assignments['expected'] == EXPECTED_NATIVE, 'extractor_native_sha')
check(Path(assignments['source']) == native_path, 'extractor_native_source')
extractor_layout = assignments['regions']
rust_source = rust_path.read_text(encoding='utf-8')
rust_array = re.search(r'const REGIONS:\s*\[\(u32, u32, u32\);\s*(\d+)\]\s*=\s*\[(.*?)\];', rust_source, re.S)
check(rust_array is not None, 'rust_region_table_present')
rust_layout = [[int(x, 0) for x in parts] for parts in
               re.findall(r'\(\s*(0x[0-9a-f]+|\d+),\s*(0x[0-9a-f]+|\d+),\s*(0x[0-9a-f]+|\d+)\s*\)', rust_array.group(2))]
check(int(rust_array.group(1)) == 62 == len(rust_layout) == len(extractor_layout), 'declared_region_counts')
check(EXPECTED_NATIVE in rust_source, 'rust_native_sha')
check('data/4.20/runtime/replay_runtime_image.bin' in rust_source, 'rust_actual_include_path')

offset = 48
regions = []
reconstructed = bytearray(package[:48])
for i in range(count):
    kind, address, size = struct.unpack_from('<III', package, offset)
    offset += 12
    blob = package[offset:offset+size]
    m = manifest['regions'][i]
    check([kind, address, size] == [m['group'], m['address'], m['size']], f'region_{i}_manifest_header')
    check([kind, address, size] == rust_layout[i], f'region_{i}_rust_layout')
    check([m['name'], kind, address, size] == extractor_layout[i], f'region_{i}_extractor_layout')
    check(offset == m['payload_offset'], f'region_{i}_manifest_offset')
    check(sha(blob) == m['sha256'], f'region_{i}_manifest_sha')
    rva = address - base
    containing = [s for s in sections if s['rva'] <= rva and rva + size <= s['rva'] + max(s['virtual_size'], s['raw_size'])]
    check(len(containing) == 1, f'region_{i}_single_PE_section', containing)
    check(0 <= rva < rva + size <= image_size, f'region_{i}_within_PE_image')
    section = containing[0]
    check(section['name'] == m['section'], f'region_{i}_section_name')
    in_section = rva - section['rva']
    initialized = min(size, max(0, section['raw_size'] - in_section))
    raw_offset = section['raw_offset'] + in_section
    check(initialized == 0 or raw_offset + initialized <= len(native), f'region_{i}_raw_file_bounds')
    source_bytes = native[raw_offset:raw_offset+initialized] + bytes(size-initialized)
    equal = check(blob == source_bytes, f'region_{i}_exact_source_bytes')
    reconstructed += struct.pack('<III', kind, address, size) + source_bytes
    regions.append({'index': i, 'name': m['name'], 'group': kind, 'address': address,
                    'size': size, 'payload_offset': offset, 'section': section['name'],
                    'initialized_file_bytes': initialized, 'loader_zero_bytes': size-initialized,
                    'sha256': sha(blob), 'source_sha256': sha(source_bytes), 'exact_match': equal})
    offset += size
check(offset == len(package), 'no_trailing_or_missing_bytes', [offset, len(package)])
check(bytes(reconstructed) == package, 'independent_reconstruction_full_binary')
check(sha(reconstructed) == EXPECTED_PACKAGE, 'independent_reconstruction_sha')

overlaps = []
for i, left in enumerate(regions):
    for right in regions[i+1:]:
        first = max(left['address'], right['address'])
        last = min(left['address'] + left['size'], right['address'] + right['size'])
        if first < last:
            overlaps.append({'left': left['name'], 'right': right['name'],
                'groups': [left['group'], right['group']], 'address': first, 'bytes': last-first})
check(not overlaps, 'no_address_overlap_in_or_across_banks', overlaps)
check(len({r['name'] for r in regions}) == len(regions), 'unique_region_names')
check(len({(r['group'], r['address']) for r in regions}) == len(regions), 'unique_region_bindings')

# Exact width/owner of each clock global and the two live CRT inputs. Clock
# aliases CLOCK_FLAG/ONCE_READY are intentionally one address, one storage slot.
globals_spec = [
    ('loading_package_manager', 0x2d78f1c, 4, 1),
    ('clock_origin', 0x14bef48, 8, 1), ('clock_frequency', 0x14bef50, 8, 1),
    ('clock_frequency_ready', 0x2d79080, 1, 1), ('clock_frequency_cache', 0x2d79158, 8, 1),
    ('clock_once_ready_and_CLOCK_FLAG_alias', 0x2d75530, 4, 1),
    ('clock_callback_vtable', 0x10de608, 4, 1),
    ('clock_mutex_ready', 0x14af61c, 1, 1), ('clock_mutex_pointer', 0x14af620, 4, 1),
    ('clock_outer_state', 0x14b1840, 4, 1), ('clock_outer_section', 0x14b1844, 24, 1),
    ('CRT_security_cookie', 0x1222ed0, 4, 0), ('CRT_CS_dispatch', 0x2da5310, 4, 0),
]
globals_report = []
for name, address, size, group in globals_spec:
    owners = [r for r in regions if r['address'] <= address and address + size <= r['address'] + r['size']]
    check(len(owners) == 1 and owners[0]['group'] == group, f'global_{name}_one_canonical_bank', owners)
    owner = owners[0]
    position = owner['payload_offset'] + address - owner['address']
    globals_report.append({'name': name, 'address': address, 'size': size,
        'expected_group': group, 'owner_regions': [r['name'] for r in owners],
        'initial_hex': package[position:position+size].hex(), 'unique': len(owners) == 1})


result = {
 'passed': not errors, 'complete_game': False,
 'scope': 'Independent initial-image verification in staging, not runtime qualification',
 'native_source_sha256': sha(native), 'package_sha256': sha(package),
 'region_count': len(regions), 'package_bytes': len(package),
 'source_regions': regions, 'overlaps': overlaps, 'globals': globals_report,
 'extractor_executed_by_this_audit': False, 'compiler_executed': False,
 'production_modified': False, 'errors': errors,
 'script_sha256': file_sha(Path(__file__)),
}
REPORT.write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps({k:v for k,v in result.items() if k not in ['source_regions','globals']}))
assert not errors, errors
