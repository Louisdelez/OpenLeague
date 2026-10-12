from pathlib import Path
import sys,struct,json,hashlib,datetime,itertools
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn
from unicorn.x86_const import *
r=Path('E:/OpenLeague'); source=json.loads((r/'data/4.20/native_endgame_default_timing.json').read_text())['source']
raw=Path(source).read_bytes();pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase;memory=pe.get_memory_mapped_image()
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(base,(len(memory)+4095)&~4095);u.mem_write(base,memory);u.mem_map(0,0x10000);u.mem_map(0x40000000,0x40000)
device=0x40000000;vt=device+0x1000;callback=device+0x2000;backend=device+0x3000;renderer=device+0x4000;tls=device+0x5000;stack=device+0x30000;end=device+0x3f000
w=lambda a,v:u.mem_write(a,struct.pack('<I',v&0xffffffff))
read=lambda a:struct.unpack('<I',u.mem_read(a,4))[0]
def finish(pop=0):
 sp=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EIP,read(sp));u.reg_write(UC_X86_REG_ESP,sp+4+pop)
calls=[];visited=set()
def hook(uc,a,size,user):
 if a==callback:
  sp=u.reg_read(UC_X86_REG_ESP);args=list(struct.unpack('<7I',u.mem_read(sp+4,28)));assert args[0]==device
  calls.append(dict(count=args[1],rects=args[2],flags=args[3],argb=args[4],depth_bits=args[5],stencil=args[6]));u.reg_write(UC_X86_REG_EAX,0);finish(28);return
 if a==0xc975f5:finish();return
 assert any(lo<=a<hi for lo,hi in [(0x73c6c0,0x73c729),(0x987790,0x9877ef),(0x9c2510,0x9c2564),(0x9c57e0,0x9c5900)]),hex(a)
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
w(device,vt);w(vt+0xac,callback);w(backend,0x10e2f30);w(backend+0x14,device);w(renderer+0x14,backend);w(0x2d79078,renderer);w(0x2c,tls);w(tls,tls+0x100)
assert list(struct.unpack('<6I',u.mem_read(0x123fa78,24)))==[1,1,2,2,4,4]
assert struct.unpack('<f',u.mem_read(0x1139108,4))[0]==256.
settings=json.loads((r/'data/4.20/map_fog_settings.json').read_text());rgb=settings['native_fog_rgb'];opacity=float(settings['native_config']['opacity']);assert opacity==1.
cases=[]
for enabled,amount,color,secondary,mode in itertools.product([False,True],[0.,.125,.5,opacity],[rgb,[0,0,0],[255,255,255],[1,127,254]],[False,True],[False,True]):
 u.mem_write(0x14be79f,bytes([enabled]));u.mem_write(0x1224dad,bytes([mode]));u.mem_write(0x14beec0,struct.pack('<f',amount));u.mem_write(0x123f8e4,bytes([color[2],color[1],color[0],255]));w(renderer+0x18,backend if secondary else 0)
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_FPCW,0x37f);calls=[];u.emu_start(0x73c6c0,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
 computed=[((c*int(amount*256))>>8)&255 if enabled else 0 for c in color]
 expected=dict(count=0,rects=0,flags=3 if mode else 7,argb=(computed[0]<<16)|(computed[1]<<8)|computed[2],depth_bits=0x3f800000,stencil=0)
 assert calls==[expected]*(2 if secondary else 1),(enabled,amount,color,calls,expected)
 cases.append(dict(fog_enabled=enabled,opacity=amount,fog_rgb=color,secondary_backend=secondary,mode_byte=mode,clear_rgb=computed,calls=calls.copy()))
header=Path('C:/Program Files (x86)/Windows Kits/10/Include/10.0.26100.0/shared/d3d9.h');text=header.read_text(errors='replace');assert 'STDMETHOD(Clear)(THIS_ DWORD Count,CONST D3DRECT* pRects,DWORD Flags,D3DCOLOR Color,float Z,DWORD Stencil)' in text
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,source=source,native_sha256=hashlib.sha256(raw).hexdigest(),world_entry='0x73c6c0',color_helper='0x987790',renderer_clear='0x9c2510',d3d_clear_wrapper='0x9c57e0',renderer_vtable='0x10e2f30',renderer_clear_offset='0x30',d3d_clear_offset='0xac',native_addresses_executed=len(visited),cases=cases,map10_config=settings['native_config'],map10_rgb=rgb,map10_opacity=opacity,map10_expected_clear_rgb=rgb,header_source=str(header),header_sha256=hashlib.sha256(header.read_bytes()).hexdigest(),findings=['World clear computes fog RGB multiplied by trunc(f32(opacity*256)), then integer arithmetic shift8; disabled fog produces black.','Map10 config opacity1 gives exactly RGB34,62,84. Existing client clear RGB agrees with this isolated native world-clear path.','Therefore merely replacing cyan clear with black is not a source-qualified fix for the exposed base-Chaos background. Investigate missing/hidden background geometry, projection and render-pass composition.'],adapters=['Renderer globals, fog state and color supplied from Map10 config; full original config loader not executed.','Original renderer virtual dispatch, color helper, flag translation and D3D wrapper executed; D3D COM Clear callback records arguments and returns success.','Dummy TLS and device supplied; security cookie checker adapted. No original GPU rasterization or full render-pass execution.'],limits=['Actual map fog loader/color setter linkage and full frame composition remain unqualified.','No new graphical client screenshot or ordinary match qualification. Cyan holes remain open; this contract qualifies clear submission arguments only.'])
(r/'data/4.20/native_world_clear_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited),map10_clear_rgb=rgb,complete=False)))
