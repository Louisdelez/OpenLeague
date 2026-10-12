from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/discover_audio_emitter_clock_writes.py').read_text().split('start=0x93e000')[0],'setup','exec'))
import struct
hits=[]
for section in pe.sections:
 if not section.Characteristics&0x20000000:continue
 data=section.get_data();va=base+section.VirtualAddress
 for j in range(len(data)-5):
  if data[j]==0xe8 and va+j+5+struct.unpack_from('<i',data,j+1)[0]==0x93f2f0:
   hits.append(va+j)
print([hex(h) for h in hits])
for h in hits:
 off=pe.get_offset_from_rva(h-base)
 print('\n',hex(h))
 for i in md.disasm(raw[off-60:off+8],h-60):print(hex(i.address),i.mnemonic,i.op_str)
