from pathlib import Path
import sys,struct,json,hashlib,datetime,itertools
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn
from unicorn.x86_const import *
r=Path('E:/OpenLeague');p=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe')
raw=p.read_bytes();pe=pefile.PE(data=raw);m=pe.get_memory_mapped_image();b=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(b,(len(m)+4095)&~4095);u.mem_write(b,m)
a=0x40000000;u.mem_map(a,0x40000);device=a;vt=a+0x1000;callback=a+0x2000;manager=a+0x4000;stack=a+0x30000;end=a+0x3f000;visited=set();calls=[]
w=lambda addr,v:u.mem_write(addr,struct.pack('<I',v&0xffffffff));read=lambda addr:struct.unpack('<I',u.mem_read(addr,4))[0]
def finish(pop=0):
 sp=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EIP,read(sp));u.reg_write(UC_X86_REG_ESP,sp+4+pop)
def hook(uc,addr,size,user):
 if addr==callback:
  sp=u.reg_read(UC_X86_REG_ESP);receiver,state,value=struct.unpack('<3I',u.mem_read(sp+4,12));assert receiver==device;calls.append([state,value]);finish(12);return
 if addr==0xc975f5:finish();return
 assert 0x9abc90<=addr<0x9ac340 or 0x9ac600<=addr<0x9ac820 or 0x9836a0<=addr<0x9838fe or 0x95c110<=addr<0x95c168,hex(addr);visited.add(addr)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(device,vt);w(vt+0xe4,callback);w(0x2d794b0,device);w(0x2d79078,manager);u.mem_write(0x14be79f,b'\0');w(0x14bef88,0)
table=list(struct.unpack('<2I',u.mem_read(0x10e2dcc,8)));assert table==[2,3]
enable_cases=[]
for mode,initial,request,suppressed in itertools.product([0,1],[False,True],[False,True],[False,True]):
 w(0x123ff20,0x10000000 if initial else 0);w(0x123ff5c,mode);u.mem_write(0x2d79470,bytes([suppressed]));w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,0x10000000);calls=[];u.emu_start(0x9abc90 if request else 0x9abee0,end,count=500)
 expected=[[22,table[mode] if request else 1]] if initial!=request and not suppressed else [];assert calls==expected,(mode,initial,request,suppressed,calls)
 assert bool(read(0x123ff20)&0x10000000)==request
 enable_cases.append({'mode':mode,'initial_enabled':initial,'requested_enabled':request,'suppressed':suppressed,'device_calls':calls.copy()})
setter_cases=[]
for initial_mode,requested,enabled,suppressed in itertools.product([0,1],[0,1],[False,True],[False,True]):
 w(0x123ff20,0x10000000 if enabled else 0);w(0x123ff5c,initial_mode);u.mem_write(0x2d79470,bytes([suppressed]));w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,requested);calls=[];u.emu_start(0x9ac7c0,end,count=500)
 expected=[[22,table[requested]]] if not suppressed and enabled and initial_mode!=requested else [];assert calls==expected;assert read(0x123ff5c)==requested
 setter_cases.append({'initial_mode':initial_mode,'requested_mode':requested,'enabled':enabled,'suppressed':suppressed,'device_calls':calls.copy()})
pass_cases=[]
for selector,initial,mode,suppressed in itertools.product([3,4],range(16),[0,1],[False,True]):
 depth=bool(initial&1);write=bool(initial&2);blend=bool(initial&4);cull=bool(initial&8)
 w(0x123ff20,(0x1000000 if depth else 0)|(0x8000000 if blend else 0)|(0x10000000 if cull else 0));w(0x123ff60,0x10000000 if write else 0);w(0x123ff5c,mode);u.mem_write(0x2d79470,bytes([suppressed]));w(manager+0x2b8,0);w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EDI,selector);calls=[];u.emu_start(0x95c110,0x95c168,count=2000)
 expected=[]
 if not suppressed:
  if not depth:expected.append([7,1])
  if not write:expected.append([14,1])
  if blend:expected.append([27,0])
  if not cull or mode!=1:expected.append([22,3])
 assert calls==expected,(selector,initial,mode,suppressed,calls,expected)
 assert read(0x123ff20)&0x10000000 and read(0x123ff5c)==1
 pass_cases.append({'selector':selector,'initial_bits':initial,'initial_mode':mode,'suppressed':suppressed,'device_calls':calls.copy(),'main_state':read(0x123ff20),'secondary_state':read(0x123ff60)})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'native_addresses':len(visited),'enable_cases':enable_cases,'setter_cases':setter_cases,'pass_cases':pass_cases,'culling_table':table,'findings':['Main-state bit10000000is CULLENABLE, not stencil; enable/disable9ABC90/9ABEE0submit D3Dstate22with cached culling value orNONE1.','9AC7C0selects cached mode0/1mapping toD3Dvalues2/3and only submits when culling enabled and cache changes.','Actual grass selector3/4prefix95C110..95C168sets depth on, depthwrite on, blend off, cullingmode1enabled (state22value3). No stencil state submitted in this prefix.','Secondary-state bit10000000still represents depthwrite in123FF60; state-bank identity must be preserved.'],'runtime_adapters':['Actual native flags/caches/passprefix execute with deviceSetRenderState recording adapter; optional secondary backend disabled.'],'limits':['Passprefix only: later grass material updates, geometry, alpha persistence and complete pass order remain open.','D3Dstate22numeric mapping observed; Vulkan winding/culling adaptation through mirrored map transforms and whole native device initialization remain unqualified.','Earlier reports treated stencil as a possible interpretation; this proof corrects that hypothesis without claiming every whole-scene stencil path absent.']}
(r/'data/4.20/grass_culling_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'enable_cases':len(enable_cases),'setter_cases':len(setter_cases),'pass_cases':len(pass_cases),'native_addresses':len(visited),'passed':True}))
