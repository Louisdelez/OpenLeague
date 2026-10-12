from pathlib import Path
import sys,json,hashlib
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
r=Path('E:/OpenLeague');source=Path(json.loads((r/'docs/native_projection_discovery.json').read_text())['source']);raw=source.read_bytes();p=pefile.PE(data=raw);img=p.get_memory_mapped_image();base=p.OPTIONAL_HEADER.ImageBase
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);md.skipdata=True
ins=list(md.disasm(img[0x918000-base:0x9437e0-base],0x918000));hits=[]
for n,i in enumerate(ins):
 dest=i.op_str.split(',')[0]
 if (' + 0x1dc]' in dest or ' + 0xa8]' in dest) and i.mnemonic in ['mov','movss','fstp','or','and','xor']:
  hits.append(dict(address=hex(i.address),context=[dict(address=hex(x.address),mnemonic=x.mnemonic,operands=x.op_str) for x in ins[max(0,n-5):n+7]]))
proof={'native_sha256':hashlib.sha256(raw).hexdigest(),'complete':False,'static_only':True,'hits':hits}
(r/'data/4.20/particle_owner_end_discovery.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps([{'address':h['address'],'instruction':next(x for x in h['context'] if x['address']==h['address'])} for h in hits],indent=2))
