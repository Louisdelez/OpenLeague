from pathlib import Path
import sys,struct,json,hashlib,datetime,itertools
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn
from unicorn.x86_const import *
r=Path('E:/OpenLeague');p=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe');raw=p.read_bytes();pe=pefile.PE(data=raw);memory=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(base,(len(memory)+4095)&~4095);u.mem_write(base,memory);arena=0x40000000;u.mem_map(arena,0x10000);stack=arena+0x1000;end=arena+0x2000;material=arena+0x3000;visited=set();u.hook_add(unicorn.UC_HOOK_CODE,lambda uc,a,size,user:visited.add(a))
w=lambda a,v:u.mem_write(a,struct.pack('<I',v&0xffffffff))
def reject(selector,kind,flags,quality):
 if selector==0:return kind==2 or flags&4!=0 and quality>0
 if selector in [1,5,8]:return kind not in [0,2,3]
 if selector==2:return kind not in [0,3]
 if selector==3:return kind!=2 or flags&4!=0
 if selector==4:return kind!=2
 if selector==6:return kind not in [0,3]
 if selector==7:return flags&4==0
 if selector in [9,10,13,14]:return kind!=3 and flags&8==0
 if selector in [11,12]:return flags&0x64!=0
 return False
cases=[]
for selector,kind,flags,quality in itertools.product(range(17),range(5),range(128),[-1,0,1,3]):
 w(stack,end);w(material+0x104,kind);w(material+0x108,flags);w(0x12258d8,quality);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,material);u.reg_write(UC_X86_REG_EDX,selector);u.emu_start(0x95b4d0,end,count=100);actual=bool(u.reg_read(UC_X86_REG_EAX)&0xff);assert actual==reject(selector,kind,flags,quality),(selector,kind,flags,quality,actual)
 cases.append({'selector':selector,'type':kind,'flags':flags,'quality':quality,'rejected':actual})
profiles=json.loads((r/'data/4.20/map10_shader_material_fields.json').read_text(encoding='utf-8'))['gltf_materials_matched'];map10=[{'name':p['name'],'type':p['type'],'flags':p['flags'],'drawn_passes':[i for i in range(15) if not reject(i,p['type'],p['flags'],3)]} for p in profiles]
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x95b4d0','native_addresses':len(visited),'cases':cases,'map10':map10,'caller_evidence':['Native95B841/95B846/95B848 and95B965/95B96A/95B96C call classifier, test AL and skip current row on true.','Native73CC40/73CC45 disables alpha before later preparation; call73CCBD passes selector7 from73CCB3. Full intermediate preparation and actual draw remain unqualified.'],'findings':['Classifier true means rejection, not admission.','Flag4 materials at positive quality are rejected from ordinary selector0 and admitted by selector7. Type1 nonflag4 decalers are admitted by selector0.','Type2 nonflag4 grass is rejected from selectors0/7 and admitted by selector3/4; separate grass path requires qualification.'],'limits':['Original draw queue, per-pass setup persistence, special selector7 shader path and quality settings source remain unfinished.','Classified pass lists represent only this predicate; they do not prove every listed pass is executed or a scene mesh is actually drawn.','This stage records native routing evidence; production pass scheduling and alpha enable corrections not yet integrated.']}
(r/'data/4.20/material_pass_filter_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'pass0_materials':sum(0 in p['drawn_passes'] for p in map10),'pass7_materials':sum(7 in p['drawn_passes'] for p in map10),'passed':True}))
