"""Original raw config parsing and string selection, with read-only leaves.

The backend list and working/config paths are declared inputs. This is not a
claim about the mounted historical process or its effective locale.
"""
import hashlib
import os
import pathlib
import re
import struct
import sys

sys.path.insert(0, 'E:/OpenLeague/tools/project-plan')
from original_config_cache_reference import OriginalConfigCache
from unicorn.x86_const import *


class OriginalTextConfig(OriginalConfigCache):
    def __init__(self, binary, roots, observation_root=None):
        self.observation_root = pathlib.Path(observation_root or roots[0]).resolve(strict=True)
        super().__init__(binary, roots)
        self.text_markers = {self.work+0x5c000: 'size', self.work+0x5c020: 'seek'}
        self.directory_markers = {self.work+0x5c040: 'create_directory', self.work+0x5c060: 'copy_file',
            self.work+0x5c080: 'move_file', self.work+0x5c0a0: 'write_file', self.work+0x5c0c0: 'delete_file'}

    def reset(self):
        super().reset()
        self.raw_stats = []
        self.raw_queries = []
        self.upstream_events = []

    def observed_path(self, value):
        if not isinstance(value, str) or not value.isascii() or '\0' in value or not 0<len(value)<1024:
            raise ValueError('Invalid readonly observation path')
        p = pathlib.Path(value.replace('\\', '/'))
        p = p if p.is_absolute() else self.roots[0]/p
        p = pathlib.Path(os.path.abspath(p))
        if not p.is_relative_to(self.observation_root):
            raise ValueError('Observation escaped declared root')
        for q in [p, *p.parents]:
            if q.is_symlink() or q.is_junction():
                raise ValueError('Observation reparse/link refused')
            if q == self.observation_root:
                break
        return p

    def physical(self, logical, root_index=0):
        if pathlib.Path(logical).is_absolute():
            return self.observed_path(logical)
        return super().physical(logical, root_index)

    def start(self, locale=None):
        result = super().start(locale)
        reverse = {v:k for k,v in self.directory_markers.items()}
        guarded = {b'CreateDirectoryA':'create_directory',b'CopyFileA':'copy_file',
            b'MoveFileExW':'move_file',b'WriteFile':'write_file',b'DeleteFileA':'delete_file',b'DeleteFileW':'delete_file'}
        for library in self.pe.DIRECTORY_ENTRY_IMPORT:
            for item in library.imports:
                if item.name in guarded:
                    self.w(item.address, reverse[guarded[item.name]])
        return result

    def string(self, address):
        length = self.rd(address+16)
        if length > 0xffff:
            raise ValueError('Bounded original text string exceeded')
        data = self.rd(address) if self.rd(address+20) >= 16 else address
        return bytes(self.u.mem_read(data, length)).decode('ascii')

    def assign(self, address, text):
        raw = text.encode('ascii')
        # Native std::string permits embedded NUL bytes. ReadAll deliberately
        # appends a terminator to the file string; an unterminated last line
        # can include it in a substring. Preserve size/bytes, never strip it.
        if len(raw) > 0xffff:
            raise ValueError('Bounded text string assignment exceeded')
        if len(raw) < 16:
            self.u.mem_write(address, bytes(24))
            self.u.mem_write(address, raw+b'\0')
            self.w(address+16, len(raw)); self.w(address+20, 15)
            return
        at = self.scan_strings
        self.scan_strings += (len(raw)+16)&~15
        if self.scan_strings >= 0x50400000:
            raise ValueError('Bounded text string arena exhausted')
        self.u.mem_write(address, bytes(24))
        self.u.mem_write(at, raw+b'\0')
        self.w(address, at); self.w(address+16, len(raw)); self.w(address+20, len(raw))

    def hook(self, uc, address, size, unused):
        if self.cache_mode:
            sp = self.u.reg_read(UC_X86_REG_ESP)
            ecx = self.u.reg_read(UC_X86_REG_ECX)
            if address in [0x82d1a0, 0x8b15d0, 0x8b3970, 0x8b3140, 0x8b2e70]:
                self.upstream_events.append({'entry': hex(address), 'locale_before': self.cstring(0x14beb74),
                    'enabled_before': bool(self.u.mem_read(0x2d78db8,1)[0])})
            if address == 0xc9c554:
                # Aligned chain 8b312c -> c9c554 -> cb28fc -> MoveFileExW.
                # Refuse before CRT conversions, allocation and OS dispatch.
                raise ValueError('Host file move refused before execution')
            if address in self.directory_markers:
                kind = self.directory_markers[address]
                if kind != 'create_directory':
                    raise ValueError('Host file '+kind.replace('_file','')+' refused before execution')
                logical = self.cstring(self.rd(sp+4)); p = self.observed_path(logical)
                if not p.is_dir() or self.rd(sp+8) != 0:
                    raise ValueError('Host directory creation refused before execution')
                self.upstream_events.append({'adapter': 'readonly_already_existing_directory',
                    'logical': logical, 'physical': str(p), 'api_return': 0, 'host_mutated': False})
                self.leave(0, 8)
                return
            if address in self.markers and self.markers[address] == 'attributes':
                logical = self.cstring(self.rd(sp+4)); p = self.observed_path(logical)
                value = 0x10 if p.is_dir() else (0x20 if p.is_file() else 0xffffffff)
                self.upstream_events.append({'adapter': 'readonly_current_attributes',
                    'logical': logical, 'physical': str(p), 'attributes': value})
                self.leave(value, 4)
                return
            if address == 0xc9f6c9:
                logical = self.cstring(self.rd(sp+4)); mode = self.rd(sp+8)
                if mode != 2:
                    raise ValueError('Unqualified writable-directory permission query')
                p = self.observed_path(logical); writable = p.exists() and os.access(p, os.W_OK)
                self.upstream_events.append({'adapter': 'readonly_directory_permission_observation',
                    'physical': str(p), 'mode': mode, 'writable': writable, 'host_mutated': False})
                self.leave(0 if writable else 0xffffffff)
                return
            if address == 0xc9f355 and self.rd(sp) == 0x8ada92:
                logical = self.cstring(self.rd(sp+4))
                physical = self.physical(logical)
                if physical.exists():
                    if not physical.is_file():
                        raise ValueError('Raw config stat requires a regular file')
                    # This constructor reads only the 64-bit mtime at +0x28.
                    # Do not pretend to implement arbitrary CRT stat callers.
                    stamp = int(physical.stat().st_mtime)
                    out = self.rd(sp+8)
                    self.u.mem_write(out, bytes(0x38))
                    self.u.mem_write(out+0x28, struct.pack('<q', stamp))
                    self.raw_stats.append({'logical': logical, 'physical': str(physical),
                        'mtime_seconds': stamp, 'return_site': '0x8ada92',
                        'qualified_output_fields': ['mtime64@0x28'], 'historical_mtime': False})
                    self.leave(0)
                    return
            if address in self.markers and self.markers[address] == 'open':
                if ecx not in self.backend_objects:
                    raise ValueError('Unqualified text backend identity')
                logical = self.cstring(self.rd(sp+4))
                mode = self.cstring(self.rd(sp+8))
                if logical.lower().endswith(('.ini', '.cfg')):
                    if mode != 'rb':
                        raise ValueError('Non-read-only text stream refused')
                    index = self.backend_objects[ecx]
                    physical = self.physical(logical, index)
                    raw = physical.read_bytes()
                    if len(raw) > 0xffff or b'\0' in raw or not raw.isascii():
                        raise ValueError('Unqualified raw text encoding/size/NUL')
                    self.stream = {'raw': raw, 'position': 0, 'closed': False, 'reads': [],
                        'logical': logical, 'physical': str(physical), 'backend': index}
                    self.opened.append({'logical': logical, 'physical': str(physical), 'backend': index,
                        'bytes': len(raw), 'sha256': hashlib.sha256(raw).hexdigest(), 'mode': mode})
                    file, table = self.work+0x1800, self.work+0x1900
                    self.w(file, table)
                    reverse = {v:k for k,v in self.markers.items()}
                    for offset, name in [(0, 'close'), (0x24, 'read')]:
                        self.w(table+offset, reverse[name])
                    for marker, name in self.text_markers.items():
                        self.w(table+(8 if name == 'size' else 0x1c), marker)
                    self.leave(file, 8)
                    return
            if address in self.text_markers:
                if ecx != self.work+0x1800 or self.stream is None or self.stream['closed']:
                    raise ValueError('Invalid raw text stream identity/lifetime')
                name = self.text_markers[address]
                if name == 'size':
                    self.leave(len(self.stream['raw']))
                    return
                offset, origin = self.rd(sp+4), self.rd(sp+8)
                if (offset, origin) != (0, 0):
                    raise ValueError('Only original ReadAll rewind is qualified')
                self.stream['position'] = 0
                self.leave(0, 8)
                return
        super().hook(uc, address, size, unused)

    def cached_string(self, logical, section, field, default='', force=False, capacity=500):
        if not self.cache_ready:
            raise ValueError('Prepare explicit text cache context first')
        self.logical_path(logical)
        if not logical.lower().endswith(('.ini', '.cfg')):
            raise ValueError('Explicit .ini/.cfg path required')
        for value in [section, field, default]:
            if not isinstance(value, str) or not value.isascii() or '\0' in value or len(value)>100:
                raise ValueError('Invalid text query section/field/default')
        if not section or not field or not isinstance(force, bool) or type(capacity) is not int or not 1<=capacity<=500:
            raise ValueError('Invalid text query force/capacity')
        before = len(self.opened)
        for at, value in [(self.work+0x3000, logical), (self.work+0x3300, section),
                          (self.work+0x3500, field), (self.work+0x3700, default)]:
            self.u.mem_write(at, value.encode('ascii')+b'\0')
        out = self.work+0x3a00
        self.u.mem_write(out, b'\xcc'*502)
        try:
            self.invoke(0x8b0630, [self.work+0x3700, out, capacity, self.work+0x3000, int(force)],
                        self.work+0x3300, self.work+0x3500)
            result = {'logical': logical, 'section': section, 'field': field, 'default': default,
                'capacity': capacity, 'value': self.cstring(out), 'pair': self.pair_snapshot(),
                'new_opened_streams': self.opened[before:], 'native_string_wrapper_executed': True}
            self.raw_queries.append(result)
            return result
        except BaseException:
            self.cache_ready = False; self.cache_mode = False; self.native_registration_mode = False
            raise

    def set_locale(self, locale):
        if not self.cache_ready or not isinstance(locale, str) or not re.fullmatch(r'[a-z]{2}_[A-Z]{2}', locale):
            raise ValueError('Explicit five-character locale and prepared context required')
        before = self.cstring(0x14beb74)
        self.u.mem_write(self.work+0x3900, locale.encode('ascii')+b'\0')
        self.invoke(0x8b2e70, ecx=self.work+0x3900)
        return {'before': before, 'requested': locale, 'enabled': bool(self.u.mem_read(0x2d78db8,1)[0]),
                'after': self.cstring(0x14beb74), 'original_setter_executed': True}

    def initialize_locale(self, declared_user_config=None):
        if not self.cache_ready:
            raise ValueError('Prepare explicit text cache context first')
        if declared_user_config is not None:
            self.logical_path(declared_user_config)
            if not declared_user_config.lower().endswith('.cfg'):
                raise ValueError('Explicit user config must be .cfg')
            self.assign(0x2d8a9c0, declared_user_config)
            self.w(0x2d8a9dc, 1)
        app = self.work+0x3d00
        self.assign(app, '')
        self.w(0x2d78d08, app)
        try:
            self.invoke(0x82d1a0)
            return {'locale': self.cstring(0x14beb74), 'enabled': bool(self.u.mem_read(0x2d78db8,1)[0]),
                'application_string': self.string(app), 'declared_user_config': declared_user_config,
                'selected_user_config': self.string(0x2d8a9c0) if self.rd(0x2d8a9dc)&1 else None,
                'native_config_directory_mode': self.rd(0x2d859f4) if 0x8b3140 in self.case_visited else None,
                'original_locale_caller_executed': True, 'historical_effective_locale_qualified': False}
        except BaseException:
            self.cache_ready = False; self.cache_mode = False; self.native_registration_mode = False
            raise

    def global_string(self, section, field, default=''):
        if not self.cache_ready:
            raise ValueError('Prepare explicit text cache context first')
        if any(not isinstance(v,str) or not v.isascii() or '\0' in v or len(v)>100 for v in [section,field,default]) or not section or not field:
            raise ValueError('Invalid global string query')
        for at,value in [(self.work+0x3300,section),(self.work+0x3500,field),(self.work+0x3700,default)]:
            self.u.mem_write(at,value.encode('ascii')+b'\0')
        out=self.invoke(0x8b15d0,[self.work+0x3700,0],self.work+0x3300,self.work+0x3500)
        return {'section':section,'field':field,'default':default,'value':self.cstring(out),
            'selected_user_config':self.string(0x2d8a9c0),'native_directory_mode':self.rd(0x2d859f4),
            'native_global_wrapper_executed':True}

    def evidence(self):
        result = super().evidence()
        result['native_text_entries'] = {'parser': '0x8aec00', 'read_all': '0x8b5030',
            'string_wrapper': '0x8b0630', 'locale_setter': '0x8b2e70'}
        result['original_raw_text_parser_executed'] = 0x8aec00 in self.visited
        result['original_string_wrapper_executed'] = 0x8b0630 in self.visited
        result['raw_stats'] = self.raw_stats
        result['upstream_events'] = self.upstream_events
        result['limits'] = ['Backend list/current cwd are supplied. Historical mounts, command line, generated files, installed locale and CRT overrides remain unqualified.',
            'ASCII raw .ini/.cfg, bounded ReadAll size/rewind and constructor-only current mtime observation are qualified; arbitrary stat/stream semantics and host writes are refused.',
            'No historical process, current Rust game consumer, rendering, audio or gameplay acceptance is inferred.']
        result['adapters'].append('Virtual size/rewind/read/close expose actual raw bytes. Only constructor return0x8ada92 receives current mtime64@+0x28; no Python config parser populates native arrays.')
        return result
