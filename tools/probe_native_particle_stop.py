from pathlib import Path
import json,datetime
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_simple_cycle.py').read_text(encoding='utf-8').split('frames=[]')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook_cycle)','')
exec(compile(prefix,'native setup','exec'))
visited=set()
def stop_hook(uc,a,size,user):
 visited.add(a);assert any(lo<=a<hi for lo,hi in native_code_ranges),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,stop_hook)
cases=[]
for flags in range(256):
 for now in [10.5,12.]:
  write32(system+0x1dc,flags);f(system+0xa8,10.);f(system+0x148,9.)
  write32(sp,end);f(sp+4,now);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,system)
  u.emu_start(0x93fa10,0x93fa44,count=1000)
  expected=end if flags&0x40 else 0x93fa44
  assert u.reg_read(UC_X86_REG_EIP)==expected,(flags,hex(u.reg_read(UC_X86_REG_EIP)))
  cases.append(dict(initial_flags=flags,now=now,flags=u.mem_read(system+0x1dc,1)[0],system_start=floats(system+0xa8,1)[0],stop_time=floats(system+0x148,1)[0],returned=expected==end))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),native_sha256=digest,complete=False,passed=True,entry='0x93fa10',stop='0x93fa44 or return if already stopped',original_instruction_addresses=len(visited),runtime_adapters=[],cases=cases,limits=['First-stop probe ends after native field writes, before audio callback and manager bookkeeping.','Already-stopped branch runs full function through native return.','Caller request0x400 statically leads to93FA10; owner/missile request producer remains unqualified.'])
(r/'data/4.20/particle_stop_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'first':cases[0],'already_stopped':cases[128]}))
