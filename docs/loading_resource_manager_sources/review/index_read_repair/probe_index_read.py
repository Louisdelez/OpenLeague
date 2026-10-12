"""Native manager producer/destructor and provider cache lookup.

Only allocator/free/memory primitives are supplied. Providers in the lookup
fixture are opaque borrowed tokens, never a simulated constructed provider.
Misses stop at the real90B520 entry before its body; direct String24 retirement
is an explicitly separate abandoned-call cleanup, not a native exception path.
"""
from pathlib import Path
import sys, json, struct, hashlib, traceback, collections
import importlib.util
sys.dont_write_bytecode=True
source_path=Path('E:/OpenLeague/docs/loading_standard_resource_preparation/extract_resource.py')
spec=importlib.util.spec_from_file_location('src',source_path);src=importlib.util.module_from_spec(spec);spec.loader.exec_module(src)
EXE,raw,digest,pe,image,BASE,read=src.EXE,src.raw,src.digest,src.pe,src.image,src.BASE,src.read
OUT=Path(__file__).resolve().parent
import unicorn
from unicorn.x86_const import *
H=0x30000000; STACK=0x31000000; END=0x32000000; ARENA=0x33000000
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32)
u.mem_map(BASE,(len(image)+0xfff)&~0xfff);u.mem_write(BASE,image)
u.mem_map(0,0x10000);u.mem_map(H,0x10000);u.mem_map(STACK,0x20000);u.mem_map(END,0x10000);u.mem_map(ARENA,0x400000)
active_index=None;index_calls=[]
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
    u.mem_write(p,bytes([poison])*n);live[p]=n;allocations.append({'pointer':p,'bytes':n,'phase':phase});
    if active_index is not None:active_index['access'].append(['allocate',p,n])
    trace.append({'kind':'allocate','pointer':p,'bytes':n,'phase':phase});return p
def release(p):
    if not p:return
    assert p in live,('free of unowned pointer',hex(p),phase)
    
    if active_index is not None:active_index['access'].append(['free',p])
    trace.append({'kind':'free','pointer':p,'phase':phase});del live[p];frees.append({'pointer':p,'phase':phase})
PRIMITIVES={0x9933e0,0xc9f39b,0xc98528,0xca1ef0,0xca1f20}
def hook(uc,pc,size,user):
    global stop,name_copy,copy_before_cleanup,active_index
    sp=u.reg_read(UC_X86_REG_ESP)
    if pc in (0x9933e0,0xc9f39b):finish(allocate(read32(sp+4)));return
    if pc==0xc98528:release(read32(sp+4));finish();return
    if pc in (0xca1ef0,0xca1f20):
        dst,src,n=[read32(sp+i) for i in (4,8,12)];assert n<0x100000
        u.mem_write(dst,bytes(u.mem_read(src,n)));finish(dst);return
    assert BASE<=pc<BASE+len(image),('unexpected external execution',hex(pc),phase)
    assert bytes(u.mem_read(pc,size))==read(pc,size),('source modified',hex(pc))
    trail.append(hex(pc))
    visited.add(pc)
    if active_index is not None and pc==active_index['return_pc'] and sp==active_index['entry_sp']+8:
        active_index['slot']=u.reg_read(UC_X86_REG_EAX)
        active_index['after']=snap()
        active_index['allocations']=list(allocations[active_index.pop('allocation_start'):])
        index_calls.append(active_index);active_index=None
    if phase=='produce' and pc==0x5bd9b0:
        assert active_index is None
        key_ref=read32(sp+4)
        active_index={'entry_sp':sp,'return_pc':read32(sp),'tree':u.reg_read(UC_X86_REG_ECX),'key_ref':key_ref,'key':read32(key_ref),'before':snap(),'allocation_start':len(allocations),'access':[],'read_sites':[]}
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

trace=[]
def mem_hook(uc,access,address,size,value,user):
    if ARENA<=address<ARENA+0x400000 or 0x2d6edf0<=address<0x2d6ee00 or address==0x2d78f1c:
        trace.append({'kind':'write','address':address,'hex':(value&((1<<(size*8))-1)).to_bytes(size,'little').hex(),'phase':phase})
