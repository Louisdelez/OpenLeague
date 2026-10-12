"""Execute real729D70/get/set on controlled metadata operands with exact guard pages."""
from pathlib import Path
import hashlib,itertools,json,struct
import pefile
from capstone import Cs,CS_ARCH_X86,CS_MODE_32
from unicorn import Uc,UcError,UC_ARCH_X86,UC_MODE_32,UC_HOOK_CODE,UC_HOOK_MEM_READ,UC_HOOK_MEM_WRITE,UC_HOOK_MEM_READ_PROT,UC_HOOK_MEM_WRITE_PROT,UC_PROT_NONE
from unicorn.x86_const import UC_X86_REG_EIP,UC_X86_REG_ESP,UC_X86_REG_EBP,UC_X86_REG_ECX,UC_X86_REG_EAX,UC_X86_REG_EDI
ROOT=Path(__file__).parent
SOURCE=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe')
raw=SOURCE.read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase;image=pe.get_memory_mapped_image()
u=Uc(UC_ARCH_X86,UC_MODE_32);u.mem_map(base,(len(image)+4095)&~4095);u.mem_write(base,image)
M_PAGE=0x30000000;META=M_PAGE+0xe00;P_PAGE=0x31000000;STACK=0x32000000;STOP=0x33000000
for at,size in [(M_PAGE,0x2000),(P_PAGE,0x2000),(STACK,0x10000),(STOP,0x1000)]:u.mem_map(at,size)
for at in [M_PAGE+0x1000,P_PAGE+0x1000]:u.mem_protect(at,0x1000,UC_PROT_NONE)
def word(p):return struct.unpack('<I',u.mem_read(p,4))[0]
def put(p,v):u.mem_write(p,struct.pack('<I',v))
assert word(0x10b00c4+8)==0x728150 and word(0x10b00c4+12)==0x7281c0
events=[];writes=[];counter_reads=[];faults=[];packet=0;packet_len=0
def code(uc,pc,size,user):
    sp=uc.reg_read(UC_X86_REG_ESP)
    if pc in [0x728150,0x7281c0]:
        events.append({'op':'setter' if pc==0x728150 else 'getter','pc':pc,'owner':uc.reg_read(UC_X86_REG_ECX),'args':[word(sp+4),word(sp+8)]})
    if pc in [0x9941b0,0x994210]:
        assert uc.reg_read(UC_X86_REG_ECX)==META+0x1c8
        events.append({'op':'enter' if pc==0x9941b0 else 'leave','pc':pc,'owner':META+0x1c8})
        # Existing single-thread OS primitive boundary, not a metadata consumer.
        uc.reg_write(UC_X86_REG_ESP,sp+4);uc.reg_write(UC_X86_REG_EIP,word(sp));uc.reg_write(UC_X86_REG_EAX,0)
def read(uc,access,p,size,value,user):
    if p in [META+0x1a0,META+0x1a4]:counter_reads.append({'pc':uc.reg_read(UC_X86_REG_EIP),'offset':p-META,'value':word(p),'loop_index':uc.reg_read(UC_X86_REG_EDI)})
def write(uc,access,p,size,value,user):
    if META<=p<M_PAGE+0x2000:writes.append({'pc':uc.reg_read(UC_X86_REG_EIP),'offset':p-META,'bytes':size,'value':value,'inside_object':p+size<=META+512})
def invalid(uc,access,p,size,value,user):
    faults.append({'pc':uc.reg_read(UC_X86_REG_EIP),'address':p,'bytes':size,'access':access,'value':value,'loop_index':uc.reg_read(UC_X86_REG_EDI),'region':'packet' if P_PAGE<=p<P_PAGE+0x2000 else 'metadata'})
    return False
