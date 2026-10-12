from pathlib import Path
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for i in md.disasm(image[0xc9b47b-base:0xc9b47b-base+0x90],0xc9b47b):print(hex(i.address),i.mnemonic,i.op_str)
