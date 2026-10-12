from pathlib import Path
import json,sys
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'));import pefile,capstone
d=json.loads((r/'docs/native_projection_discovery.json').read_text());raw=Path(d['source']).read_bytes();pe=pefile.PE(data=raw);md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
va=0x10c3f64;print('WILDCARD',repr(raw[pe.get_offset_from_rva(va-0x400000):][:50].split(b'\0')[0]))
start=0x905620;ins=list(md.disasm(raw[pe.get_offset_from_rva(start-0x400000):][:1200],start));lines=[]
for i in ins:
 annotation=''
 if i.mnemonic=='push' and i.op_str.startswith('0x'):
  va=int(i.op_str,16)
  if va>0x1000000:
   try:annotation=repr(raw[pe.get_offset_from_rva(va-0x400000):][:70].split(b'\0')[0].decode('ascii'))
   except Exception:pass
 lines.append(f'{i.address:x} {i.mnemonic} {i.op_str} {annotation}')
 if i.mnemonic=='ret':break
Path('E:/mapslol3v3/map_enumeration_disassembly.txt').write_text('\n'.join(lines),encoding='utf-8')
print('\n'.join(line for line in lines if 'call ' in line or "'" in line or '9057'==line[:5]))
