from pathlib import Path
import re,struct
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for token in [b'EnableFXAA',b'FXAA',b'MultiSample']:
 for match in re.finditer(re.escape(token),image):
  loc=base+match.start(); print('STRING',hex(loc),image[match.start():match.start()+80].split(b'\0')[0])
  for section in pe.sections:
   if not section.Characteristics&0x20000000:continue
   data=section.get_data(); origin=base+section.VirtualAddress
   for m in re.finditer(re.escape(struct.pack('<I',loc)),data):
    print('REF',hex(origin+m.start()))
    for i in md.disasm(data[max(0,m.start()-18):m.start()+65],origin+max(0,m.start()-18)):print(hex(i.address),i.mnemonic,i.op_str)
key=23; index=image[0x837880-base+key-1]; target=struct.unpack_from('<I',image,0x837840-base+index*4)[0]
print('DISPATCH23',hex(target))
for start,size in [(target,180)]:
 for i in md.disasm(image[start-base:start-base+size],start):print(hex(i.address),i.mnemonic,i.op_str)
