from pathlib import Path
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for begin,size in [(0x8b3490,0x110),(0x8b3140,0x350),(0x8b30d0,0x70),(0x8b2ed0,0x100)]:
 print('FUNCTION',hex(begin))
 for i in md.disasm(image[begin-base:begin-base+size],begin):print(hex(i.address),i.mnemonic,i.op_str)
