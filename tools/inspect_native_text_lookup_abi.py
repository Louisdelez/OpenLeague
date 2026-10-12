from pathlib import Path
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for i in md.disasm(image[0x8ae0e0-base:0x8ae340-base],0x8ae0e0):
 if i.address<0x8ae135 or i.mnemonic=='ret':print(hex(i.address),i.mnemonic,i.op_str)
