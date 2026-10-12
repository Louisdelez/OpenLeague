from pathlib import Path
import json,hashlib,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0],'HUD PE prerequisites','exec'))
rows=[]
for start,end in [(0x9a1e40,0x9a2750),(0x9a6800,0x9a6d00)]:
 rows.append(dict(start=hex(start),end=hex(end),instructions=[dict(address=hex(i.address),mnemonic=i.mnemonic,operands=i.op_str) for i in md.disasm(image[start-base:end-base],start)]))
proof=dict(complete=False,qualified=False,native_sha256=hashlib.sha256(Path(source).read_bytes()).hexdigest(),ranges=rows,limits=['Bounded disassembly only; function alignment and native execution remain to qualify.'])
(r/'data/4.20/native_hud_element_loader_disassembly.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
for row in rows:
 print('RANGE',row['start'],row['end'])
 for i in row['instructions']:print(i['address'],i['mnemonic'],i['operands'])
