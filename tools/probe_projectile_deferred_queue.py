from pathlib import Path
import json,hashlib
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projectile_team_visibility.py').read_text().split('\nrows=[]')[0],'setup','exec'))
objects=[vector+0x1b000+i*0x300 for i in range(3)];source=vector+0x1a000;dest=vector+0x1a100;observed=[];inject=False;injected=False

def queue_hook(uc,a,size,user):
 global injected
 if a in [0x6c9210,0x6153d0,0x5eb4b0]:
  obj=u.reg_read(UC_X86_REG_ECX);observed.append([objects.index(obj),hex(a)])
  if a==0x6153d0 and inject and not injected:
   assert read(0x2d6290c)==read(0x2d62910),'pending queue must already be empty'
   w(source,objects[2]);w(0x2d62910,source+4);injected=True
 if a==0x717f26:uc.reg_write(UC_X86_REG_EIP,end);uc.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,queue_hook)
rows=[]
for order in [[0],[0,1],[1,0]]:
 for inject in [False,True]:
  for obj in objects:u.mem_write(obj,b'\0'*0x200);w(obj,0x10a4960);w(obj+0xb0,0x100212)
  for i,index in enumerate(order):w(source+4*i,objects[index])
  for address,value in [(0x2d6290c,source),(0x2d62910,source+4*len(order)),(0x2d62914,source+32),(0x2d7c3c0,dest),(0x2d7c3c4,dest),(0x2d7c3c8,dest+32)]:w(address,value)
  observed=[];injected=False;u.reg_write(UC_X86_REG_EBP,stack+0x100);run(0x717e70,0,[])
  expected_order=order+([2] if inject else []);expected=[[i,cb] for i in expected_order for cb in ['0x6c9210','0x6153d0','0x5eb4b0']]
  assert observed==expected,(order,inject,observed);assert read(0x2d62910)==source
  rows.append(dict(initial_order=order,injected_during_callback=inject,callbacks=observed.copy()))
proof=dict(complete=False,passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['Original64ADA0 copies pending pointers into work vector;6E3080 clears pending before callbacks.','Effects inserted during callback are handled in next batch of the SAME717DF0 processing call, after current batch.'],adapters=['Preallocated work/source vector capacity avoids allocation. Insertion simulated at callback50, as a controlled external event.','Absent resources; inherited bounds callback adapted. Entry717E70 stops before717F26 phase transition.'],limits=['Real enqueue API, reallocation, deletion and subsequent frame phases not covered.'])
(r/'data/4.20/projectile_deferred_queue_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS6 queue batching cases')
