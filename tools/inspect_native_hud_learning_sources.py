from pathlib import Path
import zipfile,struct
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
z=zipfile.ZipFile('E:/OpenLeague/data/4.20/archives/menu/HUD.zip')
for n in z.namelist():
 if 'Shurima' in n or not n.endswith('.ini'):continue
 s=z.read(n).decode('utf-8',errors='replace')
 if any(x in s for x in ['Name: EvolutionArrow0','Name: EvolutionArrowFrom','Name: EvolutionArrowFrame']):print(n,s)
print('NATIVE UI CONSTRUCTOR BUTTON REGISTRATION')
for i in md.disasm(image[0x7d3b80-base:0x7d3d40-base],0x7d3b80):print(hex(i.address),i.mnemonic,i.op_str)
