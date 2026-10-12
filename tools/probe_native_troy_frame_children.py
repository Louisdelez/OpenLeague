"""Whole93F2F0 with filtered active children and explicit update endpoints."""
from pathlib import Path
import json,datetime,ctypes,shutil,itertools
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_troy_frame_timing.py').read_text(encoding='utf-8').split('\ncases=[]')[0]
setup=setup.replace("'0x93f45b<=a<0x93f5c0'", "'(0x93f2f0<=a<0x93fa0b or 0x93ed60<=a<0x93ef76)'")
setup=setup.replace('if a==0x93f5c0:u.emu_stop();return','if a==0:u.emu_stop();return')
setup=setup.replace('u.hook_add(unicorn.UC_HOOK_CODE,timing_hook)', 'timing_hook_id=u.hook_add(unicorn.UC_HOOK_CODE,timing_hook)')
exec(compile(setup,'whole frame setup','exec'));u.hook_del(timing_hook_id)
scratch=heap+0x5000;context=actor_config+0x24;clock_endpoint=end+0x1300;pause_endpoint=end+0x1310;position_endpoint=end+0x1320
def frame_hook(uc,a,size,user):
 if a in [0x934340,0x9437e0]:
  sp=u.reg_read(UC_X86_REG_ESP);child=u.reg_read(UC_X86_REG_ECX);simple=a==0x9437e0
  events.append({'event':'simple_update' if simple else 'complex_update','id':read32(child+0x100),'time':hex(read32(sp+4)),'last_step':read32(sp+8)&255 if simple else None,'position':[hex(read32(actor+0x90+i*4)) for i in range(3)],'minimum':[hex(read32(actor+0x130+i*4)) for i in range(3)],'maximum':[hex(read32(actor+0x13c+i*4)) for i in range(3)]})
  u.mem_write(child+(8 if simple else 12),bytes([done_marker]));finish(pop=8 if simple else 4);return
 if a==clock_endpoint:events.append('clock');finish(eax=99);return
 if a==pause_endpoint:
  sp=u.reg_read(UC_X86_REG_ESP);events.append({'event':'audio_pause','key':read32(sp+4),'paused':read32(sp+8)});finish(pop=8);return
 if a==position_endpoint:
  sp=u.reg_read(UC_X86_REG_ESP);p=read32(sp+8);events.append({'event':'audio_position','key':read32(sp+4),'position':[hex(read32(p+i*4)) for i in range(3)]});finish(pop=8);return
 timing_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,frame_hook)
