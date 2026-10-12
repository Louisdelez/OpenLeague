from pathlib import Path
import json,hashlib
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_audio_common_queue.py').read_text(encoding='utf-8').split('\nfor pattern,')[0];setup=setup.replace('u.hook_add(unicorn.UC_HOOK_CODE,guard_ring)','ring_hook=u.hook_add(unicorn.UC_HOOK_CODE,guard_ring)');exec(compile(setup,'setup','exec'))
consumer_regions=[(0xb06c60,0xb07d78),(0xb054d0,0xb05541),(0xb20e90,0xb20e9e)];regions.extend(consumer_regions);wait_count=0;processed=0

def guard_retry(uc,a,n,d):
 global wait_count
 if a==wait_api:
  sp=u.reg_read(UC_X86_REG_ESP);handle,timeout=read(sp+4,'II');calls.append({'kind':'wait_event','handle':handle,'timeout':timeout});wait_count+=1;assert wait_count==1
  saved=u.context_save();sp2=stack+0x4000;put(sp2,'I',trap);u.reg_write(UC_X86_REG_ESP,sp2);u.reg_write(UC_X86_REG_ECX,common);u.emu_start(0xb06c60,trap,count=200000);assert u.reg_read(UC_X86_REG_EIP)==trap;result=u.reg_read(UC_X86_REG_EAX);assert result==1;calls.append({'kind':'native_consumer_return','result':result});u.context_restore(saved);ret(0,8);return
 if any(start<=a<end for start,end in consumer_regions):return
 guard_ring(uc,a,n,d)
u.hook_del(ring_hook);u.hook_add(unicorn.UC_HOOK_CODE,guard_retry)
rows=[]
for pattern,page_size,start,event in __import__('itertools').product([0,0xa5],[64,2048],[0,1],[0,789]):
 for size in ([24,56,64]if page_size==64 else[24,56,2048]):
  put(0x12101bc,'I',page_size);pages=[heap+0x8000,heap+0x9000];wait_count=0;fail_nth=0;calls.clear();allocations.clear();next_pointer=heap+0xc000;count_allocate=0;consumed=0;u.mem_write(common,bytes(0xa4));put(ring,'8I',table_ref,2,2,2,start,0,start,0);put(common+0x88,'I',event);put(common+0x90,'I',456);u.mem_write(table_ref,bytes(16));put(0x14a82e0,'I',0)
  for i,page in enumerate(pages):u.mem_write(page,bytes([pattern])*page_size);put(table_ref+i*8,'II',page,0);allocations.append({'reference':page,'size':page_size,'freed':False})
  allocations.insert(0,{'reference':table_ref,'size':16,'freed':False});packet=size.to_bytes(2,'little')+bytes.fromhex('ffff')+bytes((i*7+3)&255 for i in range(size-4));u.mem_write(packet_ref,packet)
  pending=2*(page_size//size)
  for i in range(pending):assert invoke(0xb05ed0,[packet_ref,size],common)==1
  calls.clear();before=bytes(u.mem_read(common,0x98)).hex();initial=[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations];result=invoke(0xb05ed0,[packet_ref,size],common);assert result==1 and wait_count==1
  rows.append({'pattern':pattern,'page_size':page_size,'size':size,'before':before,'initial_allocations':initial,'packet':packet.hex(),'result':result,'context':bytes(u.mem_read(common,0x98)).hex(),'processed':read(0x14a82e0,'I')[0],'allocations':[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations],'calls':list(calls)});assert rows[-1]['processed']==pending
proof={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(b).hexdigest(),'cases':rows,'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in consumer_regions],'adapters':['Physical event wait schedules actual B06C60 consumer with separate saved CPU/stack context then restores producer CPU. Actual reader/commit/default unknown-opcode drop and producer retry execute; no logical drain shim.'],'limits':['Unknown-opcode native default drop only; remaining normal command bodies/frame markers/full initialization/destruction and OS concurrent scheduling remain required. Fixture-owned pages, two-page capacity, no native destructor acceptance.']}
(r/'data/4.20/audio_common_queue_backpressure_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native blocked producer/retry/actual consumer sequences,64 and2048-byte pages')
