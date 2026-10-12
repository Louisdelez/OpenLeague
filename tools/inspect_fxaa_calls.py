from pathlib import Path
import struct
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for start,size in [(0x8373d0,50),(0x981480,210),(0x835e65,32)]:
 print('BLOCK',hex(start))
 for i in md.disasm(image[start-base:start-base+size],start): print(hex(i.address),i.mnemonic,i.op_str)
for section in pe.sections:
 if not section.Characteristics&0x20000000:continue
 data=section.get_data();origin=base+section.VirtualAddress
 for pos in range(len(data)-5):
  if data[pos]!=0xe8:continue
  target=origin+pos+5+struct.unpack_from('<i',data,pos+1)[0]
  if target!=0x835080:continue
  prior=data[max(0,pos-30):pos]
  if b'\x6a\x17' not in prior:continue
  print('GETTER23_CANDIDATE',hex(origin+pos))
  for i in md.disasm(data[max(0,pos-20):pos+65],origin+max(0,pos-20)): print(hex(i.address),i.mnemonic,i.op_str)
