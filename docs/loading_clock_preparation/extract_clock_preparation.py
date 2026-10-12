"""Bounded static evidence only. Does not execute PE code or modify production."""
from pathlib import Path
import ast
import hashlib
import json
import struct
import sys

import capstone
import pefile

ROOT = Path(__file__).resolve().parent
SOURCE = Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe')
EXPECTED = '402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
PROJECT = Path('E:/OpenLeague')

CODE = [
    ('clock_initialize', 0x993c70, 0x6f),
    ('clock_sample', 0x993ce0, 0xc0),
    ('clock_callback', 0x995850, 0x7),
    ('callback_trampoline', 0xce13e2, 0xb),
    ('clock_once', 0xce298a, 0x42),
    ('once_mutex_initialize', 0xce2961, 0x29),
    ('once_mutex_cleanup_callback', 0xce2955, 0xc),
    ('once_mutex_allocate', 0xce28cf, 0x3c),
    ('once_mutex_lock', 0xce290b, 0x11),
    ('once_mutex_unlock', 0xce2934, 0x21),
    ('once_mutex_destroy', 0xce289e, 0x24),
    ('mutex_lock_dispatch', 0xce2702, 0x164),
    ('mutex_inner_initialize', 0xcbe86c, 0x20),
    ('outer_once', 0xce5247, 0x7a),
    ('outer_once_cleanup', 0xce52c1, 0xc),
    ('critical_section_initialize_dispatch', 0xcabd7a, 0x2e),
    ('outer_once_sleep', 0xcbe63c, 0xe),
    ('mutex_initialize_failure', 0xce13ed, 0x2c),
]
DATA = [
    ('wall_origin_and_frequency', 0x14bef48, 16),
    ('frequency_cache_ready', 0x2d79080, 1),
    ('frequency_cache', 0x2d79158, 8),
    ('clock_once_ready', 0x2d75530, 4),
    ('clock_callback_vtable_slot0', 0x10de608, 4),
    ('once_mutex_ready_byte', 0x14af61c, 1),
    ('once_mutex_pointer', 0x14af620, 4),
    ('outer_once_state', 0x14b1840, 4),
    ('outer_once_critical_section_pe32', 0x14b1844, 24),
    ('crt_cookie_reused', 0x1222ed0, 4),
    ('crt_cs_dispatch_reused', 0x2da5310, 4),
]
IATS = [0xfa4134, 0xfa4180, 0xfa4424, 0xfa4428, 0xfa41bc, 0xfa4270, 0xfa4378, 0xfa43c8]
SNAPSHOTS = [
    'crates/client/src/native_effect_clock.rs',
    'crates/core/src/native_game_clock.rs',
    'crates/core/src/audio_loading_screen_packet.rs',
    'crates/core/src/audio_replay_windows_loading_metadata.rs',
    'crates/core/src/audio_replay_windows_loading_packets.rs',
    'crates/core/src/audio_crt_windows_engine_worker.rs',
    'crates/core/src/audio_crt_static_lock_startup.rs',
    'crates/core/src/audio_crt_windows_critical_sections.rs',
    'crates/core/src/audio_crt_heap.rs',
    'crates/core/src/audio_crt_windows_process_heap.rs',
    'crates/core/src/audio_replay_runtime_image.rs',
    'tools/extract_replay_runtime_image.py',
    'tools/probe_native_qpc_resync.py',
    'docs/native_qpc_resync_progress.json',
]

def sha(raw):
    return hashlib.sha256(raw).hexdigest()

def write_json(name, data):
    (ROOT / name).write_text(json.dumps(data, indent=2) + '\n', encoding='utf-8')

