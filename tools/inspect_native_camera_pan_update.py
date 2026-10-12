from pathlib import Path
import sys,json
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile
from capstone import Cs,CS_ARCH_X86,CS_MODE_32
d=json.loads(Path('E:/mapslol3v3/native_endgame_camera_client_locations.json').read_text());pe=pefile.PE(d['source']);base=pe.OPTIONAL_HEADER.ImageBase;image=pe.get_memory_mapped_image();md=Cs(CS_ARCH_X86,CS_MODE_32)
rows=[dict(address=hex(i.address),instruction=i.mnemonic+' '+i.op_str) for i in md.disasm(image[0x565f50-base:0x566490-base],0x565f50)]
Path('E:/mapslol3v3/native_camera_pan_update_instructions.json').write_text(json.dumps(rows,indent=2),encoding='utf-8')
print('\n'.join(i['address']+' '+i['instruction'] for i in rows[:160]))
