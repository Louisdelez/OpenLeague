"""Original7CFBF1..7CFE8A normal camera geometry after supplied focus update."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,'native setup','exec'));controller=heap+0x6000;camera=heap+0x8000;distance=None;queries=0
service=heap+0x9000;vtable=heap+0x9100;write32(0x2d787b8,service);write32(service,vtable);write32(vtable+0xb0,end+0x400)
ranges=[(0x7cfbf1,0x7cfe8b),(0x7d2ed0,0x7d3035),(0x7d3040,0x7d30ca),(0x866e00,0x866e9e),(0x8e24f0,0x8e254a),(0x8e2550,0x8e25b2),(0x66d6e0,0x66d72a),(0x5fa7c0,0x5fa81e),(0x5f4550,0x5f463d),(0x7d2be0,0x7d2e5f)]
def bits(values):return list(struct.unpack('<'+'I'*len(values),struct.pack('<'+'f'*len(values),*values)))
def hook(uc,a,size,user):
 global distance,queries
 if a==end+0x400:queries+=1;finish(eax=1);return
 if a==0x7d3040:distance=read32(u.reg_read(UC_X86_REG_ESP)+4)
 assert any(lo<=a<hi for lo,hi in ranges),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
initial_camera=bits([0.,0.,0.,50.,65000.,0.,0.,1.,0.,1.,0.,103.,0.,1000.,1000.,0.]);initial_camera[12]=2
cases=[]
for focus,pitch,yaw,fov,zoom_pair,scale,delta in itertools.product([[0.,0.,0.],[7000.,200.,7700.]],[0.,45.,56.9,90.],[0.,1e-6,45.,-90.,360.],[45.,103.],[(1500.,2250.),(2250.,1000.)],[1.,2.],[0.,.016]):
 initial_zoom=bits([.2,3.,scale,0.,*zoom_pair]);u.mem_write(controller,b'\x00'*0x200);u.mem_write(controller+0x104,struct.pack('<3f',*focus));u.mem_write(controller+0x120,struct.pack('<5f',pitch,yaw,0.,0.,fov));u.mem_write(controller+0x1a8,struct.pack('<6I',*initial_zoom));u.mem_write(camera,struct.pack('<16I',*initial_camera));u.mem_write(0x123eeb8,struct.pack('<f',delta));distance=None;queries=0
 sp=stack+0x8000;u.mem_write(sp,struct.pack('<II',end,camera));bp=sp-4;write32(bp,0);write32(sp-0x4c,0);write32(sp-0x50,0);u.reg_write(UC_X86_REG_EBP,bp);u.reg_write(UC_X86_REG_ESP,sp-0x50);u.reg_write(UC_X86_REG_EDI,controller)
 u.emu_start(0x7cfbf1,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end;assert queries==1 and distance is not None
 cases.append({'focus':focus,'pitch':pitch,'yaw':yaw,'previous_yaw':0.,'fov':fov,'initial_zoom_bits':initial_zoom,'delta_bits':bits([delta])[0],'initial_camera_bits':initial_camera,'distance_bits':distance,'output_zoom_bits':list(struct.unpack('<6I',u.mem_read(controller+0x1a8,24))),'output_camera_bits':list(struct.unpack('<16I',u.mem_read(camera,64)))})
proof={'native_sha256':digest,'passed':True,'cases':cases,'distance_factor_bits':read32(0x1138a08),'offset_scale_bits':read32(0x1139190),'zero_bits':read32(0x1138960),'yaw_threshold_bits':read32(0x11389ac),'normalization_threshold_bits':read32(0x1138990),'complete':False,'limits':['Actual7CFBF1..7CFE8A normal camera geometry fragment and original zoom, pitch, yaw, reciprocal/square-root helper functions executed without math adapters.','Focus supplied after7D1A60; earlier7CFB70 focus/target update prelude excluded.','Actual7D3040 warning function executed with supplied service virtual query returningtrue; remaining warning/network branch unqualified.','Actual7D2BE0 finalizer executed with shake disabled; active shake path unqualified.','Outputs include full64byte camera state and24byte zoom state; full controller defaults/input production and visible client integration remain unqualified.']}
(r/'data/4.20/camera_normal_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Original normal camera geometry: {len(cases)} cases passed')
