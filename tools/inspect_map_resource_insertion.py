from pathlib import Path
import json,sys
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'));import pefile,capstone
d=json.loads((r/'docs/native_projection_discovery.json').read_text());raw=Path(d['source']).read_bytes();pe=pefile.PE(data=raw);md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
start=0x905090;lines=[]
for i in md.disasm(raw[pe.get_offset_from_rva(start-0x400000):][:1500],start):
 annotation=''
 if i.mnemonic in ['push','mov']:
  for op in i.op_str.split(','):
   op=op.strip()
   if op.startswith('0x'):
    va=int(op,16)
    if va>0x1000000:
     try:annotation=repr(raw[pe.get_offset_from_rva(va-0x400000):][:100].split(b'\0')[0].decode('ascii'))
     except Exception:pass
 lines.append(f'{i.address:x} {i.mnemonic} {i.op_str} {annotation}')
 if i.mnemonic=='ret':break
Path('E:/mapslol3v3/map_resource_insertion_disassembly.txt').write_text('\n'.join(lines),encoding='utf-8')
print('\n'.join(lines[:115]));print('\n'.join(line for line in lines[115:] if 'call ' in line or "'" in line))
