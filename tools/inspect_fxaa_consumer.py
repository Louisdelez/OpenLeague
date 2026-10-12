from pathlib import Path
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for start,size in [(0x73e170,54),(0x73d610,280)]:
 print('BLOCK',hex(start),image[start-base:start-base+20].hex())
 for i in md.disasm(image[start-base:start-base+size],start):print(hex(i.address),i.mnemonic,i.op_str)
print('section',image[0x1088748-base:0x1088748-base+40].split(b'\0')[0])
