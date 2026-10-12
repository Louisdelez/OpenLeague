from pathlib import Path
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for target,end in [(0x836cef,0x836d80),(0x837630,0x837380)]:
 off=target-base;start=image.rfind(b'\xcc\xcc',off-0x1200,off)+2
 print('FUNCTION',hex(base+start))
 for i in md.disasm(image[start:end-base],base+start):print(hex(i.address),i.mnemonic,i.op_str)
for loc in [0x1088748,0x1085b20]:print('STRING',hex(loc),image[loc-base:].split(b'\0')[0].decode(errors='replace'))
