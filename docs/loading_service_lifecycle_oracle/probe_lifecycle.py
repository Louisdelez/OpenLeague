"""Run original x86 Stop, outer shutdown fragment and loading pair reset.

No Rust, production writes, game process or renderer. Explicit terminal interfaces
are recorded, never described as completed service/UI implementations.
"""
from pathlib import Path
import hashlib
import itertools
import json
import struct
import sys

ROOT = Path(__file__).resolve().parent
sys.path.insert(0, "E:/OpenLeague/tools/pythonlibs")
import pefile
import unicorn
from unicorn.x86_const import *

SOURCE = Path(r"D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe")
DIGEST = "402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862"
raw = SOURCE.read_bytes()
assert hashlib.sha256(raw).hexdigest() == DIGEST
pe = pefile.PE(data=raw)
IMAGE = pe.get_memory_mapped_image()
BASE = 0x400000
H, STACK, END, ARCHIVE, ARENA = 0x30000000, 0x31000000, 0x32000000, 0x34000000, 0x35000000
G, SERVICE = 0x14C761C, 0x2D787B8
INIT, DEL, UI_CLOSE, UI_DELETE, CUSTOM = [END + x for x in (0x100, 0x200, 0x300, 0x400, 0x500)]
NESTED_A, NESTED_B, DELETE_A, DELETE_B = [END + x for x in (0x600, 0x700, 0x800, 0x900)]
VTA, VTB, NVA, NVB, RVT = [H + x for x in (0x1000, 0x1200, 0x1400, 0x1600, 0x1800)]
SRC, TMP = H + 0x2000, H + 0x2200
ARCHIVE_FIXTURE = Path("E:/OpenLeague/data/4.20/audio_game_service_lifecycle_contract.json")
archived_bytes = ARCHIVE_FIXTURE.read_bytes()
archived = json.loads(archived_bytes)
assert archived["passed"] and archived["native_sha256"] == DIGEST

def sha(data):
    return hashlib.sha256(data).hexdigest()

def dump(name, value):
    (ROOT / name).write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

