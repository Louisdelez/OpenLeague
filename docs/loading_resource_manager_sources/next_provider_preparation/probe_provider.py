"""Native manager producer/destructor and provider cache lookup.

Only allocator/free/memory primitives are supplied. Providers in the lookup
fixture are opaque borrowed tokens, never a simulated constructed provider.
Misses stop at the real90B520 entry before its body; direct String24 retirement
is an explicitly separate abandoned-call cleanup, not a native exception path.
"""
from pathlib import Path
import sys, json, struct, hashlib, traceback, collections
import sys,importlib.util,ctypes
from ctypes import wintypes as wt
sys.dont_write_bytecode=True
spec=importlib.util.spec_from_file_location('source',Path('E:/OpenLeague/docs/loading_standard_resource_preparation/extract_resource.py'))
src=importlib.util.module_from_spec(spec);spec.loader.exec_module(src)
EXE,raw,digest,pe,image,BASE,read=src.EXE,src.raw,src.digest,src.pe,src.image,src.BASE,src.read
OUT=Path(__file__).resolve().parent
DEPLOY=EXE.parent

import unicorn
from unicorn.x86_const import *
H=0x30000000; STACK=0x31000000; END=0x32000000; ARENA=0x33000000
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32)
u.mem_map(BASE,(len(image)+0xfff)&~0xfff);u.mem_write(BASE,image)
u.mem_map(0,0x10000);u.mem_map(H,0x10000);u.mem_map(STACK,0x20000);u.mem_map(END,0x10000);u.mem_map(ARENA,0x400000)
cursor=ARENA;poison=0;allocations=[];frees=[];live={};visited=set();events=[];phase='';stop=None;name_copy=None;copy_before_cleanup=None;trail=collections.deque(maxlen=45)
def read32(a):return int.from_bytes(u.mem_read(a,4),'little')
def write32(a,v):u.mem_write(a,(v&0xffffffff).to_bytes(4,'little'))
def finish(value=None,pop=0):
    sp=u.reg_read(UC_X86_REG_ESP);ret=read32(sp)
    if value is not None:u.reg_write(UC_X86_REG_EAX,value&0xffffffff)
    u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EIP,ret)
def allocate(n):
    global cursor
    assert 0<n<0x100000
    p=cursor;cursor+=(n+31)&~15;assert cursor<ARENA+0x400000
    u.mem_write(p,bytes([poison])*n);live[p]=n;allocations.append({'pointer':p,'bytes':n,'phase':phase});return p
def release(p):
    if not p:return
    assert p in live,('free of unowned pointer',hex(p),phase)
    del live[p];frees.append({'pointer':p,'phase':phase})
PRIMITIVES={0x9933e0,0xc9f39b,0xc98528,0xca1ef0,0xca1f20}
def hook(uc,pc,size,user):
    global stop,name_copy,copy_before_cleanup
    sp=u.reg_read(UC_X86_REG_ESP)
    if pc in (0x9933e0,0xc9f39b):finish(allocate(read32(sp+4)));return
    if pc==0xc98528:release(read32(sp+4));finish();return
    if pc in (0xca1ef0,0xca1f20):
        dst,src,n=[read32(sp+i) for i in (4,8,12)];assert n<0x100000
        u.mem_write(dst,bytes(u.mem_read(src,n)));finish(dst);return
    if pc in imports:
        api_import(pc);return
    if pc==0xc97e4c:
        shutdown_callbacks.append(read32(sp+4));finish(0);return
    if pc==0xca1d00:
        dst,v,n=[read32(sp+i) for i in (4,8,12)];assert n<0x100000
        u.mem_write(dst,bytes([v&255])*n);finish(dst);return
    if pc==0x8b0630:
        stop={'kind':'ini_reader_boundary','pc':pc,'ecx':u.reg_read(UC_X86_REG_ECX),'edx':u.reg_read(UC_X86_REG_EDX),'args':[read32(sp+i) for i in (4,8,12,16,20)]};u.emu_stop();return
    assert BASE<=pc<BASE+len(image),('unexpected external execution',hex(pc),phase)
    assert bytes(u.mem_read(pc,size))==read(pc,size),('source modified',hex(pc))
    trail.append(hex(pc))
    visited.add(pc)
    if phase.startswith('lookup') and pc==0x99a310:name_copy=u.reg_read(UC_X86_REG_ECX)
    if phase=='lookup_hit' and pc==0x90adb1:copy_before_cleanup=string(name_copy)
    if phase=='lookup_miss' and pc==0x90b520:
        visited.discard(pc)
        stop={'address':pc,'this':u.reg_read(UC_X86_REG_ECX),'arguments':[read32(sp+4),read32(sp+8)],'copy':string(name_copy),'live':dict(live),'esp':sp};u.emu_stop();return
    if pc in (0x90b7c0,0x90a4c0,0x90a760,0x90a800,0x90ad00,0x90cef0,0x90e0c0,0x90e190,0x5c2ab0,0x5c2ce0):events.append({'phase':phase,'entry':pc,'this':u.reg_read(UC_X86_REG_ECX),'global':read32(0x2d78f1c)})
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def call(a,this=0,args=(),edx=0):
    sp=STACK+0x1d000;u.mem_write(sp,struct.pack('<'+'I'*(len(args)+1),END,*args));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,this);u.reg_write(UC_X86_REG_EDX,edx)
    u.emu_start(a,END,count=3000000)
    assert u.reg_read(UC_X86_REG_EIP)==END,('incomplete call',hex(a),hex(u.reg_read(UC_X86_REG_EIP)))
    return u.reg_read(UC_X86_REG_EAX)
