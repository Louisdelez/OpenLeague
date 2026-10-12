from pathlib import Path
import itertools,json,hashlib
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_audio_bank_command_queue.py').read_text(encoding='utf-8').split('\nrows=[]')[0];setup=setup.replace('u.hook_add(unicorn.UC_HOOK_CODE,guard_queue)','queue_hook=u.hook_add(unicorn.UC_HOOK_CODE,guard_queue)');exec(compile(setup,'queue_setup','exec'))
regions.append((0xaf8c80,0xaf8ef1));wait_index=0

def guard_worker(uc,a,n,d):
 global wait_index
 if a==wait_api:
  handle,timeout=read(u.reg_read(UC_X86_REG_ESP)+4,'II');wait_index+=1;stop=wait_index==2
  if stop:u.mem_write(manager+0x2c,b'\x01')
  calls.append({'kind':'wait_event','handle':handle,'timeout':timeout,'stop_published':stop});ret(0,8);return
 guard_queue(uc,a,n,d)
u.hook_del(queue_hook);u.hook_add(unicorn.UC_HOOK_CODE,guard_worker)
caller=json.loads((r/'data/4.20/audio_bank_caller_contract.json').read_text(encoding='utf-8'));source=caller['source'];original=Path(source['bank_path']).read_bytes();assert hashlib.sha256(original).hexdigest()==source['bank_sha256'];packets={v['packet']:v['bank_payload']for v in caller['cases']};bank_id=int.from_bytes(original[12:16],'little');rows=[]
for(packet,payload),pattern,enabled,preallocated,fail_nth in itertools.product(packets.items(),[0,0xa5],[False,True],[False,True],range(8)):
 data=bytes.fromhex(payload);calls.clear();allocations.clear();next_pointer=heap+0xc000;count_allocate=0;consumed=0;wait_index=0;put(0x14a7aa8,'I',100);u.mem_write(manager,bytes(0x500));put(manager+0x28,'I',456);u.mem_write(manager+0x7c,b'\x01');put(context,'III',0,0,0);put(context+36,'I',123);put(queue,'6I',0,0,free_node if preallocated else 0,int(preallocated),2,0);put(manager+0x78,'I',free_node if preallocated else 0)
 if preallocated:u.mem_write(free_node,bytes([pattern])*40);put(free_node,'I',0);allocations.append({'reference':free_node,'size':40,'freed':False})
 u.mem_write(registries,bytes(0x2600));u.mem_write(bank,data);request=[0,callback if enabled else 0,100,1,bank_id,0xffffffff,bank,len(data),0];initial_manager=bytes(u.mem_read(manager,0x500)).hex();initial_allocations=[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations];stages=[]
 def snapshot(stage,result):return {'stage':stage,'result':result,'manager':bytes(u.mem_read(manager,0x500)).hex(),'worker_thread':read(0x14a7aa8,'I')[0],'custom_count':read(registries+0x1f40+0x31c,'I')[0],'shared_count':read(registries+0x1c20+0x31c,'I')[0],'allocations':[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations],'calls':list(calls)}
 for i in range(2):
  result=invoke(0xafbae0,request,manager);stages.append(snapshot('admit',result));calls.clear()
 result=invoke(0xaf8c80,[manager]);assert result==0 and wait_index==2;stages.append(snapshot('worker',result));calls.clear()
 reference=read(cache+((bank_id+bank)&0xffffffff)%31*4,'I')[0]
 if reference:invoke(0xb21aa0,[bank_id,bank],cache);invoke(0xafc410,(),reference);invoke(0xafbfd0,[1],reference)
 invoke(0xb14560,(),context)
 for v in allocations:
  if not v['freed']:
   assert preallocated and v['reference']==free_node
   sp=stack+0x8000;put(sp,'III',trap,0xffffffff,v['reference']);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0xada3e0,trap,count=20000)
 stages.append(snapshot('final_fixture_cleanup',0));assert all(v['freed']for v in allocations)
 rows.append({'packet':packet,'pattern':pattern,'enabled':enabled,'preallocated':preallocated,'failure_nth':fail_nth,'bank_payload':payload,'request_words':request,'initial_manager':initial_manager,'initial_allocations':initial_allocations,'stages':stages})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'source':source,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in [(0xaf8c80,0xaf8ef1),(0xafbae0,0xafbb59),(0xaf8ae0,0xaf8b54),(0xaf9d40,0xaf9e0d)]],'adapters':['Only physical allocator/free/mutex/memcpy/atomics/events/thread-id/user callback. Wait boundary publishes external stop flag on second wait for deterministic fixture shutdown;actual AF8C80 worker admission/pop/command0 dispatch/caller/source/notification ownership execute.'],'findings':['Worker publishes current thread,waits manager event,locks queue,copies9 request words,unlinks head and clears tail for last node.','Node inside manager arena[78,78+6C*40) returns to free list;other nodes physically freed before command dispatch. Active count decrements before unlock.','Normal command0 dispatch executes actual AF9D40 reader/caller/nonzero completion. Worker drains all queued commands under individual pop locks then unlocks/waits again;external stop flag leads normal return0.'],'limits':['Native preparation;Rust worker/dequeue/normal queued loading composition pending. Controlled memory command0/effect-only banks,scope7C1/empty media and explicit event success;OS threads/concurrency/reentrancy/all commands/full banks/audible acceptance remain required.','Final explicit bank unlink/unload/destruction and arena fixture free do not qualify whole worker/manager shutdown/destructor lifecycle.']}
(r/'data/4.20/audio_bank_command_worker_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native actual bank worker admission/dequeue/dispatch/notification/lifetime sequences')
