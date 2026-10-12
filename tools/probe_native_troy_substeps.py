"""Original93F5C0..93F983 orchestration, interpolation and child completion."""
from pathlib import Path
import json,datetime,ctypes,shutil,itertools
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_troy_frame_timing.py').read_text(encoding='utf-8').split('\ncases=[]')[0]
setup=setup.replace('0x93f45b<=a<0x93f5c0','0x93f5c0<=a<0x93f983').replace('if a==0x93f5c0:','if a==0x93f983:')
setup=setup.replace('\nu.hook_add(unicorn.UC_HOOK_CODE,timing_hook)\n','\ntiming_hook_id=u.hook_add(unicorn.UC_HOOK_CODE,timing_hook)\n')
exec(compile(setup,'substep setup','exec'));u.hook_del(timing_hook_id)
context=heap+0x8000;status=0
def substep_hook(uc,a,size,user):
 if a in [0x934340,0x9437e0]:
  sp=u.reg_read(UC_X86_REG_ESP);child=u.reg_read(UC_X86_REG_ECX);simple=a==0x9437e0
  events.append({'event':'simple_update' if simple else 'complex_update','id':read32(child+0x100),'time':hex(read32(sp+4)),'last_step':read32(sp+8)&255 if simple else None,'position':[hex(read32(actor+0x90+i*4)) for i in range(3)],'minimum':[hex(read32(actor+0x130+i*4)) for i in range(3)],'maximum':[hex(read32(actor+0x13c+i*4)) for i in range(3)]})
  u.mem_write(child+(8 if simple else 12),bytes([done_marker]));finish(pop=8 if simple else 4);return
 timing_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,substep_hook)
vector_profiles=[([bits(1.),bits(2.),bits(3.)],[bits(2.),bits(4.),bits(6.)],[bits(1.),0,0]),([0,0,0],[bits(4.),bits(5.),bits(6.)],[bits(1.),0,0]),([bits(1.),bits(2.),bits(3.)],[bits(4.),bits(5.),bits(6.)],[0,0,0]),([0x7fa01234,0,0],[0xffa05678,1,0x80000000],[bits(1.),0,0]),([0x7f800000,0,0],[0x7f800000,bits(2.),bits(3.)],[bits(1.),0,0]),([1,1,1],[2,3,4],[1,0,0])]
cases=[]
for count,complex_count,simple_count,phase,done_marker in itertools.product([-1,0,1,2,4,20],[0,1,2],[0,2],range(6),[0,1,255]):
 previous,position,direction=vector_profiles[phase];step=[bits(.1),0x7fa01234,1][phase%3];last=[bits(1.),0x7fa01234,0x7f800000][phase%3];coefficient=[bits(2.),0x7fa01234,1][phase%3];captures=[]
 for corrected in [False,True]:
  enabled=corrected;events=[];u.mem_write(actor,b'\0'*0x200);u.mem_write(actor_config,b'\0'*0x200);u.mem_write(context,b'\0'*0x80);u.mem_write(frame-0x100,b'\0'*0x200);write32(actor,engine);write32(actor+0xe8,actor_config);write32(engine,root_vtable);write32(root_vtable+0x50,get_status);write32(actor_config+0x138,coefficient);write32(actor+0xac,last);u.mem_write(actor+0x1dc,b'\x80')
  for start,v in [(0x84,previous),(0x90,position),(0x9c,direction)]:
   for i,value in enumerate(v):write32(actor+start+i*4,value)
  for start in [0x130,0x13c]:
   for i in range(3):write32(actor+start+i*4,0xcccccccc)
  for offset in [0x20,0x28]:write32(context+offset,0x7fa01234)
  complex_children=[heap+0x9000+i*0x200 for i in range(complex_count)];simple_children=[heap+0xa000+i*0x200 for i in range(simple_count)]
  for array,offset,children in [(heap+0xe000,8,complex_children),(heap+0xe100,0x38,simple_children)]:
   write32(actor+offset,array);write32(actor+offset+4,array+len(children)*4)
   for i,child in enumerate(children):u.mem_write(child,b'\0'*0x110);write32(child+0x100,i+1);write32(array+i*4,child)
  write32(frame-0x14,count&0xffffffff);write32(frame-0xc,step);write32(frame-0x38,context);write32(frame-0x10,0xcccccccc)
  sp=stack+0x8000;u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESI,actor);u.reg_write(UC_X86_REG_EBX,context);u.reg_write(UC_X86_REG_EDI,count&0xffffffff);u.reg_write(UC_X86_REG_XMM3,step);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff)
  u.emu_start(0x93f5c0,0x93f983,count=100000);assert u.reg_read(UC_X86_REG_EIP)==0x93f983 and restore is None
  captures.append({'position':[hex(read32(actor+0x90+i*4)) for i in range(3)],'previous':[hex(read32(actor+0x84+i*4)) for i in range(3)],'minimum':[hex(read32(actor+0x130+i*4)) for i in range(3)],'maximum':[hex(read32(actor+0x13c+i*4)) for i in range(3)],'last':hex(read32(actor+0xac)),'flags':u.mem_read(actor+0x1dc,1)[0],'metrics':[hex(read32(context+o)) for o in [0x20,0x28]],'events':events.copy()})
 cases.append({'count':count,'complex_count':complex_count,'simple_count':simple_count,'done_marker':done_marker,'previous':[hex(v) for v in previous],'position':[hex(v) for v in position],'direction':[hex(v) for v in direction],'step':hex(step),'last':hex(last),'coefficient':hex(coefficient),'emulator':captures[0],'cpu':captures[1]})
for addr in blocks:kernel.VirtualFree(addr,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'range':'93F5C0..93F983','epsilon':hex(read32(0x1138990)),'cases':cases,'actual_cpu_sse_operations':cpu_calls,'actual_cpu_conversions':conversion_calls,'actual_cpu_x87_copies':x87_copies,'emulator_cpu_case_disagreements':sum(c['emulator']!=c['cpu'] for c in cases),'adapters':['Original full substep loop executes interpolation gates, per-step AABB writes, four status queries, both child iterations, metrics, raw last-time writes/x87 previous-position copies, final completion aggregation.','Complex934340 and Simple9437E0 endpoints record calls and supply explicit completion bytes. Engine status0 disables profiler993CE0. Child update bodies not executed.','Independent actual CPU SSE arithmetic/conversion and x87 copies; original VM capture retained.'],'limits':['Child producers, profiler timing/status8 path, remaining audio/final frame writes and ordinary integration incomplete.','Empty initial child completion bytes, supplied callback completion and default FP modes only.']}
(r/'data/4.20/troy_substeps_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'conversions':conversion_calls,'x87':x87_copies,'disagreements':proof['emulator_cpu_case_disagreements']}))
