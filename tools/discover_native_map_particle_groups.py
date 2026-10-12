from pathlib import Path
import sys,re,struct,json,hashlib,shutil
from datetime import datetime,timezone
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'));import pefile,capstone
path=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe');payload=path.read_bytes();p=pefile.PE(data=payload);base=p.OPTIONAL_HEADER.ImageBase;img=p.get_memory_mapped_image();m=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);rows=[]
for match in re.finditer(rb'[^\x00\x01-\x1f\x7f-\xff]*[Gg]roup[Pp]art[^\x00\x01-\x1f\x7f-\xff]*\x00',img):
 text=match.group()[:-1].decode('ascii');addr=base+match.start();refs=[];needle=struct.pack('<I',addr)
 for section in p.sections:
  if not section.Characteristics&0x20000000:continue
  start=section.VirtualAddress;end=start+section.Misc_VirtualSize;at=start
  while (at:=img.find(needle,at,end))>=0:
   # Only immediate push forms are accepted as aligned instruction starts.
   if img[at-1]==0x68:
    instructions=list(m.disasm(img[at-1:at+240],base+at-1));refs.append({'address':hex(base+at-1),'instructions':[{'address':hex(i.address),'mnemonic':i.mnemonic,'operands':i.op_str,'bytes':i.bytes.hex()} for i in instructions]})
   at+=4
 rows.append({'string_address':hex(addr),'text':text,'aligned_push_references':refs})
proof={'updated_utc':datetime.now(timezone.utc).isoformat(),'native_sha256':hashlib.sha256(payload).hexdigest(),'complete':False,'strings':rows,'limits':['Aligned native push references discovered; static inspection alone does not qualify defaults, emitter class selection or native configuration reader execution.']};(r/'docs/native_map_particle_group_discovery.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps([{'text':row['text'],'address':row['string_address'],'references':[v['address'] for v in row['aligned_push_references']]} for row in rows]))
