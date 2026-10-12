from pathlib import Path
import json,hashlib
import sys
sys.path.insert(0,"E:/OpenLeague/tools/pythonlibs")
import pefile
from capstone import Cs,CS_ARCH_X86,CS_MODE_32
r=Path('E:/OpenLeague')
source=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe')
b=source.read_bytes();digest=hashlib.sha256(b).hexdigest()
assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
p=pefile.PE(data=b);base=p.OPTIONAL_HEADER.ImageBase;md=Cs(CS_ARCH_X86,CS_MODE_32)
regions=[]
for start,end in [(0xb124e0,0xb12e20),(0xb13540,0xb13900)]:
 raw=p.get_data(start-base,end-start)
 instructions=[{'address':hex(i.address),'bytes':i.bytes.hex(),'mnemonic':i.mnemonic,'operands':i.op_str}for i in md.disasm(raw,start)]
 regions.append({'start':hex(start),'end':hex(end),'sha256':hashlib.sha256(raw).hexdigest(),'instructions':instructions,'calls':[i for i in instructions if i['mnemonic']=='call']})
receipt={'complete':False,'native_sha256':digest,'source':str(source),'regions':regions,'limits':['Disassembly spans are exploratory windows, not verified complete function boundaries. Does not qualify a Rust registration producer or notification implementation. Native 12-case subscription contract remains the behavioral reference.']}
(r/'data/4.20/audio_rtpc_registration_discovery.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print('Native RTPC registration/notification disassembly retained',sum(len(q['instructions'])for q in regions),'instructions')
