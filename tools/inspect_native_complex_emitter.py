from pathlib import Path
import sys,json,hashlib,shutil
from datetime import datetime,timezone
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'));import pefile,capstone
source=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe');raw=source.read_bytes();p=pefile.PE(data=raw);img=p.get_memory_mapped_image();base=p.OPTIONAL_HEADER.ImageBase;m=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);rows=[]
for start,stop in [(0x90fa70,0x90fe00),(0x910270,0x910b40),(0x910eb0,0x911400)]:
 ins=list(m.disasm(img[start-base:stop-base],start));rows.append({'start':hex(start),'stop':hex(stop),'instructions':[{'address':hex(i.address),'mnemonic':i.mnemonic,'operands':i.op_str,'bytes':i.bytes.hex()} for i in ins]})
proof={'updated_utc':datetime.now(timezone.utc).isoformat(),'native_sha256':hashlib.sha256(raw).hexdigest(),'complete':False,'ranges':rows,'limits':['Static disassembly with entry ranges; field names and runtime semantics require original execution.']};(r/'docs/native_complex_emitter_discovery.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
for row in rows[:2]:
 print(row['start']);print('\n'.join(i['address']+' '+i['mnemonic']+' '+i['operands'] for i in row['instructions'][:115]))
