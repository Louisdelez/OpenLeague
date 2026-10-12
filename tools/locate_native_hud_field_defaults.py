from pathlib import Path
import json,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0],'HUD field defaults prerequisites','exec'))
from capstone import CS_OP_MEM,CS_OP_IMM
md.detail=True;rows=[]
for i in md.disasm(image[0x9a0000-base:0x9ac000-base],0x9a0000):
 if i.mnemonic!='mov' or len(i.operands)!=2:continue
 first,last=i.operands
 if first.type!=CS_OP_MEM or last.type!=CS_OP_IMM or first.mem.disp not in [0x40,0x48,0x1a8,0x1ac,0x1b0,0x1b4,0x1b8,0x1bc,0x1c0,0x1c4,0x1c8,0x1cc,0x1d0,0x1d4,0x1d8]:continue
 begin=max(0x9a0000,i.address-240);pad=image[begin-base:i.address-base].rfind(b'\xcc\xcc')
 if pad>=0:begin+=pad+2
 rows.append(dict(reference=hex(i.address),instruction=i.mnemonic+' '+i.op_str,candidate_start=hex(begin),instructions=[dict(address=hex(j.address),mnemonic=j.mnemonic,operands=j.op_str) for j in md.disasm(image[begin-base:i.address+80-base],begin)]))
proof=dict(complete=False,qualified=False,matches=rows,limits=['Candidate immediate field writes only; object types, constructor alignment and execution remain to qualify.'])
(r/'data/4.20/native_hud_field_defaults_candidates.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps([dict(reference=m['reference'],instruction=m['instruction']) for m in rows]))
