from pathlib import Path
import sys,struct,json,hashlib,datetime
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn
from unicorn.x86_const import *
r=Path('E:/OpenLeague');p=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe');raw=p.read_bytes();pe=pefile.PE(data=raw);image=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(base,(len(image)+4095)&~4095);u.mem_write(base,image);u.mem_map(0,4096);u.mem_map(0x40000000,0x30000)
w=lambda a,x:u.mem_write(a,struct.pack('<I',x&0xffffffff));read=lambda a:struct.unpack('<I',u.mem_read(a,4))[0]
context=0x40000000;world=context+0x1000;stack=context+0x20000;visited=set();wrapper_arguments=[];internal_arguments=[]
def hook(uc,a,size,user):
 if a==0xc9f39b:
  sp=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EAX,0);u.reg_write(UC_X86_REG_EIP,read(sp));u.reg_write(UC_X86_REG_ESP,sp+4);return
 assert 0x73cb2c<=a<0x73cb5b or 0x95bef0<=a<0x95bfe5 or 0x95bff0<=a<0x95c0eb,hex(a);visited.add(a)
 if a==0x95bef0:
  sp=u.reg_read(UC_X86_REG_ESP);wrapper_arguments.extend(read(sp+4+4*i) for i in range(10))
 if a==0x95bff0:
  sp=u.reg_read(UC_X86_REG_ESP);internal_arguments.extend(read(sp+4+4*i) for i in range(8))
u.hook_add(unicorn.UC_HOOK_CODE,hook)
w(world,context);w(0x2d78f48,world);w(0x2d78c2c,context+0x8000);w(0x2d78c30,context+0x9000);w(0x2d791a8,context+0xa000);w(0x2d90f2c,1);u.mem_write(0x2d90fed,b'\0');w(0x2d78fb8,0);u.mem_write(0x2d77b20,b'\1');w(0x14bef58,0)
cases=[]
for caller in [True,False]:
 for selector in ([0] if caller else range(10)):
  wrapper_arguments.clear();internal_arguments.clear();w(context+0x54,0xfeed);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,context)
  if not caller:
   w(stack,context+0x2f000)
   for i,x in enumerate([1,2,3,selector,5,6,7,8,9,10]):w(stack+4+4*i,x)
  u.emu_start(0x73cb2c if caller else 0x95bef0,0x95c0eb,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x95c0eb;assert read(context+0x54)==selector
  assert internal_arguments[2]==wrapper_arguments[3]==selector
  cases.append({'native_world_callsite':caller,'wrapper_arguments':wrapper_arguments.copy(),'internal_arguments':internal_arguments.copy(),'stored_selector':read(context+0x54),'stored_shader_state':read(context+0x58)})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'native_callsite':'0x73cb56','wrapper':'0x95bef0','internal_draw':'0x95bff0','field_store':'0x95c0d8','native_addresses':len(visited),'cases':cases,'findings':['Actual native callsite73CB56 passes selector0 through wrapper argument4, internal argument3, and field0x54 consumed by95A730.','Native wrapper remaps10arguments to8; selector values0..9 preserved through the actual instructions.'],'runtime_adapters':['Startup registry readiness, cached render-disable=false and ordinary renderer path supplied; alternate baked renderer path excluded.','Allocator C9F39B returnsnull to exercise original null allocation branch; no shader state array constructed.','Stops after selector store, before geometry submission/device state/frame rendering.'],'limits':['Original caller branch executes from73CB2C after upstream service validity checks; complete world render loop and frame pass order remain unqualified.','Selector0 native callsite transport is qualified; naming every pass and special baked renderer/global options producer remains open.','No GPU pixel or complete material variant qualification implied.']}
(r/'data/4.20/environment_pass_transport_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'native_world_selector':cases[0]['stored_selector']}))
