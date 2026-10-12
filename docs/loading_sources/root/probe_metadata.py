from pathlib import Path
import sys,json,struct,hashlib
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn
from unicorn.x86_const import *
OUT=Path(__file__).resolve().parent
EXE=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe')
raw=EXE.read_bytes();sha=hashlib.sha256(raw).hexdigest();assert sha=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
pe=pefile.PE(data=raw);im=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(base,(len(im)+4095)&~4095);u.mem_write(base,im)
H=0x30000000;STACK=0x31000000;END=0x32000000;HEAP=0x38000000
for a,size in [(0,0x10000),(H,0x10000),(STACK,0x10000),(END,0x1000),(HEAP,0x100000)]:u.mem_map(a,size)
P=H+0x100;HEAD=H+0x1000;NODES=[H+0x1200+i*0x100 for i in range(9)];OUTSTR=H+0x3000;PARENT=H+0x3100;CONTROL=H+0x3200
KEYS=[(0x80000000,0),(0x80000000,0xffffffff),(0xffffffff,7),(0,0),(0,1),(0,0xffffffff),(1,0),(0x7fffffff,0),(0x7fffffff,0xffffffff)]
LENGTHS=[0,7,15,16,31,32,47,64,100]
regions=[('name',0x728410,0xec),('extra',0x728500,0xa6),('service_name',0x72ad90,0xb0),('service_extra',0x72ae40,0xa7),('acquire',0x729c80,0x6d),('pair_copy',0x5cc070,0x85),('find',0x72e390,0x76),('assign',0x564af0,0x120),('grow',0x564f30,0x197),('destroy_string',0x564900,0x50),('memcpy',0xca1ef0,0x350),('cookie',0xc975f5,0x1b)]
def rd(a):return int.from_bytes(u.mem_read(a,4),'little')
def wr(a,v):u.mem_write(a,struct.pack('<I',v&0xffffffff))
def ret(pop=0,eax=None,edx=None):
    sp=u.reg_read(UC_X86_REG_ESP);target=rd(sp);u.reg_write(UC_X86_REG_ESP,sp+4+pop)
    if eax is not None:u.reg_write(UC_X86_REG_EAX,eax)
    if edx is not None:u.reg_write(UC_X86_REG_EDX,edx)
    u.reg_write(UC_X86_REG_EIP,target)
active=False;events=[];allocations=[];live={};next_ptr=HEAP;fill=0;resolved=0;visited=set();output=[]
def code(uc,pc,size,_):
    global next_ptr
    if not active:return
    visited.add(pc);sp=u.reg_read(UC_X86_REG_ESP);this=u.reg_read(UC_X86_REG_ECX)
    if pc in (0x9941b0,0x994210):events.append({'op':'enter' if pc==0x9941b0 else 'leave','p':this});ret();return
    if pc==0x5f9f20:
        p=rd(sp+4);wr(this,p);events.append({'op':'enter','p':p});ret(4,this);return
    if pc==0x729ec0:events.append({'op':'resolve','p':this,'target':pc,'key':rd(sp+4)});ret(4,resolved&0xffffffff,resolved>>32);return
    if pc==0x5cf1e0:events.append({'op':'initialize_parent'});wr(0x2d78520,PARENT);ret();return
    if pc==0x9933e0:
        n=rd(sp+4);p=next_ptr;next_ptr=(p+n+63)&~63;u.mem_write(p,bytes([fill])*n);live[p]=n
        allocations.append({'pointer':p,'bytes':n});events.append({'op':'allocate','p':p,'bytes':n});ret(0,p);return
    if pc==0xc98528:
        p=rd(sp+4);assert p in live;del live[p];events.append({'op':'free','p':p});ret();return
    if pc==0xca1ef0:
        # Standard memcpy boundary; caller's allocation/control flow executes natively.
        d,s,n=[rd(sp+i) for i in (4,8,12)];assert d+n<=s or s+n<=d or d==s
        u.mem_write(d,bytes(u.mem_read(s,n)));ret(0,d);return
    assert any(a<=pc<a+n for _,a,n in regions),f'unexpected native instruction {pc:x}'
u.hook_add(unicorn.UC_HOOK_CODE,code)
def putstring(p,data,capacity=None,buffer=0):
    cap=capacity if capacity is not None else (15 if len(data)<16 else len(data)|15)
    dest=p
    if cap>=16:
        dest=buffer;wr(p,dest);live[dest]=cap+1;u.mem_write(dest,bytes([fill])*(cap+1))
    u.mem_write(dest,data+b'\0');wr(p+16,len(data));wr(p+20,cap)
