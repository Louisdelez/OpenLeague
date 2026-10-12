from pathlib import Path
import json, struct, hashlib, datetime, itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_hud_formatted_scanner.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0], 'text draw prerequisites','exec'))
font=vector+0x6000;device=vector+0x6100;table=vector+0x6200;rect=vector+0x6300;color=vector+0x6400;narrow=vector+0x6500;wide=vector+0x6600
w(font+0x28,device);w(device,table);w(table+0x10,vector+0x5100);w(0x14bef40,0)
captured=[];adapted=[]
def hook(uc,a,size,user):
 if a==0x99aa80:
  assert uc.reg_read(UC_X86_REG_ECX)==narrow
  dst=uc.reg_read(UC_X86_REG_EDX);text=contents.encode('utf-16le')+b'\0\0'
  w(dst+0x10,len(contents));w(dst+0x14,7 if len(contents)<8 else len(contents))
  if len(contents)<8:u.mem_write(dst,text)
  else:w(dst,wide);u.mem_write(wide,text)
  adapted.append('supplied narrow-to-UTF16 conversion');finish(dst);return
 if a==vector+0x5100:
  assert uc.reg_read(UC_X86_REG_ECX)==device
  sp=uc.reg_read(UC_X86_REG_ESP);args=[read(sp+4+i*4) for i in range(13)]
  assert bytes(u.mem_read(args[3],(len(contents)+1)*2))==contents.encode('utf-16le')+b'\0\0'
  captured.append(args[:3]+args[4:]);finish(0,52);return
 if a==0xc98528:
  assert read(uc.reg_read(UC_X86_REG_ESP)+4)==wide;adapted.append('supplied UTF16 heap release');finish(0);return
 if a==0xc975f5:finish(uc.reg_read(UC_X86_REG_EAX));return
 assert 0x9a5cf0<=a<=0x9a5eb6,hex(a)
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
f32=lambda x:struct.unpack('<f',struct.pack('<f',x))[0]
bits=lambda x:struct.unpack('<I',struct.pack('<f',x))[0]
rects=[[0.,0.,20.,12.],[10.75,7.25,91.5,46.5],[-17.5,-4.5,-1.25,3.5],[1920.25,1080.75,1977.75,1121.25],[16777216.,16777216.,16777218.,16777218.]]
cases=[]
for control,coords,align,flags,packed,contents in itertools.product([0x27f,0x37f],rects,[0,1,2,3,0xffffffff],[0,4,0x14],[0,0xffa1b2c3,0x80402010],['','Gold','12345678']):
 captured.clear();adapted.clear();w(font+0x24,flags);u.mem_write(rect,struct.pack('<4f',*coords));w(color,packed);u.mem_write(narrow,contents.encode()+b'\0')
 w(stack,end)
 for i,value in enumerate([font,align,color,rect,narrow]):w(stack+4+i*4,value)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_FPCW,control);u.emu_start(0x9a5cf0,end,count=1000)
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==stack+24
 assert u.reg_read(UC_X86_REG_FPCW)==control
 x=int(coords[0]) if align==0 else int((coords[0]+coords[2])*0.5) if align==1 else int(coords[2]) if align==2 else 0
 y=int((coords[1]+coords[3])*0.5)
 if flags&4:x-=8;y-=8
 expected=[bits(1),bits((x&0xffffffff)),bits((y&0xffffffff)),packed,0,0,0,align,0,bits(1),bits(1),0]
 assert captured==[expected],(coords,align,flags,captured,expected)
 cases.append(dict(control_word=control,rect=coords,alignment=align,font_flags=flags,color=packed,text=contents,draw_argument_bits=captured[0],adapters=list(adapted)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x9a5cf0',case_count=len(cases),native_addresses=len(visited),argument_order=['opacity','x','y','color','zero0','zero1','zero2','horizontal','vertical','scale_x','scale_y','zero3'],cases=cases,findings=['Original complete HUD text draw wrapper executes with original x87 instructions and cleanup.','Left/center/right use truncated left/midpoint/right; unsupported alignment leaves x=0. Y is truncated vertical midpoint.','Shadow flag4 subtracts8 from both signed anchors before unsigned-u32-to-f32 conversion.','Device receives opacity1, source color, horizontal source alignment, vertical0, scales1 and zero auxiliary arguments.'],limits=['Prepared font/device, pixel rectangle, text and color supplied. HUD batch transforms/group producers not executed here.','Narrow-to-UTF16 conversion, device virtual draw, heap release and cookie verification are adapted boundaries; not a native localization/allocation/GPU proof.','Finite selected coordinates tested. Overflow/nonfinite conversion behavior and original framebuffer projection remain unqualified.','Does not prove complete HUD widgets, interactions or game.'])
(r/'data/4.20/native_hud_text_draw_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited))))
