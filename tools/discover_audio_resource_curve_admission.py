from pathlib import Path
import json,hashlib
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
from capstone import Cs,CS_ARCH_X86,CS_MODE_32
c=Cs(CS_ARCH_X86,CS_MODE_32)
sections=[]
for lo,hi in[(0xb10450,0xb10780),(0xae4550,0xae46c0),(0xb11f20,0xb12020)]:
 instructions=[{'address':i.address,'mnemonic':i.mnemonic,'operands':i.op_str}for i in c.disasm(bytes(u.mem_read(lo,hi-lo)),lo)]
 sections.append({'start':lo,'end_exclusive':hi,'instructions':instructions})
 for i in instructions:
  if i['mnemonic']=='call':print(hex(i['address']),i['operands'])
p={'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'sections':sections,'observations':['B10450 manager curve list uses938head/93Ctail/940free/948capacity/94Ccount; required manager extent at least950, larger than current zero-curve resource fixture920.','52byte curve nodes and embedded AE4550 curve storage; existing key replaces scalar and frees previous points before constructor. New-node failure invokes B11F20 removal. Additional delayed dependency list starts91C/920tail/924free/92Ccapacity/930count, requiring B131D0 and callback processing. Full replay still pending.'],'limits':['Static disassembly only; no behavior qualification or original curve registration replay in this discovery.']}
(r/'docs/audio_resource_curve_admission_discovery.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8')
(r/'tools/discover_audio_resource_curve_admission.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8')
print('Saved original curve registration/point construction/removal disassembly.')
