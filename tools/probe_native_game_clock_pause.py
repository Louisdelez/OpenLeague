from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('rows=[]')[0],'setup','exec'))
controller=vector+0xc000;qpc=vector+0xb000;w(0xfa4134,qpc);counter=10000000;calls=0

def observe(uc,address,size,user):
 global calls
 if address==0xce298a:finish(0)
 elif address==qpc:
  calls+=1;sp=u.reg_read(UC_X86_REG_ESP);u.mem_write(read(sp+4),struct.pack('<Q',counter));finish(1,4)
u.hook_add(unicorn.UC_HOOK_CODE,observe)
u.mem_write(0x14bef48,struct.pack('<Q',0));u.mem_write(0x14bef50,struct.pack('<Q',10000000))
def snapshot(label):
 return dict(label=label,scale_hex=bytes(u.mem_read(obj+0x10,8)).hex(),pending_scale_bits=read(obj+0x48),time_bits=read(obj+0x2c),delta_bits=read(obj+0x30),drift_bits=read(obj+0x34),paused=int(u.mem_read(controller+0x15,1)[0]),resume_pending=int(u.mem_read(controller+0x16,1)[0]),remaining_bits=read(controller+0x1c),elapsed_pause_bits=read(controller+0x30),qpc_calls=calls)
rows=[]
for scale,new_scale,delayed in itertools.product([.5,1.,1.123456789,2.],[.25,1.,1.23456789],[False,True]):
 u.mem_write(obj,b'\0'*0x50);call(0x99c410,obj);u.mem_write(obj+0x10,struct.pack('<d',scale));u.mem_write(obj+0x2c,struct.pack('<f',5.))
 u.mem_write(controller,b'\0'*0x50);w(controller,0x10deac4);w(controller+4,obj);u.mem_write(controller+0x18,struct.pack('<f',.25));w(obj+0x28,controller)
 counter=10000000;calls=0;steps=[snapshot('initial')]
 call(0x99c940,controller);assert u.reg_read(UC_X86_REG_EAX)&255==1;steps.append(snapshot('pause'))
 call(0x99c940,controller);assert u.reg_read(UC_X86_REG_EAX)&255==0;assert calls==1
 call(0x99c4f0,obj,struct.pack('<d',new_scale));steps.append(snapshot('set_scale_while_paused'))
 for _ in range(3):
  counter+=1250000;call(0x99c5e0,obj+0x20,struct.pack('<d',.125));assert read(obj+0x2c)==struct.unpack('<I',struct.pack('<f',5.))[0]
 steps.append(snapshot('paused_frames'))
 counter+=1250000;call(0x99ca20,controller,struct.pack('<I',int(delayed)));assert u.reg_read(UC_X86_REG_EAX)&255==1;steps.append(snapshot('request_resume'))
 if delayed:
  for i in range(2):
   counter+=1250000;call(0x99c5e0,obj+0x20,struct.pack('<d',.125));steps.append(snapshot('countdown_'+str(i)))
 assert u.mem_read(controller+0x15,1)==b'\0'
 expected=struct.unpack('<f',struct.pack('<f',new_scale))[0];assert struct.unpack('<d',u.mem_read(obj+0x10,8))[0]==expected
 counter+=1250000;call(0x99c5e0,obj+0x20,struct.pack('<d',.125));assert struct.unpack('<f',u.mem_read(obj+0x2c,4))[0]>5.;steps.append(snapshot('resumed_frame'))
 rows.append(dict(scale=scale,requested_scale=new_scale,delayed=delayed,steps=steps))
proof=dict(complete=False,passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),pause='0x99c940',resume_request='0x99ca20',countdown='0x99ca80',resume='0x99cae0',scale_setter='0x99c4f0',cases=rows,limits=['Controller fields/vtable supplied; config parser/constructor not emulated. Countdown duration .25 supplied explicitly, not historical default claim.','OS QPC output deterministic; original conversion/update/controller executed. Notifications null; authorization/UI/network not covered.','Unicorn arithmetic; physical Rust port still pending.'])
(r/'data/4.20/game_clock_pause_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps(dict(passed=True,sequences=len(rows),paused_frames=len(rows)*3)))
