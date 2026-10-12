"""Native Simple whole-frame cycle for the authored invisible ambient child."""
from pathlib import Path
import json,struct,math
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_simple_cycle.py').read_text().split('frames=[]')[0]
prefix=prefix.replace("write32(definition+0x17c,1);u.mem_write(definition+0x151,b'\\1')",'')
exec(compile(prefix,'native ambient setup','exec'))
# Explicit authored ambient values; keep other executed constructor defaults.
f(instance+0x10,3.4028234663852886e38)
write32(definition+0x17c,0);u.mem_write(definition+0x151,b'\0')
f(read32(definition+0x88),0.);f(read32(definition+0xd8),0.)
frames=[]
for age,ended in [(0.,False),(.125,False),(.5,False),(1.,False),(1.125,False),(2.,False),(3.,False),(3.125,True)]:
 write32(system+0x1dc,0x10 if ended else 0)
 for i,x in enumerate(identity):f(system+0xf0+4*i,x)
 for i,x in enumerate([100.+age*10.,200.,300.]):f(system+0x90+4*i,x)
 write32(sp,end);f(sp+4,10.+age);f(sp+8,.125);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,instance)
 u.emu_start(0x9437e0,end,count=200000);assert u.reg_read(UC_X86_REG_EIP)==end
 n=(read32(container+0xc)-read32(container+8))//4
 finished=u.mem_read(instance+8,1)[0]
 frames.append({'age':age,'ended':ended,'slots':n,'active':read32(container+0xa4),'finished':finished,'life_bits':[read32(read32(container+0x14)+4*i) for i in range(n)],'age_bits':[read32(read32(container+0x20)+4*i) for i in range(n)]})
 assert finished==int(ended),(age,finished)
proof={'passed':True,'native_sha256':digest,'entry':'0x9437e0','frames':frames,'birth_calls':birth_calls,'initialization_adapters':initialization_adapters,'runtime_adapters':[],'limits':['Authored constant life0/rate1/scale0 and effective maximum emitter life supplied, single0/local0 explicitly supplied. Other values from constructor, not full resource reader.','Preallocated arrays, owner pose/time, RNG and explicit end flag. No full parent frame, audio or graphics validation.']}
(r/'data/4.20/ambient_simple_cycle_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps({'passed':True,'frames':frames}))
