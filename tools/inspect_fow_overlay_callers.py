from pathlib import Path
import json,sys,struct
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'));import pefile,capstone
d=json.loads((r/'docs/native_projection_discovery.json').read_text());raw=Path(d['source']).read_bytes();pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase;md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
for sec in pe.sections:
 if not sec.Characteristics&0x20000000:continue
 b=sec.get_data();va=base+sec.VirtualAddress
 for i in range(len(b)-5):
  if b[i]==0xe8 and va+i+5+struct.unpack_from('<i',b,i+1)[0]==0x6b3020:
   print('CALLSITE',hex(va+i));start=max(0,i-45)
   for ins in md.disasm(b[start:i+12],va+start):print(hex(ins.address),ins.mnemonic,ins.op_str)
