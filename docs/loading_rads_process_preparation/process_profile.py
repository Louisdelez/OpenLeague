"""Explicit virtual game-process command line. No host argv or environment."""
from pathlib import Path
import sys,ntpath,hashlib
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import unicorn

class ProfileError(RuntimeError):pass
class ProcessProfile:
    def __init__(self,u,virtual_executable,base=0x3b000000,environment=()):
        self.u=u;self.base=base;self.size=0x1000;self.closed=False;self.calls=0
        self.environment_blocks={};self.environment_cursor=base+0x10000;self.events=[]
        entries=[];keys=set()
        for key,value in environment:
            if not isinstance(key,str) or not isinstance(value,str) or not key or '=' in key or '\0' in key or '\0' in value:raise ProfileError('invalid declared environment entry')
            if key.casefold() in keys:raise ProfileError('duplicate environment name')
            keys.add(key.casefold());entries.append(key+'='+value)
        self.environment=('\0'.join(entries)+'\0\0').encode('utf-16le')
        if len(self.environment)>0x1000:raise ProfileError('declared environment exceeds one page')
        path=str(virtual_executable)
        if not path.isascii() or '\0' in path or '"' in path or not ntpath.isabs(path):raise ProfileError('invalid explicit virtual executable path')
        if ntpath.basename(path)!='League of Legends.exe':raise ProfileError('virtual process must name original game executable')
        self.command_line=('"'+path+'"').encode('ascii')+b'\0'
        if len(self.command_line)>self.size:raise ProfileError('declared command line exceeds owned page')
        if base&0xfff or not 0<base<=0x100000000-0x100000:raise ProfileError('invalid x86 process storage reservation')
        for a,b,_ in u.mem_regions():
            if base<=b and a<base+self.size:raise ProfileError('process-owned page overlaps existing memory')
        u.mem_map(base,self.size)
        try:
            u.mem_write(base,self.command_line);u.mem_protect(base,self.size,unicorn.UC_PROT_READ)
        except BaseException:u.mem_unmap(base,self.size);raise
    def get_command_line_a(self):
        if self.closed:raise ProfileError('virtual process storage already retired')
        self.calls+=1;return self.base
    def get_environment_strings_w(self):
        if self.closed:raise ProfileError('virtual process storage already retired')
        pointer=self.environment_cursor
        if pointer>=self.base+0x100000:raise ProfileError('environment profile allocation range exhausted')
        for a,b,_ in self.u.mem_regions():
            if pointer<=b and a<pointer+0x1000:raise ProfileError('environment allocation overlaps owned memory')
        self.u.mem_map(pointer,0x1000)
        try:
            self.u.mem_write(pointer,self.environment);self.u.mem_protect(pointer,0x1000,unicorn.UC_PROT_READ)
        except BaseException:self.u.mem_unmap(pointer,0x1000);raise
        self.environment_blocks[pointer]=len(self.environment);self.environment_cursor+=0x1000
        self.events.append({'api':'GetEnvironmentStringsW','pointer':pointer,'bytes':len(self.environment),'profile':'explicit declared environment, no host read'})
        return pointer
    def free_environment_strings_w(self,pointer):
        if self.closed:raise ProfileError('virtual process storage already retired')
        if pointer not in self.environment_blocks:raise ProfileError('unknown/already freed environment allocation')
        self.u.mem_unmap(pointer,0x1000);del self.environment_blocks[pointer]
        self.events.append({'api':'FreeEnvironmentStringsW','pointer':pointer,'result':1})
        return 1
    def snapshot(self):
        data=bytes(self.u.mem_read(self.base,len(self.command_line))) if not self.closed else None
        return {'profile':'quoted virtual game executable only; zero match arguments','pointer':self.base,
                'bytes':len(self.command_line),'sha256':hashlib.sha256(self.command_line).hexdigest(),
                'value':self.command_line[:-1].decode('ascii'),'calls':self.calls,'closed':self.closed,
                'declared_environment_utf16_hex':self.environment.hex(),'environment_live_allocations':len(self.environment_blocks),
                'environment_events':list(self.events),
                'memory_unchanged':data==self.command_line if data is not None else None,
                'host_argv_imported':False,'host_environment_imported':False}
    def close_after_execution(self):
        if not self.closed:
            for pointer in list(self.environment_blocks):
                self.u.mem_unmap(pointer,0x1000);del self.environment_blocks[pointer]
                self.events.append({'api':'end_process_environment_retirement','pointer':pointer,'native_free':False})
            self.u.mem_unmap(self.base,self.size);self.closed=True
