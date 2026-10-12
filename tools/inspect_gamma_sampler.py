from pathlib import Path
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for off in [0x70,0x90,0x98]:
 a=struct.unpack_from('<I',image,0x10e2f30+off-base)[0]
 print('VTABLE',hex(off),hex(a))
 for i in md.disasm(image[a-base:a-base+180],a):
  print(hex(i.address),i.mnemonic,i.op_str)
  if i.mnemonic=='ret':break
print('INITIAL_GAMMA_ENABLED',image[0x1224dd9-base])
for addr,n in [(0x10e2b6c,8),(0x10e2bfc,5),(0x10e2c9c,5)]:print('TABLE',hex(addr),list(struct.unpack_from('<'+'I'*n,image,addr-base)))
for i in md.disasm(image[0x9c5260-base:0x9c52d0-base],0x9c5260):
 print(hex(i.address),i.mnemonic,i.op_str)
 if i.mnemonic=='ret':break
for target in [0x1224dd9]:
 needle=struct.pack('<I',target);off=0
 while True:
  off=image.find(needle,off)
  if off<0:break
  print('REFERENCE',hex(off+base))
  start=max(0,off-70)
  pad=image[start:off].rfind(b'\xcc\xcc')
  if pad>=0:start+=pad+2
  for i in md.disasm(image[start:off+28],base+start):print(hex(i.address),i.mnemonic,i.op_str)
  off+=1
