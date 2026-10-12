from pathlib import Path
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
off=0;needle=struct.pack('<I',0x1225904)
while True:
 off=image.find(needle,off)
 if off<0:break
 print('REFERENCE',hex(off+base));start=max(0,off-65);pad=image[start:off].rfind(b'\xcc\xcc')
 if pad>=0:start+=pad+2
 for i in md.disasm(image[start:off+35],base+start):print(hex(i.address),i.mnemonic,i.op_str)
 off+=1
