from pathlib import Path
import json,hashlib,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'native atlas pixels prerequisites','exec'))
atlas=vector+0x6000;rows=vector+0x6100;lists=vector+0x6300;nodes=vector+0x6800;glyphs=vector+0x7000;face=vector+0x7800;slot=vector+0x7900;metrics=vector+0x7a00;bitmap=vector+0x7b00;destination=vector+0x9000;source_pixels=vector+0x8000
calls=[]
def hook(uc,a,size,user):
 if a==0xc3b830:
  sp=uc.reg_read(UC_X86_REG_ESP);args=[read(sp+4+i*4) for i in range(3)];assert args[0]==face and args[2]==4
  index=args[1];calls.append(index);u.mem_write(bitmap,bytes([index+1,64,128,192,254,255]));finish(0);return
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
w(face+0x54,slot);w(face+0x58,metrics);w(slot+0x4c,2);w(slot+0x50,3);w(slot+0x54,3);w(slot+0x58,bitmap);w(slot+0x24,9*64);w(metrics+0x18,12*64)
routed=[]
profiles=[[],[[]],[[0]],[[0,1],[2]],[[2],[],[1,0]]]
positions=[[2,3],[10,5],[20,1]]
for groups,offset,stride in itertools.product(profiles,[0,1,3],[48,64]):
 calls.clear();w(atlas+0x14,rows);w(atlas+0x18,rows+len(groups)*12)
 for index,(x,y) in enumerate(positions):
  node=nodes+index*0x40;glyph=glyphs+index*0x40;w(node+0x18,x);w(node+0x1c,y);w(node+0x30,glyph);w(glyph,0x10ca2c0);w(glyph+0x24,face);w(glyph+0x2c,index)
 for row_index,indices in enumerate(groups):
  address=lists+row_index*0x40;w(rows+row_index*12,address);w(rows+row_index*12+4,address+len(indices)*4)
  for col,index in enumerate(indices):w(address+col*4,nodes+index*0x40)
 length=stride*32*4;u.mem_write(destination,b'\xa5'*length)
 w(stack,end)
 for index,value in enumerate([destination,stride,offset,offset]):w(stack+4+index*4,value)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,atlas);u.emu_start(0x8c0510,end,count=10000)
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==stack+20 and u.reg_read(UC_X86_REG_EAX)==0
 expected=bytearray(b'\xa5'*length);order=[index for group in groups for index in group];assert calls==order
 for index in order:
  x,y=positions[index];values=[index+1,64,128,192,254,255]
  for dy in range(2):
   for dx in range(3):
    start=((y+offset+3+dy)*stride+x+offset+dx)*4;expected[start:start+4]=bytes([values[dy*3+dx]])*4
 actual=bytes(u.mem_read(destination,length));assert actual==expected
 routed.append({'rows':groups,'positions':positions,'offset':offset,'stride_pixels':stride,'height':32,'load_indices':list(calls),'destination_sha256':hashlib.sha256(actual).hexdigest(),'destination_hex':actual.hex()})
masks=[]
for entry in [0x8c05a0,0x8c05f0]:
 for a,b in itertools.product(range(256),[0,1,64,128,255]):
  src=bytes([a,0x37,0x59,0x91]);dst=bytes([b,0x13,0x27,0x81]);u.mem_write(source_pixels,src);u.mem_write(destination,dst)
  w(stack,end);w(stack+4,source_pixels);w(stack+8,destination);w(stack+12,1);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(entry,end,count=100)
  assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==stack+16
  expected=bytes([max(a,b),0x13,0x27,0x81]) if entry==0x8c05a0 else bytes([min(255-a,b),0x13,a,0x81])
  actual=bytes(u.mem_read(destination,4));assert actual==expected
  masks.append({'entry':hex(entry),'source':list(src),'destination_before':list(dst),'destination_after':list(actual)})
 for count in [0,2,17]:
  src=bytes((i*37+19)&255 for i in range(68));dst=bytes((i*61+17)&255 for i in range(68));u.mem_write(source_pixels,src);u.mem_write(destination,dst)
  w(stack,end);w(stack+4,source_pixels);w(stack+8,destination);w(stack+12,count);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(entry,end,count=1000)
  expected=bytearray(dst)
  for i in range(count):
   k=i*4;expected[k]=max(src[k],dst[k]) if entry==0x8c05a0 else min(255-src[k],dst[k])
   if entry==0x8c05f0:expected[k+2]=src[k]
  actual=bytes(u.mem_read(destination,68));assert actual==expected
  masks.append({'entry':hex(entry),'pixel_count':count,'source':list(src),'destination_before':list(dst),'destination_after':list(actual)})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'route_entry':'0x8c0510','copy_entry':'0x8c2140','mask_entries':['0x8c05a0','0x8c05f0'],'route_cases':len(routed),'mask_cases':len(masks),'native_addresses':len(visited),'routed':routed,'masks':masks,'limits':['Original row traversal and original glyph bitmap copy execute with supplied successful FT_Load_Glyph(flags4), bitmap metrics and row buffers. Original native font pixels and provider errors remain unqualified.','Mask functions execute directly and change byte0; second also writes source byte0 into byte2. GPU channel interpretation not inferred.','Full page update8C0650, dilation loops, GPU locking/upload, allocation/errors/lifecycle and HUD widgets remain open.']}
(r/'data/4.20/native_font_atlas_pixels_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'route_cases':len(routed),'mask_cases':len(masks),'native_addresses':len(visited),'passed':True}))
