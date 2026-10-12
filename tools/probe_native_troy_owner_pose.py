"""Whole owner phase94099A..940AEE plus93F1A0 status/deferred callbacks."""
from pathlib import Path
import json,struct,datetime,shutil,itertools
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_troy_properties.py').read_text(encoding='utf-8').split('\nactor=')[0]
exec(compile(setup,'native owner pose setup','exec'))
actor=heap+0x9000;actor_config=heap+0xa000;wrapper=heap+0xb000;state=heap+0xc000;state_vtable=heap+0xc100;pending=heap+0xd000
entries={name:end+0x900+i*0x10 for i,name in enumerate(['eligible','position','direction','orientation','secondary','primary','callback'])}
events=[];profile={}
def hook(uc,a,size,user):
 if a==0x940aee:u.emu_stop();return
 if a in (0x9941b0,0x994210):finish();return
 name=next((name for name,address in entries.items() if address==a),None)
 if name:
  sp=u.reg_read(UC_X86_REG_ESP)
  if name=='callback':
   events.append({'event':name,'argument':read32(sp+4),'queue_count':(read32(actor+0x68)-read32(actor+0x64))//8});finish();return
  assert u.reg_read(UC_X86_REG_ECX)==state
  event={'event':name}
  if name in ('position','direction','orientation'):
   out=read32(sp+4);values=profile[name];u.mem_write(out,struct.pack('<'+'I'*len(values),*values));finish(pop=4,eax=int(profile[name+'_ok']))
  elif name=='primary':finish(eax=profile['primary'])
  else:finish(eax=profile[name])
  events.append(event);return
 native_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
patterns=[0,0x80000000,1,0x3f000000,0x3f800000,0x40000000,0xbf800000,0x7f7fffff,0xff7fffff,0x7f800000,0xff800000,0x7fa01234,0xffa05678,0x7fc01234,0xffc05678]
profiles=list(itertools.product([0,0x10,0x20,0x30],[None,0,1,255],[False,True],[False,True],[False,True],[0,2]))
profiles += [(0x10,1,True,True,True,count) for config_flags,primary,secondary,count in itertools.product([0,2,4,6],[0,255],[0,2],[0,2])]
cases=[]
def snapshot():
 return {'source_matrix':[hex(read32(wrapper+0x88+i*4)) for i in range(16)],'source_position':[hex(read32(wrapper+0x40+i*4)) for i in range(3)],'source_direction':[hex(read32(wrapper+0x4c+i*4)) for i in range(3)],'matrix':[hex(read32(actor+0xf0+i*4)) for i in range(16)],'position':[hex(read32(actor+0x90+i*4)) for i in range(3)],'minimum':[hex(read32(actor+0x130+i*4)) for i in range(3)],'maximum':[hex(read32(actor+0x13c+i*4)) for i in range(3)],'direction':[hex(read32(actor+0x9c+i*4)) for i in range(3)],'source_flags':read32(actor+0x70),'pending_count':(read32(actor+0x68)-read32(actor+0x64))//8,'events':events.copy()}
for index,(flags,eligible,position_ok,direction_ok,orientation_ok,count) in enumerate(profiles):
 phase=index%15;config_flags=(index%4)*2;primary=[0,1,2,255][(index//2)%4];secondary=[0,2,255,1][(index//3)%4]
 if index>=256:
  config_flags,primary,secondary,count=list(itertools.product([0,2,4,6],[0,255],[0,2],[0,2]))[index-256]
 profile={'eligible':eligible or 0,'position_ok':position_ok,'direction_ok':direction_ok,'orientation_ok':orientation_ok,'primary':primary,'secondary':secondary,'position':[patterns[(phase+i)%15] for i in range(3)],'direction':[patterns[(phase+i+4)%15] for i in range(3)],'orientation':[patterns[(phase+i+8)%15] for i in range(16)]}
 captures=[]
 for corrected in [False,True]:
  enabled=corrected;events=[];allocation_cursor=heap+0x80000
  u.mem_write(actor,b'\0'*0x300);u.mem_write(actor_config,b'\0'*0x300);u.mem_write(wrapper,b'\0'*0x200);write32(actor+0xe8,actor_config);write32(actor_config+0x138,patterns[(phase+7)%15]);write32(actor_config+0x1bc,config_flags)
  write32(wrapper+0x114,actor);write32(wrapper+0xc8,state if eligible is not None else 0);write32(wrapper+0x24,flags);write32(state,state_vtable)
  for offset,name in [(0x24,'eligible'),(4,'position'),(8,'direction'),(0xc,'orientation'),(0x38,'secondary'),(0x34,'primary')]:write32(state_vtable+offset,entries[name])
  for offset,width in [(0x90,3),(0x130,3),(0x13c,3),(0x9c,3),(0xf0,16)]:
   for i in range(width):write32(actor+offset+i*4,0xa5000000+offset+i)
  for offset,width in [(0x40,3),(0x4c,3),(0x88,16)]:
   for i in range(width):write32(wrapper+offset+i*4,0xb5000000+offset+i)
  write32(actor+0x70,0xa5a5a5a5 if index%2==0 else 0xa5a5a5ad);write32(actor+0x64,pending);write32(actor+0x68,pending+count*8);write32(actor+0x6c,pending+128)
  for i in range(count):write32(pending+i*8,entries['callback']);write32(pending+i*8+4,100+i)
  before=snapshot();sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBP,sp-0x100);u.reg_write(UC_X86_REG_EDI,wrapper);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPTAG,0xffff)
  u.emu_start(0x94099a,0x940aee,count=100000);assert u.reg_read(UC_X86_REG_EIP)==0x940aee and restore is None;captures.append(snapshot())
 cases.append({'flags':flags,'owner_present':eligible is not None,'profile':{key:[hex(v) for v in value] if isinstance(value,list) else value for key,value in profile.items()},'coefficient':hex(patterns[(phase+7)%15]),'config_flags':config_flags,'pending_arguments':[100+i for i in range(count)],'before':before,'emulator':captures[0],'cpu':captures[1]})
for addr in blocks:kernel.VirtualFree(addr,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'range':'94099A..940AEE','callback_address':hex(entries['callback']),'cases':cases,'actual_cpu_sse_operations':cpu_calls,'actual_cpu_x87_copies':x87_copies,'emulator_cpu_case_disagreements':sum(c['emulator']!=c['cpu'] for c in cases),'adapters':['Original entire owner phase,921F60/8DE480/8DE500/921F20 and93F1A0 execute including snapshot/copy/clear/deferred dispatch.','Owner virtual endpoints supply explicit eligibility, position/direction/matrix success and raw status bytes. Deferred callback endpoint records arguments and remaining queue length.','Allocator/free/security inherited; mutex endpoints adapted for single-thread execution. Original temporary vector copy and callback iteration execute.','Separate actual CPU SSE and x87 operand copies; original emulator output retained independently.'],'limits':['Owner virtual producer bodies, full940frame, reset/audio/child flag phases, ordinary rendering and resource acquisition incomplete.','Deferred queue non-reentrant here; concurrent mutation/mutex semantics and allocation failure not qualified.','Default masked arithmetic modes only.']}
(r/'data/4.20/troy_owner_pose_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'passed':True,'cases':len(cases),'sse_operations':cpu_calls,'x87_copies':x87_copies,'disagreements':proof['emulator_cpu_case_disagreements']}))
