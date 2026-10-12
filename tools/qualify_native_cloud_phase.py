from pathlib import Path
import json,struct,datetime,itertools,hashlib
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0]
exec(compile(prefix,'original PE isolated mapping','exec'))
cloud=json.loads((r/'data/4.20/native_cloud_opacity_contract.json').read_text())
assert hashlib.sha256(raw).hexdigest()==cloud['native_sha256']
clock=vector+0x6000;clock_vt=vector+0x6100;clock_valid=end+0x10;clock_get=end+0x20;float_stub=end+0x30;float_cell=end+0x40
u.mem_write(float_stub,b'\xd9\x05'+struct.pack('<I',float_cell)+b'\xc3')
w(clock,clock_vt);w(clock_vt+0x20,clock_valid);w(clock_vt+8,clock_get);w(0x2d791a8,clock)
renderer=vector+0x7000;device=vector+0x7100;device_vt=vector+0x7200;constants=end+0x50;sampler=end+0x60
w(renderer+0x14,device);w(device,device_vt);w(device_vt+0x8c,constants);w(device_vt+0x70,sampler);w(0x2d79078,renderer)
deltas=[];events=[]
def f32(x):return struct.unpack('<f',struct.pack('<f',x))[0]
def f(a,x):u.mem_write(a,struct.pack('<f',x))
def bits(x):return struct.unpack('<I',struct.pack('<f',x))[0]
def hook_cloud(uc,a,size,user):
 visited.add(a);sp=uc.reg_read(UC_X86_REG_ESP)
 if a==clock_valid:finish(1);return
 if a==clock_get:
  f(float_cell,deltas.pop(0));uc.reg_write(UC_X86_REG_EIP,float_stub);return
 if a==constants:
  start,pointer,count=struct.unpack('<3I',uc.mem_read(sp+4,12));assert start==231 and count==1
  events.append(dict(kind='constants',register=start,values=list(struct.unpack('<4f',uc.mem_read(pointer,16)))));finish(0,12);return
 if a==sampler:
  events.append(dict(kind='sampler',args=list(struct.unpack('<3I',uc.mem_read(sp+4,12)))));finish(0,12);return
 if a==0x983cb0:
  events.append(dict(kind='texture',args=list(struct.unpack('<2I',uc.mem_read(sp+4,8)))));finish(0,8);return
 assert 0x73a710<=a<0x73a850 or 0x73a850<=a<0x73a923 or float_stub<=a<float_stub+7,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook_cloud)
def invoke(entry):
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(entry,end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==end
speed=f32(cloud['parameters']['SpeedU']);tile=cloud['parameters']['Tile'];wrap=struct.unpack_from('<f',image,0x1138fa8-base)[0];print(json.dumps(dict(native_wrap_threshold=wrap)),flush=True)
u.mem_write(0x1224dd8,b'\1');w(0x2d78c60,0x12345678)
f(0x14be7e0,tile);f(0x14be7d8,speed);f(0x14be7dc,speed)
cases=[]
for initial,dt,speed_case in itertools.product([0.,wrap-.001,wrap,wrap+.1,wrap*2.25,-.1],[0.,.016,1.,10.],[0.,speed,-speed]):
 initial=f32(initial);dt=f32(dt);dv=f32(dt/2);speed_case=f32(speed_case)
 f(0x2d78c5c,initial);f(0x2d78c58,-initial);f(0x14be7d8,speed_case);f(0x14be7dc,speed_case)
 deltas[:]=[dt,dv];invoke(0x73a710);assert not deltas
 actual=list(struct.unpack('<f',u.mem_read(0x2d78c5c,4)))+list(struct.unpack('<f',u.mem_read(0x2d78c58,4)))
 expected=[]
 for old,delta in [(initial,dt),(-initial,dv)]:
  v=f32(float(old)+float(delta)*float(speed_case));expected.append(f32(v-wrap) if v>wrap else v)
 assert [bits(v) for v in actual]==[bits(v) for v in expected],(initial,dt,speed_case,actual,expected)
 events.clear();invoke(0x73a850)
 assert events[0]['values']==[f32(1/tile),*actual,0.]
 assert events[1:]==[dict(kind='sampler',args=[7,0,0]),dict(kind='sampler',args=[7,1,0]),dict(kind='texture',args=[0x12345678,7])]
 cases.append(dict(initial=[initial,-initial],delta=[dt,dv],speed=[speed_case,speed_case],phase=actual,phase_bits=[bits(v) for v in actual],constants=events[0]['values']))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),phase_entry='0x73a710',binding_entry='0x73a850',cases=cases,case_count=len(cases),native_addresses=len(visited),wrap=wrap,strict_wrap=True,single_subtraction=True,source_cloud_contract='data/4.20/native_cloud_opacity_contract.json',
 adapters=['Clock object valid/getter virtuals supply two controlled f32 deltas through x87 FLD/RET; original multiplication, accumulation, rounding and wrap execute.',
 'Native c231 binding consumer executes. Renderer/device storage supplied, GPU constants/sampler/texture calls captured at boundaries. Texture creation bypassed through nonnull handle.'],
 limits=['Original delta provider/timing thread and complete clock implementation not executed.','Native s7 U/V requests0 map to D3D WRAP through previously qualified enum table; actual sampler filters, missing texture fallback and GPU renderer remain unqualified.','Cloud/high fog shader not integrated yet.'])
(r/'data/4.20/native_cloud_phase_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),strict_wrap=True,single_subtraction=True)))
