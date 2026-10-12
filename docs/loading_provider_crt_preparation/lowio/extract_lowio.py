"""Static extraction only: no emulator, OS I/O probe, compilation or production writes."""
from pathlib import Path
import hashlib
import importlib.util
import json
import struct
import sys

sys.dont_write_bytecode = True
OUT = Path(__file__).resolve().parent
EXTRACTOR = Path('E:/OpenLeague/docs/loading_standard_resource_preparation/extract_resource.py')
spec = importlib.util.spec_from_file_location('lowio_original_bytes', EXTRACTOR)
src = importlib.util.module_from_spec(spec)
spec.loader.exec_module(src)  # Its file-writing entry point is guarded by __main__.

# Budgets bound traversal; callees are explicit entries, not recursively executed.
ENTRIES = [
    ('lowio_initialize', 0xCAFF53, 0x2AB),
    ('lowio_initialize_finally_unlock11', 0xCB01FE, 9),
    ('crt_lock', 0xCB0247, 0x34),
    ('crt_dynamic_lock_ensure', 0xCB02CF, 0xA0),
    ('crt_dynamic_lock_finally_unlock10', 0xCB036F, 9),
    ('crt_unlock', 0xCB03B1, 0x15),
    ('critical_section_dispatch', 0xCABD7A, 0x2E),
    ('descriptor_lock', 0xCA717C, 0x82),
    ('descriptor_lock_finally_unlock10', 0xCA7201, 9),
    ('descriptor_unlock', 0xCA7638, 0x26),
    ('descriptor_close', 0xCAF488, 0xDB),
    ('descriptor_close_finally_unlock', 0xCAF53B, 8),
    ('descriptor_close_nolock', 0xCAF563, 0x9A),
    ('descriptor_invalidate_os_handle', 0xCA73B3, 0x86),
    ('descriptor_get_os_handle', 0xCA7439, 0x67),
    ('stdio_pointer_table_initialize', 0xC9AD72, 0x73),
    ('stdio_pointer_table_terminate', 0xC9ADE5, 0x27),
    ('stdio_fcloseall_nonstandard', 0xCB124E, 0x91),
    ('stdio_fcloseall_finally_unlock1', 0xCB12E2, 9),
    ('stdio_fclose_body', 0xC997E9, 0x6C),
]
DATA = [
    ('lowio_block_pointer_table_64', 0x14AE888, 64 * 4),
    ('lowio_descriptor_capacity', 0x2DA52EC, 4),
    ('stdio_pointer_table_and_capacity', 0x2DA63A0, 8),
    ('stdio_conditional_closeall_flag', 0x14AE5E0, 1),
    ('standard_handle_reset_mode', 0x14AEAD8, 4),
    ('static_stdio_records20x32', 0x12225B0, 20 * 32),
    ('security_cookie', 0x1222ED0, 4),
    ('critical_section_encoded_dispatch', 0x2DA5310, 4),
    ('global_lock_table_36x8', 0x1223580, 36 * 8),
    ('lowio_initialize_scope_table', 0x11C2CF8, 32),
    ('descriptor_close_scope_table', 0x11C2CD8, 32),
    ('descriptor_lock_scope_table', 0x11C2A68, 32),
    ('dynamic_lock_scope_table', 0x11C2D18, 32),
    ('stdio_fcloseall_scope_table', 0x11C2D98, 32),
]

imports = {}
for desc in src.pe.DIRECTORY_ENTRY_IMPORT:
    for imp in desc.imports:
        imports[imp.address] = {'dll': desc.dll.decode('ascii'), 'name': imp.name.decode('ascii') if imp.name else None, 'ordinal': imp.ordinal}

regions, text = [], []
for role, address, budget in ENTRIES:
    row, disasm = src.walk(role, address, budget)
    assert not row['edges'], (role, row['edges'])
    for call in row['calls']:
        if call['target'] is None:
            for address, imp in imports.items():
                if hex(address) in call['operand']:
                    call['iat'] = address
                    call['import'] = imp
    regions.append(row)
    text.append(disasm)

def bytes_region(role, address, size):
    data = src.read(address, size)
    return dict(role=role, address=address, size=size, hex=data.hex(), sha256=hashlib.sha256(data).hexdigest())

data_regions = [bytes_region(*item) for item in DATA]
# This is a call-site fragment, not a complete CRT startup body.
caller = bytes_region('crt_startup_heap_then_thread_then_lowio_fragment', 0xCA0F8E, 0x3C)
caller['disassembly'] = '\n'.join(f'{i.address:08x} {i.mnemonic} {i.op_str}' for i in src.md.disasm(bytes.fromhex(caller['hex']), caller['address']))

# Candidate search is deliberately bounded to the CRT neighborhood. It cannot
# prove absence of a destructor outside the region or via indirect references.
scan_start, scan_end = 0xC97000, 0xCD0000
scan = src.read(scan_start, scan_end - scan_start)
xrefs = {}
for address in [0x14AE888, 0x2DA52EC, 0x2DA63A0]:
    needle = struct.pack('<I', address)
    cursor, found = 0, []
    while True:
        at = scan.find(needle, cursor)
        if at < 0:
            break
        found.append(scan_start + at)
        cursor = at + 1
    xrefs[f'{address:08x}'] = found

report = dict(
    kind='bounded_static_source_extraction', source=str(src.EXE), source_sha256=src.digest,
    execution_performed=False, rust_compiled=False, production_integrated=False,
    source_extractor=str(EXTRACTOR), source_extractor_sha256=hashlib.sha256(EXTRACTOR.read_bytes()).hexdigest(),
    functions=regions, data=data_regions, caller_fragment=caller,
    destructor_search=dict(start=scan_start, end_exclusive=scan_end,
        bytes_sha256=hashlib.sha256(scan).hexdigest(), immediate_operand_candidates=xrefs,
        lowio_block_destructor_identified=False,
        limit='Operand candidates are not function-boundary proofs. Descriptor close and separate stdio table teardown are identified; no global lowIO block teardown is claimed.'),
    limits=[
        'No function, Windows API, imported I/O, allocation or teardown was executed here.',
        'Inherited StartupInfo buffers, OS failure paths, SEH/abnormal exit and races require native execution before a Rust lifecycle is called qualified.',
        'Untouched record padding comes from the actual calloc service. Opaque Windows critical-section bytes are not reconstructed or treated as stable.',
        'The recovered FILE table teardown is not a destructor for the separate lowIO64-byte descriptor blocks.',
        'Source lowIO/stdio are not substituted with the host UCRT. Existing host CRT file APIs remain a distinct explicitly adapted domain.',
    ],
)
(OUT / 'lowio_source.json').write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
(OUT / 'lowio_disassembly.txt').write_text('\n\n'.join(text + [caller['disassembly']]) + '\n', encoding='utf-8')
print(json.dumps({'functions': len(regions), 'function_bytes': sum(r['size'] for r in regions),
    'data_regions': len(data_regions), 'data_bytes': sum(r['size'] for r in data_regions),
    'source_json_sha256': hashlib.sha256((OUT/'lowio_source.json').read_bytes()).hexdigest(),
    'destructor_identified': False, 'native_execution': False}))
