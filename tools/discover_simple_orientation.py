from pathlib import Path
import sys,json
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
r=Path('E:/OpenLeague');source=Path(json.loads((r/'docs/native_projection_discovery.json').read_text())['source'])
p=pefile.PE(str(source));img=p.get_memory_mapped_image();base=p.OPTIONAL_HEADER.ImageBase
m=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);m.skipdata=True
for i in m.disasm(img[0x91c0c0-base:0x94b000-base],0x91c0c0):
 if any(x in i.op_str for x in ['+ 0x160]','+ 0x161]']):print(hex(i.address),i.mnemonic,i.op_str)
for address in [0x10d7474,0x10d83e0,0x10d7a64]:print(hex(address),img[address-base:].split(b'\0',1)[0].decode())
for start,end in [(0x91eb67,0x91ebd5)]:
 print('RANGE',hex(start))
 for i in m.disasm(img[start-base:end-base],start):print(hex(i.address),i.mnemonic,i.op_str)
