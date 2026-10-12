from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
obj=vector+0x10000;allocations=[];registered=[]
def ret(value):
 sp=u.reg_read(UC_X86_REG_ESP);target=read(sp);u.reg_write(UC_X86_REG_EAX,value);u.reg_write(UC_X86_REG_ESP,sp+4);u.reg_write(UC_X86_REG_EIP,target)
def allocate(uc,a,n,d):allocations.append(read(u.reg_read(UC_X86_REG_ESP)+8));ret(obj)
def register(uc,a,n,d):registered.append(u.reg_read(UC_X86_REG_ECX));ret(0)
u.hook_add(unicorn.UC_HOOK_CODE,allocate,begin=0xada670,end=0xada670)
u.hook_add(unicorn.UC_HOOK_CODE,register,begin=0xb21cf0,end=0xb21cf0)
rows=[]
contract=json.loads((r/'data/4.20/ambient_audio_selection.json').read_text())
for action in [a for e in contract['events'] for a in e['actions']]:
 u.mem_write(obj,b'\0'*0x40);allocations.clear();registered.clear()
 call(0xb21d40,0,struct.pack('<II',0x403,action['id']))
 assert u.reg_read(UC_X86_REG_EAX)==obj and read(obj)==0xff2a04 and read(0xff2a04+0x20)==0xb2d240
 assert read(obj+8)==action['id'] and struct.unpack('<H',u.mem_read(obj+0x20,2))[0]==0x403
 assert allocations==[40] and registered==[obj]
 rows.append(dict(action=action['id'],type=0x403,vtable=hex(read(obj)),execute=hex(read(read(obj)+0x20))))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),factory='0xb21d40',constructor_factory='0xb2d1f0',cases=rows,limits=['Allocator and action registry insertion adapted; native factory dispatch and constructor executed unchanged.','Verified8actual action IDs with type0403; does not execute full pending event scheduling or playback.'])
(r/'data/4.20/audio_native_play_action_class.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps(dict(passed=True,actions=len(rows))))
