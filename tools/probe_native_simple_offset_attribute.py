"""Whole941F00 final11C offset attribute348/364 combined with rotation lists."""
from pathlib import Path
import json,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_rotation_emission.py').read_text(encoding='utf-8').split('\ncaptures=[]')[0]
exec(compile(setup,'final offset attribute setup','exec'))
buffer=heap+0x6e000
old=next(x for x in body.splitlines() if x.startswith('for single,'))
body=body.replace(old,'for single,progress,profile,mode,present,attribute_value in itertools.product([0,1],[-.5,0.,.5,1.],[0,1],range(4),[0,1],[-2.,0.,3.]):')
marker=' sp=stack+0x8000;'
extra='''
 offset_weights=[[.5,1.,-.25],[1.5,-2.,3.],[-1.,.25,2.]];offset_weight_modes=[(mode+j+1)%4 for j in range(3)]
 data=heap+0x6f000;write32(definition+0x344,7);write32(definition+0x348,data);write32(definition+0x34c,data+36);write32(definition+0x350,data+36);u.mem_write(definition+0x364,b'\\1')
 for j,v in enumerate(x for row in offset_weights for x in row):f(data+j*4,v)
 for axis,weight_mode in enumerate(offset_weight_modes):
  probability_address=heap+0x70000+axis*0x100;u.mem_write(probability_address,b'\\0'*0x100);write32(definition+0x354+axis*4,probability_address if weight_mode else 0)
  u.mem_write(probability_address,bytes([weight_mode==1]));f(probability_address+4,.5);u.mem_write(probability_address+8,bytes([weight_mode==2]));f(probability_address+0xc,.25);f(probability_address+0x10,1.5)
  times=probability_address+0x80;probability_values=probability_address+0xc0;write32(probability_address+0x14,times);write32(probability_address+0x18,times+12);write32(probability_address+0x20,probability_values);write32(probability_address+0x24,probability_values+12)
  for j,(t,v) in enumerate(zip([0.,.5,1.],[1.,.5,2.])):f(times+j*4,t);f(probability_values+j*4,v)
 attribute_map=system+0x1b8;head=heap+0x35000;buckets=heap+0x36000;node=heap+0x37000
 write32(attribute_map+4,head);write32(attribute_map+0xc,buckets);write32(attribute_map+0x18,0);write32(attribute_map+0x1c,1)
 write32(head,node if present else head);write32(head+4,node if present else head);write32(buckets,node if present else head);write32(buckets+4,node if present else head)
 write32(node,head);write32(node+4,head);write32(node+8,7);f(node+0xc,attribute_value)
'''
assert marker in body;body=body.replace(marker,extra+marker)
body=body.replace(' calls=[];u.reg_write',' calls=[];offset_samples=[];u.reg_write')
body+='\n cases[-1].update(offset_weights=offset_weights,offset_weight_modes=offset_weight_modes,present=present,attribute_value=attribute_value,augmented_offsets=offset_samples.copy())\n'
def offset_capture(uc,address,size,user):
 if address==0x942b62:offset_samples.append([read32(u.reg_read(UC_X86_REG_EBP)-0x38+j*4) for j in range(3)])
u.hook_add(unicorn.UC_HOOK_CODE,offset_capture)
captures=[]
for corrected in [False,True]:
 enabled=corrected;exec(compile(body,'whole final offset attributes and rotations','exec'));captures.append(cases);u.hook_del(birth_observer)
rows=[dict(emulator=a,cpu=b) for a,b in zip(*captures)];assert len(rows)==384
for a in blocks:kernel.VirtualFree(a,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='941F00',cases=rows,actual_cpu_sse_operations=cpu_calls,emulator_cpu_case_disagreements=sum(c['cpu']!=c['emulator'] for c in rows),adapters=['64AEA0 reserve supplies temporary two-float vector storage; C98528 releases that supplied vector. Actual offset attribute lookup, raw weight sampling, probabilities, rotations and insertion execute.'],findings=['Final11C own component probabilities precede attribute348 component probabilities on raw sampled weight. Attribute value times weighted raw vector is added once to the own offset, then scale/rotation stages follow. Earlier A8/EC attributes use a different two-stage augmentation.'],limits=['Finite supplied vector weights and -2/0/3 present/missing attributes, valid one-bucket map, identity pose and preallocated arrays. Temporary allocator/free controlled.','Other source flags, generalized rounding, map population and ordinary graphics/audio remain incomplete.'])
assert proof['emulator_cpu_case_disagreements']==0
(r/'data/4.20/simple_offset_attribute_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(rows),sse=cpu_calls,disagreements=proof['emulator_cpu_case_disagreements'])))
