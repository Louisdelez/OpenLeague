"""Original skin filename/section branches, with explicit resource boundaries.

This is not the original filesystem/package/cache or a running historical game.
"""
import hashlib
import math
import pathlib
import re
import struct
import sys

R = pathlib.Path('E:/OpenLeague')
sys.path.insert(0, str(R / 'tools/pythonlibs'))
sys.path.insert(0, str(R / 'tools/project-plan'))
import pefile
import unicorn
from unicorn.x86_const import *
from reference_inibin import hashkey

BINARY_SHA = '402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'


class OriginalSkinLoader:
    def __init__(self, binary):
        self.binary = pathlib.Path(binary)
        raw = self.binary.read_bytes()
        if hashlib.sha256(raw).hexdigest() != BINARY_SHA:
            raise ValueError('Original skin-loader binary identity mismatch')
        self.pe = pefile.PE(data=raw)
        self.base = self.pe.OPTIONAL_HEADER.ImageBase
        if self.base != 0x400000:
            raise ValueError('Original skin-loader image layout mismatch')
        self.image = self.pe.get_memory_mapped_image()
        self.u = unicorn.Uc(unicorn.UC_ARCH_X86, unicorn.UC_MODE_32)
        self.u.mem_map(self.base, (len(self.image) + 4095) & ~4095)
        self.u.mem_write(self.base, self.image)
        self.u.mem_map(0, 0x1000)  # isolated SEH/TIB slot used by original prologue
        self.work = 0x40000000
        self.u.mem_map(self.work, 0x60000)
        self.finish = self.work + 0x50000
        self.contains = self.work + 0x51000
        self.float_stub = self.work + 0x52000
        self.float_value = self.work + 0x52100
        self.init = self.work + 0x53000
        self.u.mem_write(self.float_stub, b'\xd9\x05' + struct.pack('<I', self.float_value) + b'\xc3')
        self.u.mem_write(self.init, b'\xdb\xe3')
        self.visited = set()
        self.u.hook_add(unicorn.UC_HOOK_CODE, self.hook)
        self.reset()

    def reset(self):
        self.u.mem_write(self.work, bytes(0x50000))
        self.heap = self.work + 0x20000
        self.calls = []
        self.case_visited = set()
        self.allowed = []
        self.names = set()
        self.values = {}
        self.alias_stop = False
        self.alias_registration = None
        self.w(0, 0xffffffff)
        for reg in [UC_X86_REG_EAX, UC_X86_REG_EBX, UC_X86_REG_ECX, UC_X86_REG_EDX,
                    UC_X86_REG_ESI, UC_X86_REG_EDI, UC_X86_REG_EBP]:
            self.u.reg_write(reg, 0)
        self.u.reg_write(UC_X86_REG_EFLAGS, 2)
        self.u.reg_write(UC_X86_REG_ESP, self.work + 0x40000)
        self.u.emu_start(self.init, self.init + 2, count=4)

    def w(self, address, value):
        self.u.mem_write(address, struct.pack('<I', value & 0xffffffff))

    def rd(self, address):
        return struct.unpack('<I', self.u.mem_read(address, 4))[0]

    def cstring(self, address):
        raw = bytearray()
        for i in range(4096):
            b = bytes(self.u.mem_read(address + i, 1))
            if b == b'\0':
                return raw.decode('ascii')
            raw.extend(b)
        raise ValueError('Unbounded original string refused')

    def string(self, address):
        size = self.rd(address + 16)
        if size > 4095:
            raise ValueError('Unqualified native string size')
        data = self.rd(address) if self.rd(address + 20) >= 16 else address
        return bytes(self.u.mem_read(data, size)).decode('ascii')

    def assign(self, address, text):
        raw = text.encode('ascii')
        if b'\0' in raw or len(raw) > 4095:
            raise ValueError('Unqualified string assignment')
        self.u.mem_write(address, bytes(24))
        if len(raw) < 16:
            self.u.mem_write(address, raw + b'\0')
            capacity = 15
        else:
            at = self.heap
            self.heap += (len(raw) + 16) & ~15
            if self.heap >= self.work + 0x30000:
                raise ValueError('Isolated string arena exhausted')
            self.u.mem_write(at, raw + b'\0')
            self.w(address, at)
            capacity = len(raw)
        self.w(address + 16, len(raw))
        self.w(address + 20, capacity)

    def leave(self, value=0, pop=0):
        sp = self.u.reg_read(UC_X86_REG_ESP)
        self.u.reg_write(UC_X86_REG_EAX, value & 0xffffffff)
        self.u.reg_write(UC_X86_REG_EIP, self.rd(sp))
        self.u.reg_write(UC_X86_REG_ESP, sp + 4 + pop)

    def hook(self, uc, address, size, unused):
        sp = self.u.reg_read(UC_X86_REG_ESP)
        ecx = self.u.reg_read(UC_X86_REG_ECX)
        if self.alias_stop and address == 0x905343:
            self.u.emu_stop()
            return
        if address == 0x564c20:
            source, count = self.rd(sp + 4), self.rd(sp + 8)
            text = bytes(self.u.mem_read(source, count)).decode('ascii')
            self.assign(ecx, text)
            self.calls.append({'adapter': 'string_assign', 'address': hex(address), 'text': text})
            self.leave(ecx, 8)
            return
        if address == 0x564900:
            self.assign(ecx, '')
            self.calls.append({'adapter': 'isolated_string_destroy', 'address': hex(address)})
            self.leave()
            return
        if address == 0x5648a0:
            self.assign(ecx, self.cstring(self.rd(sp + 4)))
            self.calls.append({'adapter': 'string_construct_from_cstring', 'address': hex(address)})
            self.leave(ecx, 4)
            return
        if address == 0x5bca50:
            out, start, count = [self.rd(sp + i) for i in [4, 8, 12]]
            text = self.string(ecx)
            if start > len(text):
                raise ValueError('Unqualified substring start')
            selected = text[start:] if count == 0xffffffff else text[start:start + count]
            self.assign(out, selected)
            self.calls.append({'adapter': 'substring_storage', 'input': text, 'start': start,
                               'count': count, 'selected': selected})
            self.leave(out, 12)
            return
        if address == 0xc98074:
            value = self.rd(sp + 4)
            if not 97 <= value <= 122:
                raise ValueError('Only lowercase ASCII suffix comparison is qualified')
            self.calls.append({'adapter': 'lowercase_ascii_ctype_identity', 'character': value})
            self.leave(value)
            return
        if address == 0x90cdb0:
            if ecx != self.work + 0x7000:
                raise ValueError('Unexpected isolated alias map')
            self.alias_registration = {'key': self.string(self.rd(sp + 4))}
            self.assign(self.work + 0x7100, '')
            self.calls.append({'adapter': 'alias_map_slot', **self.alias_registration})
            self.leave(self.work + 0x7100, 4)
            return
        if address == 0x5fadb0:
            if ecx != self.work + 0x7100 or self.alias_registration is None:
                raise ValueError('Unexpected alias value assignment')
            value = self.string(self.rd(sp + 4))
            self.assign(ecx, value)
            self.alias_registration['value'] = value
            self.calls.append({'adapter': 'alias_value_assignment', 'value': value})
            self.leave(ecx, 4)
            return
        if address == 0x993860:
            out, cap, fmt, value = [self.rd(sp + i) for i in [4, 8, 12, 16]]
            if self.cstring(fmt) != 'Skin%02d.ini' or cap != 256 or not 1 <= value <= 99:
                raise ValueError('Unqualified bounded format call')
            text = ('Skin%02d.ini' % value).encode('ascii')
            self.u.mem_write(out, text + b'\0')
            self.calls.append({'adapter': 'bounded_format', 'format': 'Skin%02d.ini', 'number': value})
            self.leave(len(text))
            return
        if address == self.contains:
            if ecx != self.work + 0x1000:
                raise ValueError('Unexpected resource provider')
            name = self.string(self.rd(sp + 4))
            present = name in self.names
            self.calls.append({'adapter': 'provider_contains', 'logical_name': name, 'present': present})
            self.leave(int(present), 4)
            return
        if address == 0xc975f5:
            expected = struct.unpack_from('<I', self.image, 0x1222ed0 - self.base)[0]
            if ecx != expected:
                raise ValueError('Original caller security-cookie value diverged')
            self.calls.append({'adapter': 'security_cookie_check', 'compared_original_cookie': True})
            self.leave()
            return
        if address == 0xc9befc:
            value, out, radix = [self.rd(sp + i) for i in [4, 8, 12]]
            if not 0 <= value <= 99 or radix != 10:
                raise ValueError('Unqualified integer formatting')
            self.u.mem_write(out, str(value).encode('ascii') + b'\0')
            self.calls.append({'adapter': 'itoa10', 'number': value})
            self.leave(out)
            return
        if address == 0x5fa560:
            out, lhs, rhs = [self.rd(sp + i) for i in [4, 8, 12]]
            text = self.string(lhs) + self.cstring(rhs)
            self.assign(out, text)
            self.calls.append({'adapter': 'string_plus_cstring', 'text': text})
            self.leave(out)
            return
        if address == 0x5fa460:
            rhs = self.rd(sp + 4)
            left, right = bytes(self.u.mem_read(ecx, 16)), bytes(self.u.mem_read(rhs, 16))
            self.u.mem_write(ecx, right)
            self.u.mem_write(rhs, left)
            self.calls.append({'adapter': 'string_storage_swap_only', 'address': hex(address)})
            self.leave(ecx, 4)
            return
        if address == 0x8b1f50:
            config, section, name = [self.rd(sp + i) for i in [4, 8, 12]]
            default = struct.unpack('<f', self.u.mem_read(sp + 16, 4))[0]
            if config != self.work + 0x3000 or self.cstring(name) != 'SkinScale' or self.rd(sp + 20) != 0:
                raise ValueError('Unexpected original section lookup')
            sec = self.cstring(section)
            raw = self.values.get(hashkey(sec, 'SkinScale'))
            if raw is not None and (isinstance(raw, bool) or not isinstance(raw, (float, int)) or not math.isfinite(raw)):
                raise ValueError('Unqualified SkinScale text/nonfinite value')
            value = default if raw is None else raw
            self.u.mem_write(self.float_value, struct.pack('<f', value))
            self.calls.append({'adapter': 'INIBIN_float_lookup', 'section': sec, 'field': 'SkinScale',
                               'present': raw is not None, 'raw': raw, 'original_default': default, 'value': value})
            self.u.reg_write(UC_X86_REG_EIP, self.float_stub)
            return
        if address == self.init or self.float_stub <= address < self.float_stub + 7:
            return
        if not any(start <= address < stop for start, stop in self.allowed):
            raise ValueError('Unqualified original/external skin-loader code ' + hex(address))
        self.visited.add(address)
        self.case_visited.add(address)

    @staticmethod
    def inputs(champion, number):
        if not isinstance(champion, str) or not re.fullmatch(r'[A-Za-z][A-Za-z0-9]*', champion) or len(champion) > 63:
            raise ValueError('Unqualified character identity')
        if isinstance(number, bool) or not isinstance(number, int) or not 0 <= number <= 99:
            raise ValueError('Unqualified skin number')

    def filename(self, champion, number, logical_names):
        self.inputs(champion, number)
        if not isinstance(logical_names, (list, tuple, set)) or any(not isinstance(x, str) or not re.fullmatch(r'[A-Za-z0-9_]+\.ini', x) or len(x) > 15 for x in logical_names):
            raise ValueError('Explicit bounded logical resource names required')
        self.reset()
        self.names = set(logical_names)
        self.allowed = [(0x56e0d0, 0x56e343)]
        provider, table = self.work + 0x1000, self.work + 0x1100
        output, flag, legacy = self.work + 0x1200, self.work + 0x1300, self.work + 0x1400
        self.w(provider, table)
        self.w(table + 0x28, self.contains)
        self.assign(output, '')
        self.u.mem_write(legacy, (champion + '.ini').encode('ascii') + b'\0')
        stack = self.work + 0x40000
        for i, value in enumerate([self.finish, legacy, number, output, flag, provider]):
            self.w(stack + 4 * i, value)
        self.u.reg_write(UC_X86_REG_ESP, stack)
        self.u.emu_start(0x56e0d0, self.finish, count=20000)
        if self.u.reg_read(UC_X86_REG_EIP) != self.finish:
            raise ValueError('Original filename function did not return')
        return {'logical_name': self.string(output), 'dedicated': bool(self.u.mem_read(flag, 1)[0]),
                'queries': [x for x in self.calls if x['adapter'] == 'provider_contains'],
                'adapter_calls': list(self.calls), 'original_addresses_exercised': len(self.case_visited),
                'original_resource_provider_executed': False}

    def section(self, champion, number, dedicated, legacy_values):
        self.inputs(champion, number)
        if not isinstance(dedicated, bool) or not isinstance(legacy_values, dict):
            raise ValueError('Explicit dedicated flag and parsed legacy values required')
        self.reset()
        self.values = legacy_values
        self.allowed = [(0x566bc0, 0x566cb4)]
        frame = self.work + 0x10000
        self.u.reg_write(UC_X86_REG_EBP, frame)
        self.u.reg_write(UC_X86_REG_EDI, self.work + 0x4000)
        for offset, value in [(8, self.work + 0x3000), (12, self.work + 0x3500),
                              (16, int(dedicated)), (20, 0), (24, number)]:
            self.w(frame + offset, value)
        self.u.emu_start(0x566bc0, 0x566cb4, count=10000)
        if self.u.reg_read(UC_X86_REG_EIP) != 0x566cb4:
            raise ValueError('Original section branch did not reach common consumer')
        return {'section': self.string(frame - 0x38), 'dedicated': dedicated,
                'lookup_calls': [x for x in self.calls if x['adapter'] == 'INIBIN_float_lookup'],
                'adapter_calls': list(self.calls), 'original_addresses_exercised': len(self.case_visited),
                'original_config_cache_executed': False}

    def evidence(self):
        fragments = []
        for start, stop in [(0x56e0d0, 0x56e343), (0x566bc0, 0x566cb4),
                            (0x905192, 0x9052f2), (0x867bc0, 0x867c0b), (0x5ed570, 0x5ed5c9)]:
            raw = self.image[start - self.base:stop - self.base]
            fragments.append({'start': hex(start), 'stop': hex(stop), 'bytes': len(raw),
                              'sha256': hashlib.sha256(raw).hexdigest()})
        return {'binary': {'path': str(self.binary), 'sha256': BINARY_SHA}, 'fragments': fragments,
                'original_unique_addresses_exercised': len(self.visited),
                'original_instructions_executed_in_isolated_memory': True,
                'historical_game_process_launched': False, 'original_resource_provider_executed': False,
                'adapters': ['Bounded formatting, SSO string storage/copy/swap/destruction and cookie comparison use explicit adapters.',
                             'Provider Contains answers only from the explicitly supplied logical resource-name set; no original VFS/cache/overlay executes.',
                             'Section lookup returns the supplied parsed INIBIN value or the exact default passed by original code through an x87 FLD/RET stub.',
                             'Alias experiment supplies original path-split outputs, adapts substring storage and map insertion, and restricts the ctype boundary to already lowercase ASCII. Original suffix comparisons and truncation counts execute.'],
                'limits': ['Conditional original filename, section and suffix-alias decisions only. Package mounting, provider maps/fallbacks, compiled payload opening, overlays and effective process resource contents need separate proof.',
                           'No complete skin constructor, asset inheritance, skin ownership/availability, gameplay, renderer or current runtime skin dispatch is qualified.']}

    def alias(self, physical_path):
        if not isinstance(physical_path, str) or not re.fullmatch(r'[A-Za-z0-9_/]+\.[a-z]+', physical_path) or '..' in physical_path:
            raise ValueError('Explicit ASCII path and lowercase extension required')
        self.reset()
        self.alias_stop = True
        self.allowed = [(0x905192, 0x9052f2), (0x867bc0, 0x867c0b), (0x5ed570, 0x5ed5c9)]
        frame = self.work + 0x10000
        self.u.reg_write(UC_X86_REG_EBP, frame)
        self.u.reg_write(UC_X86_REG_EDI, self.work + 0x7000)
        self.assign(frame - 0x44, physical_path)
        self.assign(frame - 0x5c, physical_path.rsplit('.', 1)[1])
        self.assign(self.work + 0x6000, physical_path.rsplit('/', 1)[-1])
        self.w(frame - 0xe0, self.work + 0x6000)
        self.u.emu_start(0x905192, 0x9052f2, count=20000)
        end = self.u.reg_read(UC_X86_REG_EIP)
        if end not in [0x9052f2, 0x905343]:
            raise ValueError('Alias decision did not reach qualified stop')
        return {'physical_path': physical_path, 'alias': self.alias_registration,
                'original_alias_branch_taken': end == 0x9052f2, 'adapter_calls': list(self.calls),
                'original_addresses_exercised': len(self.case_visited), 'original_map_insert_executed': False}
