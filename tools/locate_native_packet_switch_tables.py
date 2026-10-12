from pathlib import Path
import sys,json,struct
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs');import pefile
from capstone import Cs,CS_ARCH_X86,CS_MODE_32
source=json.loads(Path('E:/OpenLeague/data/4.20/native_endgame_default_timing.json').read_text())['source'];pe=pefile.PE(source);base=pe.OPTIONAL_HEADER.ImageBase;image=pe.get_memory_mapped_image();md=Cs(CS_ARCH_X86,CS_MODE_32);rows=[]
def code(ptr):return any(s.Characteristics&0x20000000 and base+s.VirtualAddress<=ptr<base+s.VirtualAddress+s.Misc_VirtualSize for s in pe.sections)
for section in pe.sections:
 if not section.Characteristics&0x20000000:continue
 raw=section.get_data();pos=0
 while True:
  pos=raw.find(b'\xff\x24',pos)
  if pos<0:break
  if pos+7<=len(raw) and raw[pos+2]&0xc7==0x85:
   table=struct.unpack_from('<I',raw,pos+3)[0];offset=table-base;entries=[]
   if 0<=offset<len(image)-1024:
    for i in range(350):
     ptr=struct.unpack_from('<I',image,offset+i*4)[0]
     if not code(ptr):break
     entries.append(ptr)
   if len(entries)>203:
    address=base+section.VirtualAddress+pos
    rows.append(dict(address=hex(address),table=hex(table),entries=len(entries),target95=hex(entries[95]),target203=hex(entries[203]),context=[dict(address=hex(ins.address),instruction=ins.mnemonic+' '+ins.op_str) for ins in md.disasm(raw[max(0,pos-35):pos+7],base+section.VirtualAddress+max(0,pos-35))]))
  pos+=2
Path('E:/mapslol3v3/native_packet_switch_table_candidates.json').write_text(json.dumps(dict(rows=rows,complete=False,limits=['Large code-pointer tables only; indices have not been proved to be network packet IDs.']),indent=2),encoding='utf-8');print(json.dumps(rows,indent=2))
