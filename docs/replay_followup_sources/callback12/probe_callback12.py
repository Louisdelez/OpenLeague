"""Execute only the native5CCEB0 wrapper; terminal members are explicit trace boundaries."""
from pathlib import Path
import hashlib,itertools,json,struct,sys
import pefile
from unicorn import Uc,UcError,UC_ARCH_X86,UC_MODE_32,UC_HOOK_CODE,UC_HOOK_MEM_READ,UC_HOOK_MEM_READ_UNMAPPED,UC_HOOK_MEM_READ_PROT,UC_PROT_NONE
from unicorn.x86_const import UC_X86_REG_EIP,UC_X86_REG_ESP,UC_X86_REG_EBP,UC_X86_REG_ECX,UC_X86_REG_EAX

SOURCE=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe')
EXPECTED='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
raw=SOURCE.read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest==EXPECTED
pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase;image=pe.get_memory_mapped_image()
u=Uc(UC_ARCH_X86,UC_MODE_32);u.mem_map(base,(len(image)+4095)&~4095);u.mem_write(base,image)
PAGE=0x30000000;CALLBACK=PAGE+0xff4;REF=0x31000000;STACK=0x32000000;STOP=0x33000000
for at,size in [(PAGE,0x2000),(REF,0x1000),(STACK,0x10000),(STOP,0x1000)]:u.mem_map(at,size)
u.mem_protect(PAGE+0x1000,0x1000,UC_PROT_NONE)
def word(at):return struct.unpack('<I',u.mem_read(at,4))[0]
def put(at,value):u.mem_write(at,struct.pack('<I',value))
active=None;trace=[];reads=[];tail_faults=[]
def code(uc,address,size,user):
    if active and address==active['member']:
        sp=uc.reg_read(UC_X86_REG_ESP)
        trace.append({'owner':uc.reg_read(UC_X86_REG_ECX),'member':address,'args':[word(sp+4+i*4) for i in range(5)]})
        # Deliberately supplied terminal return qualifies the wrapper only.
        # The real member body is not executed or replaced by a claimed consumer.
        uc.reg_write(UC_X86_REG_EAX,active['return']);uc.reg_write(UC_X86_REG_ESP,sp+24);uc.reg_write(UC_X86_REG_EIP,word(sp))
def memory(uc,access,address,size,value,user):
    if active and (PAGE<=address<PAGE+0x2000 or REF<=address<REF+0x1000):reads.append([address,size])
def invalid(uc,access,address,size,value,user):tail_faults.append([address,size]);return False
u.hook_add(UC_HOOK_CODE,code);u.hook_add(UC_HOOK_MEM_READ,memory)
u.hook_add(UC_HOOK_MEM_READ_UNMAPPED|UC_HOOK_MEM_READ_PROT,invalid)
cases=[]
for owner,member,result,reference in itertools.product([0,0x30008500,0xffffffff],[0x729370,0x72c780],[0,1,0xabcdef00,0xf1234501],['separate','owner','member','vtable']):
    for off,value in [(0,0x108606c),(4,owner),(8,member)]:put(CALLBACK+off,value)
    put(REF,0xa5c37129)
    arg0={'separate':REF,'owner':CALLBACK+4,'member':CALLBACK+8,'vtable':CALLBACK}[reference]
    args=[arg0,0xabcdef02,0x76543203,0xfffffff1,0x3000d123]
    sp=STACK+0x8000;put(sp,STOP)
    for i,value in enumerate(args):put(sp+4+i*4,value)
    active={'owner':owner,'member':member,'return':result};trace=[];reads=[];tail_faults=[]
    before=bytes(u.mem_read(CALLBACK,12)).hex()
    u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBP,0x11223344);u.reg_write(UC_X86_REG_ECX,CALLBACK);u.reg_write(UC_X86_REG_EAX,0x55667788)
    u.emu_start(0x5cceb0,STOP,count=128)
    actual=u.reg_read(UC_X86_REG_EAX);after=bytes(u.mem_read(CALLBACK,12)).hex()
    assert actual==result and len(trace)==1 and not tail_faults and before==after
    assert u.reg_read(UC_X86_REG_ESP)==sp+24 and u.reg_read(UC_X86_REG_EBP)==0x11223344
    assert reads==[[arg0,4],[CALLBACK+4,4],[CALLBACK+8,4]]
    cases.append({'owner':owner,'member':member,'supplied_return':result,'reference':reference,'args':args,'reads':reads,'trace':trace,'return':actual,'before':before,'after':after,'final_stack_delta':24,'tail_reads':tail_faults})

# Negative control: using16-byte734130 on this protected12-byte object must fault
# specifically at +12 before any terminal is called.
trace=[];reads=[];tail_faults=[];sp=STACK+0x8000;put(sp,STOP)
for i,value in enumerate([REF,2,3,4,5]):put(sp+4+i*4,value)
u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,CALLBACK)
try:
    u.emu_start(0x734130,STOP,count=128)
    raise AssertionError('16-byte wrapper unexpectedly crossed protected tail')
except UcError as error:
    assert tail_faults==[[CALLBACK+12,4]] and not trace
    negative={'wrapper':0x734130,'faults':tail_faults,'terminal_calls':0,'error':str(error)}
result={'passed':True,'native_sha256':digest,'wrapper':0x5cceb0,'callback':CALLBACK,'reference':REF,'vtable':0x108606c,'cases':cases,'negative_control':negative,'limits':['Only actual source5CCEB0 executes; actual member addresses729370/72C780 are intercepted at entry as explicit boundaries. No terminal member body, metadata, network, frame or gameplay consumer executes.','Terminal returns are supplied and qualified solely for unchanged full32-bit propagation; caller data is controlled. Twelve-byte callback ends at a protected page boundary. No claim of native recovery from an invalid pointer.']}
Path(sys.argv[1]).write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'native_sha256':digest,'cases':len(cases),'negative_control':negative}))
