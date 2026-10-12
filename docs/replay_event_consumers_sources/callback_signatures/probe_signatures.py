"""Native wrapper oracle. Hooked terminals are observations, not implemented consumers."""
from pathlib import Path
import hashlib,itertools,json,struct
import pefile
from capstone import Cs,CS_ARCH_X86,CS_MODE_32
from unicorn import Uc,UcError,UC_ARCH_X86,UC_MODE_32,UC_HOOK_CODE,UC_HOOK_MEM_READ,UC_HOOK_MEM_READ_UNMAPPED,UC_HOOK_MEM_READ_PROT,UC_PROT_NONE
from unicorn.x86_const import UC_X86_REG_EIP,UC_X86_REG_ESP,UC_X86_REG_EBP,UC_X86_REG_ESI,UC_X86_REG_ECX,UC_X86_REG_EAX
ROOT=Path(__file__).parent
SOURCE=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe')
EXPECTED='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
raw=SOURCE.read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest==EXPECTED
pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase;image=pe.get_memory_mapped_image()
u=Uc(UC_ARCH_X86,UC_MODE_32);u.mem_map(base,(len(image)+4095)&~4095);u.mem_write(base,image)
PAGE=0x30000000;REF=0x31000000;STACK=0x32000000;STOP=0x33000000;SYNTHETIC=0x35000000
for at,size in [(PAGE,0x2000),(REF,0x1000),(STACK,0x10000),(STOP,0x1000),(SYNTHETIC,0x1000)]:u.mem_map(at,size)
u.mem_protect(PAGE+0x1000,0x1000,UC_PROT_NONE)
def word(at):return struct.unpack('<I',u.mem_read(at,4))[0]
def put(at,value):u.mem_write(at,struct.pack('<I',value))
active=None;trace=[];reads=[];faults=[]
def code(uc,address,size,user):
    if active and address==active['member']:
        sp=uc.reg_read(UC_X86_REG_ESP)
        trace.append({'owner':uc.reg_read(UC_X86_REG_ECX),'member':address,'args':[word(sp+4+i*4) for i in range(active['argc'])]})
        if active['hook']:
            # Explicit boundary only. Never claims to execute this member body.
            uc.reg_write(UC_X86_REG_EAX,active['return'])
            uc.reg_write(UC_X86_REG_ESP,sp+4+4*active['argc'])
            uc.reg_write(UC_X86_REG_EIP,word(sp))
def memory(uc,access,address,size,value,user):
    if PAGE<=address<PAGE+0x2000 or REF<=address<REF+0x1000:reads.append([address,size])
def invalid(uc,access,address,size,value,user):faults.append([address,size]);return False
u.hook_add(UC_HOOK_CODE,code);u.hook_add(UC_HOOK_MEM_READ,memory)
u.hook_add(UC_HOOK_MEM_READ_UNMAPPED|UC_HOOK_MEM_READ_PROT,invalid)
specs={0x65e9e0:(16,2,0x109b2d4,0x738a3a),0x7341d0:(16,2,0x10afcfc,0x72b950),0x734080:(12,6,0x10afd14,SYNTHETIC),0x733f70:(12,0,0x10afd34,SYNTHETIC+0x20)}
def run(wrapper,owner,adjustment,result,variant,real_leaf=False):
    global active,trace,reads,faults
    size,argc,vt,member=specs[wrapper];p=PAGE+0x1000-size
    if real_leaf:member={0x734080:0x71ec30,0x733f70:0x586230}[wrapper]
    fields=[vt,owner,member]+([adjustment] if size==16 else [])
    for i,v in enumerate(fields):put(p+i*4,v)
    put(REF,0xa5c37129);put(REF+4,0x8f4e5a67)
    if wrapper==0x65e9e0:args=[[0,0xffffffff],[0xdead1234,0xfeedbeef]][variant]
    elif wrapper==0x7341d0:args=[0xdead1234,[REF,p,p+4,p+8,p+12][variant]]
    elif wrapper==0x734080:
        r0,r1=[(REF,REF+4),(REF,REF),(REF+4,REF),(p,p+4),(p+8,p),(p+4,p+8)][variant]
        args=[r0,r1,0xdead1234,0xfeedbeef,0xffffffff,0xa1234567]
    else:args=[]
    forwarded=args.copy()
    if wrapper==0x7341d0:forwarded[1]=word(args[1])
    if wrapper==0x734080:forwarded[0]=word(args[0]);forwarded[1]=word(args[1])
    expected_reads={0x65e9e0:[[p+12,4],[p+4,4],[p+8,4]],0x7341d0:([[args[1],4]] if args else [])+[[p+12,4],[p+4,4],[p+8,4]],0x734080:([[args[1],4],[args[0],4]] if len(args)>2 else [])+[[p+4,4],[p+8,4]],0x733f70:[[p+4,4],[p+8,4]]}[wrapper]
    sp=STACK+0x8000;put(sp,STOP)
    for i,v in enumerate(args):put(sp+4+i*4,v)
    active={'member':member,'argc':argc,'hook':not real_leaf,'return':result};trace=[];reads=[];faults=[]
    before=bytes(u.mem_read(p,size)).hex()
    for reg,value in [(UC_X86_REG_ESP,sp),(UC_X86_REG_EBP,0x11223344),(UC_X86_REG_ESI,0x55667788),(UC_X86_REG_ECX,p),(UC_X86_REG_EAX,0xabcdef12)]:u.reg_write(reg,value)
    u.emu_start(wrapper,STOP,count=128)
    actual=u.reg_read(UC_X86_REG_EAX);after=bytes(u.mem_read(p,size)).hex()
    assert reads==expected_reads,(hex(wrapper),reads,expected_reads)
    expected_owner=(owner+(adjustment if size==16 else 0))&0xffffffff
    assert trace==[{'owner':expected_owner,'member':member,'args':forwarded}],trace
    assert actual==(member&0xffffff00 if real_leaf else result)
    assert not faults and before==after
    assert u.reg_read(UC_X86_REG_ESP)==sp+4+argc*4 and u.reg_read(UC_X86_REG_EBP)==0x11223344 and u.reg_read(UC_X86_REG_ESI)==0x55667788
    return {'wrapper':wrapper,'callback':p,'size':size,'owner':owner,'adjustment':adjustment,'member':member,'supplied_return':None if real_leaf else result,'args':args,'reads':reads,'trace':trace,'return':actual,'before':before,'after':after,'final_stack_delta':4+argc*4,'tail_reads':faults,'terminal_body_executed':real_leaf}
