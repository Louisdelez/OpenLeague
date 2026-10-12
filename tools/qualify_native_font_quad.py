from pathlib import Path
import json,struct,math,hashlib,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'native quad prerequisites','exec'))
row=vector+0x6000;wrapper=row+0x100;node=row+0x200;font=row+0x300;table=row+0x400;scales=row+0x500;vertices=row+0x1000;indices=row+0x2000
colors=[0xE04080C0,0xA0C08040]
f32=lambda x:struct.unpack('<f',struct.pack('<f',x))[0]
putf=lambda a,x:u.mem_write(a,struct.pack('<f',x))
def hook(uc,a,size,user):
 if a==vector+0x5000:finish(scales);return
 if a in [vector+0x5010,vector+0x5020]:
  sp=uc.reg_read(UC_X86_REG_ESP);output=read(sp+4);w(output,colors[0 if a==vector+0x5010 else 1]);finish(output,4);return
 assert 0x8bf370<=a<=0x8bf5f8 or 0x8beba0<=a<=0x8bebd5,hex(a)
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
w(row,wrapper);w(row+4,font);w(wrapper,node);w(font,table);w(table+0x3c,vector+0x5000);w(table+0x14,vector+0x5010);w(table+0x1c,vector+0x5020)
uv=[.125,.25,.625,.75]
for i,value in enumerate(uv):putf(node+0x20+i*4,value)
cases=[]
for position,dimensions,scale,opacity,base_index in itertools.product([[0.,0.],[10.75,-2.25],[-.25,.999],[-16.,32.]],[[0,0],[13,29],[256,512]],[[1.,1.,1.],[.75,1.5,.5]],[0.,.5,1.],[0,12,65532]):
 x,y=position;width,height=dimensions;sx,sy,owner_scale=scale
 putf(row+8,x);putf(row+12,y);w(node+4,width);w(node+8,height);putf(wrapper+4,owner_scale);putf(wrapper+8,opacity);putf(scales,sx);putf(scales+4,sy)
 u.mem_write(vertices,b'\xcc'*144);u.mem_write(indices,b'\xcc'*12)
 args=[row,vertices,indices,base_index,0x8beba0,0x8bebc0]
 w(stack,end)
 for i,value in enumerate(args):w(stack+4+i*4,value)
 u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0x8bf370,end,count=1000)
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==stack+28
 left=f32(math.floor(x)-.5);top=f32(math.floor(y)-.5)
 right=f32(f32(f32(width*sx)*owner_scale)+left);bottom=f32(f32(f32(height*sy)*owner_scale)+top)
 adjusted=[(c&0xffffff)|(int(f32((c>>24)*opacity))&255)<<24 for c in colors]
 expected=b''
 for px,py,u0,v0,u1,v1 in [(left,top,uv[0],uv[1],0.,0.),(right,top,uv[2],uv[1],1.,0.),(right,bottom,uv[2],uv[3],1.,1.),(left,bottom,uv[0],uv[3],0.,1.)]:expected+=struct.pack('<3f2I4f',px,py,0.,*adjusted,u0,v0,u1,v1)
 actual=bytes(u.mem_read(vertices,144));actual_indices=bytes(u.mem_read(indices,12));expected_indices=struct.pack('<6H',*[((base_index+i)&65535) for i in [0,1,2,0,2,3]])
 assert actual==expected and actual_indices==expected_indices,(position,dimensions,scale,opacity,base_index)
 cases.append({'position':position,'dimensions':dimensions,'scale':scale,'opacity':opacity,'base_index':base_index,'colors':colors,'uv':uv,'vertex_bytes_hex':actual.hex(),'indices':list(struct.unpack('<6H',actual_indices))})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x8bf370','case_count':len(cases),'native_addresses':len(visited),'cases':cases,'vertex_stride_bytes':36,'findings':['Original full glyph quad builder and native color getter callbacks execute. Four vertices and six u16 indices compared byte-for-byte with independent arithmetic.','Origin floor(x)-0.5,floor(y)-0.5; scaled dimensions use font x/y scale then glyph-owner scale. Vertex Z0.','Packed colors retain RGB and multiply alpha by owner opacity, truncate to byte. Atlas UV copied; fill UV corners0/1.','Vertex order top-left,top-right,bottom-right,bottom-left; indices0,1,2,0,2,3 with u16 wrapping.'],'limits':['Font scale and color virtual providers adapted to supplied values; original suppliers, rich text placement, baseline, kerning, clipping, wrap and alignment remain unqualified.','Supplied finite positions/sizes/scales and opacity0..1. NaN/infinity/large-coordinate rounding not qualified.','Native D3D half-texel convention recorded; port to current viewport raster conventions must be verified separately. No original framebuffer comparison.']}
(r/'data/4.20/native_font_quad_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'passed':True}))
