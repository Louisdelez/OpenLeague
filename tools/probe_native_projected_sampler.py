from pathlib import Path
import json,datetime,struct
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_simple_cycle.py').read_text(encoding='utf-8').split('frames=[]')[0]
exec(compile(prefix,'native setup','exec'))
renderer=heap+0x1b000;wrapper=heap+0x1c000;device=heap+0x1d000;vtable=heap+0x1e000;api=0xc9f39b
write32(0x2d79078,renderer);write32(renderer+0x14,wrapper);write32(wrapper,0x10e2f30);write32(wrapper+0x14,device);write32(device,vtable);write32(vtable+0x114,api)
assert read32(0x10e2f30+0x70)==0x9c2270
# Native successful HRESULT path writes its ordinary TLS status fields.
write32(0x2c,heap+0x1f100);write32(heap+0x1f100,heap+0x1f200)
calls=[]
def sampler_hook(uc,a,size,user):
 if a==api:
  pointer,stage,key,value=[read32(u.reg_read(UC_X86_REG_ESP)+i) for i in [4,8,12,16]]
  assert pointer==device;calls.append([stage,key,value]);finish(16,0)
 elif a==0xc975f5:finish()
u.hook_add(unicorn.UC_HOOK_CODE,sampler_hook)
cases=[]
for cached in [0xffffffff,2,0]:
 for stage in range(3):
  for key in range(2):write32(wrapper+0x164+(stage*8+key)*4,cached)
 calls.clear();u.reg_write(UC_X86_REG_ESP,sp)
 u.emu_start(0x9310b5,0x93115c,count=100000);assert u.reg_read(UC_X86_REG_EIP)==0x93115c
 cases.append(dict(initial_cached=cached,calls=list(calls),final_cached=[[read32(wrapper+0x164+(stage*8+key)*4) for key in range(2)] for stage in range(3)]))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),native_sha256=digest,passed=True,complete=False,entry='0x9310b5',stop='0x93115c',wrapper_vtable='0x10e2f30',virtual70='0x9c2270',translation='0x9c1960',external_wrapper='0x9c5260',original_instruction_addresses=len(visited-{api,0xc975f5}),runtime_adapters=['D3D9 SetSamplerState API boundary records stage/key/value and returns S_OK.','Stack-cookie check returns without comparison.'],cases=cases,limits=['Original projected sampler setup and virtual dispatch/translation/TLS successful HRESULT path execute. Explicit valid wrapper/device/TLS/cache prerequisites supplied.','This qualifies U/V CLAMP for stages0/1/2, not filtering, mip generation, anisotropy, LOD, color-space or other shader variants.','No GPU executed in this probe.'])
(r/'data/4.20/projected_sampler_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'cases':len(cases),'native_addresses':proof['original_instruction_addresses'],'calls':[c['calls'] for c in cases]}))
