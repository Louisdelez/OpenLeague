"""Execute full alternate camera builders with actual shake and RNG math."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_camera_random_shake.py').read_text(encoding='utf-8').split('sequences=[]')[0]
exec(compile(source,'rng setup','exec'))
allowed.extend([(0x7cfe90,0x7d0118)])
controller=heap+0x9000;entity=heap+0xb000;write32(0x2d77f48,entity)
initial=bits([1.,2.,3.,50.,5000.,0.,0.,1.,0.,1.,0.,103.,0.,1000.,1000.,0.]);initial[12]=2;initial[15]=0xdeadbeef
cases=[]
for mode,position,direction,fov,active in itertools.product([1,2],[[0.,0.,0.],[7000.,10.,8000.],[10000000.,-20.,-10000000.]],[[0.,0.,1.],[.4,-.8,.4],[0.,0.,0.],[1e-8,0.,0.]],[40.,50.],[0,1]):
 u.mem_write(controller,b'\x00'*0x200);u.mem_write(entity,b'\x00'*0x1900)
 for offset,values in [(8,position),(0x50,direction)]:u.mem_write(controller+offset,struct.pack('<3f',*values))
 write32(controller+0x130,bits([fov])[0]);u.mem_write(entity+0x60,struct.pack('<3f',*position));u.mem_write(entity+0x18e0,struct.pack('<3f',*direction))
 # Original unaligned min/max fields overlap other entity fields only as in the source layout.
 bounds=[-2.,-3.,-4.,5.,7.,11.]
 u.mem_write(entity+0x95,struct.pack('<6f',*bounds))
 state=bits([0.,0.,0.,2.,0.,10.,0.,10.]);u.mem_write(controller+0x138,struct.pack('<8I',*state)+bytes([active])+b'\x00'*3)
 u.mem_write(camera,struct.pack('<16I',*initial));u.mem_write(0x2d78dfc,struct.pack('<f',.1));seed(42);random_calls=0
 run(0x7cfe90 if mode==1 else 0x7cffa0,[camera],controller)
 assert random_calls==(3 if active else 0)
 cases.append({'mode':mode,'position_bits':bits(position),'direction_bits':bits(direction),'bounds_bits':bits(bounds),'fov_bits':bits([fov])[0],'initial_camera_bits':initial,'initial_shake_bits':state,'initial_active_raw':active,'seed':42,'now_bits':bits([.1])[0],'output_camera_bits':list(struct.unpack('<16I',u.mem_read(camera,64))),'output_shake_bits':list(struct.unpack('<8I',u.mem_read(controller+0x138,32))),'active_raw':u.mem_read(controller+0x158,1)[0],'random_calls':random_calls,'rng':rng_state()})
# Dispatch fragment ends before builders execute: selection and receiver/argument verified directly.
targets={0x7cfb70:'normal',0x7cfe90:'mode1',0x7cffa0:'mode2',0x565910:'mode3'}
dispatch=[]
def dispatch_hook(uc,a,size,user):
 if a in targets:
  dispatch.append({'mode_raw':current,'target':targets[a],'ecx':u.reg_read(UC_X86_REG_ECX),'argument':read32(u.reg_read(UC_X86_REG_ESP)+4)});u.emu_stop();return
 assert 0x58c8b0<=a<0x58c8e9,hex(a)
# Remove original shared hook; recreation from legacy setup gives an isolated clean instance for fragment.
# Existing hook remains; extend its permitted ranges for dispatch and stop hook runs before target instructions.
allowed.extend([(0x58c8b0,0x58c8e9),(0x565910,0x565911),(0x7cfb70,0x7cfb71)])
u.hook_add(unicorn.UC_HOOK_CODE,dispatch_hook)
facade=heap+0x5000;write32(0x2d78d24,facade);write32(facade,controller)
for current in [0,1,2,3,4,55,0x7fffffff,0x80000000,0xffffffff]:
 write32(controller+0x1c0,current);u.reg_write(UC_X86_REG_ESP,stack+0x7000);u.emu_start(0x58c8b0,end,count=100)
 row=dispatch[-1];assert row['ecx']==controller+(0x78 if current==3 else 0) and row['argument']==0x1239600
 row['receiver_offset']=row.pop('ecx')-controller
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'dispatch_cases':dispatch,'constants_bits':{hex(a):read32(a) for a in [0x1138fa8,0x1138df8,0x1138990]},'limits':['Full7CFE90/7CFFA0 execute original66D6E0 normalization and7D2BE0 shake with original8E2630/8E26A0 RNG. Controller/entity inputs and clock supplied; no math adapters.','58C8B0 selection fragment executes and captures target/receiver/output argument. Subsequent renderer/global copy calls not qualified here.','Mode3 calls565910 on controller+78; static decode shows angle/trigonometric construction, not a simple camera copy. Its full math remains unqualified.','Input bindings, entity bounds producers, mode activation, renderer integration and original shake triggers remain incomplete.']}
(r/'data/4.20/camera_alternate_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print('Native alternate camera:',len(cases),'full updates,',len(dispatch),'dispatch selections')