u.hook_add(unicorn.UC_HOOK_MEM_WRITE,mem_hook)
def index_memory_hook(uc,access,address,size,value,user):
    if active_index is None:return
    key_ref=active_index['key_ref']
    if not (ARENA<=address<ARENA+0x400000 or key_ref<=address<key_ref+4 or address in (0x14bef40,0x14bef44)):return
    if access==unicorn.UC_MEM_READ:
        active_index['access'].append(['read',address,size]);active_index['read_sites'].append([u.reg_read(UC_X86_REG_EIP),address,size])
    else:
        raw=(value&((1<<(8*size))-1)).to_bytes(size,'little')
        active_index['access'].extend(['write',address+i,v] for i,v in enumerate(raw))
u.hook_add(unicorn.UC_HOOK_MEM_READ|unicorn.UC_HOOK_MEM_WRITE,index_memory_hook)
cases=[]
frozen=json.loads(Path('E:/OpenLeague/docs/loading_standard_resource_preparation/native_resource_oracle.json').read_text())
for fill in [0,165]:
    poison=fill;cursor=ARENA;live.clear();allocations.clear();frees.clear();events.clear();trace.clear();index_calls.clear();active_index=None
    write32(0x14bef40,0);write32(0x14bef58,0);u.mem_write(0x2d77b20,b'\1');write32(0x2d78f1c,0)
    phase='hashes'
    for initializer in [0x531a50,0x531a90,0x531ad0,0x531b10]:call(initializer)
    phase='produce';assert call(0x90b7c0)==ARENA
    manager=read32(0x2d78f1c);initial=snap()
    ref=next(c for c in frozen['cases'] if c['fill']==fill)
    assert initial==ref['initial']
    phase='wire';u.reg_write(UC_X86_REG_EAX,manager);u.emu_start(0x592e49,0x592e6a,count=1000)
    wired=snap();assert wired==ref['after_bounded_backpointer_fragment']
    phase='destroy';assert call(0x90a760,manager,[1])==manager
    assert not live and read32(0x2d78f1c)==manager
    assert [f['pointer'] for f in frees]==[f['pointer'] for f in ref['frees'] if f['phase']=='manager_destructor']
    destroyed_global=read32(0x2d78f1c)
    write32(0x2d78f1c,0)
    cases.append({'fill':fill,'manager':manager,'initial':initial,'wired':wired,'destructor_keeps_global':destroyed_global,'allocations':list(allocations),'frees':list(frees),'trace':list(trace),'live_after':dict(live),'index_calls':list(index_calls)})

assert all(len(c['index_calls'])==4 for c in cases)
result={'passed':True,'insertions':sum(len(c['index_calls']) for c in cases),'read_operations':sum(sum(e[0]=='read' for e in call['access']) for c in cases for call in c['index_calls']),'capture_scope':{'entry':0x5bd9b0,'exit':'original return_pc and ESP==entry_sp+8','address_ranges':[[ARENA,ARENA+0x400000]],'extra_addresses':['per-call key_ref..key_ref+4',0x14bef40,0x14bef44],'excludes':'Other stack/ABI/FS/cookie reads and caller preflight'},'source':str(EXE),'source_sha256':digest,'lifetimes':len(cases),'cases':cases,'executed_instruction_addresses':sorted(visited),'primitive_hooks':sorted(PRIMITIVES),'limits':['Only the four genuine index insertions of each empty manager constructor are qualified; no synthetic provider or altered source opcode.','Index trace filters canonical allocation addresses, the actual caller key_ref and deallocator globals. Stack arguments, spills, cookie and FS/SEH scaffolding are excluded.','Writes are normalized to bytes; reads retain exact native width and order.','Native normal-return behavior only; host read-error recovery is tested separately in Rust.','No Rust test executed by this Python oracle.']}
(OUT/'loading_resource_index_read_contract.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({'passed':True,'lifetimes':len(cases),'insertions':sum(len(c['index_calls']) for c in cases),'reads':sum(sum(e[0]=='read' for e in call['access']) for c in cases for call in c['index_calls'])}))
