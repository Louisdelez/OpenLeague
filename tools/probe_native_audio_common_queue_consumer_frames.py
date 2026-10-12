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
u.hook_del(ring_hook);u.hook_add(unicorn.UC_HOOK_CODE,guard_retry)
rows=[]
for pattern,page_size,start,frames,waiting,processed_start in __import__('itertools').product([0,0xa5],[64,2048],[0,1],[(0,0),(1,0),(2,0),(0xffffffff,0xfffffffe),(0,0xffffffff)],[0,1],[0,0xfffffffe]):
 put(0x12101bc,'I',page_size);pages=[heap+0x8000,heap+0x9000];wait_count=0;fail_nth=0;calls.clear();allocations.clear();next_pointer=heap+0xc000;count_allocate=0;consumed=0;u.mem_write(common,bytes(0xa4));put(ring,'8I',table_ref,2,2,2,start,0,start,0);put(common+0x80,'II',*frames);put(common+0x88,'I',789);put(common+0x90,'I',456);u.mem_write(table_ref,bytes(16));put(0x14a82e0,'I',processed_start)
 for i,page in enumerate(pages):u.mem_write(page,bytes([pattern])*page_size);put(table_ref+i*8,'II',page,0);allocations.append({'reference':page,'size':page_size,'freed':False})
 allocations.insert(0,{'reference':table_ref,'size':16,'freed':False})
 for opcode in [0xffff,0,0xffff,0]:
  packet=bytes.fromhex('1800')+opcode.to_bytes(2,'little')+bytes(range(20));u.mem_write(packet_ref,packet);assert invoke(0xb05ed0,[packet_ref,24],common)==1
 u.mem_write(common+0x3c,bytes([waiting]));calls.clear();before=bytes(u.mem_read(common,0x98)).hex();initial=[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations];result=invoke(0xb06c60,(),common);assert result==1
 rows.append({'page_size':page_size,'pattern':pattern,'processed_start':processed_start,'before':before,'initial_allocations':initial,'result':result,'context':bytes(u.mem_read(common,0x98)).hex(),'processed':read(0x14a82e0,'I')[0],'allocations':[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations],'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(b).hexdigest(),'cases':rows,'adapters':['Physical mutex/event only; actual B06C60/B054D0/B05530/frame0/default unknown-opcode drop execute.'],'limits':['Two owned pages; four packets with frame/default opcodes; known command bodies and complete lifecycle/OS scheduling remain required.']}
(r/'data/4.20/audio_common_queue_consumer_frames_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual consumer frame stop,waiting override,read wrap,global processed counter wrapping cases')