raw = SOURCE.read_bytes()
assert sha(raw) == EXPECTED, 'Pinned PE mismatch; no extraction permitted'
pe = pefile.PE(data=raw)
base = pe.OPTIONAL_HEADER.ImageBase
assert base == 0x400000 and pe.FILE_HEADER.Machine == 0x14c and pe.OPTIONAL_HEADER.Magic == 0x10b
mapped = pe.get_memory_mapped_image()
image = mapped + bytes(pe.OPTIONAL_HEADER.SizeOfImage - len(mapped))
decoder = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
decoder.detail = True

def extract(kind, name, address, size):
    rva = address - base
    matching = [s for s in pe.sections if s.VirtualAddress <= rva and rva + size <= s.VirtualAddress + max(s.Misc_VirtualSize, s.SizeOfRawData)]
    assert len(matching) == 1, (name, hex(address), size)
    section = matching[0]
    offset = rva - section.VirtualAddress
    file_count = min(size, max(0, section.SizeOfRawData - offset))
    blob = image[rva:rva + size]
    assert len(blob) == size
    if file_count:
        file_offset = section.PointerToRawData + offset
        assert blob[:file_count] == raw[file_offset:file_offset + file_count]
    else:
        file_offset = None
    assert blob[file_count:] == bytes(size - file_count)
    relative = f'bytes/{kind}_{address:08x}.bin'
    (ROOT / relative).parent.mkdir(exist_ok=True)
    (ROOT / relative).write_bytes(blob)
    record = dict(kind=kind, name=name, address=address, address_hex=f'0x{address:08x}', size=size,
                  section=section.Name.rstrip(b'\0').decode('ascii'),
                  file_offset=file_offset, file_backed_bytes=file_count, loader_zero_fill_bytes=size-file_count,
                  hex=blob.hex(), sha256=sha(blob), path=relative)
    return record, blob

regions = []
assembly = []
direct_edges = []
for name, address, size in CODE:
    record, blob = extract('code', name, address, size)
    instructions = list(decoder.disasm(blob, address))
    assert sum(i.size for i in instructions) == size, name
    assert instructions[-1].mnemonic in ('ret', 'jmp'), (name, instructions[-1].mnemonic)
    record['instruction_count'] = len(instructions)
    regions.append(record)
    assembly.append(f'; {name} | {address:#x}+{size:#x} | SHA256 {record["sha256"]}')
    for ins in instructions:
        assembly.append(f'{ins.address:08x} {ins.bytes.hex():22s} {ins.mnemonic} {ins.op_str}')
        if ins.mnemonic in ('call', 'jmp'):
            for operand in ins.operands:
                if operand.type == capstone.x86.X86_OP_IMM:
                    target = operand.imm & 0xffffffff
                    if not address <= target < address + size:
                        direct_edges.append(dict(source=ins.address, kind=ins.mnemonic, target=target,
                                                 included=any(a <= target < a+n for _,a,n in CODE)))
    assembly.append('')
for name, address, size in DATA:
    record, blob = extract('data', name, address, size)
    regions.append(record)

imports_by_address = {i.address: dict(dll=d.dll.decode('ascii'), name=i.name.decode('ascii') if i.name else None, ordinal=i.ordinal)
                      for d in pe.DIRECTORY_ENTRY_IMPORT for i in d.imports}
imports = []
for address in IATS:
    value = imports_by_address[address]
    record, blob = extract('iat_initial', value['name'], address, 4)
    record.update(value)
    imports.append(record)
assert imports_by_address[0xfa4134]['name'] == 'QueryPerformanceCounter'
assert imports_by_address[0xfa4180]['name'] == 'QueryPerformanceFrequency'

snapshot_records = []
for relative in SNAPSHOTS:
    source = PROJECT / relative
    contents = source.read_bytes()
    destination = Path('source_snapshots') / relative
    (ROOT / destination).parent.mkdir(parents=True, exist_ok=True)
    (ROOT / destination).write_bytes(contents)
    snapshot_records.append(dict(source=str(source), path=destination.as_posix(), bytes=len(contents), sha256=sha(contents)))

