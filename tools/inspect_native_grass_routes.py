from pathlib import Path
import sys,struct,re,json
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
p=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe');pe=pefile.PE(str(p));data=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase;md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
catalog=json.loads(Path('E:/OpenLeague/data/4.20/native_shader_descriptor_catalog.json').read_text(encoding='utf-8'))
text=next(s for s in pe.sections if s.Name.startswith(b'.text'));low=text.VirtualAddress;high=low+text.Misc_VirtualSize
for descriptor in catalog['descriptors']:
 if 'WALL_OF_GRASS' not in descriptor['name']:continue
 name=descriptor['name'];at=data.find(name.encode()+b'\0');print('NAME',name,'ADDRESS',hex(base+at),'descriptor',descriptor['native_descriptor'])
 for value in [base+at,int(descriptor['native_descriptor'],16)]:
  for m in re.finditer(re.escape(struct.pack('<I',value)),data[low:high]):
   offset=low+m.start();print('XREF',hex(base+offset))
   for i in md.disasm(data[offset-30:offset+95],base+offset-30):print(hex(i.address),i.mnemonic,i.op_str)
