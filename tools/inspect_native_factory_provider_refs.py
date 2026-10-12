from pathlib import Path
import re,struct
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for target in [0x9c4bb0]:
 for m in re.finditer(re.escape(struct.pack('<I',target)),image):
  pos=m.start();loc=base+pos;print('PROVIDER_REF',hex(loc))
  if loc<0xfa0000:
   for i in md.disasm(image[pos-30:pos+40],loc-30):print(hex(i.address),i.mnemonic,i.op_str)
  else:print(image[pos-24:pos+24].hex())
