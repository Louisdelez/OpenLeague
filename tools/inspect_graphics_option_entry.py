from pathlib import Path
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for begin,size in [(0x8373d0,0x80),(0x8b1c20,0x90),(0x836f70,0x85)]:
 print('FUNCTION',hex(begin))
 for i in md.disasm(image[begin-base:begin-base+size],begin):print(hex(i.address),i.mnemonic,i.op_str)
for key in [15,16,19,20]:
 target=struct.unpack_from('<I',image,0x836ea0-base+(key-1)*4)[0]
 print('NAME_BRANCH',key,hex(target))
