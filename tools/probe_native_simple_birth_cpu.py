"""Requalify whole941F00 emission and insertion against CPU scalar arithmetic."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_movement.py').read_text(encoding='utf-8').split('\ncontainer=')[0]
exec(compile(setup,'Simple birth CPU setup','exec'))
original=(r/'tools/probe_native_simple_birth.py').read_text(encoding='utf-8')
body='instance='+original.split('instance=',1)[1].split('\nproof=',1)[0]
body=body.replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','birth_observer=u.hook_add(unicorn.UC_HOOK_CODE,hook)')
body=body.replace('u.emu_start(0x941f00,end,count=100000)', 'u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.emu_start(0x941f00,end,count=100000)')
body=body.replace('first_calls=calls','stored["arrays"]={hex(off):[read32(read32(container+off)+j*4) for j in range((read32(container+off+4)-read32(container+off))//4)] for off in range(8,0x99,12)}\n stored["rng"]=[read32(0x2d6ec08+j*4) for j in range(55)]\n stored["first"]=read32(0x2d6ece4);stored["second"]=read32(0x2d6ece8)\n stored["active"]=read32(container+0xa4);stored["counter"]=read32(metadata+0x28)\n first_calls=calls')
body=body.replace("assert len(calls)==count and u.mem_read(instance+0xd4,1)==b'\\1'", "assert len(calls)==count and u.mem_read(instance+0xd4,1)==b'\\1', (corrected,len(calls),count,read32(instance+0xd4),hex(u.reg_read(UC_X86_REG_EIP)))")
captures=[]
for corrected in [False,True]:
 enabled=corrected;exec(compile(body,'actual emission birth body','exec'));captures.append(cases);u.hook_del(birth_observer)
rows=[dict(emulator=a,cpu=b) for a,b in zip(*captures)];assert len(rows)==48
for address in blocks:kernel.VirtualFree(address,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='941F00',cases=rows,actual_cpu_sse_operations=cpu_calls,emulator_cpu_case_disagreements=sum(c['cpu']!=c['emulator'] for c in rows),adapters=[],limits=['Whole941F00 emission and native insertion execute with supplied preallocated storage and constant tables. All13 arrays, RNG55 words/cursors, active count and source counter captured.','Selected burst profiles only; allocation, dynamic probability curves, nonconstant vector resources, normal cyclic emission, full frame and ordinary renderer remain incomplete.'])
(r/'data/4.20/simple_birth_cpu_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(rows),sse=cpu_calls,disagreements=proof['emulator_cpu_case_disagreements'])))
