from pathlib import Path
import itertools,json,hashlib
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_audio_common_queue.py').read_text(encoding='utf-8').split('\nfor pattern,')[0];setup=setup.replace('u.hook_add(unicorn.UC_HOOK_CODE,guard_ring)','ring_hook=u.hook_add(unicorn.UC_HOOK_CODE,guard_ring)');exec(compile(setup,'ring_setup','exec'))
page_size=int.from_bytes(p.get_data(0x12101bc-base,4),'little');assert page_size==2048;put(0x12101bc,'I',page_size);pages=[heap+0x8000,heap+0x9000]
def guard_original(uc,a,n,d):
 global next_pointer,count_allocate
 if a==0xada670:
  owner,size=read(u.reg_read(UC_X86_REG_ESP)+4,'II');count_allocate+=1;reference=0 if count_allocate==fail_nth else next_pointer
  if reference:
   next_pointer+=((size+255)&~255)+256;u.mem_write(reference,bytes([pattern])*size);allocations.append({'reference':reference,'size':size,'freed':False})
  calls.append({'kind':'allocate','method':'pool','allocator':owner,'size':size,'reference':reference});ret(reference,0);return
 guard_ring(uc,a,n,d)
u.hook_del(ring_hook);u.hook_add(unicorn.UC_HOOK_CODE,guard_original)
profiles=[(24,0,0,0),(56,0,0,1),(24,2040,0,0),(56,2040,1,0),(2048,2048,1,0),(2049,0,1,1)];rows=[]
for(size,offset,read_page,full),pattern,limit,array_capacity,fail_nth,mode in itertools.product(profiles,[0,0xa5],[2,4],[2,4],[0,1,2],['direct','locked']):
 if mode=='locked'and size>page_size-offset and size<=page_size:continue
 calls.clear();allocations.clear();next_pointer=heap+0xc000;count_allocate=0;consumed=0;u.mem_write(common,bytes([pattern])*0x98);u.mem_write(common,bytes(24));put(ring,'8I',table_ref,2,array_capacity,limit,read_page,0,0,offset);u.mem_write(ring+32,bytes([full]));put(common+0x88,'I',789);put(common+0x90,'I',456);u.mem_write(table_ref,bytes([pattern])*(array_capacity*8));allocations.append({'reference':table_ref,'size':array_capacity*8,'freed':False})
 for i,page in enumerate(pages):u.mem_write(page,bytes([pattern])*page_size);put(table_ref+i*8,'II',page,offset if i==0 else 0);allocations.append({'reference':page,'size':page_size,'freed':False})
 payload=bytes((i*7+3)&255 for i in range(page_size+2));u.mem_write(packet_ref,payload);before=bytes(u.mem_read(common,0x98)).hex();initial=[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations];result=invoke(0xb05670 if mode=='direct'else 0xb05ed0,[packet_ref,size],ring if mode=='direct'else common)
 intervals=sorted((v['reference'],v['reference']+v['size'])for v in allocations if not v['freed']);assert all(a[1]<=b[0]for a,b in zip(intervals,intervals[1:]))
 rows.append({'page_size':page_size,'pattern':pattern,'mode':mode,'write_page':0,'read_page':read_page,'offset':offset,'limit':limit,'array_capacity':array_capacity,'full':full,'failure_nth':fail_nth,'size':size,'before':before,'initial_allocations':initial,'packet_before':payload.hex(),'result':result,'context':bytes(u.mem_read(common,0x98)).hex(),'packet_after':bytes(u.mem_read(packet_ref,page_size+2)).hex(),'allocations':[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations],'calls':list(calls)})
 for v in allocations:
  if not v['freed']:
   sp=stack+0x8000;put(sp,'III',trap,0xffffffff,v['reference']);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0xada3e0,trap,count=20000)
 assert all(v['freed']for v in allocations)
proof={'passed':True,'complete':False,'case_count':len(rows),'page_size':page_size,'original_page_size_address':'12101BC','cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in local_regions+[(0xb153b0,0xb15426)]],'adapters':['Same real queue/ring/ordered insert bodies as64-byte contract;physical pool allocator reserves nonoverlapping spans for original2048-byte pages. No logical queue success stub.'],'findings':['Original PE global page size is2048,not controlled64-byte probe size. Original-sized pages preserve exact copy/growth/reuse/OOM/header/rejection behavior.'],'limits':['Native preparation;Rust common queue port pending. Full valid-sized wrapper backpressure/consumer/destructor/concurrency and full normal audio output still required. Explicit initialized page table/read offset0.']}
(r/'data/4.20/audio_common_queue_original_pages_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native original2048-byte common audio page/copy/growth/OOM/locked-wrapper cases')
