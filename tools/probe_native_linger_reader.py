from pathlib import Path
import struct,json,datetime
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_simple_cycle.py').read_text(encoding='utf-8').split('frames=[]')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook_cycle)','')
exec(compile(prefix,'native setup','exec'))
stub=heap+0x1f000;u.mem_write(stub,bytes.fromhex('d9442410c3')) # FLD [ESP+10]; RET, float-reader adapter
visited=set();calls=[];values=[None,None]
def reader_hook(uc,a,size,user):
 if a==0x8b1f50:
  sp=u.reg_read(UC_X86_REG_ESP);key=read32(sp+12);value=values[0 if key==0x10d74b0 else 1]
  default=floats(sp+16,1)[0]
  if value is not None:f(sp+16,value)
  calls.append(dict(key=hex(key),default=default,supplied=value));u.reg_write(UC_X86_REG_EIP,stub)
 elif a<heap:visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,reader_hook)
cases=[]
for supplied in [[None,None],[0.,None],[-1.,-1.],[10.,10.],[11.,11.],[.75,.5]]:
 values=supplied;calls=[];visited=set()
 sp=stack+0x8000;u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBX,definition);u.reg_write(UC_X86_REG_ECX,0);u.reg_write(UC_X86_REG_EDI,0);u.reg_write(UC_X86_REG_ESI,0)
 u.emu_start(0x91ef33,0x91efc9,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x91efc9
 cases.append(dict(supplied=supplied,particle_linger=floats(definition+0xa0,1)[0],emitter_linger=floats(definition+0xa4,1)[0],reader_calls=calls,original_instruction_addresses=len(visited)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),native_sha256=digest,complete=False,passed=True,entry='0x91ef33',stop='0x91efc9',cases=cases,adapters=['Float config reader8B1F50 returns authored value or exact native stack default via x87 FLD/RET stub.'],limits=['Original reader parsing internals not executed; native call-site defaults, field assignment and clamping executed.','Upstream owner-end flag and time producer remain unqualified.'])
(r/'data/4.20/simple_linger_defaults_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps(cases))
