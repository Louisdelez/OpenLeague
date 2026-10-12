from pathlib import Path
import sys,json
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile
from capstone import Cs,CS_ARCH_X86,CS_MODE_32
d=json.loads(Path('E:/mapslol3v3/native_endgame_camera_client_locations.json').read_text());pe=pefile.PE(d['source']);base=pe.OPTIONAL_HEADER.ImageBase;image=pe.get_memory_mapped_image();md=Cs(CS_ARCH_X86,CS_MODE_32);rows=[]
for address,length in [(0x565e00,512),(0x6a68c0,256)]:
 instructions=[]
 for ins in md.disasm(image[address-base:address-base+length],address):
  instructions.append(dict(address=hex(ins.address),instruction=ins.mnemonic+' '+ins.op_str))
  if ins.mnemonic.startswith('ret'):break
 rows.append(dict(address=hex(address),instructions=instructions))
Path('E:/mapslol3v3/native_camera_pan_controller_instructions.json').write_text(json.dumps(rows,indent=2),encoding='utf-8');print(json.dumps(rows,indent=2))
