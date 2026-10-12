from pathlib import Path
import json,hashlib,datetime,itertools,struct
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'native atlas UV prerequisites','exec'))
atlas=vector+0x6000;texture=vector+0x7000;node=vector+0x8000;frame=vector+0xe000
def f32(value):return struct.unpack('<f',struct.pack('<f',value))[0]
def bits(value):return struct.unpack('<I',struct.pack('<f',value))[0]
u.hook_add(unicorn.UC_HOOK_CODE,lambda uc,a,size,user:visited.add(a));cases=[]
assert struct.unpack('<f',u.mem_read(0x1138ba4,4))[0]==0.5
for size,x,y,width,height,dimensions in itertools.product([256,512],[0,13,96],[0,11,76],[8,25,100],[12,44],[(256,256),(512,256)]):
 u.mem_write(node,b'\0'*0x38);w(node+4,width);w(node+8,height);w(atlas+4,size);w(atlas+8,texture);w(atlas+12,0)
 w(texture+0x60,dimensions[0]);w(texture+0x64,dimensions[1]);w(frame-0x18,atlas);w(frame-0x14,size-y);w(frame+8,node)
 u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_EBX,size-x);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0x8c02bd,0x8c0399,count=1000)
 assert u.reg_read(UC_X86_REG_EIP)==0x8c0399 and read(node+0x18)==x and read(node+0x1c)==y
 inverse_x=f32(1.0/dimensions[0]);inverse_y=f32(1.0/dimensions[1]);expected=[f32(f32(x)*inverse_x),f32(f32(y)*inverse_y),f32(f32(f32(x+width)-0.5)*inverse_x),f32(f32(y+height)*inverse_y)]
 actual=[read(node+offset) for offset in [0x20,0x24,0x28,0x2c]];assert actual==[bits(value) for value in expected]
 assert bytes(u.mem_read(node,1))==b'\1' and bytes(u.mem_read(atlas+0x12,1))==b'\1'
 cases.append({'page_size':size,'x':x,'y':y,'cell_width':width,'cell_height':height,'texture_dimensions':list(dimensions),'uv_bits':actual,'ready':True,'atlas_dirty':True})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x8c02bd','stop':'0x8c0399','case_count':len(cases),'native_addresses':len(visited),'right_edge_inset':0.5,'cases':cases,'limits':['Original existing-row successful UV assignment suffix executes with supplied atlas/texture/node and prior remaining row width/height. Original preceding row search/insertion not executed.','Exact normalized UV bits compared for256/512texture widths; right edge subtracts0.5 before multiplication, left/top/bottom have no matching subtraction. Ready and atlas dirty flags verified.','Packing, page allocation/GPU, failure paths, shadows/contours, upload and text drawing remain open.']}
(r/'data/4.20/native_font_atlas_uv_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'right_inset':0.5}))
