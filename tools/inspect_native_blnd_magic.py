from pathlib import Path
import sys,struct,json
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs');import capstone,pefile
p=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe');pe=pefile.PE(str(p));data=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase;md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
records=[]
for needle in [b'r3d2',b'blnd']:
 for s in pe.sections:
  if not s.Characteristics&0x20000000:continue
  cur=s.VirtualAddress;hi=cur+s.Misc_VirtualSize
  while True:
   cur=data.find(needle,cur,hi)
   if cur<0:break
   pad=data.rfind(b'\xcc\xcc',max(s.VirtualAddress,cur-600),cur);start=pad+2 if pad>=0 else max(s.VirtualAddress,cur-70)
   while data[start]==0xcc:start+=1
   lines=[f'{i.address:x} {i.mnemonic} {i.op_str}' for i in md.disasm(data[start:cur+320],base+start)]
   records.append(dict(needle=needle.decode(),address=hex(base+cur),instructions=lines));print(json.dumps(dict(needle=needle.decode(),address=hex(base+cur),decode_start=hex(base+start))),flush=True);cur+=4
Path('E:/mapslol3v3/native_blnd_magic_trace.json').write_text(json.dumps(records,indent=2)+'\n',encoding='utf-8')
for i in md.disasm(data[0x897ca0-base:0x897f00-base],0x897ca0):print(f'{i.address:x} {i.mnemonic} {i.op_str}')
