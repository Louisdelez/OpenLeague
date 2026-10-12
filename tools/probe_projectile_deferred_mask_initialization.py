from pathlib import Path
import json,hashlib
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projectile_team_visibility.py').read_text().split('\nrows=[]')[0],'setup','exec'))
observed=[]
def dispatch_hook(uc,a,size,user):
 if a in [0x6c9210,0x6153d0,0x5eb4b0]:observed.append(hex(a))
 if a==0x717f0a:uc.reg_write(UC_X86_REG_EIP,end);uc.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,dispatch_hook)
rows=[]
for pending in [False,True]:
 for initial in [0,1,2,3,0xffffffff]:
  u.mem_write(wrapper,b'\0'*0x200);w(wrapper,0x10a4960);w(wrapper+0x15c,initial);w(wrapper+0xb0,0x212|(0x100000 if pending else 0));w(vector+0x1a000,wrapper);u.reg_write(UC_X86_REG_ESI,vector+0x1a000);u.reg_write(UC_X86_REG_EBP,stack+0x100);observed=[]
  run(0x717ec0,0,[]);after=read(wrapper+0x15c);assert after==(0xffffffff if pending else initial);assert read(wrapper+0xb0)==0x212
  assert observed==(['0x6c9210','0x6153d0','0x5eb4b0'] if pending else [])
  rows.append(dict(pending=pending,initial_mask=initial,final_mask=after,callbacks=observed.copy()))
proof=dict(complete=False,passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['Factory7173D6 sets100000 after successful load.','Original registry block717EC0 tests/clears100000 then invokes44,50,54 in order.','Callback44 resets maskFFFFFFFF before subsequent callbacks. Without pending flag no reset occurs.'],adapters=['One supplied list entry; execution stops at717F0A before loop advancement.','Absent Troy resource; inherited bounds34 callback adapted. Registry membership and full frame loop not executed.'],limits=['Normal initialization mask now explained by deferred dispatch, not constructor.','Live-resource initialization, ownership and complete registry scheduling remain separate qualifications.'])
(r/'data/4.20/projectile_deferred_mask_initialization.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS10 deferred initialization cases')
