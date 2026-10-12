from pathlib import Path
import json,sys
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'));import pefile,capstone
d=json.loads((r/'docs/native_projection_discovery.json').read_text());raw=Path(d['source']).read_bytes();pe=pefile.PE(data=raw);md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
for start,size in [(0x90d1d0,190),(0x905de7,22),(0x905620,180)]:
 print('FUNCTION',hex(start))
 for i in md.disasm(raw[pe.get_offset_from_rva(start-0x400000):][:size],start):print(hex(i.address),i.mnemonic,i.op_str)
