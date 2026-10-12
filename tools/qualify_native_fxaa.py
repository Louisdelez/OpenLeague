from pathlib import Path
import json, struct, hashlib, datetime, itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0], 'native emulator base', 'exec'))
owner=vector+0x9000
sentinel=vector+0xa000
node=vector+0xb000
renderer=vector+0xc000
consumer=vector+0xd000
mode='default'
configured=0
requests=[]
calls=[]
visited=set()
def signed(v):return v if v<0x80000000 else v-0x100000000
def hook(uc,a,size,user):
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a==0x8b1c20:
  requests.append(dict(section=string(uc.reg_read(UC_X86_REG_ECX)),key=string(uc.reg_read(UC_X86_REG_EDX)),default=read(sp+4),flags=read(sp+8)))
  finish(configured);return
 if a==0x73d610:
  calls.append(dict(this=uc.reg_read(UC_X86_REG_ECX),argument=signed(read(sp+4))))
  finish(0,4);return
 ranges={'default':[(0x835e65,0x835e85)],'dispatch':[(0x8373d0,0x8373f5),(0x837837,0x83783c)],'consumer':[(0x73e177,0x73e19f),(0x835080,0x8350f1)]}
 assert any(lo<=a<hi for lo,hi in ranges[mode]),(mode,hex(a))
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
defaults=[]
for configured in [-2147483648,-1,0,1,2,3,4,5,2147483647]:
 requests.clear();u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EBP,stack+0x100)
 u.emu_start(0x835e65,0x835e85,count=100)
 expected=dict(section='Performance',key='EnableFXAA',default=0,flags=0)
 assert requests==[expected]
 assert read(stack+0x100-8)==23 and signed(read(stack+0x100-4))==configured
 defaults.append(dict(configured=configured,request=expected,stored_id=23,stored_value=configured))
mode='dispatch'
w(stack,end);w(stack+4,23);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner)
u.emu_start(0x8373d0,end,count=100)
assert u.reg_read(UC_X86_REG_EIP)==end
assert u.reg_read(UC_X86_REG_ESP)==stack+8
dispatch=dict(id=23,target='0x837837',immediate_callback=False,returned=True)
mode='consumer'
w(0x2d78568,owner);w(0x2d79078,renderer);w(owner+0x10,sentinel)
u.mem_write(sentinel,b'\0'*32);u.mem_write(sentinel+0xd,b'\1');w(sentinel+4,node)
u.mem_write(node,b'\0'*32);w(node,sentinel);w(node+8,sentinel);w(node+0x10,23)
cases=[]
for value,shader_cap in itertools.product([-2147483648,-1,0,1,2,3,2147483647],[0,0xffff0200,0xffff0300,0xffff0301]):
 w(node+0x14,value);w(renderer+0x78,shader_cap);calls.clear()
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EBX,consumer)
 u.emu_start(0x73e177,0x73e19f,count=300)
 assert u.reg_read(UC_X86_REG_EIP)==0x73e19f
 active=value>0 and shader_cap>=0xffff0300
 expected=[dict(this=consumer,argument=value)] if active else []
 assert calls==expected and u.reg_read(UC_X86_REG_ESP)==stack
 cases.append(dict(value=value,shader_cap=hex(shader_cap),invokes_fxaa=active,calls=list(calls)))
names=json.loads((r/'data/4.20/native_graphics_options_contract.json').read_text(encoding='utf-8'))['name_cases']
assert all(row['name']=='EnableFXAA' for row in names if row['id']==23)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),option=dict(id=23,section='Performance',key='EnableFXAA',default=0),defaults=defaults,dispatch=dispatch,consumer_entry='0x73e177',fxaa_entry='0x73d610',consumer_cases=cases,native_addresses=len(visited),limits=['Original initializer instructions, dispatcher return, integer tree getter and consumer gate executed in emulator.', 'Configuration return and valid one-node integer tree supplied; configuration persistence and full render frame not executed.', 'FXAA body is a recorded call boundary. Shader execution, render targets and multisampling configuration remain unqualified.', 'This contract does not establish original MSAA state and does not authorize changing the ordinary renderer MSAA choice.'])
out=r/'data/4.20/native_fxaa_option_contract.json'
out.write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(passed=True,default_cases=len(defaults),consumer_cases=len(cases),native_addresses=len(visited),option=proof['option'])))
