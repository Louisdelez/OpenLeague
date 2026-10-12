from pathlib import Path
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for a in [0x10c9ba8,0x10c9be8,0x10c9d0c]:print('CONSTANT',hex(a),image[a-base:].split(b'\0',1)[0])
for begin,size in [(0x8b3840,0x130),(0x8b35a0,0x250)]:
 print('FUNCTION',hex(begin))
 for i in md.disasm(image[begin-base:begin-base+size],begin):print(hex(i.address),i.mnemonic,i.op_str)
