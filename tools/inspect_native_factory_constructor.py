from pathlib import Path
import re,struct
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for target in [0x10e2e2c]:
 for m in re.finditer(re.escape(struct.pack('<I',target)),image):print('FACTORY_TABLE_REF',hex(base+m.start()))
for start,size in [(0x9c3d80,0xb0)]:
 for i in md.disasm(image[start-base:start-base+size],start):print(hex(i.address),i.mnemonic,i.op_str)
