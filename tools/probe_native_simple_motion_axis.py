"""Whole944A10 motion velocity-axis reorientation, including native norm, no endpoints."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_particle_random_force.py').read_text(encoding='utf-8').split('\nforce=')[0]
exec(compile(setup,'axis force native setup','exec'))
cpu_hook.__code__=cpu_hook.__code__.replace(co_consts=tuple(0x944c80 if c==0x93c6f9 else c for c in cpu_hook.__code__.co_consts))
force=heap+0x22000;position=heap+0x23000;velocity=heap+0x24000;parameters=heap+0x25000
def words(a,n):return [read32(a+j*4) for j in range(n)]
axes=[[0.,1.,0.],[1.,0.,0.],[0.,0.,1.],[0.,-1.,0.],[0.,0.,0.],[1.,1.,1.],[0.,2.,0.],[.5,.25,-.75]]
vectors=[[0.,0.,0.],[1.,0.,0.],[0.,1.,0.],[3.,4.,-2.],[-2.,-1.,3.],[.001,0.,0.],[.0001,0.,0.]];cases=[]
for axis,original_position,original_velocity,anchor in itertools.product(axes,vectors,vectors,[[0.,0.,0.],[1.,2.,-3.]]):
 captures=[]
 for corrected in [False,True]:
  enabled=corrected;u.mem_write(force,b'\0'*0x30)
  for address,values in [(force+0x10,axis),(position,original_position),(velocity,original_velocity),(parameters,anchor)]:
   for j,v in enumerate(values):write32(address+j*4,bits(v))
  sp=stack+0x8000;u.mem_write(sp-0x100,b'\0'*0x140);write32(sp,end);write32(sp+4,parameters);write32(sp+8,force+0x10);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,velocity);u.reg_write(UC_X86_REG_EDX,position);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x944a10,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==sp+4 and restore is None
  captures.append({'position':words(position,3),'velocity':words(velocity,3),'parameters':words(parameters,3)})
 cases.append({'axis':[bits(v) for v in axis],'position':[bits(v) for v in original_position],'velocity':[bits(v) for v in original_velocity],'parameters':[bits(v) for v in anchor],'emulator':captures[0],'cpu':captures[1]})
constants={hex(a):read32(a) for a in [0x1138a10,0x1138990,0x11392ec,0x1138960]}
for address in blocks:kernel.VirtualFree(address,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'944A10','cases':cases,'constants':constants,'actual_cpu_sse_operations':cpu_calls,'emulator_cpu_case_disagreements':sum(c['cpu']!=c['emulator'] for c in cases),'adapters':[],'limits':['Explicit raw axis, position, velocity and parameter vector supplied. Selected finite profiles, including nonunit/zero axes and small speed boundaries. Owner construction and ordinary rendering remain unqualified.','Actual CPU SSE/RSQRTSS reference; original approximate norm5FA7C0 and whole force execute, default FP mode.']}
(r/'data/4.20/simple_motion_axis_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'disagreements':proof['emulator_cpu_case_disagreements'],'constants':constants}))