cases=[]
for wrapper in specs:
    adjustments=[0,1,0xfffffff0] if specs[wrapper][0]==16 else [0]
    variants=range({0x65e9e0:2,0x7341d0:5,0x734080:6,0x733f70:1}[wrapper])
    for owner,adjustment,result,variant in itertools.product([0,0x30008500,0xffffffff],adjustments,[0,1,0xabcdef00,0xf1234501],variants):cases.append(run(wrapper,owner,adjustment,result,variant))
leaves=[]
for wrapper in [0x734080,0x733f70]:
    for owner,variant in itertools.product([0,0x30008500,0xffffffff],range(3 if wrapper==0x734080 else 1)):leaves.append(run(wrapper,owner,0,None,variant,True))
direct=[]
for leaf,argc in [(0x586230,0),(0x71ec30,6)]:
    for eax in [0,1,0xff,0xabcdef00,0xabcdef01,0xffffffff]:
        active=None;trace=[];reads=[];faults=[];sp=STACK+0x8000;put(sp,STOP)
        u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EAX,eax)
        u.emu_start(leaf,STOP,count=16)
        actual=u.reg_read(UC_X86_REG_EAX);delta=u.reg_read(UC_X86_REG_ESP)-sp
        assert actual==eax&0xffffff00 and delta==4+4*argc and not reads and not faults
        direct.append({'leaf':leaf,'incoming_eax':eax,'return':actual,'final_stack_delta':delta})
# Each16-byte wrapper must fail at+12 on a12-byte object, proving the guard works.
negatives=[]
for wrapper in [0x65e9e0,0x7341d0]:
    p=PAGE+0xff4;put(p,0x108606c);put(p+4,1);put(p+8,SYNTHETIC)
    sp=STACK+0x8000;put(sp,STOP);put(sp+4,0xdead1234);put(sp+8,REF)
    active={'member':SYNTHETIC,'argc':2,'hook':True,'return':1};trace=[];reads=[];faults=[]
    u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,p)
    try:u.emu_start(wrapper,STOP,count=128);raise AssertionError('protected tail crossed')
    except UcError as error:
        assert faults==[[p+12,4]] and not trace
        negatives.append({'wrapper':wrapper,'callback':p,'faults':faults,'terminal_calls':0,'error':str(error)})
ranges={0x65e9e0:0x11,0x7341d0:0x23,0x734080:0x31,0x733f70:0xA,0x586230:3,0x71ec30:5,0x729c80:0x26,0x5cc070:0x6B,0x738a3a:5,0x72b2d0:0x17,0x72c2b3:0x70}
cs=Cs(CS_ARCH_X86,CS_MODE_32);regions=[];disassembly=[]
for va,length in ranges.items():
    data=image[va-base:va-base+length]
    regions.append({'address':va,'length':length,'bytes':data.hex(),'sha256':hashlib.sha256(data).hexdigest()})
    disassembly.append('\n'.join([f'FUNCTION 0x{va:08x} length {length}']+[f'{x.address:08x} {x.mnemonic} {x.op_str}' for x in cs.disasm(data,va)]))
(ROOT/'native_disassembly.txt').write_text('\n\n'.join(disassembly)+'\n',encoding='utf-8')
proof={'passed':True,'source':str(SOURCE),'native_sha256':digest,'regions':regions,'cases':cases,'real_leaf_wrappers':leaves,'direct_leaves':direct,'negative_controls':negatives,'limits':['Only wrapper opcodes and the two real AL0 leaf bodies execute. Other terminal entries are explicitly intercepted; supplied return values qualify forwarding only.','Synthetic target labels are used for zero/six argument generic wrapper coverage and are not claimed to identify recovered consumers.','Read tracing covers referenced words and callback data, not all native stack accesses. Twelve/sixteen byte objects end at a protected page boundary.','65E9E0 is a generic native tailcall. Its two argument usage is selected by the actual service factory/call site; the wrapper alone does not encode an argument count.']}
(ROOT/'signatures_native_probe.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'native_sha256':digest,'boundary_cases':len(cases),'real_leaf_wrappers':len(leaves),'direct_leaves':len(direct),'negative_controls':len(negatives)}))
