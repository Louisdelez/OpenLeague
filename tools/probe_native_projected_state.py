from pathlib import Path
import json,datetime,struct
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_simple_cycle.py').read_text(encoding='utf-8').split('frames=[]')[0]
exec(compile(prefix,'native setup','exec'))
renderer=heap+0x1b000;device=heap+0x1c000;vtable=heap+0x1d000;api=0xc9f39b
write32(0x2d79078,renderer);write32(0x2d794b0,device);write32(device,vtable);write32(vtable+0xe4,api)
u.mem_write(0x2d79470,b'\0');u.mem_write(0x14be79f,b'\0')
state_calls=[];cookie_calls=0
def state_hook(uc,a,size,user):
 global cookie_calls
 if a==api:
  pointer,key,value=[read32(u.reg_read(UC_X86_REG_ESP)+i) for i in [4,8,12]]
  assert pointer==device;state_calls.append([key,value]);finish(12,0)
 elif a==0xc975f5:cookie_calls+=1;finish()
u.hook_add(unicorn.UC_HOOK_CODE,state_hook)
cases=[]
for mode in range(5):
 for flags in range(256):
  for initial in [0,0x19000000]:
   state_calls.clear();write32(0x123ff20,initial);write32(0x123ff60,initial & 0x10000000)
   for offset in [0x123ff48,0x123ff4c,0x123ff50,0x123ff54,0x123ff58]:write32(offset,0xffffffff)
   write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,mode);u.reg_write(UC_X86_REG_EDX,flags)
   u.emu_start(0x932a60,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
   cases.append(dict(mode=mode,flags=flags,initial=initial,state_bits=read32(0x2d79074),blend_preset=read32(0x1225908),calls=list(state_calls),final_enable_bits=read32(0x123ff20),final_write_bits=read32(0x123ff60)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),native_sha256=digest,passed=True,complete=False,entry='0x932a60',original_instruction_addresses=len(visited-{api,0xc975f5}),runtime_adapters=['D3D9 SetRenderState API boundary records key/value and returns S_OK; no GPU executed.','Stack cookie check returns without comparison.'],definition_defaults={hex(off):read32(definition+off) for off in [0x20,0x24]},blend_selector_table=[read32(0x10e3248+i*4) for i in range(10)],blend_operation_table=[read32(0x10e27d0+i*4) for i in range(5)],cases=cases,limits=['Original routing/preset/state helper instructions execute; only external device boundary and cookie check are adapted.','Explicit D3D backend, state caches and flags supplied; global inherited Z compare, rasterizer and sampler setup not covered.','All flags tested but these flags are inputs, not a proof of all authored/runtime flag producers.'])
(r/'data/4.20/projected_render_state_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps({'cases':len(cases),'native_addresses':proof['original_instruction_addresses'],'defaults':proof['definition_defaults'],'base_mode0':next(c for c in cases if c['flags']==proof['definition_defaults']['0x24'] and c['mode']==proof['definition_defaults']['0x20'] and c['initial']==0)}))
