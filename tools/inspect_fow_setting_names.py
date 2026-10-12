from pathlib import Path
import json,sys,struct
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'));import pefile,capstone
d=json.loads((r/'docs/native_projection_discovery.json').read_text());raw=Path(d['source']).read_bytes();pe=pefile.PE(data=raw);md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
def text_at(va):
 try:return raw[pe.get_offset_from_rva(va-0x400000):][:100].split(b'\0')[0].decode('ascii')
 except Exception:return ''
for va in [0x10a0354,0x10a290c,0x108b1a4]:print(hex(va),repr(text_at(va)))
start=0x6b3270
for i in md.disasm(raw[pe.get_offset_from_rva(start-0x400000):][:385],start):
 annotation=''
 if i.mnemonic=='push' and i.op_str.startswith('0x'):
  va=int(i.op_str,16)
  if va>0x1000000:annotation=repr(text_at(va))
 print(hex(i.address),i.mnemonic,i.op_str,annotation)
