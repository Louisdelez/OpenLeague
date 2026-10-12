"""Actual941F00 emission gates/count with hardware scalar SSE reference."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_movement.py').read_text(encoding='utf-8').split('\ncontainer=')[0]
exec(compile(setup,'Simple emission CPU setup','exec'))
original=(r/'tools/probe_native_simple_emission.py').read_text(encoding='utf-8')
body='instance='+original.split('instance=',1)[1].split('\nproof=',1)[0]
body=body.replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','emission_observer=u.hook_add(unicorn.UC_HOOK_CODE,hook)')
body=body.replace('u.emu_start(0x941f00,end,count=100000)', 'u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.emu_start(0x941f00,end,count=100000)')
captures=[]
for corrected in [False,True]:
 enabled=corrected;exec(compile(body,'actual emission count body','exec'))
 for single,latch,rate,age,previous in itertools.product([0,1],[0,1],[.5,3.,100.,10000000.],[.25,.75],[10.,10.5]):run(single,latch,rate,age,previous=previous)
 captures.append(cases);u.hook_del(emission_observer)
rows=[dict(emulator=a,cpu=b) for a,b in zip(*captures)];assert len(rows)==160
for a in blocks:kernel.VirtualFree(a,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='941F00..9420B9',cases=rows,actual_cpu_sse_operations=cpu_calls,emulator_cpu_case_disagreements=sum(c['cpu']!=c['emulator'] for c in rows),adapters=[],limits=['Original gates/count prefix, original x87 fmod and scalar lookup execute; supplied finite fields and constant effective rate table, multiplier1. Stops before birth or exit epilogue.','Selected negative elapsed-since-previous and high rate included; unsigned raw count retained. Count alone does not prove normal emission or allocation.'])
(r/'data/4.20/simple_emission_cpu_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(rows),sse=cpu_calls,disagreements=proof['emulator_cpu_case_disagreements'])))
