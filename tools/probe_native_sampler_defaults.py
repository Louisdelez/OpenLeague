from pathlib import Path
import json,datetime
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_simple_cycle.py').read_text(encoding='utf-8').split('frames=[]')[0]
exec(compile(prefix,'native setup','exec'))
wrapper=heap+0x1b000;device=heap+0x1f000;vtable=heap+0x1f400;api=0xc9f39b
write32(wrapper+0x14,device);write32(device,vtable);write32(vtable+0x114,api)
write32(0x2c,heap+0x1f800);write32(heap+0x1f800,heap+0x1f900)
calls=[]
def sampler_hook(uc,a,size,user):
 if a==api:
  args=[read32(u.reg_read(UC_X86_REG_ESP)+i) for i in [4,8,12,16]]
  assert args[0]==device
  calls.append(args[1:]);finish(16,0)
u.hook_add(unicorn.UC_HOOK_CODE,sampler_hook)
defaults=[read32(0x10e2d34+4*i) for i in range(8)]
keys=[read32(0x10e2b6c+4*i) for i in range(8)]
cases=[]
for sentinel in [0,0xffffffff,0x12345678]:
 for stage in range(16):
  for key in range(8):write32(wrapper+0x164+(stage*8+key)*4,sentinel)
 calls.clear();write32(sp+0x14,wrapper)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBX,wrapper)
 u.emu_start(0x9c1cd8,0x9c1d62,count=100000)
 assert u.reg_read(UC_X86_REG_EIP)==0x9c1d62
 expected=[]
 for stage in range(16):
  for key,value in enumerate(defaults):
   mapped=read32((0x10e2bfc if key in [0,1,2] else 0x10e2c9c)+4*value) if key in [0,1,2,4,5,6] else value
   expected.append([stage,keys[key],mapped])
 assert calls==expected
 cached=[[read32(wrapper+0x164+(stage*8+key)*4) for key in range(8)] for stage in range(16)]
 assert cached==[defaults]*16
 cases.append(dict(initial_cache=sentinel,calls=list(calls),final_cached=cached))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x9c1cd8',stop='0x9c1d62',abstract_defaults=defaults,d3d_keys=keys,original_instruction_addresses=len(visited-{api}),cases=cases,runtime_adapters=['Original device-reset sampler tail entered with supplied wrapper/device, stack-local wrapper pointer and mapped TLS.','Only D3D SetSamplerState API boundary returns S_OK and records arguments.'],limits=['All16 stages/8keys are submitted unconditionally and cached, independent of prior cache.','Earlier reset operations, full constructor and later sampler mutations not executed; this proves reset defaults, not final grass draw filtering.','No original GPU execution; device-loss/failure path unqualified.'])
(r/'data/4.20/sampler_defaults_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),sampler_submissions=sum(len(c['calls']) for c in cases),defaults=defaults,keys=keys,stage0=calls[:8],native_addresses=proof['original_instruction_addresses'])))
