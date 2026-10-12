from pathlib import Path
import json, struct, datetime, hashlib
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0]
exec(compile(prefix,'isolated native PE mapping','exec'))
u.mem_map(0,0x1000)
renderer=vector+0x7000; wrapper=vector+0x8000; table=vector+0x9000
device=vector+0xa000; device_table=vector+0xb000; tls=vector+0xc000
callback=end+0x100; constants=end+0x110
w(renderer+0x14,wrapper);w(wrapper,table);w(wrapper+0x14,device)
w(table+0x70,0x9c2270);w(table+0x8c,constants)
w(device,device_table);w(device_table+0x114,callback)
w(0x2d79078,renderer);w(0x2c,tls);w(tls,tls+0x100)
submissions=[];bindings=[]
ranges=[(0x981f39,0x981fee),(0x739c75,0x739cc9),(0x73a850,0x73a923),
        (0x9c2270,0x9c22a8),(0x9c1960,0x9c19bb),(0x9c5260,0x9c5372)]
def hook_sampler(uc,a,size,user):
 visited.add(a); sp=uc.reg_read(UC_X86_REG_ESP)
 if a==callback:
  args=list(struct.unpack('<4I',uc.mem_read(sp+4,16)));assert args[0]==device
  submissions.append(dict(stage=args[1],d3d_type=args[2],d3d_value=args[3]));finish(0,16);return
 if a==0xc975f5:finish(0);return
 if a==constants:
  register,pointer,count=struct.unpack('<3I',uc.mem_read(sp+4,12));assert register==231 and count==1
  bindings.append(dict(register=register,values=list(struct.unpack('<4f',uc.mem_read(pointer,16)))));finish(0,12);return
 if a==0x983cb0:
  texture,stage=struct.unpack('<2I',uc.mem_read(sp+4,8));bindings.append(dict(texture=texture,stage=stage));finish(0,8);return
 assert any(lo<=a<hi for lo,hi in ranges),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook_sampler)
def invoke(start,stop=end):
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EBX,renderer)
 u.emu_start(start,stop,count=100000);assert u.reg_read(UC_X86_REG_EIP)==stop
def cache(stage,kind):return wrapper+0x164+(stage*8+kind)*4
cases=[]
for sentinel in [0xffffffff,0x12345678]:
 for override in [False,True]:
  for stage in range(16):
   for kind in range(8):w(cache(stage,kind),sentinel)
  submissions.clear();invoke(0x981f39,0x981fee)
  expected=[dict(stage=s,d3d_type=k+1,d3d_value=2 if k in [4,5,6] else 1 if k in [0,1] else 0)
            for s in range(16) for k in [0,1,3,4,5,6,7]]
  assert submissions==expected
  bootstrap=list(submissions)
  if override:
   for kind in [4,5,6]:w(cache(7,kind),1)
  submissions.clear();invoke(0x739c75,0x739cc9)
  assert submissions==([dict(stage=7,d3d_type=k+1,d3d_value=2) for k in [4,5,6]] if override else [])
  restored=list(submissions)
  for stage in range(16):
   for kind in [4,5,6]:assert read(cache(stage,kind))==2
  for texture in [0,0x12345678]:
   # Force prior U/V clamp to exercise cloud binding through native enum mapper.
   for kind in [0,1]:w(cache(7,kind),2)
   u.mem_write(0x1224dd8,b'\1');w(0x2d78c60,texture);w(0x14bef38,0xabcdef)
   u.mem_write(0x14be7e0,struct.pack('<f',2000.));u.mem_write(0x2d78c5c,struct.pack('<f',.25));u.mem_write(0x2d78c58,struct.pack('<f',.5))
   submissions.clear();bindings.clear();invoke(0x73a850)
   assert submissions==[dict(stage=7,d3d_type=k+1,d3d_value=1) for k in [0,1]]
   assert bindings[-1]==dict(texture=texture or 0xabcdef,stage=7)
   assert [read(cache(7,k)) for k in [0,1,4,5,6]]==[0,0,2,2,2]
   cases.append(dict(initial_cache=sentinel,point_override=override,texture_present=bool(texture),
     bootstrap_submissions=bootstrap,world_restore_submissions=restored,cloud_submissions=list(submissions),
     bindings=list(bindings),final_s7_native_state=dict(address_u=0,address_v=0,mag=2,min=2,mip=2)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,
 native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),cases=cases,
 entries=dict(renderer_sampler_initialization=['0x981f39','0x981fee'],world_filter_reset=['0x739c75','0x739cc9'],cloud_binding='0x73a850',
 sampler_backend=['0x9c2270','0x9c1960','0x9c5260']),
 findings=['Native initialization sets linear MAG/MIN/MIP on all16 stages. Native world filter reset restores linear filters, including s7.',
 'Cloud binding sets s7 U/V WRAP and preserves filter values. Given this reset/binding sequence, s7 has linear MAG/MIN/MIP and WRAP U/V.',
 'Native backend cache elides repeated values; point overrides are restored. Cloud binding selects supplied fallback when cloud texture handle is null.'],
 adapters=['Enter initialization and world-reset sampler tails with preallocated renderer/device and stack; earlier function work omitted.',
 'COM SetSamplerState records arguments and returns S_OK; security cookie checker adapted; mapped TLS supplied.',
 'GPU constant upload and texture-binding function captured at boundary; nonnull fallback supplied.'],
 limits=['Original frame scheduling/order and sampler overrides between reset, binding and draws remain unqualified.',
 'Texture binding wrapper and physical GPU filtering not executed; fallback texture creation/content unqualified.',
 'This proves the controlled native reset/binding sequence, not the entire original frame or complete game.'])
(r/'data/4.20/native_cloud_sampler_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),s7_filter='linear',address='wrap',complete=False)))
