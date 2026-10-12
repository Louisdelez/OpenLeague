from pathlib import Path
import sys,struct,json,hashlib,datetime,itertools
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn
from unicorn.x86_const import *
r=Path('E:/OpenLeague');p=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe')
raw=p.read_bytes();pe=pefile.PE(data=raw);m=pe.get_memory_mapped_image();b=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(b,(len(m)+4095)&~4095);u.mem_write(b,m);u.mem_map(0,0x1000)
a=0x40000000;u.mem_map(a,0x50000);manager=a;wrapper=a+0x1000;secondary=a+0x2000;device=a+0x3000;device2=a+0x4000;vt=a+0x5000;callback=a+0x6000;tlsarray=a+0x7000;tls=a+0x8000;stack=a+0x40000;end=a+0x4f000;calls=[];visited=set()
w=lambda addr,v:u.mem_write(addr,struct.pack('<I',v&0xffffffff));read=lambda addr:struct.unpack('<I',u.mem_read(addr,4))[0]
def finish(pop=0):
 sp=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EIP,read(sp));u.reg_write(UC_X86_REG_ESP,sp+4+pop)
def hook(uc,addr,size,user):
 if addr==callback:
  sp=u.reg_read(UC_X86_REG_ESP);arguments=list(struct.unpack('<7I',u.mem_read(sp+4,28)));assert arguments[0] in [device,device2];calls.append(arguments);finish(28);u.reg_write(UC_X86_REG_EAX,0);return
 if addr==0xc975f5:finish();return
 assert 0x980290<=addr<0x9802d5 or 0x9c2510<=addr<0x9c2562 or 0x9c57e0<=addr<0x9c5900,hex(addr);visited.add(addr)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(0x2d79078,manager);w(manager+0x14,wrapper);w(wrapper,0x10e2f30);w(secondary,0x10e2f30);w(wrapper+0x14,device);w(secondary+0x14,device2);w(device,vt);w(device2,vt);w(vt+0xac,callback);w(0x2c,tlsarray);w(tlsarray,tls)
cases=[]
for flags,color,second,junk in itertools.product(range(8),[0,0xffffffff,0x11223344],[False,True],[0,0x12345678,0xffffffff]):
 w(manager+0x18,secondary if second else 0);w(stack,end)
 for i,value in enumerate([0,0,flags,color,junk,junk]):w(stack+4+i*4,value)
 w(tls+4,0);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,manager);calls=[];u.emu_start(0x980290,end,count=2000)
 expected=[[receiver,0,0,flags,color,0x3f800000,0] for receiver in ([device,device2] if second else [device])];assert calls==expected;assert read(tls+4)==1
 cases.append({'flags':flags,'argb_color':color,'secondary_device_present':second,'unused_argument_bits':junk,'api_calls':calls.copy()})
mask_calls=[c['api_calls'] for c in cases if c['flags']==1 and c['argb_color']==0xffffffff and not c['secondary_device_present']];assert mask_calls
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x980290 ->0x9c2510 ->0x9c57e0','native_addresses':len(visited),'wrapper_vtable':'0x10e2f30','virtual30':'0x9c2510','cases':cases,'grass_mask_api_arguments':[0,0,1,0xffffffff,0x3f800000,0],'findings':['Actual abstract clear wrapper translates flags with native identity map1->1,2->2,4->4and reaches D3D9device virtualACClear withcount/rectangle/flags/ARGB/depth/stencil.','Grass producer arguments0,0,1,FFFFFFFFbecome full-viewport targetclear to opaque white; depthargument1and stencil0are supplied but flags1does not select their buffers.','Extra lasttwo980290arguments ignored; optional secondary wrapper receives identical clear request. Native successful HRESULT TLSupdate executes.'],'runtime_adapters':['Native generic wrapper, actual driver virtualdispatch, flagtranslation, D3DAPIforwarder and successful TLSpath execute; only D3D9ClearAPIboundary and securitycookie adapted.'],'semantic_sources':['https://learn.microsoft.com/en-us/windows/win32/api/d3d9/nf-d3d9-idirect3ddevice9-clear','https://learn.microsoft.com/en-us/windows/win32/direct3d9/d3dclear'],'limits':['S_OKAPIreturn only; original failure/device-loss paths and actual native GPU viewport binding remain open.','Does not qualify targetformat, targetpushviewport, filtering, alpha-state persistence or wholegrassdrawpixels.']}
(r/'data/4.20/grass_clear_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'grass_mask_api_arguments':proof['grass_mask_api_arguments'],'passed':True}))
