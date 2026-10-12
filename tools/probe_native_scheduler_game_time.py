from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'clock_setup','exec'))
receiver=vector+0xc000;vtable=vector+0xc100;callback=vector+0xc200;captured=vector+0xc300;frame=vector+0xc400
# Only scheduled object boundary is replaced: capture its native f32 argument.
u.mem_write(callback,b'\x8b\x44\x24\x04\xa3'+struct.pack('<I',captured)+b'\xc2\x04\x00')
w(receiver,vtable);w(vtable,callback);w(frame-8,receiver)
rows=[]
for scale in [0.,.5,1.,2.]:
 u.mem_write(obj,b'\0'*0x50);call(0x99c410,obj);w(0x2d791a8,obj)
 u.mem_write(obj+0x10,struct.pack('<d',scale));u.mem_write(obj+0x2c,struct.pack('<f',1.25))
 for dt in [.015625,.125,1.]:
  before=read(obj+0x2c);call(0x99c5e0,obj+0x20,struct.pack('<d',dt))
  w(captured,0xdeadbeef);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff)
  u.emu_start(0x88102c,0x881044,count=64);assert u.reg_read(UC_X86_REG_EIP)==0x881044
  assert read(captured)==read(obj+0x2c)
  if scale==0:assert read(captured)==before
  rows.append({'scale':scale,'delta':dt,'before_bits':before,'time_bits':read(obj+0x2c),'delivered_bits':read(captured)})
proof={'complete':False,'passed':True,'native_sha256':hashlib.sha256(raw).hexdigest(),'range':'0x88102c..0x881044','cases':rows,'qualified':'Scheduler dispatch reads original GameClock virtual+4 and rounds to f32 argument to scheduled object virtual0; zero scale delivers unchanged time.','limits':['Scheduled object callback replaced with argument capture; its concrete type not established.','Full scheduler traversal/budget not executed. This is not yet a proof of actor/ambient animation clock wiring.']}
(r/'data/4.20/scheduler_game_time_dispatch_contract.json').write_text(json.dumps(proof,indent=2));print('PASS native scheduler game time dispatch',len(rows),'cases')
