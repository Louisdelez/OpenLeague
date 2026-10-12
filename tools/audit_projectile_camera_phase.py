from pathlib import Path
import json,hashlib,sys
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,capstone
raw=Path(json.loads((r/'docs/native_projection_discovery.json').read_text())['source']).read_bytes();pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase
cs=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
def decode(a,n):return [dict(address=hex(i.address),mnemonic=i.mnemonic,operands=i.op_str) for i in cs.disasm(pe.get_data(a-base,n),a)]
main=decode(0x58cdad,0x58d289-0x58cdad);camera=decode(0x58c8b0,0xaf)
keys=[x for x in main if x['mnemonic']=='call' and x['operands'] in ['0x717df0','0x58c8b0','0x739cf0','0x7185d0']]
assert [(x['address'],x['operands']) for x in keys]==[('0x58ce78','0x717df0'),('0x58d11d','0x58c8b0'),('0x58d12c','0x739cf0'),('0x58d1ab','0x7185d0')]
assert any(x['address']=='0x58c93e' and x['mnemonic']=='call' and x['operands']=='0x71a6e0' for x in camera)
d=dict(complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),game_loop_calls=keys,camera_helper=camera,finding='Normal game-loop entity update precedes camera visibility selection, which precedes particles and removal drain.',limits=['Static call ordering for normal state2; full runtime branch selection and camera input producers remain to qualify.','Does not qualify within-phase object ordering.'])
(r/'docs/projectile_camera_phase_audit.json').write_text(json.dumps(d,indent=2)+'\n');print(d['finding'])