class Native:
    def __init__(self):
        self.u = unicorn.Uc(unicorn.UC_ARCH_X86, unicorn.UC_MODE_32)
        self.u.mem_map(BASE, (len(IMAGE) + 4095) & ~4095)
        self.u.mem_write(BASE, IMAGE)
        for address, size in ((0, 0x10000), (H, 0x10000), (STACK, 0x10000), (END, 0x10000), (ARCHIVE, 0x200000), (ARENA, 0x200000)):
            self.u.mem_map(address, size)
        self.all_native = {}
        self.active = False
        self.u.hook_add(unicorn.UC_HOOK_CODE, self.code)
        self.u.hook_add(unicorn.UC_HOOK_MEM_READ | unicorn.UC_HOOK_MEM_WRITE, self.memory)
        self.reset(0)

    def rd(self, p):
        return struct.unpack("<I", self.u.mem_read(p, 4))[0]

    def wr(self, p, value):
        self.u.mem_write(p, struct.pack("<I", value & 0xFFFFFFFF))

    def rb(self, p):
        return self.u.mem_read(p, 1)[0]

    def wb(self, p, value):
        self.u.mem_write(p, bytes([value]))

    def reset(self, fill):
        self.fill = fill
        self.cursor = ARENA
        self.live, self.locks, self.events, self.body_seen = {}, set(), [], set()
        self.log_action = self.nested_action = self.delete_action = self.ui_action = None
        self.track = False
        self.watch = {G, G+4, SERVICE}
        self.u.mem_write(H, bytes([fill]) * 0x10000)
        self.u.mem_write(STACK, bytes([fill]) * 0x10000)
        self.wr(0, 0)
        for address, value in ((G, 0), (G+4, 0), (SERVICE, 0), (TMP, 0), (TMP+4, 0), (0x14BEF40, 0), (0x14BEF44, 0x11223344), (0x14AE870, 0), (0x2D78D08, SRC), (0x2D788BC, 0x33445566), (0x2D77E44, 0x12345678), (0xFA41A0, INIT), (0xFA41BC, DEL)):
            self.wr(address, value)
        self.u.mem_write(SRC, b"en_US\0")
        self.wr(SRC+16, 5)
        self.wr(SRC+20, 15)
        for vt, delete in ((VTA, DELETE_A), (VTB, DELETE_B)):
            self.wr(vt, delete)
            self.wr(vt+0x20, 0x72A9F0)
        self.wr(NVA+0x30, NESTED_A)
        self.wr(NVB+0x30, NESTED_B)
        self.wr(RVT+0xC, UI_CLOSE)
        self.wr(RVT+0x10, UI_DELETE)
        for reg in (UC_X86_REG_EAX, UC_X86_REG_EBX, UC_X86_REG_ECX, UC_X86_REG_EDX, UC_X86_REG_ESI, UC_X86_REG_EDI, UC_X86_REG_EBP):
            self.u.reg_write(reg, 0)
        self.u.reg_write(UC_X86_REG_EFLAGS, 2)

    def globals(self):
        return dict(service=self.rd(SERVICE), loading_pair=[self.rd(G), self.rd(G+4)])

    def state(self):
        return dict(**self.globals(), temporary_pair=[self.rd(TMP), self.rd(TMP+4)], live=[dict(pointer=p, size=n, hex=bytes(self.u.mem_read(p, n)).hex()) for p, n in sorted(self.live.items())], locks=sorted(self.locks))

    def event(self, kind, **kwargs):
        if self.track:
            self.events.append(dict(kind=kind, pc=self.u.reg_read(UC_X86_REG_EIP), **self.globals(), **kwargs))

    def alloc(self, n):
        p = self.cursor
        self.cursor += (n+31) & ~15
        assert self.cursor < ARENA+0x200000
        self.u.mem_write(p, bytes([self.fill])*n)
        self.live[p] = n
        self.event("allocate", pointer=p, size=n)
        return p

    def free(self, p, route):
        assert p in self.live, (hex(p), sorted(map(hex, self.live)))
        n = self.live.pop(p)
        self.event("free", pointer=p, size=n, route=route, final_hex=bytes(self.u.mem_read(p, n)).hex())

    def finish(self, pop=0, eax=0):
        sp = self.u.reg_read(UC_X86_REG_ESP)
        target = self.rd(sp)
        self.u.reg_write(UC_X86_REG_EAX, eax)
        self.u.reg_write(UC_X86_REG_ESP, sp+4+pop)
        self.u.reg_write(UC_X86_REG_EIP, target)

    def memory(self, u, access, address, size, value, data):
        if self.active and self.track and any(address <= p < address+size for p in self.watch):
            self.events.append(dict(kind="write" if access == unicorn.UC_MEM_WRITE else "read", pc=u.reg_read(UC_X86_REG_EIP), address=address, size=size, value=value if access == unicorn.UC_MEM_WRITE else int.from_bytes(u.mem_read(address, size), "little")))

    def code(self, u, pc, size, data):
        if not self.active:
            return
        sp = u.reg_read(UC_X86_REG_ESP)
        this = u.reg_read(UC_X86_REG_ECX)
        if pc == 0x9933E0:
            self.finish(eax=self.alloc(self.rd(sp+4)))
            return
        if pc in (0xC98528, CUSTOM):
            self.free(self.rd(sp+4), 0 if pc == 0xC98528 else CUSTOM)
            self.finish()
            return
        if pc in (0xCA1EF0, 0xCA1F20):
            dst, src, n = self.rd(sp+4), self.rd(sp+8), self.rd(sp+12)
            u.mem_write(dst, bytes(u.mem_read(src, n)))
            self.finish(eax=dst)
            return
        if pc == 0x5FA170:
            args = [self.rd(sp+4+4*x) for x in range(4)]
            assert args == [3, 1, 0, 0x10B1874], args
            self.event("log_boundary", args=args)
            if self.log_action:
                self.log_action()
                self.event("after_log_mutation")
            self.finish()
            return
        if pc in (NESTED_A, NESTED_B):
            self.event("nested_virtual_boundary", target=pc, receiver=this)
            if self.nested_action:
                self.nested_action()
                self.event("after_nested_mutation")
            self.finish()
            return
        if pc in (DELETE_A, DELETE_B):
            flags = self.rd(sp+4)
            assert flags == 1
            self.event("service_delete_boundary", target=pc, receiver=this, flags=flags)
            if self.delete_action:
                self.delete_action()
                self.event("after_delete_mutation")
            self.free(this, "explicit fixture destructor boundary")
            self.finish(4, this)
            return
        if pc in (INIT, DEL):
            p = self.rd(sp+4)
            if pc == INIT:
                assert p not in self.locks
                self.locks.add(p)
                u.mem_write(p, bytes(24))
            else:
                assert p in self.locks
                self.locks.remove(p)
            self.event("initialize_lock" if pc == INIT else "destroy_lock", pointer=p)
            self.finish(4)
            return
        if pc in (UI_CLOSE, UI_DELETE):
            self.event("ui_boundary", target=pc, receiver=this, flags=self.rd(sp+4) if pc == UI_DELETE else None)
            if pc == UI_CLOSE and self.ui_action:
                self.ui_action()
                self.event("after_ui_mutation")
            if pc == UI_DELETE:
                assert self.rd(sp+4) == 1
                self.free(this, "explicit recipient delete boundary")
            self.finish(4 if pc == UI_DELETE else 0)
            return
        if pc in (0xCE0B9F, 0xCE0C22, 0xCA3722):
            raise RuntimeError(f"native exception/unwind boundary {pc:X}")
        assert BASE <= pc < BASE+len(IMAGE), f"unexpected executable boundary {pc:X}"
        actual = bytes(u.mem_read(pc, size))
        assert actual == IMAGE[pc-BASE:pc-BASE+size], f"source instruction changed {pc:X}"
        self.all_native[pc] = actual
        if self.track:
            self.body_seen.add(pc)
            if pc in (0x72A530, 0x5CC140, 0x5DDB80, 0x576410, 0x5DDB70, 0x5D5B40, 0x5D6840):
                self.event("native_entry", entry=pc, receiver=this)

    def call(self, entry, this=0, args=(), track=False):
        self.track = track
        sp = STACK+0xE000
        self.u.mem_write(sp, struct.pack("<"+"I"*(len(args)+1), END, *args))
        self.u.reg_write(UC_X86_REG_ESP, sp)
        self.u.reg_write(UC_X86_REG_ECX, this)
        self.active = True
        try:
            self.u.emu_start(entry, END, count=1000000)
        finally:
            self.active = False
            self.track = False
        assert self.u.reg_read(UC_X86_REG_EIP) == END
        return self.u.reg_read(UC_X86_REG_EAX)

    def outer(self):
        # At 590F03 the four previous logger arguments still occupy16 bytes.
        # The real add esp,10 at590F09 removes them. This is a fragment entry,
        # not a manufactured function prologue or a run of all590E70.
        sp = STACK+0xE000
        self.u.mem_write(sp, struct.pack("<5I", 3, 1, 0, 0x108BF84, END))
        self.u.reg_write(UC_X86_REG_ESP, sp)
        self.active = self.track = True
        try:
            self.u.emu_start(0x590F03, 0x590F31, count=1000000)
        finally:
            self.active = self.track = False
        assert self.u.reg_read(UC_X86_REG_EIP) == 0x590F31
        assert self.u.reg_read(UC_X86_REG_ESP) == sp+16

    def fixture_service(self, vt=VTA, mode=1, nested=0):
        p = self.alloc(0x188)
        self.wr(p, vt)
        self.wb(p+0x122, mode)
        self.wr(p+0xCC, nested)
        self.watch.update((p, p+0x122, p+0xCC, vt, vt+0x20))
        return p

    def nested(self, vt):
        p = self.alloc(4)
        self.wr(p, vt)
        self.watch.update((p, vt+0x30))
        return p

    def wrapper(self, recipient=False):
        p = self.alloc(128)
        self.call(0x576280, p)
        if recipient:
            r = self.alloc(4)
            self.wr(r, RVT)
            self.call(0x5C7D10, p, [r])
            self.wb(p+0xC, 1)
        return p

    def publish(self, p):
        self.call(0x5C7E30, 0, [p])
        c = self.rd(G+4)
        self.watch.update((c, c+4, c+8, c+12))
        return c

    def record(self, label, before, **extra):
        return dict(label=label, fill=self.fill, before=before, after=self.state(), events=list(self.events), executed_body_addresses=sorted(self.body_seen), **extra)

