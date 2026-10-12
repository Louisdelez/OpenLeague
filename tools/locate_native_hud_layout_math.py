from pathlib import Path
import json,hashlib,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0],'HUD layout math prerequisites','exec'))
from capstone import CS_OP_MEM
md.detail=True;matches=[]
for start,end in [(0x9a0000,0x9a1000),(0x9a2800,0x9ac000)]:
 for i in md.disasm(image[start-base:end-base],start):
  if i.mnemonic not in ['movss','addss','subss','mulss','divss']:continue
  if not any(o.type==CS_OP_MEM and o.mem.disp in [0x1a8,0x1ac,0x1b0,0x1b4,0x1b8,0x1bc,0x1c0,0x1c4,0x1c8,0x1cc] for o in i.operands):continue
  begin=max(start,i.address-160);pad=image[begin-base:i.address-base].rfind(b'\xcc\xcc')
  if pad>=0:begin+=pad+2
  matches.append(dict(reference=hex(i.address),instruction=i.mnemonic+' '+i.op_str,candidate_start=hex(begin),instructions=[dict(address=hex(j.address),mnemonic=j.mnemonic,operands=j.op_str) for j in md.disasm(image[begin-base:min(end,i.address+160)-base],begin)]))
proof=dict(complete=False,qualified=False,native_sha256=hashlib.sha256(Path(source).read_bytes()).hexdigest(),matches=matches,limits=['Candidate arithmetic references only; instruction alignment, object ownership and execution remain to qualify.'])
(r/'data/4.20/native_hud_layout_math_candidates.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps([dict(reference=m['reference'],instruction=m['instruction']) for m in matches]))
