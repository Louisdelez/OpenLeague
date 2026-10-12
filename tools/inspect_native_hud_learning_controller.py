from pathlib import Path
import struct
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for term in [b'EvolutionArrow%u',b'EvolutionArrowFrame%u']:
 off=image.find(term);address=base+off;print(term,hex(address));i=image.find(struct.pack('<I',address),0x7d3300-base,0x7dc000-base)
 while i>=0:
  a=base+i;k=image.rfind(b'\xcc\xcc',i-10000,i);start=base+k+2;print('REF',hex(a),'FUNC',hex(start))
  for x in md.disasm(image[start-base:i+100],start):
   if a-20<=x.address<a+95:print(hex(x.address),x.mnemonic,x.op_str)
  i=image.find(struct.pack('<I',address),i+4,0x7dc000-base)
print('UPDATE PREFIX')
for x in md.disasm(image[0x7d7a30-base:0x7d7b6f-base],0x7d7a30):print(hex(x.address),x.mnemonic,x.op_str)