# Parse the extractor's literal region list, never execute the production writer.
extractor = ROOT / 'source_snapshots/tools/extract_replay_runtime_image.py'
tree = ast.parse(extractor.read_text(encoding='utf-8'))
assignment = next(n for n in tree.body if isinstance(n,ast.Assign) and any(isinstance(t,ast.Name) and t.id=='regions' for t in n.targets))
def literal(node):
    if isinstance(node,ast.BinOp) and isinstance(node.op,ast.Mult): return literal(node.left)*literal(node.right)
    if isinstance(node,(ast.List,ast.Tuple)): return [literal(n) for n in node.elts]
    return ast.literal_eval(node)
existing = literal(assignment.value)
coverage = []
for name, address, size in DATA:
    hits = [n for n,g,a,z in existing if a <= address and address+size <= a+z]
    coverage.append(dict(name=name,address=address,size=size,covered_by=hits))

proof = dict(schema=1, kind='bounded_static_clock_preparation', native_source=str(SOURCE), native_sha256=EXPECTED,
             native_pe_bytes=len(raw), image_base=base, pe_machine=pe.FILE_HEADER.Machine,
             rust_tests_run=False, native_execution_run=False, production_integrated=False,
             code_regions=len(CODE), code_bytes=sum(n for _,_,n in CODE),
             data_regions=len(DATA), data_bytes=sum(n for _,_,n in DATA),
             regions=regions, imports=imports, direct_call_or_tail_edges=direct_edges,
             external_direct_targets=sorted({e['target'] for e in direct_edges if not e['included']}),
             production_snapshot=snapshot_records,
             runtime_extractor_region_count=len(existing), runtime_region_coverage=coverage,
             scope='Exact bounded PE bytes and static dependencies. External targets are boundaries, not qualified implementations. Import thunk bytes are initial PE data, never callable host pointers.',
             source_tools=dict(python=sys.version.split()[0],pefile=pefile.__version__,capstone=capstone.__version__))
write_json('clock_sources.json', proof)
(ROOT / 'clock_disassembly.txt').write_text('\n'.join(assembly), encoding='utf-8')

# Independent round-trip of each exported native region before issuing receipt.
for record in regions + imports:
    contents = (ROOT / record['path']).read_bytes()
    start = record['address'] - base
    assert contents == image[start:start + record['size']]
    assert sha(contents) == record['sha256'] and contents.hex() == record['hex']
assert sha(SOURCE.read_bytes()) == EXPECTED, 'PE changed during extraction'

files = []
for path in sorted(ROOT.rglob('*')):
    if path.is_file() and path.name != 'manifest.json':
        contents = path.read_bytes()
        files.append(dict(path=path.relative_to(ROOT).as_posix(),bytes=len(contents),sha256=sha(contents)))
manifest = dict(schema=1,native_sha256=EXPECTED,verified=True,
                verification='PE SHA checked before/after; every exported region round-tripped against PE mapped bytes; file bytes and loader zero-fill independently checked.',
                rust_tests_run=False,native_execution_run=False,production_integrated=False,
                code_regions=len(CODE),code_bytes=sum(n for _,_,n in CODE),data_regions=len(DATA),data_bytes=sum(n for _,_,n in DATA),
                import_thunks=len(imports),import_thunk_bytes=4*len(imports),files=files)
write_json('manifest.json',manifest)
print(json.dumps(dict(verified=True,native_sha256=EXPECTED,code_regions=len(CODE),code_bytes=manifest['code_bytes'],
                     data_regions=len(DATA),data_bytes=manifest['data_bytes'],import_thunks=len(imports),
                     source_sha256=sha((ROOT/'clock_sources.json').read_bytes()),
                     disassembly_sha256=sha((ROOT/'clock_disassembly.txt').read_bytes()),
                     manifest_sha256=sha((ROOT/'manifest.json').read_bytes()),runtime_snapshot_regions=len(existing))))
