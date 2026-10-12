from pathlib import Path
import json,struct,hashlib,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'native emulator base','exec'))
renderer=0x41000000;u.mem_map(renderer,0x30000)
factory=vector+0x9000;output=vector+0xa000
w(factory,0x10e2e2c);w(renderer+0x10,factory);w(0x2d773c0,0x12345678);w(0x2d78f1c,vector+0xb000)
mode='game';selection=0;events=[];visited=set()
def hook(uc,a,size,user):
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a==0x8b1c20:
  request=dict(section=string(uc.reg_read(UC_X86_REG_ECX)),key=string(uc.reg_read(UC_X86_REG_EDX)),default=read(sp+4),flags=read(sp+8))
  assert request==dict(section='General',key='Antialiasing',default=0,flags=0)
  events.append(dict(kind='config',request=request));finish(selection);return
 if a==0x592670:finish(0);return
 if a==0x9608d0:events.append(dict(kind='game_create',args=[read(sp+4+i*4) for i in range(5)]));finish(1,20);return
 if a==0xca1d00:
  dst,value,size=[read(sp+4+i*4) for i in range(3)];assert value==0 and size==0x34
  u.mem_write(dst,b'\0'*size);finish(dst);return
 if a==0x5fa170:finish(0);return
 if a==0x9c3e30:
  args=[read(sp+4+i*4) for i in range(5)]
  events.append(dict(kind='renderer_create',args=args,descriptor=list(struct.unpack('<13I',u.mem_read(args[3],52)))))
  finish(1,20);return
 ranges={'game':[(0x574dec,0x574e63)],'renderer':[(0x980fec,0x98111c)],'presentation':[(0x9c46b0,0x9c474f)]}
 assert any(lo<=a<hi for lo,hi in ranges[mode]),(mode,hex(a));visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[];bp=stack+0x100
for selection,hal,windowed,vsync,bits in itertools.product([-2147483648,-1,0,1,2,3,2147483647],[0,1],[0,1],[0,1],[16,32]):
 mode='game';events.clear()
 for offset,value in [(-0x44,windowed),(-0x48,vsync),(-0x4c,1280),(-0x50,bits)]:w(bp+offset,value)
 u.reg_write(UC_X86_REG_EBP,bp);u.reg_write(UC_X86_REG_ESP,stack-8);u.reg_write(UC_X86_REG_EAX,hal);u.reg_write(UC_X86_REG_ESI,hal);u.reg_write(UC_X86_REG_EBX,800)
 u.emu_start(0x574dec,0x574e63,count=200)
 call=events[-1];assert call['kind']=='game_create';args=call['args'];flags=args[3]
 assert args[:3]==[1280,800,bits]
 expected=(4 if windowed else 0)|(0 if hal else 0x20)|(0x40 if selection==1 else 0x80 if selection==2 else 0)|(0x100 if vsync else 0)
 assert flags==expected and u.reg_read(UC_X86_REG_ESP)==stack,(selection,hal,windowed,vsync,bits,hex(flags),hex(expected),hex(u.reg_read(UC_X86_REG_ESP)),hex(stack))
 game_events=list(events)
 mode='renderer';events.clear()
 for offset,value in [(0x10,bits),(0x14,flags)]:w(bp+offset,value)
 u.reg_write(UC_X86_REG_EBP,bp);u.reg_write(UC_X86_REG_ESP,stack-32);u.reg_write(UC_X86_REG_EBX,renderer);u.reg_write(UC_X86_REG_ESI,1280);u.reg_write(UC_X86_REG_EDI,800)
 u.emu_start(0x980fec,0x98111c,count=300)
 assert u.reg_read(UC_X86_REG_EIP)==0x98111c and u.reg_read(UC_X86_REG_ESP)==stack
 desc=events[-1]['descriptor'];index=1 if selection==1 else 2 if selection==2 else 0
 assert desc[4:6]==[index,0]
 mode='presentation';w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,renderer+0x34);u.reg_write(UC_X86_REG_EDX,output)
 u.emu_start(0x9c46b0,end,count=100)
 actual_type=read(output+0x10);actual_quality=read(output+0x14)
 assert actual_type==(2 if selection==1 else 4 if selection==2 else 0) and actual_quality==0
 cases.append(dict(config=selection,hal=hal,windowed=windowed,vsync=vsync,color_bits=bits,flags=flags,game_events=game_events,renderer_events=list(events),descriptor=desc,d3d_multisample_type=actual_type,d3d_multisample_quality=actual_quality))
cfg=r/'data/4.20/configuration/defaults/Game.cfg';config_text=cfg.read_text(encoding='utf-8-sig')
assert 'Antialiasing = 0' in config_text
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),option=dict(section='General',key='Antialiasing',default=0),supplied_default_config=dict(path=str(cfg),sha256=hashlib.sha256(cfg.read_bytes()).hexdigest(),value=0),game_segment='0x574dec',renderer_segment='0x980fec',presentation='0x9c46b0',default_d3d_multisample_type=0,default_d3d_multisample_quality=0,cases=cases,limits=['Original launch flag producer, renderer descriptor initialization and presentation conversion executed as three segments. Config returns, window update/logging/memset and creation calls adapted.', 'Original user config text parsing is separately qualified; current supplied default configuration has Antialiasing0. Per-user overrides can select 2x/4x.', 'Real device creation, failure/fallback/reset paths, hardware support and full original gameplay frame still unqualified.'])
(r/'data/4.20/native_multisample_selection_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited),default_msaa=0)))