n = Native()
stop_cases = []
for fill, profile in itertools.product((0, 165), ("disabled", "enabled_null", "enabled_a", "noncanonical_flag", "log_enable", "log_disable", "log_replace_nested", "log_clear_nested", "log_replace_nested_vtable")):
    n.reset(fill)
    a, b = n.nested(NVA), n.nested(NVB)
    mode = 0 if profile in ("disabled", "log_enable") else (255 if profile == "noncanonical_flag" else 1)
    service = n.fixture_service(mode=mode, nested=0 if profile == "enabled_null" else a)
    n.wr(SERVICE, service)
    expected = NESTED_A if mode and profile != "enabled_null" else None
    if profile == "log_enable":
        n.log_action = lambda: n.wb(service+0x122, 1)
        expected = NESTED_A
    elif profile == "log_disable":
        n.log_action = lambda: n.wb(service+0x122, 0)
        expected = None
    elif profile == "log_replace_nested":
        n.log_action = lambda: n.wr(service+0xCC, b)
        expected = NESTED_B
    elif profile == "log_clear_nested":
        n.log_action = lambda: n.wr(service+0xCC, 0)
        expected = None
    elif profile == "log_replace_nested_vtable":
        n.log_action = lambda: n.wr(a, NVB)
        expected = NESTED_B
    before = n.state()
    n.call(0x72A9F0, service, track=True)
    calls = [e for e in n.events if e["kind"] == "nested_virtual_boundary"]
    assert [e["target"] for e in calls] == ([] if expected is None else [expected])
    assert n.rd(SERVICE) == service and service in n.live
    assert len([e for e in n.events if e["kind"] == "log_boundary"]) == 1
    log_index = next(i for i, e in enumerate(n.events) if e["kind"] == "log_boundary")
    flag_reads = [(i, e) for i, e in enumerate(n.events) if e["kind"] == "read" and e["address"] == service+0x122]
    assert len(flag_reads) == 1 and flag_reads[0][0] > log_index and flag_reads[0][1]["pc"] == 0x72AA0D
    if n.log_action:
        mutation_index = next(i for i, e in enumerate(n.events) if e["kind"] == "after_log_mutation")
        assert flag_reads[0][0] > mutation_index
    nested_reads = [e for e in n.events if e["kind"] == "read" and e["address"] == service+0xCC]
    assert len(nested_reads) == (1 if n.rb(service+0x122) else 0)
    stop_cases.append(n.record(profile, before, service=service, expected_nested_target=expected))

