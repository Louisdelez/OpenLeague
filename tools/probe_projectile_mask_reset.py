from pathlib import Path
import json,hashlib
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projectile_team_visibility.py').read_text().split('\nrows=[]')[0],'setup','exec'))
rows=[]
for initial in [0,1,2,3,0x80000000,0xffffffff]:
 u.mem_write(wrapper,b'\0'*0x200);w(wrapper,0x10a4960);w(wrapper+0x15c,initial)
 result=run(0x6c9210,wrapper,[]);after=read(wrapper+0x15c);assert result==1 and after==0xffffffff
 rows.append(dict(initial_mask=initial,final_mask=after,return_value=result))
proof=dict(complete=False,passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['Wrapper table10A4960 slot44 points to6C9210.','6C9210 writes maskFFFFFFFF at6C9330 then invokes wrapper34 (bounds update).','Function resets mask for all six input masks with no acquired Troy resource.'],adapters=['Resource weak handle absent. Inherited6C9490 bounds-update hook omitted. Native method otherwise executes.'],limits=['Not proof of constructor or initial load default; prior attribution corrected.','Caller of slot44 and live-resource branch still unqualified.'])
(r/'data/4.20/projectile_mask_reset_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS6 native mask reset cases')
for name in ['coverage','resume_checkpoint','completion_plan','goal_plan_revision']:
 p=r/f'docs/{name}.json';d=json.loads(p.read_text(encoding='utf-8'));d['next_action']='Correction:6C9330 belongs to wrapper virtual44 method6C9210, not constructor/load. Original method passes6 mask reset cases with absent Troy weak resource, setsFFFFFFFF then calls bounds34 (hooked). Contract projectile_mask_reset_contract.json. Default-mask fixture failure remains valid. Next trace wrapper44 callers and actual constructor718A70 before claiming initial mask. Full plan intact, no active process.';p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
