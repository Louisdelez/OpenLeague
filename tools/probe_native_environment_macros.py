from pathlib import Path
import sys,struct,json,hashlib,itertools,datetime
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn
from unicorn.x86_const import *
r=Path('E:/OpenLeague');p=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe');raw=p.read_bytes();pe=pefile.PE(data=raw);image=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(base,(len(image)+4095)&~4095);u.mem_write(base,image);u.mem_map(0x40000000,0x30000)
w=lambda a,x:u.mem_write(a,struct.pack('<I',x&0xffffffff));read=lambda a:struct.unpack('<I',u.mem_read(a,4))[0]
vector=0x40000000;storage=vector+0x1000;animate=vector+0x2000;cloud=vector+0x3000;vt=vector+0x4000;stack=vector+0x20000;end=vector+0x2f000;visited=set();animate_state=cloud_state=False
def finish(value,args=0):
 sp=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EAX,value);u.reg_write(UC_X86_REG_EIP,read(sp));u.reg_write(UC_X86_REG_ESP,sp+4+args)
def string(a):return bytes(u.mem_read(a,100)).split(b'\0')[0].decode()
def hook(uc,a,size,user):
 if a==0xc9befc:
  sp=u.reg_read(UC_X86_REG_ESP);value=read(sp+4);buffer=read(sp+8);assert value in [0,1];u.mem_write(buffer,str(value).encode()+b'\0');finish(buffer);return
 if a in [vector+0x5000,vector+0x5010]:finish(int(animate_state if a==vector+0x5000 else cloud_state));return
 assert 0x9593c0<=a<0x9595c5 or 0x9696d0<=a<0x9696e9 or 0x77de90<=a<0x77df05,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(animate,vt);w(cloud,vt+0x100);w(vt+0x18,vector+0x5000);w(vt+0x118,vector+0x5010)
cases=[]
for quality,shadow,animate_override,animate_state,cloud_state,colormap,height_blend,options,cached in itertools.product([-1,0,1,2,3],[0,1],[False,True],[False,True],[False,True],[False,True],[False,True],[0,8,16,24],[False,True]):
 w(vector,storage);w(vector+4,storage+16);w(vector+8,storage+1024);w(0x12258f4,shadow);w(0x12258d8,quality);w(0x2d78fc0,7);w(0x12258f0,7 if cached else 6);w(0x2d78fc8,1-shadow if cached else 99)
 for address,value in [(0x2d78fac,animate_override),(0x2d78fa4,colormap),(0x2d78fbc,height_blend)]:u.mem_write(address,bytes([value]))
 w(0x123f5f8,animate);w(0x123f7e0,cloud);w(0x2d78fb0,options);w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,vector);u.emu_start(0x9593c0,end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==end
 actual=[]
 for offset in range(0,read(vector+4)-storage,8):name,value=struct.unpack('<2I',u.mem_read(storage+offset,8));actual.append({'name':string(name),'value':string(value)})
 expected=[]
 def add(name,value='1'):expected.append({'name':name,'value':value})
 if not shadow:add('DISABLE_SHADOWS')
 add('PCF_MODE',str(1-shadow if cached else int(bool(shadow))))
 if animate_override or animate_state:add('ANIMATE_FOW_OVERLAY_UV')
 if (quality<=2 or colormap) and cloud_state:add('DISABLE_CLOUDS')
 if quality<=1:
  add('DISABLE_EMISSIVE');add('VS_LIGHT_INTERPOLATE')
  if not shadow:add('QUALITY_LOW')
 if height_blend:add('USE_HEIGHT_BLEND')
 if colormap:add('MOD2X_COLORMAP')
 if options&8:add('TERRAIN_EDITOR')
 if options&16:add('NOLIGHTING')
 assert actual==expected,(quality,shadow,actual,expected)
 cases.append({'quality':quality,'shadow_setting':shadow,'animate_override':animate_override,'animate_feature':animate_state,'cloud_feature':cloud_state,'colormap':colormap,'height_blend':height_blend,'global_options':options,'cache_hit':cached,'pcf_cached_input':1-shadow if cached else 99,'macros':actual})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x9593c0','vector_clear':'0x9696d0','vector_push':'0x77de90','native_addresses':len(visited),'cases':cases,'case_count':len(cases),'findings':['Native vector clear and macro pair append instructions execute with supplied capacity; ordered name/value pairs match independent branch expression.','MOD2X_COLORMAP follows global2D78FA4; USE_HEIGHT_BLEND follows2D78FBC.','QUALITY_LOW is only appended for quality<=1 with shadows disabled; it is not synonymous with quality<=1 alone.','PCF_MODE uses existing cached value when quality revision matches, otherwise recomputes from nonzero shadow setting.'],'runtime_adapters':['C9BEFC integer-to-text formatting adapted for native observed PCF0/1; feature virtual calls return supplied booleans.','Input quality/options/feature objects and macro-vector capacity supplied; their original configuration producers remain unqualified.'],'limits':['Macro builder/clear/append qualified; actual shader registry/compiler, macro merging with static descriptors and GPU execution remain open.','Map10 configuration producer and original sampler/lighting/shadow/reflection/death shader variants remain open.','Does not prove complete original rendering or gameplay.']}
(r/'data/4.20/environment_shader_macros_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited)}))
