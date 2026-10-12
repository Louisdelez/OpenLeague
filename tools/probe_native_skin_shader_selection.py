from pathlib import Path
import sys,struct,json,hashlib,itertools,datetime
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn
from unicorn.x86_const import *
r=Path('E:/OpenLeague');p=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe');raw=p.read_bytes();pe=pefile.PE(data=raw);image=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(base,(len(image)+4095)&~4095);u.mem_write(base,image);u.mem_map(0x40000000,0x20000)
w=lambda a,x:u.mem_write(a,struct.pack('<I',x&0xffffffff));read=lambda a:struct.unpack('<I',u.mem_read(a,4))[0]
visited=set()
def hook(uc,address,size,user):
 assert 0x87852d<=address<0x878774,hex(address)
 visited.add(address)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
obj=0x40000000;holder=obj+0x1000;output=obj+0x2000;mesh=obj+0x3000;model=obj+0x4000;skin=obj+0x5000;death=obj+0x6000;stack=obj+0x10000
names={11:'SkinnedMesh_LIT_PROP_LOW_VS',12:'SkinnedMesh_LIT_PROP_VS',13:'SkinnedMesh_LIT_PROP_REFLECTIVE_VS',21:'SkinnedMesh_LIT_PROP_LOW_PS',22:'SkinnedMesh_LIT_PROP_LOW_PS_DEATH_SCREEN',23:'SkinnedMesh_LIT_PROP_REFLECTIVE_PS',24:'SkinnedMesh_LIT_PROP_PS',25:'SkinnedMesh_LIT_PROP_PS_DEATH_SCREEN'}
cases=[]
for quality,is_dead,reflective in itertools.product([-1,0,1,2,3],[False,True],[False,True]):
 u.mem_write(obj,bytes(0x8000));w(obj+0x178,11);w(obj+0x17c,12);w(obj+0x180,13);w(holder,output);w(obj+0x130,mesh);w(mesh+0x50,model);w(model+0x9e4,skin);u.mem_write(skin+0x30,bytes([reflective]));w(0x2d78f48,death);u.mem_write(death+0xc,bytes([is_dead]));w(0x12258d8,quality);w(0x2d83ec4,31)
 for address,value in [(0x2d83ec8,21),(0x2d83ecc,22),(0x2d83ed0,23),(0x2d83ed4,24),(0x2d83ed8,25)]:w(address,value)
 u.reg_write(UC_X86_REG_ESI,obj);u.reg_write(UC_X86_REG_EDI,holder);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EBP,stack+0x400)
 u.emu_start(0x87852d,0x878774,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x878774
 vs=read(output+0x44);ps=read(output+0x48)
 expected=(11,22 if is_dead else 21) if quality<=1 else ((12,25) if is_dead else ((13,23) if reflective else (12,24)))
 assert (vs,ps)==expected,(quality,is_dead,reflective,vs,ps)
 cases.append({'quality':quality,'death_screen':is_dead,'reflective':reflective,'vertex_shader':names[vs],'pixel_shader':names[ps]})
def cstring(address):
 if not base<=address<base+len(image):return None
 b=image[address-base:address-base+300].split(b'\0')[0]
 return b.decode() if b and all(32<=c<=126 for c in b) else None
descriptors={}
for name in names.values():
 found=raw.find(name.encode()+b'\0');assert found>=0,name;address=base+pe.get_rva_from_offset(found)
 for match in __import__('re').finditer(__import__('re').escape(struct.pack('<I',address)),image):
  off=match.start()
  if off+12>len(image):continue
  n,path,defines=struct.unpack_from('<3I',image,off);path=cstring(path)
  if path and path.startswith('SkinnedMesh/'):
   descriptors[name]={'native_descriptor':hex(base+off),'source':path,'defines':cstring(defines) if defines else ''}
source=p.parent/'DATA/Shaders/HLSL/SkinnedMesh';sources=[]
for name in names.values():
 descriptor=descriptors.get(name);stem=name.removeprefix('SkinnedMesh_').replace('_DEATH_SCREEN','');suffix='.vs_2_0' if stem.endswith('_VS') else '.ps_2_0';path=p.parent/'DATA/Shaders/HLSL'/descriptor['source'] if descriptor else source/(stem+suffix)
 sources.append({'variant':name,'static_descriptor':descriptor,'path':str(path),'exists':path.exists(),'sha256':hashlib.sha256(path.read_bytes()).hexdigest() if path.exists() else None,'death_variant_registration_qualified':False if name.endswith('_DEATH_SCREEN') else None})
 if descriptor and path.exists():
  archive=r/'data/4.20/shaders'/descriptor['source'];archive.parent.mkdir(parents=True,exist_ok=True)
  if archive.exists():assert archive.read_bytes()==path.read_bytes()
  else:archive.write_bytes(path.read_bytes())
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x87852d','stop':'0x878774','native_addresses':len(visited),'cases':cases,'shader_sources':sources,'runtime_adapters':['Shader lookup caches prefilled with distinct handles; no shader compiler/device execution in this probe.','Supplied mesh/model/skin chain, quality global and death-screen context; original native branch instructions and output assignments executed.'],'findings':['Signed quality<=1 chooses low shaders.','High quality death-screen uses ordinary vertex shader and death-screen pixel shader, taking precedence over reflective flag.','High quality living reflective material chooses reflective vertex/pixel shaders; other living materials choose ordinary pair.'],'limits':['Starts after upstream render eligibility and skin/model descriptor preparation; their producer behavior remains unqualified.','Actual shader macro registration, reflection textures, death rendering and complete original draw path remain open.','No full shader variants or all champion skins implemented by this qualification.']}
(r/'data/4.20/skinned_shader_selection_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'missing_shader_sources':[s['variant'] for s in sources if not s['exists']]}))
