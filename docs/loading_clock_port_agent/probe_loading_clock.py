"""Run real993C70/993CE0/CE298A. OS outputs and once locks are explicit boundaries."""
from pathlib import Path
import hashlib,itertools,json,struct,sys
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn
from unicorn.x86_const import *
OUT=Path(__file__).resolve().parent
SOURCE=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe')
EXPECTED='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
raw=SOURCE.read_bytes();assert hashlib.sha256(raw).hexdigest()==EXPECTED
pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase
assert base==0x400000 and pe.FILE_HEADER.Machine==0x14c
image=pe.get_memory_mapped_image()
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32)
u.mem_map(base,(pe.OPTIONAL_HEADER.SizeOfImage+4095)&~4095);u.mem_write(base,image)
S=0x40000000;STACK=S+0x30000;END=S+0x3f000;QPF=S+0x100;QPC=S+0x110;THUNK=S+0x200;BITS=S+0x300
u.mem_map(S,0x40000)
def wr(a,v):u.mem_write(a,struct.pack('<I',v&0xffffffff))
def rd(a):return int.from_bytes(u.mem_read(a,4),'little')
def qword(a,v):u.mem_write(a,struct.pack('<Q',v&((1<<64)-1)))
wr(0xfa4180,QPF);wr(0xfa4134,QPC)
u.mem_write(THUNK,b'\xe8'+struct.pack('<i',0x993ce0-THUNK-5)+b'\xd9\x1d'+struct.pack('<I',BITS)+b'\xc3')
REGIONS=[(0x14bef48,16),(0x2d79080,1),(0x2d79158,8),(0x2d75530,4),(0x10de608,4)]
ALLOWED=[(0x993c70,0x993cdf),(0x993ce0,0x993da0),(0x995850,0x995857),(0xce13e2,0xce13ed),(0xce298a,0xce29cc),(THUNK,THUNK+12)]
active=False;events=[];queue=[];seen=set()
def finish(value=0,pop=0):
    sp=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EAX,value&0xffffffff);u.reg_write(UC_X86_REG_EIP,rd(sp));u.reg_write(UC_X86_REG_ESP,sp+4+pop)
def code(uc,pc,size,_):
    if not active:return
    seen.add(pc)
    if pc in [QPC,QPF]:
        op='qpc' if pc==QPC else 'qpf';spec=queue.pop(0);assert spec['op']==op,(op,spec)
        pointer=rd(u.reg_read(UC_X86_REG_ESP)+4);before=bytes(u.mem_read(pointer,8));out=bytearray(before)
        value=bytes.fromhex(spec['value_hex'])
        for n in range(8):
            if spec['mask']&(1<<n):out[n]=value[n]
        u.mem_write(pointer,bytes(out))
        events.append(dict(op=op,initial_hex=before.hex(),output_hex=out.hex(),return_value=spec['return_value'],mask=spec['mask']))
        for address,n,val in spec.get('mutations',[]):
            u.mem_write(address,val.to_bytes(n,'little'))
            events.append(dict(op='api_write',address=address,bytes=n,value=val))
        finish(spec['return_value'],4);return
    if pc==0xce5247:
        sp=u.reg_read(UC_X86_REG_ESP);assert [rd(sp+4),rd(sp+8)]==[0x14af61c,0xce2961]
        events.append(dict(op='once_prepare'));finish();return
    if pc in [0xce290b,0xce2934]:
        assert rd(u.reg_read(UC_X86_REG_ESP)+4)==0x14af620
        events.append(dict(op='once_enter' if pc==0xce290b else 'once_leave'));finish();return
    assert any(a<=pc<b for a,b in ALLOWED),hex(pc)
def memory(uc,kind,a,n,v,_):
    if active and any(p<=a and a+n<=p+z for p,z in REGIONS):
        events.append(dict(op='read' if kind==unicorn.UC_MEM_READ else 'write',address=a,bytes=n,value=int.from_bytes(u.mem_read(a,n),'little') if kind==unicorn.UC_MEM_READ else v))
u.hook_add(unicorn.UC_HOOK_CODE,code)
u.hook_add(unicorn.UC_HOOK_MEM_READ|unicorn.UC_HOOK_MEM_WRITE,memory)
def state():return [{'address':a,'hex':bytes(u.mem_read(a,n)).hex()} for a,n in REGIONS]
def response(op,value,ret=1,mask=255,mutations=None):
    o=dict(op=op,value_hex=struct.pack('<Q',value&((1<<64)-1)).hex(),return_value=ret,mask=mask)
    if mutations:o['mutations']=mutations
    return o
