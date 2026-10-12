from pathlib import Path
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for begin,end in [(0x8b4ef0,0x8b5030),(0x8b5170,0x8b51b8)]:
 print('FUNCTION',hex(begin))
 for i in md.disasm(image[begin-base:end-base],begin):print(hex(i.address),i.mnemonic,i.op_str)
