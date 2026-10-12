"""Bounded static source audit. Does not execute game code or compile anything."""
from pathlib import Path
import hashlib
import json
import struct
import sys

sys.path.insert(0, "E:/OpenLeague/tools/pythonlibs")
import capstone
import pefile

ROOT = Path(__file__).resolve().parent
PE = Path(r"D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe")
EXPECTED = "402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862"

def sha(data):
    return hashlib.sha256(data).hexdigest()

def save(name, obj):
    (ROOT / name).write_text(json.dumps(obj, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

raw = PE.read_bytes()
assert sha(raw) == EXPECTED
pe = pefile.PE(data=raw)
image = pe.get_memory_mapped_image()
base = pe.OPTIONAL_HEADER.ImageBase
assert base == 0x400000 and pe.FILE_HEADER.Machine == 0x14C
cs = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
cs.detail = True

def get(va, size):
    result = image[va - base:va - base + size]
    assert len(result) == size
    return result

# End addresses are exclusive. Existing loading construction/selection audits
# are referenced separately, rather than claiming they were newly qualified.
regions = [
    ("process_owner_592E80", 0x592E80, 0x59313D, "code"),
    ("process_initialization_58FCB0", 0x58FCB0, 0x58FF4B, "code"),
    ("startup_after_service_58FF50", 0x58FF50, 0x590E55, "code"),
    ("launch_workflow_5910C0", 0x5910C0, 0x5923B4, "code"),
    ("loading_lifetime_58E550", 0x58E550, 0x58EEF7, "code"),
    ("loading_prepare_58D7B0", 0x58D7B0, 0x58E54A, "code"),
    ("loading_tick_58D550", 0x58D550, 0x58D5D0, "code"),
    ("loading_tick_inner_58CB20", 0x58CB20, 0x58D536, "code"),
    ("loading_wrapper_entry_577D10", 0x577D10, 0x577DEB, "code"),
    ("loading_wrapper_reset_577DF0", 0x577DF0, 0x577E88, "code"),
    ("process_shutdown_590E70", 0x590E70, 0x5910BD, "code"),
    ("service_stop_72A9F0", 0x72A9F0, 0x72AA2A, "code"),
    ("service_mode_718AD0", 0x718AD0, 0x718AD7, "code"),
    ("service_construct_72A3B0", 0x72A3B0, 0x72A522, "code"),
    ("service_delete_72A530", 0x72A530, 0x72A5F3, "code"),
    ("wrapper_publish_5C7E30", 0x5C7E30, 0x5C7E98, "code"),
    ("service_vtable_10AFE8C", 0x10AFE8C, 0x10AFFA4, "data"),
]
(ROOT / "bytes").mkdir(exist_ok=True)
manifest_regions = []
instructions = {}
disassembly = []
for name, start, end, kind in regions:
    data = get(start, end - start)
    (ROOT / "bytes" / (name + ".bin")).write_bytes(data)
    entry = dict(name=name, start=f"0x{start:08X}", end_exclusive=f"0x{end:08X}", size=len(data), sha256=sha(data), kind=kind, path=f"bytes/{name}.bin")
    if kind == "code":
        decoded = list(cs.disasm(data, start))
        assert sum(i.size for i in decoded) == len(data), (name, "incomplete linear decode")
        entry["instruction_count"] = len(decoded)
        entry["direct_calls"] = []
        disassembly.append(f"\n[{name}] {start:08X}..{end:08X} SHA256 {sha(data)}\n")
        for i in decoded:
            instructions[i.address] = i
            disassembly.append(f"{i.address:08X} {i.bytes.hex():24} {i.mnemonic} {i.op_str}\n")
            if i.mnemonic == "call" and i.operands[0].type == capstone.x86.X86_OP_IMM:
                entry["direct_calls"].append(dict(site=f"0x{i.address:08X}", target=f"0x{i.operands[0].imm:08X}"))
    manifest_regions.append(entry)
(ROOT / "source_disassembly.txt").write_text("".join(disassembly), encoding="utf-8")

section = next(s for s in pe.sections if s.Name.startswith(b".text"))
text_bytes = section.get_data()
text_base = base + section.VirtualAddress
globals_found = []
for target in (0x2D787B8, 0x14C761C, 0x14C7620):
    offset = 0
    candidates = {}
    raw_count = 0
    while True:
        offset = text_bytes.find(struct.pack("<I", target), offset)
        if offset < 0:
            break
        raw_count += 1
        for start in range(max(0, offset - 8), offset):
            ins = next(cs.disasm(text_bytes[start:offset + 10], text_base + start, count=1), None)
            if not ins or not (ins.address <= text_base + offset and ins.address + ins.size >= text_base + offset + 4):
                continue
            if any(o.type == capstone.x86.X86_OP_MEM and not o.mem.base and not o.mem.index and o.mem.disp == target and o.access & capstone.CS_AC_WRITE for o in ins.operands):
                candidates[ins.address] = ins
        offset += 4
    confirmed = []
    for address, ins in sorted(candidates.items()):
        actual = instructions.get(address)
        assert actual is not None and actual.bytes == ins.bytes, (hex(target), hex(address), "candidate needs an enclosing-function decode")
        confirmed.append(dict(site=f"0x{address:08X}", bytes=ins.bytes.hex(), mnemonic=ins.mnemonic, operands=ins.op_str))
    globals_found.append(dict(address=f"0x{target:08X}", initial_mapped_bytes=get(target, 4).hex(), raw_literal_occurrences_in_text=raw_count, confirmed_absolute_writes=confirmed))
assert [x["site"] for x in globals_found[0]["confirmed_absolute_writes"]] == ["0x0058FE54", "0x00590F27"]
save("global_writers.json", dict(method="Literal search in all .text raw bytes; decode candidates with absolute memory destination; confirm every writer at an instruction boundary decoded from its enclosing function start. Does not exclude indirect writes, runtime patching, or non-.text code.", section_va=f"0x{text_base:08X}", section_size=len(text_bytes), globals=globals_found))

edge_specs = [
    (0x592E80, 0x592F88, 0x58FCB0, "process initialization before launch"),
    (0x58FCB0, 0x58FE2C, 0x9933E0, "allocate 0x188 bytes"),
    (0x58FCB0, 0x58FE44, 0x72A3B0, "constructor only when allocation is nonzero"),
    (0x592E80, 0x59307A, 0x58FF50, "startup after service publication"),
    (0x592E80, 0x593085, 0x5910C0, "only if 58FF50 returns AL != 0"),
    (0x5910C0, 0x591E52, 0x58E550, "loading branch; not unconditional at entry"),
    (0x58E550, 0x58E5AE, 0x58D7B0, "prepare before loading loop"),
    (0x58D7B0, 0x58D9E7, 0x577D10, "wrapper construction and selection"),
    (0x577D10, 0x577D5E, 0x576280, "wrapper ctor on previously null global"),
    (0x577D10, 0x577D6F, 0x5C7E30, "publish wrapper shared pair"),
    (0x5C7E30, 0x5C7E4C, 0x5D7750, "construct wrapper owning control"),
    (0x577D10, 0x577D7B, 0x5765F0, "select actual recipient after global wrapper publication"),
    (0x577D10, 0x577DD5, 0x5768E0, "later wrapper activation/layout boundary"),
    (0x58E550, 0x58E676, 0x58D550, "loading loop tick"),
    (0x58D550, 0x58D56F, 0x58CB20, "inner loading tick"),
    (0x58CB20, 0x58D1FE, 0x577DF0, "reset iff service virtual+0xBC returned AL == 0 on this branch"),
    (0x58E550, 0x58E9CE, 0x577DF0, "reset after loading loop on ordinary return route"),
    (0x577DF0, 0x577E0A, 0x5CC140, "retain temporary global pair before clearing"),
    (0x592E80, 0x5930EF, 0x590E70, "shutdown after launch returns or earlier startup branch exits"),
]
edges = []
for caller, site, callee, condition in edge_specs:
    i = instructions[site]
    assert i.mnemonic == "call" and i.operands[0].type == capstone.x86.X86_OP_IMM and i.operands[0].imm == callee, (hex(site), hex(callee))
    edges.append(dict(caller=f"0x{caller:08X}", site=f"0x{site:08X}", callee=f"0x{callee:08X}", bytes=i.bytes.hex(), condition=condition))
targets = {c for _, _, c, _ in edge_specs}
targets.update((0x58FCB0, 0x590E70, 0x72A3B0, 0x577DF0))
e8_xrefs = {f"0x{t:08X}": [] for t in targets}
for off in range(len(text_bytes) - 4):
    if text_bytes[off] != 0xE8:
        continue
    target = (text_base + off + 5 + struct.unpack_from("<i", text_bytes, off + 1)[0]) & 0xFFFFFFFF
    if target in targets:
        e8_xrefs[f"0x{target:08X}"].append(f"0x{text_base + off:08X}")
indirect = []
for site, receiver, slot, target, condition in [
    (0x590F0E, "fresh [SERVICE_GLOBAL]", 0x20, 0x72A9F0, "normal service vtable10AFE8C; no null guard before Stop"),
    (0x590F1F, "re-read [SERVICE_GLOBAL] after Stop", 0, 0x72A530, "only if re-read pointer nonzero; flags1"),
    (0x577DAB, "fresh [SERVICE_GLOBAL]", 0xB0, 0x718AD0, "mode byte service+0x122"),
    (0x72AA22, "fresh [service+0xCC] after logging", 0x30, None, "only if service+0x122 != 0 and nested object != 0; target remains dynamic"),
]:
    i = instructions[site]
    assert i.mnemonic == "call"
    indirect.append(dict(site=f"0x{site:08X}", bytes=i.bytes.hex(), receiver=receiver, slot=f"0x{slot:X}", target_if_known=f"0x{target:08X}" if target else None, condition=condition))
save("callgraph.json", dict(direct_verified=edges, virtual_verified=indirect, raw_e8_xrefs=e8_xrefs, xref_limit="Raw E8 candidates outside extracted functions are leads only, not proven instruction boundaries; virtual/indirect callers may also exist."))

vtable = [dict(offset=f"0x{x:X}", target=f"0x{struct.unpack('<I', get(0x10AFE8C+x,4))[0]:08X}") for x in range(0, 0x118, 4)]
strings = []
for va in (0x10868C8, 0x1088754, 0x108B90C, 0x10B1874):
    data = get(va, 256).split(b"\0")[0] + b"\0"
    strings.append(dict(address=f"0x{va:08X}", text=data[:-1].decode("ascii"), bytes=data.hex(), sha256=sha(data)))
imports = []
for module in pe.DIRECTORY_ENTRY_IMPORT:
    for symbol in module.imports:
        if symbol.address == 0xFA45B4:
            imports.append(dict(iat=f"0x{symbol.address:08X}", dll=module.dll.decode(), name=symbol.name.decode()))
assert imports[0]["name"] == "LoadIconA"
save("data_evidence.json", dict(service_vtable=vtable, strings=strings, imports=imports))

references = []
for name in (
    "docs/replay_loading_screen_preparation/AUDIT.md",
    "docs/replay_loading_screen_preparation/recipient_selection.txt",
    "docs/replay_loading_screen_preparation/recipient_wrapper_functions.txt",
    "docs/replay_loading_screen_preparation/recipient_audit_manifest.json",
    "crates/core/src/audio_game_service_lifecycle.rs",
    "crates/core/src/audio_replay_windows_service.rs",
    "crates/core/src/audio_replay_windows_loading_packets_tests.rs",
    "crates/core/src/audio_replay_loading_owner.rs",
):
    path = Path("E:/OpenLeague") / name
    d = path.read_bytes()
    references.append(dict(path=str(path), size=len(d), sha256=sha(d), purpose="Existing source/context at audit time, not a claim of new qualification"))
save("source_manifest.json", dict(source=str(PE), source_sha256=EXPECTED, architecture="PE32 x86", image_base=f"0x{base:08X}", tool_versions=dict(pefile=pefile.__version__, capstone=capstone.__version__), regions=manifest_regions, existing_references=references, qualification=dict(static_only=True, native_code_executed=False, rust_compiled=False, production_modified=False)))
artifacts = ["AUDIT.md", "source_manifest.json", "source_disassembly.txt", "callgraph.json", "global_writers.json", "data_evidence.json", "extract_service_global_preparation.py"]
save("evidence_index.json", dict(artifacts=[dict(path=n, sha256=sha((ROOT/n).read_bytes()), size=(ROOT/n).stat().st_size) for n in artifacts], code_regions=sum(r[3]=="code" for r in regions), data_regions=sum(r[3]=="data" for r in regions), verified_direct_edges=len(edges), verified_virtual_edges=len(indirect)))
print(json.dumps(dict(regions=len(regions), direct_edges=len(edges), virtual_edges=len(indirect), service_absolute_writers=len(globals_found[0]["confirmed_absolute_writes"]), evidence_index_sha256=sha((ROOT/"evidence_index.json").read_bytes())), indent=2))
