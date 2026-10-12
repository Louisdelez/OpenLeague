from pathlib import Path
import struct
r=Path('E:/OpenLeague')
exec(compile((r/'tools/inspect_native_clear_callers.py').read_text().split('for target in ')[0],'native inspection','exec'))
print('GLYPH_VTABLE', [hex(struct.unpack_from('<I',image,0x10ca2c0-base+i*4)[0]) for i in range(8)])
for start,end in [(0x8c22c0,0x8c2520)]:
 for i in md.disasm(image[start-base:end-base],start): print(hex(i.address),i.mnemonic,i.op_str)
