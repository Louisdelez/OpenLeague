from pathlib import Path
import struct,json,hashlib,datetime,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'alignment prerequisites','exec'))
owner=vector+0x6000;metrics=owner+0x100;text=owner+0x200;table=owner+0x300;position=owner+0x400;dimensions=owner+0x500;output=owner+0x600
f32=lambda v:struct.unpack('<f',struct.pack('<f',v))[0]
putf=lambda a,x:u.mem_write(a,struct.pack('<f',x))
horizontal=vertical=0
def hook(uc,a,size,user):
 if a in [vector+0x5000,vector+0x5010,vector+0x5020,vector+0x5030]:finish({vector+0x5000:position,vector+0x5010:dimensions,vector+0x5020:horizontal,vector+0x5030:vertical}[a]);return
 assert 0x8be3c0<=a<=0x8be4b8,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(owner+4,metrics);w(text,table)
for offset,address in [(0xc,vector+0x5000),(0x60,vector+0x5010),(0x2c,vector+0x5020),(0x34,vector+0x5030)]:w(table+offset,address)
cases=[]
for point,width,height,add,subtract,horizontal,vertical in itertools.product([[0.,0.],[11.75,-2.25]],[-13,0,13,101],[-29,0,29,80],[-3,24],[-5,0,7],[0,1,2,3],[0,1,2,3]):
 putf(position,point[0]);putf(position+4,point[1]);w(dimensions,width);w(dimensions+4,height);w(metrics+4,add);w(metrics+8,subtract)
 w(stack,end);w(stack+4,text);w(stack+8,output);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner);u.emu_start(0x8be3c0,end,count=200)
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==stack+12
 x=point[0] if horizontal==0 else f32(point[0]-(int(width/2) if horizontal==1 else width))
 y=point[1] if vertical==0 else f32(point[1]+add) if vertical==1 else f32(f32(point[1]+add)-int(height/2)) if vertical==2 else f32(point[1]-subtract)
 expected=struct.pack('<2f',x,y);actual=bytes(u.mem_read(output,8));assert actual==expected
 cases.append({'position':point,'dimensions':[width,height],'font_vertical_add':add,'font_vertical_subtract':subtract,'horizontal':horizontal,'vertical':vertical,'output_bits':list(struct.unpack('<2I',actual))})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x8be3c0','case_count':len(cases),'native_addresses':len(visited),'cases':cases,'findings':['Original alignment function executes; output8bytes compared with independent arithmetic.','Horizontal0 retainsX,1 subtracts signed integer width/2 rounded toward zero, other nonzero subtracts fullwidth.','Vertical0 retainsY;1 adds native metric+4;2 adds metric+4 then subtracts signed integer height/2;other values subtract metric+8.'],'limits':['Position/dimension/alignment virtual providers and font metric structure supplied; producers/layout enums and full rich text placement remain open.','Selected signed dimensions, font metrics, finite origins and modes0..3. Extreme integer wrapping and nonfinite inputs not qualified.','No ordinary HUD widget integration or original-framebuffer comparison.']}
(r/'data/4.20/native_font_alignment_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'passed':True}))
