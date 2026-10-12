"""Whole941F00 life attribute, initial raw weight and per-birth probability."""
from pathlib import Path
import json,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_rate_attribute.py').read_text(encoding='utf-8').split('\ncaptures=[]')[0]
exec(compile(setup,'life attribute native setup','exec'))
marker=' sp=stack+0x8000;'
extra='''
 life_weight_table=[.5,1.,-.25,2.];life_weight_mode=(mode+2)%4
 table_address=heap+0x64000;probability_address=heap+0x65000;u.mem_write(probability_address,b'\\0'*0x100)
 write32(definition+0x3c4,7);write32(definition+0x3c8,table_address);write32(definition+0x3cc,table_address+16);write32(definition+0x3d0,table_address+16);write32(definition+0x3d4,probability_address if life_weight_mode else 0);u.mem_write(definition+0x3dc,b'\\1')
 for j,value in enumerate(life_weight_table):f(table_address+j*4,value)
 u.mem_write(probability_address,bytes([life_weight_mode==1]));f(probability_address+4,.5);u.mem_write(probability_address+8,bytes([life_weight_mode==2]));f(probability_address+0xc,.25);f(probability_address+0x10,1.5)
 times=probability_address+0x80;probability_values=probability_address+0xc0
 write32(probability_address+0x14,times);write32(probability_address+0x18,times+12);write32(probability_address+0x20,probability_values);write32(probability_address+0x24,probability_values+12)
 for j,(t,value) in enumerate(zip([0.,.5,1.],[1.,.5,2.])):f(times+j*4,t);f(probability_values+j*4,value)
'''
assert marker in body;body=body.replace(marker,extra+marker)
body=body.replace('rate_samples=[];u.reg_write','rate_samples=[];life_samples=[];u.reg_write')
body+='\n cases[-1].update(life_weight_table=life_weight_table,life_weight_mode=life_weight_mode,prepared_life=life_samples.copy())\n'
def observe_life(uc,address,size,user):
 if address==0x94210a:life_samples.append(read32(u.reg_read(UC_X86_REG_EBP)-0x48))
u.hook_add(unicorn.UC_HOOK_CODE,observe_life)
captures=[]
for corrected in [False,True]:
 enabled=corrected;exec(compile(body,'whole life attribute preparation and birth','exec'));captures.append(cases);u.hook_del(birth_observer)
rows=[dict(emulator=a,cpu=b) for a,b in zip(*captures)];assert len(rows)==384
for a in blocks:kernel.VirtualFree(a,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='941F00/93FB10/6890C0',cases=rows,actual_cpu_sse_operations=cpu_calls,emulator_cpu_case_disagreements=sum(c['cpu']!=c['emulator'] for c in rows),adapters=[],findings=['Initial life uses raw948FB0 weight3C8 without probability, plus attribute times weight. Both70/48 receive augmented life.','Per birth: own life probability multiplies augmented life; then948FF0 applies life-weight probability to that same augmented life, not to the raw weight. Attribute times this second result is added; negative life fallback follows later.'],limits=['Whole native rate and life attribute branches with supplied one-bucket map, finite selected values, variable scalar/vector tables and probabilities; all arrays, source preparation, counts and full RNG captured.','Rust life attribute production not yet ported. Generalized x87 rounding extremes, source attribute population, other attribute/rotation branches and ordinary rendering/audio remain incomplete.'])
assert proof['emulator_cpu_case_disagreements']==0
(r/'data/4.20/simple_life_attribute_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(rows),sse=cpu_calls,disagreements=proof['emulator_cpu_case_disagreements'])))
