from pathlib import Path
import re,struct
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for section in pe.sections:
 if not section.Characteristics&0x20000000:continue
 data=section.get_data();origin=base+section.VirtualAddress
 for match in re.finditer(re.escape(b'\xff\x15'+struct.pack('<I',0xfa47ec)),data):
  pos=match.start();start=max(0,pos-80)
  print('CREATE9',hex(origin+pos))
  for i in md.disasm(data[start:pos+240],origin+start): print(hex(i.address),i.mnemonic,i.op_str)
