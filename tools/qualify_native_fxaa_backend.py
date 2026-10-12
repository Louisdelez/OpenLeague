from pathlib import Path
import json,struct,hashlib,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'native emulator base','exec'))
interface=vector+0x9000;device=vector+0xa000;vtable=vector+0xb000;d3d_call=end+0x100
w(interface+0x14,device);w(device,vtable);w(vtable+0x5c,d3d_call)
mode='assignment';events=[];visited=set()
def hook(uc,a,size,user):
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a==0x9c6070:
  args=[read(sp+4+i*4) for i in range(6)]
  events.append(dict(kind='bridge',device=uc.reg_read(UC_X86_REG_ECX),width=uc.reg_read(UC_X86_REG_EDX),args=args));finish(0);return
 if a==d3d_call:
  args=[read(sp+4+i*4) for i in range(9)]
  events.append(dict(kind='CreateTexture',args=args));finish(0,36);return
 ranges={'assignment':[(0x9c14a3,0x9c14a9)],'bridge':[(0x9c2d6b,0x9c2deb)],'wrapper':[(0x9c60a5,0x9c60c1)]}
 assert any(lo<=a<hi for lo,hi in ranges[mode]),(mode,hex(a));visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
u.reg_write(UC_X86_REG_EBX,interface);u.emu_start(0x9c14a3,0x9c14a9,count=5)
assert read(interface)==0x10e2f30 and read(read(interface)+0x60)==0x9c2d40
formats=[struct.unpack_from('<I',image,0x10e2b90-base+i*4)[0] for i in range(24)]
pools=[struct.unpack_from('<I',image,0x10e2c9c-base+i*4)[0] for i in range(4)]
usage_pairs=[(1,1),(2,2),(4,0x200),(8,8),(0x20,0x400)]
assert [(read(0x123ff68+i*8),read(0x123ff6c+i*8)) for i in range(5)]==usage_pairs
cases=[];width=1280;height=800;levels=1;bp=stack+0x100
for fmt,pool,usage in itertools.product(range(24),range(4),range(64)):
 mode='bridge';events.clear()
 for offset,value in [(8,width),(12,height),(16,levels),(20,usage),(24,fmt),(28,pool),(32,vector+0xc000)]:w(bp+offset,value)
 u.reg_write(UC_X86_REG_EBP,bp);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,interface)
 u.emu_start(0x9c2d6b,0x9c2deb,count=150)
 assert u.reg_read(UC_X86_REG_EIP)==0x9c2deb and u.reg_read(UC_X86_REG_ESP)==stack-28
 converted=0
 for mask,value in usage_pairs:
  if usage&mask:converted|=value
 out=events[0]['args'][-1]
 expected=dict(kind='bridge',device=device,width=width,args=[height,levels,converted,formats[fmt],pools[pool],out])
 assert events==[expected] and out==stack+12
 mode='wrapper';events.clear()
 for i,value in enumerate(expected['args']):w(bp+8+i*4,value)
 u.reg_write(UC_X86_REG_EBP,bp);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,device);u.reg_write(UC_X86_REG_EDX,width)
 u.emu_start(0x9c60a5,0x9c60c1,count=100)
 assert u.reg_read(UC_X86_REG_EIP)==0x9c60c1 and u.reg_read(UC_X86_REG_ESP)==stack
 request=[device,width,height,levels,converted,formats[fmt],pools[pool],out,0]
 assert events==[dict(kind='CreateTexture',args=request)]
 cases.append(dict(format_id=fmt,pool_id=pool,usage=usage,d3d_format=formats[fmt],d3d_pool=pools[pool],d3d_usage=converted,create_texture_args=request))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),vtable_assignment='0x9c14a3',vtable='0x10e2f30',slot60='0x9c2d40',bridge_prefix='0x9c2d6b',wrapper_prefix='0x9c60a5',format_table=formats,pool_table=pools,usage_pairs=usage_pairs,cases=cases,api_source='https://learn.microsoft.com/en-us/windows/win32/api/d3d9/nf-d3d9-idirect3ddevice9-createtexture',limits=['Original vtable assignment, format/pool/usage conversion prefix and D3D9 CreateTexture call prefix execute; COM call adapted and returned success.', 'Three native instruction segments exercised separately with supplied valid objects/stack frames. Constructor, full bridge result handling and real GPU allocation not executed.', '24 supplied format IDs and four native pool IDs are table mappings, not proof that the GPU supports every combination.', 'CreateTexture parameters do not establish global multisampling, presentation or depth-surface configuration.'])
(r/'data/4.20/native_fxaa_backend_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited))))
