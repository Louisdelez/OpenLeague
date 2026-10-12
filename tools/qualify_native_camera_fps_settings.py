"""Original7D2330 FPS camera settings/base-vector initializer."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
exec(compile((r/'tools/qualify_native_camera_random_shake.py').read_text(encoding='utf-8').split('sequences=[]')[0],'setup','exec'))
allowed.extend([(0x7d2330,0x7d244d),(0x8b20f0,0x8b20f1),(end+0x700,end+0x707)])
state=heap+0x9000;value_slot=heap+0x4000;getter_stub=end+0x700;u.mem_write(getter_stub,b'\xd9\x05'+struct.pack('<I',value_slot)+b'\xc3')
getters=[];overrides={}
def config_hook(uc,a,size,user):
 if a==0x8b20f0:
  section=cbytes(u.reg_read(UC_X86_REG_ECX)).decode();key=cbytes(u.reg_read(UC_X86_REG_EDX)).decode();default=read32(u.reg_read(UC_X86_REG_ESP)+4);assert section=='Hacks'
  value=overrides.get(key,default);getters.append({'section':section,'key':key,'default_bits':default,'value_bits':value});write32(value_slot,value);u.reg_write(UC_X86_REG_EIP,getter_stub)
u.hook_add(unicorn.UC_HOOK_CODE,config_hook)
cases=[]
for vector,velocity,acceleration in itertools.product([[0,0,0],[0x3f800000,0x40000000,0x40400000],[0x80000000,0x7fa01234,0xff800000],[0xdeadbeef,0x12345678,0xa5a5a5a5]],[None,0,0x80000000,bits([37.])[0]],[None,0,0x80000000,bits([-123.])[0]]):
 overrides={key:value for key,value in [('FPS_ViewAngleVelocity_Magnitude',velocity),('FPS_Acceleration_Magnitude',acceleration)] if value is not None};getters=[]
 for i,b in enumerate(vector):write32(0x2d773b4+i*4,b)
 initial=[0xa5a5a5a5+i for i in range(35)];u.mem_write(state,struct.pack('<35I',*initial));run(0x7d2330,ecx=state);assert u.reg_read(UC_X86_REG_EAX)==state;assert len(getters)==2
 out=list(struct.unpack('<35I',u.mem_read(state,140)));assert out[30:]==initial[30:] and out[29]&0xffff0000==initial[29]&0xffff0000
 cases.append({'vector_seed_bits':vector,'velocity_override_bits':velocity,'acceleration_override_bits':acceleration,'initial_words':initial,'output_words':out,'getter_calls':getters})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Full7D2330 initializer executed.8B20F0 configgetter adapter validates native section/key/default and returns explicit finiteoverride/default viaFLD; actual configfile lookup not qualified.','Two FPS scalar settings default15/500; eight3word vectors copied directly from supplied global2D773B4..BC. Those globals are not assumed actualruntimezero.','Writes end at offset75: partial16bit zero at74; all bytes76..8B unchanged, including controller78 mode3 angle/offset parameters. Previous inference that7D2330 initializedmode3 defaults corrected.','Native configurable scalarNaN/Inf handling and actual mode3 initialization/input producers remain unqualified; core/client activation incomplete.']}
(r/'data/4.20/camera_fps_settings_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Native FPS camera initializer:',len(cases),'cases')
