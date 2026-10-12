from pathlib import Path
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for a,b in [(0x99e8d0,0x99ea60),(0x9a0540,0x9a0685)]:
 print('RANGE',hex(a),hex(b))
 for i in md.disasm(image[a-base:b-base],a):print(hex(i.address),i.mnemonic,i.op_str)
