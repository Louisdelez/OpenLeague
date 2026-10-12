from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
node=vector+0x10000;params=vector+0x11000;state=vector+0x12000;props=vector+0x13000;factory=vector+0x14000;table=vector+0x15000
lock=vector+0x18000;registry=vector+0x19000
u.mem_write(lock,b'\xc2\x04\x00');w(0xfa4424,lock);w(0xfa4428,lock);w(0x14a7a08,registry)
voice=vector+0x16000;owner=vector+0x17000;allocs=[]
def hook(uc,a,size,user):
 if a==0xb16380:uc.emu_stop();return
 if a==0xada670:
  sp=uc.reg_read(UC_X86_REG_ESP);size=read(sp+8);assert size in (424,960);allocs.append(size);target=voice if size==424 else vector+0x22000;u.mem_write(target,bytes(size));finish(target)

u.hook_add(unicorn.UC_HOOK_CODE,hook)
def invalid(uc,access,address,size,value,user):
 print('invalid',hex(uc.reg_read(UC_X86_REG_EIP)),hex(address));return False
u.hook_add(unicorn.UC_HOOK_MEM_INVALID,invalid)

manager=vector+0x1c000;record=vector+0x1c100;media=vector+0x1d000
rows=[]
for priority,mode,playing_id,registered,queue_available,start_paused in itertools.product([25.,75.],[0],[1,31,0xffffffff],[True],[True],[False,True]):
 for addr,size in [(node,128),(params,176),(state,64),(props,16),(factory,32),(table,32)]:u.mem_write(addr,bytes(size))
 u.mem_write(state+0x38,b"\x01");w(node,0xff1cd8);w(node+0x1c,state);w(node+0x28,props);u.mem_write(props,b'\x01\x05');u.mem_write(props+4,struct.pack('<f',priority));w(params,mode);w(params+4,factory);w(factory,0xff1cd8);u.mem_write(owner,bytes(128));w(params+8,owner);allocs.clear()
 u.mem_write(0x14a82f0,bytes(24));u.mem_write(vector+0x1f000,bytes(20));w(0x14a82f8,vector+0x1f000 if queue_available else 0);w(0x14a82e0,123);u.mem_write(0x14a82e4,b'\x00');w(params+0x70,int(start_paused));w(params+0x74,97)
 w(params+0xc,vector+0x1e000);u.mem_write(vector+0x1e000,bytes(8));w(params+0x20,playing_id);w(0x14a7a2c,manager);u.mem_write(manager,bytes(256));u.mem_write(record,bytes(64));w(record,7);w(record+0x20,playing_id);w(record+0x30,0x12345678)
 if registered:w(manager+(playing_id%31)*4,record)
 w(node+0x58+0x14,media);w(node+0x58+0xc,16);u.mem_write(media,bytes(range(16)))
 for a in [0x14a79d8,0x14a7d3c]:u.mem_write(a,struct.pack('<f',1.))
 w(0x14a7a74,0);w(0x14a7a78,0);w(0x14a7a70,0);w(0x14a7a6c,0);u.mem_write(0x12100ec,struct.pack('<H',128))
 u.mem_write(0x12100e0,bytes(16));w(0x12100e0,vector+0x1b000);w(0x12100e8,8);u.mem_write(vector+0x1b000,bytes(96))
 w(stack,end);w(stack+4,params);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,node);u.emu_start(0xb228e0,end,count=20000)
 assert u.reg_read(UC_X86_REG_EIP)==end
 assert u.reg_read(UC_X86_REG_EAX)==1
 assert read(0x12100e4)==1 and read(vector+0x1b000)==voice
 assert allocs==[424] and read(voice)==0xff0cdc and read(voice+0x60)==node and read(voice+0x64)==node+0x58 and read(voice+0x68)==owner
 assert struct.unpack('<f',u.mem_read(voice+0x134,4))[0]==priority
 assert read(voice+0x48)==playing_id
 assert read(record)==(8 if registered else 7)
 assert read(voice+4)==(0x12345678 if registered else 0)
 assert read(voice+0x14c)==media and read(voice+0x150)==16 and read(voice+0x14)==0
 assert read(0x14a7a70)==1 and read(0x14a7a74)==voice and read(0x14a7a78)==voice
 assert read(voice+0x148)==97
 assert bool(u.mem_read(voice+0x12d,1)[0]&0x40)==start_paused
 assert read(0x14a8304)==int(queue_available)
 if queue_available:
  assert read(0x14a82f0)==vector+0x1f000 and read(0x14a82f4)==vector+0x1f000
  assert read(vector+0x1f004)==voice and read(vector+0x1f008)==int(start_paused) and read(vector+0x1f00c)==123
  assert u.mem_read(0x14a82e4,1)==b'\x01'
 w(0x12100f4,48000);w(0x14a8308,vector+0x1f000);w(0x14a82fc,1)
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xb1c590,end,count=20000)
 assert u.reg_read(UC_X86_REG_EIP)==0xb16380
 assert allocs==[424,960]
 assert u.reg_read(UC_X86_REG_ECX)==vector+0x22000
 sp=u.reg_read(UC_X86_REG_ESP);assert read(sp+4)==voice and read(sp+8)==1
 rows.append(dict(queue_available=queue_available,start_paused=start_paused,priority=priority,mode=mode,playing_id=playing_id,registered=registered,allocations=allocs.copy(),voice_bytes=bytes(u.mem_read(voice,424)).hex()))
proof=dict(passed=True,case_count=len(rows),native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['Reader activation then B1C590 command preparation enters B0CE90, allocates960-byte backend, executes B15BC0 constructor and B176E0 sample rate setup, reaches B16380(voice,1).'],adapters=['Allocator supplies voice424 and backend960 buffers; OS locks adapted; resident source sentinel16 bytes; preallocated queues and registry.','Sample rate48000; no attenuation/RTPC; zero fade. Stop before B16380 source attachment.'],limits=['Source attachment, decoder creation, command completion, mixing and audible output unproven.'])
(r/'data/4.20/audio_backend_construction.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'native backend construction cases')