u.hook_add(UC_HOOK_CODE,code);u.hook_add(UC_HOOK_MEM_READ,read);u.hook_add(UC_HOOK_MEM_WRITE,write)
u.hook_add(UC_HOOK_MEM_READ_PROT|UC_HOOK_MEM_WRITE_PROT,invalid)
cases=[]
for (count_a,count_b),packet_len,replacement_b in itertools.product([(24,24),(25,0),(48,0),(0,25),(0,48),(25,25),(48,48),(49,0),(0,49),(49,1)],[0x191,0x249],[0,24,25,48,0xffffffff]):
    packet=P_PAGE+0x1000-packet_len
    payload=bytearray(packet_len);payload[0]=103
    for i in range(9,packet_len-3,4):payload[i:i+4]=(0xabc00000+i).to_bytes(4,'little')
    for off,value in [(1,count_a),(5,count_b),(0x189,0x11223344),(0x18d,replacement_b)]:payload[off:off+4]=value.to_bytes(4,'little')
    u.mem_write(packet,bytes(payload));u.mem_write(META,bytes([0xa5])*512)
    put(META,0x10b00c4)
    for off in [0x1a0,0x1a4,0x1a8,0x1ac]:put(META+off,0)
    before=bytes(u.mem_read(META,512)).hex();events=[];writes=[];counter_reads=[];faults=[]
    sp=STACK+0x8000;put(sp,STOP);put(sp+4,packet)
    for reg,value in [(UC_X86_REG_ESP,sp),(UC_X86_REG_EBP,0x11223344),(UC_X86_REG_ECX,META),(UC_X86_REG_EAX,0x55667788)]:u.reg_write(reg,value)
    error=None
    try:u.emu_start(0x729d70,STOP,count=50000)
    except UcError as e:error=str(e)
    completed=u.reg_read(UC_X86_REG_EIP)==STOP
    assert completed or len(faults)==1,(count_a,count_b,packet_len,replacement_b,hex(u.reg_read(UC_X86_REG_EIP)))
    copied_a=sum(w['pc']==0x729e15 and w['inside_object'] for w in writes)
    copied_b=sum(w['pc']==0x729e45 and w['inside_object'] for w in writes)
    counter_overwrite=[w for w in writes if w['pc'] in [0x729e45,0x729e4e] and w['offset'] in [0x1a0,0x1a4]]
    if count_b in [25,48]:
        assert [(w['offset'],w['value']) for w in counter_overwrite]==[(0x1a0,0x11223344),(0x1a4,replacement_b)]
        if replacement_b<=25:assert completed and copied_b==25
        elif packet_len==0x191:assert not completed and faults[0]['region']=='packet' and faults[0]['address']==P_PAGE+0x1000 and faults[0]['pc']==0x729e40
        else:assert not completed and faults[0]['region']=='metadata' and faults[0]['address']==META+512 and faults[0]['pc']==0x729e45 and copied_b==36
    else:assert completed and not counter_overwrite
    assert copied_a==(count_a if count_a<=48 else 0)
    if completed:assert u.reg_read(UC_X86_REG_ESP)==sp+8 and u.reg_read(UC_X86_REG_EBP)==0x11223344
    cases.append({'count_a':count_a,'count_b':count_b,'packet_length':packet_len,'packet':packet,'replacement_counter_a':0x11223344,'replacement_counter_b':replacement_b,'completed':completed,'return_al':u.reg_read(UC_X86_REG_EAX)&255 if completed else None,'error':error,'first_copied_elements':copied_a,'second_copied_elements':copied_b,'counter_overwrites':counter_overwrite,'events':events,'counter_reads':counter_reads,'writes':writes,'faults':faults,'before':before,'after':bytes(u.mem_read(META,512)).hex()})
cs=Cs(CS_ARCH_X86,CS_MODE_32);regions=[];lines=[]
for va,length in [(0x729d70,0xf5),(0x728150,0x69),(0x7281c0,0x4e)]:
    data=image[va-base:va-base+length];regions.append({'address':va,'length':length,'bytes':data.hex(),'sha256':hashlib.sha256(data).hexdigest()})
    lines.append('\n'.join([f'FUNCTION0x{va:08x}']+[f'{x.address:08x} {x.mnemonic} {x.op_str}' for x in cs.disasm(data,va)]))
(ROOT/'native_disassembly.txt').write_text('\n\n'.join(lines)+'\n',encoding='utf-8')
summary={'cases':len(cases),'completed':sum(c['completed'] for c in cases),'packet_read_faults':sum(bool(c['faults'])and c['faults'][0]['region']=='packet' for c in cases),'metadata_write_faults':sum(bool(c['faults'])and c['faults'][0]['region']=='metadata' for c in cases),'counter_overwrite_cases':sum(bool(c['counter_overwrites']) for c in cases)}
proof={'passed':True,'source':str(SOURCE),'native_sha256':digest,'metadata':META,'metadata_bytes':512,'regions':regions,'summary':summary,'cases':cases,'limits':['Metadata operands are controlled initialized fields, not a constructor/destructor lifetime proof. Only729D70, real728150 and real7281C0 execute; lock primitives9941B0/994210 are explicit single-thread boundaries.','Packet lengths0x191 and0x249 are controlled audit profiles. This does not establish that the game protocol supplies either oversized profile.','Protected pages establish the exact first invalid read/write of these profiles. Execution stops immediately at the fault; damaged metadata is never destroyed or used for further callbacks.','No Rust/Windows/production change, no new consumer, and no changed ingress allowance are proposed.']}
(ROOT/'count_overwrite_native_probe.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'native_sha256':digest,**summary}))
