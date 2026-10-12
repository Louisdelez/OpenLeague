"""x86 Unicorn CRT ABI bridge to real Windows process/TLS/FLS services.

32-bit native labels identify 64-bit host objects; native pointers never execute
as host callbacks. FLS destruction queues the real native callback for execution
after the emulator's outer call has stopped. Unknown APIs remain boundaries.
"""
from pathlib import Path
import ctypes,struct,hashlib
from ctypes import wintypes as w
from isolated_io import K,sig,Rejected,INVALID
P=ctypes.c_void_p
sig('GetModuleHandleW',[w.LPCWSTR],w.HMODULE)
sig('GetProcAddress',[w.HMODULE,ctypes.c_char_p],P)
sig('GetProcessHeap',[],w.HANDLE)
sig('HeapAlloc',[w.HANDLE,w.DWORD,ctypes.c_size_t],P)
sig('HeapFree',[w.HANDLE,w.DWORD,P],w.BOOL)
sig('HeapSize',[w.HANDLE,w.DWORD,P],ctypes.c_size_t)
sig('GetCurrentThreadId',[],w.DWORD)
sig('GetCurrentProcessId',[],w.DWORD)
sig('GetCurrentThread',[],w.HANDLE)
sig('GetThreadTimes',[w.HANDLE,P,P,P,P],w.BOOL)
sig('QueryPerformanceCounter',[ctypes.POINTER(ctypes.c_longlong)],w.BOOL)
sig('GetACP',[],w.UINT)
sig('IsProcessorFeaturePresent',[w.DWORD],w.BOOL)
sig('IsValidCodePage',[w.UINT],w.BOOL)
class CPInfo(ctypes.Structure):
    _fields_=[('MaxCharSize',w.UINT),('DefaultChar',w.BYTE*2),('LeadByte',w.BYTE*12)]
assert ctypes.sizeof(CPInfo)==20
sig('GetCPInfo',[w.UINT,ctypes.POINTER(CPInfo)],w.BOOL)
sig('GetStringTypeW',[w.DWORD,P,ctypes.c_int,P],w.BOOL)
sig('LCMapStringEx',[w.LPCWSTR,w.DWORD,P,ctypes.c_int,P,ctypes.c_int,P,P,ctypes.c_ssize_t],ctypes.c_int)
sig('EncodePointer',[P],P);sig('DecodePointer',[P],P)
sig('TlsAlloc',[],w.DWORD);sig('TlsFree',[w.DWORD],w.BOOL)
sig('TlsGetValue',[w.DWORD],P);sig('TlsSetValue',[w.DWORD,P],w.BOOL)
CALLBACK=ctypes.WINFUNCTYPE(None,P)
sig('FlsAlloc',[CALLBACK],w.DWORD);sig('FlsFree',[w.DWORD],w.BOOL)
sig('FlsGetValue',[w.DWORD],P);sig('FlsSetValue',[w.DWORD,P],w.BOOL)
sig('InitializeCriticalSectionAndSpinCount',[P,w.DWORD],w.BOOL)
sig('InitializeCriticalSectionEx',[P,w.DWORD,w.DWORD],w.BOOL)
sig('InitializeCriticalSection',[P],None)
for name in ['DeleteCriticalSection','EnterCriticalSection','LeaveCriticalSection']:sig(name,[P],None)
sig('GetStdHandle',[w.DWORD],w.HANDLE);sig('GetFileType',[w.HANDLE],w.DWORD)
sig('GetConsoleMode',[w.HANDLE,ctypes.POINTER(w.DWORD)],w.BOOL)
sig('OutputDebugStringA',[ctypes.c_char_p],None)
sig('GetCurrentPackageId',[ctypes.POINTER(w.DWORD),P],ctypes.c_long)
sig('AreFileApisANSI',[],w.BOOL)
sig('GetLocalTime',[P],None);sig('GetSystemTime',[P],None)
sig('GetSystemTimeAsFileTime',[P],None)
sig('MultiByteToWideChar',[w.UINT,w.DWORD,P,ctypes.c_int,P,ctypes.c_int],ctypes.c_int)
sig('WideCharToMultiByte',[w.UINT,w.DWORD,P,ctypes.c_int,P,ctypes.c_int,P,ctypes.POINTER(w.BOOL)],ctypes.c_int)
class StartupInfo(ctypes.Structure):
    _fields_=[('cb',w.DWORD),('reserved',P),('desktop',P),('title',P),('x',w.DWORD),('y',w.DWORD),
        ('xsize',w.DWORD),('ysize',w.DWORD),('xchars',w.DWORD),('ychars',w.DWORD),('fill',w.DWORD),
        ('flags',w.DWORD),('show',w.WORD),('reserved_bytes',w.WORD),('reserved_data',P),
        ('stdin',w.HANDLE),('stdout',w.HANDLE),('stderr',w.HANDLE)]
