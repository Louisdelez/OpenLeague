from pathlib import Path
import sys,json
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
r=Path('E:/OpenLeague');source=Path(json.loads((r/'docs/native_projection_discovery.json').read_text())['source'])
p=pefile.PE(str(source));img=p.get_memory_mapped_image();base=p.OPTIONAL_HEADER.ImageBase
m=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);m.skipdata=True
instructions=list(m.disasm(img[0x92ea60-base:0x94b000-base],0x92ea60));out=[]
for n,i in enumerate(instructions):
 if i.mnemonic=='call' and i.op_str in ['0x944600','0x944760','0x943300','0x941f00']:
  block=[dict(address=hex(x.address),mnemonic=x.mnemonic,operands=x.op_str) for x in instructions[max(0,n-10):n+7]]
  out.append(dict(call=hex(i.address),target=i.op_str,context=block))
  print(json.dumps(out[-1]))
(r/'data/4.20/simple_update_order_discovery.json').write_text(json.dumps(dict(native_sha256=__import__('hashlib').sha256(source.read_bytes()).hexdigest(),complete=False,calls=out),indent=2)+'\n')
