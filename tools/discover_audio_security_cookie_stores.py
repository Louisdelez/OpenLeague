from pathlib import Path
import sys,struct,json,hashlib
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
from capstone.x86 import X86_OP_MEM
r=Path('E:/OpenLeague');native=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe')
raw=native.read_bytes();pe=pefile.PE(data=raw);image=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase;cookie=0x1222ed0;pattern=struct.pack('<I',cookie)
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);md.detail=True
execute=[(v.VirtualAddress,v.VirtualAddress+max(v.Misc_VirtualSize,v.SizeOfRawData))for v in pe.sections if v.Characteristics&0x20000000]
stores={};count=0;cursor=0
while True:
 cursor=image.find(pattern,cursor)
 if cursor<0:break
 hit=cursor;cursor+=1
 if not any(a<=hit<b for a,b in execute):continue
 count+=1
 for offset in range(max(hit-6,0),hit):
  instruction=next(md.disasm(image[offset:offset+16],base+offset,count=1),None)
  if not instruction or instruction.mnemonic!='mov' or not(offset<=hit<offset+instruction.size):continue
  first=instruction.operands[0]
  if first.type!=X86_OP_MEM or first.mem.base or first.mem.index or first.mem.disp!=cookie:continue
  # Emit an exact forward decode at each confirmed absolute store; nearby call
  # graph/function entry discovery is a separate step, never guessed from bytes.
  instructions=[{'address':v.address,'bytes':v.bytes.hex(),'mnemonic':v.mnemonic,'operands':v.op_str}for v in md.disasm(image[offset:offset+160],base+offset)]
  stores[instruction.address]={'address':instruction.address,'bytes':instruction.bytes.hex(),'operands':instruction.op_str,'forward_instructions':instructions}
initial=struct.unpack_from('<I',image,cookie-base)[0];complement=struct.unpack_from('<I',image,cookie+4-base)[0]
receipt={'passed':True,'complete':False,'native_file':str(native),'native_sha256':hashlib.sha256(raw).hexdigest(),'cookie_reference':cookie,'initial_cookie':initial,'adjacent_word':complement,'executable_cookie_references':count,'absolute_cookie_stores':list(stores.values()),'limits':['Byte occurrence filtering plus exact x86 operand decoding identifies absolute stores only, not all potential indexed writes.','No function entry or entropy-call graph inferred yet. No executed cookie producer or qualified current cookie-generation implementation.']}
(r/'docs/audio_security_cookie_store_discovery.json').write_text(json.dumps(receipt,indent=2)+'\n');(r/'tools/discover_audio_security_cookie_stores.py').write_text(Path(__file__).read_text(),encoding='utf-8')
print('Cookie initial',hex(initial),'adjacent',hex(complement),'executable references',count,'confirmed absolute stores',[(hex(v['address']),v['operands'])for v in stores.values()])
