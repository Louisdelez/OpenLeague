from pathlib import Path
import json,struct,hashlib,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'text batch prerequisites','exec'))
renderer=vector+0xb000;packet=vector+0xb100;elements=vector+0xc000;packets=vector+0xc100;records=vector+0x10000;fonts=vector+0x14000;actors=[vector+0x6000+i*0x400 for i in range(4)]
w(renderer+0xc,vector+0xd000);w(renderer+0x4c,elements);w(renderer+0x58,packets)
captured=[]
def hook(uc,a,size,user):
 if a==0x9aa1a0:
  assert uc.reg_read(UC_X86_REG_ECX)==packet+0x1c
  n=read(uc.reg_read(UC_X86_REG_ESP)+4);w(packet+0x1c,records);w(packet+0x20,records+n*0x120);w(packet+0x24,records+4*0x120);finish(0,4);return
 if a==0x9a4b30:
  assert uc.reg_read(UC_X86_REG_ECX)==vector+0xd000
  sp=uc.reg_read(UC_X86_REG_ESP);element,dst,motion=[read(sp+4+i*4) for i in range(3)];assert element in actors and motion==0
  u.mem_write(dst,bytes(u.mem_read(element+0x1c0,16)));finish(dst,12);return
 if a==0xc9b780:finish(vector+0x15000);return
 if a==0xc9de72:finish(0);return
 assert 0x9a81b0<=a<=0x9a8443 or 0xc9f8b6<=a<=0xc9f925,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
patterns=[p for n in range(5) for p in itertools.product([0,1,0x81],repeat=n)]
for flags,textbytes,index in itertools.product(patterns,[b'',b'Gold',b'A'*255,b'B'*256,b'X\0hidden'],[0,1]):
 w(packets+index*4,packet);w(packet+0xc,0);w(packet+0x10,len(flags));w(packet+0x28,fonts);w(packet+0x2c,fonts+8);w(packet+0x30,fonts+32)
 u.mem_write(records,b'\0'*(4*0x120));u.mem_write(fonts,b'\0'*32);u.mem_write(renderer+0x70,struct.pack('<4f',1.,1.,0.,0.))
 inputs=[];expected=[];expected_fonts=[];bounds=[1.,1.,0.,0.]
 for i,flag in enumerate(flags):
  a=actors[i];w(elements+i*4,a);u.mem_write(a,b'\0'*0x400);w(a+0x48,flag);w(a+0x200,[0,7,7,9][i]);w(a+0x208,i%3);w(a+0x1dc,0xff000000+i)
  rect=[-0.125+i*0.25,0.125*i,0.25+i*0.25,0.125*(i+1)];u.mem_write(a+0x1c0,struct.pack('<4f',*rect));u.mem_write(a+0x20c,textbytes+b'\0')
  inputs.append(dict(flags=flag,font=[0,7,7,9][i],alignment=i%3,color=0xff000000+i,rect=rect,text_hex=textbytes.hex()))
  bounds=[min(bounds[0],rect[0]),min(bounds[1],rect[1]),max(bounds[2],rect[2]),max(bounds[3],rect[3])]
  if flag&1:
   font=[0,7,7,9][i];payload=bytearray(0x120);struct.pack_into('<3I4f',payload,0,font,i%3,0xff000000+i,*rect);content=textbytes.split(b'\0')[0];stored=content[:256];payload[0x1c:0x1c+len(stored)]=stored
   if len(content)>=256:payload[0x1c]=0
   payload[0x11c]=int(bool(flag&0x80));expected.append(payload.hex())
   if font not in expected_fonts:expected_fonts.append(font)
 w(stack,end);w(stack+4,index);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,renderer);u.emu_start(0x9a81b0,end,count=20000)
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==stack+8
 n=(read(packet+0x20)-records)//0x120;actual=[bytes(u.mem_read(records+i*0x120,0x120)).hex() for i in range(n)];actual_fonts=[read(p) for p in range(fonts,read(packet+0x2c),4)]
 assert actual==expected and actual_fonts==expected_fonts,(flags,index,actual_fonts,expected_fonts)
 assert bytes(u.mem_read(renderer+0x70,16))==struct.pack('<4f',*bounds)
 assert all(read(actors[i]+0x4c)==index for i in range(len(flags)))
 cases.append(dict(inputs=inputs,batch_index=index,record_hex=actual,font_handles=actual_fonts,bounds=bounds))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x9a81b0',case_count=len(cases),native_addresses=len(visited),record_stride=288,cases=cases,findings=['Complete original text batch builder executes and active record bytes match supplied independent model.','All elements transform and update renderer bounds before enabled-bit1 check; disabled elements do not consume an output record.','Record fields: font0, alignment4, color8, rect12, text28 through native strcpy_s256; overflow writes byte0=NUL after copying256bytes, fixed-scale byte284. Font handles are deduplicated in first active use order, including zero.','Element+4C receives batch index even when disabled. Native vector is finally resized to enabled count.'],limits=['Vector resize with reserved capacity, rectangle transform9A4B30 are adapted boundaries; CRT string length/copy execute natively with adapted errno/returning invalid-parameter handler. Their allocator/failure behavior and full original layout initialization not proven.','Output backing bytes start zero; padding/stale-capacity initialization remains allocator responsibility.','Finite supplied rectangles, native flag patterns, lengths0/4/255/256/embeddedNUL and up to4elements tested. Ordinary HUD rendering, widget lifetime, localization and original font flush remain open.'])
(r/'data/4.20/native_hud_text_batch_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited))))
