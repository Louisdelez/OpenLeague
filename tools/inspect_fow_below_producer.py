from pathlib import Path
import sys,json
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
r=Path('E:/OpenLeague');source=json.loads((r/'docs/native_projection_discovery.json').read_text(encoding='utf-8-sig'));pe=pefile.PE(source['source']);im=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase;md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
rows=[{'address':hex(i.address),'instruction':i.mnemonic+' '+i.op_str} for i in md.disasm(im[0x6b3780-base:0x6b3a90-base],0x6b3780)]
(r/'docs/fow_below_producer_instructions.json').write_text(json.dumps({'complete':False,'instructions':rows},indent=2)+'\n',encoding='utf-8')
for row in rows:print(row['address'],row['instruction'])
