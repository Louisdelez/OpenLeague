"""Whole9448C0 circular planar position update, including native norm."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_motion_axis.py').read_text(encoding='utf-8').split('\nforce=')[0]
exec(compile(setup,'circular motion native setup','exec'))
position=heap+0x22000;velocity=heap+0x23000;center=heap+0x24000
def words(a,n):return [read32(a+j*4) for j in range(n)]
vectors=[[0.,0.,0.],[1.,0.,0.],[0.,1.,0.],[3.,4.,-2.],[-2.,-1.,3.],[.001,0.,0.],[.0001,0.,0.]];cases=[]
for axis_a,axis_b,delta,original_position,original_velocity,anchor in itertools.product(range(3),range(3),[0.,.125,-.5,2.],vectors,vectors,[[0.,0.,0.],[1.,2.,-3.]]):
 captures=[]
 for corrected in [False,True]:
  enabled=corrected
  for address,values in [(position,original_position),(velocity,original_velocity),(center,anchor)]:
   for j,v in enumerate(values):write32(address+j*4,bits(v))
  sp=stack+0x8000;u.mem_write(sp-0x100,b'\0'*0x140);write32(sp,end);write32(sp+4,center);write32(sp+8,bits(delta));write32(sp+12,axis_a);write32(sp+16,axis_b);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,position);u.reg_write(UC_X86_REG_EDX,velocity);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x9448c0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==sp+4 and restore is None
  captures.append({'position':words(position,3),'velocity':words(velocity,3),'center':words(center,3)})
 cases.append({'axis_a':axis_a,'axis_b':axis_b,'delta':bits(delta),'position':[bits(v) for v in original_position],'velocity':[bits(v) for v in original_velocity],'center':[bits(v) for v in anchor],'emulator':captures[0],'cpu':captures[1]})
for address in blocks:kernel.VirtualFree(address,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'9448C0','cases':cases,'actual_cpu_sse_operations':cpu_calls,'emulator_cpu_case_disagreements':sum(c['cpu']!=c['emulator'] for c in cases),'adapters':[],'limits':['Explicit finite center/position/velocity and0..2axis indices supplied, including duplicate axes and zero radii. Original norm and x87 reciprocal execute. Selection in whole particle update and ordinary integration unqualified.','Actual CPU SSE/RSQRTSS reference, default FP controls. Invalid zero-norm arithmetic output retained as raw native words.']}
(r/'data/4.20/simple_circular_motion_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'disagreements':proof['emulator_cpu_case_disagreements']}))
