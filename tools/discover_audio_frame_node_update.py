from pathlib import Path
import sys,json,hashlib
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile
from capstone import Cs,CS_ARCH_X86,CS_MODE_32
r=Path('E:/OpenLeague');source=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe');b=source.read_bytes();digest=hashlib.sha256(b).hexdigest();assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862';pe=pefile.PE(data=b);base=pe.OPTIONAL_HEADER.ImageBase;md=Cs(CS_ARCH_X86,CS_MODE_32);regions=[]
for start in [0xb14140,0xb1bd10,0xaf5b10,0xaf5a20]:
 instructions=[]
 for i in md.disasm(pe.get_data(start-base,2048),start):
  if i.mnemonic=='int3':break
  instructions.append({'address':hex(i.address),'bytes':i.bytes.hex(),'mnemonic':i.mnemonic,'operands':i.op_str})
 assert instructions and len(instructions)<300
 end=int(instructions[-1]['address'],16)+len(bytes.fromhex(instructions[-1]['bytes']));regions.append({'start':hex(start),'end':hex(end),'sha256':hashlib.sha256(pe.get_data(start-base,end-start)).hexdigest(),'instructions':instructions,'calls':[i for i in instructions if i['mnemonic']=='call']})
proof={'complete':False,'native_sha256':digest,'regions':regions,'limits':['Native disassembly only; does not qualify timed update, transition/control or two-vector update bodies. B14140 has separate controlled native preparation; remaining called functions require owned implementation and producer integration.']}
(r/'data/4.20/audio_frame_node_update_discovery.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
for region in regions:print(region['start'],region['end'],len(region['instructions']),'instructions; calls',[(i['address'],i['operands'])for i in region['calls']])
