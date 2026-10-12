from pathlib import Path
import re
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for m in re.finditer(rb'\xc7[\x40-\x47]\x18[\x00-\x03]\x00\x00\x00',image[0x9a6000-base:0x9aa000-base]):
 at=0x9a6000-base+m.start();pad=image.rfind(b'\xcc\xcc',max(0,at-4000),at)
 if pad<0:continue
 start=pad+2;ins=list(md.disasm(image[start:at+12],base+start))
 if not any(i.address==base+at and i.mnemonic=='mov' for i in ins):continue
 print('FIELD+18',hex(base+at),'FUNCTION',hex(base+start))
 for i in ins:
  if i.address>=base+at-80:print(hex(i.address),i.mnemonic,i.op_str)