outer_cases = []
for fill, profile in itertools.product((0, 165), ("unchanged", "log_clear_global", "log_replace_global", "nested_clear_global", "nested_replace_global", "log_replace_delete_vtable", "delete_republish_global")):
    n.reset(fill)
    inner = n.nested(NVA)
    a = n.fixture_service(mode=1, nested=inner)
    b = n.fixture_service(vt=VTB, mode=0)
    n.wr(SERVICE, a)
    expected_receiver, expected_target = a, DELETE_A
    if profile == "log_clear_global":
        n.log_action = lambda: n.wr(SERVICE, 0)
        expected_receiver = None
    elif profile == "log_replace_global":
        n.log_action = lambda: n.wr(SERVICE, b)
        expected_receiver, expected_target = b, DELETE_B
    elif profile == "nested_clear_global":
        n.nested_action = lambda: n.wr(SERVICE, 0)
        expected_receiver = None
    elif profile == "nested_replace_global":
        n.nested_action = lambda: n.wr(SERVICE, b)
        expected_receiver, expected_target = b, DELETE_B
    elif profile == "log_replace_delete_vtable":
        n.log_action = lambda: n.wr(a, VTB)
        expected_target = DELETE_B
    elif profile == "delete_republish_global":
        n.delete_action = lambda: n.wr(SERVICE, b)
    before = n.state()
    n.outer()
    calls = [e for e in n.events if e["kind"] == "service_delete_boundary"]
    assert [(e["receiver"], e["target"]) for e in calls] == ([] if expected_receiver is None else [(expected_receiver, expected_target)])
    if calls:
        assert calls[0]["service"] == expected_receiver
    assert [e["receiver"] for e in n.events if e["kind"] == "nested_virtual_boundary"] == [inner]
    global_reads = [e for e in n.events if e["kind"] == "read" and e["address"] == SERVICE]
    assert [(e["pc"], e["value"]) for e in global_reads] == [(0x590F03, a), (0x590F11, expected_receiver or 0)]
    assert n.rd(SERVICE) == 0
    assert len([e for e in n.events if e["kind"] == "log_boundary"]) == 1
    writes = [e for e in n.events if e["kind"] == "write" and e["address"] == SERVICE]
    assert len(writes) == 1 and writes[0]["pc"] == 0x590F27 and writes[0]["value"] == 0
    outer_cases.append(n.record(profile, before, first_service=a, replacement_service=b, expected_deleted_receiver=expected_receiver, expected_deleted_target=expected_target if expected_receiver else None, dynamic_destructor_boundary=True))

