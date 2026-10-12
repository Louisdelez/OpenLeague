from pathlib import Path
import itertools,json,hashlib
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_audio_bank_notification.py').read_text(encoding='utf-8').split('\nrows=[]')[0];setup=setup.replace('u.hook_add(unicorn.UC_HOOK_CODE,guard_notification)','notification_hook=u.hook_add(unicorn.UC_HOOK_CODE,guard_notification)');exec(compile(setup,'notify_setup','exec'))
regions.extend([(0xb14560,0xb14623),(0xb146f0,0xb1478a),(0xb14810,0xb1489d)])
close_handle=read(0xfa4398,'I')[0];delete_cs=read(0xfa41bc,'I')[0]
def guard_registration(uc,a,n,d):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==close_handle:calls.append({'kind':'close_handle','handle':read(sp+4,'I')[0]});ret(1,4);return
 if a==delete_cs:calls.append({'kind':'delete_critical_section','reference':read(sp+4,'I')[0]});ret(0,4);return
 guard_notification(uc,a,n,d)
u.hook_del(notification_hook);u.hook_add(unicorn.UC_HOOK_CODE,guard_registration)
rows=[]
seeds=[(0,[]),(1,[(100,0xffffffff,3)]),(5,[(99,2,0),(100,2,1),(101,1,0)]),(5,[(99+i,1,0)for i in range(5)])]
for(seed_capacity,records),pattern,fail_nth in itertools.product(seeds,[0,0xa5,0xff],[0,1,2]):
 calls.clear();allocations.clear();next_pointer=heap+0xc000;count_allocate=0;consumed=0;u.mem_write(context,bytes([pattern])*40);put(context,'III',table_ref if seed_capacity else 0,len(records),seed_capacity);put(context+36,'I',123)
 if seed_capacity:
  u.mem_write(table_ref,bytes([pattern])*(seed_capacity*12));allocations.append({'reference':table_ref,'size':seed_capacity*12,'freed':False})
  for i,record in enumerate(records):put(table_ref+i*12,'3I',*record)
 initial_context=bytes(u.mem_read(context,40)).hex();initial_allocations=[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations];stages=[]
 def snapshot(stage,cookie,result):return {'stage':stage,'cookie':cookie,'result':result,'context':bytes(u.mem_read(context,40)).hex(),'allocations':[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations],'calls':list(calls)}
 for cookie in [100,100,101,102,103,104,105,106,0xffffffff,0,100]:
  result=invoke(0xb145b0,[cookie],context);stages.append(snapshot('register',cookie,result));calls.clear()
 invoke(0xb14560,(),context);stages.append(snapshot('destructor',0,0));assert all(v['freed']for v in allocations)
 rows.append({'pattern':pattern,'failure_nth':fail_nth,'initial_context':initial_context,'initial_allocations':initial_allocations,'stages':stages})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in [(0xb14560,0xb14623),(0xb146f0,0xb1478a),(0xb14810,0xb1489d)]],'adapters':['Only physical pool allocation/free,mutex,CloseHandle and DeleteCriticalSection. Actual B145B0 registration,B14810 insertion,B146F0 growth and B14560 destructor execute.'],'findings':['Existing first-match cookie increments refs with unsigned wrapping, preserving cancellation. New entries initialize refs1,cancellation0.','Capacity grows by5 records,allocating12 bytes per slot and copying active records only before freeing previous table. Failed allocation returns52 preserving storage.','Destructor frees table,zeros pointer/count/capacity when pointer nonzero,closes event and deletes mutex;raw handle remains unchanged.'],'limits':['Native preparation;Rust registration/growth/destructor pending. Explicit initialized context;OS constructor/concurrency/cancel-wait behavior and reentrant callbacks remain required.']}
(r/'data/4.20/audio_bank_notification_registration_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native bank notification producer/growth/destructor sequences')
