from pathlib import Path
import sys,struct,json,hashlib,datetime,itertools
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn
from unicorn.x86_const import *
r=Path('E:/OpenLeague');p=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe');raw=p.read_bytes();pe=pefile.PE(data=raw);memory=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(base,(len(memory)+4095)&~4095);u.mem_write(base,memory);u.mem_map(0x40000000,0x30000);arena=0x40000000;device=arena;vt=arena+0x1000;callback=arena+0x2000;stack=arena+0x20000;end=arena+0x2f000;calls=[];visited=set()
w=lambda a,v:u.mem_write(a,struct.pack('<I',v&0xffffffff));read=lambda a:struct.unpack('<I',u.mem_read(a,4))[0]
def finish(pop=0):
 sp=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EIP,read(sp));u.reg_write(UC_X86_REG_ESP,sp+4+pop)
def hook(uc,a,size,user):
 if a==callback:
  sp=u.reg_read(UC_X86_REG_ESP);receiver,state,value=struct.unpack('<3I',u.mem_read(sp+4,12));assert receiver==device;calls.append([state,value]);finish(12);return
 if a==0xc975f5:finish();return
 assert 0x9ac500<=a<0x9ac5f4 or 0x9abc90<=a<0x9abedd or 0x9abee0<=a<0x9ac086 or 0x73cad9<=a<0x73caf2,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(device,vt);w(vt+0xe4,callback);w(0x2d794b0,device);u.mem_write(0x2d79470,b'\0')
table=list(struct.unpack('<8I',u.mem_read(0x10e31a8,32)));unit=struct.unpack('<f',u.mem_read(0x1138a30,4))[0];scale=struct.unpack('<f',u.mem_read(0x1139104,4))[0];assert scale==255.
cases=[]
for mode,cut,func_hit,reference_hit in itertools.product(range(8),range(256),[False,True],[False,True]):
 reference=struct.unpack('<f',struct.pack('<f',cut*unit))[0];bits=struct.unpack('<I',struct.pack('<f',reference))[0];initial_func=mode if func_hit else 0xffffffff;initial_bits=bits if reference_hit else (0x3f000000 if bits!=0x3f000000 else 0)
 w(0x123ff40,initial_func);w(0x123ff44,initial_bits);w(stack,end);w(stack+4,bits);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,mode);u.reg_write(UC_X86_REG_FPCW,0x37f);calls=[];u.emu_start(0x9ac500,end,count=500);assert u.reg_read(UC_X86_REG_EIP)==end
 expected=[]
 if not func_hit:expected.append([25,table[mode]])
 byte=int(float(reference)*255.)
 if not reference_hit:expected.append([24,byte])
 assert calls==expected,(mode,cut,calls,expected);assert read(0x123ff40)==mode and read(0x123ff44)==bits
 cases.append({'mode':mode,'cutoff_input':cut,'reference_bits':bits,'initial_function':initial_func,'initial_reference_bits':initial_bits,'calls':calls.copy(),'quantized_reference':byte})
enable_cases=[]
for enabled,suppressed,request in itertools.product([False,True],[False,True],[False,True]):
 w(0x123ff20,0x4000000 if enabled else 0);u.mem_write(0x2d79470,bytes([suppressed]));w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,0x4000000);calls=[];u.emu_start(0x9abc90 if request else 0x9abee0,end,count=500);assert u.reg_read(UC_X86_REG_EIP)==end;expected=[[15,int(request)]] if enabled!=request and not suppressed else [];assert calls==expected;assert bool(read(0x123ff20)&0x4000000)==request;enable_cases.append({'initial_enabled':enabled,'suppressed':suppressed,'request_enabled':request,'calls':calls.copy()})
u.mem_write(0x2d79470,b'\0');w(0x123ff20,0);w(0x123ff40,0xffffffff);w(0x123ff44,0);w(0x12258d4,struct.unpack('<I',struct.pack('<f',unit))[0]);w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,0x4000000);u.reg_write(UC_X86_REG_FPCW,0x37f);calls=[];u.emu_start(0x73cad9,0x73caf2,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x73caf2;assert calls==[[15,1],[25,5],[24,1]]
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'setter_entry':'0x9ac500','enable_entry':'0x9abc90','disable_entry':'0x9abee0','world_setup_entry':'0x73cad9','native_addresses':len(visited),'comparison_table':table,'reference_scale':scale,'cases':cases,'enable_cases':enable_cases,'world_setup_calls':calls.copy(),'findings':['Native world setup enables state15, sets comparison state25value5, and reference state24value1 under Map10 default reference.','Original native setter uses x87 reference*255 then truncation; comparison/reference caches independently skip identical device submissions.','Reference conversion uses actual original f32 reciprocal255 normalization and wide x87 product; every cutoff0..255 checked under eight comparisons and cache combinations.'],'runtime_adapters':['Real native instructions execute; D3D virtual SetRenderState callback records state/value and returns, no actual original D3D raster submission.','Security cookie checker adapted; actual device and cache globals supplied. Enable/disable scope restricted to alpha flag0x4000000.'],'semantic_sources':['https://learn.microsoft.com/en-us/windows/win32/direct3d9/d3dcmpfunc','https://learn.microsoft.com/en-us/windows/win32/direct3d9/d3drenderstatetype'],'limits':['Ordinary world setup and device state setter qualified in scope; full render-pass ordering, per-mesh changes and original pixel alpha quantization/interpolation remain open.','Does not qualify all map/champion/particle shader alpha variants or original framebuffer equivalence.']}
(r/'data/4.20/alpha_render_state_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'enable_cases':len(enable_cases),'native_addresses':len(visited),'world_calls':calls,'cutoffs_with_native_reference_difference':sorted({c['cutoff_input'] for c in cases if c['quantized_reference']!=c['cutoff_input']})}))
