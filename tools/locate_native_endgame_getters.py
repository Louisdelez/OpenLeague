from pathlib import Path
import sys,struct,json,hashlib
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile
from capstone import Cs,CS_ARCH_X86,CS_MODE_32
p=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe')
raw=p.read_bytes();pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase;image=pe.get_memory_mapped_image();md=Cs(CS_ARCH_X86,CS_MODE_32);rows=[]
for name in ['GetEoGPanToHQTime','GetEoGNexusChangeSkinTime','GetEoGUseNexusDeathAnimation','Continue']:
 needle=name.encode()+b'\0';matches=[];pos=0
 while True:
  pos=image.find(needle,pos)
  if pos<0:break
  address=base+pos;refs=[];j=0
  while True:
   j=image.find(struct.pack('<I',address),j)
   if j<0:break
   executable=any(s.Characteristics&0x20000000 and s.VirtualAddress<=j<s.VirtualAddress+s.Misc_VirtualSize for s in pe.sections)
   refs.append(dict(address=hex(base+j),executable=bool(executable),surrounding_hex=image[max(0,j-16):j+32].hex(),disassembly=[dict(address=hex(i.address),instruction=i.mnemonic+' '+i.op_str) for i in md.disasm(image[max(0,j-16):j+48],base+max(0,j-16))] if executable else []));j+=4
  matches.append(dict(address=hex(address),references=refs));pos+=len(needle)
 rows.append(dict(name=name,matches=matches))
report=dict(source=str(p),sha256=hashlib.sha256(raw).hexdigest(),rows=rows,complete=False,limits=['String references locate candidate native registrations; no getter function execution or timing value qualification performed.'])
Path('E:/mapslol3v3/native_endgame_getter_locations.json').write_text(json.dumps(report,indent=2),encoding='utf-8')
print(json.dumps(rows,indent=2))
