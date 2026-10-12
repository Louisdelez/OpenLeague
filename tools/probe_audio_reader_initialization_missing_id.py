from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
node=vector+0x10000;params=vector+0x11000;state=vector+0x12000;props=vector+0x13000;factory=vector+0x14000;table=vector+0x15000
lock=vector+0x18000;registry=vector+0x19000
u.mem_write(lock,b'\xc2\x04\x00');w(0xfa4424,lock);w(0xfa4428,lock);w(0x14a7a08,registry)
voice=vector+0x16000;owner=vector+0x17000;allocs=[]
def hook(uc,a,size,user):
 if a==0xada670:
  sp=uc.reg_read(UC_X86_REG_ESP);size=read(sp+8);assert size==424;allocs.append(size);u.mem_write(voice,bytes(424));finish(voice)
 elif a==0xaf3d32:uc.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,hook)

rows=[]
for priority,mode in itertools.product([25.,50.,75.],[0]):
 for addr,size in [(node,128),(params,176),(state,64),(props,16),(factory,32),(table,32)]:u.mem_write(addr,bytes(size))
 u.mem_write(state+0x38,b"\x01");w(node,0xff1cd8);w(node+0x1c,state);w(node+0x28,props);u.mem_write(props,b'\x01\x05');u.mem_write(props+4,struct.pack('<f',priority));w(params,mode);w(params+4,factory);w(factory,0xff1cd8);u.mem_write(owner,bytes(128));w(params+8,owner);allocs.clear()
 for a in [0x14a79d8,0x14a7d3c]:u.mem_write(a,struct.pack('<f',1.))
 w(0x14a7a70,0);w(0x14a7a6c,0);u.mem_write(0x12100ec,struct.pack('<H',128))
 u.mem_write(0x12100e0,bytes(16));w(0x12100e0,vector+0x1b000);w(0x12100e8,8);u.mem_write(vector+0x1b000,bytes(96))
 w(stack,end);w(stack+4,params);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,node);u.emu_start(0xb228e0,end,count=4000)
 assert u.reg_read(UC_X86_REG_EIP)==0xaf3d32
 assert u.reg_read(UC_X86_REG_EAX)==2
 assert read(0x12100e4)==1 and read(vector+0x1b000)==voice
 assert allocs==[424] and read(voice)==0xff0cdc and read(voice+0x60)==node and read(voice+0x64)==node+0x58 and read(voice+0x68)==owner
 assert struct.unpack('<f',u.mem_read(voice+0x134,4))[0]==priority
 rows.append(dict(priority=priority,mode=mode,allocations=allocs.copy(),voice_bytes=bytes(u.mem_read(voice,424)).hex()))
proof=dict(passed=True,case_count=len(rows),native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['Actual reader/factory/constructor now executes voicevirtual8 AEDA10 and global AFE110 priority-list insertion.','Missing playingID voice48 returns2 after priority registration, so reader must unwind this partially initialized state.'],adapters=['Allocator maps424bytevoice; lock importsret4; preallocated global priority array with8slots.','Mode0 and playingID0; stopAF3D32 after initreturn before readercleanup.'],limits=['Positive playingID, successful initialization, failure unwind and physical sound remain open.'])
(r/'data/4.20/audio_reader_initialization_missing_id.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'native missing-ID initialization cases')
