from pathlib import Path
import re
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for section in pe.sections:
 if not section.Characteristics&0x20000000:continue
 data=section.get_data();origin=base+section.VirtualAddress
 for m in re.finditer(b'\xe8',data):
  off=m.start()
  if off+5<=len(data) and origin+off+5+struct.unpack_from('<i',data,off+1)[0]==0x987600:
   print('CALL',hex(origin+off))
   for i in md.disasm(data[off-70:off+12],origin+off-70):print(hex(i.address),i.mnemonic,i.op_str)
print('QUALITY_REFS',[hex(base+m.start()) for m in re.finditer(re.escape(struct.pack('<I',0x1225904)),image)])
