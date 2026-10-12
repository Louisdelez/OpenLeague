from pathlib import Path
import sys,json,collections,re,hashlib
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile
from capstone import Cs,CS_ARCH_X86,CS_MODE_32
p=Path(json.loads(Path('E:/OpenLeague/data/4.20/native_endgame_default_timing.json').read_text())['source']);raw=p.read_bytes();pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase;image=pe.get_memory_mapped_image();md=Cs(CS_ARCH_X86,CS_MODE_32);md.skipdata=True
matches=[]
for section in pe.sections:
 if not section.Characteristics&0x20000000:continue
 instructions=list(md.disasm_lite(section.get_data(),base+section.VirtualAddress))
 for i,(address,size,mnemonic,operand) in enumerate(instructions):
  if mnemonic not in ['push','mov','cmp']:continue
  if re.search(r'(?:^|, )0x(?:cb|5f)$',operand):
   matches.append(dict(address=hex(address),instruction=mnemonic+' '+operand,context=[dict(address=hex(a),instruction=m+' '+o) for a,z,m,o in instructions[max(0,i-9):i+15]]))
d=dict(source=str(p),sha256=hashlib.sha256(raw).hexdigest(),matches=matches,complete=False,limits=['Candidate immediate constants only. No packet handler identified or executed by this scan.'])
Path('E:/mapslol3v3/native_endgame_packet_id_candidates.json').write_text(json.dumps(d,indent=2),encoding='utf-8')
print(json.dumps([dict(address=x['address'],instruction=x['instruction']) for x in matches],indent=2))
