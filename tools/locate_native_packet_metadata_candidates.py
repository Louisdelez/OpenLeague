from pathlib import Path
import sys,json,struct
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs');import pefile
source=json.loads(Path('E:/OpenLeague/data/4.20/native_endgame_default_timing.json').read_text())['source'];pe=pefile.PE(source);image=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase;rows=[]
for packet in [95,203]:
 for sec in pe.sections:
  if sec.Characteristics&0x20000000:continue
  raw=sec.get_data();pos=0
  while True:
   pos=raw.find(struct.pack('<I',packet),pos)
   if pos<0:break
   if pos%4==0:
    address=base+sec.VirtualAddress+pos;window=raw[max(0,pos-20):pos+44];rows.append(dict(packet=packet,address=hex(address),section=sec.Name.decode(errors='replace').rstrip('\0'),context_u32=[hex(struct.unpack_from('<I',window,j)[0]) for j in range(0,len(window)-3,4)]))
   pos+=4
Path('E:/mapslol3v3/native_packet_metadata_candidates.json').write_text(json.dumps(dict(rows=rows,complete=False,limits=['Integer coincidences, not qualified network registrations.']),indent=2),encoding='utf-8');print(json.dumps(rows,indent=2))
