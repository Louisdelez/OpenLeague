from pathlib import Path
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for start,size in [(0x9882a0,0x390)]:
 for i in md.disasm(image[start-base:start-base+size],start): print(hex(i.address),i.mnemonic,i.op_str)