# Exercise the actual72A530 using byte-for-byte states archived from a previous
# native72A3B0 run. No constructor is claimed to run in these four new cases.
real_delete_cases = []
for fill, custom in itertools.product((0, 165), (False, True)):
    n.reset(fill)
    case = next(c for c in archived["whole_cases"] if c["poison"] == fill and c["flags"] == 1)
    for a in case["constructed"]["allocations"]:
        n.live[a["pointer"]] = a["bytes"]
    for p in case["constructed"]["freed"]:
        n.live.pop(p, None)
    for p, value in case["constructed"]["words"]:
        n.wr(p, value)
    service = case["service"]
    assert n.rd(service) == 0x10AFE8C and n.rb(service+0x122) == 0
    n.watch.update((service, service+0x122, service+0xCC))
    n.wr(SERVICE, service)
    n.wr(0x14BEF40, CUSTOM if custom else 0)
    before = n.state()
    n.outer()
    freed = [e for e in n.events if e["kind"] == "free"]
    assert [e["pointer"] for e in freed] == case["destroyed"]["freed"]
    assert all(e["service"] == service for e in freed)
    assert all(e["route"] == (CUSTOM if custom else 0) for e in freed)
    assert not n.live and n.rd(SERVICE) == 0
    assert 0x72A530 in n.body_seen
    assert n.u.reg_read(UC_X86_REG_ECX) == 0x33445566
    real_delete_cases.append(n.record("archived_native_constructor_state", before, service=service, custom_deallocator=custom, constructor_fixture_sha256=sha(archived_bytes), archived_fill=fill, archived_flags=1))

