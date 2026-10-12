"""Execute real x86 588290/577E90/5CC140; only virtual terminal boundaries observed."""
from pathlib import Path
import sys, json, struct, hashlib, itertools
ROOT=Path('E:/OpenLeague'); OUT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT/'tools/pythonlibs'))
import pefile, unicorn
from unicorn.x86_const import *
context=json.loads((ROOT/'data/4.20/ambient_audio_context.json').read_text())
exe=next(p for p in Path(context['banks'][0]['path']).parents if p.name=='deploy')/'League of Legends.exe'
raw=exe.read_bytes(); digest=hashlib.sha256(raw).hexdigest()
assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
pe=pefile.PE(data=raw); image=pe.get_memory_mapped_image()
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32)
u.mem_map(0x400000,(len(image)+4095)&~4095); u.mem_write(0x400000,image)
H=0x30000000; STACK=0x31000000; END=0x32000000
for address in [0,H,STACK,END]: u.mem_map(address,0x10000)
G=0x14c761c; SCR=H+0x100; DST=H+0x120; A=H+0x200; B=H+0x220
VT=H+0x300; VT2=H+0x310; WRAP=H+0x400; RECIP=H+0x420; RVT=H+0x440
PACKET=H+0x600; RECEIVE=END+0x100; DISPOSE=END+0x200; RELEASE=END+0x300; RELEASE2=END+0x400
def rd(a): return struct.unpack('<I',u.mem_read(a,4))[0]
def wr(a,v): u.mem_write(a,struct.pack('<I',v&0xffffffff))
def finish(pop=0,eax=0):
    sp=u.reg_read(UC_X86_REG_ESP); ret=rd(sp)
    u.reg_write(UC_X86_REG_EAX,eax);u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EIP,ret)
selected={G,G+4,SCR,SCR+4,DST,DST+4,WRAP,RECIP,RVT,VT,VT+4,VT2,VT2+4}
selected.update(c+n for c in [A,B] for n in [0,4,8])
events=[]; mode='observe'; active=False; scratch_native=SCR; dest=DST; seen=set()
atomic={0x5cc164:'increment',0x5cc178:'decrement',0x5cc18a:'decrement',0x577efb:'decrement',0x577f0a:'decrement'}
def norm(a):
    if scratch_native!=SCR and scratch_native<=a<scratch_native+8:return SCR+a-scratch_native
    return a
def snap():
    return [[a,rd(scratch_native+a-SCR if SCR<=a<SCR+8 else a)] for a in sorted(selected)]
def callback(kind,ptr,target,payload=None):
    entry={'op':kind,'object':ptr,'method':target,'global':[rd(G),rd(G+4)],'destination':[rd(dest),rd(dest+4)]}
    if kind=='receive':entry.update(payload=payload,counts=[rd(A+4),rd(A+8)])
    else:entry.update(counts=[rd(ptr+4),rd(ptr+8)])
    events.append(entry)
    if kind=='receive':
        if mode in ('clear_global','drop_global'):wr(G,0);wr(G+4,0)
        if mode=='drop_global' and ptr==RECIP:
            # Explicit terminal-boundary mutation, releasing the external owner.
            # Tested only with initially live counts1/2, so temporary keeps it alive.
            wr(A+4,rd(A+4)-1)
        if mode=='retarget_vtable':wr(A,VT2)
    elif kind=='dispose':
        if mode=='dispose_mutates_global':wr(G,0xfeed1234);wr(G+4,0)
        if mode=='dispose_retargets':wr(ptr,VT2)
        if mode=='dispose_weak2':wr(ptr+8,2)
def code(uc,pc,size,user):
    if not active:return
    seen.add(pc)
    if pc==0x577ebd:
        global scratch_native,dest
        scratch_native=u.reg_read(UC_X86_REG_EBP)-0x14;dest=scratch_native
    if pc in atomic:
        if pc==0x5cc164: address=u.reg_read(UC_X86_REG_EAX)
        elif pc in (0x5cc178,0x577efb):address=u.reg_read(UC_X86_REG_ECX)
        else:address=u.reg_read(UC_X86_REG_EAX)
        events.append({'op':atomic[pc],'address':norm(address),'old':rd(address)})
    if pc in [RECEIVE,DISPOSE,RELEASE,RELEASE2]:
        obj=u.reg_read(UC_X86_REG_ECX)
        if pc==RECEIVE:
            callback('receive',obj,pc,rd(u.reg_read(UC_X86_REG_ESP)+4));finish(4,0xdeadbeef)
        else:callback('dispose' if pc==DISPOSE else 'release',obj,pc);finish(eax=0xfaceb00c)
def memory(uc,access,address,size,value,user):
    if not active or u.reg_read(UC_X86_REG_EIP) in atomic:return
    a=norm(address)
    if a in selected:
        assert size==4,(hex(address),size)
        events.append({'op':'read' if access==unicorn.UC_MEM_READ else 'write','address':a,'value':rd(address) if access==unicorn.UC_MEM_READ else value})
