from pathlib import Path
import hashlib
import json
import struct
import pefile

root = Path('E:/mapslol3v3/replay_manager_agent')
manifest = json.loads(Path('E:/OpenLeague/data/4.20/runtime/replay_runtime_image_manifest.json').read_text())
source = Path(manifest['native_source'])
raw = source.read_bytes()
digest = hashlib.sha256(raw).hexdigest()
assert digest == '402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
pe = pefile.PE(data=raw)
mapped = pe.get_memory_mapped_image()
regions = []
for address, length, role in [
    (0x728150, 0x69, 'set_count'), (0x7281c0, 0x4e, 'get_count'),
    (0x7285b0, 0x120, 'put_string_extra'), (0x728830, 0x170, 'put_string_c'),
    (0x728a40, 0x19, 'mark1'), (0x728a60, 0x19, 'mark2'),
    (0x72e390, 0x76, 'find_composite'), (0x7334d0, 0x4b, 'copy_pair_extra'),
    (0x733520, 0x20, 'copy_pair_string'), (0x734d70, 0xd0, 'create_node56'),
    (0x734e40, 0x140, 'insert_node56'), (0x734f80, 0x40, 'create_node48'),
    (0x734fc0, 0x140, 'insert_node48'), (0x735ef0, 0x1c0, 'link_rebalance56'),
    (0x7360b0, 0x1c0, 'link_rebalance48'), (0x5c4680, 0x2ca, 'erase_string_node'),
    (0x64d040, 0x77, 'value_slot24'), (0x661f80, 0x29, 'create_node24'),
    (0x10b00c4, 100, 'metadata_derived_vtable'),
]:
    data = mapped[address - pe.OPTIONAL_HEADER.ImageBase:address - pe.OPTIONAL_HEADER.ImageBase + length]
    assert len(data) == length
    row = {'address': address, 'length': length, 'role': role, 'sha256': hashlib.sha256(data).hexdigest(), 'hex': data.hex()}
    if 'vtable' in role:
        row['slots'] = [{'offset': i, 'target': struct.unpack_from('<I', data, i)[0]} for i in range(0, length, 4)]
    regions.append(row)
proof = {'native_source': str(source), 'native_sha256': digest, 'regions': regions,
         'limits': ['Raw PE source extraction only. Helper extents include adjacent padding/exception landing pads where indicated by the fixed extraction length. No runtime region installation.']}
(root / 'metadata_setter_sources.json').write_text(json.dumps(proof, indent=2) + '\n')
print(json.dumps({'native_sha256': digest, 'regions': len(regions), 'vtable': regions[-1]['slots']}))
