from pathlib import Path
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for start,size in [(0x9c4b40,0x96),(0x9ac090,0x190),(0x9ac600,0xd0)]:
 print('BLOCK',hex(start))
 for i in md.disasm(image[start-base:start-base+size],start):print(hex(i.address),i.mnemonic,i.op_str)
