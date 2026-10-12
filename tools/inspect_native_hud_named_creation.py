from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0],'HUD named creation prerequisites','exec'))
for start,end in [(0xc9f8b6,0xc9f905),(0x8e45d0,0x8e4690),(0x5bdcb0,0x5bdd40)]:
 for i in md.disasm(image[start-base:end-base],start):print(hex(i.address),i.mnemonic,i.op_str)
