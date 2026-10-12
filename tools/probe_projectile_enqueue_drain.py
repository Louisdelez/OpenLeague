from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projectile_team_visibility.py').read_text().split('\nrows=[]')[0],'setup','exec'))
source=vector+0x1a000;dest=vector+0x1a100
objects=[vector+0x1b000+i*0x300 for i in range(4)]
phase='enqueue';pause=False;injected=False;inject=False;observed=[]
def hook(uc,a,size,user):
 global pause
 if phase=='enqueue' and a==0x717a31:uc.reg_write(UC_X86_REG_EIP,end);uc.emu_stop()
 if phase=='drain':
  if a==0x6153d0 and inject and not injected:
   pause=True;uc.emu_stop();return
  if a in [0x6c9210,0x6153d0,0x5eb4b0]:observed.append([objects.index(uc.reg_read(UC_X86_REG_ECX)),hex(a)])
  if a==0x717f26:uc.reg_write(UC_X86_REG_EIP,end);uc.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def enqueue(index):
 global phase
 phase='enqueue';u.reg_write(UC_X86_REG_EBP,stack+0x2000);w(stack+0x2008,objects[index]);run(0x7179f6,0,[])
rows=[]
for order,inject in itertools.product([[0],[2,0,1],[1,2,0],[2,0,2,1,0]],[False,True]):
 for obj in objects:u.mem_write(obj,b'\0'*0x200);w(obj,0x10a4960);w(obj+0xb0,0x100212)
 for address,value in [(0x2d6290c,source),(0x2d62910,source),(0x2d62914,source+64),(0x2d7c3c0,dest),(0x2d7c3c4,dest),(0x2d7c3c8,dest+64)]:w(address,value)
 for index in order:enqueue(index)
 observed=[];injected=False;pause=False;phase='drain'
 u.reg_write(UC_X86_REG_EBP,stack+0x100)
 # run() expects terminal sentinel, so drive the original entry directly for callback pause.
 u.mem_write(stack-0x1000,b'\0'*0x2000);w(stack,end);u.reg_write(UC_X86_REG_ESP,stack)
 u.emu_start(0x717e70,end,count=200000)
 if pause:
  assert read(0x2d62910)==source
  context=u.context_save();saved=bytes(u.mem_read(stack-0x1000,0x4000))
  enqueue(3);enqueue(3)
  u.mem_write(stack-0x1000,saved);u.context_restore(context)
  injected=True;phase='drain';u.emu_start(u.reg_read(UC_X86_REG_EIP),end,count=200000)
 assert u.reg_read(UC_X86_REG_EIP)==end
 expected_order=sorted(set(order))+([3] if inject else [])
 expected=[[i,cb] for i in expected_order for cb in ['0x6c9210','0x6153d0','0x5eb4b0']]
 assert observed==expected,(order,inject,observed)
 assert read(0x2d62910)==source
 rows.append(dict(insertion_order=order,duplicate_injection_during_callback=inject,callbacks=observed.copy()))
proof=dict(complete=False,passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['Native enqueue and drain composed: unique pointer order, callbacks44/50/54 exactly once per pending object.','Duplicate native insertion during callback is deduplicated and processed after current batch within same drain.'],adapters=['Callback paused to execute native enqueue block with saved CPU context and stack, then resumed.','Preallocated vectors; absent resource; inherited bounds adapter.'],limits=['Full registration, reallocations, destruction, real renderer and client integration remain unqualified.'])
(r/'data/4.20/projectile_enqueue_drain_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print('PASS8 composed native enqueue/drain scenarios')
