from pathlib import Path
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
import zipfile,struct
z=zipfile.ZipFile('E:/OpenLeague/data/4.20/archives/menu/HUD.zip')
for n in z.namelist():
 if n.endswith('CenterHUD_AbilitiesSpell0.ini') and 'Shurima' not in n:
  print('SOURCE',n,z.read(n).decode('utf-8',errors='replace'))
for start,end in [(0x7d3800,0x7d3a00)]:
 print('RANGE',hex(start),hex(end))
 for i in md.disasm(image[start-base:end-base],start):print(hex(i.address),i.mnemonic,i.op_str)
print('CONSTANT',hex(0x1138f8c),struct.unpack_from('<f',image,0x1138f8c-base)[0])
