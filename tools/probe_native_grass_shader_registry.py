from pathlib import Path
import sys,struct,json,hashlib,datetime,itertools
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn
from unicorn.x86_const import *
r=Path('E:/OpenLeague');p=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe');raw=p.read_bytes();pe=pefile.PE(data=raw);memory=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(base,(len(memory)+4095)&~4095);u.mem_write(base,memory);arena=0x40000000;u.mem_map(arena,0x30000);context=arena;manager=arena+0x1000;driver=arena+0x2000;vt=arena+0x3000;callback=arena+0x4000;stack=arena+0x20000;end=arena+0x2f000;visited=set();names={};requests=[];bindings=[]
w=lambda a,v:u.mem_write(a,struct.pack('<I',v&0xffffffff));read=lambda a:struct.unpack('<I',u.mem_read(a,4))[0]
def finish(pop=0,result=0):
 sp=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EIP,read(sp));u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EAX,result)
def hook(uc,a,size,user):
 if a==0x9805c0:
  pointer=read(u.reg_read(UC_X86_REG_ESP)+4);name=bytes(u.mem_read(pointer,180)).split(b'\0')[0].decode();requests.append(name);handle=len(names)+1;names[handle]=name;w(manager+0x102e0+handle*128,arena+0x5000+handle*4);finish(4,handle);return
 if a==callback:bindings.append({'stage':'vertex','shader_object':read(u.reg_read(UC_X86_REG_ESP)+4)});finish(4);return
 if a==0x95a570:handle=read(u.reg_read(UC_X86_REG_ESP)+4);bindings.append({'stage':'pixel','handle':handle,'name':names[handle]});finish(4);return
 if a==0x95cc10:finish();return
 assert 0x95c168<=a<0x95c365,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(0x2d79078,manager);w(manager+0x14,driver);w(driver,vt);w(vt+0x84,callback);cases=[]
for selector in range(15):
 names.clear();requests.clear();bindings.clear();w(stack+0x30,selector);u.mem_write(context+0x70,b'\0');u.reg_write(UC_X86_REG_EBX,context);u.reg_write(UC_X86_REG_ESI,0);u.reg_write(UC_X86_REG_EDI,selector);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0x95c168,0x95c35b,count=3000);assert u.reg_read(UC_X86_REG_EIP)==0x95c35b;handle=read(manager+0x202dc);vertex=names[handle];pixel=bindings[-1]['name'];assert len(requests)==30
 warm=[]
 for repeat in range(3):
  requests.clear();bindings.clear();u.reg_write(UC_X86_REG_EDI,selector);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EBX,context);u.emu_start(0x95c168,0x95c35b,count=3000);assert requests==[] and names[read(manager+0x202dc)]==vertex and bindings[-1]['name']==pixel;warm.append({'vertex':vertex,'pixel':pixel})
 cases.append({'selector':selector,'vertex':vertex,'pixel':pixel,'cold_lookup_count':30,'warm_repeats':warm})
for c in cases:
 if c['selector']==3:assert c['vertex']=='Environment_WALL_OF_GRASS_VS' and c['pixel']=='Environment_WALL_OF_GRASS_PS'
 if c['selector']==4:assert c['vertex']=='Environment_ZPASS_VS' and c['pixel']=='Environment_ZPASS_PS'
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x95c168','stop':'0x95c35b before color-write branch','native_addresses':len(visited),'cases':cases,'native_executions':60,'findings':['Native world-pass shader table maps selector3 to Environment_WALL_OF_GRASS VS/PS and selector4 to Environment_ZPASS VS/PS; dynamic material selector is not their shader producer.','Original bootstrap performs30lookups for15VS/PS pairs once per context, then warmed contexts reuse both shader handle tables.','World caller73C900 invokes selector4 before selector3; selector4 clears color-write mask at95C365. WALL_OF_GRASS shader uses screen-space projected RGBA mask sampler3 and multiplies all four output channels.'],'runtime_adapters':['Actual table construction/indexing executes; shader lookup supplies unique handles, driver vertex bind and pixel-consumer record handles; renderer memory/cache supplied.','Selector0 common constant upload95CC10 adapted; compiler, native shader consumers/device execution excluded.'],'limits':['Grass texture generation, stencil operations, full pass state/scheduling, fog/quality variants and native pixels remain open.','No claim that current generic grass material matches native wall-of-grass rendering.']}
(r/'data/4.20/grass_shader_registry_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'executions':60,'native_addresses':len(visited),'grass_pairs':[(c['selector'],c['vertex'],c['pixel']) for c in cases if c['selector'] in [3,4]],'passed':True}))
