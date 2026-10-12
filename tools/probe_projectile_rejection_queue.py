from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projectile_team_visibility.py').read_text().split('\nrows=[]')[0],'setup','exec'))
pending=vector+0x1a000
stop_addresses={0x718032,0x7180ce}
def stop_hook(uc,a,size,user):
 if a in stop_addresses:uc.reg_write(UC_X86_REG_EIP,end);uc.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,stop_hook)
rows=[]
for accepted,registered in itertools.product([False,True],[False,True]):
 u.mem_write(wrapper,bytes(0x200));u.mem_write(wrapper+0xad,b'\1');w(wrapper+0xe4,0x2d628b8 if registered else 0)
 for a,v in [(0x2d62900,pending),(0x2d62904,pending),(0x2d62908,pending+64)]:w(a,v)
 snapshots=[]
 for repeat in range(2):
  u.reg_write(UC_X86_REG_EBX,wrapper);u.reg_write(UC_X86_REG_EAX,int(accepted));run(0x71800f,0,[])
  count=(read(0x2d62904)-pending)//4;active=int(u.mem_read(wrapper+0xad,1)[0])
  assert count==int(not accepted and registered) and active==int(accepted)
  if count:assert read(pending)==wrapper
  snapshots.append(dict(active=active,pending_count=count))
 # A revived active wrapper cancels its queued removal through the same original API.
 u.mem_write(wrapper+0xad,b'\1');run(0x7184b0,0x2d628b8,[wrapper]);assert read(0x2d62904)==pending
 rows.append(dict(accepted=accepted,registered=registered,repeat_snapshots=snapshots,reactivation_cancels_pending=True))
proof=dict(complete=False,passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['Native post-update rejection clearsAD and inserts into manager+48 pending removal vector through7184B0; no cleanup callback invoked in this branch.','Repeated rejection is deduplicated; marking active and calling7184B0 cancels pending removal.'],adapters=['Update return supplied at71800F; original rejection branch/search/insert/erase execute; spare vector capacity.'],limits=['Timing of7185D0 drain relative to particle frame and actual717AF0 cleanup remain unqualified.'])
(r/'data/4.20/projectile_rejection_queue_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS4 native rejection/queue/cancellation scenarios')
