from pathlib import Path
import re
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for begin,size in [(0x835080,0x110),(0x837470,0x310)]:
 print('FUNCTION',hex(begin))
 for i in md.disasm(image[begin-base:begin-base+size],begin):print(hex(i.address),i.mnemonic,i.op_str)
for token in [b'EnvironmentQuality',b'CharacterQuality',b'EffectsQuality',b'ShadowQuality']:
 locations=[base+m.start() for m in re.finditer(re.escape(token+b'\0'),image)]
 print('TOKEN',token.decode(),[hex(x) for x in locations])
 for loc in locations:
  for section in pe.sections:
   if not section.Characteristics&0x20000000:continue
   data=section.get_data();origin=base+section.VirtualAddress
   for m in re.finditer(re.escape(struct.pack('<I',loc)),data):
    off=m.start();start=max(0,off-25)
    print('REF',hex(origin+off))
    for i in md.disasm(data[start:off+50],origin+start):print(hex(i.address),i.mnemonic,i.op_str)
