from pathlib import Path
import sys,json,hashlib,struct
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'));import pefile,capstone
p=Path(json.loads((r/'docs/native_projection_discovery.json').read_text())['source']);raw=p.read_bytes();pe=pefile.PE(data=raw);d=pe.get_memory_mapped_image();b=pe.OPTIONAL_HEADER.ImageBase;m=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
assert struct.unpack_from('<I',d,0x1091770-b)[0]==0x6469e0
assert struct.unpack_from('<I',d,0x109361c-b)[0]==0x565170
assert d[0x565170-b:0x565173-b]==bytes.fromhex('c20400')
regions=[]
for a,z in [(0x5891d5,0x5891f1),(0x883618,0x88362d),(0x877106,0x87712a),(0x877170,0x87718e),(0x6469e0,0x6469f5)]:
 code=d[a-b:z-b];regions.append({'start':hex(a),'end':hex(z),'sha256':hashlib.sha256(code).hexdigest(),'instructions':[f'{i.address:x} {i.mnemonic} {i.op_str}' for i in m.disasm(code,a)]})
proof={'complete':False,'static_checks_passed':True,'native_sha256':hashlib.sha256(raw).hexdigest(),'chain':['network registration5891d5: object+138 passed to LevelProp manager','883610 binds wrapper+8 to object+120','constructor8770b0 sets wrapper vtable1091770 and object+120 vtable109361c','wrapper virtual0=6469e0 forwards f32 argument to object+120 virtual0','object+120 virtual0=565170 returns with ret4 and no work'],'regions':regions,'conclusion':'This concrete constructor configuration has no animation update through the LevelProp scheduler. Do not use scheduler dispatch evidence alone to choose animation clock.','limits':['Constructor instructions checked statically; factory-derived overrides and other registered object classes remain unqualified.','Animation/render update path not yet traced.']}
(r/'data/4.20/levelprop_scheduler_receiver_contract.json').write_text(json.dumps(proof,indent=2));print('PASS wrapper routing and no-op slot byte checks')
