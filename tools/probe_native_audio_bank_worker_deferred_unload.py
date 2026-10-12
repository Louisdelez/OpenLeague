from pathlib import Path
import json,hashlib
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_audio_common_queue.py').read_text(encoding='utf-8').split('\nfor pattern,')[0];setup=setup.replace('u.hook_add(unicorn.UC_HOOK_CODE,guard_ring)','ring_hook=u.hook_add(unicorn.UC_HOOK_CODE,guard_ring)');exec(compile(setup,'setup','exec'))
consumer_regions=[(0xb06c60,0xb07d78),(0xb054d0,0xb05541),(0xb20e90,0xb20e9e)];regions.extend(consumer_regions);wait_count=0

def guard_retry(uc,a,n,d):
 global wait_count
 if a==wait_api:
  sp=u.reg_read(UC_X86_REG_ESP);handle,timeout=read(sp+4,'II');calls.append({'kind':'wait_event','handle':handle,'timeout':timeout});wait_count+=1;assert wait_count==1
  saved=u.context_save();sp2=stack+0x4000;put(sp2,'I',trap);u.reg_write(UC_X86_REG_ESP,sp2);u.reg_write(UC_X86_REG_ECX,common);u.emu_start(0xb06c60,trap,count=200000);assert u.reg_read(UC_X86_REG_EIP)==trap;result=u.reg_read(UC_X86_REG_EAX);assert result==1;calls.append({'kind':'native_consumer_return','result':result});u.context_restore(saved);ret(0,8);return
 if any(start<=a<end for start,end in consumer_regions):return
 guard_ring(uc,a,n,d)
u.hook_del(ring_hook);retry_hook=u.hook_add(unicorn.UC_HOOK_CODE,guard_retry)
extra=[(0xaf9900,0xaf994f),(0xafcde0,0xafceb0),(0xaf4290,0xaf42e0),(0xb0f7a0,0xb0f8b0),(0x83bb30,0x83bb36),(0xaeb000,0xaeb00b),(0xb08440,0xb084b1),(0xafcec0,0xafcf00)];regions.extend(extra)
def guard_unload(uc,a,n,d):
 if any(lo<=a<hi for lo,hi in extra):return
 guard_retry(uc,a,n,d)
u.hook_del(retry_hook);unload_hook=u.hook_add(unicorn.UC_HOOK_CODE,guard_unload)
def guard_full_worker(uc,a,n,d):
 if a==wait_api and read(u.reg_read(UC_X86_REG_ESP)+4,'I')[0]==456:guard_worker(uc,a,n,d);return
 guard_unload(uc,a,n,d)
u.hook_del(unload_hook);u.hook_add(unicorn.UC_HOOK_CODE,guard_full_worker)
caller=json.loads((r/'data/4.20/audio_bank_caller_contract.json').read_text(encoding='utf-8'));source=caller['source'];original=Path(source['bank_path']).read_bytes();assert hashlib.sha256(original).hexdigest()==source['bank_sha256'];bank_id=int.from_bytes(original[12:16],'little');payloads={v['packet']:v['bank_payload']for v in caller['cases']if v['packet']in['header_only','one','both']};rows=[]
for(packet,payload),pattern,enabled,preallocated,page_size in __import__('itertools').product(payloads.items(),[0,0xa5],[False,True],[False,True],[64,2048]):
 data=bytes.fromhex(payload);fail_nth=0;calls.clear();allocations.clear();next_pointer=heap+0xc000;count_allocate=0;consumed=0;wait_index=0;wait_count=0;put(0x12101bc,'I',page_size);put(0x14a7aa8,'I',100);u.mem_write(manager,bytes(0x500));put(manager+0x28,'I',456);u.mem_write(manager+0x7c,b'\x01');u.mem_write(registries,bytes(0x2600));u.mem_write(bank,data);put(context+36,'I',123);put(queue,'6I',0,0,free_node if preallocated else 0,int(preallocated),2,0);put(manager+0x78,'I',free_node if preallocated else 0)
 if preallocated:u.mem_write(free_node,bytes([pattern])*40);put(free_node,'I',0);allocations.append({'reference':free_node,'size':40,'freed':False})
 u.mem_write(common,bytes(0xa4));put(ring,'8I',table_ref,2,2,2,0,0,0,0);put(common+0x88,'I',789);put(common+0x90,'I',321);put(0x14a7a28,'I',common);put(0x14a7a74,'I',0);put(0x14a7d58,'II',0,0);put(0x14a7cf8,'II',0,0);put(0x14a82e0,'I',0);u.mem_write(table_ref,bytes(16));pages=[heap+0xa000,heap+0xb000]
 for i,page in enumerate(pages):u.mem_write(page,bytes([pattern])*page_size);put(table_ref+i*8,'II',page,0)
 request=[0,callback if enabled else 0,100,1,bank_id,0xffffffff,bank,len(data),0]
 def snapshot(stage,result):
  return {'stage':stage,'result':result,'manager':bytes(u.mem_read(manager,0x500)).hex(),'worker_thread':read(0x14a7aa8,'I')[0],'common':bytes(u.mem_read(common,0x98)).hex(),'common_table':bytes(u.mem_read(table_ref,16)).hex(),'pages':[bytes(u.mem_read(page,page_size)).hex()for page in pages],'processed':read(0x14a82e0,'I')[0],'custom_count':read(registries+0x1f40+0x31c,'I')[0],'shared_count':read(registries+0x1c20+0x31c,'I')[0],'allocations':[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations],'calls':list(calls)}
 stages=[snapshot('initial',0)];calls.clear();result=invoke(0xafbae0,request,manager);assert result==1;stages.append(snapshot('admit_load',result));calls.clear();unload=request.copy();unload[0]=1;result=invoke(0xafbae0,unload,manager);assert result==1;stages.append(snapshot('admit_unload',result));calls.clear();result=invoke(0xaf8c80,[manager]);assert result==0 and wait_index==2;stages.append(snapshot('worker_load_then_deferred_unload',result));calls.clear();result=invoke(0xb06c60,(),common);assert result==1 and read(0x14a82e0,'I')[0]==2;stages.append(snapshot('common_consumer_release_frame_callback',result));calls.clear();invoke(0xb14560,(),context)
 for v in allocations:
  if not v['freed']:
   sp=stack+0x8000;put(sp,'III',trap,0xffffffff,v['reference']);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0xada3e0,trap,count=20000)
 assert all(v['freed']for v in allocations);stages.append(snapshot('fixture_arena_and_notification_cleanup',0));rows.append({'pattern':pattern,'packet':packet,'preallocated':preallocated,'page_size':page_size,'bank_payload':payload,'request':request,'stages':stages})
proof={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(b).hexdigest(),'source':source,'cases':rows,'adapters':['Only physical allocation/free/mutex/events/atomic/thread-id/user callback. Actual AFBAE0 admissions,AF8C80 load+unload dispatch,AFCDE0/AF9900 deferred enqueue,frame publication,B06C60 holder callback/free execute. Worker second wait publishes fixture external stop flag;not OS shutdown qualification.'],'limits':['Three effect-only banks,manually initialized two-page common queue,empty voice/media owners,controlled worker stop. Rust full worker unload integration,nonempty owners,all commands/whole startup/destruction and OS scheduling/audible game output remain required. Native uninitialized command padding is nondeterministic and not logical data.']}
(r/'data/4.20/audio_bank_worker_deferred_unload_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'normal worker load/unload/common deferred consumer/callback/storage sequences')
