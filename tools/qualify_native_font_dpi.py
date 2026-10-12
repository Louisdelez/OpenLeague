from pathlib import Path
import json,datetime,hashlib,itertools,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'native font DPI prerequisites','exec'))
device=vector+0x6000;calls=[]
for slot,target in [(0xfa4630,vector+0x5100),(0xfa407c,vector+0x5110),(0xfa4068,vector+0x5120)]:w(slot,target)
def hook(uc,a,size,user):
 if a==vector+0x5100:
  assert read(uc.reg_read(UC_X86_REG_ESP)+4)==0;calls.append('GetDC');finish(device,4);return
 if a==vector+0x5110:
  sp=uc.reg_read(UC_X86_REG_ESP);assert read(sp+4)==device;index=read(sp+8);assert index in [88,90];calls.append(f'GetDeviceCaps{index}');finish(dpi_x if index==88 else dpi_y,8);return
 if a==vector+0x5120:
  assert read(uc.reg_read(UC_X86_REG_ESP)+4)==device;calls.append('DeleteDC');finish(1,4);return
 if a==0x8bda45:uc.reg_write(UC_X86_REG_EIP,end);return
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);cases=[]
for context,dpi_x,dpi_y in itertools.product([False,True],[0,72,96,144],[0,72,96,144]):
 calls.clear();w(0x2d78d90,int(context));w(0x2d7856c,device);w(0x14beb98,0xa5a5a5a5);w(0x14beb80,0xa5a5a5a5);w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EBP,stack+0x800);u.emu_start(0x8bd9e4,end,count=3000)
 assert u.reg_read(UC_X86_REG_EIP)==end;out=[read(0x14beb98),read(0x14beb80)];assert out==([dpi_x,dpi_y] if context else [100,100]);assert calls==(['GetDC','GetDeviceCaps88','GetDeviceCaps90','DeleteDC'] if context else [])
 cases.append(dict(context=context,supplied_dpi=[dpi_x,dpi_y],output_dpi=out,calls=list(calls)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x8bd9e4',stop='0x8bda45',case_count=len(cases),native_addresses=len(visited),cases=cases,limits=['Original branch selects100/100when supplied context is zero, otherwise stores supplied GetDeviceCaps88/90results including zeros. API boundaries adapted.','Original import cleanup is DeleteDC for borrowed GetDC result; OpenLeague will use ReleaseDC for that resource as explicit lifetime integration.','Original global2D78D90producer and actual native monitor/DPI awareness not qualified. Engine uses explicit window/desktop context.'])
(r/'data/4.20/native_font_dpi_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
destination=r/'tools'/Path(__file__).name
if destination.resolve()!=Path(__file__).resolve():shutil.copy2(Path(__file__),destination)
print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited))))
