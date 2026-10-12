from pathlib import Path
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for begin,size in [(0xc9b7d4,0xb5),(0xc9b9e4,0x16),(0xc97ea8,0x70)]:
 print('FUNCTION',hex(begin))
 for i in md.disasm(image[begin-base:begin-base+size],begin):print(hex(i.address),i.mnemonic,i.op_str)
for ptr in [0x12232f8,0x14ae870]:print('WORDS',hex(ptr),[hex(struct.unpack_from('<I',image,ptr-base+4*i)[0]) for i in range(4)])
