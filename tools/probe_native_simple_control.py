"""9437E0..943924 progress/expiration and dispatch, producer endpoints supplied."""
from pathlib import Path
import json,datetime,ctypes,shutil,itertools,random
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_troy_frame_timing.py').read_text(encoding='utf-8').split('\ncases=[]')[0]
setup=setup.replace("'0x93f45b<=a<0x93f5c0'", "'0x9437e0<=a<0x943924'").replace('u.hook_add(unicorn.UC_HOOK_CODE,timing_hook)','timing_hook_id=u.hook_add(unicorn.UC_HOOK_CODE,timing_hook)')
exec(compile(setup,'simple control setup','exec'));u.hook_del(timing_hook_id)
instance=heap+0x9000;definition=heap+0xa000;particle_storage=heap+0xb000
def simple_hook(uc,a,size,user):
 if a==0x943924:u.emu_stop();return
 if a in [0x943300,0x941f00,0x944e20]:
  sp=u.reg_read(UC_X86_REG_ESP);name={0x943300:'attachment',0x941f00:'emission',0x944e20:'particles'}[a];argc=3 if name=='particles' else 2
  assert u.reg_read(UC_X86_REG_ECX)==(particle_storage if name=='particles' else instance)
  events.append({'event':name,'time':hex(read32(sp+4)),'value':hex(read32(sp+8)),'last_step':read32(sp+12) if name=='particles' else None})
  if name=='emission' and create:write32(instance+0xc,particle_storage)
  finish(pop=argc*4);return
 reset_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,simple_hook)
special=[0,0x80000000,1,0x3f000000,0x3f800000,0xbf800000,0x40000000,0x7f800000,0xff800000,0x7fa01234,0xffa05678,0x7fc01234]
inputs=[]
for index,(flags,ti,li,present) in enumerate(itertools.product([0,0x10,0x20,0xff],range(12),range(8),[False,True])):
 inputs.append({'flags':flags,'time':special[ti],'start':special[(ti+3)%12],'life':special[li],'lower':special[(li+3)%12],'upper':special[(li+7)%12],'delay':special[(ti+li)%12],'emitter_linger':special[(ti+5)%12],'particle_linger':special[(li+2)%12],'present':present,'create':index%3==0,'last_step':index%256})
rng=random.Random(420)
for _ in range(256):inputs.append(dict(flags=rng.choice([0,0x10]),**{k:bits(rng.uniform(-2,5)) for k in ['time','start','life','lower','upper','delay','emitter_linger','particle_linger']},present=bool(rng.randrange(2)),create=bool(rng.randrange(2)),last_step=rng.choice([0,1,255,0xffffffff])))
cases=[]
for index,entry in enumerate(inputs):
 create=entry['create'];captures=[]
 for corrected in [False,True]:
  enabled=corrected;events=[];u.mem_write(actor,b'\0'*0x200);u.mem_write(instance,b'\0'*0x160);u.mem_write(definition,b'\0'*0x300);write32(instance,actor);write32(instance+4,definition);write32(instance+0xc,particle_storage if entry['present'] else 0);write32(instance+0x10,entry['life']);write32(actor+0xa8,entry['start']);u.mem_write(actor+0x1dc,bytes([entry['flags']]))
  for off,name in [(0x170,'lower'),(0x174,'upper'),(0x164,'delay'),(0xa4,'emitter_linger'),(0xa0,'particle_linger')]:write32(definition+off,entry[name])
  sp=stack+0x8000;u.mem_write(sp-0x400,b'\0'*0x440);write32(sp,end);write32(sp+4,entry['time']);write32(sp+8,entry['last_step']);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,instance);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x9437e0,0x943924,count=10000);assert u.reg_read(UC_X86_REG_EIP)==0x943924 and restore is None
  captures.append({'expired':u.mem_read(u.reg_read(UC_X86_REG_ESP)+0xf,1)[0],'present':read32(instance+0xc)!=0,'events':events.copy()})
 cases.append(dict(entry,emulator=captures[0],cpu=captures[1]))
for address in blocks:kernel.VirtualFree(address,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'range':'9437E0..943924','cases':cases,'actual_cpu_sse_operations':cpu_calls,'emulator_cpu_case_disagreements':sum(c['emulator']!=c['cpu'] for c in cases),'adapters':['Native progress/expiration block and attachment/emission/particle dispatch execute. Three producer endpoints capture arguments; emission may supply particle storage. Actual producer bodies not executed.','Owner-end bit10 chooses emitter linger; particle cap supplied only after strict expiration. Raw last-step word preserved. CPU SSE and x87 copies supplied independently.'],'limits':['Remaining Simple update, endpoint producer bodies, owner fields production and ordinary rendering/audio integration incomplete.','Static definition fields, default FP controls and zeroed caller stack.']}
(r/'data/4.20/simple_control_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'disagreements':proof['emulator_cpu_case_disagreements']}))
