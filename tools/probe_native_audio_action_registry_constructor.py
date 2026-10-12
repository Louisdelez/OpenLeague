from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
registry=vector+0x1000;first=vector+0x2000;second=vector+0x3000;calls=[];visited=set();fail_first=fail_second=False;section_pattern=0;section_result=1
regions=[('registry',registry,108),('first_pool',first,96),('second_pool',second,128)]
def snap():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
def hook(uc,a,size,data):
 if a==read(0xfa41a0):
  sp=u.reg_read(UC_X86_REG_ESP);section=read(sp+4);assert section==registry+68;calls.append({'kind':'initialize_critical_section','receiver':section,'supplied_pattern':section_pattern,'result':section_result,'at_call':snap()});u.mem_write(section,bytes([section_pattern])*24);finish(section_result,4);return
 if a==0xada670:
  sp=u.reg_read(UC_X86_REG_ESP);size=read(sp+8);assert size in[96,128];result=0 if(fail_first if size==96 else fail_second)else(first if size==96 else second);calls.append({'kind':'allocate','pool':read(sp+4),'size':size,'result':result,'at_call':snap()});finish(result);return
 assert 0xaf66c0<=a<0xaf672b or 0xaf6b80<=a<0xaf6c5f,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(0x12100dc,19);rows=[]
for pattern,section_pattern,section_result,fail_first,fail_second in itertools.product([0,0xa5,0xff],[0x11,0xcc],[0,1],[False,True],[False,True]):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 before=snap();calls.clear();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,registry);u.emu_start(0xaf66c0,end,count=1000);assert u.reg_read(UC_X86_REG_EAX)==registry;constructor_calls=list(calls);after_constructor=snap()
 calls.clear();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,registry);u.emu_start(0xaf6b80,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end;result=u.reg_read(UC_X86_REG_EAX);assert result==(52 if fail_first or fail_second else 1)
 rows.append({'pattern':pattern,'section_pattern':section_pattern,'section_result':section_result,'fail_first':fail_first,'fail_second':fail_second,'before':before,'constructor_calls':constructor_calls,'after_constructor':after_constructor,'initialization_calls':list(calls),'after':snap(),'result':result})
d={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual AF66C0 108-byte registry constructor and AF6B80 initialization execute; pools96/128 form eight12-byte/eight16-byte free-list slots. Constructor preserves untouched bytes; actual allocation-failure paths return52 and preserve partial state, including retained first pool on second failure.','Windows critical-section initialization is supplied24-byte ABI mutation and0/1 return. Native constructor ignores this API return. Allocator supplied mapped blocks or null; no physical OS or allocator qualification. Registry object storage supplied; startup allocation/publishing, key table population, destruction and Rust replay remain required.']}
(r/'data/4.20/audio_action_registry_constructor_preparation.json').write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual108byte registry constructor/two-pool initialization/partial OOM cases')
