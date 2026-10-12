"""Original9452F1..945466 inline baked/probability scalar multiplied by container50."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_movement.py').read_text(encoding='utf-8').split('\ncontainer=')[0]
exec(compile(setup,'Simple scalar phase native setup','exec'))
cpu_hook.__code__=cpu_hook.__code__.replace(co_consts=tuple(0x945466 if c==0x945120 else c for c in cpu_hook.__code__.co_consts))
container=heap+0x22000;instance=heap+0x23000;definition=heap+0x24000;ages=heap+0x25000;output=heap+0x26000;table=heap+0x27000;probability=heap+0x28000;times=heap+0x29000;values=heap+0x2a000;factors=heap+0x2b000;frame=stack+0x4000;conversion_count=0
def words(a,n):return [read32(a+j*4) for j in range(n)]
def phase_hook(uc,a,size,user):
 global conversion_count
 if a==0x945466:u.emu_stop();return
 if enabled and 0x9452f1<=a<0x945466:
  ins=next(cs.disasm(bytes(u.mem_read(a,size)),a),None)
  if ins and ins.mnemonic in conversion_functions:
   dest,source=ins.operands;dr=getattr(registers,'UC_X86_REG_'+ins.reg_name(dest.reg).upper());sr=getattr(registers,'UC_X86_REG_'+ins.reg_name(source.reg).upper());value=u.reg_read(sr)&0xffffffff;converted=conversion_functions[ins.mnemonic](value);conversion_count+=1
   u.reg_write(dr,(u.reg_read(dr)&~0xffffffff)|converted if ins.mnemonic=='cvtsi2ss' else converted);u.reg_write(UC_X86_REG_EIP,a+size)
u.hook_add(unicorn.UC_HOOK_CODE,phase_hook)
cases=[]
for active,table_count,mode,count,profile,seed in itertools.product([True],[1,3,7],range(4),[0,1,4],range(3),[0,17,0xffffffff]):
 initial_ages=[[0,bits(.25),bits(.999),bits(1.)],[bits(-.5),0,bits(.5),0x7fa01234],[0xff800000,bits(1.),bits(.5),0x7fa01234]][profile][:count];initial=[0xcccccccc+j for j in range(count)];table_values=[bits(float(j+1)) for j in range(table_count)];rng=[(12345+13579*j)^seed for j in range(55)];captures=[]
 for corrected in [False,True]:
  enabled=corrected;u.mem_write(container,b'\0'*0xb0);u.mem_write(instance,b'\0'*0x160);u.mem_write(definition,b'\0'*0x200);u.mem_write(probability,b'\0'*0x40);write32(container,instance);write32(instance+4,definition);u.mem_write(definition+0x1c8,bytes([int(active)]));write32(definition+0x1a0,table);write32(definition+0x1a4,table+table_count*4);write32(definition+0x1ac,probability if mode else 0);write32(container+0x20,ages);write32(container+0x44,output);write32(container+0x50,factors)
  for address,data in [(ages,initial_ages),(output,initial),(table,table_values),(factors,[bits(1.+j*.5) for j in range(count)])]:
   for j,v in enumerate(data):write32(address+j*4,v)
  if mode==1:u.mem_write(probability,b'\1');write32(probability+4,bits(.5))
  if mode==2:u.mem_write(probability+8,b'\1');write32(probability+0xc,bits(.25));write32(probability+0x10,bits(1.5))
  if mode==3:
   write32(probability+20,times);write32(probability+24,times+12);write32(probability+32,values);write32(probability+36,values+12)
   for j,(t,v) in enumerate([(0.,1.),(.5,.5),(1.,2.)]):write32(times+j*4,bits(t));write32(values+j*4,bits(v))
  write32(0x2d6ece4,0);write32(0x2d6ece8,0)
  for j,v in enumerate(rng):write32(0x2d6ec08+j*4,v)
  sp=stack+0x8000;u.mem_write(sp-0x100,b'\0'*0x140);u.mem_write(frame-0x100,b'\0'*0x140);write32(frame-8,count);write32(frame-0x14,container);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_EDI,container);u.reg_write(UC_X86_REG_ESI,count);u.reg_write(UC_X86_REG_XMM1,bits(1.));u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x9452f1,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==0x945466 and u.reg_read(UC_X86_REG_ESP)==sp and restore is None
  captures.append({'output':words(output,count),'rng':words(0x2d6ec08,55),'first':read32(0x2d6ece4),'second':read32(0x2d6ece8)})
 cases.append({'active':active,'table':table_values,'mode':mode,'ages':initial_ages,'initial':initial,'rng':rng,'factors':[bits(1.+j*.5) for j in range(count)],'emulator':captures[0],'cpu':captures[1]})
for address in blocks:kernel.VirtualFree(address,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'range':'9452F1..945466','cases':cases,'actual_cpu_sse_operations':cpu_calls,'actual_cpu_conversion_operations':conversion_count,'emulator_cpu_case_disagreements':sum(c['cpu']!=c['emulator'] for c in cases),'adapters':[],'limits':['Actual inline scalar lookup, inline RNG body and probability91B770 execute. Explicit definition table1A0/1A4/probability1AC and arrays44/50 supplied. One-element table skips all writes/draws; authored field names not inferred.','Selected finite table/probability fields; negative/infinite/NaN ages, default FP mode and zeroed caller frame. Remaining scalar integration and ordinary rendering incomplete.']}
(r/'data/4.20/simple_scaled_scalar_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'conversions':conversion_count,'disagreements':proof['emulator_cpu_case_disagreements']}))
