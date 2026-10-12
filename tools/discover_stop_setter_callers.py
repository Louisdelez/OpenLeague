from pathlib import Path
import sys,json,struct,hashlib
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
r=Path('E:/OpenLeague');source=Path(json.loads((r/'docs/native_projection_discovery.json').read_text())['source']);raw=source.read_bytes();p=pefile.PE(data=raw);img=p.get_memory_mapped_image();base=p.OPTIONAL_HEADER.ImageBase;m=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
target=0x9289b0;calls=[];pointers=[]
for sec in p.sections:
 start=sec.VirtualAddress;stop=start+sec.Misc_VirtualSize
 if sec.Characteristics&0x20000000:
  at=start
  while True:
   at=img.find(b'\xe8',at,stop)
   if at<0:break
   if at+5<=stop and base+at+5+struct.unpack_from('<i',img,at+1)[0]==target:
    context=list(m.disasm(img[max(start,at-20):at+45],base+max(start,at-20)))
    calls.append({'address':hex(base+at),'context':[dict(address=hex(i.address),mnemonic=i.mnemonic,operands=i.op_str) for i in context]})
   at+=1
 else:
  at=start
  while True:
   at=img.find(struct.pack('<I',target),at,stop)
   if at<0:break
   pointers.append(hex(base+at));at+=4
out={'native_sha256':hashlib.sha256(raw).hexdigest(),'complete':False,'static_only':True,'target':hex(target),'direct_calls':calls,'data_pointers':pointers}
(r/'data/4.20/particle_stop_setter_callers.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(out,indent=2))
