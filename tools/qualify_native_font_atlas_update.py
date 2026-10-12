from pathlib import Path
import json,hashlib,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_hud_formatted_scanner.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'atlas update prerequisites','exec'))
u.mem_map(0x40040000,0x100000)
atlas=vector+0x6000;texture=vector+0x6100;device=vector+0x6300;vtable=vector+0x6500;rows=vector+0x6800;row_list=vector+0x6900;node=vector+0x6a00;glyph=vector+0x6b00;face=vector+0x7000;slot=vector+0x7100;metrics=vector+0x7200;bitmap=vector+0x7300;tls=vector+0x7400;tls_value=vector+0x7500;scratch=0x40040000;destination=0x40080000
events=[]
def hook(uc,a,size,user):
 if a==vector+0x5000:
  sp=uc.reg_read(UC_X86_REG_ESP);assert read(sp+4)==0;result=read(sp+8);w(result,page_size*4);w(result+4,destination);finish(0,16);events.append('lock');return
 if a==vector+0x5010:events.append('unlock');finish(0,4);return
 if a==0x5e5a10:
  sp=uc.reg_read(UC_X86_REG_ESP);count=read(sp+4);assert count==page_size*page_size;owner=uc.reg_read(UC_X86_REG_ECX);w(owner,scratch);w(owner+4,scratch+count*4);w(owner+8,scratch+count*4);finish(0,4);return
 if a==0xca1d00:
  sp=uc.reg_read(UC_X86_REG_ESP);dest,value,count=[read(sp+4+i*4) for i in range(3)];u.mem_write(dest,bytes([value&255])*count);finish(dest);return
 if a==0xc98528:finish(0);return
 if a==0xc3b830:
  sp=uc.reg_read(UC_X86_REG_ESP);assert [read(sp+4+i*4) for i in range(3)]==[face,3,4];events.append('glyph');finish(0);return
 scanner_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
w(0x2c,tls);w(tls,tls_value);w(tls_value+4,1);w(texture+0x90,device);w(device,vtable);w(vtable+0x24,vector+0x5000);w(vtable+0x28,vector+0x5010)
w(face+0x54,slot);w(face+0x58,metrics);w(slot+0x4c,2);w(slot+0x50,3);w(slot+0x54,3);w(slot+0x58,bitmap);w(slot+0x24,9*64);w(metrics+0x18,12*64);u.mem_write(bitmap,bytes([1,64,128,192,254,255]))
w(atlas+8,texture);w(atlas+0x14,rows);w(atlas+0x18,rows+12);w(rows,row_list);w(rows+4,row_list+4);w(row_list,node);w(node+0x18,3);w(node+0x1c,2);w(node+0x30,glyph);w(glyph,0x10ca2c0);w(glyph+0x24,face);w(glyph+0x2c,3)
cases=[]
for page_size,extra,shadow in list(itertools.product([32],[0,1,2],[False,True]))+list(itertools.product([256],[0,1],[False,True])):
 events.clear();calls.clear();w(atlas,extra);w(atlas+4,page_size);u.mem_write(atlas+0x10,bytes([int(shadow),0]));length=page_size*page_size*4;u.mem_write(destination,b'\xa5'*length)
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,atlas)
 try:u.emu_start(0x8c0650,end,count=30000000)
 except Exception:
  print({'eip':hex(u.reg_read(UC_X86_REG_EIP)),'esp':hex(u.reg_read(UC_X86_REG_ESP)),'events':events,'calls':calls[-15:]});raise
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==stack+4 and u.reg_read(UC_X86_REG_EAX)==0
 expected=bytearray(bytes([0,0,0,255])*(page_size*page_size));base=extra+(8 if shadow else 0)
 def raster(x,y):
  temp=bytearray(length)
  for dy in range(2):
   for dx in range(3):
    start=((2+y+3+dy)*page_size+3+x+dx)*4;temp[start:start+4]=bytes([1,64,128,192,254,255][dy*3+dx:dy*3+dx+1])*4
  return temp
 for radius in range(1,extra+1):
  for dx in [-1,0,1]:
   for dy in [-1,0,1]:
    if dx==dy==0:continue
    src=raster(base+radius*dy,base+radius*dx)
    for k in range(0,length,4):expected[k]=max(expected[k],src[k])
 src=raster(base,base)
 for k in range(0,length,4):expected[k]=min(255-src[k],expected[k]);expected[k+2]=src[k]
 actual=bytes(u.mem_read(destination,length));assert actual==expected,(page_size,extra,shadow)
 assert events[0]=='lock' and events[-1]=='unlock' and events.count('glyph')==extra*8+1
 changes=[[k//4,list(actual[k:k+4])] for k in range(0,length,4) if actual[k:k+4]!=bytes([0,0,0,255])]
 cases.append({'page_size':page_size,'extra':extra,'shadow':shadow,'glyph_calls':events.count('glyph'),'changed_pixels':changes,'destination_sha256':hashlib.sha256(actual).hexdigest()})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'entry':'0x8c0650','native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(cases),'native_addresses':len(visited),'cases':cases,'limits':['Whole update executes original row traversal, bitmap copy and mask operations. GPU lock/unlock, scratch-vector allocation, memset/free and successful FT provider explicitly adapted; actual GPU format/upload/errors and original glyph pixels unqualified.','32pixel contexts are explicit worker inputs; native page creation still256/512. Four256pixel contexts additionally executed.','Shadow flag adds8pixel offset; no native blur behavior inferred. Secondary texture flagfalse only; secondary-copy path and lifetime/dirty caller remain open.']}
(r/'data/4.20/native_font_atlas_update_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'passed':True}))
