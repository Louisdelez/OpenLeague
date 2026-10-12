from pathlib import Path
import json,sys,struct
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'));import pefile,capstone
d=json.loads((r/'docs/native_projection_discovery.json').read_text());raw=Path(d['source']).read_bytes();pe=pefile.PE(data=raw);md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
for va in [0x10d6998,0x10d6960,0x10a2890]:print(hex(va),repr(raw[pe.get_offset_from_rva(va-0x400000):][:130].split(b'\0')[0]))
for start,size in [(0x905d52,46),(0x905dd1,25),(0x909850,145)]:
 print('FUNCTION',hex(start))
 for i in md.disasm(raw[pe.get_offset_from_rva(start-0x400000):][:size],start):print(hex(i.address),i.mnemonic,i.op_str)
