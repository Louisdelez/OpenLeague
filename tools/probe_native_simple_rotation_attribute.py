"""Whole941F00 scalar rotation attribute alongside rate/life/vector attributes."""
from pathlib import Path
import json,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_vector_attributes.py').read_text(encoding='utf-8').split('\ncaptures=[]')[0]
exec(compile(setup,'rotation attribute native setup','exec'))
marker=' sp=stack+0x8000;'
extra='''
 rotation_weight_table=[1.,.5,-2.,3.];rotation_weight_mode=(mode+3)%4
 table_address=heap+0x6c000;probability_address=heap+0x6d000;u.mem_write(probability_address,b'\\0'*0x100)
 write32(definition+0x3a8,7);write32(definition+0x3ac,table_address);write32(definition+0x3b0,table_address+16);write32(definition+0x3b4,table_address+16);write32(definition+0x3b8,probability_address if rotation_weight_mode else 0);u.mem_write(definition+0x3c0,b'\\1')
 for j,value in enumerate(rotation_weight_table):f(table_address+j*4,value)
 u.mem_write(probability_address,bytes([rotation_weight_mode==1]));f(probability_address+4,.5);u.mem_write(probability_address+8,bytes([rotation_weight_mode==2]));f(probability_address+0xc,.25);f(probability_address+0x10,1.5)
 times=probability_address+0x80;probability_values=probability_address+0xc0;write32(probability_address+0x14,times);write32(probability_address+0x18,times+12);write32(probability_address+0x20,probability_values);write32(probability_address+0x24,probability_values+12)
 for j,(t,value) in enumerate(zip([0.,.5,1.],[1.,.5,2.])):f(times+j*4,t);f(probability_values+j*4,value)
'''
assert marker in body;body=body.replace(marker,extra+marker)
body=body.replace('vector_samples=[];u.reg_write','vector_samples=[];rotation_samples=[];u.reg_write')
body+='\n cases[-1].update(rotation_weight_table=rotation_weight_table,rotation_weight_mode=rotation_weight_mode,prepared_rotation=rotation_samples.copy())\n'
def observe_rotation(uc,address,size,user):
 if address==0x9422b6:rotation_samples.append(read32(u.reg_read(UC_X86_REG_EBP)-0xb8))
u.hook_add(unicorn.UC_HOOK_CODE,observe_rotation)
captures=[]
for corrected in [False,True]:
 enabled=corrected;exec(compile(body,'whole scalar rotation attribute stages','exec'));captures.append(cases);u.hook_del(birth_observer)
rows=[dict(emulator=a,cpu=b) for a,b in zip(*captures)];assert len(rows)==384
for a in blocks:kernel.VirtualFree(a,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='941F00',cases=rows,actual_cpu_sse_operations=cpu_calls,emulator_cpu_case_disagreements=sum(c['cpu']!=c['emulator'] for c in rows),adapters=[],findings=['Rotation108 plus attribute times raw3AC weight prepares rotation3C/B8. Per birth own probability precedes3AC probability applied to augmented rotation, then attribute multiplication/addition. Negative rotation remains signed; no negative-life fallback.'],limits=['Whole native rate/life/position/velocity/rotation attribute branches with supplied finite tables and -2/0/3 attributes, actual map lookup, identity pose and preallocated arrays.','Rotation lists, x87 rounding extremes, source attribute population and ordinary graphics/audio integration remain incomplete.'])
assert proof['emulator_cpu_case_disagreements']==0
(r/'data/4.20/simple_rotation_attribute_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(rows),sse=cpu_calls,disagreements=proof['emulator_cpu_case_disagreements'])))
