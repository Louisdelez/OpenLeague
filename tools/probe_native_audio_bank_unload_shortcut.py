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
u.hook_del(retry_hook);u.hook_add(unicorn.UC_HOOK_CODE,guard_unload)
caller=json.loads((r/'data/4.20/audio_bank_caller_contract.json').read_text(encoding='utf-8'));source=caller['source'];original=Path(source['bank_path']).read_bytes();assert hashlib.sha256(original).hexdigest()==source['bank_sha256'];bank_id=int.from_bytes(original[12:16],'little');data=bytes.fromhex(next(v['bank_payload']for v in caller['cases']if v['packet']=='both'));rows=[]
for pattern,inactive,enabled,pool in __import__('itertools').product([0,0xa5],[False,True],[False,True],[0xffffffff,42]):
 fail_nth=0;calls.clear();allocations.clear();next_pointer=heap+0xc000;count_allocate=0;consumed=0;put(0x12101bc,'I',64);u.mem_write(manager,bytes(0x500));u.mem_write(manager+0x7c,b'\x01');u.mem_write(registries,bytes(0x2600));u.mem_write(bank,data);load=[0,0,0,1,bank_id,0xffffffff,bank,len(data),0]
 if inactive:
  put(packet_ref,'9I',*load);assert invoke(0xaf9d40,[packet_ref],manager)==1;reference=read(cache+((bank_id+bank)&0xffffffff)%31*4,'I')[0];flags=bytes(u.mem_read(reference+72,1))[0];u.mem_write(reference+72,bytes([flags&~1]))
 u.mem_write(common,bytes(0xa4));put(ring,'8I',table_ref,2,2,2,0,0,0,0);put(common+0x88,'I',789);put(common+0x90,'I',456);put(context+36,'I',123);put(0x14a7a28,'I',common);put(0x14a82e0,'I',0);u.mem_write(table_ref,bytes(16));pages=[heap+0xa000,heap+0xb000]
 for i,page in enumerate(pages):u.mem_write(page,bytes([pattern])*64);put(table_ref+i*8,'II',page,0)
 request=[1,callback if enabled else 0,100,1,bank_id,pool,bank,0,0]
 if enabled:assert invoke(0xb145b0,[100],context)==1
 def snapshot(stage,result):
  return {'stage':stage,'result':result,'manager':bytes(u.mem_read(manager,0x500)).hex(),'common':bytes(u.mem_read(common,0x98)).hex(),'common_table':bytes(u.mem_read(table_ref,16)).hex(),'pages':[bytes(u.mem_read(page,64)).hex()for page in pages],'processed':read(0x14a82e0,'I')[0],'custom_count':read(registries+0x1f40+0x31c,'I')[0],'shared_count':read(registries+0x1c20+0x31c,'I')[0],'allocations':[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations],'calls':list(calls)}
 calls.clear();stages=[snapshot('before_unload',0)];result=invoke(0xafcde0,request,manager);assert result==(2 if inactive else 54);stages.append(snapshot('unload_immediate_completion',result));calls.clear()
 if inactive:invoke(0xb21aa0,[bank_id,bank],cache);invoke(0xafc410,(),reference);invoke(0xafbfd0,[1],reference)
 invoke(0xb14560,(),context);assert all(v['freed']for v in allocations);stages.append(snapshot('fixture_release_remaining_bank_and_notification',0))
 rows.append({'pattern':pattern,'inactive':inactive,'bank_payload':data.hex(),'load_request':load,'request':request,'stages':stages})
proof={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(b).hexdigest(),'source':source,'cases':rows,'adapters':['Only physical allocation/free/mutex/events/atomic/user callback. AFCDE0 lookup,immediate status2/54 and concrete AFA370/B14630 execute without common packets or frame.'],'limits':['Controlled missing/inactive loaded cache,empty media/voice ownership. Final explicit fixture cleanup is not normal deferred unload acceptance;other modes and complete runtime remain required.']}
(r/'data/4.20/audio_bank_unload_shortcut_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native missing/inactive unload/status/callback/storage cases')
