from pathlib import Path
import sys, struct, json
sys.path.insert(0, 'E:/OpenLeague/tools/pythonlibs')
import pefile, capstone
source=json.loads(Path('E:/OpenLeague/data/4.20/native_endgame_default_timing.json').read_text())['source']
pe=pefile.PE(source); base=pe.OPTIONAL_HEADER.ImageBase; image=pe.get_memory_mapped_image()
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
for target in [int(x,16) for x in sys.argv[1:]] or [0x9c57e0]:
 needle=struct.pack('<I',target)
 start=0
 while True:
  off=image.find(needle,start)
  if off<0: break
  print('POINTER',hex(base+off),[hex(struct.unpack_from('<I',image,k)[0]) for k in range(max(0,off-32),off+36,4)])
  start=off+1
 for section in pe.sections:
  if not section.Characteristics & 0x20000000: continue
  data=section.get_data()
  for off in range(len(data)-5):
   if data[off]!=0xe8: continue
   address=base+section.VirtualAddress+off
   if address+5+struct.unpack_from('<i',data,off+1)[0]!=target: continue
   print('CALLER',hex(address),'TARGET',hex(target))
   start=max(0,off-180)
   pad=data[start:off].rfind(b'\xcc\xcc')
   if pad>=0:start+=pad+2
   for i in md.disasm(data[start:off+20],base+section.VirtualAddress+start):print(hex(i.address),i.mnemonic,i.op_str)
