from pathlib import Path
import json,struct
r=Path('E:/OpenLeague')
exec(compile((r/'tools/qualify_native_audio_backend_reference.py').read_text().split('u.hook_add(')[0],'setup','exec'))
constructor_calls=[]
def combined(uc,a,size,user):
 if a in [0x654260,0x5c74a0,0x5c73c0]:
  constructor_calls.append(hex(a));ret(heap+0x6000+len(constructor_calls)*0x100);return
 if 0x6cdc80<=a<=0x6cdd32:return
 hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,combined)
rows=[];actor=0;resolved=False
for fill in [0,0xa5,0xff]:
 u.mem_write(heap,bytes([fill])*0x10000);u.mem_write(0,b'\0'*4);sp=stack+0x8000;u.mem_write(sp,struct.pack('<I',end));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,manager);constructor_calls.clear();u.emu_start(0x6cdc80,end,count=10000)
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)==manager
 initial=struct.unpack('<I',u.mem_read(manager+0xc,4))[0];assert initial==0
 seq=[]
 for success in [False,True,True]:
  seed=struct.unpack('<I',u.mem_read(manager+0xc,4))[0]
  u.mem_write(control,struct.pack('<III',0,3,3));u.mem_write(entry,b'\0'*32)
  u.mem_write(heap+0x4000,b'event\0'+b'\0'*10+struct.pack('<II',5,15));u.mem_write(heap+0x4100,struct.pack('<3f',1.,2.,3.))
  u.mem_write(sp,struct.pack('<IIIIf',end,heap+0x4000,0,heap+0x4100,-.5));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,manager);events.clear();u.emu_start(0x6ce0e0,end,count=10000)
  assert u.reg_read(UC_X86_REG_EIP)==end
  returned=u.reg_read(UC_X86_REG_EAX);counter=struct.unpack('<I',u.mem_read(manager+0xc,4))[0]
  assert returned==(seed if success else 0xffffffff);assert counter==seed+int(success)
  seq.append(dict(success=success,returned_raw=returned,next_counter=counter))
 rows.append(dict(fill=fill,initial_counter=initial,constructor_calls=constructor_calls.copy(),sequence=seq))
proof=dict(passed=True,complete=False,native_sha256=digest,constructor='0x6cdc80',counter_store='0x6cdcd0',cases=rows,adapters=['Container allocators654260/5C74A0/5C73C0 return supplied distinct nodes.','Voice factory, map insertion and shared assignment use existing qualified registration adapters.','Original constructor body, initial counter store and registration counter transitions execute.'],limits=['No container allocation failure/unwind qualification.','Voice factory return supplied; no physical audio admission.'])
(r/'data/4.20/audio_backend_startup_contract.json').write_text(json.dumps(proof,indent=2),encoding='utf-8');print('PASS',len(rows),'constructor/registration sequences')
