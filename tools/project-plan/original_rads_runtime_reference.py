"""Mapped original RADS runtime for the bounded unpacked-filesystem reference profile.

No Windows LoadLibrary or historical native process is used. DLL bytes and
imports are mapped inside the same isolated x86 emulator; unknown calls stop.
"""
import hashlib,json,pathlib,struct,sys,re,ctypes
R=pathlib.Path('E:/OpenLeague');sys.path.insert(0,str(R/'tools/project-plan'))
from original_text_config_reference import OriginalTextConfig
from readonly_windows_text_reference import ReadonlyWindowsTextLeaf
from unicorn.x86_const import *
import pefile


class OriginalMappedRadsRuntime(OriginalTextConfig):
    def __init__(self,binary,roots,observation_root):
        self.dll_loaded=False
        self.game_path=pathlib.Path(binary).resolve(strict=True)
        self.windows_text=ReadonlyWindowsTextLeaf()
        if self.windows_text.observed_host_acp!=1252:raise ValueError('Declared ACP1252 text profile does not match current host leaf')
        self.find_kernel=ctypes.WinDLL('kernel32',use_last_error=True)
        for suffix,text_type in [('W',ctypes.c_wchar_p),('A',ctypes.c_char_p)]:
            first=getattr(self.find_kernel,'FindFirstFileEx'+suffix)
            first.argtypes=[text_type,ctypes.c_int,ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p,ctypes.c_uint32];first.restype=ctypes.c_void_p
            next_file=getattr(self.find_kernel,'FindNextFile'+suffix)
            next_file.argtypes=[ctypes.c_void_p,ctypes.c_void_p];next_file.restype=ctypes.c_int
        self.find_kernel.FindClose.argtypes=[ctypes.c_void_p];self.find_kernel.FindClose.restype=ctypes.c_int
        super().__init__(binary,roots,observation_root)
        self.dll_path=pathlib.Path(observation_root)/'RADS/RiotRadsIO.dll'
        raw=self.dll_path.read_bytes()
        if hashlib.sha256(raw).hexdigest()!='60833cd552d93b93304d4937912951e144e38db5d70793eb60a0c5f5d579e521':
            raise ValueError('Unqualified native DLL source')
        self.dll_pe=pefile.PE(data=raw);self.dll_base=self.dll_pe.OPTIONAL_HEADER.ImageBase
        self.dll_image=self.dll_pe.get_memory_mapped_image()
        self.u.mem_map(self.dll_base,(len(self.dll_image)+4095)&~4095)
        self.dll_import_markers={};i=0
        for library in self.dll_pe.DIRECTORY_ENTRY_IMPORT:
            for item in library.imports:
                self.dll_import_markers[self.work+0x5d000+0x10*i]=(library.dll.decode(),item.name.decode() if item.name else item.ordinal,item.address)
                i+=1
        assert i<250
        for index,name in enumerate(['FlsAlloc','FlsFree','FlsGetValue','FlsSetValue']):
            self.dll_import_markers[self.work+0x5e000+0x10*index]=('DECLARED_KERNEL32',name,None)
        self.u.mem_map(0x51000000,0x1000000)
        self.dll_loaded=True

    def start(self,locale=None):
        if hasattr(self,'dll_handles'):self.close_read_handles()
        result=super().start(locale)
        self.dll_calls=[];self.dll_allocations={};self.dll_heap=0x51000000
        self.dll_tls={};self.next_tls=1;self.dll_last_error=0;self.dll_attached=False
        self.dll_critical_sections={}
        self.dll_handles={};self.next_handle=0x70001000;self.slist_heads=set()
        self.event_registrations={}
        self.dll_file_sources=[];self.dll_file_operations=[]
        if self.dll_loaded:
            self.u.mem_write(self.dll_base,self.dll_image)
            for marker,(_,_,iat) in self.dll_import_markers.items():
                if iat is not None:self.w(iat,marker)
            for section in self.dll_pe.sections:
                if section.Characteristics&0x20000000:
                    self.allowed.append((self.dll_base+section.VirtualAddress,
                        self.dll_base+section.VirtualAddress+section.Misc_VirtualSize))
        return result

    def wstring(self,address):
        raw=bytearray()
        for i in range(4096):
            pair=bytes(self.u.mem_read(address+2*i,2))
            if pair==b'\0\0':return raw.decode('utf-16-le')
            raw.extend(pair)
        raise ValueError('Unbounded wide string refused')

    def hook(self,uc,address,size,unused):
        if self.dll_loaded and self.cache_mode:
            sp=self.u.reg_read(UC_X86_REG_ESP);ecx=self.u.reg_read(UC_X86_REG_ECX)
            if address==0x100ec285:
                if ecx!=self.rd(0x101902c0):raise ValueError('DLL security cookie differs')
                self.dll_calls.append({'adapter':'DLL_cookie_preserving_eax'})
                self.leave(self.u.reg_read(UC_X86_REG_EAX));return
            if address in [0x1003d4d0,0x1003e1e0]:
                self.dll_calls.append({'adapter':'DLL_diagnostic_log_boundary','entry':hex(address)})
                self.leave(self.u.reg_read(UC_X86_REG_EAX));return
            if address in self.dll_import_markers:
                lib,name,_=self.dll_import_markers[address]
                self.dll_calls.append({'import':name,'library':lib,'return_site':hex(self.rd(sp)),
                    'argument_words':[self.rd(sp+i) for i in [4,8,12,16,20,24,28,32]]})
                if self.windows_text.handle(self,name,sp):return
                if name in ['EncodePointer','DecodePointer']:
                    self.leave(self.rd(sp+4)^0x6d4a9c31,4);return
                if name in ['GetCurrentProcessId','GetTickCount']:
                    self.leave(1);return
                if name=='IsProcessorFeaturePresent':
                    if self.rd(sp+4)!=10:raise ValueError('Only declared emulator SSE2 feature is qualified')
                    self.leave(1,4);return
                if name=='GetCurrentProcess':self.leave(0xffffffff);return
                if name=='GetCurrentPackageId':
                    # Explicit standalone/unpackaged process input. No AppX
                    # package or host installation is inferred or queried.
                    self.leave(15700,8);return
                if name=='GetCurrentThread':self.leave(0xfffffffe);return
                if name=='GetThreadTimes':
                    h=self.rd(sp+4)
                    if h!=0xfffffffe and self.dll_handles.get(h)!='current_thread':
                        raise ValueError('Unknown isolated thread-time handle')
                    for at,value in [(8,1),(12,0),(16,0),(20,0)]:
                        self.u.mem_write(self.rd(sp+at),struct.pack('<Q',value))
                    self.leave(1,20);return
                if name in ['GetThreadPriority','SetThreadPriority']:
                    h=self.rd(sp+4)
                    if h!=0xfffffffe and self.dll_handles.get(h)!='current_thread':
                        raise ValueError('Unknown isolated thread priority handle')
                    if name=='GetThreadPriority':self.leave(0,4);return
                    priority=self.rd(sp+8)
                    if priority not in [0,1,2,15,0xffffffff,0xfffffffe,0xfffffff1]:
                        raise ValueError('Unqualified declared thread priority')
                    self.leave(1,8);return
                if name=='IsDebuggerPresent':self.leave(0);return
                if name=='GetLogicalProcessorInformation':
                    out,length=self.rd(sp+4),self.rd(sp+8)
                    payload=b''.join(struct.pack('<II16s',1,kind,bytes(16)) for kind in [0,1,3])
                    capacity=self.rd(length);self.w(length,len(payload))
                    if not out or capacity<len(payload):self.dll_last_error=122;self.leave(0,8);return
                    self.u.mem_write(out,payload);self.dll_last_error=0;self.leave(1,8);return
                if name=='GetProcessAffinityMask':
                    if self.rd(sp+4)!=0xffffffff:raise ValueError('Unknown isolated process affinity')
                    self.w(self.rd(sp+8),1);self.w(self.rd(sp+12),1);self.leave(1,12);return
                if name=='GetNumaHighestNodeNumber':self.w(self.rd(sp+4),0);self.leave(1,4);return
                if name=='GetSystemInfo':
                    payload=struct.pack('<9I',0,4096,0x10000,0x7ffeffff,1,1,586,65536,6)
                    self.u.mem_write(self.rd(sp+4),payload);self.leave(0,4);return
                if name in ['SetThreadAffinityMask','SetProcessAffinityMask']:
                    handle,mask=self.rd(sp+4),self.rd(sp+8)
                    expected=0xfffffffe if name=='SetThreadAffinityMask' else 0xffffffff
                    if handle!=expected or mask!=1:raise ValueError('Unqualified isolated affinity mutation')
                    self.leave(1,8);return
                if name=='DuplicateHandle':
                    source_proc,source,target_proc,out,access,inherit,options=[self.rd(sp+i) for i in [4,8,12,16,20,24,28]]
                    if source_proc!=0xffffffff or target_proc!=0xffffffff or source!=0xfffffffe or access or inherit or options!=2:
                        raise ValueError('Unqualified isolated current-thread duplication')
                    h=self.next_handle;self.next_handle+=16;self.dll_handles[h]='current_thread';self.w(out,h)
                    self.leave(1,28);return
                if name=='CloseHandle':
                    h=self.rd(sp+4)
                    if h not in self.dll_handles:raise ValueError('Unknown isolated handle close')
                    obj=self.dll_handles[h]
                    if isinstance(obj,dict) and obj['kind']=='find':raise ValueError('Find handle requires FindClose, not CloseHandle')
                    if isinstance(obj,dict) and obj['kind']=='file':obj['stream'].close()
                    del self.dll_handles[h];self.leave(1,4);return
                if name in ['FindFirstFileExW','FindFirstFileExA','FindFirstFileW','FindFirstFileA']:
                    wide=name.endswith('W');logical=self.wstring(self.rd(sp+4)) if wide else self.cstring(self.rd(sp+4))
                    if 'Ex' in name:level,out,search,filter_ptr,flags=[self.rd(sp+i) for i in [8,12,16,20,24]];pop=24
                    else:out=self.rd(sp+8);level=search=filter_ptr=flags=0;pop=8
                    p=pathlib.PureWindowsPath(logical);pattern=p.name
                    if not re.fullmatch('[A-Za-z0-9_.*? -]{1,260}',pattern) or level not in [0,1] or search or filter_ptr or flags&~2:
                        raise ValueError('Unqualified bounded readonly directory search')
                    directory=self.observed_path(str(p.parent));full=str(directory/pattern)
                    buffer=ctypes.create_string_buffer(592 if wide else 320)
                    host=getattr(self.find_kernel,'FindFirstFileEx'+('W' if wide else 'A'))(full if wide else full.encode('ascii'),level,buffer,0,None,flags)
                    self.dll_file_operations.append({'operation':'find_first','pattern':full,'info_level':level,'flags':flags,'current_host_observation':True})
                    if host==ctypes.c_void_p(-1).value:
                        self.dll_last_error=ctypes.get_last_error();self.leave(0xffffffff,pop);return
                    if struct.unpack_from('<I',buffer.raw)[0]&0x400:
                        self.find_kernel.FindClose(host);raise ValueError('Directory-search reparse entry refused')
                    h=self.next_handle;self.next_handle+=16
                    self.dll_handles[h]={'kind':'find','host':host,'wide':wide,'entries':1,'pattern':full}
                    self.u.mem_write(out,buffer.raw)
                    self.dll_file_operations.append({'operation':'find_entry','handle':hex(h),'bytes':len(buffer.raw),'sha256':hashlib.sha256(buffer.raw).hexdigest()})
                    self.dll_last_error=0;self.leave(h,pop);return
                if name in ['FindNextFileW','FindNextFileA']:
                    h,out=self.rd(sp+4),self.rd(sp+8);obj=self.dll_handles.get(h);wide=name.endswith('W')
                    if not isinstance(obj,dict) or obj['kind']!='find' or obj['wide']!=wide or obj['entries']>=8192:
                        raise ValueError('Unqualified directory search identity/encoding/bound')
                    buffer=ctypes.create_string_buffer(592 if wide else 320)
                    value=getattr(self.find_kernel,name)(obj['host'],buffer)
                    if value:
                        if struct.unpack_from('<I',buffer.raw)[0]&0x400:raise ValueError('Directory-search reparse entry refused')
                        obj['entries']+=1;self.u.mem_write(out,buffer.raw)
                        self.dll_file_operations.append({'operation':'find_entry','handle':hex(h),'bytes':len(buffer.raw),'sha256':hashlib.sha256(buffer.raw).hexdigest()})
                    else:self.dll_last_error=ctypes.get_last_error()
                    self.leave(value,8);return
                if name=='FindClose':
                    h=self.rd(sp+4);obj=self.dll_handles.get(h)
                    if not isinstance(obj,dict) or obj['kind']!='find':raise ValueError('Unknown readonly search close')
                    value=self.find_kernel.FindClose(obj['host']);del self.dll_handles[h]
                    self.dll_file_operations.append({'operation':'find_close','handle':hex(h),'entries':obj['entries']})
                    self.leave(value,4);return
                if name in ['CreateFileA','CreateFileW']:
                    pointer,access,share,attrs,creation,flags,template=[self.rd(sp+i) for i in [4,8,12,16,20,24,28]]
                    logical=self.wstring(pointer) if name.endswith('W') else self.cstring(pointer)
                    self.dll_calls[-1]['requested_path']=logical
                    if creation!=3 or access not in [0,0x80000000] or share&~7 or flags&0x04000000 or template:
                        raise ValueError('Non-readonly DLL file open refused before host access')
                    if attrs and (self.rd(attrs)!=12 or self.rd(attrs+4) or self.rd(attrs+8) not in [0,1]):
                        raise ValueError('Unqualified DLL file security/inheritance input')
                    physical=self.observed_path(logical)
                    if any(pathlib.PureWindowsPath(part).is_reserved() for part in physical.parts):
                        raise ValueError('Native device path refused before host access')
                    try:
                        stat=physical.stat()
                        if not physical.is_file():raise ValueError('Only regular readonly DLL files are qualified')
                        if stat.st_size>0x40000000:raise ValueError('DLL source exceeds one-gigabyte bound')
                        digest=hashlib.sha256()
                        with physical.open('rb') as f:
                            for chunk in iter(lambda:f.read(1024*1024),b''):digest.update(chunk)
                        stream=physical.open('rb')
                    except OSError as e:
                        self.dll_last_error=getattr(e,'winerror',None) or 2
                        self.dll_file_operations.append({'operation':'open','path':str(physical),'opened':False,'winerror':self.dll_last_error})
                        self.leave(0xffffffff,28);return
                    h=self.next_handle;self.next_handle+=16
                    self.dll_handles[h]={'kind':'file','stream':stream,'position':0,'bytes':stat.st_size,'physical':physical,'flags':flags}
                    self.dll_file_sources.append({'path':str(physical),'bytes':stat.st_size,'sha256':digest.hexdigest()})
                    self.dll_file_operations.append({'operation':'open','path':str(physical),'opened':True,'handle':hex(h),'flags':flags})
                    self.dll_last_error=0;self.leave(h,28);return
                if name=='GetFullPathNameW':
                    pointer,capacity,out,part=[self.rd(sp+i) for i in [4,8,12,16]]
                    logical=self.wstring(pointer);full=str(self.observed_path(logical));needed=len(full)+1
                    if capacity>32768:raise ValueError('Unqualified full-path capacity')
                    self.dll_file_operations.append({'operation':'full_path','input':logical,'declared_cwd_result':full})
                    if capacity<needed or not out:self.leave(needed,16);return
                    self.u.mem_write(out,(full+'\0').encode('utf-16-le'))
                    if part:self.w(part,out+2*(full.rfind('\\')+1))
                    self.leave(len(full),16);return
                if name=='ReadFile':
                    h,out,count,read_out,overlapped=[self.rd(sp+i) for i in [4,8,12,16,20]];obj=self.dll_handles.get(h)
                    if not isinstance(obj,dict) or obj['kind']!='file' or count>0x100000:
                        raise ValueError('Unqualified bounded readonly DLL read')
                    position=(self.rd(overlapped+8)|(self.rd(overlapped+12)<<32)) if overlapped else obj['position']
                    obj['stream'].seek(position);raw=obj['stream'].read(count)
                    if raw:self.u.mem_write(out,raw)
                    if read_out:self.w(read_out,len(raw))
                    if overlapped:
                        self.w(overlapped,0);self.w(overlapped+4,len(raw));event=self.rd(overlapped+16)
                        if event:
                            target=self.dll_handles.get(event)
                            if not isinstance(target,dict) or target['kind']!='event':raise ValueError('Unknown overlapped-read event')
                            target['signaled']=True
                    else:obj['position']+=len(raw)
                    self.dll_file_operations.append({'operation':'read','handle':hex(h),'offset':position,'requested':count,'bytes':len(raw),'overlapped':bool(overlapped)})
                    self.dll_last_error=0;self.leave(1,20);return
                if name=='SetFilePointerEx':
                    h,low,high,out,origin=[self.rd(sp+i) for i in [4,8,12,16,20]];obj=self.dll_handles.get(h)
                    if not isinstance(obj,dict) or obj['kind']!='file' or origin not in [0,1,2]:raise ValueError('Unknown readonly DLL seek')
                    distance=low|(high<<32)
                    if distance&0x8000000000000000:distance-=1<<64
                    position=([0,obj['position'],obj['bytes']][origin])+distance
                    if not 0<=position<1<<63:raise ValueError('Unqualified readonly DLL seek bounds')
                    obj['position']=position
                    if out:self.u.mem_write(out,struct.pack('<Q',position))
                    self.dll_file_operations.append({'operation':'seek','handle':hex(h),'position':position,'origin':origin})
                    self.leave(1,20);return
                if name=='GetOverlappedResult':
                    h,overlapped,out,wait=[self.rd(sp+i) for i in [4,8,12,16]]
                    if h not in self.dll_handles or self.rd(overlapped) or wait not in [0,1]:raise ValueError('Unqualified overlapped completion state')
                    self.w(out,self.rd(overlapped+4));self.leave(1,16);return
                if name in ['CreateSemaphoreA','CreateSemaphoreW']:
                    attrs,initial,maximum,label=[self.rd(sp+i) for i in [4,8,12,16]]
                    if attrs or label or not 0<maximum<=0x7fffffff or initial>maximum:
                        raise ValueError('Unqualified isolated unnamed semaphore')
                    h=self.next_handle;self.next_handle+=16
                    self.dll_handles[h]={'kind':'semaphore','count':initial,'maximum':maximum}
                    self.leave(h,16);return
                if name=='ReleaseSemaphore':
                    h,count,out=[self.rd(sp+i) for i in [4,8,12]];obj=self.dll_handles.get(h)
                    if not isinstance(obj,dict) or obj['kind']!='semaphore' or not count or count+obj['count']>obj['maximum']:
                        raise ValueError('Unqualified isolated semaphore release')
                    if out:self.w(out,obj['count'])
                    obj['count']+=count;self.leave(1,12);return
                if name in ['CreateEventA','CreateEventW']:
                    attrs,manual,initial,label=[self.rd(sp+i) for i in [4,8,12,16]]
                    if attrs or label or manual not in [0,1] or initial not in [0,1]:raise ValueError('Unqualified isolated unnamed event')
                    h=self.next_handle;self.next_handle+=16
                    self.dll_handles[h]={'kind':'event','manual':bool(manual),'signaled':bool(initial)}
                    self.leave(h,16);return
                if name in ['SetEvent','ResetEvent']:
                    obj=self.dll_handles.get(self.rd(sp+4))
                    if not isinstance(obj,dict) or obj['kind']!='event':raise ValueError('Unknown isolated event')
                    obj['signaled']=name=='SetEvent';self.leave(1,4);return
                if name in ['WaitForSingleObject','WaitForSingleObjectEx']:
                    h,timeout=self.rd(sp+4),self.rd(sp+8);obj=self.dll_handles.get(h)
                    if name.endswith('Ex') and self.rd(sp+12):raise ValueError('Alertable isolated waits unqualified')
                    if not isinstance(obj,dict):raise ValueError('Unknown isolated wait object')
                    ready=obj['count']>0 if obj['kind']=='semaphore' else obj['signaled']
                    if ready:
                        if obj['kind']=='semaphore':obj['count']-=1
                        elif not obj['manual']:obj['signaled']=False
                        self.leave(0,12 if name.endswith('Ex') else 8);return
                    if timeout==0:self.leave(258,12 if name.endswith('Ex') else 8);return
                    raise ValueError('Isolated wait requires an unscheduled producer; no success invented')
                if name=='InitializeSListHead':
                    p=self.rd(sp+4)
                    if p%8:raise ValueError('Unaligned isolated SList head')
                    self.u.mem_write(p,bytes(8));self.slist_heads.add(p);self.leave(0,4);return
                if name in ['QueryPerformanceCounter','QueryPerformanceFrequency','GetSystemTimeAsFileTime']:
                    self.u.mem_write(self.rd(sp+4),struct.pack('<Q',10000000 if name=='QueryPerformanceFrequency' else 1))
                    self.leave(1,4);return
                if name in ['GetModuleHandleW','GetModuleHandleA','LoadLibraryW','LoadLibraryA']:
                    p=self.rd(sp+4);text=(self.wstring(p) if name.endswith('W') else self.cstring(p)) if p else None
                    if text is None:value=self.base
                    elif text.casefold() in ['kernel32','kernel32.dll']:value=0x70000000
                    elif text.casefold() in ['advapi32','advapi32.dll']:value=0x70000100
                    elif text.casefold()=='riotradsio.dll':value=self.dll_base
                    else:raise ValueError('Unqualified declared module lookup: '+str(text))
                    self.leave(value,4);return
                if name=='GetProcAddress':
                    module,symbol=self.rd(sp+4),self.cstring(self.rd(sp+8))
                    if module not in [0x70000000,0x70000100]:raise ValueError('Unknown declared API module')
                    marker=next((k for k,v in self.dll_import_markers.items() if v[1]==symbol),None)
                    if marker is None:
                        if not re.fullmatch('[A-Za-z0-9_]{1,96}',symbol):raise ValueError('Unqualified dynamic API name')
                        marker=self.work+0x5e000+0x10*len([v for v in self.dll_import_markers.values() if v[2] is None])
                        if marker>=self.work+0x5f000:raise ValueError('Bounded dynamic API guards exhausted')
                        self.dll_import_markers[marker]=('DECLARED_KERNEL32_DYNAMIC' if module==0x70000000 else 'DECLARED_ADVAPI32_DYNAMIC',symbol,None)
                        self.dll_calls.append({'declared_dynamic_guard':symbol,
                            'OS_availability_qualified':False,'unsupported_invocation_will_refuse':True})
                    self.leave(marker,8);return
                if name=='EventRegister':
                    guid,callback,context,out=[self.rd(sp+i) for i in [4,8,12,16]]
                    h=0x170000000+len(self.event_registrations)+1
                    self.event_registrations[h]={'guid_hex':bytes(self.u.mem_read(guid,16)).hex(),
                        'callback':hex(callback),'context':hex(context),'enabled':False,'host_registration':False}
                    self.u.mem_write(out,struct.pack('<Q',h));self.leave(0,16);return
                if name=='EventUnregister':
                    h=self.rd(sp+4)|(self.rd(sp+8)<<32)
                    if h not in self.event_registrations:raise ValueError('Unknown isolated trace registration')
                    del self.event_registrations[h];self.leave(0,8);return
                if name=='FreeLibrary':
                    if self.rd(sp+4) not in [0x70000000,0x70000100]:raise ValueError('Unknown virtual module release')
                    self.leave(1,4);return
                if name in ['TlsAlloc','FlsAlloc']:
                    index=self.next_tls;self.next_tls+=1;self.dll_tls[index]=0
                    self.leave(index,4 if name=='FlsAlloc' else 0);return
                if name in ['TlsFree','FlsFree','TlsGetValue','FlsGetValue','TlsSetValue','FlsSetValue']:
                    index=self.rd(sp+4)
                    if index not in self.dll_tls:raise ValueError('Unallocated isolated DLL TLS index')
                    if name.endswith('GetValue'):value=self.dll_tls[index];pop=4;self.dll_last_error=0
                    elif name.endswith('SetValue'):self.dll_tls[index]=self.rd(sp+8);value=1;pop=8
                    else:del self.dll_tls[index];value=1;pop=4
                    self.leave(value,pop);return
                if name=='GetLastError':self.leave(self.dll_last_error);return
                if name=='SetLastError':self.dll_last_error=self.rd(sp+4);self.leave(0,4);return
                if name=='GetCommandLineA':
                    p=self.work+0x5f100;self.u.mem_write(p,('"'+str(self.game_path)+'"\0').encode('ascii'))
                    self.leave(p);return
                if name=='GetEnvironmentStringsW':
                    p=self.work+0x5fa00;self.u.mem_write(p,b'\0'*4);self.leave(p);return
                if name=='FreeEnvironmentStringsW':
                    if self.rd(sp+4)!=self.work+0x5fa00:raise ValueError('Unknown isolated environment block')
                    self.leave(1,4);return
                if name=='GetStartupInfoW':
                    self.u.mem_write(self.rd(sp+4),struct.pack('<I',68)+bytes(64));self.leave(0,4);return
                if name=='GetStdHandle':
                    if self.rd(sp+4) not in [0xfffffff4,0xfffffff5,0xfffffff6]:raise ValueError('Unknown isolated standard stream')
                    self.leave(0,4);return
                if name=='GetFileType':
                    h=self.rd(sp+4);obj=self.dll_handles.get(h)
                    if h==0:value=0
                    elif isinstance(obj,dict) and obj['kind']=='file':value=1
                    else:raise ValueError('Unqualified isolated stream handle')
                    self.dll_last_error=0;self.leave(value,4);return
                if name in ['GetModuleFileNameW','GetModuleFileNameA']:
                    module,out,capacity=[self.rd(sp+i) for i in [4,8,12]]
                    if module not in [0,self.base,self.dll_base]:raise ValueError('Unknown declared module')
                    text=str(self.dll_path if module==self.dll_base else self.game_path)
                    if len(text)+1>capacity:raise ValueError('Declared module path exceeds caller capacity')
                    wide=name.endswith('W');raw=(text+'\0').encode('utf-16-le' if wide else 'ascii')
                    self.u.mem_write(out,raw);self.leave(len(text),12);return
                if name in ['GetCurrentDirectoryA','GetCurrentThreadId','GetFileAttributesA']:
                    wanted={'GetCurrentDirectoryA':'cwd','GetCurrentThreadId':'thread','GetFileAttributesA':'attributes'}[name]
                    marker=next(k for k,v in self.markers.items() if v==wanted)
                    return super().hook(uc,marker,size,unused)
                if name in ['InitializeCriticalSection','InitializeCriticalSectionAndSpinCount','InitializeCriticalSectionEx']:
                    ptr=self.rd(sp+4);spin=self.rd(sp+8) if name!='InitializeCriticalSection' else 0
                    if ptr in self.dll_critical_sections:raise ValueError('Repeated isolated critical section initialization')
                    if name=='InitializeCriticalSectionEx' and self.rd(sp+12) not in [0,0x1000000]:
                        raise ValueError('Unqualified critical section flags')
                    self.u.mem_write(ptr,struct.pack('<6I',0,0xffffffff,0,0,0,spin))
                    self.dll_critical_sections[ptr]=0
                    self.leave(1,{'InitializeCriticalSection':4,'InitializeCriticalSectionAndSpinCount':8,'InitializeCriticalSectionEx':12}[name]);return
                if name in ['EnterCriticalSection','LeaveCriticalSection','DeleteCriticalSection']:
                    ptr=self.rd(sp+4)
                    if ptr not in self.dll_critical_sections:raise ValueError('Uninitialized isolated critical section')
                    depth=self.dll_critical_sections[ptr]
                    if name=='EnterCriticalSection':self.dll_critical_sections[ptr]=depth+1
                    elif name=='LeaveCriticalSection':
                        if not depth:raise ValueError('Unbalanced isolated critical section release')
                        self.dll_critical_sections[ptr]=depth-1
                    else:
                        if depth:raise ValueError('Deleting held isolated critical section')
                        del self.dll_critical_sections[ptr]
                    self.leave(0,4);return
                if name=='GetProcessHeap':self.leave(1);return
                if name=='GetACP':self.leave(1252);return
                if name in ['MultiByteToWideChar','WideCharToMultiByte']:
                    codepage,flags,source,count,out,capacity=[self.rd(sp+i) for i in [4,8,12,16,20,24]]
                    if codepage not in [0,1252,65001] or flags not in [0,8] or count==0 or count>0x10000 and count!=0xffffffff:
                        raise ValueError('Unqualified declared ASCII codepage conversion')
                    if name=='MultiByteToWideChar':
                        raw=(self.cstring(source)+'\0').encode('ascii') if count==0xffffffff else bytes(self.u.mem_read(source,count))
                        text=raw.decode('ascii');encoded=text.encode('utf-16-le');needed=len(text);pop=24
                    else:
                        if count==0xffffffff:
                            raw=bytearray()
                            for i in range(4096):
                                pair=bytes(self.u.mem_read(source+2*i,2));raw.extend(pair)
                                if pair==b'\0\0':break
                            else:raise ValueError('Unbounded declared wide string')
                        else:raw=bytes(self.u.mem_read(source,count*2))
                        text=raw.decode('utf-16-le');encoded=text.encode('ascii');needed=len(encoded);pop=32
                        default_char,used_default=self.rd(sp+28),self.rd(sp+32)
                        if default_char:raise ValueError('Unqualified lossy conversion fallback')
                        if used_default:self.w(used_default,0)
                    if out and capacity:
                        if needed>capacity:raise ValueError('Declared conversion output too small')
                        self.u.mem_write(out,encoded)
                    self.leave(needed,pop);return
                if name=='HeapAlloc':
                    heap,flags,count=[self.rd(sp+i) for i in [4,8,12]]
                    if heap!=1 or flags&~8 or not 0<count<0x200000:
                        raise ValueError('Unqualified DLL heap allocation')
                    p=self.dll_heap;self.dll_heap+=(count+15)&~15
                    if self.dll_heap>=0x52000000:raise ValueError('Bounded DLL arena exhausted')
                    self.u.mem_write(p,bytes(count));self.dll_allocations[p]=count
                    self.leave(p,12);return
                if name=='HeapFree':
                    heap,flags,p=[self.rd(sp+i) for i in [4,8,12]]
                    if heap!=1 or flags or p not in self.dll_allocations:raise ValueError('Unqualified DLL heap free')
                    del self.dll_allocations[p]
                    self.leave(1,12);return
                if name in ['HeapSize','HeapReAlloc']:
                    heap,flags,p=[self.rd(sp+i) for i in [4,8,12]]
                    if heap!=1 or p not in self.dll_allocations or flags&~8:
                        raise ValueError('Unqualified DLL heap size/reallocation')
                    old=self.dll_allocations[p]
                    if name=='HeapSize':self.leave(old,12);return
                    count=self.rd(sp+16)
                    if not 0<count<0x200000:raise ValueError('Unqualified DLL heap resize bound')
                    q=self.dll_heap;self.dll_heap+=(count+15)&~15
                    if self.dll_heap>=0x52000000:raise ValueError('Bounded DLL arena exhausted')
                    self.u.mem_write(q,bytes(count));self.u.mem_write(q,bytes(self.u.mem_read(p,min(old,count))))
                    self.dll_allocations[q]=count;del self.dll_allocations[p]
                    self.leave(q,16);return
                raise ValueError('Unqualified DLL import '+lib+'!'+str(name))
        super().hook(uc,address,size,unused)

    def parse_game_version(self,text):
        if not isinstance(text,str) or not text.isascii() or '\0' in text or len(text)>31:
            raise ValueError('Explicit bounded version text required')
        self.u.mem_write(self.work+0x3a00,text.encode()+b'\0')
        self.u.mem_write(self.work+0x3b00,b'\xff'*8)
        value=self.invoke(0x995260,ecx=self.work+0x3a00,edx=self.work+0x3b00)
        return {'input':text,'accepted':bool(value&255),'words':[self.rd(self.work+0x3b00),self.rd(self.work+0x3b04)]}

    def attach_dll(self):
        value=self.invoke(self.dll_base+self.dll_pe.OPTIONAL_HEADER.AddressOfEntryPoint,[self.dll_base,1,0])
        if value!=1:raise ValueError('Original DLL entry point refused isolated runtime')
        self.dll_attached=True
        return {'return_value':value,'entry':hex(self.dll_base+self.dll_pe.OPTIONAL_HEADER.AddressOfEntryPoint),
            'isolated_declared_loader_and_runtime':True,'historical_host_loader_qualified':False}

    def close_read_handles(self):
        count=0
        for obj in self.dll_handles.values():
            if isinstance(obj,dict) and obj['kind']=='file' and not obj['stream'].closed:
                obj['stream'].close();count+=1
            elif isinstance(obj,dict) and obj['kind']=='find' and obj['host'] is not None:
                self.find_kernel.FindClose(obj['host']);obj['host']=None;count+=1
        return count
