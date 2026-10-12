"""Native92EA60 construction,943B60 recycled pool pop and94322C reset."""
from pathlib import Path
import json,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_movement.py').read_text(encoding='utf-8').split('\ncontainer=')[0]
exec(compile(setup,'Simple storage native setup','exec'))
import types
storage_original_x87=types.FunctionType(x87_hook.__code__,globals())
def storage_x87(uc,a,size,user):
 if a==0x94323f:return
 storage_original_x87(uc,a,size,user)
x87_hook.__code__=storage_x87.__code__
container=heap+0x22000;owner=heap+0x23000;new_context=heap+0x24000;old_context=heap+0x25000;pool=heap+0x26000
def observe(uc,a,size,user):
 if a==0x94323f:u.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,observe)
def call(entry,ecx,args=[],eax=0):
 sp=stack+0x8000;write32(sp,end)
 for j,v in enumerate(args):write32(sp+4+j*4,v)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,ecx);u.reg_write(UC_X86_REG_EAX,eax);u.reg_write(UC_X86_REG_EBX,owner);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
 try:u.emu_start(entry,end,count=100000)
 except Exception:
  print('failed native storage',hex(entry),hex(u.reg_read(UC_X86_REG_EIP)),hex(u.reg_read(UC_X86_REG_EAX)),hex(u.reg_read(UC_X86_REG_ECX)));raise
 assert u.reg_read(UC_X86_REG_EIP)==(0x94323f if entry==0x94322c else end) and restore is None
 return u.reg_read(UC_X86_REG_EAX)
def words(a,n):return [read32(a+j*4) for j in range(n)]
cases=[]
for fresh,count,height_count,bounds_last in itertools.product([False,True],[0,1,4],[0,1,4],[0,bits(.125),0x7fa12345]):
 captures=[]
 for corrected in [False,True]:
  enabled=corrected;u.mem_write(container,b'\xcc'*0xd4);u.mem_write(owner,b'\0'*0x180);write32(container+4,bits(-.5));write32(container+0xc0,bounds_last);write32(container+0xd0,old_context)
  for j,off in enumerate(range(8,0x99,12)):
   address=heap+0x30000+j*0x100;n=(height_count if off==0x98 else count)*(3 if off in [0x2c,0x38] else 1)
   write32(container+off,address);write32(container+off+4,address+4*n);write32(container+off+8,address+0x100)
   for k in range(n):write32(address+k*4,bits(float(k+1)))
  write32(pool,container);write32(0x2d6ee04,pool);write32(0x2d6ee08,pool+4)
  if fresh:assert call(0x92ea60,container,[new_context])==container
  else:assert call(0x943b60,new_context)==container and read32(0x2d6ee08)==pool
  context_before=read32(container+0xd0);height_before=words(read32(container+0x98),(read32(container+0x9c)-read32(container+0x98))//4)
  call(0x94322c,0,eax=container)
  assert read32(owner+0xc)==container and read32(container)==owner
  captures.append(dict(context_before=context_before,context_after=read32(container+0xd0),height_before=height_before,height_after=words(read32(container+0x98),(read32(container+0x9c)-read32(container+0x98))//4),last_time=read32(container+4),active=read32(container+0xa4),bounds_last=read32(container+0xc0),minimum=words(container+0xa8,3),maximum=words(container+0xb4,3),center=words(container+0xc4,3),arrays=[(read32(container+off+4)-read32(container+off))//4 for off in range(8,0x98,12)]))
 cases.append(dict(fresh=fresh,count=count,height_count=height_count,bounds_last=bounds_last,emulator=captures[0],cpu=captures[1]))
for a in blocks:kernel.VirtualFree(a,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entries=['92EA60','943B60 recycled branch','94322C..94323F','943BE0'],cases=cases,actual_cpu_sse_operations=cpu_calls,emulator_cpu_case_disagreements=sum(c['cpu']!=c['emulator'] for c in cases),adapters=[],findings=['Fresh constructor sets context and empty13array descriptors, active0 and bounds last0. Real recycled pool pop retains original context.','Actual caller installs owner link and raw last-time-MAX, invokes943BE0. Reset clears12arrays and active count, zeroes center, initializes minMAX/max-MAX, but preserves height array98 and bounds lastC0.'],limits=['Explicit already allocated storage, vector capacities and pool descriptors; CRT/custom allocation paths, pool insertion/release and allocation failure unqualified.','Native retained heights after recycling may require additional qualification when terrain flag161 is active.'])
(r/'data/4.20/simple_storage_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),sse=cpu_calls,disagreements=proof['emulator_cpu_case_disagreements'])))
