from pathlib import Path
import sys,json,hashlib
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile
from capstone import Cs,CS_ARCH_X86,CS_MODE_32
r=Path('E:/OpenLeague');source=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe');b=source.read_bytes();p=pefile.PE(data=b);base=p.OPTIONAL_HEADER.ImageBase;md=Cs(CS_ARCH_X86,CS_MODE_32);rows=[]
assert hashlib.sha256(b).hexdigest()=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
for section in p.sections:
 if not section.Characteristics&0x20000000:continue
 data=section.get_data();start=base+section.VirtualAddress
 for address in [0x14a7a5c,0x14a7a60,0x14a7a64]:
  needle=address.to_bytes(4,'little');offset=0
  while True:
   offset=data.find(needle,offset)
   if offset<0:break
   begin=max(0,offset-128);near=data[begin:offset];prologue=near.rfind(bytes.fromhex('558bec'))
   if prologue>=0:begin+=prologue
   end=min(len(data),offset+180);raw=data[begin:end]
   rows.append({'global':hex(address),'operand_address':hex(start+offset),'window_start':hex(start+begin),'sha256':hashlib.sha256(raw).hexdigest(),'instructions':[{'address':hex(i.address),'mnemonic':i.mnemonic,'operands':i.op_str}for i in md.disasm(raw,start+begin)]});offset+=4
receipt={'complete':False,'native_sha256':hashlib.sha256(b).hexdigest(),'references':rows,'limits':['Exploratory byte references with nearby disassembly only; function boundaries and normal frame invocation need verification.']}
(r/'data/4.20/audio_callback_dispatch_discovery.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8');print('Callback globals:',len(rows),'executable references')
