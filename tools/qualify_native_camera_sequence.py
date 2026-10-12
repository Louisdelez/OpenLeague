"""Full7CFB70 normal camera in explicit contexts without resolved automatic follow or shake."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_camera_normal.py').read_text(encoding='utf-8').split('\nu.hook_add(unicorn.UC_HOOK_CODE,hook)')[0]
exec(compile(source,'normal setup','exec'))
assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
focus_service=heap+0xb000;focus_vtable=heap+0xb100;ui=heap+0xa000;special=heap+0xa400;active=0;focus_queries=0
write32(0x2d791a4,focus_service);write32(focus_service,focus_vtable);write32(focus_vtable+0x10,end+0x500);u.mem_write(focus_service+0x14,b'\x01');write32(0x2d77e54,ui);write32(ui+0x13c,special);write32(ui+0x130,0)
ranges[0]=(0x7cfb70,0x7cfe8b);ranges.append((0x7d1a60,0x7d1d10));ranges.append((0x5755c4,0x5755f9))
def hook(uc,a,size,user):
 global queries,focus_queries,distance
 if a==end+0x400:queries+=1;finish(eax=1);return
 if a==end+0x500:focus_queries+=1;finish(eax=active);return
 if a==0x7d3040:distance=read32(u.reg_read(UC_X86_REG_ESP)+4)
 assert any(lo<=a<hi for lo,hi in ranges),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
settings=json.loads((r/'data/4.20/camera_map10_settings.json').read_text(encoding='utf-8'))
v=settings['native_values'];rectangle=[v['cam_MinX'],v['cam_MaxX'],v['cam_MinY'],v['cam_MaxY']];center=[7500.,10.,7500.];saved=[7400.,70.,8100.];cases=[]
initial_camera=bits([0.,0.,0.,50.,65000.,0.,0.,1.,0.,1.,0.,103.,0.,1000.,1000.,0.]);initial_camera[12]=2
for focus,block,held,active,service_flag,special_flag,radius in itertools.product([[-100.,42.,7700.],[7000.,-1000.,7700.],[15500.,-999.,15500.],[7500.,99.,7500.],[7000.,0.,7700.],[7000.,-999.001,7700.],[7000.,-998.999,7700.],[20000.,20000.,-1000.]],[0,1],[0,2],[0,1],[0,2],[0,2],[0.,3000.]):
 u.mem_write(controller,b'\x00'*0x200);u.mem_write(controller+0x104,struct.pack('<6f',*focus,*saved));u.mem_write(controller+0x120,struct.pack('<5f',56.,180.,180.,56.,50.));u.mem_write(controller+0x15c,struct.pack('<4f',*center,radius));u.mem_write(controller+0x1c5,bytes([held]));zoom=bits([.2,3.,1.,0.,2250.,1000.]);u.mem_write(controller+0x1a8,struct.pack('<6I',*zoom));u.mem_write(camera,struct.pack('<16I',*initial_camera));u.mem_write(focus_service+0x17,bytes([service_flag]));u.mem_write(special+0xe9,bytes([special_flag]));write32(0x2d77f48,block)
 for a,value in zip([0x123e88c,0x123e8ac,0x123e89c,0x123e8bc],rectangle):u.mem_write(a,struct.pack('<f',value))
 u.mem_write(0x123eeb8,struct.pack('<f',.016));queries=0;focus_queries=0;distance=None;sp=stack+0x8000;u.mem_write(sp,struct.pack('<II',end,camera));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,controller);u.emu_start(0x7cfb70,end,count=10000)
 assert u.reg_read(UC_X86_REG_EIP)==end and focus_queries==1 and distance is not None
 assert queries==(2 if focus[1]<-999. and block==0 else 1)
 cases.append({'focus':focus,'saved':saved,'radius':radius,'rectangle':rectangle,'center':center,'held_raw':held,'active_raw':active,'service_flag_raw':service_flag,'special_flag_raw':special_flag,'auto_follow_block_raw':block,'query_count':queries,'initial_zoom_bits':zoom,'delta_bits':bits([.016])[0],'initial_camera_bits':initial_camera,'output_focus_bits':list(struct.unpack('<6I',u.mem_read(controller+0x104,24))),'output_held_raw':u.mem_read(controller+0x1c5,1)[0],'output_zoom_bits':list(struct.unpack('<6I',u.mem_read(controller+0x1a8,24))),'output_camera_bits':list(struct.unpack('<16I',u.mem_read(camera,64))),'distance_bits':distance})
depth_cases=[];renderer=heap+0xc000;write32(0x2d79078,renderer)
for near,far in itertools.product([bits([50.])[0],0,0x80000000,0x7fc01234],[bits([v['cam_FarZ']])[0],bits([65000.])[0],0x80000000,0x7f800000]):
 u.mem_write(renderer,b'\x00'*0x300);write32(renderer+0x228,near);write32(renderer+0x22c,0xdeadbeef);write32(0x123e9a0,far);u.mem_write(0x1239600,b'\xa5'*64);u.emu_start(0x5755c4,0x5755f9,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x5755f9
 assert read32(renderer+0x22c)==far and read32(0x123960c)==near and read32(0x1239610)==far
 depth_cases.append({'near_bits':near,'far_bits':far,'renderer_far_bits':read32(renderer+0x22c),'camera_near_bits':read32(0x123960c),'camera_far_bits':read32(0x1239610)})
proof={'depth_setup_cases':depth_cases,'native_sha256' :digest,'map_settings':settings,'passed':True,'cases':cases,'complete':False,'limits':['Full7CFB70 executes with original focus/zoom/pitch/direction/finalizer math. Service virtual queries return supplied active byte/true.','Auto-follow prelude sentinel threshold and block branches execute; optional UI target reference absent, so weak target resolution and target setter path excluded. Active shake disabled.','Controller forcibly sets current focus Y0 before7D1A60; hold restore may reintroduce saved Y. This order is preserved.','Rectangle/radius/service flag producers supplied. Static cam_MinX/Y defaults300 and cam_MaxX/Y14545 were located; map-specific runtime overrides not qualified and not applied to client.','Native5755C4..5755F9 depth setup copies cam_FarZ global123E9A0 into renderer22C and main camera1239610; renderer228 near copied to main123960C. Map10cam_FarZ5000 now sourced, bootstrap near initialization unqualified.','No full camera mode dispatcher or native runtime frame-loop equivalence claimed.']}
(r/'data/4.20/camera_sequence_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Full original normal camera: {len(cases)} controlled sequences passed')
