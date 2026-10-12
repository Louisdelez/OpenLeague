from pathlib import Path
import struct
r=Path('E:/OpenLeague')
exec(compile((r/'tools/inspect_native_clear_callers.py').read_text().split('for target in ')[0],'native inspection','exec'))
for start,end in [(0x8c1ad0,0x8c1cc0),(0x10ca230,0x10ca2c0)]:
 if start>0x1000000:
  print('TABLE',hex(start),[hex(struct.unpack_from('<I',image,start-base+i*4)[0]) for i in range((end-start)//4)])
 else:
  for i in md.disasm(image[start-base:end-base],start):print(hex(i.address),i.mnemonic,i.op_str)