def string(p):
    n=read32(p+16);cap=read32(p+20);assert n<=cap<0x10000
    data=read32(p) if cap>=16 else p
    return {'pointer':p,'data':data,'length':n,'capacity':cap,'bytes_hex':bytes(u.mem_read(data,n)).hex(),'object_hex':bytes(u.mem_read(p,24)).hex()}
def make_string(p,value):
    u.mem_write(p,bytes([poison])*24);write32(p+16,0);write32(p+20,15);u.mem_write(p,b'\0');u.mem_write(H+0x4000,value+b'\0')
    call(0x564c20,p,[H+0x4000,len(value)])
def snap():return {'blocks':[{'pointer':p,'size':n,'hex':bytes(u.mem_read(p,n)).hex()} for p,n in sorted(live.items())],'global':read32(0x2d78f1c)}
def tree(manager):
    head=read32(manager+12);nodes=[]
    def walk(p):
        if u.mem_read(p+13,1)[0]:assert p==head;return
        assert p not in [x['node'] for x in nodes]
        walk(read32(p));nodes.append({'node':p,'name':string(p+16),'skin':read32(p+40),'provider':read32(p+44),'hex':bytes(u.mem_read(p,48)).hex()});walk(read32(p+8))
    walk(read32(head+4));assert len(nodes)==read32(manager+16)
    return {'head':head,'count':len(nodes),'nodes':nodes}

# Imports retain their original code callers. Only IAT data is rebound to
# explicit primitive stubs; unknown imports stop before returning any value.
STUBS=0x3f000000;u.mem_map(STUBS,0x10000)
imports={};shutdown_callbacks=[];io_events=[];handles={};next_handle=0x61000000;last_error=0
for descriptor in pe.DIRECTORY_ENTRY_IMPORT:
    for imp in descriptor.imports:
        address=STUBS+len(imports)*16
        imports[address]={'dll':descriptor.dll.decode(),'name':imp.name.decode() if imp.name else '#'+str(imp.ordinal),'iat':imp.address}
        write32(imp.address,address)
class FindData(ctypes.Structure):
    _fields_=[('attr',wt.DWORD),('creation',wt.FILETIME),('access',wt.FILETIME),('write',wt.FILETIME),('high',wt.DWORD),('low',wt.DWORD),('reserved0',wt.DWORD),('reserved1',wt.DWORD),('name',wt.WCHAR*260),('alternate',wt.WCHAR*14)]
kernel=ctypes.WinDLL('kernel32',use_last_error=True)
kernel.FindFirstFileW.argtypes=[wt.LPCWSTR,ctypes.POINTER(FindData)];kernel.FindFirstFileW.restype=wt.HANDLE
kernel.FindNextFileW.argtypes=[wt.HANDLE,ctypes.POINTER(FindData)];kernel.FindNextFileW.restype=wt.BOOL
kernel.GetFileAttributesW.argtypes=[wt.LPCWSTR];kernel.GetFileAttributesW.restype=wt.DWORD
kernel.FindClose.argtypes=[wt.HANDLE];kernel.FindClose.restype=wt.BOOL
INVALID=ctypes.c_void_p(-1).value

def cstr(p):
    out=bytearray()
    while True:
        b=u.mem_read(p+len(out),1)[0]
        if not b:return out.decode('ascii')
        out.append(b);assert len(out)<4096

def put_find(p,d):
    head=bytes(d)[:44]
    name=d.name.encode('ascii');alt=d.alternate.encode('ascii');assert len(name)<260 and len(alt)<14
    u.mem_write(p,head+name.ljust(260,b'\0')+alt.ljust(14,b'\0')+b'\0\0')

