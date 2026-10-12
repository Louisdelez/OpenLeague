from pathlib import Path
import json,hashlib,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'native composition prerequisites','exec'))
owner=vector+0x6000;face=vector+0x7000;metrics=vector+0x8000;bitmap=vector+0x9000;target=vector+0xa000
def hook(uc,a,size,user):
 assert 0x8c22c0<=a<=0x8c23e8,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(face+0x58,metrics);w(owner+0x24,face);w(owner+0x14,bitmap)
coverage=[0,1,64,128,254,255];u.mem_write(bitmap,bytes(coverage));w(owner+0x18,3);w(owner+0x1c,2);cases=[]
for x,y,bearing_x,(ascender,bearing_y),channels,fill in itertools.product([-4,-1,0,2,5],[-4,-1,0,2,5],[-2,0,2],[(12*64,9*64),(6*64,9*64)],[0,1,4],[0,85,255]):
 w(owner+8,bearing_x);w(owner+0x20,bearing_y);w(metrics+0x18,ascender);stride=4*channels+3;length=stride*3
 u.mem_write(target,bytes([fill])*length);w(stack,end)
 args=[target,4,3,channels,stride,x,y]
 for i,value in enumerate(args):w(stack+4+i*4,value)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner);u.emu_start(0x8c22c0,end,count=10000)
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==stack+32
 expected=bytearray([fill]*length);top=(ascender>>6)-(bearing_y>>6)+y
 for row in range(2):
  for col in range(3):
   dx=bearing_x+x+col;dy=top+row
   if 0<=dx<4 and 0<=dy<3:
    alpha=coverage[row*3+col]
    for channel in range(channels):
     offset=dy*stride+dx*channels+channel;expected[offset]=min(255,alpha+expected[offset]*(255-alpha)//255)
 actual=bytes(u.mem_read(target,length));assert actual==expected
 cases.append({'x':x,'y':y,'bearing_x_pixels':bearing_x,'ascender_26_6':ascender,'bearing_y_26_6':bearing_y,'channels':channels,'destination_stride_bytes':stride,'fill':fill,'destination_hex':actual.hex()})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x8c22c0','case_count':len(cases),'native_addresses':len(visited),'bitmap_width':3,'bitmap_rows':2,'coverage':coverage,'destination_width':4,'destination_height':3,'cases':cases,'limits':['Original clipped composition executes with supplied preloaded cached bitmap, face ascender, glyph bearing and destination; no font rasterizer, cache allocation or GPU drawing proof.','Horizontal bearing and signed vertical offset retained; channels0/1/4, clipped positions and fills0/85/255 exercised. Exact byte formula coverage + floor(previous*(255-coverage)/255).','Native source parser, text layout/kerning, shadows, atlas packing, color application and original widget drawing remain open.']}
(r/'data/4.20/native_glyph_composite_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'cases':len(cases),'native_addresses':len(visited)}))
