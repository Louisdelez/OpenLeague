from pathlib import Path
import json,sys,hashlib
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'));import pefile,capstone
d=json.loads((r/'docs/native_projection_discovery.json').read_text());raw=Path(d['source']).read_bytes();assert hashlib.sha256(raw).hexdigest()==d['sha256']
pe=pefile.PE(data=raw);md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
def at(a):return pe.get_offset_from_rva(a-0x400000)
for start,size in [(0x9063e0,0x340),(0x906620,0x100)]:
 print('FUNCTION',hex(start))
 for i in md.disasm(raw[at(start):at(start)+size],start):
  annotation=''
  for part in i.op_str.split(','):
   if part.strip().startswith('0x'):
    va=int(part.strip(),16)
    if va>0x1000000:
     try:annotation=repr(raw[at(va):][:120].split(b'\0')[0].decode('ascii'))
     except Exception:pass
  print(hex(i.address),i.mnemonic,i.op_str,annotation)