def seed(cap,empty):
    global next_ptr
    live.clear();next_ptr=HEAP;u.mem_write(H,bytes([fill])*0x6000);u.mem_write(STACK,bytes([fill])*0x10000);wr(0,0)
    wr(0x14bef40,0);wr(0x14bef44,0);wr(P,0x10b00c4);wr(P+8,HEAD);wr(P+12,0 if empty else 9)
    wr(HEAD,NODES[0] if not empty else HEAD);wr(HEAD+8,NODES[-1] if not empty else HEAD);u.mem_write(HEAD+12,b'\1\1')
    def branch(ids,parent,depth=0):
        if not ids:return HEAD
        mid=len(ids)//2;i=ids[mid];n=NODES[i];index,key=KEYS[i];wr(n+4,parent);wr(n+16,key);wr(n+20,index);u.mem_write(n+12,bytes([0 if depth==3 else 1,0]))
        wr(n,branch(ids[:mid],n,depth+1));wr(n+8,branch(ids[mid+1:],n,depth+1))
        data=bytes((65+(i+j)%26) for j in range(LENGTHS[i]));putstring(n+24,data,buffer=H+0x4000+i*0x100);wr(n+48,0xabcdef00+i);return n
    wr(HEAD+4,branch([] if empty else list(range(9)),HEAD));putstring(P+0x1b0,b'olddata',cap,H+0x5000)
    wr(0x2d78520,PARENT);wr(PARENT+0x34,P);wr(PARENT+0x38,CONTROL);wr(CONTROL,0x1085f4c);wr(CONTROL+4,3);wr(CONTROL+8,1);wr(CONTROL+12,P)
def snapshot():
    # Include all static storage and each live allocation, but not native stack scratch.
    data=bytes(u.mem_read(H,0x6000));runs=[];start=None
    for i,v in enumerate(data+bytes([fill])):
        if v!=fill and start is None:start=i
        if v==fill and start is not None:runs.append([start,data[start:i].hex()]);start=None
    return {'arena_runs':runs,'live':[{'pointer':p,'bytes':n,'hex':bytes(u.mem_read(p,n)).hex()} for p,n in sorted(live.items())]}
def call(address,args):
    global active
    sp=STACK+0xe000;wr(sp,END)
    for i,x in enumerate(args):wr(sp+4+4*i,x)
    u.reg_write(UC_X86_REG_ECX,P);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EFLAGS,2);active=True
    try:u.emu_start(address,END,count=100000)
    finally:active=False
    assert u.reg_read(UC_X86_REG_EIP)==END and u.reg_read(UC_X86_REG_ESP)==sp+4+4*len(args)
    return u.reg_read(UC_X86_REG_EAX)
for fill in [0,165]:
 for cap in [15,31,47,127]:
  for empty in [False,True]:
   for service in [False,True]:
    seed(cap,empty);initial=snapshot();steps=[]
    for i in [0,3,1,6,7,8,4,2,5,9,10]:
        index,key=KEYS[i] if i<9 else ((0,99) if i==9 else (0xfffffffe,0));resolved=(index<<32)|key
        events.clear();allocations.clear();before=snapshot()
        if service and i==0:wr(0x2d78520,0)
        input_key=(0x9000+i);result=call(0x72ad90 if service else 0x728410,[OUTSTR,input_key]);assert result==OUTSTR
        after_name=snapshot();name_events=list(events);name_alloc=list(allocations)
        events.clear();allocations.clear();extra=call(0x72ae40 if service else 0x728500,[input_key]);assert extra==(0xabcdef00+i if not empty and i<9 else 0)
        after_extra=snapshot();extra_events=list(events)
        events.clear();call(0x564900,[]) if False else None
        # destructor uses output, not metadata this
        sp=STACK+0xe000;wr(sp,END);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,OUTSTR);active=True
        try:u.emu_start(0x564900,END,count=10000)
        finally:active=False
        assert u.reg_read(UC_X86_REG_EIP)==END
        steps.append({'i':i,'input_key':input_key,'resolved':resolved,'reset_parent':bool(service and i==0),'before':before,'name_after':after_name,'name_events':name_events,'name_allocations':name_alloc,'extra':extra,'extra_after':after_extra,'extra_events':extra_events,'destroy_events':list(events),'after':snapshot()})
    output.append({'fill':fill,'capacity':cap,'empty':empty,'service':service,'initial':initial,'steps':steps})
sources=[{'name':name,'address':a,'size':n,'hex':im[a-base:a-base+n].hex(),'sha256':hashlib.sha256(im[a-base:a-base+n]).hexdigest()} for name,a,n in regions if name!='memcpy']
fixture={'exe_sha256':sha,'address':{'arena':H,'metadata':P,'head':HEAD,'output':OUTSTR,'parent':PARENT,'control':CONTROL},'boundaries':['Win32 lock','729EC0 resolver return','5CF1E0 initialization','engine allocator/free','memcpy'],'cases':output}
(OUT/'loading_metadata_probe.json').write_text(json.dumps(fixture,separators=(',',':')),encoding='utf-8')
(OUT/'loading_metadata_sources.json').write_text(json.dumps({'exe_sha256':sha,'regions':sources,'visited':sorted(visited)},indent=2),encoding='utf-8')
summary={'passed':True,'lifetimes':len(output),'getter_calls':len(output)*len(steps)*2,'resolver_boundary':True,'native_resolver_executed':False,'fixture_sha256':hashlib.sha256((OUT/'loading_metadata_probe.json').read_bytes()).hexdigest()}
(OUT/'native_result.json').write_text(json.dumps(summary,indent=2),encoding='utf-8');print(json.dumps(summary))
