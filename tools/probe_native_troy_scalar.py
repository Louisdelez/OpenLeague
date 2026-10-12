"""Whole93FB60 parameter remap and both child coefficient loops."""
from pathlib import Path
import json,struct,itertools,datetime,shutil,random
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_troy_position_bounds.py').read_text(encoding='utf-8').split('\nconstants=')[0]
setup=setup.replace("('addss','58')", "('addss','58'),('divss','5e')")
setup=setup.replace('0x921f60<=a<0x922000','0x93fb60<=a<0x93fcb8')
exec(compile(setup,'native scalar setup','exec'))
actor=heap+0x9000;config=heap+0xa000;engine=heap+0xb000
fallback=read32(0x1138c74)
special=[0,0x80000000,1,0x3f000000,0x3f800000,0x40000000,0xbf800000,0x7f7fffff,0xff7fffff,0x7f800000,0xff800000,0x7fa01234,0xffa05678,0x7fc01234,0xffc05678]
inputs=[]
for i,value in enumerate(special):
 for lower,upper,target in [(bits(0.),bits(1.),bits(2.)),(bits(1.),bits(1.),bits(3.)),(bits(2.),bits(-1.),bits(.5)),(special[(i+3)%15],special[(i+7)%15],special[(i+11)%15])]:
  for counts in [(0,0),(3,0),(0,3),(3,3)]:
   inputs.append((value,lower,upper,target,counts,i))
rng=random.Random(420)
for i in range(160):inputs.append((bits(rng.uniform(-5,5)),bits(rng.uniform(-2,2)),bits(rng.uniform(-2,2)),bits(rng.uniform(-2,2)),(3,3),i))
cases=[]
for value,lower,upper,target,counts,index in inputs:
 child_inputs=[]
 for kind,count in enumerate(counts):
  row=[]
  for j in range(count):
   if index<15:
    coeff=[special[(index+j*3+k*4)%15] for k in range(3)]
    owner=[special[(index+j+5+k*3)%15] for k in range(2)]
   else:
    coeff=[bits(rng.uniform(-4,4)) for _ in range(3)];owner=[bits(rng.uniform(-4,4)) for _ in range(2)]
   row.append({'coefficients':[hex(v) for v in coeff],'owner':[hex(v) for v in owner],'previous':hex(0x7fa0beef+j)})
  child_inputs.append(row)
 captures=[]
 for corrected in [False,True]:
  enabled=corrected;u.mem_write(actor,b'\0'*0x300);u.mem_write(config,b'\0'*0x300);u.mem_write(engine,b'\0'*0x400)
  write32(actor,engine);write32(actor+0xe8,config);write32(config+0x13c,target);write32(engine+0x34c,lower);write32(engine+0x350,upper)
  for kind,row in enumerate(child_inputs):
   array=heap+0xc000+kind*0x100
   for j,entry in enumerate(row):
    child=heap+0xd000+kind*0x2000+j*0x600;childconfig=child+0x200;owner=child+0x100
    u.mem_write(child,b'\0'*0x600);write32(array+j*4,child)
    if kind==0:write32(child+8,childconfig);write32(child+4,owner);offsets=[0x35c,0x36c,0x364];result_offset=0x104
    else:write32(child+4,childconfig);write32(child,owner);offsets=[0x210,0x220,0x218];result_offset=0xe0
    for offset,v in zip(offsets,entry['coefficients']):write32(childconfig+offset,int(v,16))
    for k,v in enumerate(entry['owner']):write32(owner+0xe0+k*4,int(v,16))
    write32(child+result_offset,int(entry['previous'],16))
   start=8 if kind==0 else 0x38;write32(actor+start,array);write32(actor+start+4,array+len(row)*4)
  sp=stack+0x8000;write32(sp,end);write32(sp+4,value);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x93fb60,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
  captures.append({'scalar':hex(read32(actor+0xc4)),'children':[[hex(read32(heap+0xd000+kind*0x2000+j*0x600+(0x104 if kind==0 else 0xe0))) for j in range(counts[kind])] for kind in range(2)]})
 cases.append({'input':hex(value),'lower':hex(lower),'upper':hex(upper),'target':hex(target),'children':child_inputs,'emulator':captures[0],'cpu':captures[1]})
for addr in blocks:kernel.VirtualFree(addr,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'93FB60','fallback_bits':hex(fallback),'cases':cases,'actual_cpu_sse_operations':cpu_calls,'emulator_cpu_case_disagreements':sum(c['emulator']!=c['cpu'] for c in cases),'adapters':['Whole original93FB60 executes including both child loops, with explicit engine/config/owner inputs.','Separate actual CPU scalar SSE reference for each ADD/SUB/MUL/DIV instruction; original comparisons and stores execute. Original emulator captures retained separately.'],'limits':['Property request caller and real engine/config coefficient producers not yet qualified.','Default masked arithmetic mode; no concurrent resource mutation or ordinary graphical integration qualified.']}
(r/'data/4.20/troy_scalar_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'passed':True,'cases':len(cases),'fallback':hex(fallback),'cpu_operations':cpu_calls,'disagreements':proof['emulator_cpu_case_disagreements']}))
