from pathlib import Path
import struct
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for term in [b'Cooldown\0',b'CooldownLine\0',b'SpellCooldownFX%u\0']:
 off=image.find(term)
 if off<0:print('STRING ABSENT',term);continue
 a=base+off;print('STRING',term,hex(a));needle=struct.pack('<I',a);refs=[];i=image.find(needle)
 while i>=0:
  if 0x700000<=base+i<0xa00000:refs.append(base+i)
  i=image.find(needle,i+4)
 for ref in refs[:12]:
  pad=image.rfind(b'\xcc\xcc',max(0,ref-base-500),ref-base)
  start=base+pad+2 if pad>=0 else 0x7d33a0 if 0x7d33a0<=ref<0x7d4000 else None
  if start is None:continue
  print('REF',hex(ref),'START',hex(start))
  for ins in md.disasm(image[start-base:ref-base+85],start):
   if ref-25<=ins.address<ref+85:print(hex(ins.address),ins.mnemonic,ins.op_str)
