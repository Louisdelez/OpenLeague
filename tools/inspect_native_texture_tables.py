from pathlib import Path
import re,struct
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for section in pe.sections:
 if not section.Characteristics&0x20000000:continue
 data=section.get_data();origin=base+section.VirtualAddress
 for m in re.finditer(re.escape(struct.pack('<I',0x10e2f30)),data):
  pos=m.start();print('VTABLE_ASSIGNMENT_REF',hex(origin+pos))
  for i in md.disasm(data[max(0,pos-12):pos+25],origin+max(0,pos-12)):print(hex(i.address),i.mnemonic,i.op_str)
print('FORMATS',[struct.unpack_from('<I',image,0x10e2b90-base+i*4)[0] for i in range(24)])
print('POOLS',[struct.unpack_from('<I',image,0x10e2c9c-base+i*4)[0] for i in range(4)])
