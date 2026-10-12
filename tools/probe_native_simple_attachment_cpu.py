"""Requalify actual943300/944600/944760 with hardware scalar SSE reference."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_movement.py').read_text(encoding='utf-8').split('\ncontainer=')[0]
exec(compile(setup,'Simple attachment CPU setup','exec'))
original=(r/'tools/probe_native_simple_attachment.py').read_text(encoding='utf-8')
body='instance='+original.split('instance=',1)[1].split('\nproof=',1)[0]
body=body.replace('u.emu_start(entry,end,count=100000)', 'u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.emu_start(entry,end,count=100000)')
captures=[]
for corrected in [False,True]:
 enabled=corrected;exec(compile(body,'actual attachment bodies','exec'));captures.append(cases)
rows=[dict(emulator=a,cpu=b) for a,b in zip(*captures)];assert len(rows)==112
for address in blocks:kernel.VirtualFree(address,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entries':['943300','944600','944760'],'cases':rows,'actual_cpu_sse_operations':cpu_calls,'emulator_cpu_case_disagreements':sum(c['cpu']!=c['emulator'] for c in rows),'adapters':[],'limits':['Actual emitter matrix copy/inverse and bind/local-orient bodies execute with hardware scalar SSE reference.112 selected finite authored profiles reused; unhooked packed instructions and x87 remain original VM bodies.','Upstream owner pose/bone production, exceptional matrices and ordinary rendered acceptance remain incomplete.']}
(r/'data/4.20/simple_attachment_cpu_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(rows),'sse':cpu_calls,'disagreements':proof['emulator_cpu_case_disagreements']}))
