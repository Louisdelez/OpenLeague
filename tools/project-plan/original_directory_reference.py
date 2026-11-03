"""Original directory/file scanning over an explicit read-only host iterator.

The iterator factory and its virtual methods are adapters over os.scandir.
The game package-provider bootstrap and historical directory order stay open.
"""
import fnmatch
import os
import pathlib
import re
import sys

sys.path.insert(0, 'E:/OpenLeague/tools/project-plan')
from original_skin_provider_reference import OriginalSkinProvider
from unicorn.x86_const import *


class OriginalDirectoryScanner(OriginalSkinProvider):
    def __init__(self, binary, data_root):
        self.data_root = pathlib.Path(data_root).resolve(strict=True)
        if not self.data_root.is_dir():
            raise ValueError('Explicit DATA directory required')
        self.scan_mode = False
        self.iteration = None
        self.enumerations = []
        self.scan_ready = False
        super().__init__(binary)
        self.u.mem_map(0x50000000, 0x400000)
        self.scan_alloc = 0x50000000
        self.scan_strings = 0x50200000
        self.iterator = self.work + 0x57000
        self.iterator_table = self.work + 0x56000
        self.iterator_name = self.work + 0x58000
        self.iterator_markers = {self.work + 0x55000 + 0x20*i: kind
                                 for i, kind in enumerate(['valid', 'next', 'name', 'is_directory'])}

    def reset(self):
        self.scan_ready = False
        self.iteration = None
        self.scan_alloc = 0x50000000
        self.scan_strings = 0x50200000
        super().reset()

    def assign(self, address, text):
        if len(text) < 16:
            return super().assign(address, text)
        raw = text.encode('ascii')
        if b'\0' in raw or len(raw) > 4095:
            raise ValueError('Unqualified string assignment')
        at = self.scan_strings
        self.scan_strings += (len(raw)+16)&~15
        if self.scan_strings >= 0x50400000:
            raise ValueError('Bounded directory string arena exhausted')
        self.u.mem_write(address, bytes(24))
        self.u.mem_write(at, raw+b'\0')
        self.w(address, at); self.w(address+16, len(raw)); self.w(address+20, len(raw))

    def invoke(self, entry, args=(), ecx=0, edx=0):
        stack = self.work+0x40000
        for i, value in enumerate([self.finish, *args]):
            self.w(stack+4*i, value)
        self.u.reg_write(UC_X86_REG_ESP, stack)
        self.u.reg_write(UC_X86_REG_ECX, ecx); self.u.reg_write(UC_X86_REG_EDX, edx)
        self.u.emu_start(entry, self.finish, count=10000000)
        if self.u.reg_read(UC_X86_REG_EIP) != self.finish:
            raise ValueError('Original bounded directory call did not return '+hex(entry))
        return self.u.reg_read(UC_X86_REG_EAX)

    def tree_entries(self, map_address):
        head = self.rd(map_address); seen = set(); entries = {}
        if self.u.mem_read(head+13, 1)[0] != 1:
            raise ValueError('Original directory sentinel invariant failed')
        root = self.rd(head+4)
        if root != head and self.u.mem_read(root+12, 1)[0] != 1:
            raise ValueError('Original directory tree root invariant failed')
        def walk(node, parent):
            if node == head:
                return 1
            if node in seen or len(seen) >= 2000 or self.rd(node+4) != parent or self.u.mem_read(node+13, 1)[0] != 0:
                raise ValueError('Original directory tree link/bound invariant failed')
            seen.add(node); left = self.rd(node); right = self.rd(node+8)
            color = self.u.mem_read(node+12, 1)[0]
            if color not in [0, 1] or (color == 0 and any(child != head and self.u.mem_read(child+12, 1)[0] == 0 for child in [left, right])):
                raise ValueError('Original directory tree color invariant failed')
            height = walk(left, node); name = self.string(node+0x10)
            if name in entries:
                raise ValueError('Duplicate original directory key')
            entries[name] = self.string(node+0x28)
            if walk(right, node) != height:
                raise ValueError('Original directory tree black-height invariant failed')
            return height+color
        walk(root, head)
        if len(entries) != self.rd(map_address+4) or list(entries) != sorted(entries, key=str.lower):
            raise ValueError('Original directory tree size/order invariant failed')
        return entries

    def resolve_directory(self, logical):
        if (not isinstance(logical, str) or not logical.isascii() or '\0' in logical
                or not logical or len(logical) > 300 or '\\' in logical):
            raise ValueError('Invalid explicit logical directory')
        relative = pathlib.PurePosixPath(logical)
        if relative.is_absolute() or ':' in logical or any(x in ['', '.', '..'] for x in logical.split('/')):
            raise ValueError('Directory traversal/absolute path refused')
        current = self.data_root
        for part in relative.parts:
            current = current / part
            if current.exists() and (current.is_symlink() or current.is_junction()):
                raise ValueError('Directory link/reparse boundary refused')
        resolved = current.resolve()
        if not resolved.is_relative_to(self.data_root):
            raise ValueError('Directory escaped explicit DATA root')
        return resolved

    def enumerate_host(self, query):
        if '/' not in query:
            raise ValueError('Iterator query has no explicit directory')
        directory, pattern = query.rsplit('/', 1)
        if pattern != '*' and not re.fullmatch(r'Skin[0-9]{2}\*', pattern):
            raise ValueError('Unsupported iterator wildcard refused')
        physical = self.resolve_directory(directory)
        records = []
        if physical.exists():
            if not physical.is_dir():
                raise ValueError('Iterator target is not a directory')
            # Preserve the actual current host order. Do not claim it equals
            # the historical directory provider's order or package overlays.
            with os.scandir(physical) as items:
                for item in items:
                    if not item.name.isascii() or '\0' in item.name or len(item.name) > 255:
                        raise ValueError('Unsupported native filename refused')
                    if item.is_symlink() or pathlib.Path(item.path).is_junction():
                        raise ValueError('Entry link/reparse boundary refused')
                    if not fnmatch.fnmatchcase(item.name.lower(), pattern.lower()):
                        continue
                    directory_entry = item.is_dir(follow_symlinks=False)
                    if not directory_entry and not item.is_file(follow_symlinks=False):
                        raise ValueError('Special filesystem entry refused')
                    records.append({'name': item.name, 'is_directory': directory_entry,
                                    'bytes': None if directory_entry else item.stat(follow_symlinks=False).st_size})
                    if len(records) > 512:
                        raise ValueError('Bounded directory iterator exceeded')
        result = {'query': query, 'directory': directory, 'physical': str(physical),
                  'exists': physical.exists(), 'entries': records,
                  'order': 'current os.scandir order; historical order unqualified'}
        self.enumerations.append(result)
        return records

    def hook(self, uc, address, size, unused):
        if address == 0xc98074:
            # Execute the original ASCII toupper path. The earlier restricted
            # adapter was equivalent only when both compared suffixes were
            # already lowercase; mixed-case extensions must use native code.
            if self.rd(0x14ae870) != 0:
                raise ValueError('Historical locale-dependent ctype override unqualified')
            value = self.rd(self.u.reg_read(UC_X86_REG_ESP)+4)
            if value > 127:
                raise ValueError('Non-ASCII original suffix input unqualified')
            self.visited.add(address); self.case_visited.add(address)
            return
        if self.native_registration_mode and address == 0x9933e0:
            count = self.rd(self.u.reg_read(UC_X86_REG_ESP)+4)
            if not 0 < count <= 0x10000:
                raise ValueError('Unqualified directory native allocation')
            at = self.scan_alloc; self.scan_alloc += (count+15)&~15
            if self.scan_alloc >= 0x50100000:
                raise ValueError('Bounded directory allocation arena exhausted')
            self.u.mem_write(at, bytes(count))
            self.calls.append({'adapter': 'directory_native_allocation_boundary', 'bytes': count})
            self.leave(at); return
        if self.native_registration_mode and address == 0xc98528:
            pointer = self.rd(self.u.reg_read(UC_X86_REG_ESP)+4)
            if pointer and not (self.work+0x6000 <= pointer < self.work+0x30000 or 0x50000000 <= pointer < 0x50400000):
                raise ValueError('Unqualified directory free pointer')
            self.calls.append({'adapter': 'directory_isolated_arena_free'})
            self.leave(); return
        if self.scan_mode:
            sp = self.u.reg_read(UC_X86_REG_ESP)
            if address == 0x8b4830:
                out = self.u.reg_read(UC_X86_REG_ECX)
                query = self.cstring(self.u.reg_read(UC_X86_REG_EDX))
                if self.rd(sp+4) != 0:
                    raise ValueError('Unqualified iterator factory mode')
                records = self.enumerate_host(query)
                self.iteration = {'entries': records, 'position': 0}
                self.w(self.iterator, self.iterator_table)
                for i, marker in enumerate(self.iterator_markers):
                    self.w(self.iterator_table+4*i, marker)
                self.w(out, self.iterator)
                self.w(out+4, 0)  # adapter-owned lifetime; no native refcount object
                self.calls.append({'adapter': 'readonly_current_host_directory_iterator',
                                   'query': query, 'entries': len(records)})
                self.leave(out)
                return
            if address in self.iterator_markers:
                if self.u.reg_read(UC_X86_REG_ECX) != self.iterator or self.iteration is None:
                    raise ValueError('Invalid directory iterator identity/lifetime')
                kind = self.iterator_markers[address]
                state = self.iteration
                if kind == 'valid':
                    self.leave(int(state['position'] < len(state['entries'])))
                else:
                    if state['position'] >= len(state['entries']):
                        raise ValueError('Directory iterator accessed after end')
                    item = state['entries'][state['position']]
                    if kind == 'next':
                        state['position'] += 1
                        self.leave()
                    elif kind == 'is_directory':
                        self.leave(int(item['is_directory']))
                    else:
                        self.u.mem_write(self.iterator_name, item['name'].encode('ascii')+b'\0')
                        self.leave(self.iterator_name)
                return
            if address == 0x657fc0:
                fmt = self.cstring(self.u.reg_read(UC_X86_REG_EDX))
                if fmt != '%1/Sounds/Skin%2/Sounds':
                    raise ValueError('Unqualified skin sound directory formatter')
                first = self.cstring(self.rd(self.rd(sp+4)))
                second = self.string(self.rd(self.rd(sp+8)))
                value = first+'/Sounds/Skin'+second+'/Sounds'
                self.assign(self.u.reg_read(UC_X86_REG_ECX), value)
                self.calls.append({'adapter': 'literal_skin_sound_directory_format', 'format': fmt, 'value': value})
                self.leave(len(value))
                return
        super().hook(uc, address, size, unused)

    def begin(self):
        self.reset()
        self.profiles = [{'context': 'reference-DATA', 'local': {}, 'base': {}}]
        self.configure()
        outer_head = self.rd(self.work+0x1008)
        self.inner = self.rd(outer_head+4)+0x28
        self.native_registration_mode = True
        self.w(self.inner, self.invoke(0x6542a0))
        self.w(self.inner+4, 0)
        self.scan_mode = True
        self.enumerations = []

    def finish_scan(self, kind):
        entries = self.tree_entries(self.inner)
        self.scan_ready = True
        self.current_original_alias_registration = True
        self.any_original_alias_registration = True
        return {'kind': kind, 'entries': entries, 'native_map_count': self.rd(self.inner+4),
                'enumerations': self.enumerations, 'original_addresses_exercised': len(self.case_visited),
                'original_file_scan_executed': 0x905620 in self.case_visited,
                'original_directory_scan_executed': 0x905a00 in self.case_visited,
                'original_skin_package_scan_executed': 0x902ad0 in self.case_visited,
                'original_host_iterator_factory_executed': False,
                'tree_invariants_verified': ['parent_links', 'ordered_keys', 'size', 'red_black_colors_and_height']}

    def scan_directories(self, directories, kind='files', pattern='*'):
        if kind not in ['files', 'directories'] or not isinstance(directories, list) or not 1 <= len(directories) <= 8:
            raise ValueError('Explicit bounded directory scan required')
        for directory in directories:
            self.resolve_directory(directory)
        if pattern != '*' and not re.fullmatch(r'Skin[0-9]{2}\*', pattern):
            raise ValueError('Unsupported iterator wildcard refused')
        self.begin()
        try:
            for directory in directories:
                self.assign(self.work+0x3000, directory)
                self.assign(self.work+0x3500, pattern)
                self.invoke(0x905620 if kind == 'files' else 0x905a00, [self.inner], self.work+0x3000, self.work+0x3500)
            return self.finish_scan(kind)
        finally:
            self.scan_mode = False
            self.native_registration_mode = False

    def discover_skin(self, champion, number):
        self.inputs(champion, number)
        if number == 0:
            raise ValueError('Original non-base scanner requires skin number 1..99')
        self.begin()
        try:
            self.assign(self.work+0x3000, f'{number:02}')
            self.assign(self.work+0x3500, 'Characters/'+champion)
            self.invoke(0x902ad0, [0, self.inner], self.work+0x3000, self.work+0x3500)
            return self.finish_scan('non_base_skin')
        finally:
            self.scan_mode = False
            self.native_registration_mode = False

    def filename_registered(self, champion, number):
        result = super().filename_registered(champion, number)
        result['original_file_directory_scan_executed'] = self.scan_ready
        result['original_non_base_package_scanner_executed'] = self.scan_ready and 0x902ad0 in self.case_visited
        return result

    def resolve_registered(self, logical_name):
        result = super().resolve_registered(logical_name)
        result['original_file_directory_scan_executed'] = self.scan_ready
        result['original_non_base_package_scanner_executed'] = self.scan_ready and 0x902ad0 in self.case_visited
        return result

    def evidence(self):
        d = super().evidence()
        d['adapters'] = [x for x in d['adapters'] if not x.startswith('Alias experiment') and not x.startswith('Section lookup returns')]
        d['limits'] = ['The file/directory scans and non-base folder discovery execute over the declared current host iterator. Full package-provider bootstrap, base/legacy/overlay contexts and compiled cache/defaults remain open.',
                       'No ordinary current game skin dispatch, availability, asset inheritance, rendering, audio or gameplay acceptance is established.']
        d['original_directory_entries'] = {'file_scan': '0x905620', 'directory_scan': '0x905a00',
                                            'non_base_skin_scan': '0x902ad0', 'ascii_toupper': '0xc98074..0xc98091'}
        d['adapters'] += ['0x8b4830 and four virtual iterator methods supply a bounded read-only os.scandir snapshot, preserving current host order; native scanners filter directory/file kinds, register aliases, traverse and balance the original map.',
                          '0x657fc0 adapts only the literal %1/Sounds/Skin%2/Sounds format and explicit arguments; no arbitrary formatter or filesystem write is allowed.',
                          'Separate bounded arenas supply at most 1MiB of native allocations and 2MiB of SSO storage per case; allocation/free/SSO bytes are adapters. The instruction budget is ten million per original call, directory entries are bounded to512 and final tree size to2000.']
        d['limits'] += ['Full provider/package bootstrap, overlay and fallback package selection, historical iterator ordering and compiled cache/defaults/overrides remain unqualified. The non-base scanner is executed with its first unused stack argument explicitly zero; it is not a full native package object constructor.']
        d['isolated_ctype_context'] = {'original_instructions_executed': 0xc98074 in self.visited, 'global': '0x14ae870',
                                       'value': self.rd(0x14ae870), 'historical_later_locale_override_qualified': False}
        return d
