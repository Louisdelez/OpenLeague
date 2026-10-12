from pathlib import Path
exec(Path(__file__).with_name('inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for target in [0x123f8e4,0x14beec0,0x1139108,0x14be79f,0x123fa78]:
 print('GLOBAL',hex(target),'BYTES',image[target-base:target-base+24].hex())
 for sec in pe.sections:
  if not sec.Characteristics&0x20000000:continue
  data=sec.get_data();needle=struct.pack('<I',target);pos=0
  while True:
   off=data.find(needle,pos)
   if off<0:break
   pos=off+1;start=max(0,off-24)
   print('REF',hex(base+sec.VirtualAddress+off),data[start:off+12].hex())
