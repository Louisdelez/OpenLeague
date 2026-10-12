from pathlib import Path
import struct,re
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for section in pe.sections:
 if not section.Characteristics&0x20000000:continue
 data=section.get_data();origin=base+section.VirtualAddress
 for pos in range(len(data)-5):
  if data[pos] not in [0xe8,0xe9] or origin+pos+5+struct.unpack_from('<i',data,pos+1)[0]!=0x9c4bb0:continue
  cut=data.rfind(b'\xcc',max(0,pos-500),pos);begin=cut+1 if cut>=0 else pos-50
  print('DEVICE_DESCRIPTOR_CALLER',hex(origin+pos))
  for i in md.disasm(data[begin:pos+30],origin+begin):print(hex(i.address),i.mnemonic,i.op_str)




