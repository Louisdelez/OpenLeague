from pathlib import Path
import sys,json,struct
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile
from capstone import Cs,CS_ARCH_X86,CS_MODE_32
pe=pefile.PE('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe');base=pe.OPTIONAL_HEADER.ImageBase;image=pe.get_memory_mapped_image();md=Cs(CS_ARCH_X86,CS_MODE_32);rows=[]
for global_address in [0x123ebf8,0x123ec08,0x123ebe8]:
 refs=[];pos=0
 while True:
  pos=image.find(struct.pack('<I',global_address),pos)
  if pos<0:break
  if any(s.Characteristics&0x20000000 and s.VirtualAddress<=pos<s.VirtualAddress+s.Misc_VirtualSize for s in pe.sections):
   refs.append(dict(address=hex(base+pos),hex=image[max(0,pos-32):pos+48].hex(),disassembly=[dict(address=hex(i.address),instruction=i.mnemonic+' '+i.op_str) for i in md.disasm(image[max(0,pos-32):pos+60],base+max(0,pos-32))]))
  pos+=4
 rows.append(dict(global_address=hex(global_address),initial_raw_hex=image[global_address-base:global_address-base+4].hex(),references=refs))
Path('E:/mapslol3v3/native_endgame_timing_initializers.json').write_text(json.dumps(rows,indent=2),encoding='utf-8');print(json.dumps(rows,indent=2))
