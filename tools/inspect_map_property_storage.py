from pathlib import Path
import json,sys
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'));import pefile,capstone
d=json.loads((r/'docs/native_projection_discovery.json').read_text());raw=Path(d['source']).read_bytes();pe=pefile.PE(data=raw);md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
for start,size in [(0x90a330,270),(0x905ca0,225),(0x905d80,250)]:
 print('FUNCTION',hex(start))
 for i in md.disasm(raw[pe.get_offset_from_rva(start-0x400000):][:size],start):
  annotation=''
  if i.mnemonic=='push' and i.op_str.startswith('0x'):
   va=int(i.op_str,16)
   if va>0x1000000:
    try:annotation=repr(raw[pe.get_offset_from_rva(va-0x400000):][:100].split(b'\0')[0].decode('ascii'))
    except Exception:pass
  print(hex(i.address),i.mnemonic,i.op_str,annotation)
  if i.mnemonic=='ret':break
