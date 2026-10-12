"""Execute unchanged57D650/5B3230 and lookup, only existing records/nonempty SSO.
No terminal UI/provider/allocator adapter is installed. Unexpected calls fail.
"""
from pathlib import Path
import sys,struct,json,hashlib,datetime
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn
from unicorn.x86_const import *
OUT=Path(__file__).resolve().parent
EXE=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe')
raw=EXE.read_bytes();sha=hashlib.sha256(raw).hexdigest();assert sha=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
p=pefile.PE(data=raw);image=p.get_memory_mapped_image();base=p.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32)
u.mem_map(base,(len(image)+4095)&~4095);u.mem_write(base,image)
H=0x30000000;STACK=0x31000000;END=0x32000000
for a in (0,H,STACK,END):u.mem_map(a,0x10000)
RECIP=H+0x100;HEAD=H+0x1000;NODES=[H+0x1200+i*0x100 for i in range(9)];PAYLOAD=H+0x3000
KEYS=[0,1,0x7ffffffe,0x7fffffff,0x80000000,0x80000001,0xdeadbeef,0xfffffffe,0xffffffff]
ENTRY={'standard':0x57d650,'tutorial':0x5b3230};LOOKUP={'standard':0x5be170,'tutorial':0x5be1f0}
VT={'standard':0x1084ea4,'tutorial':0x10863fc}
TREE_OFFSET={'standard':0x1c,'tutorial':4};NODE_BYTES={'standard':140,'tutorial':96};VALUE_BYTES={'standard':120,'tutorial':76}
STRING_OFFSET={'standard':0x30,'tutorial':0x28}
active=False;trace=[];writes=[];code_seen=set();kind='standard';target=0
def rd(a):return struct.unpack('<I',u.mem_read(a,4))[0]
def wr(a,v):u.mem_write(a,struct.pack('<I',v&0xffffffff))
def in_range(a,lo,hi):return lo<=a<hi
allowed=[(0x57d650,0x57dd0c),(0x5b3230,0x5b32cb),(0x5be170,0x5be1e7),(0x5be1f0,0x5be26b),(0xc975f5,0xc97610)]
def code(uc,pc,size,user):
    if not active:return
    assert any(lo<=pc<hi for lo,hi in allowed),f'unexpected native target {pc:08x}'
    code_seen.add(pc)
    if pc in (0x5be1b9,0x5be239):raise AssertionError('unexpected missing-key allocation branch')
    if pc in (0x57d6cb,0x5b3278):raise AssertionError('unexpected UI/provider branch')
    if pc==LOOKUP[kind]:trace.append({'op':'lookup','this':u.reg_read(UC_X86_REG_ECX),'key_pointer':rd(u.reg_read(UC_X86_REG_ESP)+4)})
def mem(uc,access,address,size,value,user):
    if not active:return
    if access==unicorn.UC_MEM_WRITE:
        assert H<=address<H+0x4000 or STACK<=address<STACK+0x10000 or address==0,('unexpected write',hex(address),size)
    if H<=address<H+0x4000:
        if access==unicorn.UC_MEM_WRITE:
            writes.append([address,size,value]);trace.append({'op':'write','address':address,'bytes':size,'value':value})
        elif address==RECIP+TREE_OFFSET[kind] or HEAD<=address<H+0x1b00:
            trace.append({'op':'read','address':address,'bytes':size,'value':int.from_bytes(u.mem_read(address,size),'little')})
u.hook_add(unicorn.UC_HOOK_CODE,code)
u.hook_add(unicorn.UC_HOOK_MEM_READ|unicorn.UC_HOOK_MEM_WRITE,mem)
def build_tree(fill):
    u.mem_write(H,bytes([fill])*0x4000);u.mem_write(STACK,bytes([fill])*0x10000);wr(0,0)
    tree=RECIP+TREE_OFFSET[kind];wr(RECIP,VT[kind]);wr(tree,HEAD);wr(tree+4,len(KEYS))
    wr(HEAD,NODES[0]);wr(HEAD+8,NODES[-1]);u.mem_write(HEAD+12,b'\x01\x01')
    for node,key in zip(NODES,KEYS):
        wr(node+16,key);u.mem_write(node+12,b'\x01\x00')
        record=node+20;s=record+STRING_OFFSET[kind]
        u.mem_write(s,b'present\0');wr(s+16,7);wr(s+20,15)
        if kind=='standard':u.mem_write(record+0x60,b'\0');wr(record+0x70,0);wr(record+0x74,15)
    def branch(indices,parent,depth=0):
        if not indices:return HEAD
        m=len(indices)//2;node=NODES[indices[m]];wr(node+4,parent)
        # Native red=0/black=1. Only the two extra-depth leaves are red,
        # giving equal black heights, not merely a sorted but invalid RB shape.
        u.mem_write(node+12,bytes([0 if depth==3 else 1]))
        wr(node,branch(indices[:m],node,depth+1));wr(node+8,branch(indices[m+1:],node,depth+1));return node
    wr(HEAD+4,branch(list(range(len(KEYS))),HEAD))
    def validate(node,parent,lower,upper):
        if node==HEAD:return 1
        assert rd(node+4)==parent and lower<rd(node+16)<upper
        color=u.mem_read(node+12,1)[0]
        if color==0:assert all(u.mem_read(rd(node+offset)+12,1)[0]==1 for offset in [0,8])
        left=validate(rd(node),node,lower,rd(node+16));right=validate(rd(node+8),node,rd(node+16),upper)
        assert left==right
        return left+color
    validate(rd(HEAD+4),HEAD,-1,0x100000000)
