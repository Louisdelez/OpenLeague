from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/inspect_native_clear_callers.py').read_text().split('for target in ')[0],'native inspection','exec'))
for start,end in [(0x8c2030,0x8c2290)]:
 for i in md.disasm(image[start-base:end-base],start): print(hex(i.address),i.mnemonic,i.op_str)
