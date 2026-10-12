"""Original focus initializer and map camera override, executing original tangent math."""
from pathlib import Path
import json,struct
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,'native setup','exec'))
assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
state=heap+0x6000;map_object=heap+0x5000;calls=[]
def hook(uc,a,size,user):
 assert 0x7d2960<=a<=0x7d29bf or 0x7cfb03<=a<0x7cfb4b or 0x8e2110<=a<=0x8e227d,hex(a)
 if a==0x8e2110:calls.append(read32(u.reg_read(UC_X86_REG_ESP)+4))
u.hook_add(unicorn.UC_HOOK_CODE,hook)
initializers=[]
for seed in [[0,0,0],[0x3f800000,0x40000000,0x40400000],[0x80000000,0x7fc01234,0xff800000],[0xdeadbeef,0x12345678,0xa5a5a5a5]]:
 for i,word in enumerate(seed):write32(0x2d773b4+i*4,word)
 u.mem_write(state,b'\xa5'*52);sp=stack+0x7000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,state);u.emu_start(0x7d2960,end,count=1000)
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)==state
 initializers.append({'saved_seed_bits':seed,'state_bits':list(struct.unpack('<13I',u.mem_read(state,52)))})
overrides=[];write32(0x2d7878c,map_object)
for map_id in list(range(128))+[0xffffffff,0x80000000]:
 calls=[];u.mem_write(state,b'\xa5'*0x200);write32(state+0x130,0x42480000);write32(state+0x1b0,0x3f800000);write32(map_object+4,map_id)
 sp=stack+0x7000;u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBP,sp+0x100);u.reg_write(UC_X86_REG_ESI,state);u.emu_start(0x7cfb03,0x7cfb4b,count=1000)
 assert u.reg_read(UC_X86_REG_EIP)==0x7cfb4b and u.reg_read(UC_X86_REG_ESP)==sp
 assert len(calls)==(2 if map_id in [11,90] else 0)
 overrides.append({'map_id_raw':map_id,'fov_bits':read32(state+0x130),'zoom_scale_bits':read32(state+0x1b0),'tangent_input_bits':calls})
constants={hex(a):read32(a) for a in [0x1138a54,0x1138a20,0x1138a74,0x1138a9c,0x1138af0,0x1138b60,0x1138c74,0x1138b8c,0x1138b74,0x1138bf8]}
proof={'native_sha256':digest,'passed':True,'initializers':initializers,'map_overrides':overrides,'constants_bits':constants,'complete':False,'limits':['Full7D2960 executes without adapters; saved vector global words are supplied explicitly, not assumed runtime defaults.','Constructor fragment7CFB03..7CFB4B and original8E2110 tangent execute without math adapters. Other controller constructor members and services are not qualified.','Map10 retains FOV50/scale1; map11 and90 use FOV40/native ratio. Current focus sentinel -1000 requires a runtime target before display.','Input bindings, active camera dispatch and renderer integration remain incomplete.']}
(r/'data/4.20/camera_defaults_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(f'Original camera defaults: {len(initializers)} initializers, {len(overrides)} map overrides passed')