reset_cases = []
for fill, profile in itertools.product((0, 165), ("empty", "null_object_with_control", "exclusive", "active_recipient", "shared_strong", "extra_weak", "ui_republish", "ui_change_free_route")):
    n.reset(fill)
    service = n.fixture_service(mode=0)
    n.wr(SERVICE, service)
    wrapper = control = replacement = replacement_control = 0
    active = profile in ("active_recipient", "ui_republish", "ui_change_free_route")
    if profile != "empty":
        wrapper = 0 if profile == "null_object_with_control" else n.wrapper(active)
        control = n.publish(wrapper)
        assert control and n.rd(control) == 0x1085E5C
        if profile == "shared_strong":
            n.wr(control+4, 2)
        if profile == "extra_weak":
            n.wr(control+8, 2)
        if profile == "ui_republish":
            replacement = n.wrapper()
            n.call(0x5D7750, TMP, [replacement])
            replacement_control = n.rd(TMP+4)
            def republish():
                assert n.rd(G) == n.rd(G+4) == 0
                n.wr(G+4, n.rd(TMP+4))
                n.wr(G, n.rd(TMP))
                n.wr(TMP+4, 0)
                n.wr(TMP, 0)
            n.ui_action = republish
        elif profile == "ui_change_free_route":
            n.ui_action = lambda: n.wr(0x14BEF40, CUSTOM)
    n.events.clear()
    n.body_seen.clear()
    before = n.state()
    n.call(0x577DF0, track=True)
    assert n.rd(SERVICE) == service
    assert 0x5CC140 in n.body_seen
    if profile == "null_object_with_control":
        assert [n.rd(G), n.rd(G+4)] == [0, control]
        assert n.rd(control+4) == n.rd(control+8) == 1
        assert control in n.live
    elif profile == "ui_republish":
        assert [n.rd(G), n.rd(G+4)] == [replacement, replacement_control]
        assert wrapper not in n.live and control not in n.live
    else:
        assert n.rd(G) == n.rd(G+4) == 0
        if profile == "shared_strong":
            assert wrapper in n.live and control in n.live and n.rd(control+4) == 1
        elif profile == "extra_weak":
            assert wrapper not in n.live and control in n.live and n.rd(control+4) == 0 and n.rd(control+8) == 1
        elif wrapper:
            assert wrapper not in n.live and control not in n.live
    native_writes = [e for e in n.events if e["kind"] == "write" and e["address"] in (G, G+4)]
    assert [(e["address"], e["value"]) for e in native_writes] == ([] if profile in ("empty", "null_object_with_control") else [(G+4, 0), (G, 0)])
    ui = [e for e in n.events if e["kind"] == "ui_boundary"]
    if active:
        assert [e["target"] for e in ui] == [UI_CLOSE, UI_DELETE]
        assert ui[0]["loading_pair"] == [0, 0]
        assert all(e["service"] == service for e in ui)
    if profile == "ui_change_free_route":
        physical_frees = [e for e in n.events if e["kind"] == "free" and isinstance(e["route"], int)]
        assert physical_frees and all(e["route"] == CUSTOM for e in physical_frees)
    if control:
        strong_writes = [e for e in n.events if e["kind"] == "write" and e["address"] == control+4]
        strong = 2 if profile == "shared_strong" else 1
        expected_values = [2, 1] if profile == "null_object_with_control" else [strong+1, strong, strong-1]
        assert [e["value"] for e in strong_writes] == expected_values
        if wrapper and strong == 1:
            first_clear = next(i for i, e in enumerate(n.events) if e["kind"] == "write" and e["address"] == G+4)
            last_strong = max(i for i, e in enumerate(n.events) if e["kind"] == "write" and e["address"] == control+4)
            dispose_index = next(i for i, e in enumerate(n.events) if e["kind"] == "native_entry" and e["entry"] == 0x5DDB80)
            assert first_clear < last_strong < dispose_index
            assert n.events[dispose_index]["loading_pair"] == [0, 0]
        if profile == "ui_republish":
            assert n.rd(TMP) == n.rd(TMP+4) == 0
    reset_cases.append(n.record(profile, before, wrapper=wrapper, control=control, replacement_wrapper=replacement, replacement_control=replacement_control, explicit_external_strong_owners=1 if profile == "shared_strong" else 0, explicit_external_weak_owners=1 if profile == "extra_weak" else 0))