def api_import(pc):
    global next_handle,last_error,stop
    item=imports[pc];name=item['name'];sp=u.reg_read(UC_X86_REG_ESP)
    if name=='GetCurrentDirectoryA':
        capacity,out=read32(sp+4),read32(sp+8);value=str(DEPLOY).encode('ascii')
        if capacity>len(value):u.mem_write(out,value+b'\0');result=len(value)
        else:result=len(value)+1
        io_events.append({'api':name,'emulated_working_directory':str(DEPLOY),'result':result})
        finish(result,8);return
    if name=='GetFileAttributesA':
        query=cstr(read32(sp+4));path=Path(query.replace(chr(92),'/'));target=path if path.is_absolute() else DEPLOY/path
        target=target.resolve();allowed=DEPLOY.parents[5];assert str(target).lower().startswith(str(allowed).lower()+chr(92)),query
        result=kernel.GetFileAttributesW(chr(92)*2+'?'+chr(92)+str(target));last_error=ctypes.get_last_error()
        io_events.append({'api':name,'query':query,'physical_path':str(target),'attributes':result,'error':last_error})
        finish(result,4);return
    if name=='FindFirstFileA':
        query=cstr(read32(sp+4));relative=query.replace('\\','/')
        assert not Path(relative).is_absolute() and '..' not in Path(relative).parts,query
        target=DEPLOY/relative;assert str(target.parent.resolve()).lower().startswith(str(DEPLOY.resolve()).lower()+'\\')
        d=FindData();actual=kernel.FindFirstFileW(chr(92)*2+'?'+chr(92)+str(target),ctypes.byref(d))
        last_error=ctypes.get_last_error()
        event={'api':name,'query':query,'physical_path':str(target),'error':last_error,'found':actual!=INVALID}
        if actual==INVALID:result=0xffffffff
        else:
            result=next_handle;next_handle+=4;handles[result]=actual;put_find(read32(sp+8),d);event['first_name']=d.name
        io_events.append(event);finish(result,8);return
    if name=='FindNextFileA':
        label=read32(sp+4);assert label in handles
        d=FindData();ok=kernel.FindNextFileW(handles[label],ctypes.byref(d));last_error=ctypes.get_last_error()
        if ok:put_find(read32(sp+8),d)
        io_events.append({'api':name,'handle':label,'success':bool(ok),'name':d.name if ok else None,'error':last_error})
        finish(int(bool(ok)),8);return
    if name=='FindClose':
        label=read32(sp+4);assert label in handles
        ok=kernel.FindClose(handles.pop(label));assert ok
        io_events.append({'api':name,'handle':label,'success':True});finish(1,4);return
    if name=='GetLastError':finish(last_error);return
    stop={'kind':'unimplemented_import','path':cstr(read32(sp+4)) if name in ('CreateDirectoryA','CreateFileA') else None,'import':item,'stack_args':[read32(sp+i) for i in (4,8,12,16)],'phase':phase}
    u.emu_stop()

proof={'source':str(EXE),'source_sha256':digest,'complete':False,'passed':False,'phases':[]}
try:
    write32(0x14bef40,0);write32(0x14bef58,0);u.mem_write(0x2d77b20,b'\1')
    phase='context_default_fragment';context=allocate(148);frame=STACK+0x10000;sp=STACK+0xe000
    u.mem_write(frame-0x140,bytes(0x140));write32(0x2d78f20,0)
    for reg,value in [(UC_X86_REG_ESP,sp),(UC_X86_REG_EBP,frame),(UC_X86_REG_ESI,context),(UC_X86_REG_EDI,0),(UC_X86_REG_EBX,0)]:u.reg_write(reg,value)
    u.emu_start(0x906487,0x9065d8,count=2000000)
    assert u.reg_read(UC_X86_REG_EIP)==0x9065d8 and read32(0x2d78f20)==context
    proof['context']={'pointer':context,'fields':{hex(off):string(context+off) for off in [4,0x1c,0x34,0x4c,0x64,0x7c]}}
    proof['phases'].append({'name':phase,'completed':True})
    phase='manager';write32(0x2d78f1c,0)
    for initial in [0x531a50,0x531a90,0x531ad0,0x531b10]:call(initial)
    call(0x90b7c0);manager=read32(0x2d78f1c);u.reg_write(UC_X86_REG_EAX,manager);u.emu_start(0x592e49,0x592e6a,count=1000)
    phase='input';query=H+0x100;make_string(query,b'Ahri')
    phase='provider_miss';stop=None
    call(0x90ad00,manager,[query,0,0])
    proof['phases'].append({'name':phase,'completed':True})
    proof['passed']=True
except Exception as e:
    proof['error']=repr(e);proof['phase']=phase;proof['pc']=hex(u.reg_read(UC_X86_REG_EIP));proof['trail']=list(trail)
finally:
    proof.update(stop=stop,allocations=allocations,frees=frees,live_snapshot=snap(),events=events,io_events=io_events,shutdown_callbacks=shutdown_callbacks,executed_instruction_addresses=sorted(visited),open_find_handles=len(handles),primitive_hooks=sorted(PRIMITIVES|{0xc97e4c,0xca1d00}))
    for h in handles.values():kernel.FindClose(h)
    handles.clear()
    (OUT/'provider_probe_state.json').write_text(json.dumps(proof,indent=2)+'\n')
    print(json.dumps({'passed':proof['passed'],'phase':phase,'stop':stop,'error':proof.get('error'),'live_allocations':len(live),'instructions':len(visited),'io_events':len(io_events)}),flush=True)
