from pathlib import Path
import sys,json,struct
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile
from capstone import Cs,CS_ARCH_X86,CS_MODE_32
d=json.loads(Path('E:/mapslol3v3/native_endgame_getter_locations.json').read_text());pe=pefile.PE(d['source']);base=pe.OPTIONAL_HEADER.ImageBase;image=pe.get_memory_mapped_image();md=Cs(CS_ARCH_X86,CS_MODE_32);out=[]
for row in d['rows']:
 for match in row['matches']:
  for ref in match['references']:
   if not ref['executable']:continue
   pos=int(ref['address'],16)-base;prev=image[max(0,pos-32):pos];i=prev.rfind(b'\xc7\x45\xfc');
   if i<0:continue
   callback=struct.unpack_from('<I',prev,i+3)[0];instructions=[]
   for ins in md.disasm(image[callback-base:callback-base+120],callback):
    instructions.append(dict(address=hex(ins.address),instruction=ins.mnemonic+' '+ins.op_str))
    if ins.mnemonic.startswith('ret'):break
   out.append(dict(name=row['name'],callback=hex(callback),instructions=instructions))
Path('E:/mapslol3v3/native_endgame_getter_bodies.json').write_text(json.dumps(out,indent=2),encoding='utf-8');print(json.dumps(out,indent=2))
