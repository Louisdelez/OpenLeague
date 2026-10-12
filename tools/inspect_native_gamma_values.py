from pathlib import Path
exec(Path(__file__).with_name('inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for start,end in [(0x7410e0,0x741260),(0x741640,0x741750),(0x58e070,0x58e0e0)]:
 print('RANGE',hex(start))
 for i in md.disasm(image[start-base:end-base],start):print(hex(i.address),i.mnemonic,i.op_str)
