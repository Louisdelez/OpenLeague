from pathlib import Path
import json,sys,struct
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'));import pefile,capstone
d=json.loads((r/'docs/native_projection_discovery.json').read_text());raw=Path(d['source']).read_bytes();pe=pefile.PE(data=raw);md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
def at(a):return pe.get_offset_from_rva(a-0x400000)
for slot in [0x1c,0x28]:
 start=struct.unpack_from('<I',raw,at(0x10d6380+slot))[0];print('PROPERTY METHOD',hex(slot),hex(start))
 for i in md.disasm(raw[at(start):][:250],start):
  print(hex(i.address),i.mnemonic,i.op_str)
  if i.mnemonic=='ret':break
print('INIT MAP PROPERTY')
for i in md.disasm(raw[at(0x90a240):][:390],0x90a240):
 print(hex(i.address),i.mnemonic,i.op_str)
 if i.mnemonic=='ret':break