def run(label,entry,flag,cache_flag,cached,origin,frequency,queries,fill=0xa5,repeats=1):
    global active,queue
    u.mem_write(STACK-0x4000,bytes([fill])*0x5000)
    qword(0x14bef48,origin);qword(0x14bef50,frequency);qword(0x2d79158,cached)
    wr(0x2d75530,flag);u.mem_write(0x2d79080,bytes([cache_flag]));wr(0x10de608,0x995850)
    before=state();events.clear();queue=list(queries);samples=[]
    for _ in range(repeats):
        wr(STACK,END);u.reg_write(UC_X86_REG_ESP,STACK);u.reg_write(UC_X86_REG_EFLAGS,2)
        u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPSW,0);u.reg_write(UC_X86_REG_FPTAG,0xffff)
        start=len(events);active=True
        try:u.emu_start(0x993c70 if entry=='initialize' else THUNK,END,count=2000)
        finally:active=False
        assert u.reg_read(UC_X86_REG_EIP)==END and u.reg_read(UC_X86_REG_ESP)==STACK+4
        samples.append(dict(bits=rd(BITS) if entry=='sample' else None,events_start=start,events_end=len(events)))
    assert not queue,queue
    return dict(label=label,entry=entry,fill=fill,before=before,after=state(),queries=queries,repeats=repeats,samples=samples,events=list(events))
rows=[]
# Original initializer: cache miss/hit, arbitrary nonzero byte flags, API BOOL ignored,
# full/partial/no output writes. Unwritten QPF bytes are controlled stack inputs.
for cache_flag,ret,mask,fill in itertools.product([0,1,255],[0,1,0xffffffff],[0,15,240,255],[0,0xa5]):
    qs=[]
    if cache_flag==0:qs.append(response('qpf',0x0000000200989683,ret,mask))
    qs.append(response('qpc',0xabcdef1201234567,ret,mask))
    rows.append(run('initialize', 'initialize',0,cache_flag,0xfedcba9876543210,0x1122334455667788,7,qs,fill))
# Actual CE298A guard repeats and callback; constructor frequency cache separately varied.
for flag,cache_flag,ret,mask in itertools.product([0,1,2,0xffffffff],[0,1,255],[0,1],[0,15,240,255]):
    qs=[]
    if flag==0:
        if cache_flag==0:qs.append(response('qpf',10000003,ret,mask))
        qs.append(response('qpc',123456,ret,mask))
    qs.extend([response('qpc',123456+87654321,ret,mask),response('qpc',123456+87664321,ret,mask)])
    rows.append(run('once_repeated','sample',flag,cache_flag,10000019,123456,1000003,qs,repeats=2))
# Unsigned conversion / wrapping boundaries, frequency zero retained for masked x87.
for elapsed,frequency,origin in itertools.product([0,1,2**24+1,2**53+1,2**63+17,2**64-1],[0,1,3,10000000,2**53+1,2**63+3,2**64-1],[0,123456]):
    rows.append(run('unsigned_arithmetic','sample',1,0,0,origin,frequency,[response('qpc',origin+elapsed)]))
# Prove reads occur after the final API callback, rather than cached host time values.
rows.append(run('api_mutates_canonical_source','sample',0,0,1,0,1,[response('qpf',10000000),response('qpc',100),response('qpc',150,0,255,[(0x14bef48,8,140),(0x14bef50,8,3)])]))
assert hashlib.sha256(SOURCE.read_bytes()).hexdigest()==EXPECTED
proof=dict(schema=1,passed=True,complete=False,native_sha256=EXPECTED,case_count=len(rows),cases=rows,
           native_entry_points=['0x993c70','0x993ce0','0xce298a','0xce13e2','0x995850'],native_instruction_addresses=sorted(x for x in seen if base<=x<base+len(image)),
           x87_control_word=0x37f,source_preparation='E:/mapslol3v3/loading_clock_preparation/clock_sources.json',
           limits=['Original initializers, clock arithmetic, CE298A conditional callback/publication and callback trampolines execute unchanged.',
                   'CE5247/CE290B/CE2934 are explicit successful setup/lock/unlock boundaries. No native mutex allocation, scheduling, concurrency, atexit or lifetime qualification.',
                   'QPC/QPF imports use deterministic supplied BOOL and byte writes. QPF untouched bytes come from controlled prefilled native stack, not a claimed Windows failure output.',
                   'Unicorn x87 outputs are emulator evidence until physical x87 cross-check. No OS clock or live producer connected.',
                   'Synthetic frequency0 and unsigned wrap cases demonstrate source arithmetic, not real Windows hardware behavior.'])
(OUT/'native_clock_results.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(passed=True,cases=len(rows),samples=sum(len(x['samples']) for x in rows),events=sum(len(x['events']) for x in rows))))
