from pathlib import Path
import struct
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for field in [0x474,0x460]:
 i=image.find(struct.pack('<I',field),0x7d3300-base,0x7dc000-base)
 while i>=0:
  a=base+i;k=image.rfind(b'\xcc\xcc',i-10000,i);st=base+k+2
  print('REFERENCE',hex(field),hex(a),'START',hex(st))
  for x in md.disasm(image[st-base:i+150],st):
   if a-50<=x.address<=a+140:print(hex(x.address),x.mnemonic,x.op_str)
  i=image.find(struct.pack('<I',field),i+4,0x7dc000-base)
