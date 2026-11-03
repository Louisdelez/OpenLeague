"""Original config cache/constructor/scalar dispatcher with read-only backends.

The native file-provider list is explicit input, not historical bootstrap proof.
Raw text INI payloads and host directory mutation are deliberately unqualified.
"""
import hashlib
import math
import pathlib
import re
import struct
import sys

sys.path.insert(0, 'E:/OpenLeague/tools/project-plan')
from original_directory_reference import OriginalDirectoryScanner
from original_config_reader_reference import OriginalConfigReader
from original_skin_provider_reference import OriginalSkinProvider
from unicorn.x86_const import *


class OriginalConfigCache(OriginalDirectoryScanner):
    field_hash = OriginalConfigReader.field_hash
    string_field = OriginalConfigReader.string_field
    float_field = OriginalConfigReader.float_field
    integer_field = OriginalConfigReader.integer_field
    identity_field = OriginalConfigReader.identity_field
    numeric_field = OriginalConfigReader.numeric_field

    def __init__(self, binary, roots):
        if not isinstance(roots, list) or not 1 <= len(roots) <= 4:
            raise ValueError('Explicit bounded read-only backend roots required')
        self.roots = [pathlib.Path(p).resolve(strict=True) for p in roots]
        if any(not p.is_dir() for p in self.roots):
            raise ValueError('Backend root must be a directory')
        self.cache_mode = False
        self.config_mode = False
        self.stream = None
        super().__init__(binary, self.roots[0])
        self.markers = {self.work+0x59000+0x20*i: name for i, name in enumerate(
            ['thread', 'cwd', 'attributes', 'remove_directory', 'open', 'access', 'read', 'close'])}
        self.capture = self.work+0x5a000
        self.u.mem_write(self.capture, b'\xd9\x1d'+struct.pack('<I', self.float_value)+b'\xc3')

    def reset(self):
        super().reset()
        # Every start is a fresh isolated process context. Merely resetting
        # selected flags leaves process-owned SSO/vector storage pointing into
        # the reused arena. Restore all original writable PE sections instead.
        self.writable_reset_ranges = []
        for section in self.pe.sections:
            if not section.Characteristics & 0x80000000:
                continue
            start = section.VirtualAddress
            raw = self.image[start:start+max(section.Misc_VirtualSize, section.SizeOfRawData)]
            self.u.mem_write(self.base+start, raw)
            self.writable_reset_ranges.append({'address': hex(self.base+start), 'bytes': len(raw),
                                                'sha256': hashlib.sha256(raw).hexdigest()})
        if not hasattr(self, 'initial_mxcsr'):
            self.initial_mxcsr = self.u.reg_read(UC_X86_REG_MXCSR)
        self.u.reg_write(UC_X86_REG_MXCSR, self.initial_mxcsr)
        self.cache_ready = False
        self.cache_mode = False
        self.config_mode = False
        self.stream = None
        self.opened = []
        self.read_streams = []
        self.accesses = []
        self.scalar_events = []
        self.pending_scalars = []
        self.constructed = []
        self.w(0x2d83fb8, 0)
        self.w(0x2d8aa78, 0)
        self.w(0x2d77b20, 0)

    @staticmethod
    def logical_path(value):
        if not isinstance(value, str) or not value or not value.isascii() or '\0' in value or len(value) > 400:
            raise ValueError('Invalid logical config path')
        value = value.replace('\\', '/')
        if value.startswith('/') or ':' in value or any(x in ['', '.', '..'] for x in value.split('/')):
            raise ValueError('Config traversal/absolute path refused')
        if not re.fullmatch(r'[A-Za-z0-9_./-]+', value):
            raise ValueError('Unqualified logical config characters')
        return value

    def physical(self, logical, root_index=0):
        value = self.logical_path(logical)
        root = self.roots[root_index]
        current = root
        for part in pathlib.PurePosixPath(value).parts:
            current = current/part
            if current.is_symlink() or current.is_junction():
                raise ValueError('Config link/reparse boundary refused')
        result = current.resolve()
        if not result.is_relative_to(root):
            raise ValueError('Config path escaped backend root')
        return result

    def start(self, locale=None):
        if locale is not None and (not isinstance(locale, str) or not re.fullmatch(r'[a-z]{2}_[A-Z]{2}', locale)):
            raise ValueError('Explicit locale or unchanged initial resolver state required')
        self.reset()
        self.allowed = list(self.original_ranges)
        self.native_registration_mode = True
        self.scan_mode = False
        self.cache_mode = True
        self.config_mode = True
        reverse = {name: address for address, name in self.markers.items()}
        for iat, name in [(0xfa4378, 'thread'), (0xfa41d8, 'cwd'),
                          (0xfa41a4, 'attributes'), (0xfa41ac, 'remove_directory')]:
            self.w(iat, reverse[name])
        self.backend_objects = {}
        table = self.work+0x5b100
        self.w(table, reverse['open']); self.w(table+4, reverse['access'])
        for index in range(len(self.roots)):
            obj = self.work+0x5b000+0x20*index
            self.w(obj, table); self.w(0x2d6e4a0+4*index, obj)
            self.backend_objects[obj] = index
        self.w(0x2d6e4b0, len(self.roots))
        self.w(0x2d78db4, self.work+0x1a00)
        self.u.mem_write(0x2d78db8, bytes([int(locale is not None)]))
        self.u.mem_write(0x14beb74, (locale or '').encode('ascii')+b'\0')
        self.cache_ready = True
        return {'prepared': True, 'roots': [str(p) for p in self.roots],
                'locale_resolver_enabled': locale is not None, 'locale': locale,
                'historical_bootstrap_qualified': False}

    def hook(self, uc, address, size, unused):
        if self.cache_mode:
            sp = self.u.reg_read(UC_X86_REG_ESP)
            ecx = self.u.reg_read(UC_X86_REG_ECX)
            if address == 0xc98719:
                if self.rd(0x14ae870) != 0:
                    raise ValueError('Original locale-aware path fold unqualified')
                if self.rd(sp+4) > 127:
                    raise ValueError('Non-ASCII original path fold unqualified')
                self.visited.add(address); self.case_visited.add(address)
                return
            if address == self.capture or self.capture < address < self.capture+7:
                return
            if self.pending_scalars and address == self.pending_scalars[-1]['return_address']:
                event = self.pending_scalars.pop()
                event['found'] = bool(self.u.reg_read(UC_X86_REG_EAX)&255)
                event['float32_hex'] = bytes(self.u.mem_read(event['out'], 4)).hex()
                self.scalar_events.append(event)
            if address == 0x8afb10:
                self.pending_scalars.append({'object': hex(ecx), 'return_address': self.rd(sp),
                    'out': self.rd(sp+4), 'key': self.rd(sp+16),
                    'default_float32_hex': bytes(self.u.mem_read(sp+20, 4)).hex()})
            if address == 0x8ad5b0:
                self.constructed.append({'object': hex(ecx),
                    'arguments': [self.cstring(self.rd(sp+i)) for i in [4, 8, 12]]})
            if address == 0x8b1f50:
                # Bypass the old scalar-value transfer adapter: execute the
                # complete native singleton/cache/override/scalar wrapper.
                self.visited.add(address); self.case_visited.add(address)
                return
            if address == 0xc9f39b:
                super().hook(uc, 0x9933e0, size, unused)
                self.calls[-1]['actual_allocation_entry'] = '0xc9f39b'
                return
            if address in [0xc97e4c, 0x5b47e0]:
                self.calls.append({'adapter': 'isolated_atexit' if address == 0xc97e4c else 'allocator_runtime_bootstrap',
                                   'entry': hex(address)})
                self.leave(0)
                return
            if address == 0xc9f355:
                path = self.cstring(self.rd(sp+4)); physical = self.physical(path)
                if physical.exists():
                    raise ValueError('Existing raw INI stat semantics unqualified: '+path)
                self.calls.append({'adapter': 'readonly_absent_raw_ini_stat', 'logical': path})
                self.leave(0xffffffff)
                return
            if address == 0xca9191:
                thread = self.work+0x1c00; self.u.mem_write(thread, bytes(0x200))
                self.w(thread+0x6c, self.rd(0x122323c)); self.w(thread+0x68, self.rd(0x1222dd4))
                self.calls.append({'adapter': 'CRT_thread_embedded_initial_locale'})
                self.leave(thread)
                return
            if address in [0x5642d0, 0x5fa170]:
                self.calls.append({'adapter': 'diagnostic_logging_boundary', 'entry': hex(address)})
                self.leave()
                return
            if address in self.markers:
                name = self.markers[address]
                if name == 'thread':
                    self.leave(1)
                    return
                if name == 'cwd':
                    capacity, out = self.rd(sp+4), self.rd(sp+8)
                    raw = str(self.roots[0]).encode('ascii')
                    if len(raw)+1 > capacity:
                        raise ValueError('Explicit cache cwd exceeds original capacity')
                    self.u.mem_write(out, raw+b'\0'); self.leave(len(raw), 8)
                    return
                if name == 'remove_directory':
                    raise ValueError('Host directory mutation refused before execution')
                if name == 'attributes':
                    logical = self.cstring(self.rd(sp+4)); physical = self.physical(logical)
                    value = 0x10 if physical.is_dir() else (0x20 if physical.is_file() else 0xffffffff)
                    self.calls.append({'adapter': 'readonly_current_file_attributes', 'logical': logical, 'value': value})
                    self.leave(value, 4)
                    return
                if name in ['access', 'open']:
                    if ecx not in self.backend_objects:
                        raise ValueError('Unqualified backend identity')
                    index = self.backend_objects[ecx]; logical = self.cstring(self.rd(sp+4))
                    physical = self.physical(logical, index)
                    if name == 'access':
                        flags = self.rd(sp+8)
                        if flags not in [0, 4]:
                            raise ValueError('Non-read-only backend access refused')
                        exists = physical.is_file()
                        self.accesses.append({'logical': logical, 'backend': index, 'flags': flags, 'exists': exists})
                        self.leave(0 if exists else 0xffffffff, 8)
                        return
                    mode = self.cstring(self.rd(sp+8))
                    if mode != 'rb' or not logical.lower().endswith('.inibin'):
                        raise ValueError('Raw text/non-compiled cache stream unqualified')
                    raw = physical.read_bytes()
                    if len(raw) > 0x10000:
                        raise ValueError('Oversized compiled cache input refused')
                    self.stream = {'raw': raw, 'position': 0, 'closed': False, 'reads': [],
                                   'logical': logical, 'physical': str(physical), 'backend': index}
                    self.opened.append({'logical': logical, 'physical': str(physical), 'backend': index,
                                        'bytes': len(raw), 'sha256': hashlib.sha256(raw).hexdigest(), 'mode': mode})
                    file = self.work+0x1800; table = self.work+0x1900
                    self.w(file, table); reverse = {v:k for k,v in self.markers.items()}
                    self.w(table, reverse['close']); self.w(table+0x24, reverse['read'])
                    self.leave(file, 8)
                    return
                if ecx != self.work+0x1800 or self.stream is None or self.stream['closed']:
                    raise ValueError('Invalid cache byte stream identity/lifetime')
                if name == 'read':
                    out, width, count = [self.rd(sp+i) for i in [4, 8, 12]]
                    start = self.stream['position']; amount = width*count
                    if amount > 0x10000 or start+amount > len(self.stream['raw']):
                        raise ValueError('Truncated cache source refused at original read')
                    if amount:
                        self.u.mem_write(out, self.stream['raw'][start:start+amount])
                    self.stream['position'] += amount
                    self.stream['reads'].append({'offset': start, 'item_size': width, 'count': count, 'bytes': amount})
                    self.leave(count, 12)
                    return
                if name == 'close':
                    if self.stream['position'] != len(self.stream['raw']):
                        raise ValueError('Original cache parser did not consume complete source')
                    self.stream['closed'] = True
                    self.read_streams.append({k:v for k,v in self.stream.items() if k != 'raw'})
                    self.leave(self.work+0x1800, 4)
                    return
        super().hook(uc, address, size, unused)

    def pair_snapshot(self):
        pair = self.rd(0x2d840bc)
        if not 0x50000000 <= pair < 0x50100000:
            raise ValueError('Original cache did not publish a qualified pair')
        result = {'pair': hex(pair)}
        for label, offset in [('primary', 0), ('override', 4)]:
            obj = self.rd(pair+offset)
            result[label] = None if not obj else {'object': hex(obj),
                'name': self.string(obj+0x24), 'defaults': self.string(obj+0x3c),
                'flags_148_149_14a': bytes(self.u.mem_read(obj+0x148, 3)).hex(),
                'text_source': self.string(obj+0x14c), 'text_defaults': self.string(obj+0x164)}
        return result

    def cached_scalar(self, logical, section, field, default, force=False):
        if not self.cache_ready:
            raise ValueError('Prepare explicit cache context before querying')
        self.logical_path(logical)
        if not logical.lower().endswith('.ini'):
            raise ValueError('Explicit logical .ini request required')
        if any(not isinstance(x, str) or not x or not x.isascii() or '\0' in x or len(x)>100 for x in [section, field]):
            raise ValueError('Invalid explicit section/field')
        if not isinstance(force, bool) or isinstance(default, bool) or not isinstance(default, (int, float)) or not math.isfinite(default):
            raise ValueError('Unqualified force/default input')
        before_open = len(self.opened); before_events = len(self.scalar_events)
        for at, text in [(self.work+0x3000, logical), (self.work+0x3300, section), (self.work+0x3500, field)]:
            self.u.mem_write(at, text.encode('ascii')+b'\0')
        default_bits = struct.unpack('<I', struct.pack('<f', default))[0]
        try:
            self.invoke(0x8b1f50, [self.work+0x3000, self.work+0x3300, self.work+0x3500, default_bits, int(force)])
            self.invoke(self.capture)
            value_bits = bytes(self.u.mem_read(self.float_value, 4))
            snapshot = self.pair_snapshot()
            self.obj = int(snapshot['primary']['object'], 16)
            return {'logical': logical, 'section': section, 'field': field, 'default': default,
                    'force': force, 'value': struct.unpack('<f', value_bits)[0], 'float32_hex': value_bits.hex(),
                    'pair': snapshot, 'new_opened_streams': self.opened[before_open:],
                    'original_scalar_events': self.scalar_events[before_events:],
                    'original_cache_and_full_constructor_executed': True,
                    'original_file_provider_dispatch_executed': True, 'historical_bootstrap_qualified': False}
        except BaseException:
            self.cache_ready = False; self.cache_mode = False; self.native_registration_mode = False
            raise

    def evidence(self):
        d = OriginalSkinProvider.evidence(self)
        d['native_cache_entries'] = {'singleton': '0x8aca20/0x8bac20', 'cache_lookup_load_publish': '0x8acef0',
                                    'full_config_object_constructor': '0x8ad5b0', 'scalar_wrapper': '0x8b1f50',
                                    'file_open_dispatch': '0x8b4ef0', 'file_access_dispatch': '0x8b4f60',
                                    'locale_path_resolver': '0x8b2ed0'}
        d['original_cache_manager_executed'] = 0x8acef0 in self.visited
        d['original_full_config_constructor_executed'] = 0x8ad5b0 in self.visited
        d['original_scalar_wrapper_executed'] = 0x8b1f50 in self.visited
        d['original_compiled_config_cache_executed'] = 0x8acef0 in self.visited
        d['original_file_provider_dispatch_executed'] = 0x8b4ef0 in self.visited
        d['original_access_helper_dispatch_executed'] = 0x8b4f60 in self.visited
        d['fresh_isolated_writable_image_ranges'] = self.writable_reset_ranges
        d['adapters'] = ['Bounded native allocation/free, SSO storage/copy/destruction and byte copy reuse the maintained directory/provider arena boundaries.',
                         'File-provider list is explicitly supplied; its native open/access loops execute. Read-only provider leaves observe actual files under declared roots. Virtual bounded Read/Close consume original bytes; no Python INIBIN decoder fills native arrays.',
                         'Fixed isolated thread ID and supplied cwd; read-only current attributes and stat-missing observations. RemoveDirectoryA is refused. Process allocator/atexit registration and logging are isolated boundaries.',
                         'Original embedded initial CRT locale/thread tables are supplied; historical later locale/provider/bootstrap context remains open.']
        d['limits'] = ['Complete historical process/provider mounting, effective runtime locale and upstream resource-package selection remain unqualified.',
                       'Existing raw-text INI/stat semantics are refused, not replaced with fabricated missing-file results. No game implementation, rendering, audio or acceptance is inferred.']
        d['isolated_floating_context'] = {'mxcsr': hex(self.u.reg_read(UC_X86_REG_MXCSR)),
                                         'x87_control_word': hex(self.u.reg_read(UC_X86_REG_FPCW)),
                                         'historical_overrides_qualified': False}
        return d
