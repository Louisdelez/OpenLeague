"""Full original7D2ED0 camera zoom smoothing, exact source constants and sequential state."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,'native setup','exec'));state=heap+0x6000;responses={};config_calls=[];config_result=heap+0x5000
u.mem_write(end+0x300,b"\xd9\x05"+struct.pack("<I",config_result)+b"\xc3")

def bits(value):return struct.unpack('<I',struct.pack('<f',value))[0]
def hook(uc,a,size,user):
 if a==0x8b20f0:
  sp=u.reg_read(UC_X86_REG_ESP);section=cbytes(u.reg_read(UC_X86_REG_ECX)).decode('ascii');key=cbytes(u.reg_read(UC_X86_REG_EDX)).decode('ascii');default=read32(sp+4)
  assert section=='CameraSmoothing' and key in ['CameraZoomEaseTime','CameraZoomMinSpeed'];config_calls.append({'section':section,'key':key,'default_bits':default});write32(config_result,responses.get(key,default));u.reg_write(UC_X86_REG_EIP,end+0x300);return
 assert 0x7d2ed0<=a<=0x7d3034 or 0x7d2e70<=a<=0x7d2ecd or end+0x300<=a<=end+0x306,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
def sequence(initial,deltas,origin):
 u.mem_write(state,struct.pack('<6I',*initial));steps=[]
 for delta in deltas:
  write32(0x123eeb8,delta);sp=stack+0x7000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,state);u.emu_start(0x7d2ed0,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
  steps.append({'delta_bits':delta,'state_bits':list(struct.unpack('<6I',u.mem_read(state,24)))})
 cases.append({'origin':origin,'initial_bits':initial,'steps':steps})
for duration,epsilon,pair,velocity in itertools.product([0.,.1,1.],[0.,1.,10.],[(500.,1500.),(1500.,3000.),(2250.,1000.),(1500.,1500.)],[-100.,0.,100.]):
 current,target=pair;sequence([bits(duration),bits(epsilon),0xa5a5a5a5,bits(velocity),bits(current),bits(target)],[bits(d) for d in [0.,1e-16,.016,.25,1.,-.5,1.]],'regular transition sequence')
tiny=read32(0x1138980)
for duration,delta in itertools.product([tiny-1,tiny,tiny+1,bits(-1.),0x7fc00000,0x7f800000],[tiny-1,tiny,tiny+1]):
 sequence([duration,bits(1.),0xa5a5a5a5,bits(10.),bits(1500.),bits(2000.)],[delta,delta,delta],'duration/delta boundary or exceptional')
for field in [0,1,3,4,5]:
 initial=[bits(.1),bits(1.),0xa5a5a5a5,bits(10.),bits(1500.),bits(2000.)];initial[field]=0x7fc00000;sequence(initial,[bits(.016),bits(1.)],'NaN state field')
sequence([bits(.1),bits(1.),0xa5a5a5a5,bits(10.),bits(1500.),bits(2000.)],[0x7fc00000,bits(.016)],'NaN delta')
initializers=[]
for ease,speed in itertools.product([None,bits(0.),bits(.5),0x7fc00000],[None,bits(0.),bits(10.)]):
 responses={};config_calls=[]
 if ease is not None:responses['CameraZoomEaseTime']=ease
 if speed is not None:responses['CameraZoomMinSpeed']=speed
 u.mem_write(state,b'\xa5'*24);sp=stack+0x7000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,state);u.emu_start(0x7d2e70,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
 initializers.append({'ease_bits':ease,'minimum_speed_bits':speed,'config_calls':config_calls,'state_bits':list(struct.unpack('<6I',u.mem_read(state,24)))})
constants={hex(a):read32(a) for a in [0x1138980,0x1138df8,0x1138c74,0x1138b98,0x1138b3c,0x11391ec,0x11391c4,0x1138b30]}
proof={'native_sha256':digest,'passed':True,'constants_bits':constants,'cases':cases,'initializers':initializers,'complete':False,'limits':['Full7D2ED0 executed without math/state adapters; frame delta global123EEB8 supplied. Full7D2E70 initializer executed with config getter adapter returning defaults/explicit overrides via native x87 return stub.','Raw smoothing state duration0,epsilon4,scale8,velocityC,current10,target14 tracked word-by-word across sequences.','Original denominator includes coefficient product and fifth power, not a substituted generic damping formula.','Original current clamps to1000..2250 after ordered snap/minimum-step logic; target and velocity are not arbitrarily clamped.','Zoom initializer defaults and supplied overrides qualified; config file parser, controller focus/pitch/FOV, zoom input and live renderer integration remain unqualified.']}
(r/'data/4.20/camera_zoom_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Original camera zoom: {len(cases)} sequences, {sum(len(c["steps"]) for c in cases)} state updates passed')
