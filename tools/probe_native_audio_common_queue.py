from pathlib import Path
import itertools,json,hashlib
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_audio_bank_command_worker.py').read_text(encoding='utf-8').split('\ncaller=')[0];setup=setup.replace('u.hook_add(unicorn.UC_HOOK_CODE,guard_worker)','worker_hook=u.hook_add(unicorn.UC_HOOK_CODE,guard_worker)');exec(compile(setup,'worker_setup','exec'))
common=manager+0x1000;ring=common+0x18;table_ref=heap+0x5800;packet_ref=heap+0x5c00;pages=[heap+0x6400,heap+0x6600];local_regions=[(0xb05ed0,0xb05efc),(0xb06370,0xb063f2),(0xb05550,0xb05556),(0xb05670,0xb05757),(0xb11750,0xb117b8)];regions.extend(local_regions);put(0x12101bc,'I',64)
def guard_ring(uc,a,n,d):
 if a in locks and read(u.reg_read(UC_X86_REG_ESP)+4,'I')[0]==common:calls.append({'kind':locks[a],'scope':'audio_common_queue'});ret(1,4);return
 if any(start<=a<end for start,end in local_regions):return
 guard_worker(uc,a,n,d)
u.hook_del(worker_hook);u.hook_add(unicorn.UC_HOOK_CODE,guard_ring);rows=[]
for pattern,write,read_page,offset,limit,array_capacity,full,fail_nth,size,mode in itertools.product([0,0xa5],[0,1],[0,1],[0,40,64],[2,4],[2,4],[0,1],[0,1,2],[0,2,24,56,64,65],['direct','locked']):
 fit=size<=64-offset
 if size>64 and not full:continue # exclude physical page overflow, not silently qualify it
 if mode=='locked'and not fit and size<=64:continue # real consumer/backpressure needed; do not substitute it
 calls.clear();allocations.clear();next_pointer=heap+0xc000;count_allocate=0;consumed=0;u.mem_write(common,bytes([pattern])*0x98);u.mem_write(common,bytes(24));put(ring,'8I',table_ref,2,array_capacity,limit,read_page,0,write,offset);u.mem_write(ring+32,bytes([full]));put(common+0x88,'I',789);put(common+0x90,'I',456);u.mem_write(table_ref,bytes([pattern])*(array_capacity*8));allocations.append({'reference':table_ref,'size':array_capacity*8,'freed':False})
 for i,page in enumerate(pages):u.mem_write(page,bytes([pattern])*64);put(table_ref+i*8,'II',page,offset if i==write else 0);allocations.append({'reference':page,'size':64,'freed':False})
 payload=bytes((i*7+3)&255 for i in range(66));u.mem_write(packet_ref,payload);before=bytes(u.mem_read(common,0x98)).hex();initial=[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations]
 result=invoke(0xb05670 if mode=='direct'else 0xb05ed0,[packet_ref,size],ring if mode=='direct'else common)
 rows.append({'pattern':pattern,'mode':mode,'write_page':write,'read_page':read_page,'offset':offset,'limit':limit,'array_capacity':array_capacity,'full':full,'failure_nth':fail_nth,'size':size,'before':before,'initial_allocations':initial,'packet_before':payload.hex(),'result':result,'context':bytes(u.mem_read(common,0x98)).hex(),'packet_after':bytes(u.mem_read(packet_ref,66)).hex(),'allocations':[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations],'calls':list(calls)})
 # physical fixture ownership release; full ring consumer/destructor is separate
 for v in allocations:
  if not v['freed']:
   sp=stack+0x8000;put(sp,'III',trap,0xffffffff,v['reference']);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0xada3e0,trap,count=20000)
 assert all(v['freed']for v in allocations)
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in local_regions],'adapters':['Only physical allocator/free/memcpy/mutex. Actual B05670 paged-ring insertion/copy/growth,B11750 ordered page insertion,B153B0 pair-array growth and B05ED0/B06370 wrapper execute. No logical queue success shim.'],'findings':['Fitting packet copies into current page and updates write offset/page used field before full flag is checked.','Cross-page insertion reuses next existing page unless it collides with read page;then grows up to limit with64-byte page allocation and ordered8-byte record insertion/growth. OOM marks full and returns52,freeing temporary page if array insertion fails.','Locked wrapper writes declared size to incoming u16 header;too-large packet after full52 becomes81. Valid-sized backpressure intentionally excluded pending real consumer.'],'limits':['Native preparation;Rust common queue port pending. Explicit controlled64-byte pages/2 initial page records/valid packet backing,zero read-offset;not whole queue initialization/consumer/destructor or OS concurrent scheduling.','Physical packet size exceeding page excluded except full rejection52/direct or81/wrapper;full valid-sized locked retry requires actual consumer instead of stub. Fixture free is not normal queue teardown.']}
(r/'data/4.20/audio_common_queue_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native common audio paged-ring/copy/reuse/growth/failure/locked-wrapper cases')
