from pathlib import Path
import json,hashlib,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'native glyph prerequisites','exec'))
owner=vector+0x6000;face=vector+0x7000;slot=vector+0x8000;metrics=vector+0x9000;bitmap=vector+0xa000;dest=vector+0xb000;target=vector+0xc000
calls=[]
def signed(v):return v if v<0x80000000 else v-0x100000000
def hook(uc,a,size,user):
 if a==0xc3af80:
  sp=uc.reg_read(UC_X86_REG_ESP);args=[read(sp+4),read(sp+8)];assert args==[face,character]
  calls.append({'function':'character_index','character':character,'index':glyph_index});finish(glyph_index);return
 if a==0xc3b830:
  sp=uc.reg_read(UC_X86_REG_ESP);args=[read(sp+4+i*4) for i in range(3)];assert args==[face,glyph_index,expected_flags]
  calls.append({'function':'load_glyph','index':glyph_index,'flags':args[2]});finish(0);return
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
w(face+0x54,slot);w(face+0x58,metrics)
constructors=[]
for character,glyph_index,(advance,bearing_x,width,bearing_y,height,ascender) in itertools.product([0,32,65,0x00e9,0x0416,0x03a9,0x4e2d,0xac00,0xffff],[0,31],[(703,127,641,705,897,1023),(-65,-1,0,-65,63,-1),(0,0,0,0,0,0)]):
 calls.clear();expected_flags=0;u.mem_write(owner,b'\xa5'*48)
 for offset,value in [(0x28,advance),(0x20,bearing_x),(0x18,width),(0x24,bearing_y),(0x1c,height)]:w(slot+offset,value)
 w(metrics+0x18,ascender);w(stack,end);w(stack+4,face);w(stack+8,character);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner)
 u.emu_start(0x8c2030,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==stack+12
 actual=[signed(read(owner+off)) for off in [4,8,12,16]];expected=[advance>>6,bearing_x>>6,width>>6,(ascender>>6)-(bearing_y>>6)+(height>>6)];assert actual==expected
 assert all(read(owner+off)==0 for off in [20,24,28,32]);assert read(owner+36)==face and read(owner+44)==glyph_index
 assert bytes(u.mem_read(owner+40,2))==character.to_bytes(2,'little')
 constructors.append({'character_utf16':character,'glyph_index':glyph_index,'supplied_metrics_26_6':[advance,bearing_x,width,bearing_y,height,ascender],'output_pixels':actual,'calls':list(calls)})
copies=[];character=65;glyph_index=31;expected_flags=4
for rows,width,direction,(ascender,bearing_y) in itertools.product([0,1,3],[0,1,3],[1,-1],[(12*64,9*64),(6*64,9*64)]):
 calls.clear();pitch=(width+2)*direction;source=bitmap+(rows-1)*(width+2) if direction<0 and rows else bitmap
 u.mem_write(bitmap,b'\0'*128);pixels=[]
 for row in range(rows):
  values=bytes((row*61+col*37+19)&255 for col in range(width));u.mem_write(source+row*pitch,values);pixels.append(list(values))
 w(owner+36,face);w(owner+44,glyph_index)
 for offset,value in [(0x4c,rows),(0x50,width),(0x54,pitch),(0x58,source),(0x24,bearing_y)]:w(slot+offset,value)
 w(metrics+0x18,ascender);w(dest,target);w(dest+12,16);u.mem_write(target,b'\xa5'*1024)
 w(stack,end);w(stack+4,dest);w(stack+8,2);w(stack+12,1);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner)
 u.emu_start(0x8c2140,end,count=5000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==stack+16
 expected=bytearray(b'\xa5'*1024);top=max(0,(ascender>>6)-(bearing_y>>6))+1
 for row,values in enumerate(pixels):
  for col,value in enumerate(values):
   start=((top+row)*16+2+col)*4;expected[start:start+4]=bytes([value])*4
 assert bytes(u.mem_read(target,1024))==expected
 copies.append({'rows':rows,'width':width,'pitch':pitch,'ascender_26_6':ascender,'bearing_y_26_6':bearing_y,'destination_stride_pixels':16,'x':2,'y':1,'source_pixels':pixels,'destination_rgba_hex':expected.hex(),'calls':list(calls)})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'constructor_entry':'0x8c2030','copy_entry':'0x8c2140','constructor_case_count':len(constructors),'copy_case_count':len(copies),'native_addresses':len(visited),'constructors':constructors,'copies':copies,'limits':['Original constructor and bitmap copy execute; glyph-index and FT_Load_Glyph providers explicitly supplied with successful return codes. Native FreeType hinting/compiler configuration and actual original bitmaps not qualified.','Constructor loads flags0 and signed-shifts26.6 metrics. Bitmap copy loads flags4, copies each coverage byte into all four RGBA channels, uses signed bitmap pitch and clamps vertical bearing offset to zero.','This does not qualify cache allocation, other bitmap paths, errors, GPU atlas composition, drawing, text layout or complete HUD.']}
(r/'data/4.20/native_glyph_loading_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'constructor_cases':len(constructors),'copy_cases':len(copies),'native_addresses':len(visited)}))
