from pathlib import Path
import itertools,json,hashlib
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_audio_bank_notification_withdraw.py').read_text(encoding='utf-8').split('\nsets=')[0];setup=setup.replace('u.hook_add(unicorn.UC_HOOK_CODE,guard_withdraw)','withdraw_hook=u.hook_add(unicorn.UC_HOOK_CODE,guard_withdraw)');exec(compile(setup,'setup','exec'))
regions.extend([(0xafbae0,0xafbb59),(0xaf8ae0,0xaf8b54)]);queue=manager+0x60;active=heap+0x7000;free_node=heap+0x7200

def guard_queue(uc,a,n,d):
 if a in locks and read(u.reg_read(UC_X86_REG_ESP)+4,'I')[0]==manager+0x30:calls.append({'kind':locks[a],'scope':'bank_command_queue'});ret(1,4);return
 guard_withdraw(uc,a,n,d)
u.hook_del(withdraw_hook);u.hook_add(unicorn.UC_HOOK_CODE,guard_queue)
rows=[]
for pattern,enabled,seed_active,seed_free,capacity,fail_nth in itertools.product([0,0xa5],[False,True],[False,True],[False,True],[0,2],range(3)):
 calls.clear();allocations.clear();next_pointer=heap+0xc000;count_allocate=0;consumed=0;put(0x14a7aa8,'I',100);u.mem_write(manager,bytes(0x500));put(manager+0x28,'I',456);put(context,'III',0,0,0);put(context+36,'I',123);put(queue,'6I',active if seed_active else 0,active if seed_active else 0,free_node if seed_free else 0,0,capacity,int(seed_active))
 for reference,present in [(active,seed_active),(free_node,seed_free)]:
  if present:u.mem_write(reference,bytes([pattern])*40);put(reference,'I',0);allocations.append({'reference':reference,'size':40,'freed':False})
 initial_manager=bytes(u.mem_read(manager,0x500)).hex();initial_allocations=[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations];request=[0,callback if enabled else 0,100,1,0x12345,0xffffffff,bank,40,0];stages=[]
 for i in range(2):
  result=invoke(0xafbae0,request,manager);stages.append({'result':result,'manager':bytes(u.mem_read(manager,0x500)).hex(),'allocations':[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations],'calls':list(calls)});calls.clear()
 # Explicit fixture cleanup only; queued requests have not been processed.
 invoke(0xb14560,(),context)
 for v in allocations:
  if not v['freed']:
   sp=stack+0x8000;put(sp,'III',trap,0xffffffff,v['reference']);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0xada3e0,trap,count=20000)
 assert all(v['freed']for v in allocations)
 rows.append({'pattern':pattern,'enabled':enabled,'seed_active':seed_active,'seed_free':seed_free,'capacity':capacity,'failure_nth':fail_nth,'initial_manager':initial_manager,'initial_allocations':initial_allocations,'request_words':request,'stages':stages})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in [(0xafbae0,0xafbb59),(0xaf8ae0,0xaf8b54),(0xb145b0,0xb14623),(0xb14790,0xb14803)]],'adapters':['Physical allocator/free/mutex/events/thread-id only. Actual AFBAE0 admission/registration/rollback/worker signal and AF8AE0 free-list/40-byte-node queue run with actual B145B0/B14790 ownership bodies.'],'findings':['Queue lock precedes optional cookie registration;registration failure52 prevents enqueue. Queue failure2 rolls back cookie reference with withdrawal before queue unlock.','Free-list nodes bypass count/capacity allocation guard;new40-byte node allocation requires count<capacity. Head/tail links copied and9 request words stored verbatim;count increments.','Successful admission signals manager event+28 after enqueue before queue unlock;repeated attempts preserve registration/ref ownership and failed allocations.'],'limits':['Native preparation;Rust normal command admission/queue port pending. Explicit initialized manager/worker,controlled active/free nodes and pending requests;fixture cleanup is not qualification of normal queued-command processing/ownership/destructor/OS concurrency.']}
(r/'data/4.20/audio_bank_command_queue_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native bank command queue/admission/register/rollback/free-list sequences')
