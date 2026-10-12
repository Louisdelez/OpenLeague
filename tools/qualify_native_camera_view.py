"""Execute full original986250 view builder and its original matrix/math callees."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,'native setup','exec'))
camera=heap+0x8000;output=heap+0x6000;calls=[]
allowed=[(0x986250,0x986397),(0x8dffa0,0x8e025b),(0x8de480,0x8de4f2),(0x8de500,0x8de56a),(0x66d6e0,0x66d72a),(0x716810,0x716882),(0x8df600,0x8df68f),(0x8df790,0x8dfb00)]
def hook(uc,a,size,user):
 assert any(lo<=a<hi for lo,hi in allowed),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
positions=[[0.,0.,0.],[1.,2.,3.],[-100.,500.,10000.],[7400.,6800.,7700.]]
directions=[[0.,0.,1.],[1.,0.,0.],[0.,1.,0.],[0.,0.,0.],[1.,2.,3.],[-2.,-3.,1.],[0.,-1.,-1.],[0.00001,0.,0.],[0.0001,0.,0.],[1e-8,1e-8,1e-8]]
ups=[[0.,1.,0.],[0.,0.,1.],[1.,2.,3.],[0.,0.,0.]]
cases=[]
for mode,position,direction,up in itertools.product([0,1,2,3,0xffffffff],positions,directions,ups):
 u.mem_write(camera,b'\x00'*64);u.mem_write(camera,struct.pack('<3f',*position));u.mem_write(camera+0x14,struct.pack('<6f',*direction,*up));write32(camera+0x30,mode);u.mem_write(output,b'\xa5'*64)
 sp=stack+0x7000;u.mem_write(sp,struct.pack('<II',end,output));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,camera)
 u.emu_start(0x986250,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 cases.append({'mode':mode,'position':position,'direction':direction,'up':up,'matrix_bits':list(struct.unpack('<16I',u.mem_read(output,64)))})
proof={'native_sha256':digest,'passed':True,'cases':cases,'normalization_threshold_bits':read32(0x1138990),'mode2_rotation_angle_bits':read32(0x11392f4),'complete':False,'limits':['Full986250 and original8DFFA0/66D6E0/8DE500/8DE480/716810/8DF600/8DF790 executed without math adapters.','Supplied camera fields cover raw projection modes and degenerate direction/up; final in-game setters remain unqualified.','RSQRTSS estimate varies across emulator/CPU; matrix normalization comparisons require explicit tolerance.','Rawmode2 is special shear/rotation view; other modes use position+direction look-at. Real client camera binding remains unqualified.']}
(r/'data/4.20/camera_view_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Original full camera view: {len(cases)} cases passed')
