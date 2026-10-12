"""Original6AB380 yaw matrix with actual FPATAN and quantized6BD9F0 rotations."""
from pathlib import Path
import json,struct,random
r=Path(__file__).resolve().parents[1]
exec(compile((r/'tools/qualify_native_camera_angles.py').read_text(encoding='utf-8').split('trig=[]')[0],'setup','exec'))
allowed.extend([(0x6ab380,0x6ab514),(0x6bd9f0,0x6bdc18),(0x8de480,0x8de568)])
frame=heap+0x9000;vector=heap+0xb000
randomizer=random.Random(420)
values=[[0.,0.,0.],[0.,20.,0.],[-0.,1.,-0.],[1.,0.,0.],[-1.,0.,0.],[0.,0.,1.],[0.,0.,-1.],[1.,5.,1.],[-1.,-5.,1.],[1e-20,0.,1.],[1e-20,0.,-1.]]+[[randomizer.uniform(-100,100),randomizer.uniform(-10,10),randomizer.uniform(-100,100)] for _ in range(100)]
cases=[];theta=[]
def angle_hook(uc,a,size,user):
 if a==0x6bd9f0:theta.append(read32(u.reg_read(UC_X86_REG_ESP)+8))
u.hook_add(unicorn.UC_HOOK_CODE,angle_hook)
for value in values:
 initial=[0x3f800000,0x7fa01234]+[0xa5a5a5a5]*17;u.mem_write(frame,struct.pack('<19I',*initial));u.mem_write(vector,struct.pack('<3f',*value));theta=[]
 run(0x6ab380,[vector],frame);out=list(struct.unpack('<19I',u.mem_read(frame,76)));assert out[16:]==initial[16:]
 assert len(theta)==(0 if value[0]==0 and value[2]==0 else 2)
 if theta:assert theta[0]==theta[1]
 cases.append({'direction_bits':bits(value),'initial_frame_bits':initial,'output_frame_bits':out,'angle_bits':theta[0] if theta else None})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'constants_bits':{hex(a):read32(a) for a in [0x1139068,0x1139128,0x1139094]},'limits':['Full6AB380 executes actual FPATAN,6BD9F0 two Y-axis quantized rotations,8DE480 identity and8DE500copy without adapters. Finite direction inputs supplied.','Native X/Z bothzero skips matrix write, Y ignored. Quantized index uses360-angle and90-(360-angle), preserving f32 rounding before CVTTSS2SI; genericatan2/quaternion not equivalent.','Native movement update cadence, initial facing producers, other rotation axes and client GPU integration remain unqualified. Position cache aftermatrix preserved.']}
(r/'data/4.20/entity_yaw_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Native entity yaw:',len(cases),'full updates')
