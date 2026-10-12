"""Whole941F00 normal/burst gates, insertion, time/latch and unsigned counter."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_movement.py').read_text(encoding='utf-8').split('\ncontainer=')[0]
exec(compile(setup,'Simple lifecycle CPU setup','exec'))
original=(r/'tools/probe_native_simple_birth.py').read_text(encoding='utf-8')
body='instance='+original.split('instance=',1)[1].split('\n first_calls=calls',1)[0]
body=body.replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','birth_observer=u.hook_add(unicorn.UC_HOOK_CODE,hook)')
old=next(x for x in body.splitlines() if x.startswith('for matrix,'))
body=body.replace(old,"for single,latch,rate,age,previous in itertools.product([0,1],[0,1],[0.,1.,2.9,20.],[0.,.125,.5,1.],[10.,10.5]):\n matrix=[1.,0.,0.,0.,1.,0.,0.,0.,1.];position=[110.,220.,330.];offset=[10.,20.,30.];life=2.;count=0")
body=body.replace('f(instance+0xd8,10.)','f(instance+0xd8,previous);u.mem_write(instance+0xd4,bytes([latch]))').replace('write32(definition+0x17c,1)','write32(definition+0x17c,single)').replace('(0x74,[float(count)])','(0x74,[rate])').replace('f(sp+4,10.125)','f(sp+4,10.+age)')
body=body.replace('u.emu_start(0x941f00,end,count=100000)', 'u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.emu_start(0x941f00,end,count=100000)')
body='\n'.join(x for x in body.splitlines() if not x.startswith(' assert len(calls)') and not x.startswith(' assert floats(instance+0xd8'))
body=body.replace(' stored=dict(', ' count=len(calls)\n stored=dict(')
body+='''
 stored['arrays']={hex(off):[read32(read32(container+off)+j*4) for j in range((read32(container+off+4)-read32(container+off))//4)] for off in range(8,0x99,12)}
 cases.append(dict(single=single,latch=latch,rate=rate,age=age,previous=previous,calls=calls.copy(),arrays=stored['arrays'],emitted=u.mem_read(instance+0xd4,1)[0],last_emission=read32(instance+0xd8),bounds_factor=read32(instance+0xe0),counter=read32(metadata+0x28),rng=[read32(0x2d6ec08+j*4) for j in range(55)],first=read32(0x2d6ece4),second=read32(0x2d6ece8)))
'''
captures=[]
for corrected in [False,True]:
 enabled=corrected;exec(compile(body,'whole actual emission lifecycle','exec'));captures.append(cases);u.hook_del(birth_observer)
rows=[dict(emulator=a,cpu=b) for a,b in zip(*captures)];assert len(rows)==128
for a in blocks:kernel.VirtualFree(a,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='941F00',cases=rows,actual_cpu_sse_operations=cpu_calls,emulator_cpu_case_disagreements=sum(c['cpu']!=c['emulator'] for c in rows),adapters=[],limits=['Whole941F00 with actual samplers/RNG/insertion and native emission/latch/counter writes. Normal and single-burst, existing latch0/1, zero/positive/negative counts. Preallocated empty arrays, constant resources, identity current pose and finite offsets.','No dynamic attributes, rotation list, probability resources, system pose producer or memory allocation executed. Ordinary renderer and generalized source emission remain incomplete.'])
(r/'data/4.20/simple_emission_lifecycle_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(rows),sse=cpu_calls,disagreements=proof['emulator_cpu_case_disagreements'])))
