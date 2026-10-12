from pathlib import Path
import sys,struct,json,hashlib,datetime,itertools
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn
from unicorn.x86_const import *
r=Path('E:/OpenLeague');p=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe');raw=p.read_bytes();pe=pefile.PE(data=raw);memory=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(base,(len(memory)+4095)&~4095);u.mem_write(base,memory);arena=0x40000000;u.mem_map(arena,0x30000);device=arena;vt=arena+0x1000;callback=arena+0x2000;manager=arena+0x4000;context=arena+0x5000;material=arena+0x6000;stack=arena+0x20000;end=arena+0x2f000;calls=[];visited=set()
w=lambda a,v:u.mem_write(a,struct.pack('<I',v&0xffffffff));read=lambda a:struct.unpack('<I',u.mem_read(a,4))[0]
def finish(pop=0):
 sp=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EIP,read(sp));u.reg_write(UC_X86_REG_ESP,sp+4+pop)
def hook(uc,a,size,user):
 if a==end:uc.emu_stop();return
 if a==0xc975f5:finish();return
 if a==callback:
  sp=u.reg_read(UC_X86_REG_ESP);receiver,state,value=struct.unpack('<3I',u.mem_read(sp+4,12));assert receiver==device;calls.append([state,value]);finish(12);return
 assert (0x95ad40<=a<=0x95adbf or 0x95afa9<=a<0x95afb0 or 0x9836a0<=a<0x9838fe or 0x9abc90<=a<0x9ac340 or 0x9ac600<=a<0x9ac7c0),hex(a)
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(device,vt);w(vt+0xe4,callback);w(0x2d794b0,device);w(0x2d79078,manager);u.mem_write(0x2d79470,b'\0');u.mem_write(0x14be79f,b'\0');w(0x14bef88,0)
cases=[]
for selector,kind,flags,quality,initial in itertools.product(range(16),range(5),range(16),[-1,0,1,2],range(16)):
 alpha=bool(initial&1);depth=bool(initial&2);blend=bool(initial&4);write=bool(initial&8)
 initial_state=(0x4000000 if alpha else 0)|(0x1000000 if depth else 0)|(0x8000000 if blend else 0)
 w(0x123ff20,initial_state);w(0x123ff60,0x10000000 if write else 0)
 for address in range(0x123ff48,0x123ff5c,4):w(address,0xffffffff)
 w(manager+0x2b8,0);w(context+0x54,selector);w(material+0x104,kind);w(material+0x108,flags);w(0x12258d8,quality);w(0x2d79074,0xdeadbeef);w(0x1225908,0xdeadbeef)
 w(stack,end);w(stack+4,material);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,context);calls=[];u.emu_start(0x95ad40,0x95adbf,count=2000)
 skipped=selector in [5,6,9,10,14];transparent=kind in [1,2] or bool(flags&4) and quality>0
 if skipped:
  assert u.reg_read(UC_X86_REG_EIP)==end and calls==[] and read(0x123ff20)==initial_state and read(manager+0x2b8)==0
  expected=[];mode=None
 else:
  assert u.reg_read(UC_X86_REG_EIP)==0x95adbf
  mode=0x804 if transparent else 0x40c;expected=[]
  if not depth:expected.append([7,1])
  if write!= (not transparent):expected.append([14,int(not transparent)])
  if blend!=transparent:expected.append([27,int(transparent)])
  if transparent:expected.extend([[19,5],[207,5],[20,6],[208,6],[171,1],[206,1]])
  assert calls==expected,(selector,kind,flags,quality,initial,calls,expected)
  assert read(0x2d79074)==(mode&14) and read(0x1225908)==int(transparent) and read(manager+0x2b8)==1
  assert bool(read(0x123ff20)&0x4000000)==alpha
  assert bool(read(0x123ff20)&0x1000000) and bool(read(0x123ff20)&0x8000000)==transparent
  assert bool(read(0x123ff60)&0x10000000)== (not transparent)
 cases.append({'selector':selector,'material_type':kind,'flags':flags,'quality':quality,'initial_bits':initial,'skipped':skipped,'mode':mode,'calls':calls.copy(),'alpha_enabled_after':alpha,'depth_enabled_after':depth if skipped else True,'depth_write_after':write if skipped else not transparent,'blend_enabled_after':blend if skipped else transparent})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x95ad40','stop':'0x95adbf or skipped return','native_addresses':len(visited),'cases':cases,'findings':['Ordinary material state routing enables depth test; opaque mode40C enables depth write and disables blending, transparent mode804 disables depth write and enables SRCALPHA/INVSRCALPHA for both color and separate alpha with ADD.','Types1/2 always use transparent mode; other types require flag4 and signed quality greater than zero. Selectors5/6/9/10/14 skip this material state prefix.','Native route does not alter incoming alpha-test enable state across the qualified prefix.'],'runtime_adapters':['Original native instructions executed through render mode router and D3D setters; SetRenderState callback records actual calls.','D3D device, explicit cache/state fixtures, manager counters and material/context supplied; original GL and optional secondary987640 backend disabled.'],'limits':['Material function after95ADBF, whole world setup persistence, native quality producer and final original draw order remain open.','This proof covers types0..4, flags0..15, selectors0..15, quality-1/0/1/2 and16initial state combinations; other values unqualified.','Does not prove framebuffer equivalence or implement production blend changes.']}
(r/'data/4.20/material_draw_state_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'passed':True}))
