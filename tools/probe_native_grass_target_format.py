from pathlib import Path
import sys,struct,json,hashlib,datetime,itertools
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn
from unicorn.x86_const import *
r=Path('E:/OpenLeague');p=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe');raw=p.read_bytes();pe=pefile.PE(data=raw);m=pe.get_memory_mapped_image();b=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(b,(len(m)+4095)&~4095);u.mem_write(b,m);u.mem_map(0,0x1000)
a=0x40000000;u.mem_map(a,0x40000);wrapper=a;device=a+0x1000;vt=a+0x2000;callback=a+0x3000;output=a+0x4000;texture=a+0x5000;tlsarray=a+0x6000;tls=a+0x7000;stack=a+0x30000;visited=set();calls=[]
w=lambda addr,v:u.mem_write(addr,struct.pack('<I',v&0xffffffff));read=lambda addr:struct.unpack('<I',u.mem_read(addr,4))[0]
def hook(uc,addr,size,user):
 if addr==callback:
  sp=u.reg_read(UC_X86_REG_ESP);arguments=list(struct.unpack('<9I',u.mem_read(sp+4,36)));assert arguments[0]==device;calls.append(arguments);w(arguments[7],texture);u.reg_write(UC_X86_REG_EIP,read(sp));u.reg_write(UC_X86_REG_ESP,sp+40);u.reg_write(UC_X86_REG_EAX,0);return
 if addr==0xc975f5:
  sp=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EIP,read(sp));u.reg_write(UC_X86_REG_ESP,sp+4);return
 assert 0x9c2d40<=addr<=0x9c2de6 or 0x9c6070<=addr<0x9c6200,hex(addr);visited.add(addr)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(wrapper+0x14,device);w(device,vt);w(vt+0x5c,callback);w(0x2c,tlsarray);w(tlsarray,tls)
format_table=list(struct.unpack('<8I',u.mem_read(0x10e2b90,32)));pool_table=list(struct.unpack('<4I',u.mem_read(0x10e2c9c,16)));cases=[]
for width,height,usage,format_index,pool in itertools.product([0,1,200,4294967295],[0,1,150],[0,1,3],[2],[0]):
 w(stack,0);w(output,0)
 for i,v in enumerate([width,height,1,usage,format_index,pool,output]):w(stack+4+i*4,v)
 calls=[];u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,wrapper);u.emu_start(0x9c2d40,0x9c2deb,count=2500)
 assert len(calls)==1;arguments=calls[0]
 assert arguments[1:4]==[width,height,1] and arguments[5]==format_table[2] and arguments[6]==pool_table[0] and arguments[8]==0
 # API output pointer is a native temporary; wrapped texture construction occurs after stop.
 assert read(arguments[7])==texture
 cases.append({'width':width,'height':height,'levels':1,'abstract_usage':usage,'abstract_format':format_index,'abstract_pool':pool,'device_usage':arguments[4],'device_format':arguments[5],'device_pool':arguments[6],'shared_handle_pointer':arguments[8]})
assert format_table[2]==21 and pool_table[0]==0
assert all(c['device_usage']==1 for c in cases if c['abstract_usage']==1)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x9c2d40 ->0x9c6070','stop':'0x9c2deb before texture interface wrapping','native_addresses':len(visited),'cases':cases,'format_table':format_table,'findings':['Actual nativeCreateTexture virtual60 driver translates abstractformat2toD3Dformat21and pool0toDEFAULT0.','Grass target request with onelevel/usage1reaches originalD3DdeviceCreateTexture withusage1(format21,pool0,nullsharedhandle). Dimensions passed unchanged, including zero and unsignedmax.'],'runtime_adapters':['Native driver enum/usage conversion and externalD3DAPIforwarder execute; CreateTexture API records arguments and writes supplied fixture handle, returnsS_OK.','Post-API COMinterface allocation/wrapping and actualGPU allocation intentionally excluded.'],'semantic_sources':['https://learn.microsoft.com/en-us/windows/win32/direct3d9/d3dformat','https://learn.microsoft.com/en-us/windows/win32/api/d3d9/nf-d3d9-idirect3ddevice9-createtexture'],'limits':['This proves requested original8-bit ARGBformat and render-targetusage, not native device support/actual quantization or texture sampling.','Fullresource constructor/factory/cache, viewportbinding, filtering, matrix and meshbuffers remain open.']}
(r/'data/4.20/grass_target_format_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'native_format':format_table[2],'native_pool':pool_table[0],'passed':True}))
