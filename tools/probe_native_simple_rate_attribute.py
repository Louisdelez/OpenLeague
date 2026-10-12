"""Whole941F00 rate-attribute augmentation with actual hash lookup and RNG."""
from pathlib import Path
import json,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_rate_source.py').read_text(encoding='utf-8').split('\ncaptures=[]')[0]
exec(compile(setup,'rate attribute native setup','exec'))
old=next(x for x in body.splitlines() if x.startswith('for single,'))
body=body.replace(old,'for single,progress,profile,mode,present,attribute_value in itertools.product([0,1],[-.5,0.,.5,1.],[0,1],range(4),[0,1],[-2.,0.,3.]):\n gate=0')
marker=' sp=stack+0x8000;'
extra='''
 weight_table=[1.,2.,-1.,.5];weight_mode=(mode+1)%4
 weight_address=heap+0x62000;probability_address=heap+0x63000;u.mem_write(probability_address,b'\\0'*0x100)
 write32(definition+0x38c,7);write32(definition+0x390,weight_address);write32(definition+0x394,weight_address+16);write32(definition+0x398,weight_address+16);write32(definition+0x39c,probability_address if weight_mode else 0);u.mem_write(definition+0x3a4,b'\\1')
 for j,value in enumerate(weight_table):f(weight_address+j*4,value)
 u.mem_write(probability_address,bytes([weight_mode==1]));f(probability_address+4,.5);u.mem_write(probability_address+8,bytes([weight_mode==2]));f(probability_address+0xc,.25);f(probability_address+0x10,1.5)
 times=probability_address+0x80;probability_values=probability_address+0xc0
 write32(probability_address+0x14,times);write32(probability_address+0x18,times+12);write32(probability_address+0x20,probability_values);write32(probability_address+0x24,probability_values+12)
 for j,(t,value) in enumerate(zip([0.,.5,1.],[1.,.5,2.])):f(times+j*4,t);f(probability_values+j*4,value)
 attribute_map=system+0x1b8;head=heap+0x35000;buckets=heap+0x36000;node=heap+0x37000
 write32(attribute_map+4,head);write32(attribute_map+0xc,buckets);write32(attribute_map+0x18,0);write32(attribute_map+0x1c,1)
 write32(head,node if present else head);write32(head+4,node if present else head);write32(buckets,node if present else head);write32(buckets+4,node if present else head)
 write32(node,head);write32(node+4,head);write32(node+8,7);f(node+0xc,attribute_value)
'''
assert marker in body;body=body.replace(marker,extra+marker)
body=body.replace(' calls=[];u.reg_write',' calls=[];rate_samples=[];u.reg_write')
body+='\n cases[-1].update(weight_table=weight_table,weight_mode=weight_mode,present=present,attribute_value=attribute_value,effective_rate=rate_samples.copy())\n'
def observe_rate(uc,address,size,user):
 if address==0x942002:rate_samples.append(read32(u.reg_read(UC_X86_REG_EBP)-0x3c))
u.hook_add(unicorn.UC_HOOK_CODE,observe_rate)
captures=[]
for corrected in [False,True]:
 enabled=corrected;exec(compile(body,'whole emission rate attribute branch','exec'));captures.append(cases);u.hook_del(birth_observer)
rows=[dict(emulator=a,cpu=b) for a,b in zip(*captures)];assert len(rows)==384
for a in blocks:kernel.VirtualFree(a,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='941F00/93FB10/6890C0',cases=rows,actual_cpu_sse_operations=cpu_calls,emulator_cpu_case_disagreements=sum(c['cpu']!=c['emulator'] for c in rows),adapters=[],limits=['Actual rate attribute3A4 branch: sampled390 weight and probability, actual93FB10/6890C0 present/missing lookup, x87 multiplication/addition, whole normal/single emission and scalar/vector shared RNG captured.','Selected finite tables and attributes -2/0/3, supplied valid one-bucket map, identity pose and preallocated memory. Other attribute branches, generalized rounding extremes, map population and ordinary rendering/audio remain incomplete.'])
assert proof['emulator_cpu_case_disagreements']==0
(r/'data/4.20/simple_rate_attribute_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(rows),sse=cpu_calls,disagreements=proof['emulator_cpu_case_disagreements'])))
