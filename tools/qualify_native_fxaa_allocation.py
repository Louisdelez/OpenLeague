from pathlib import Path
import json,struct,hashlib,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'native emulator base','exec'))
u.mem_map(0,0x1000)
renderer=0x41000000;u.mem_map(renderer,0x30000)
texture=vector+0x9000;device=vector+0xa000;vtable=vector+0xb000;create=end+0x100
w(0x2d79078,renderer);w(renderer+0x14,device);w(device,vtable);w(vtable+0x60,create)
mode='constructor';events=[];visited=set()
def hook(uc,a,size,user):
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a==0x9933e0:
  assert read(sp+4)==0x48;events.append(dict(kind='allocate',size=0x48));finish(texture);return
 if a==0x982c80:events.append(dict(kind='register',object=read(sp+4)));finish(0,4);return
 if a==0x988420 and mode=='constructor':
  assert uc.reg_read(UC_X86_REG_ECX)==texture;events.append(dict(kind='initialize',object=texture));finish(0);return
 if a==create:
  values=[read(sp+4+i*4) for i in range(7)]
  events.append(dict(kind='device_texture_request',device=uc.reg_read(UC_X86_REG_ECX),slot='0x60',args=values))
  w(values[-1],0);finish(0,28);return
 ranges={'constructor':[(0x985f01,0x985f34),(0x9882a0,0x98836d)],'request':[(0x988457,0x988510)]}
 assert any(lo<=a<hi for lo,hi in ranges[mode]),(mode,hex(a));visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
for width,height,fmt in itertools.product([640,1280,1920],[480,800,1080],[21,22]):
 mode='constructor';events.clear();bp=stack+0x100
 for offset,value in [(8,width),(12,height),(16,fmt),(24,0)]:w(bp+offset,value)
 u.reg_write(UC_X86_REG_EBP,bp);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EBX,fmt);u.reg_write(UC_X86_REG_ECX,0xabcdef)
 u.emu_start(0x985f01,0x985f34,count=250)
 assert u.reg_read(UC_X86_REG_EIP)==0x985f34 and u.reg_read(UC_X86_REG_ESP)==stack
 fields={hex(o):read(texture+o) for o in [0x18,0x1c,0x20,0x24,0x28,0x2c,0x30,0x34,0x38,0x3c,0x44]}
 assert fields=={'0x18':0,'0x1c':0,'0x20':0,'0x24':fmt,'0x28':0,'0x2c':1,'0x30':width,'0x34':height,'0x38':width,'0x3c':height,'0x44':0}
 constructor_events=list(events)
 mode='request';events.clear();u.reg_write(UC_X86_REG_EBX,texture);u.reg_write(UC_X86_REG_ECX,texture);u.reg_write(UC_X86_REG_ESP,stack)
 u.emu_start(0x988457,0x988510,count=100)
 assert u.reg_read(UC_X86_REG_EIP)==0x988510 and u.reg_read(UC_X86_REG_ESP)==stack
 expected=dict(kind='device_texture_request',device=device,slot='0x60',args=[width,height,1,1,fmt,0,texture+4])
 assert events==[expected]
 cases.append(dict(width=width,height=height,format=fmt,constructor_events=constructor_events,fields=fields,device_request=expected))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),acquisition_branch='0x985f01',constructor='0x9882a0',texture_request_prefix='0x988457',cases=cases,limits=['Original allocation branch, constructor initialization and device texture request prefix execute with controlled allocation/registration/device methods.', 'The virtual renderer interface at slot60 is not yet identified as a concrete D3D implementation. Request has seven arguments but this alone does not prove global MSAA state.', 'Empty-pool allocation branch only; cache reuse, allocation failure, real surface construction, clears and resource accounting remain unqualified.'])
(r/'data/4.20/native_fxaa_allocation_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited))))

