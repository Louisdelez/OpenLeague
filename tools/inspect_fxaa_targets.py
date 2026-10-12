from pathlib import Path
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for start,size in [(0x73d610,0x600),(0x985e50,0x250)]:
 print('BLOCK',hex(start))
 for i in md.disasm(image[start-base:start-base+size],start):print(hex(i.address),i.mnemonic,i.op_str)
