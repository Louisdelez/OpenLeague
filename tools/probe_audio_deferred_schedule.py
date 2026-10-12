from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
action=vector+0x10000;params=vector+0x11000;context=vector+0x12000;pair=vector+0x12100;pending=vector+0x13000;props=vector+0x14000;manager=vector+0x15000;registry=vector+0x16000;entry=vector+0x17000;lock=vector+0x18000
u.mem_write(lock,b'\xc2\x04\x00');w(0xfa4424,lock);w(0xfa4428,lock);w(0x14a7a08,registry);w(0x14a7a28,manager);w(0x14a79e8,0)
def hook(uc,a,size,user):
 if a==0xada670:
  sp=uc.reg_read(UC_X86_REG_ESP);assert read(sp+8)==64;finish(pending)
 elif a==0xb05fdd:uc.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,hook)
rows=[]
for delay in [1024,1025,6000,24000,48000,96000]:
 for addr,size in [(action,176),(params,176),(context,32),(pair,8),(pending,64),(props,16),(manager,256),(registry,0x1000),(entry,12)]:u.mem_write(addr,bytes(size))
 w(action,0xff1c34);w(action+12,1);u.mem_write(action+0x20,struct.pack('<H',0x503));w(action+0x14,props);u.mem_write(props,b'\x01\x0e');w(context+8,pair);w(manager+0x4c,entry);w(manager+0x7c,100)
 w(stack,end);u.mem_write(stack+4,struct.pack('<IIII',context,params,delay,action));u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xaf0270,end,count=2000)
 assert u.reg_read(UC_X86_REG_EIP)==0xb05fdd
 assert read(pending+4)==action and read(action+0xa0)==pending and read(action+12)==2
 assert read(props+4)==delay and read(pending+8)==100+(delay>>10) and read(pending+12)==delay%1024
 assert read(manager+0x44)==entry and read(entry+8)==pending
 rows.append(dict(delay=delay,target=read(pending+8),remainder=read(pending+12),action_references=read(action+12)))
proof=dict(passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(rows),cases=rows,findings=['Actual AF0270 -> B057B0, zero-ID association setters, B1FCB0 lookup, B22100 delay property, ADCE10, B05F00 and B06140 compose through real insertion.'],adapters=['Allocator supplies64byte pending; locks ret4; preallocated property/free node; zero association IDs and owner; stop B05FDD after insertion.'],limits=['Not yet returned through scheduling cleanup; nonzero associations and immediate execution not covered; no audio output proof.'])
(r/'data/4.20/audio_deferred_schedule.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'deferred queue compositions')
