from pathlib import Path
import sys,struct,json,hashlib,datetime,itertools
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn
from unicorn.x86_const import *
r=Path('E:/OpenLeague');exe=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe');raw=exe.read_bytes();pe=pefile.PE(data=raw);memory=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(base,(len(memory)+4095)&~4095);u.mem_write(base,memory);u.mem_map(0,4096);u.mem_map(0x40000000,0x40000)
arena=0x40000000;stack=arena+0x30000;float_stub=arena+0x1000;float_cell=arena+0x2000;filename=arena+0x3000;u.mem_write(filename,b'Levels/Map10/terrain.ini\0');u.mem_write(float_stub,b'\xd9\x05'+struct.pack('<I',float_cell)+b'\xc3')
w=lambda a,v:u.mem_write(a,struct.pack('<I',v&0xffffffff));read=lambda a:struct.unpack('<I',u.mem_read(a,4))[0]
def text(a):return bytes(u.mem_read(a,100)).split(b'\0')[0].decode('ascii')
def finish(value):
 sp=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EAX,value&0xffffffff);u.reg_write(UC_X86_REG_EIP,read(sp));u.reg_write(UC_X86_REG_ESP,sp+4)
def state():
 return {'renderer':read(0x2d78fb8),'height_blend':bool(u.mem_read(0x2d78fbc,1)[0]),'scale_bits':[read(a) for a in [0x12258e0,0x12258e4,0x12258e8,0x12258ec]],'colormap':bool(u.mem_read(0x2d78fa4,1)[0]),'colormap_revision':read(0x2d78fa8),'shadow_dynamic_only':bool(u.mem_read(0x2d78fc5,1)[0]),'shadow_revision':read(0x2d78fc0),'alpha_bits':read(0x12258d4)}
def write_state(s):
 for a,key in [(0x2d78fb8,'renderer'),(0x2d78fa8,'colormap_revision'),(0x2d78fc0,'shadow_revision'),(0x12258d4,'alpha_bits')]:w(a,s[key])
 for a,key in [(0x2d78fbc,'height_blend'),(0x2d78fa4,'colormap'),(0x2d78fc5,'shadow_dynamic_only')]:u.mem_write(a,bytes([s[key]]))
 for a,b in zip([0x12258e0,0x12258e4,0x12258e8,0x12258ec],s['scale_bits']):w(a,b)
initial=state();alpha_unit_bits=read(0x1138a30);alpha_unit=struct.unpack('<f',struct.pack('<I',alpha_unit_bits))[0];visited=set();requests=[];props={}
def hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0x8b0630:
  section=text(u.reg_read(UC_X86_REG_ECX));key=text(u.reg_read(UC_X86_REG_EDX));default,dest,length,path,flag=struct.unpack('<5I',u.mem_read(sp+4,20));assert (section,key,text(path),flag)==('Environment','Renderer','Levels/Map10/terrain.ini',0)
  value=props.get(section+'/'+key,text(default));data=value.encode()+b'\0';assert len(data)<length;u.mem_write(dest,data);requests.append({'kind':'text','property':section+'/'+key,'default':text(default),'flag':flag});finish(1);return
 if a==0xc9cf31:
  left,right=struct.unpack('<2I',u.mem_read(sp+4,8));finish(0 if text(left)==text(right) else 1);return
 if a in [0x8b1a80,0x8b1f50]:
  path,section,key,default,flag=struct.unpack('<5I',u.mem_read(sp+4,20));assert text(path)=='Levels/Map10/terrain.ini' and flag==1;property=text(section)+'/'+text(key);requests.append({'kind':'integer' if a==0x8b1a80 else 'float','property':property,'default_bits':default,'flag':flag})
  if a==0x8b1a80:finish(int(props.get(property,default)));return
  value=float(props.get(property,struct.unpack('<f',struct.pack('<I',default))[0]));u.mem_write(float_cell,struct.pack('<f',value));u.reg_write(UC_X86_REG_EIP,float_stub);return
 if float_stub<=a<float_stub+7:return
 assert 0x958e90<=a<0x95907b,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def execute(properties,before):
 global props,requests
 props=properties;requests=[];write_state(before);w(0,0);w(stack,arena+0x3f000);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,filename);u.reg_write(UC_X86_REG_EDX,0);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x37f);u.emu_start(0x958e90,0x95907b,count=2000);assert u.reg_read(UC_X86_REG_EIP)==0x95907b
 result=state();expected=dict(before);renderer=properties.get('Environment/Renderer','legacy')
 if renderer=='baked':expected['renderer']=2
 if renderer=='legacy':
  expected['renderer']=1;expected['height_blend']=bool(properties.get('HeightBlending/enable',0));expected['scale_bits']=[struct.unpack('<I',struct.pack('<f',float(properties.get('HeightBlending/layer'+str(i)+'_scale',1.))))[0] for i in range(4)]
  color=bool(properties.get('ColorMap/enable',0));shadow=properties.get('Environment/ShadowDynamicOnly',0)==1
  expected['colormap_revision']=(before['colormap_revision']+int(color!=before['colormap']))&0xffffffff;expected['shadow_revision']=(before['shadow_revision']+int(shadow!=before['shadow_dynamic_only']))&0xffffffff;expected['colormap']=color;expected['shadow_dynamic_only']=shadow
 alpha=max(0,min(255,properties.get('AlphaTest/cut_off',1)));expected['alpha_bits']=struct.unpack('<I',struct.pack('<f',float(alpha)*alpha_unit))[0];assert result==expected,(properties,result,expected)
 return {'properties':properties,'initial':before,'result':result,'requests':requests}
