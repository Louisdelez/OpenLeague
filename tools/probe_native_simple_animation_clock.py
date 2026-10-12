"""943A21..943A81 animation clock including exact CPU unsigned x87 duration."""
from pathlib import Path
import json,datetime,ctypes,shutil,itertools,random,struct,math
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_troy_frame_timing.py').read_text(encoding='utf-8').split('\ncases=[]')[0]
setup=setup.replace("'0x93f45b<=a<0x93f5c0'", "'0x943a21<=a<0x943a81'").replace('u.hook_add(unicorn.UC_HOOK_CODE,timing_hook)','timing_hook_id=u.hook_add(unicorn.UC_HOOK_CODE,timing_hook)')
exec(compile(setup,'animation clock setup','exec'));u.hook_del(timing_hook_id)
machine=bytes.fromhex('89c94883ec1848890c2489542408df2c24d84c2408d91c248b04244883c418c3');address=kernel.VirtualAlloc(None,4096,0x3000,0x40);ctypes.memmove(address,machine,len(machine));blocks.append(address);duration_cpu=ctypes.CFUNCTYPE(ctypes.c_uint32,ctypes.c_uint32,ctypes.c_uint32)(address);duration_calls=0
instance=heap+0x9000;clip=heap+0xa000
def clock_hook(uc,a,size,user):
 global duration_calls
 if a==0x943a81:u.emu_stop();return
 if enabled and a==0x943a48:
  value=duration_cpu(read32(clip+0x14),read32(clip+0x18));duration_calls+=1;write32(u.reg_read(UC_X86_REG_ESP)+0x14,value);u.reg_write(UC_X86_REG_EIP,0x943a5c);return
 reset_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,clock_hook)
f=lambda v:struct.unpack('<f',struct.pack('<I',v))[0]
inputs=[]
times=[(bits(1.),bits(.5),bits(.125)),(0,0,0),(bits(-1.),0,0),(0x7fa01234,0,bits(.5)),(0x7f800000,0x7f800000,bits(.5))]
for kind,n,rate,(time,baseline,old) in itertools.product([0,0x6d6e6163],[0,1,2,20,0x7fffffff,0x80000000,0xffffffff],[0,bits(.125),bits(.5),bits(1.),bits(2.),0x7f800000,0x7fa01234,0x7fc01234],times):
 duration=rate if kind==0x6d6e6163 else duration_cpu(n,rate);current=f(cpu_functions['addss'](cpu_functions['subss'](time,baseline),old));d=f(duration)
 if current>=d and (not math.isfinite(current) or not math.isfinite(d) or d<=0 or current/d>100):continue
 inputs.append((kind,n,rate,time,baseline,old))
rng=random.Random(420)
for _ in range(256):inputs.append((0,rng.choice([1,2,20,0x7fffffff,0x80000000,0xffffffff]),bits(rng.uniform(.125,10)),bits(rng.uniform(-2,10)),bits(rng.uniform(-2,10)),bits(rng.uniform(-1,2))))
inputs.extend([(0,1,0x7f800000,0x7f800000,0,0),(0x6d6e6163,0,0x7f800000,0x7f800000,0,0)])
cases=[]
for kind,n,rate,time,baseline,old in inputs:
 captures=[]
 for corrected in [False,True]:
  enabled=corrected;events=[];u.mem_write(instance,b'\0'*0x140);u.mem_write(clip,b'\0'*0x30);write32(instance+0x114,old);write32(clip+4,kind);write32(clip+0x14,n);write32(clip+0x18,rate)
  sp=stack+0x8000;u.mem_write(sp-0x100,b'\0'*0x200);write32(frame+8,time);write32(sp+0x10,baseline);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_EBX,instance);u.reg_write(UC_X86_REG_ECX,clip);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x943a21,0x943a81,count=10000);assert u.reg_read(UC_X86_REG_EIP)==0x943a81
  captures.append({'clock':hex(read32(instance+0x114)),'duration':hex(u.reg_read(UC_X86_REG_XMM1)&0xffffffff)})
 cases.append({'kind':kind,'frames':n,'rate':hex(rate),'time':hex(time),'baseline':hex(baseline),'old_clock':hex(old),'emulator':captures[0],'cpu':captures[1]})
assert read32(0x1139280)==0x4f800000
duration_inputs=list(itertools.product([0,1,2,20,0x7fffffff,0x80000000,0xffffffff],[0,0x80000000,1,0x007fffff,0x00800000,0x3f800000,0xbf800000,0x7f7fffff,0xff7fffff,0x7f800000,0xff800000,0x7fa01234,0xffa05678,0x7fc01234]))
for _ in range(256):duration_inputs.append((rng.getrandbits(32),rng.getrandbits(32)))
duration_cases=[{'frames':n,'factor':hex(v),'cpu':hex(duration_cpu(n,v))} for n,v in duration_inputs]
for address in blocks:kernel.VirtualFree(address,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'range':'943A21..943A81','cases':cases,'duration_cases':duration_cases,'actual_cpu_sse_operations':cpu_calls,'actual_cpu_x87_duration_operations':duration_calls,'emulator_cpu_case_disagreements':sum(c['emulator']!=c['cpu'] for c in cases),'adapters':['Whole native clock advance/wrap executes with explicit clip metadata. CANM kind6D6E6163 uses raw duration; other clip kinds use unsigned frame count times raw rate in x87 before single rounding.','Independent actual CPU unsigned integer x87 multiplication supplies duration; original VM captures preserved. No endpoint calls in this fragment.'],'limits':['Unbounded native wrap inputs excluded: nonpositive duration when wrap entered, nonfinite clock with finite duration, excessive iteration counts.','Clip lookup/evaluation and metadata producers, remaining frame finalization and ordinary integration incomplete. Default FP controls only.']}
(r/'data/4.20/simple_animation_clock_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'x87':duration_calls,'disagreements':proof['emulator_cpu_case_disagreements']}))
