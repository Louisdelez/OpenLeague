from pathlib import Path
import sys,json
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
r=Path('E:/OpenLeague');source=Path(json.loads((r/'docs/native_projection_discovery.json').read_text())['source']);p=pefile.PE(str(source));img=p.get_memory_mapped_image();base=p.OPTIONAL_HEADER.ImageBase;m=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
for start,end in [(0x887110,0x8871f0),(0x755ba0,0x755c42)]:
 print('RANGE',hex(start))
 for i in m.disasm(img[start-base:end-base],start):print(hex(i.address),i.mnemonic,i.op_str)