decoded=json.loads((r/'data/4.20/native_map10_inibin_loader_contract.json').read_text())['native_decoded']
def key(section,name):
 h=0
 for c in (section+'*'+name).lower().encode():h=(h*65599+c)&0xffffffff
 return str(h)
native={}
for section,name in [('Environment','Renderer'),('HeightBlending','enable'),('ColorMap','enable'),('Environment','ShadowDynamicOnly'),('AlphaTest','cut_off')]+[('HeightBlending','layer'+str(i)+'_scale') for i in range(4)]:
 k=key(section,name)
 if k in decoded:native[section+'/'+name]=decoded[k]
cases=[execute(native,initial)]
for renderer,height,color,shadow,alpha,oldcolor,oldshadow in itertools.product([None,'legacy','baked','unknown','LEGACY'],[-1,0,1,2],[0,1],[0,1,2],[-5,0,1,128,255,300],[False,True],[False,True]):
 props={'HeightBlending/enable':height,'ColorMap/enable':color,'Environment/ShadowDynamicOnly':shadow,'AlphaTest/cut_off':alpha}
 if renderer is not None:props['Environment/Renderer']=renderer
 before=dict(initial,renderer=7,height_blend=True,scale_bits=[0x40000000,0x40400000,0x40800000,0x40a00000],colormap=oldcolor,shadow_dynamic_only=oldshadow,colormap_revision=0xffffffff if height==2 else 7,shadow_revision=0xffffffff if height==2 else 9)
 cases.append(execute(props,before))
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x958e90','stop_before_following_initialization':'0x95907b','native_addresses':len(visited),'alpha_unit_bits':alpha_unit_bits,'native_static_initial_state':initial,'cases':cases,'findings':['Case-sensitive renderer defaults legacy; baked sets2 and skips legacy-specific fields; unknown names retain prior state.','Height/color use integer nonzero; ShadowDynamicOnly is true only for exact1. Color/shadow revisions increment only on change with u32wrap.','Four float scales default1; alpha integer clamps0..255 and multiplies original f32 reciprocal255 in every renderer branch.','First case consumes values actually decoded by original Map10 INIBIN loader; Environment/Renderer and AlphaTest/cut_off are absent and take defaults.'],'runtime_adapters':['Config getters adapted with explicit values/defaults/flags; actual complete config lookup, text overrides and parse/conversion semantics remain unqualified.','CRT strcmp adapted for observed ASCII exact comparison; x87 float getter returns through FLD stub.','Entered original consumer and stopped after config writes before subsequent registrations/setup; original full renderer initialization/GPU remain open.'],'limits':['Consumer branch/state/store scope; not complete original configuration/renderer/shadow/alpha raster fidelity.','Native alpha reference is recorded; alpha comparison operator, draw-state routing and live material cutoff application remain unqualified.']}
(r/'data/4.20/environment_render_config_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'map10_state':cases[0]['result']}))