def payload(key,flags,pattern):
    if pattern==0:tail=bytes((i*37+flags*11)&255 for i in range(20))
    elif pattern==1:tail=b'\xff'*20
    elif pattern==2:tail=struct.pack('<5I',0,0x80000000,0x7f800000,0xff800000,0x7fc12345)
    else:tail=struct.pack('<5I',0x7f800001,0xffffffff,0x80000000,0x7f812345,0xdeadbeef)
    return struct.pack('<I',key)+tail+bytes([flags])
def run_case(fill,key_index,flags,pattern):
    global active,target
    build_tree(fill);target=NODES[key_index]+20;data=payload(KEYS[key_index],flags,pattern);u.mem_write(PAYLOAD,data)
    before=bytes(u.mem_read(H,0x4000));record_before=bytes(u.mem_read(target,VALUE_BYTES[kind]));trace.clear();writes.clear()
    sp=STACK+0xe000;wr(sp,END);wr(sp+4,PAYLOAD)
    u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,RECIP);u.reg_write(UC_X86_REG_EFLAGS,2)
    active=True
    try:u.emu_start(ENTRY[kind],END,count=50000)
    except Exception as e:raise RuntimeError((kind,fill,KEYS[key_index],flags,pattern,hex(u.reg_read(UC_X86_REG_EIP)))) from e
    finally:active=False
    assert u.reg_read(UC_X86_REG_EIP)==END
    assert u.reg_read(UC_X86_REG_ESP)==sp+8
    assert rd(0)==0
    after=bytes(u.mem_read(H,0x4000));expected=bytearray(before);offset=target-H
    expected[offset:offset+25]=data
    if flags&1:expected[offset+16:offset+20]=b'\0'*4
    assert after==expected,(kind,flags,key_index,'unexpected mutation')
    expected_writes=[[target+i,4,int.from_bytes(data[i:i+4],'little')] for i in range(0,24,4)]+[[target+24,1,flags]]
    if flags&1:expected_writes.append([target+16,4,0])
    assert writes==expected_writes,(writes,expected_writes)
    return {'kind':kind,'fill':fill,'key':KEYS[key_index],'key_index':key_index,'flag':flags,'pattern':pattern,'record':target,'payload_hex':data.hex(),'record_before_hex':record_before.hex(),'record_after_hex':bytes(u.mem_read(target,VALUE_BYTES[kind])).hex(),'trace':list(trace),'entire_arena_before_sha256':hashlib.sha256(before).hexdigest(),'entire_arena_after_sha256':hashlib.sha256(after).hexdigest(),'non_target_bytes_unchanged':True,'payload_unchanged':bytes(u.mem_read(PAYLOAD,25))==data,'stack_bytes_popped':8}
cases=[]
for kind in ['standard','tutorial']:
    for fill in [0,165]:
        # Every flag byte is native-executed, with keys/patterns distributed.
        for flags in range(256):cases.append(run_case(fill,flags%len(KEYS),flags,(flags//len(KEYS))%4))
        # Explicit complete key x interesting-flag x payload-pattern matrix.
        for key_index in range(len(KEYS)):
            for flags in [0,1,128,255]:
                for pattern in range(4):cases.append(run_case(fill,key_index,flags,pattern))
regions=[]
for role,a,size in [('standard_consumer',0x57d650,0x6bc),('tutorial_consumer',0x5b3230,0x9b),('standard_lookup',0x5be170,0x77),('tutorial_lookup',0x5be1f0,0x7b),('cookie_check',0xc975f5,0x1b)]:
    b=image[a-base:a-base+size];regions.append({'role':role,'address':a,'size':size,'hex':b.hex(),'sha256':hashlib.sha256(b).hexdigest()})
proof={'native_sha256':sha,'passed':True,'complete':False,'scope':'Existing records, nonempty string lengths, no UI branch','layout':{'arena':H,'arena_bytes':0x4000,'recipient':RECIP,'head':HEAD,'nodes':NODES,'keys':KEYS,'payload':PAYLOAD,'tree_offsets':TREE_OFFSET,'node_bytes':NODE_BYTES,'value_bytes':VALUE_BYTES,'string_offsets':STRING_OFFSET,'vtables':VT},'cases':cases,'source_regions':regions,'executed_instruction_addresses':sorted(code_seen),'limits':['Original consumers, ordered lookup,25-byte copy,flag mask and security-cookie check executed unchanged. No target/provider/allocator hooks installed.','Recipient and balanced tree are explicitly seeded test contexts; their real constructors, allocation/insertion/rotation/destruction and UI initialization are not qualified here.','Both nonzero SSO lengths are populated with real inline ASCII present/length7/capacity15. No invented provider output bypasses the branch.','All16384 seeded arena bytes are compared each call: exactly destination25bytes plus conditional four-byte reset may change. Other records, tree, recipient, payload and padding remain intact.','All256 flag bytes and IEEE-looking payload bit patterns are copied without interpreting them as valid gameplay fields. No semantic payload labels, concurrency, network or real rendering evidence claimed.']}
(OUT/'replay_loading_existing_record_probe.json').write_text(json.dumps(proof,indent=2)+'\n')
summary={'passed':True,'cases':len(cases),'standard':sum(c['kind']=='standard' for c in cases),'tutorial':sum(c['kind']=='tutorial' for c in cases),'flags':256,'keys':len(KEYS),'patterns':4,'fills':[0,165],'arena_bytes_compared_each_call':0x4000,'ui_calls':0,'allocator_calls':0,'native_instructions_seen':len(code_seen)}
(OUT/'native_result.json').write_text(json.dumps(summary,indent=2)+'\n');print(json.dumps(summary))