u.hook_add(unicorn.UC_HOOK_CODE,code)
u.hook_add(unicorn.UC_HOOK_MEM_READ|unicorn.UC_HOOK_MEM_WRITE,memory)
def call(entry,ecx,args,edx=0):
    sp=STACK+0xe000;u.mem_write(sp,struct.pack('<'+'I'*(len(args)+1),END,*args))
    u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,ecx);u.reg_write(UC_X86_REG_EDX,edx)
    u.emu_start(entry,END,count=10000)
    assert u.reg_read(UC_X86_REG_EIP)==END,hex(u.reg_read(UC_X86_REG_EIP))
    return u.reg_read(UC_X86_REG_EAX)
def setup(fill,strong=1,weak=1):
    global active,scratch_native,dest
    active=False;scratch_native=SCR;dest=DST
    u.mem_write(H,bytes([fill])*0x1000);u.mem_write(STACK,bytes([fill])*0x10000);wr(0,0)
    for c in [A,B]:wr(c,VT);wr(c+4,strong);wr(c+8,weak)
    for a,v in [(G,WRAP),(G+4,A),(DST,0),(DST+4,0),(VT,DISPOSE),(VT+4,RELEASE),(VT2,DISPOSE),(VT2+4,RELEASE2),(WRAP,RECIP),(RECIP,RVT),(RVT,RECEIVE)]:wr(a,v)
    u.mem_write(PACKET,bytes([0x95,0x78,0x56,0x34,0x12,0xa5,0,0xff]))
consumers=[]
profiles=[('null',0,0,1),('borrowed',WRAP,0,1),('control_only',0,A,1),('owned',WRAP,A,1),('shared',WRAP,A,2),('zero_count',WRAP,A,0),('wrapping_count',WRAP,A,0xffffffff)]
for fill,(name,obj,control,strong),weak,mode in itertools.product([0,165],profiles,[1,2],['observe','clear_global','drop_global','retarget_vtable','dispose_retargets','dispose_weak2']):
    if mode=='drop_global' and name not in ('owned','shared'):continue
    setup(fill,strong,weak);wr(G,obj);wr(G+4,control)
    #588290 itself selects0x95; native scratch location is discovered inside577E90.
    before=snap();events.clear();active=True
    result=call(0x588290,0x95,[0x12345678],PACKET);active=False
    assert result&255==1
    consumers.append({'fill':fill,'profile':name,'mode':mode,'before':before,'trace':list(events),'after':snap(),'result_al':result&255})
assignments=[]
for fill,strong,weak,relation,mode in itertools.product([0,165],[0,1,2,0xffffffff],[1,2],['empty','distinct','same','global'],['observe','dispose_mutates_global','dispose_retargets']):
    setup(fill,1,weak);wr(B+4,strong)
    if relation=='distinct':wr(DST,WRAP);wr(DST+4,B)
    elif relation=='same':wr(DST,WRAP);wr(DST+4,A)
    dest=G if relation=='global' else DST
    before=snap();events.clear();active=True
    call(0x5cc140,dest,[0xfedcba98]);active=False
    assignments.append({'fill':fill,'old_strong':strong,'mode':mode,'destination':dest,'relation':relation,'before':before,'trace':list(events),'after':snap()})
regions=[]
for label,address,size in [('consumer577E90',0x577e90,0x99),('acquire5CC140',0x5cc140,0x76),('packet95branch',0x58a6f2,15),('dispatch588290',0x588290,0x9a),('jump_table',0x58c1ac,496),('case_indices',0x58c39c,301)]:
    data=bytes(image[address-0x400000:address-0x400000+size]);regions.append({'label':label,'address':address,'size':size,'sha256':hashlib.sha256(data).hexdigest(),'hex':data.hex()})
proof={'native_sha256':digest,'passed':True,'complete':False,'consumers':consumers,'assignments':assignments,'source_regions':regions,'executed_instruction_addresses':sorted(seen),'limits':['Native588290,577E90 and5CC140 execute unchanged. Receiver/dispose/release terminal virtual methods are observational boundary adapters, not game handlers or concrete control destructors.','Trace records all source reads/writes to selected business words; locked xadd recorded as one atomic event with prior value. Stack-cookie, prologue and unrelated stack locals excluded.','Seeded counters include synthetic0/MAX edge values for arithmetic parity; this does not legitimize invalid owning pairs. Single-threaded emulator does not qualify concurrency.','No allocation occurs in these source bodies. Fixture virtual disposal/release records calls without pretending to free a real game object. No packet payload parsing, Windows integration or end-to-end gameplay claimed.']}
(OUT/'replay_packet95_probe.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps({'consumers':len(consumers),'assignments':len(assignments),'traced_events':sum(len(c['trace']) for c in consumers+assignments),'passed':True}))
