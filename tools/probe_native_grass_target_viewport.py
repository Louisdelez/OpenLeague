from pathlib import Path
import struct,json,hashlib,datetime,itertools
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_grass_quad.py').read_text(encoding='utf-8').split('u.hook_add(')[0]
exec(compile(prefix,'native setup','exec'))
u.mem_map(0,0x1000)
target=a+0x5000;device=a+0x36000;devicevt=a+0x37000;api=a+0x38000
w(0x2c,a+0x39000);w(a+0x39000,a+0x39100)
w(0x2d79078,manager);w(manager+0x14,driver);w(driver,vt);w(driver+0x14,device);w(device,devicevt);w(devicevt+0xbc,api)
w(vt+0xc8,callbacks+0xc8);w(vt+0xd0,callbacks+0xd0);w(vt+0xdc,0x9c3820)
assert read(0x10e2f30+0xdc)==0x9c3820
events=[];visited=set()
def capture(uc,addr,size,user):
 if addr in [callbacks+0xc8,callbacks+0xd0]:
  n=2 if addr==callbacks+0xc8 else 1;events.append(dict(slot=hex(addr-callbacks),arguments=args(n)));finish(n*4);return
 if addr==api:
  pointer,viewport=args(2);assert pointer==device
  events.append(dict(device_viewport_bits=list(struct.unpack('<6I',u.mem_read(viewport,24)))));finish(8);return
 if addr==0xc975f5:finish(value=u.reg_read(UC_X86_REG_EAX));return
 visited.add(addr)
u.hook_add(unicorn.UC_HOOK_CODE,capture);u.reg_write(UC_X86_REG_FPCW,0x037f)
matrices=json.loads((r/'data/4.20/grass_screen_matrix_contract.json').read_text(encoding='utf-8'))
lookup={(c['width'],c['height'],c['api_flag']):c['matrix_bits'] for c in matrices['cases']}
cases=[]
for size,slot,present,depth_mode,flag in itertools.product([(0,0),(1,1),(200,150),(803,607),(4294967295,4294967295)],[0,1],[False,True],[0,1,2],[0,1,2]):
 events=[];initial=matrices['cases'][0]['initial_bits'];u.mem_write(manager+0x244,struct.pack('<16I',*initial))
 w(manager+0x24,0xabcdef);w(manager+0x20,a+0x9000);w(manager+0x20328,2000);w(manager+0x2032c,1000)
 w(target+0x10,a+0x7000 if present else 0);w(target+0xc,a+0x8000);w(target+8,a+0x8100)
 w(target+0x20,0);w(target+0x18,int(depth_mode==1));w(target+0x1c,int(depth_mode==2));w(target+0x30,size[0]);w(target+0x34,size[1]);w(0x1225c58,flag)
 w(stack,end);w(stack+4,slot);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,target)
 u.emu_start(0x988870,end,count=2000);assert u.reg_read(UC_X86_REG_EIP)==end
 viewport=[e['device_viewport_bits'] for e in events if 'device_viewport_bits' in e]
 actual=list(struct.unpack('<16I',u.mem_read(manager+0x244,64)))
 update=present and slot==0
 assert viewport==([[0,0,*size,0,0x3f800000]] if update else [])
 assert actual==(lookup[(*size,flag)] if update else initial)
 assert [read(manager+0x20328),read(manager+0x2032c)]==(list(size) if update else [2000,1000])
 assert read(manager+0x24)==(target if update else 0xabcdef)
 cases.append(dict(size=size,slot=slot,texture_present=present,depth_mode=depth_mode,api_flag=flag,events=list(events),matrix_bits=actual,renderer_dimensions=[read(manager+0x20328),read(manager+0x2032c)]))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x988870',viewport_driver='0x9c3820 ->0x9c74c0 ->D3DSetViewport',original_instruction_addresses=len(visited),cases=cases,runtime_adapters=['Render-target and depth-surface driver virtualC8/D0record supplied handles; no real surface bind.','D3DSetViewport boundary records6DWORD viewport and returnsS_OK; securitycookie preserves return registers.','Explicit resource, wrapper/device/TLS prerequisites and x87CW037F.'],limits=['Normal2Dtarget path only; cubemap path and restore target unqualified.','Zero/huge dimensions execute only with successfulAPIadapter; realdevice validity/capability not claimed.','Original push->screenmatrix->viewport API routing verified, no originalGPU frame or liveactor/camera integration.'])
(r/'data/4.20/grass_target_viewport_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),viewport_submissions=sum(any('device_viewport_bits' in e for e in c['events']) for c in cases))))
