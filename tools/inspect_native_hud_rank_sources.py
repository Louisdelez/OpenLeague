from pathlib import Path
import zipfile,struct
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
z=zipfile.ZipFile('E:/OpenLeague/data/4.20/archives/menu/HUD.zip')
for n in z.namelist():
 if not n.endswith('.ini') or 'Shurima' in n:continue
 s=z.read(n).decode('utf-8',errors='replace')
 for text in ['PipBarDummyReference','PipDividerDummyReference']:
  if 'Name: '+text in s:
   i=s.find('Name: '+text); print(n,s[i-15:i+470])
print('DIVIDER LAYOUT')
for i in md.disasm(image[0x7d69cc-base:0x7d6b90-base],0x7d69cc):print(hex(i.address),i.mnemonic,i.op_str)
print('DEFAULT RANKS',struct.unpack_from('<4I',image,0x10b29e8-base))
