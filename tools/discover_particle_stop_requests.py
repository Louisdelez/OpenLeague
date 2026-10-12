from pathlib import Path
import sys,json,hashlib
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
r=Path('E:/OpenLeague');source=Path(json.loads((r/'docs/native_projection_discovery.json').read_text())['source']);raw=source.read_bytes();p=pefile.PE(data=raw);img=p.get_memory_mapped_image();base=p.OPTIONAL_HEADER.ImageBase
m=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);m.skipdata=True;ins=list(m.disasm(img[0x93d000-base:0x941f00-base],0x93d000));hits=[]
for n,i in enumerate(ins):
 dest=i.op_str.split(',')[0]
 if (i.mnemonic=='call' and i.op_str=='0x93fa10') or (' + 0x144]' in dest and i.mnemonic in ['mov','or','and','xor']):
  hits.append(dict(address=hex(i.address),context=[dict(address=hex(x.address),mnemonic=x.mnemonic,operands=x.op_str) for x in ins[max(0,n-6):n+5]]))
proof={'native_sha256':hashlib.sha256(raw).hexdigest(),'complete':False,'static_only':True,'hits':hits}
(r/'data/4.20/particle_stop_requests_discovery.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps(hits,indent=2))
