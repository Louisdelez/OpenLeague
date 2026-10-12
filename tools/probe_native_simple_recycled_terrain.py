"""Actual recycle preparation, birth insertion and terrain follow with retained98."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_storage.py').read_text(encoding='utf-8').split('\ncases=[]')[0]
exec(compile(setup,'Recycled Simple terrain native setup','exec'))
definition=heap+0x27000;root=old_context;provider=heap+0x28000;vtable=heap+0x29000;stub=heap+0x2a000;response=heap+0x2b000;position=heap+0x2c000;velocity=heap+0x2d000;table=heap+0x3c000
u.mem_write(stub,b'\xd9\x05'+struct.pack('<I',response)+b'\xc2\x0c\x00')
def observe_height(uc,a,size,user):
 if a==stub:
  sp=u.reg_read(UC_X86_REG_ESP);value=bits(2.+len(events)*.25);events.append(dict(phase=phase,arguments=words(sp+4,3),height=value));write32(response,value)
u.hook_add(unicorn.UC_HOOK_CODE,observe_height)
def snapshot():return dict(arrays={hex(off):words(read32(container+off),(read32(container+off+4)-read32(container+off))//4) for off in range(8,0x99,12)},last_time=read32(container+4),active=read32(container+0xa4),bounds_last=read32(container+0xc0),minimum=words(container+0xa8,3),maximum=words(container+0xb4,3),center=words(container+0xc4,3))
cases=[]
for old_count,height_count,birth_count,terrain,locked,(begin,last) in itertools.product([0,3],[0,1,4,8],[1,2,4],[0,1],[0,1],[(0.,1.),(0.,0.),(.5,.5)]):
 captures=[];retained=[bits(.5+j) for j in range(height_count)]
 for corrected in [False,True]:
  enabled=corrected;events=[];phase='prepare'
  for a in [container,owner,definition,root,provider,vtable]:u.mem_write(a,b'\0'*0x410)
  write32(owner+4,definition);write32(container+0xd0,root);write32(root+8,provider);write32(provider,vtable);write32(vtable+0x58,stub);write32(container+0xc0,bits(.125));u.mem_write(definition+0x161,bytes([terrain]));u.mem_write(definition+0x160,bytes([locked]));write32(definition+0x158,bits(begin));write32(definition+0x15c,bits(last));write32(definition+0x1a0,table);write32(definition+0x1a4,table+4);write32(table,bits(1.))
  for j,off in enumerate(range(8,0x99,12)):
   address=heap+0x40000+j*0x1000;data=retained if off==0x98 else [bits(-9.)]*(old_count*(3 if off in [0x2c,0x38] else 1))
   write32(container+off,address);write32(container+off+4,address+4*len(data));write32(container+off+8,address+0x100)
   for k,v in enumerate(data):write32(address+k*4,v)
  call(0x94322c,0,eax=container);after_reset=snapshot();phase='birth'
  for j in range(birth_count):
   for k,v in enumerate([3.+j,4.,5.]):write32(position+k*4,bits(v))
   for k,v in enumerate([.25,-.5,1.]):write32(velocity+k*4,bits(v))
   call(0x943cd0,container,[bits(10.125),bits(2.),position,velocity,bits(-.5),bits(500.),bits(.5),bits(.125)])
  after_birth=snapshot();phase='follow';call(0x9456e0,container)
  captures.append(dict(after_reset=after_reset,after_birth=after_birth,after_follow=snapshot(),events=events.copy()))
 cases.append(dict(old_count=old_count,retained=retained,birth_count=birth_count,terrain=terrain,locked=locked,begin=bits(begin),last=bits(last),emulator=captures[0],cpu=captures[1]))
for a in blocks:kernel.VirtualFree(a,0,0x8000)
assert len(cases)==288
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entries=['94322C..94323F','943BE0','943CD0','9456E0'],cases=cases,actual_cpu_sse_operations=cpu_calls,emulator_cpu_case_disagreements=sum(c['cpu']!=c['emulator'] for c in cases),adapters=['Virtual height provider58 captures phase and X/Z/Y, returns supplied binary32 sequence through actual FLD/RET12 stub; real terrain provider unqualified.'],findings=['After real reset,98 retains prior heights. New birth always appends terrain height to98, even when its length exceeds birth array length. Following reads indices0..particle_count and preserves excess98suffix.'],limits=['Already allocated capacities, finite supplied parameters, constant scale and no probability resources. Actual recycle caller/reset/insertion/follow bodies execute; no native whole emission or whole frame in this fixture.','Real terrain provider, memory backend and ordinary rendering remain incomplete.'])
(r/'data/4.20/simple_recycled_terrain_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),sse=cpu_calls,disagreements=proof['emulator_cpu_case_disagreements'])))