sig('GetStartupInfoA',[ctypes.POINTER(StartupInfo)],None)
sig('GetStartupInfoW',[ctypes.POINTER(StartupInfo)],None)

class CrtOs:
    def __init__(self,machine,io):
        self.m=machine;self.io=io;self.events=[];self.modules={};self.exports={};self.actual_exports={}
        self.encoded={};self.next_encoded=0x5a000000;self.next_export=0x3e000000
        self.heap=K.GetProcessHeap();self.heap_label=0x71000000;self.heap_blocks={};self.heap_sizes={};self.unadopted_heap_blocks={};self.locks={};self.lock_depth={}
        self.slots={};self.callback_refs=[];self.pending=[];self.stdio={};self.next_stdio=0x70001000
        self.closed=False
        self.borrowed_cursor=0x3d000000;self.m['u'].mem_map(self.borrowed_cursor,0x10000)
    def borrowed_bytes(self,b):
        p=self.borrowed_cursor;self.borrowed_cursor+=(len(b)+15)&~15
        if self.borrowed_cursor>0x3d010000:raise Rejected('OS borrowed buffer exhausted')
        self.m['u'].mem_write(p,b);return p
    def strz(self,p,wide=False):
        if not p:return None
        out=bytearray();width=2 if wide else 1
        for j in range(32768):
            b=bytes(self.m['u'].mem_read(p+j*width,width))
            if b==bytes(width):return out.decode('utf-16le' if wide else 'ascii')
            out.extend(b)
        raise Rejected('unbounded CRT string')
    def event(self,name,result,**kw):
        self.io.last_error=ctypes.get_last_error();self.events.append(dict(api=name,result=result,last_error=self.io.last_error,**kw))
    def label_stdio(self,h):
        if h in (None,INVALID):return 0 if h is None else 0xffffffff
        for label,known in self.stdio.items():
            if known==h:return label
        label=self.next_stdio;self.next_stdio+=4;self.stdio[label]=h;return label
    def heap_free(self,p):
        raw=self.heap_blocks[p];ok=K.HeapFree(self.heap,0,raw)
        if not ok:raise ctypes.WinError(ctypes.get_last_error())
        del self.heap_blocks[p]
        self.heap_sizes.pop(p,None)
        self.m['release'](p);self.event('HeapFree',int(bool(ok)),pointer=p)
    def dispatch(self,name):
        m=self.m;u=m['u'];sp=u.reg_read(m['UC_X86_REG_ESP']);arg=lambda i:m['read32'](sp+4*i)
        done=m['finish'];put=m['write32']
        ctypes.set_last_error(self.io.last_error)
        if name in ('EncodePointer','DecodePointer'):
            value=arg(1)
            if name=='EncodePointer':
                actual=K.EncodePointer(value)
                label=next((k for k,v in self.encoded.items() if v==actual),None)
                if label is None:label=self.next_encoded;self.next_encoded+=4;self.encoded[label]=actual
                result=label
            else:
                if value not in self.encoded:raise Rejected('unknown encoded pointer label')
                result=K.DecodePointer(self.encoded[value]) or 0
                if result>0xffffffff:raise Rejected('decoded pointer outside x86')
            self.event(name,result,input=value);done(result,4);return True
        if name=='GetModuleHandleW':
            value=self.strz(arg(1),True)
            if value is None or value.lower()!='kernel32.dll':raise Rejected('unknown native module')
            actual=K.GetModuleHandleW(value)
            label=0x71001000 if actual else 0
            if actual:self.modules[label]=actual
            self.event(name,label,module=value);done(label,4);return True
        if name=='GetProcAddress':
            module,value=arg(1),self.strz(arg(2))
            if module not in self.modules:raise Rejected('unknown module label')
            actual=K.GetProcAddress(self.modules[module],value.encode())
            if not actual:label=0
            elif (module,value) in self.exports:label=self.exports[(module,value)]
            else:
                label=self.next_export;self.next_export+=16;self.exports[(module,value)]=label;self.actual_exports[(module,value)]=actual
                m['imports'][label]={'dll':'kernel32.dll','name':value,'resolved_export':True}
            self.event(name,label,module=module,export=value,available=bool(actual));done(label,8);return True
        if name=='GetProcessHeap':self.event(name,self.heap_label);done(self.heap_label);return True
        if name=='HeapAlloc':
            heap,flags,n=arg(1),arg(2),arg(3)
            if heap!=self.heap_label or flags not in (0,8) or not 0<n<0x100000:raise Rejected('unqualified HeapAlloc request')
            raw=K.HeapAlloc(self.heap,flags,n)
            p=0
            if raw:
                # Track raw ownership before the fallible emulated allocation.
                # An exception leaves the raw block for host cleanup/retry.
                self.unadopted_heap_blocks[raw]=n
                p=m['allocate'](n)
                self.heap_sizes[p]=n
                self.heap_blocks[p]=raw
                del self.unadopted_heap_blocks[raw]
                # Native reads host allocation's actual initial bytes, not invented zero state.
                u.mem_write(p,ctypes.string_at(raw,n))
            self.event(name,p,size=n,flags=flags);done(p,12);return True
        if name=='HeapSize':
            heap,flags,p=arg(1),arg(2),arg(3)
            if heap!=self.heap_label or flags or p not in self.heap_blocks or p not in self.heap_sizes:
                raise Rejected('HeapSize requires exact owned process-heap allocation base')
            actual_size=K.HeapSize(self.heap,0,self.heap_blocks[p]);failed=actual_size==ctypes.c_size_t(-1).value
            result=0xffffffff if failed else actual_size
            self.event(name,result,pointer=p,mirror_capacity=self.heap_sizes[p])
            if not failed and actual_size>self.heap_sizes[p]:raise Rejected('HeapSize exceeds qualified guest mirror capacity')
            done(result,12);return True
        if name=='HeapFree':
            heap,flags,p=arg(1),arg(2),arg(3)
            if heap!=self.heap_label or flags or p not in self.heap_blocks:raise Rejected('unowned HeapFree')
            self.heap_free(p);done(1,12);return True
        if name in ('FlsAlloc','TlsAlloc'):
            callback=arg(1) if name=='FlsAlloc' else 0
            wrapper=None
            if name=='FlsAlloc':
                if callback:
                    def invoked(value,native=callback):
                        self.pending.append({'callback':native,'value':int(value or 0),'reason':'actual Windows FLS callback'})
                    wrapper=CALLBACK(invoked);self.callback_refs.append(wrapper)
                else:wrapper=CALLBACK() # Actual null callback remains null.
                index=K.FlsAlloc(wrapper)
            else:index=K.TlsAlloc()
            if index!=0xffffffff:
                key=(name[:3],index)
                if key in self.slots:raise Rejected('OS returned duplicate live slot in same namespace')
                self.slots[key]={'kind':name[:3],'callback':callback,'wrapper':wrapper}
            self.event(name,index,callback=callback);done(index,4 if name=='FlsAlloc' else 0);return True
        if name in ('FlsGetValue','TlsGetValue','FlsSetValue','TlsSetValue','FlsFree','TlsFree'):
            index=arg(1)
            key=(name[:3],index)
            if key not in self.slots:raise Rejected('unknown native slot')
            if name.endswith('GetValue'):result=getattr(K,name)(index) or 0;pop=4
            elif name.endswith('SetValue'):result=int(bool(getattr(K,name)(index,arg(2))));pop=8
            else:
                result=int(bool(getattr(K,name)(index)));pop=4
                if result:del self.slots[key]
            self.event(name,result,index=index,value=arg(2) if pop==8 else None)
            if self.pending:
                # Outer runner must execute the queued native destructor before
                # completing this emulated OS call, preserving call order.
                self.pending_return=(result,pop);u.emu_stop();return True
            done(result,pop);return True
        if name=='GetCurrentThreadId':result=K.GetCurrentThreadId();self.event(name,result);done(result);return True
        if name=='GetCurrentProcessId':result=K.GetCurrentProcessId();self.event(name,result);done(result);return True
        if name=='GetCurrentThread':
            actual=K.GetCurrentThread()
            if actual!=ctypes.c_void_p(-2).value:raise Rejected('unexpected current-thread pseudo handle')
            self.event(name,0xfffffffe,borrowed_pseudo_handle=True);done(0xfffffffe);return True
        if name=='GetThreadTimes':
            handle=arg(1);addresses=[arg(i) for i in range(2,6)]
            if handle!=0xfffffffe or not all(addresses):raise Rejected('GetThreadTimes only current-thread pseudo handle and nonnull outputs')
            low=min(addresses);high=max(addresses)+8
            if high>0x100000000 or high-low>4096:raise Rejected('GetThreadTimes output span exceeds qualified bound')
            before=bytes(u.mem_read(low,high-low));buffer=ctypes.create_string_buffer(before,len(before))
            outputs=[ctypes.byref(buffer,p-low) for p in addresses]
            result=K.GetThreadTimes(K.GetCurrentThread(),*outputs);error=ctypes.get_last_error()
            u.mem_write(low,bytes(buffer));ctypes.set_last_error(error)
            self.event(name,result,handle=handle,outputs=addresses,span=high-low,output_hex=bytes(buffer).hex());done(result,20);return True
        if name=='GetACP':result=K.GetACP();self.event(name,result);done(result);return True
        if name=='IsProcessorFeaturePresent':
            feature=arg(1)
            if feature!=10:raise Rejected('processor feature profile only qualifies actual SSE2 query10')
            result=K.IsProcessorFeaturePresent(feature);self.event(name,result,feature=feature);done(result,4);return True
        if name=='IsValidCodePage':
            cp=arg(1);result=K.IsValidCodePage(cp);self.event(name,result,codepage=cp);done(result,4);return True
        if name=='GetCPInfo':
            cp,target=arg(1),arg(2)
            if not target:raise Rejected('GetCPInfo null output is outside qualified profile')
            before=bytes(u.mem_read(target,20));info=CPInfo.from_buffer_copy(before)
            result=K.GetCPInfo(cp,ctypes.byref(info));error=ctypes.get_last_error()
            after=bytes(info);u.mem_write(target,after);ctypes.set_last_error(error)
            self.event(name,result,codepage=cp,before=before.hex(),after=after.hex());done(result,8);return True
        if name=='GetStringTypeW':
            kind,source,count,target=[arg(i) for i in range(1,5)]
            if not source or not target or not 0<count<=32768:raise Rejected('GetStringTypeW requires bounded explicit positive length')
            size=count*2
            if max(source,target)<min(source+size,target+size):raise Rejected('GetStringTypeW overlap is outside qualified profile')
            raw=bytes(u.mem_read(source,size));before=bytes(u.mem_read(target,size))
            src=ctypes.create_string_buffer(raw,size);dest=ctypes.create_string_buffer(before,size)
            result=K.GetStringTypeW(kind,src,count,dest);error=ctypes.get_last_error()
            u.mem_write(target,bytes(dest));ctypes.set_last_error(error)
            self.event(name,result,kind=kind,count=count,source_sha256=hashlib.sha256(raw).hexdigest(),output_sha256=hashlib.sha256(bytes(dest)).hexdigest());done(result,16);return True
        if name=='LCMapStringEx':
            locale,flags,source,count,target,capacity,version,reserved,sort=[arg(i) for i in range(1,10)]
            if flags not in (0x100,0x200) or version or reserved or sort:
                raise Rejected('LCMapStringEx supports only ordinary casing with null optional arguments')
            if not source or not 0<count<=32768 or capacity>32768 or (capacity and not target):
                raise Rejected('LCMapStringEx requires bounded explicit lengths')
            localename=None
            if locale:
                name_bytes=bytearray()
                for i in range(85):
                    word=bytes(u.mem_read(locale+2*i,2))
                    if word==b'\0\0':break
                    name_bytes.extend(word)
                else:raise Rejected('LCMapStringEx locale exceeds85WCHAR bound')
                localename=name_bytes.decode('utf-16le')
            if capacity and max(source,target)<min(source+count*2,target+capacity*2):
                raise Rejected('LCMapStringEx overlap is outside qualified profile')
            raw=bytes(u.mem_read(source,count*2));src=ctypes.create_string_buffer(raw,len(raw))
            before=bytes(u.mem_read(target,capacity*2)) if capacity else None
            dest=ctypes.create_string_buffer(before,len(before)) if capacity else None
            result=K.LCMapStringEx(localename,flags,src,count,dest,capacity,None,None,0);error=ctypes.get_last_error()
            # Failure can leave partial output: preserve every bounded byte.
            if dest is not None:u.mem_write(target,bytes(dest))
            ctypes.set_last_error(error)
            self.event(name,result,locale=localename,flags=flags,count=count,capacity=capacity,
                source_sha256=hashlib.sha256(raw).hexdigest(),output_sha256=hashlib.sha256(bytes(dest)).hexdigest() if dest is not None else None)
            done(result,36);return True
        if name=='QueryPerformanceCounter':
            value=ctypes.c_longlong();result=K.QueryPerformanceCounter(ctypes.byref(value))
            if result:u.mem_write(arg(1),struct.pack('<q',value.value))
            self.event(name,int(bool(result)),counter=value.value if result else None);done(int(bool(result)),4);return True
        if name=='AreFileApisANSI':result=K.AreFileApisANSI();self.event(name,result);done(result);return True
        if name in ('GetLocalTime','GetSystemTime','GetSystemTimeAsFileTime'):
            size=8 if name.endswith('FileTime') else 16;value=ctypes.create_string_buffer(size)
            getattr(K,name)(value);u.mem_write(arg(1),value.raw);self.event(name,None,observed_bytes=value.raw.hex());done(None,4);return True
        if name=='MultiByteToWideChar':
            codepage,flags,p,count,out,capacity=[arg(i) for i in range(1,7)]
            count=ctypes.c_int32(count).value
            if not -1<=count<=0x10000 or capacity>0x10000:raise Rejected('unqualified multibyte conversion size')
            if count==-1:
                source=bytearray()
                for j in range(0x10000):
                    v=bytes(u.mem_read(p+j,1));source.extend(v)
                    if v==b'\0':break
                else:raise Rejected('unterminated multibyte input')
                source=bytes(source)
            else:source=bytes(u.mem_read(p,count))
            data=ctypes.create_string_buffer(source);dest=ctypes.create_string_buffer(capacity*2) if out else None
            result=K.MultiByteToWideChar(codepage,flags,data,count,dest,capacity);error=ctypes.get_last_error()
            if result and dest is not None:u.mem_write(out,dest.raw[:result*2])
            ctypes.set_last_error(error);self.event(name,result,codepage=codepage,flags=flags,count=count,capacity=capacity);done(result,24);return True
        if name=='WideCharToMultiByte':
            codepage,flags,p,count,out,capacity,default,used=[arg(i) for i in range(1,9)]
            count=ctypes.c_int32(count).value
            if not -1<=count<=0x10000 or capacity>0x10000:raise Rejected('unqualified wide conversion size')
            source=((self.strz(p,True)+'\0').encode('utf-16le') if count==-1 else bytes(u.mem_read(p,count*2)))
            data=ctypes.create_string_buffer(source);dest=ctypes.create_string_buffer(capacity) if out else None
            fallback=ctypes.create_string_buffer(bytes(u.mem_read(default,2))) if default else None;used_value=w.BOOL()
            result=K.WideCharToMultiByte(codepage,flags,data,count,dest,capacity,fallback,ctypes.byref(used_value) if used else None);error=ctypes.get_last_error()
            if result and dest is not None:u.mem_write(out,dest.raw[:result])
            if used:put(used,int(bool(used_value.value)))
            ctypes.set_last_error(error);self.event(name,result,codepage=codepage,flags=flags,count=count,capacity=capacity);done(result,32);return True
        if name=='GetCurrentPackageId':
            size=w.DWORD(m['read32'](arg(1)));capacity=size.value
            if capacity>0x10000:raise Rejected('package identity buffer too large')
            data=ctypes.create_string_buffer(capacity) if arg(2) else None
            result=K.GetCurrentPackageId(ctypes.byref(size),data);error=ctypes.get_last_error();put(arg(1),size.value)
            if result==0 and data is not None:
                if size.value>capacity:raise Rejected('package identity size exceeds capacity')
                u.mem_write(arg(2),data.raw[:size.value])
            ctypes.set_last_error(error);self.event(name,result,capacity=capacity,required=size.value);done(result&0xffffffff,8);return True
        if name=='GetLastError':done(self.io.last_error);return True
        if name=='SetLastError':self.io.last_error=arg(1);ctypes.set_last_error(arg(1));done(None,4);return True
        if name.startswith('InitializeCriticalSection'):
            p=arg(1)
            if p in self.locks:raise Rejected('critical section initialized twice')
            storage=ctypes.create_string_buffer(40)
            if name=='InitializeCriticalSectionEx':result=K.InitializeCriticalSectionEx(storage,arg(2),arg(3));pop=12
            elif name=='InitializeCriticalSectionAndSpinCount':result=K.InitializeCriticalSectionAndSpinCount(storage,arg(2));pop=8
            else:K.InitializeCriticalSection(storage);result=1;pop=4
            if result:self.locks[p]=storage;self.lock_depth[p]=0;u.mem_write(p,bytes(24))
            self.event(name,int(bool(result)),reference=p,abi='host40-byte CS object; native24-byte opaque storage')
            done(None if name=='InitializeCriticalSection' else int(bool(result)),pop);return True
        if name in ('EnterCriticalSection','LeaveCriticalSection','DeleteCriticalSection'):
            p=arg(1)
            if p not in self.locks:raise Rejected('unknown critical section')
            if name=='LeaveCriticalSection' and self.lock_depth[p]<=0:raise Rejected('leave unowned critical section')
            if name=='DeleteCriticalSection' and self.lock_depth[p]!=0:raise Rejected('delete owned critical section')
            getattr(K,name)(self.locks[p]);self.event(name,None,reference=p)
            if name=='EnterCriticalSection':self.lock_depth[p]+=1
            if name=='LeaveCriticalSection':self.lock_depth[p]-=1
            if name=='DeleteCriticalSection':del self.locks[p];del self.lock_depth[p]
            done(None,4);return True
        if name in ('GetStartupInfoA','GetStartupInfoW'):
            s=StartupInfo();getattr(K,name)(ctypes.byref(s))
            if s.reserved_bytes or s.reserved_data:raise Rejected('inherited low-IO table requires explicit x64-to-x86 handle translation')
            strings=[]
            for pointer in [s.reserved,s.desktop,s.title]:
                data=((ctypes.wstring_at(pointer)+'\0').encode('utf-16le') if name.endswith('W') else ctypes.string_at(pointer)+b'\0') if pointer else None
                strings.append(self.borrowed_bytes(data) if data else 0)
            data=struct.pack('<12IHH4I',68,*strings,s.x,s.y,s.xsize,s.ysize,s.xchars,s.ychars,s.fill,s.flags,
                s.show,s.reserved_bytes,0,self.label_stdio(s.stdin),self.label_stdio(s.stdout),self.label_stdio(s.stderr))
            assert len(data)==68
            u.mem_write(arg(1),data);self.event(name,None,flags=s.flags,host_reserved_bytes=s.reserved_bytes);done(None,4);return True
        if name=='GetStdHandle':
            actual=K.GetStdHandle(arg(1));label=self.label_stdio(actual);self.event(name,label,kind=arg(1));done(label,4);return True
        if name in ('GetFileType','GetConsoleMode'):
            label=arg(1);h=self.stdio.get(label)
            if h is None and label in self.io.handles:h=self.io.handles[label]['handle']
            if h is None:raise Rejected('unknown type/console handle')
            if name=='GetFileType':result=K.GetFileType(h);pop=4
            else:
                v=w.DWORD();result=K.GetConsoleMode(h,ctypes.byref(v));pop=8
                if result:put(arg(2),v.value)
            self.event(name,result,handle=label);done(result,pop);return True
        if name=='OutputDebugStringA':
            value=self.strz(arg(1));K.OutputDebugStringA(value.encode());self.event(name,None,text=value);done(None,4);return True
        return False
    def host_cleanup(self):
        """Separate host hygiene; does not claim native CRT ownership retirement."""
        for key,item in list(self.slots.items()):
            kind,index=key
            # Let real FlsFree queue its callback; the runner executes it in PE.
            if item['kind']=='Fls':ok=K.FlsFree(index)
            else:ok=K.TlsFree(index)
            self.event('host_cleanup_'+item['kind']+'Free',int(bool(ok)),index=index)
            if ok:del self.slots[key]
        # Locks/heap remain until pending native callbacks have run.
    def release_host_backing(self):
        # A stopped native frame can still own recursive locks. Unwind only
        # these host locks on this same OS thread before destroying the host
        # backing; this is explicitly not native stack/SEH teardown.
        for p,s in list(self.locks.items()):
            depth=self.lock_depth[p]
            for _ in range(depth):K.LeaveCriticalSection(s)
            self.events.append({'api':'host_cleanup_lock_backing','reference':p,'abandoned_native_depth':depth})
            K.DeleteCriticalSection(s);del self.locks[p];del self.lock_depth[p]
        for p,raw in list(self.heap_blocks.items()):
            ok=K.HeapFree(self.heap,0,raw)
            self.events.append({'api':'host_cleanup_HeapFree','pointer':p,'success':bool(ok),'last_error':ctypes.get_last_error()})
            if ok:del self.heap_blocks[p];self.heap_sizes.pop(p,None)
        for raw,n in list(self.unadopted_heap_blocks.items()):
            ok=K.HeapFree(self.heap,0,raw)
            self.events.append({'api':'host_cleanup_unadopted_HeapFree','bytes':n,'success':bool(ok),'last_error':ctypes.get_last_error()})
            if ok:del self.unadopted_heap_blocks[raw]
        self.closed=True
