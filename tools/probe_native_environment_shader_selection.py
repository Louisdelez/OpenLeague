from pathlib import Path
import sys,struct,json,hashlib,itertools,datetime
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn
from unicorn.x86_const import *
r=Path('E:/OpenLeague');p=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe');raw=p.read_bytes();pe=pefile.PE(data=raw);image=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(base,(len(image)+4095)&~4095);u.mem_write(base,image);u.mem_map(0x40000000,0x30000)
w=lambda a,x:u.mem_write(a,struct.pack('<I',x&0xffffffff));read=lambda a:struct.unpack('<I',u.mem_read(a,4))[0]
def string(a):return bytes(u.mem_read(a,180)).split(b'\0')[0].decode()
visited=set();selected=[];textures=[];texture_requests=[];return_texture_handles=True
def finish(result=0,arguments=0):
 sp=u.reg_read(UC_X86_REG_ESP);ret=read(sp);u.reg_write(UC_X86_REG_EAX,result);u.reg_write(UC_X86_REG_ESP,sp+4+arguments);u.reg_write(UC_X86_REG_EIP,ret)
def hook(uc,address,size,user):
 if address==0x98a7f0:
  sp=u.reg_read(UC_X86_REG_ESP);name=string(read(sp+4));texture_requests.append({'name':name,'remaining_slots':read(sp+12),'arguments':[read(sp+16),read(sp+20)]});finish(read(sp+4) if return_texture_handles else 0,20);return
 if address==0x9805c0:finish(read(u.reg_read(UC_X86_REG_ESP)+4),4);return
 if address in [0x95a520,0x95a570]:
  selected.append({'stage':'vertex' if address==0x95a520 else 'pixel','name':string(read(u.reg_read(UC_X86_REG_ESP)+4))});finish(arguments=4);return
 if address==0x983cb0:
  sp=u.reg_read(UC_X86_REG_ESP);textures.append({'handle':read(sp+4),'slot':read(sp+8)});finish(arguments=8);return
 if address in [0x95a480,0x95a5f0,0x95a640]:finish(arguments=0 if address==0x95a480 else 4);return
 assert 0x95a730<=address<0x95ad18 or 0x958850<=address<0x958be7,hex(address);visited.add(address)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
context=0x40000000;material=context+0x1000;renderer=context+0x3000;stack=context+0x20000;end=context+0x2f000
w(0x2d79078,renderer);w(context+0x58,0);u.mem_write(0x2d78fbc,b'\0')
cases=[]
for pass_selector,material_type,flags,emissive,global_options in itertools.product(range(10),range(4),[0,1,4,8,16,24,32,48,64,80,96,127],[False,True],[0,4]):
 selected.clear();textures.clear();w(context+0x54,pass_selector);w(material+0x104,material_type);w(material+0x108,flags);w(material+0xbb0,111 if emissive else 0);w(material+0xbac,222);w(0x2d78fb0,global_options);w(0x2d90f30,0)
 w(stack,end);w(stack+4,material);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,context);u.emu_start(0x95a730,end,count=2000);assert u.reg_read(UC_X86_REG_EIP)==end
 cases.append({'pass_selector':pass_selector,'material_type':material_type,'flags':flags,'emissive_handle_present':emissive,'global_options':global_options,'selected':selected.copy(),'textures':textures.copy()})
normal=[c for c in cases if c['pass_selector']==0 and c['material_type'] in [0,1]]
assert normal and all(c['selected'] for c in normal)
# Independent branch expression, verified against original instructions over each fixture.
for c in normal:
 f=c['flags'];em=c['emissive_handle_present'];typ=c['material_type']
 if f&32:vs='Environment_NOLIGHTING_VS';ps='Environment_NOLIGHTING_PS'
 elif f&64:vs='Environment_NOLIGHTING_WITHFOG_VS';ps='Environment_NOLIGHTING_WITHFOG_PS'
 elif typ==1 or f&8:vs='Environment_LIT_DECAL_VS' if em else 'Environment_LIT_NO_EMISSIVE_DECAL_VS';ps='Environment_LIT_DECAL_PS' if em else 'Environment_LIT_NO_EMISSIVE_DECAL_PS'
 else:vs='Environment_LIT_VS' if em else 'Environment_LIT_NO_EMISSIVE_VS';ps='Environment_LIT_PS' if em else 'Environment_LIT_NO_EMISSIVE_PS';vs='Environment_LIT_DUAL_COLOR_VS' if f&16 else vs
 assert c['selected']==[{'stage':'vertex','name':vs},{'stage':'pixel','name':ps}],c
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x95a730','native_addresses':len(visited),'cases':cases,'normal_selector_cases':len(normal),'jump_table':[hex(struct.unpack_from('<I',image,0x95ad18-base+4*i)[0]) for i in range(9)],'runtime_adapters':['9805C0 shader lookup returns distinct string address handles; shader compiler/device excluded.','95A520/95A570 selected shader consumers record requested pair; death-screen remapping inside95A570 excluded.','95A480/95A5F0/95A640 texture/constants upload preparation adapted;983CB0 records texture calls.','Material fields, render context selector and global options supplied; their producer remains unqualified.'],'limits':['Original dispatch and branch selection execute, but render pass meaning and NVR material field producers are not yet qualified.','Texture/constant preparation and GPU state/compile/render execution excluded.','Does not implement original variants or prove native pixel equivalence.']}
(r/'data/4.20/environment_shader_selection_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'normal_selector_cases':len(normal),'native_addresses':len(visited),'jump_table':proof['jump_table']}))
