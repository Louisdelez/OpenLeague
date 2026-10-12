from pathlib import Path
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for begin,size in [(0x993780,0x60),(0x8ad4a4,0x50)]:
 print('FUNCTION',hex(begin))
 for i in md.disasm(image[begin-base:begin-base+size],begin):print(hex(i.address),i.mnemonic,i.op_str)
