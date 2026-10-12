from pathlib import Path
import sys,json,struct
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs');import pefile
from capstone import Cs,CS_ARCH_X86,CS_MODE_32
source=json.loads(Path('E:/OpenLeague/data/4.20/native_endgame_default_timing.json').read_text())['source'];pe=pefile.PE(source);image=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase;md=Cs(CS_ARCH_X86,CS_MODE_32);rows=[]
for address in [0x10a6038,0x10a6468,0x10a4748,0x10a487c,0x10a48d0]:
 slots=[]
 for i in range(6):
  ptr=struct.unpack_from('<I',image,address-base+i*4)[0];executable=any(s.Characteristics&0x20000000 and base+s.VirtualAddress<=ptr<base+s.VirtualAddress+s.Misc_VirtualSize for s in pe.sections);body=[]
  if executable:
   for ins in md.disasm(image[ptr-base:ptr-base+130],ptr):
    body.append(dict(address=hex(ins.address),instruction=ins.mnemonic+' '+ins.op_str))
    if ins.mnemonic.startswith('ret'):break
  slots.append(dict(slot=i,pointer=hex(ptr),executable=bool(executable),body=body))
 rows.append(dict(address=hex(address),slots=slots))
Path('E:/mapslol3v3/native_endgame_event_table_candidates.json').write_text(json.dumps(rows,indent=2),encoding='utf-8')
print(json.dumps(rows,indent=2))
