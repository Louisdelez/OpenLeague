"""Whole93BDD0 including real random/axis children and shared RNG; no endpoint adapters."""
from pathlib import Path
import json,struct,itertools,datetime,shutil,ctypes
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_forces.py').read_text(encoding='utf-8').split('\ncontainer=')[0]
exec(compile(setup,'particle force setup','exec'))
cpu_hook.__code__=cpu_hook.__code__.replace(co_consts=tuple(0x5fa7c0 if c==0x945620 else 0x93c122 if c==0x9456d7 else c for c in cpu_hook.__code__.co_consts))
machine=bytes.fromhex('660f6ec1f30f52c0660f7ec0c3');address=kernel.VirtualAlloc(None,4096,0x3000,0x40);ctypes.memmove(address,machine,len(machine));blocks.append(address);cpu_functions['rsqrtss']=ctypes.CFUNCTYPE(ctypes.c_uint32,ctypes.c_uint32,ctypes.c_uint32)(address)
cpu_hook.__code__=cpu_hook.__code__.replace(co_consts=tuple(0x93cbc1 if c==0x93c122 else c for c in cpu_hook.__code__.co_consts))
force=heap+0x22000;position=heap+0x23000;velocity=heap+0x24000;parameters=heap+0x25000;point_list=heap+0x26000;damping_list=heap+0x26100;child_list=heap+0x26200;final_list=heap+0x26300
def words(a,n):return [read32(a+j*4) for j in range(n)]
def child_hook(uc,a,size,user):
 if a in [0x93c450,0x93c900]:
  sp=u.reg_read(UC_X86_REG_ESP);assert read32(sp+4)==position and read32(sp+8)==velocity
  events.append({'kind':hex(a),'resource':u.reg_read(UC_X86_REG_ECX)-heap,'position':words(position,3),'velocity':words(velocity,3),'parameters':words(read32(sp+12),3) if a==0x93c900 else None})
  # Observe only: original child body runs through its native return.
u.hook_add(unicorn.UC_HOOK_CODE,child_hook)
vectors=[[0.,0.,0.],[1.,0.,0.],[0.,1.,1.],[3.,4.,0.],[-2.,1.,3.],[.001,0.,0.]];cases=[]
for uniform,point_count,damping_count,delta,profile,radius,children in itertools.product([False,True],[0,1,2],[0,1,2],[0.,.125,2.],range(6),[0.,1.,2.,5.],[False,True]):
 pos=[bits(x) for x in vectors[profile]];vel=[bits(x) for x in vectors[(profile+3)%6]];acc=[bits(x) for x in [1.,-2.,.5]];param=[bits(1.),bits(2.),bits(3.)];points=[];dampings=[]
 for n in range(point_count):points.append({'position':[bits(x) for x in vectors[n]],'radius':bits(radius),'strength':bits(1. if n==0 else -.5)})
 for n in range(damping_count):dampings.append({'position':[bits(x) for x in vectors[n]],'radius':bits(radius),'strength':bits(.5 if n==0 else 2.)})
 captures=[]
 for corrected in [False,True]:
  enabled=corrected;events=[];u.mem_write(force,b'\0'*0x80);write32(force+0x10,1 if uniform else 0);write32(force+0x14,0)
  for j,v in enumerate(acc):write32(force+1+j*4,v)
  for address,values in [(position,pos),(velocity,vel),(parameters,param)]:
   for j,v in enumerate(values):write32(address+j*4,v)
  for offset,lst,rows in [(0x1c,point_list,points),(0x28,damping_list,dampings)]:
   write32(force+offset,lst);write32(force+offset+4,lst+len(rows)*4)
   for n,row in enumerate(rows):
    obj=heap+0x27000+(offset*4+n)*0x100;write32(lst+n*4,obj);u.mem_write(obj,b'\0'*0x30)
    for j,v in enumerate(row['position']):write32(obj+0x10+j*4,v)
    write32(obj+0x20,row['strength']);write32(obj+0x28,row['radius'])
  for offset,lst,base in [(0x34,child_list,0x38000),(0x40,final_list,0x39000)]:
   write32(force+offset,lst);write32(force+offset+4,lst+(8 if children else 0));write32(lst,heap+base);write32(lst+4,heap+base+0x100)
  write32(0x2d6ece4,0);write32(0x2d6ece8,0)
  for j in range(55):write32(0x2d6ec08+j*4,12345+13579*j)
  for n in range(2):
   obj=heap+0x38000+n*0x100;u.mem_write(obj,b'\0'*0x50);write32(obj+0x40,n+1);write32(obj+0x20,bits(5.));write32(obj+0x2c,bits(.25))
   for j,v in enumerate([.5,1.,2.]):write32(obj+0x30+j*4,bits(v))
   obj=heap+0x39000+n*0x100;u.mem_write(obj,b'\0'*0x30)
   for j,v in enumerate([0.,1.,0.] if n==0 else [0.,0.,1.]):write32(obj+0x10+j*4,bits(v))
  sp=stack+0x8000;u.mem_write(sp-0x100,b'\0'*0x140);write32(sp,end);write32(sp+4,bits(delta));write32(sp+8,position);write32(sp+12,velocity);write32(sp+16,parameters);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,force);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x93bdd0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==sp+20 and restore is None
  captures.append({'position':words(position,3),'velocity':words(velocity,3),'parameters':words(parameters,3),'events':events.copy(),'rng':words(0x2d6ec08,55),'first':read32(0x2d6ece4),'second':read32(0x2d6ece8)})
 cases.append({'uniform':uniform,'acceleration':acc,'delta':bits(delta),'position':pos,'velocity':vel,'parameters':param,'points':points,'dampings':dampings,'children':children,'emulator':captures[0],'cpu':captures[1]})
constants={hex(a):read32(a) for a in [0x1138e98,0x1138ba4,0x11389d8]}
for address in blocks:kernel.VirtualFree(address,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'93BDD0','cases':cases,'constants':constants,'actual_cpu_sse_operations':cpu_calls,'emulator_cpu_case_disagreements':sum(c['cpu']!=c['emulator'] for c in cases),'adapters':[],'limits':['Whole93BDD0 executes real93C450/93C900 children. Explicit child fields and shared RNG supplied; construction and ordinary integration unqualified. Selected finite input profiles, default FP controls; CPU-dependent reciprocal-square-root estimate.']}
(r/'data/4.20/particle_force_graph_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'disagreements':proof['emulator_cpu_case_disagreements'],'constants':constants}))