cases=[];status=0
profiles=itertools.product([0,4,0x80],[0,2],[0,0x20],[False,True],[0x3f800000],[False,True],[(1,0),(0,2),(2,2)],[0,1,255],range(3))
for index,(flags,source_flags,config_flags,visible,lifetime,emit,(complex_count,simple_count),done_marker,phase) in enumerate(profiles):
 time=[0x3f800000,0x7fa01234,0x7f800000][phase];start=[0,0x3f800000,0x7f800000][index//3%3];handles=[0xffffffff,0xffffffff] if index%2 else [0,42];captures=[]
 for corrected in [False,True]:
  enabled=corrected;events=[];u.mem_write(actor,b'\0'*0x200);u.mem_write(actor_config,b'\0'*0x200);u.mem_write(scratch,b'\0'*0x12c);write32(actor,engine);write32(actor+0xe8,actor_config);write32(engine,root_vtable);write32(root_vtable+0x2c,clock_endpoint);write32(root_vtable+0x50,get_status);write32(engine+0xe8,bits(10.));write32(engine+4,audio_vtable);write32(audio_vtable+0x24,pause_endpoint);write32(audio_vtable+0x20,audio_release);write32(audio_vtable+0x2c,position_endpoint)
  if not visible:write32(scratch+0x78,bits(-1.))
  write32(actor+0x70,source_flags);write32(actor_config+0x1bc,config_flags);write32(actor_config+0x1c0,bits(.5));write32(actor_config+0x138,bits(2.));u.mem_write(actor+0x1dc,bytes([flags]));u.mem_write(actor+0x1dd,bytes([index%256]));write32(actor+0xec,bits(.25));write32(actor+0xa8,start);write32(actor+0xac,bits(.75));write32(actor+0xb0,bits(.25));write32(actor+0xb4,lifetime);write32(context+0x14,0xffffffff);write32(context+0x20,0x7fa01234);write32(context+0x28,0x7fa01234)
  for off,vals in [(0x84,[1.,2.,3.]),(0x90,[2.,4.,6.]),(0x9c,[1.,0.,0.])]:
   for i,value in enumerate(vals):write32(actor+off+i*4,bits(value))
  parent=heap+0x8100;parent_config=heap+0x8500;u.mem_write(parent,b'\0'*0x200);u.mem_write(parent_config,b'\0'*0x200);write32(parent+0x70,2);write32(parent+0xe8,parent_config)
  for count,offset,array,base_child,is_simple in [(complex_count,8,heap+0xe000,heap+0x9000,False),(simple_count,0x38,heap+0xe100,heap+0xa000,True)]:
   write32(actor+offset,array);write32(actor+offset+4,array+count*4)
   for i in range(count):
    child=base_child+i*0x200;u.mem_write(child,b'\0'*0x140);write32(child+(0 if is_simple else 4),parent);write32(child+0x100,i+1);write32(array+i*4,child)
  for o,v in zip([0x1ac,0x1b0],handles):write32(actor+o,v)
  sp=stack+0x8000;u.mem_write(sp-0x400,b'\0'*0x440);write32(sp,end);write32(sp+4,time);write32(sp+8,scratch);write32(sp+12,int(emit));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff)
  u.emu_start(0x93f2f0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==sp+16 and restore is None, (index,corrected,hex(u.reg_read(UC_X86_REG_EIP)),hex(u.reg_read(UC_X86_REG_ESP)),hex(sp),restore)
  captures.append({'flags':u.mem_read(actor+0x1dc,1)[0],'flags_1dd':u.mem_read(actor+0x1dd,1)[0],'offset':hex(read32(actor+0xec)),'last':hex(read32(actor+0xac)),'time':hex(read32(actor+0xb0)),'previous':[hex(read32(actor+0x84+i*4)) for i in range(3)],'position':[hex(read32(actor+0x90+i*4)) for i in range(3)],'minimum':[hex(read32(actor+0x130+i*4)) for i in range(3)],'maximum':[hex(read32(actor+0x13c+i*4)) for i in range(3)],'counter':read32(context+0x14),'clock':read32(actor_config+0x58),'metrics':[hex(read32(context+o)) for o in [0x20,0x28]],'handles':[read32(actor+o) for o in [0x1ac,0x1b0]],'complex_done':[u.mem_read(heap+0x9000+i*0x200+12,1)[0] for i in range(complex_count)],'simple_done':[u.mem_read(heap+0xa000+i*0x200+8,1)[0] for i in range(simple_count)],'events':events.copy()})
 cases.append({'flags':flags,'source_flags':source_flags,'config_flags':config_flags,'visible':visible,'time':hex(time),'start':hex(start),'lifetime':hex(lifetime),'emit':emit,'complex_count':complex_count,'simple_count':simple_count,'done_marker':done_marker,'initial_flags_1dd':index%256,'initial_handles':handles,'emulator':captures[0],'cpu':captures[1]})
for addr in blocks:kernel.VirtualFree(addr,0,0x8000)
proof={'passed':True,'complete':False,'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':digest,'entry':'93F2F0','cases':cases,'actual_cpu_sse_operations':cpu_calls,'actual_cpu_conversions':conversion_calls,'emulator_cpu_case_disagreements':sum(c['emulator']!=c['cpu'] for c in cases),'adapters':['Whole93F2F0 executes gate, visibility, actual pause/resume/acquisition, timing, substep loop, persistent audio-position dispatch, one-shot with disabled descriptors and final writes.','Engine clock/status and audio endpoints supplied explicitly. Nonempty child arrays with source2 pause filters; Complex934340/Simple9437E0 update bodies are adapters that return explicit completion bytes. Stack ret12 verified.'],'limits':['Actual child producer bodies and unfiltered clearing transitions, active descriptor production, actual audio output, profiler and ordinary client integration remain unqualified.','Default FP mode only. Caller stack initialized to zero; virtual24 pause boolean upper24bits may contain unspecified stack residue otherwise.']}
(r/'data/4.20/troy_frame_children_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'conversions':conversion_calls,'differences':proof['emulator_cpu_case_disagreements']}))
