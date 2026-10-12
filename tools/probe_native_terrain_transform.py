from pathlib import Path
import sys,struct,json,hashlib,datetime
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn
from unicorn.x86_const import *
r=Path('E:/OpenLeague');p=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe');raw=p.read_bytes();pe=pefile.PE(data=raw);image=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(base,(len(image)+4095)&~4095);u.mem_write(base,image);u.mem_map(0x40000000,0x30000);asset=0x40000000;state=asset+0x1000;stack=asset+0x20000;end=asset+0x2f000;visited=set();uploads=[]
w=lambda a,x:u.mem_write(a,struct.pack('<I',x&0xffffffff));read=lambda a:struct.unpack('<I',u.mem_read(a,4))[0]
def hook(uc,a,size,user):
 if a==asset+0x6000:
  sp=u.reg_read(UC_X86_REG_ESP);register,pointer,count=struct.unpack('<3I',u.mem_read(sp+4,12));assert register==233 and count==1;uploads.append(list(struct.unpack('<4I',u.mem_read(pointer,16))));u.reg_write(UC_X86_REG_EIP,read(sp));u.reg_write(UC_X86_REG_ESP,sp+16);return
 assert 0x86fa49<=a<0x86fac2 or 0x86fb74<=a<0x86fc55 or 0x95c97d<=a<0x95c99a,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);bounds_contract=json.loads((r/'data/4.20/fow_level_bounds_contract.json').read_text());wrapper=asset+0x3000;renderer=asset+0x4000;vtable=asset+0x5000;w(0x2d79078,wrapper);w(wrapper+0x14,renderer);w(renderer,vtable);w(vtable+0x8c,asset+0x6000)
cases=[]
for source in bounds_contract['cases']:
 u.mem_write(asset,bytes(128));u.mem_write(asset+0x64,struct.pack('<6I',*source['bounds_bits']));u.mem_write(state,bytes(0x500));u.reg_write(UC_X86_REG_EAX,asset);u.reg_write(UC_X86_REG_EDI,state);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.emu_start(0x86fa49,0x86fac2,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x86fac2
 frame=stack+0x100;w(frame,0);w(frame+4,end);w(frame-8,0);u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,frame-8);u.emu_start(0x86fb74,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
 params=list(struct.unpack('<4I',u.mem_read(0x2d778bc,16)));u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0x95c97d,0x95c99a,count=100);assert u.reg_read(UC_X86_REG_EIP)==0x95c99a and uploads[-1]==params
 cases.append({'bounds_bits':source['bounds_bits'],'span_bits':source['span_bits'],'center_bits':source['center_bits'],'params_bits':params,'uploaded_bits':uploads[-1],'register':233,'count':1})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'bounds_entry':'0x86fa49','transform_entry':'0x86fb74','upload_entry':'0x95c97d','native_addresses':len(visited),'resource':bounds_contract['resource'],'cases':cases,'findings':['Original native SCB bounds arithmetic feeds original SSE terrain transform producer; c233 upload reads those exact four f32 bits.','Transform has reciprocal X/Z spans and centered offset: -(center-span*0.5)*reciprocal.','Actual Map10 native span is15398.671875 on X/Z, not the prior reconstructed15360UV divisor.'],'runtime_adapters':['SCB bounds field layout supplied from original header, as existing bounds qualification; native SCB resource registration/loader remains open.','Producer entered through bounds-ready branch; stack frame supplied. GPU constant uploader records register/count/data and returns, no D3D submission.'],'limits':['Original producer and upload bits qualified in recorded scope; full world geometry transform, all camera/animation coordinates and native framebuffer equivalence remain open.','Zero-span native infinities/NaNs retained in bit fixtures; runtime must reject invalid geometry rather than invent usable coordinates.']}
(r/'data/4.20/terrain_transform_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'map10_transform_bits':cases[0]['params_bits'],'map10_transform':list(struct.unpack('<4f',struct.pack('<4I',*cases[0]['params_bits'])))}))
