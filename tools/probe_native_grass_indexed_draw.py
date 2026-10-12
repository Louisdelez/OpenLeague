from pathlib import Path
import json,struct,hashlib,datetime
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_grass_quad.py').read_text(encoding='utf-8').split('u.hook_add(')[0]
exec(compile(prefix,'native setup','exec'));u.mem_map(0,0x1000)
device=a+0x36000;devicevt=a+0x37000;api=a+0x38000
w(driver+0x14,device);w(device,devicevt);w(devicevt+0x148,api);w(0x2c,a+0x39000);w(a+0x39000,a+0x39100)
visited=set();calls=[]
def capture(uc,addr,size,user):
 if addr==api:
  values=args(7);assert values[0]==device;calls.append(values[1:]);finish(28);return
 if addr==0xc975f5:finish(value=u.reg_read(UC_X86_REG_EAX));return
 visited.add(addr)
u.hook_add(unicorn.UC_HOOK_CODE,capture)
frame=stack+0x100;cases=[]
for base_vertex in [0,1,0xffffffff]:
 for start_index in [0,3]:
  calls=[]
  values=[1,base_vertex,0,4,start_index,2]
  for i,v in enumerate(values):w(frame+8+i*4,v)
  u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ESI,driver)
  u.emu_start(0x9c2435,0x9c2456,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x9c2456
  assert calls==[[5,*values[1:]]]
  cases.append(dict(abstract_arguments=values,device_arguments=calls[0]))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x9c2435',stop='0x9c2456',original_instruction_addresses=len(visited),cases=cases,runtime_adapters=['Entered native draw dispatch after earlierstateflush with supplied frame/wrapper/device/TLS; only actualD3DDrawIndexedPrimitive API boundary returnsS_OK.'],limits=['Draw argument translation/routing qualified, not earlierstateflush, actualbufferbinding/declaration ororiginalGPU pixels.'])
(r/'data/4.20/grass_indexed_draw_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),quad_device_arguments=cases[0]['device_arguments'])))
