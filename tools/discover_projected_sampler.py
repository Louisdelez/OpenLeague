from pathlib import Path
import sys,json
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
r=Path('E:/OpenLeague');source=Path(json.loads((r/'docs/native_projection_discovery.json').read_text(encoding='utf-8'))['source']);p=pefile.PE(str(source));img=p.get_memory_mapped_image();base=p.OPTIONAL_HEADER.ImageBase;m=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
hits=[]
for s in p.sections:
 if not s.Characteristics&0x20000000:continue
 lo=s.VirtualAddress;hi=lo+s.Misc_VirtualSize
 for reg in [0x90,0x91,0x92,0x93,0x96,0x97]:
  pattern=bytes([0xff,reg,0x14,0x01,0x00,0x00]);start=lo
  while True:
   at=img.find(pattern,start,hi)
   if at<0:break
   start=at+1;context=img[max(lo,at-100):at]
   hits.append({'call':hex(at+base),'bytes_before':context.hex(),'bytes_after':img[at:at+35].hex()})
print('potential_addresses',[h['call'] for h in hits])
for hit in [h for h in hits if 0x9a0000<=int(h['call'],16)<0x9d0000]:
 at=int(hit['call'],16);start=max(base,at-70)
 print('CANDIDATE',hit['call'])
 print('\n'.join(hex(i.address)+' '+i.mnemonic+' '+i.op_str for i in m.disasm(img[start-base:at-base+15],start)))
print('potential_calls',len(hits))
