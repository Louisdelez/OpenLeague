from pathlib import Path
import json,struct,ast,hashlib,datetime
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text().split('\ncases=[]')[0],'native-setup','exec'))
parser={'struct':struct};tree=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text());exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ['ini','hashkey']],type_ignores=[]),'parser','exec'),parser)
config=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/LEVELS/Map10/Graphics.inibin');properties=parser['ini'](config)
descriptor=terrain+0x2000;sectionptr=terrain+0x3000;resourceptr=terrain+0x4000;frame=sp-0x1000;requests=[];selected=[];override=None
def cstring(pointer):return bytes(u.mem_read(pointer,128)).split(b'\0')[0].decode('ascii')
def string_value(pointer):return cstring(read32(pointer) if read32(pointer+0x14)>=16 else pointer)
def boundary(uc,address,size,user):
 stack=u.reg_read(UC_X86_REG_ESP)
 if address==0x8b1a80:
  resource,section,key=cstring(read32(stack+4)),cstring(read32(stack+8)),cstring(read32(stack+12));default=read32(stack+16);assert key=='DestroyedTowerSkinID' and default==0
  value=int(properties.get(parser['hashkey'](section,key),default)) if override is None else override[1];requests.append(dict(key=key,section=section,resource=resource,default=default,selected=value));u.reg_write(UC_X86_REG_EAX,value);u.reg_write(UC_X86_REG_EIP,read32(stack));u.reg_write(UC_X86_REG_ESP,stack+4)
 elif address==0x8b0630:
  section=cstring(u.reg_read(UC_X86_REG_ECX));key=cstring(u.reg_read(UC_X86_REG_EDX));default=cstring(read32(stack+4));out=read32(stack+8);limit=read32(stack+12);resource=cstring(read32(stack+16));assert key=='DestroyedTowerSkin' and default=='DestroyedTower' and limit==0x13a0
  value=properties.get(parser['hashkey'](section,key),default) if override is None else override[0];assert isinstance(value,str);u.mem_write(out,value.encode()+b'\0');requests.append(dict(key=key,section=section,resource=resource,default=default,selected=value));u.reg_write(UC_X86_REG_EIP,read32(stack));u.reg_write(UC_X86_REG_ESP,stack+4)
 elif address==0x873070:
  selected.append(dict(model=string_value(read32(stack+4)),skin=read32(stack+8)));u.reg_write(UC_X86_REG_EIP,read32(stack));u.reg_write(UC_X86_REG_ESP,stack+12)
 elif address==0x9933e0:
  length=read32(stack+4);assert length<0x1000;u.reg_write(UC_X86_REG_EAX,terrain+0x7000);u.reg_write(UC_X86_REG_EIP,read32(stack));u.reg_write(UC_X86_REG_ESP,stack+4)
u.hook_add(unicorn.UC_HOOK_CODE,boundary)
cases=[]
names=list(json.loads((r/'data/4.20/native_grass_structure_model_bounds.json').read_text()))
for name,override in [(name,None) for name in names]+[('fixture-override',('OtherDestroyedModel',3)),('fixture-empty',('',0))]:
 requests.clear();selected.clear();u.mem_write(descriptor,bytes(0x100));u.mem_write(frame,bytes(0x100));u.mem_write(sectionptr,name.encode()+b'\0');u.mem_write(resourceptr,b'Levels/Map10/Graphics.ini\0')
 # Descriptor SSO field stores a long section by pointer for every fixture.
 write32(descriptor+0x24,sectionptr);write32(descriptor+0x34,len(name));write32(descriptor+0x38,31)
 u.reg_write(UC_X86_REG_EBX,descriptor);u.reg_write(UC_X86_REG_ESI,descriptor+0x24);u.reg_write(UC_X86_REG_EDI,resourceptr);u.reg_write(UC_X86_REG_EAX,sectionptr);u.reg_write(UC_X86_REG_ESP,frame)
 u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(0x87d049,0x87d0e3,count=100000);assert u.reg_read(UC_X86_REG_EIP)==0x87d0e3 and len(selected)==1 and len(requests)==2
 expected={'model':'DestroyedTower','skin':0} if override is None else {'model':override[0],'skin':override[1]};assert selected[0]==expected
 cases.append(dict(section=name,configuration_override=override,requests=list(requests),selected=selected[0]))
proof=dict(passed=True,complete=False,actual_map10_resource_binding_qualified=False,native_sha256=digest,native_addresses=len(visited),resource=str(config),resource_sha256=hashlib.sha256(config.read_bytes()).hexdigest(),cases=cases,limits=['Actual87D049..87D0E3 consumer including native string construction executes; integer/string configuration lookup, allocation and model spawn boundary adapted.','Supplied resource is original Map10 Graphics.inibin. Binding of native global+38 to that resource and actual descriptor section names remains unqualified; these fixtures do not prove final Map10 model selection.','Native873070 skin debug override and actual descriptor/model factory are not executed.'])
(r/'docs/native_destroyed_selection_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),default='DestroyedTower',map10_resource_binding_qualified=False)))
