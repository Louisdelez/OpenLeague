from pathlib import Path
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for begin,size in [(0x8af910,0x70),(0xc998cc,0x70),(0x8ae340,0xc0)]:
 print('FUNCTION',hex(begin))
 for i in md.disasm(image[begin-base:begin-base+size],begin):print(hex(i.address),i.mnemonic,i.op_str)
print('ZERO_SUFFIX',image[0x108643c-base:].split(b'\0')[0])
