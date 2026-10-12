"""Original tutorial caller + lookup +564900; explicit name/clock primitives.
This oracle qualifies the consumer's boundary contract, not service72AD90/QPC.
"""
from pathlib import Path
import json,struct,hashlib,itertools
OUT=Path(__file__).resolve().parent
seed=Path('E:/mapslol3v3/replay_loading_record_probe/probe_existing_records.py')
source=seed.read_text().split('\ncases=[]')[0]
source=source.replace('u.hook_add(unicorn.UC_HOOK_CODE,code)','').replace('u.hook_add(unicorn.UC_HOOK_MEM_READ|unicorn.UC_HOOK_MEM_WRITE,mem)','')
exec(compile(source,str(seed),'exec'))
OUT=Path('E:/mapslol3v3/loading_consumer_agent')
kind='tutorial';NAME=END+0x100;CLOCK=END+0x200;CLOCKDATA=H+0x3800;DATA=H+0x3900;SERVICE=H+0x3500;TABLE=H+0x3600;SCR=H+0x3400
u.mem_write(CLOCK,b'\xd9\x05'+struct.pack('<I',CLOCKDATA)+b'\xc3') #FLD primitive clock value; source caller does FSTP.
active=False;events=[];freed=[];scratch_native=None;name_bytes=b'';mutate=False;before_blocks={};seen=set()
def finish(pop=0,eax=0):
    sp=u.reg_read(UC_X86_REG_ESP);ret=rd(sp);u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EAX,eax);u.reg_write(UC_X86_REG_EIP,ret)
def normalized(a):
    if scratch_native is not None and scratch_native<=a<scratch_native+24:return SCR+a-scratch_native
    return a
def callback(uc,pc,size,user):
    global scratch_native
    if not active:return
    seen.add(pc)
    if pc==NAME:
        sp=u.reg_read(UC_X86_REG_ESP);output,key=rd(sp+4),rd(sp+8);scratch_native=output
        events.append({'op':'name','service':u.reg_read(UC_X86_REG_ECX),'target':NAME,'output':SCR,'key':key})
        # Explicit successful String24 return, owned by consumer after return.
        u.mem_write(output,bytes([fill])*24)
        if len(name_bytes)<16:u.mem_write(output,name_bytes+b'\0');wr(output+20,15)
        else:wr(output,DATA);u.mem_write(DATA,name_bytes+b'\0');wr(output+20,47)
        wr(output+16,len(name_bytes))
        if mutate:wr(target+16,0x7fc00001);wr(target+12,0x80000001)
        finish(8,output);return
    if pc==0x993ce0:
        events.append({'op':'clock','bits':rd(CLOCKDATA)});u.reg_write(UC_X86_REG_EIP,CLOCK);return
    if pc==0xc98528:
        pointer=rd(u.reg_read(UC_X86_REG_ESP)+4);events.append({'op':'free','pointer':pointer});freed.append(pointer);finish();return
    if pc==0x564900:events.append({'op':'destroy_string','pointer':SCR})
    assert (0x5b3230<=pc<0x5b32cb or 0x5be1f0<=pc<0x5be26b or 0x564900<=pc<0x564950 or 0xc975f5<=pc<0xc97610 or CLOCK<=pc<CLOCK+7),hex(pc)
    assert pc!=0x5be239,'unexpected allocation'
def access(uc,typ,address,size,value,user):
    if not active:return
    address_n=normalized(address)
    watched=(target<=address<target+76 or SCR<=address_n<SCR+24 or address in [0x2d787b8,SERVICE,TABLE+0x48,PAYLOAD])
    if watched:events.append({'op':'read' if typ==unicorn.UC_MEM_READ else 'write','address':address_n,'bytes':size,'value':int.from_bytes(u.mem_read(address,size),'little') if typ==unicorn.UC_MEM_READ else value})
