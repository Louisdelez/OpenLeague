from pathlib import Path
import json,hashlib,datetime,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_hud_formatted_scanner.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'native font sampler prerequisites','exec'))
device=vector+0x6000;vtable=vector+0x6100;tls=vector+0x6300;tls_value=vector+0x6400;events=[]
def hook(uc,a,size,user):
 if a==vector+0x5000:
  sp=uc.reg_read(UC_X86_REG_ESP);args=[read(sp+4+i*4) for i in range(4)];assert args[0]==device;events.append(args[1:]);finish(0,16);return
 scanner_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(device,vtable);w(vtable+0x114,vector+0x5000);w(0x2c,tls);w(tls,tls_value);w(tls_value+4,1)
cases=[]
for name,stages in [('fill_outline',[(0,1),(1,2)]),('glow',[(0,2)])]:
 for stage,value in stages:
  for state in [4,5,6]:
   events.clear();calls.clear();w(stack,end);w(stack+4,state);w(stack+8,value);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,device);u.reg_write(UC_X86_REG_EDX,stage);u.emu_start(0x9c1960,end,count=1000)
   assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==stack+4 and events==[[stage,state+1,value]]
   cases.append({'pass':name,'stage':stage,'native_state':state,'native_value':value,'d3d_calls':list(events)})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'entry':'0x9c1960','d3d_wrapper':'0x9c5260','native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(cases),'native_addresses':len(visited),'cases':cases,'native_draw_sites_static':['0x8bec48..0x8becd4','0x8bedb6..0x8bedf7'],'findings':['Font fill/outline stage0 uses point min/mag/mip filters; fill texture stage1 uses linear min/mag/mip.','Glow stage0 uses linear min/mag/mip filters. Native states4/5/6 map to D3DSAMP_MAGFILTER5/MINFILTER6/MIPFILTER7, nativevalues1/2 map to point1/linear2.'],'limits':['Mapping and D3D wrapper execute with supplied successful SetSamplerState virtual provider/device/TLS. Full draw-site calls identified statically; native state/cache producer, UV interpolation, address/gamma/filter precision and final framebuffer remain open.']}
(r/'data/4.20/native_font_sampler_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path('E:/mapslol3v3/qualify_native_font_sampler.py'),r/'tools/qualify_native_font_sampler.py');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'passed':True}))
