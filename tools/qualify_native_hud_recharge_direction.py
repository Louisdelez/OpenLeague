from pathlib import Path
import struct,json,datetime,hashlib,math,shutil
exec(Path('E:/OpenLeague/tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0])
manager=vector+0x6000;device=vector+0x7000;packet=vector+0x8000;instance=vector+0x9000;vertex_cb=vector+0xa000;pixel_cb=vector+0xa100
w(0x2d79078,manager);w(manager+0x14,device);w(device,vt);w(vt+0x8c,vertex_cb);w(vt+0x98,pixel_cb);w(packet+0x1c,instance)
f=lambda a,x:u.mem_write(a,struct.pack('<f',x));rf=lambda a:struct.unpack('<f',u.mem_read(a,4))[0]
events=[];wrapped=None
def hook(uc,a,n,unused):
 global wrapped
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xca633a:u.reg_write(UC_X86_REG_EIP,0xca6344);return
 if a==0xc975f5:finish(0);return
 if a in [vertex_cb,pixel_cb]:
  assert read(sp+12)==1;values=struct.unpack('<4f',u.mem_read(read(sp+8),16));events.append(dict(kind='vertex' if a==vertex_cb else 'pixel',register=read(sp+4),values=list(values)));finish(0,12);return
 assert 0x9a0800<=a<=0x9a09d0 or 0xca6344<=a<=0xca6351,hex(a)
 if a==0x9a0858:wrapped=rf(u.reg_read(UC_X86_REG_EBP)-0x18)
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
tau=rf(0x1138f8c);cases=[]
inputs=[tau*i/64 for i in range(65)]+[-tau,-1.,tau*2,tau*120]
for angle in inputs:
 events.clear();wrapped=None;f(instance+0x14,angle)
 for i,v in enumerate([0.,0.,0.,0.,0.,0.,128./255.,180./255.]):f(instance+0x34+i*4,v)
 w(stack,end);w(stack+4,0);w(stack+8,packet);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0x9a0800,end,count=2000);assert u.reg_read(UC_X86_REG_EIP)==end
 assert [e['kind'] for e in events]==['vertex','pixel','pixel','pixel'] and [e['register'] for e in events]==[8,0,1,2] # native params then color0 and color1
 v=events[0]['values'];assert all(math.isfinite(x) for x in v) and v[3]==0. and v[2]>0
 assert abs(max(abs(v[0]),abs(v[1]))*v[2]-1)<1e-6
 cases.append(dict(angle=struct.unpack('<f',struct.pack('<f',angle))[0],wrapped=wrapped,events=list(events)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x9a0800',native_cases=len(cases),native_addresses=len(visited),cases=cases,constant_bits={hex(a):read(a) for a in [0x1138eac,0x1138f8c,0x1138d2c,0x1138c74,0x1138a48,0x1138b0c,0x1138a8c,0x1138ba0]},findings=['Original cooldown pre-draw executes native polynomial direction approximation, maximum-axis normalization, and vertex/pixel constant uploads. Device calls capture register8 vertex vector, register0 angle and register1/2 source colors.','Native Cooldown constructor9A04F0 binds UI\\Cooldown shaders and UI\\CooldownLine shaders; subsequent geometry9A0540 emits basequad plus indexed line strip with seven total vertices. Constructor/geometry inspected separately, not qualified here.'],limits=['CRT fmod wrapperCA633A bypassed to original finite x87FPREM fast pathCA6344..6351. CRT environment dispatch/error policies not qualified. Stack cookie adapted.','Inputs/instance, manager/device supplied; actual D3D9 draw, blend/renderstates, packet geometry and WGSL transport remain open. No original GPU pixel proof.'])
(r/'data/4.20/native_hud_recharge_direction_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,native_cases=len(cases))))
