from pathlib import Path
import re
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for m in re.finditer(rb'\xff[\x90\x91\x92\x93\x96\x97]\x48\x01\x00\x00',image):
 at=m.start();pad=image.rfind(b'\xcc\xcc',max(0,at-1500),at)
 if pad<0:continue
 start=pad+2;instructions=list(md.disasm(image[start:at+24],base+start))
 if not any(i.address==base+at and i.mnemonic=='call' for i in instructions):continue
 print('DRAW REF',hex(base+at),'START',hex(base+start))
 if 0x980000<=base+at<0x9e0000:
  for i in instructions:print(hex(i.address),i.mnemonic,i.op_str)
