from pathlib import Path
import struct, json, sys
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
source=json.loads(Path('E:/OpenLeague/data/4.20/native_endgame_default_timing.json').read_text())['source']
pe=pefile.PE(source);base=pe.OPTIONAL_HEADER.ImageBase;data=pe.get_memory_mapped_image()
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
for word in [b'HPStat\0',b'MPStat\0',b'%d / %d\0',b'%u / %u\0',b'%.0f / %.0f\0']:
 start=0
 while True:
  off=data.find(word,start)
  if off<0:break
  address=base+off;print('STRING',word,hex(address));start=off+1
  needle=struct.pack('<I',address);pos=0
  while True:
   ref=data.find(needle,pos)
   if ref<0:break
   pos=ref+1
   if not any(s.VirtualAddress<=ref<s.VirtualAddress+s.Misc_VirtualSize and s.Characteristics&0x20000000 for s in pe.sections):continue
   begin=max(0,ref-160);padding=data[begin:ref].rfind(b'\xcc\xcc')
   if padding>=0:begin+=padding+2
   print('REFERENCE',hex(base+ref))
   for ins in md.disasm(data[begin:ref+220],base+begin):print(hex(ins.address),ins.mnemonic,ins.op_str)
