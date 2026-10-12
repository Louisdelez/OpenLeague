"""Execute native signed/SSE and unsigned/x87 aspect writers; no game launch."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,'native setup','exec'))
obj=heap+0x10000;u.mem_map(obj,0x21000);bp=stack+0x8000

def hook(uc,a,size,user):
 if a in [0x982085,0x981032]:u.emu_stop();return
 assert 0x982000<=a<0x982085 or 0x980fef<=a<0x981032,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
dimensions=[0,1,600,768,1080,1920,0x7fffffff,0x80000000,0xffffffff]
cases=[]
for path,width,height in itertools.product(['unsigned_initialization','signed_device_setup'],dimensions,dimensions):
 u.mem_write(obj,b'\x00'*0x20400);write32(0x14beea0,0xdeadbeef)
 write32(obj+0x34,width);write32(obj+0x38,height)
 u.reg_write(UC_X86_REG_ESP,stack+0x7000);u.reg_write(UC_X86_REG_EBP,bp)
 if path=='unsigned_initialization':
  u.reg_write(UC_X86_REG_ECX,obj);entry=0x982000;stop=0x982085
 else:
  u.reg_write(UC_X86_REG_EBX,obj);u.reg_write(UC_X86_REG_ESI,width);u.reg_write(UC_X86_REG_EDI,height)
  write32(bp+0x14,0);write32(bp+0x10,0);entry=0x980fef;stop=0x981032
 u.emu_start(entry,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==stop
 case={'path':path,'width':width,'height':height,'aspect_bits':read32(0x14beea0)}
 if path=='unsigned_initialization':
  assert read32(obj)==1 and read32(obj+0x20328)==width and read32(obj+0x2032c)==height
  assert read32(obj+0x2a0)==read32(obj+0x2a4)==0xff000000
  assert all(read32(obj+i)==0 for i in [0x2a8,0x2ac,0x2b0])
 cases.append(case)
proof={'native_sha256':digest,'passed':True,'cases':cases,'aspect_global':'0x14BEEA0','complete':False,'limits':['Actual982000..982085 renderer initialization prefix executed including unsigned dimensions copies and aspect store; downstream981E90/982B40 excluded.','Actual980FEF..981032 signed device setup fragment executed with supplied registers and frame; previous device/service setup and subsequent allocation excluded.','Dimensions are raw32bit source values; zero height and high-bit dimensions retained without clamping.','Final game camera field overrides and client integration remain unqualified.']}
(r/'data/4.20/camera_aspect_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(f'Original aspect writers: {len(cases)} cases passed')
