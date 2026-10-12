from pathlib import Path
import json,sys,hashlib,struct
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'));import pefile,capstone
p=Path(json.loads((r/'docs/native_projection_discovery.json').read_text())['source']);raw=p.read_bytes();pe=pefile.PE(data=raw);data=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase;md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
assert data[0x1088214-base:0x108821e-base]==b'LevelProp\0'
assert struct.unpack_from('<I',data,0x10c5f64-base)[0]==0x880f50
regions=[]
for start,end in [(0x52e175,0x52e1bb),(0x880d95,0x880dbc),(0x880e55,0x880e83),(0x88102c,0x881044),(0x889180,0x8891a4)]:
 code=data[start-base:end-base];instructions=[{'address':hex(i.address),'bytes':i.bytes.hex(),'operation':i.mnemonic+' '+i.op_str} for i in md.disasm(code,start)]
 regions.append({'start':hex(start),'end':hex(end),'sha256':hashlib.sha256(code).hexdigest(),'instructions':instructions})
assert any(i['operation']=='push 0x1088214' for i in regions[0]['instructions'])
assert any(i['operation']=='call 0x880d70' for i in regions[0]['instructions'])
assert any(i['operation']=='mov dword ptr [0x2d6dfb0], 0x10c5f64' for i in regions[1]['instructions'])
proof={'complete':False,'static_checks_passed':True,'native_sha256':hashlib.sha256(raw).hexdigest(),'registry_name':'LevelProp','registry_address':'0x2d6dfb0','constructor':'0x880d70','scheduler':'0x880f50','vtable':'0x10c5f64','regions':regions,'execution_evidence':'data/4.20/scheduler_game_time_dispatch_contract.json','limits':['Static initializer names this scheduler LevelProp; this does not identify each concrete scheduled-object vtable.','Still trace LevelProp virtual0 to animation graph delta. Champion/AI animation clocks remain separate and unqualified.','Native simple-node slot44 accepts delta; scheduler passes absolute time. The conversion bridge must not be skipped.']}
(r/'data/4.20/levelprop_scheduler_identity_contract.json').write_text(json.dumps(proof,indent=2));print('PASS LevelProp scheduler identity and5 byte-hashed instruction regions')
