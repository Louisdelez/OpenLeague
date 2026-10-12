"""Whole9437E0 through ret8, actual auxiliary/inverse and explicit producer adapters."""
from pathlib import Path
import json,datetime,ctypes,shutil,itertools,struct
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_animation_policy.py').read_text(encoding='utf-8').split('\ntimes=')[0]
setup=setup.replace("'0x943a21<=a<0x943a81'", "'0x9437e0<=a<0x943b58'").replace('if a==0x943ada:u.emu_stop();return','if a==0:u.emu_stop();return').replace('u.hook_add(unicorn.UC_HOOK_CODE,policy_hook)','policy_hook_id=u.hook_add(unicorn.UC_HOOK_CODE,policy_hook)')
exec(compile(setup,'simple whole frame setup','exec'));u.hook_del(policy_hook_id)
# The arithmetic hook is compiled by nested setup scripts. Extend that actual
# callback, rather than changing a string in an outer setup that never sees it.
assert 0x943a21 in cpu_hook.__code__.co_consts and 0x943a81 in cpu_hook.__code__.co_consts
cpu_hook.__code__=cpu_hook.__code__.replace(co_consts=tuple(0x9437e0 if c==0x943a21 else 0x943b58 if c==0x943a81 else c for c in cpu_hook.__code__.co_consts))
helper=heap+0xb000;storage=heap+0xb800;manager=heap+0xb900;found=True
def frame_hook(uc,a,size,user):
 if a in [0x943300,0x941f00,0x944e20]:
  sp=u.reg_read(UC_X86_REG_ESP);name={0x943300:'attachment',0x941f00:'emission',0x944e20:'particles'}[a];assert u.reg_read(UC_X86_REG_ECX)==(storage if name=='particles' else instance)
  events.append({'event':name,'time':hex(read32(sp+4)),'value':hex(read32(sp+8)),'last_step':read32(sp+12) if name=='particles' else None})
  if name=='emission' and create:write32(instance+0xc,storage)
  finish(pop=12 if name=='particles' else 8);return
 policy_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,frame_hook)
identity=[bits(1.) if i in [0,5,10,15] else 0 for i in range(16)];cases=[]
profiles=itertools.product([False,True],[False,True],[0,0x10],[False,True],[0,0x6d6e6163],[False,True],range(4),[0,1],[0,1])
for present,create,flags,pose_present,clip_kind,helper_present,phase,manager_flag,active in profiles:
 time=[0,bits(.25),bits(1.5),0x7fa01234][phase];previous_time=0xff7fffff if phase%2==0 else bits(.25);matrix=identity.copy();matrix[12:15]=[bits(100.+phase),bits(20.),bits(-30.)];captures=[]
 for corrected in [False,True]:
  enabled=corrected;events=[];u.mem_write(instance,b'\0'*0x160);u.mem_write(actor,b'\0'*0x200);u.mem_write(definition,b'\0'*0x300);u.mem_write(metadata,b'\0'*0x10);u.mem_write(resource,b'\0'*0x40);u.mem_write(clip,b'\0'*0x30);u.mem_write(helper,b'\0'*0x40);u.mem_write(storage,b'\0'*0xb0);u.mem_write(manager,b'\0'*0x10)
  write32(instance,actor);write32(instance+4,definition);write32(instance+0xc,storage if present else 0);write32(instance+0x10,bits(1.));write32(instance+0xdc,previous_time);write32(instance+0xe4,helper if helper_present else 0);write32(instance+0xec,resource if pose_present else 0);write32(instance+0xf4,mapping);write32(instance+0x114,bits(.25));u.mem_write(instance+0x94,struct.pack('<16I',*matrix));u.mem_write(instance+0x14,b'\xcc'*64);u.mem_write(instance+0x54,b'\xdd'*64)
  u.mem_write(actor+0x1dc,bytes([flags]));write32(actor+0xa8,0)
  for i in range(3):write32(actor+0x90+i*4,bits((i+1)*2.));write32(actor+0x84+i*4,bits(i+1.));write32(helper+0x10+i*4,0xcccccccc)
  u.mem_write(helper+0x2c,b'\1');write32(helper+0x24,bits(.25));write32(0x2d78560,manager);u.mem_write(manager+5,bytes([manager_flag]));write32(0x12258c4,0x3d088889);write32(storage+0xa4,active)
  for off,value in [(0x170,bits(.5)),(0x174,bits(1.)),(0x164,0),(0xa4,bits(.5)),(0xa0,0),(0x18c,0),(0x228,42)]:write32(definition+off,value)
  write32(definition+4,metadata);write32(metadata+4,lookup_object);write32(lookup_object,lookup_vtable);write32(lookup_vtable+0x44,lookup_endpoint);write32(clip+4,clip_kind);write32(clip+0x14,2);write32(clip+0x18,bits(.5));u.mem_write(resource+0x20,b'\x7f');u.mem_write(0x2d77410,struct.pack('<16I',*identity))
  sp=stack+0x8000;u.mem_write(sp-0x400,b'\0'*0x440);write32(sp,end);write32(sp+4,time);write32(sp+8,phase&1);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,instance);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x9437e0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==sp+12 and restore is None
  captures.append({'particle_present':read32(instance+0xc)!=0,'clock':hex(read32(instance+0x114)),'pose_flag':u.mem_read(resource+0x20,1)[0],'helper_delta':[hex(read32(helper+0x10+i*4)) for i in range(3)],'helper_flag':u.mem_read(helper+0x2c,1)[0],'helper_accumulator':hex(read32(helper+0x24)),'previous':list(struct.unpack('<16I',u.mem_read(instance+0x14,64))),'inverse':list(struct.unpack('<16I',u.mem_read(instance+0x54,64))),'last_time':hex(read32(instance+0xdc)),'finished':u.mem_read(instance+8,1)[0],'events':events.copy()})
 cases.append({'present':present,'create':create,'flags':flags,'pose_present':pose_present,'clip_kind':clip_kind,'helper_present':helper_present,'time':hex(time),'previous_time':hex(previous_time),'manager_flag':manager_flag,'active':active,'last_step':phase&1,'matrix':matrix,'emulator':captures[0],'cpu':captures[1]})
for address in blocks:kernel.VirtualFree(address,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'9437E0','cases':cases,'actual_cpu_sse_operations':cpu_calls,'actual_cpu_x87_duration_operations':duration_calls,'emulator_cpu_case_disagreements':sum(c['emulator']!=c['cpu'] for c in cases),'adapters':['Whole9437E0 executes through native ret8. Progress/expiration, auxiliary writes, clip policy/clock and actual matrix copy/inverse/final writes run.','Attachment/emission/particle update, clip lookup and evaluators are capture endpoints. Emission may create particle storage, active count is supplied. Explicit owner positions/matrix/manager/reset value and fallback supplied.'],'limits':['Concrete attachment/emission/particle/clip/pose producers unbound. Selected supplied matrices and finite/NaN time profiles only. No ordinary rendering/audio/full-game acceptance.','Default FP mode and zeroed caller stack.']}
(r/'data/4.20/simple_frame_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'x87':duration_calls,'disagreements':proof['emulator_cpu_case_disagreements']}))
