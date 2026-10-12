from pathlib import Path
import re,struct
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for target in [0x9c3e30,0x9c14a3,0x10e2f30]:
 for m in re.finditer(re.escape(struct.pack('<I',target)),image):
  loc=base+m.start();print('POINTER',hex(target),hex(loc))
  if target==0x9c3e30:
   print('TABLE',[hex(struct.unpack_from('<I',image,m.start()+i*4)[0]) for i in range(-5,8)])
for i in md.disasm(image[0x9c13c0-base:0x9c13c0-base+0x180],0x9c13c0):print(hex(i.address),i.mnemonic,i.op_str)