u.hook_add(unicorn.UC_HOOK_CODE,callback);u.hook_add(unicorn.UC_HOOK_MEM_READ|unicorn.UC_HOOK_MEM_WRITE,access)
cases=[]
pairs=[(0,0x80000000),(0x3f800000,0xbf800000),(1,0x80000001),(0x7f800000,0xff800000),(0x7f800001,0xff800123),(0x7fc12345,0xffc23456)]
for fill,flags,pair,name_bytes,mutate in itertools.product([0,165],[0,1,128,255],pairs,[b'',b'Name',b'LoadingRecipientNameLongerThan15'],[False,True]):
    # Unicorn differs from physical x87 on signaling NaNs. Hardware oracle
    # separately qualifies those conversions; do not falsify native parity here.
    if name_bytes and any(v&0x7f800000==0x7f800000 and v&0x7fffff and not v&0x400000 for v in pair):continue
    build_tree(fill);target=NODES[4]+20;wr(target+0x38,0);wr(0x14bef40,0);wr(0x2d787b8,SERVICE);wr(SERVICE,TABLE);wr(TABLE+0x48,NAME);wr(CLOCKDATA,0x42f6e979)
    data=bytearray(payload(KEYS[4],flags,2));struct.pack_into('<II',data,12,*pair);u.mem_write(PAYLOAD,bytes(data))
    original=bytes(u.mem_read(target,76));initial_payload=bytes(data);events.clear();freed.clear();scratch_native=None
    sp=STACK+0xe000;wr(sp,END);wr(sp+4,PAYLOAD);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,RECIP);u.reg_write(UC_X86_REG_EFLAGS,2);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff)
    active=True
    try:u.emu_start(0x5b3230,END,count=50000)
    finally:active=False
    assert u.reg_read(UC_X86_REG_EIP)==END and u.reg_read(UC_X86_REG_ESP)==sp+8
    assert len(freed)==int(len(name_bytes)>=16)
    observed=bytes(u.mem_read(target,76));expected=bytearray(original);expected[:25]=data
    if flags&1:expected[16:20]=b'\0'*4
    if mutate:struct.pack_into('<II',expected,12,0x80000001,0x7fc00001)
    def loaded(bits):return bits|0x400000 if bits&0x7f800000==0x7f800000 and bits&0x7fffff else bits
    if name_bytes:
        struct.pack_into('<I',expected,0x44,loaded(struct.unpack_from('<I',expected,16)[0]));struct.pack_into('<I',expected,0x40,loaded(struct.unpack_from('<I',expected,12)[0]));struct.pack_into('<I',expected,0x48,0x42f6e979)
    assert observed==expected,(fill,flags,pair,name_bytes,observed.hex(),expected.hex())
    cases.append({'fill':fill,'flags':flags,'pair_bits':pair,'name_hex':name_bytes.hex(),'mutate_record':mutate,'record':target,'record_before_hex':original.hex(),'payload_hex':initial_payload.hex(),'record_after_hex':observed.hex(),'scratch_after_hex':bytes(u.mem_read(scratch_native,24)).hex(),'events':list(events),'freed':list(freed)})
proof={'passed':True,'complete':False,'native_sha256':sha,'cases':cases,'layout':{'recipient':RECIP,'record':NODES[4]+20,'payload':PAYLOAD,'scratch':SCR,'service':SERVICE,'service_table':TABLE,'name_method':NAME,'name_buffer':DATA,'clock_bits':0x42f6e979},'native_instruction_addresses':sorted(seen),'limits':['Original5B3230/5BE1F0/564900/cookie execute. Provider virtual+48 constructs explicitly controlled String24 responses; actual72AD90 is qualified separately by root.','993CE0 is an explicit clock primitive returning FLD f32 to original caller FSTP, not a QPC implementation. Default x87 masked exceptions0x37F; condition-code/exception-flag side effects are not ported by the Rust bit transform.','Tree/context seeded with an existing key. Native insertion/lifetime qualified separately. Provider can mutate record before native re-reads, proving the post-callback values drive copies.']}
(OUT/'tutorial_first_name_probe.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps({'cases':len(cases),'events':sum(len(c['events']) for c in cases),'passed':True}))
