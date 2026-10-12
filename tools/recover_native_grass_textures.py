from pathlib import Path
import sys,struct,json,hashlib,datetime,itertools,shutil
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn
from unicorn.x86_const import *
from PIL import Image
r=Path('E:/OpenLeague');p=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe')
raw=p.read_bytes();pe=pefile.PE(data=raw);m=pe.get_memory_mapped_image();b=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(b,(len(m)+4095)&~4095);u.mem_write(b,m)
a=0x40000000;u.mem_map(a,0x10000);object=a;manager=a+0x1000;stack=a+0x8000;visited=set();requests=[];returned=0;manager_missing=False
w=lambda addr,v:u.mem_write(addr,struct.pack('<I',v&0xffffffff));read=lambda addr:struct.unpack('<I',u.mem_read(addr,4))[0]
def hook(uc,addr,size,user):
 if addr==0x98a7f0:
  sp=u.reg_read(UC_X86_REG_ESP);arguments=[read(sp+4+i*4) for i in range(5)];name=bytes(u.mem_read(arguments[0],100)).split(b'\0')[0].decode();requests.append({'name':name,'context':arguments[1],'options':arguments[2:]});u.reg_write(UC_X86_REG_EAX,returned);u.reg_write(UC_X86_REG_EIP,read(sp));u.reg_write(UC_X86_REG_ESP,sp+24);return
 if addr==0x9599c7:u.emu_stop();return
 assert 0x959700<=addr<0x95973e,hex(addr);visited.add(addr)
u.hook_add(unicorn.UC_HOOK_CODE,hook);cases=[]
for context,returned,manager_missing in itertools.product([0,a+0x2000],[0,a+0x3000,a+0x4000],[False,True]):
 requests=[];w(0x2d79078,0 if manager_missing else manager);w(object+0x20,0xabcdef01);w(stack+8,context);u.reg_write(UC_X86_REG_ESP,stack-0x100);u.reg_write(UC_X86_REG_EBP,stack);u.reg_write(UC_X86_REG_EDI,object);u.emu_start(0x959700,0x95973e,count=100)
 expected=0xabcdef01 if manager_missing else (returned if context else 0);assert read(object+0x20)==expected
 assert len(requests)==int(not manager_missing and context!=0)
 if requests:assert requests==[{'name':'wall_of_grass_mask.dds','context':context,'options':[0,0,1]}]
 cases.append({'context_present':bool(context),'manager_present':not manager_missing,'loader_return':returned,'stored_texture':read(object+0x20),'load_requests':requests})
assets=[];directory=r/'assets/maps/grass_native';directory.mkdir(parents=True,exist_ok=True)
for name in ['wall_of_grass_mask.dds','White.dds','Blank.dds']:
 source=p.parent/'DATA/Shaders/TEXTURE'/name;image=Image.open(source).convert('RGBA');destination=directory/(Path(name).stem+'.png');image.save(destination);decoded=Image.open(destination).convert('RGBA');assert decoded.tobytes()==image.tobytes()
 dds=directory/name;shutil.copy2(source,dds);assert dds.read_bytes()==source.read_bytes()
 assets.append({'native_path':str(source),'native_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'dds_asset':str(dds.relative_to(r)),'png_asset':str(destination.relative_to(r)),'png_sha256':hashlib.sha256(destination.read_bytes()).hexdigest(),'decoded_rgba_sha256':hashlib.sha256(image.tobytes()).hexdigest(),'size':image.size,'extrema':image.getextrema(),'distinct_rgba':len(set(image.getdata())),'decoded_pixels_equal':True})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x959700','stop':'0x95973e before subsequent constructor/driver state','native_addresses':len(visited),'cases':cases,'assets':assets,'findings':['Actual renderer-context constructor loadswall_of_grass_mask.ddswith supplied nonnull context/options[0,0,1]and stores loader return atobject+20; nullcontext storeszero; missingmanager skips field mutation.','Default global14BEF38initialization inspected at98131F..981345calls98A7F0with stringWhite.dds(10DC3B4). Adjacent global14BEF3CloadsBlank.dds.','OriginalDDSfiles recovered unchanged; PNG conversion preserves every decodedRGBApixel. These are actual source files, not generated replacement textures.'],'runtime_adapters':['Native constructor prefix executes;98A7F0texture-loading consumer returns independent fixture handles; actual path resolution/device upload not executed.','Default initializer name linkage from native static instructions; not full initializer execution.'],'limits':['DDSdecoder PNG equivalence does not prove native compressed GPU filtering or load-option interpretation.','Whole constructor, loader search precedence/context, texture initialization/device bindings and grass pass state remain open.','Recoveredassets not yet connected to normal GPUgrassmask producer; allgame requirements remain unfinished.']}
(r/'data/4.20/grass_texture_sources_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'constructor_cases':len(cases),'assets':[{'name':Path(x['native_path']).name,'size':x['size'],'extrema':x['extrema'],'distinct_rgba':x['distinct_rgba']} for x in assets],'passed':True}))