regions = []
(ROOT / "bytes").mkdir(exist_ok=True)
for name, address, size in (("stop_72A9F0", 0x72A9F0, 0x3A), ("outer_shutdown_590F03", 0x590F03, 0x2E), ("reset_577DF0", 0x577DF0, 0x98), ("acquire_pair_5CC140", 0x5CC140, 0x76), ("wrapper_dispose_5DDB80", 0x5DDB80, 0x31), ("wrapper_destroy_576410", 0x576410, 0x118), ("control_release_5D5B40", 0x5D5B40, 12), ("control_delete_5D6840", 0x5D6840, 60), ("service_delete_72A530", 0x72A530, 0xC3), ("control_vtables_1085E5C", 0x1085E5C, 32)):
    data = IMAGE[address-BASE:address-BASE+size]
    path = f"bytes/{name}.bin"
    (ROOT / path).write_bytes(data)
    regions.append(dict(name=name, address=address, size=size, path=path, sha256=sha(data)))
proof = dict(passed=True, complete=False, native_sha256=DIGEST, stop_cases=stop_cases, outer_dynamic_cases=outer_cases, outer_real_destructor_cases=real_delete_cases, loading_pair_reset_cases=reset_cases, source_regions=regions, native_executed_instructions=[dict(address=p, size=len(data), bytes=data.hex()) for p, data in sorted(n.all_native.items())], dependencies=[dict(path=str(ARCHIVE_FIXTURE), sha256=sha(archived_bytes), usage="Four actual72A530 cases start from archived native72A3B0 constructed states; no new constructor execution claimed."), dict(path="E:/mapslol3v3/loading_owner_agent/probe_loading_owner.py", sha256=sha(Path("E:/mapslol3v3/loading_owner_agent/probe_loading_owner.py").read_bytes()), usage="Reused primitive boundary design for loading wrapper/control execution, without importing the script or rerunning its suite.")], limits=["The original72A9F0,590F03..590F31,577DF0 and5CC140 instructions execute unchanged; hook byte checks reject source instruction mutation.", "Logger5FA170, dynamic nested slot+30, dynamic fixture-service slot0 and recipient UI terminals are explicit observable interface boundaries. Their bodies are not claimed implemented.", "Outer native-destructor cases execute actual72A530 and member bodies from two archived native constructor states (two allocator fills), replayed through four deallocator-route cases. No full process startup, network, renderer or current configuration is qualified.", "Wrapper construction/publication/acquisition/disposal and control release execute actual native bodies. Memory allocation/free/copy and single-thread lock primitives are supplied. Empty native trees are used; no new populated-tree or concurrency qualification.", "Mutations from fixture callbacks are deliberate inputs that expose late reads and overwrite order. They do not claim a real UI callback normally performs these mutations.", "Injected external strong/weak references remain owned in the corresponding fixture cases; callback-created replacement owners remain live. Remaining service objects in terminal-interface tests are explicit fixture-owned state, not a claimed full shutdown.", "SEH/unwind, invalid inputs, allocation failure, real Win32 concurrency, Rust ports and production integration remain outside this oracle."])
dump("native_lifecycle_oracle.json", proof)
summary = dict(passed=True, stop_cases=len(stop_cases), outer_dynamic_cases=len(outer_cases), outer_real_destructor_cases=len(real_delete_cases), loading_pair_reset_cases=len(reset_cases), native_instruction_count=len(n.all_native), source_regions=len(regions), proof_sha256=sha((ROOT/"native_lifecycle_oracle.json").read_bytes()))
dump("summary.json", summary)
print(json.dumps(summary, indent=2))
