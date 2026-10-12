from pathlib import Path
import sys,struct,json,hashlib
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile
r=Path('E:/OpenLeague');source=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe');raw=source.read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862';p=pefile.PE(data=raw);base=p.OPTIONAL_HEADER.ImageBase;targets={0xb1b220,0xb1b3c0,0xb1b430,0xb14310};candidates=[]
for section in p.sections:
 if not section.Characteristics&0x20000000:continue
 data=section.get_data();offset=0
 while True:
  offset=data.find(b'\xe8',offset)
  if offset<0 or offset+5>len(data):break
  address=base+section.VirtualAddress+offset;target=(address+5+struct.unpack_from('<i',data,offset+1)[0])&0xffffffff
  if target in targets:candidates.append({'address':hex(address),'target':hex(target),'bytes':data[offset:offset+5].hex()})
  offset+=1
proof={'complete':False,'native_sha256':digest,'candidates':candidates,'limits':['Executable-section E8 byte scan only; candidate alignment/control reachability and whole caller function boundaries must be verified before qualification. Does not prove constructors/producers or invocation.']};(r/'data/4.20/audio_path_resource_caller_candidates.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Candidate caller refs',len(candidates));print(candidates)
