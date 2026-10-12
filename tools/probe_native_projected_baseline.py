from pathlib import Path
import json,datetime,struct
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projected_sampler.py').read_text(encoding='utf-8').split('cases=[]')[0],'native setup','exec'))
state_api=0xc98528;write32(vtable+0xe4,state_api);write32(0x2d794b0,device);u.mem_write(0x2d79470,b'\0');u.mem_write(0x14be79f,b'\0');state_calls=[]
def capture_state(uc,a,size,user):
 if a==state_api:
  pointer,key,value=[read32(u.reg_read(UC_X86_REG_ESP)+i) for i in [4,8,12]]
  assert pointer==device;state_calls.append([key,value]);finish(12,0)
u.hook_add(unicorn.UC_HOOK_CODE,capture_state)
u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBX,wrapper);u.reg_write(UC_X86_REG_EDI,0);write32(sp+0xc,wrapper+0x100)
u.emu_start(0x9c1cb0,0x9c1cd8,count=100000);assert u.reg_read(UC_X86_REG_EIP)==0x9c1cd8
reset_calls=list(state_calls)
# Mirror the observed reset enable/write state in the higher-level state cache.
write32(0x123ff20,0x11000000);write32(0x123ff60,0x10000000)
def invoke(entry,ecx,edx=0,arg=None):
 write32(sp,end)
 if arg is not None:u.mem_write(sp+4,struct.pack('<f',arg))
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,ecx);u.reg_write(UC_X86_REG_EDX,edx);u.emu_start(entry,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
invoke(0x9abee0,0x1d000000);invoke(0x9ac1c0,0x10000000)
manager_calls=state_calls[len(reset_calls):]
for offset in [0x123ff48,0x123ff4c,0x123ff50,0x123ff54,0x123ff58]:write32(offset,0xffffffff)
invoke(0x932a60,read32(definition+0x20),read32(definition+0x24))
invoke(0x9abc90,0x4000000);invoke(0x9ac500,5,arg=floats(definition+0x2c,1)[0]*floats(0x1138a30,1)[0])
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),native_sha256=digest,passed=True,complete=False,reset_range=['0x9c1cb0','0x9c1cd8'],reset_calls=reset_calls,manager_calls=list(manager_calls),all_calls=state_calls,final_state=dict(state_calls),definition_alpha_reference=read32(definition+0x2c),original_instruction_addresses=len(visited-{api,state_api,0xc975f5}),runtime_adapters=['D3D9 device SetRenderState boundary returns S_OK and records values.','Stack-cookie check returns without comparison.'],limits=['Original reset loop, manager enable/write helpers and base projected setup helpers execute with explicit valid cache/device/TLS.','Higher-level enable/write cache seeded to match observed reset. Full interleaved world renderer and other state mutations not executed.','No native GPU acceptance; this qualifies baseline/inherited settings, not every frame or variant.'])
(r/'data/4.20/projected_baseline_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'reset':reset_calls,'final':proof['final_state'],'alpha_reference':proof['definition_alpha_reference'],'native_addresses':proof['original_instruction_addresses']}))
