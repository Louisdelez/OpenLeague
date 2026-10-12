from pathlib import Path
import json,hashlib
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projectile_team_visibility.py').read_text().split('\nrows=[]')[0],'setup','exec'))
source=vector+0x1a000
objects=[vector+0x1b000+i*0x300 for i in range(3)]
def stop(uc,a,size,user):
 if a==0x717a31:uc.reg_write(UC_X86_REG_EIP,end);uc.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,stop)
rows=[]
for order in [[0],[0,1,2],[2,1,0],[1,0,2],[2,0,2,1,0]]:
 w(0x2d6290c,source);w(0x2d62910,source);w(0x2d62914,source+64)
 snapshots=[]
 for index in order:
  u.reg_write(UC_X86_REG_EBP,stack+0x2000);w(stack+0x2008,objects[index])
  run(0x7179f6,0,[])
  actual=[read(a) for a in range(source,read(0x2d62910),4)]
  expected=sorted(set(objects[i] for i in order[:len(snapshots)+1]))
  assert actual==expected,(order,index,actual,expected)
  snapshots.append([objects.index(a) for a in actual])
 rows.append(dict(insertion_order=order,snapshots=snapshots))
proof=dict(complete=False,passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['Registration717970 inserts into pending initialization vector at7179F6 through original735880 search and6B6530 insertion.','Pending entries are unique and sorted by unsigned object address, not insertion order.','718540 handles bit100 membership, not bit100000 initialization enqueue.'],limits=['Registration prefix and suffix excluded. Capacity preallocated; reallocation untested. No full game execution.'])
(r/'data/4.20/projectile_native_enqueue_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print('PASS native enqueue:5 sequences; sorted unique pointers')
