from pathlib import Path
import sys,json,struct,hashlib
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
r=Path('E:/OpenLeague');d=json.loads((r/'docs/native_projection_discovery.json').read_text(encoding='utf-8-sig'))
exe=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe')
b=exe.read_bytes();pe=pefile.PE(data=b);base=pe.OPTIONAL_HEADER.ImageBase
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
key=b'FOG_OF_WAR_ALWAYS_BELOW_Y';at=b.find(key)
if at<0:
 proof={'complete':False,'native_sha256':hashlib.sha256(b).hexdigest(),'key':key.decode(),'ascii_present':False,'utf16le_present':key.decode().encode('utf-16le') in b,'next_action':'Trace original shader constant-register250 stores/upload paths; exact string lookup cannot locate this producer.','limits':['Absent name is not evidence that the shader coefficient is absent or unused. No coefficient value inferred.']}
 (r/'docs/fow_below_y_discovery.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(proof));sys.exit(0)
va=base+pe.get_rva_from_offset(at);needle=struct.pack('<I',va);refs=[]
for section in pe.sections:
 if not section.Characteristics&0x20000000:continue
 start=section.PointerToRawData;end=start+section.SizeOfRawData;position=start
 while True:
  position=b.find(needle,position,end)
  if position<0:break
  address=base+pe.get_rva_from_offset(position)
  # Raw immediate reference; disassembly window is a locator, not a function-boundary proof.
  offset=max(start,position-64);window=base+pe.get_rva_from_offset(offset)
  refs.append({'immediate_va':hex(address),'window':[{ 'address':hex(i.address),'instruction':i.mnemonic+' '+i.op_str} for i in md.disasm(b[offset:position+150],window)]});position+=4
proof={'complete':False,'native_sha256':hashlib.sha256(b).hexdigest(),'key':key.decode(),'string_va':hex(va),'raw_code_references':refs,'limits':['Raw immediate references and unaligned disassembly windows locate candidates; no function execution or coefficient qualification yet.']}
(r/'docs/fow_below_y_discovery.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(proof))
