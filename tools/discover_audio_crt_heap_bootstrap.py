from pathlib import Path
import sys,json,hashlib
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'));import pefile,capstone
exe=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe');raw=exe.read_bytes();pe=pefile.PE(data=raw);imports={imp.address:imp.name.decode('ascii')for desc in pe.DIRECTORY_ENTRY_IMPORT for imp in desc.imports if imp.name};md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);word=(0x14ae87c).to_bytes(4,'little');writes=[]
for section in pe.sections:
 if not section.Characteristics&0x20000000:continue
 data=section.get_data();origin=pe.OPTIONAL_HEADER.ImageBase+section.VirtualAddress;pos=0
 while True:
  pos=data.find(word,pos)
  if pos<0:break
  start=None
  if pos>=1 and data[pos-1]==0xa3:start=pos-1
  elif pos>=2 and data[pos-2]==0x89 and data[pos-1]&0xc7==5:start=pos-2
  elif pos>=2 and data[pos-2:pos]==b'\xc7\x05':start=pos-2
  if start is not None:
   nearby=[]
   for addr,name in imports.items():
    if name not in ['HeapCreate','HeapDestroy','GetProcessHeap','HeapSetInformation']:continue
    needle=b'\xff\x15'+addr.to_bytes(4,'little');at=data.find(needle,max(0,start-96),min(len(data),start+96))
    if at>=0:nearby.append({'address':origin+at,'import':name})
   ins=next(md.disasm(data[start:start+10],origin+start));writes.append({'address':ins.address,'instruction':ins.mnemonic+' '+ins.op_str,'bytes':ins.bytes.hex(),'nearby_import_calls':nearby,'nearby_raw_start':origin+max(0,start-96),'nearby_raw':data[max(0,start-96):start+96].hex()})
  pos+=4
p={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'heap_global':'0x14ae87c','absolute_store_candidates':writes,'limits':['Exact executable-section absolute-store instruction patterns for CRT heap global and adjacent direct imported calls. Candidate function boundaries and full bootstrap control flow not qualified; raw nearby byte windows retained for follow-up disassembly.']};(r/'docs/audio_crt_heap_bootstrap_discovery.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8');(r/'tools/discover_audio_crt_heap_bootstrap.py').write_text(Path(__file__).read_text(encoding='utf-8-sig'),encoding='utf-8')
for v in writes:print(hex(v['address']),v['instruction'],v['nearby_import_calls'])
