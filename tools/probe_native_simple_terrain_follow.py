"""Whole9456E0 terrain following; height provider is an explicit endpoint."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_movement.py').read_text(encoding='utf-8').split('\ncontainer=')[0]
exec(compile(setup,'Simple terrain setup','exec'))
cpu_hook.__code__=cpu_hook.__code__.replace(co_consts=tuple(0x945863 if c==0x945120 else c for c in cpu_hook.__code__.co_consts))
container=heap+0x22000;owner=heap+0x23000;definition=heap+0x24000;ages=heap+0x25000;positions=heap+0x26000;previous=heap+0x27000;root=heap+0x28000;provider=heap+0x29000;vtable=heap+0x2a000;stub=heap+0x2b000;response=heap+0x2c000
u.mem_write(stub,b'\xd9\x05'+struct.pack('<I',response)+b'\xc2\x0c\x00')
def words(a,n):return [read32(a+j*4) for j in range(n)]
def observe(uc,a,size,user):
 if a==stub:
  sp=u.reg_read(UC_X86_REG_ESP);index=len(events);events.append({'arguments':words(sp+4,3),'height':height_values[index]});write32(response,height_values[index])
u.hook_add(unicorn.UC_HOOK_CODE,observe)
cases=[]
for present,enabled_flag,locked,count,(begin,last),profile,height_profile in itertools.product([False,True],[0,1,2],[0,1],[0,1,4],[(0.,1.),(.25,.75),(.5,.5),(1.,0.),(0.,.0000001)],range(2),range(2)):
 age_values=[[0,bits(.5),bits(1.),0x7fa01234],[bits(-.5),bits(.999),0xff800000,0x7fa01234]][profile][:count];initial_positions=[bits(v) for j in range(count) for v in [3.+j,4.+j,-2.]];initial_previous=[bits(j*.5) for j in range(count)];height_values=[bits(0. if height_profile==0 else 2.+j) for j in range(count)];captures=[]
 for corrected in [False,True]:
  enabled=corrected;events=[]
  for address in [container,owner,definition,root,provider,vtable]:u.mem_write(address,b'\0'*0x200)
  write32(container,owner if present else 0);write32(owner+4,definition);u.mem_write(definition+0x161,bytes([enabled_flag]));u.mem_write(definition+0x160,bytes([locked]));write32(definition+0x158,bits(begin));write32(definition+0x15c,bits(last));write32(container+8,ages);write32(container+0xc,ages+count*4);write32(container+0x20,ages);write32(container+0x2c,positions);write32(container+0x98,previous);write32(container+0xd0,root);write32(root+8,provider);write32(provider,vtable);write32(vtable+0x58,stub)
  for address,data in [(ages,age_values),(positions,initial_positions),(previous,initial_previous)]:
   for j,v in enumerate(data):write32(address+j*4,v)
  sp=stack+0x8000;u.mem_write(sp-0x100,b'\0'*0x140);write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,container);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x9456e0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==sp+4 and restore is None
  captures.append({'positions':words(positions,count*3),'previous':words(previous,count),'ages':words(ages,count),'events':events.copy()})
 cases.append({'present':present,'enabled':enabled_flag,'locked':locked,'begin':bits(begin),'last':bits(last),'ages':age_values,'positions':initial_positions,'previous':initial_previous,'heights':height_values,'emulator':captures[0],'cpu':captures[1]})
epsilon=struct.unpack('<d',u.mem_read(0x1138c08,8))[0]
for address in blocks:kernel.VirtualFree(address,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'9456E0','epsilon':epsilon,'cases':cases,'actual_cpu_sse_operations':cpu_calls,'emulator_cpu_case_disagreements':sum(c['cpu']!=c['emulator'] for c in cases),'adapters':['Virtual height provider58 captures X/Z/Y arguments and returns supplied binary32 height through an actual FLD/RET12 stub; native terrain provider implementation is not qualified.'],'limits':['Original9456E0 body, flags161/160, ordered ages, zero/positive/negative interval and clamp execute; supplied owner/root/arrays. Selected finite authored intervals and positions.','Height source, ordinary Map10 rendering and full particle cycle remain incomplete.']}
(r/'data/4.20/simple_terrain_follow_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'disagreements':proof['emulator_cpu_case_disagreements'],'epsilon':epsilon}))
