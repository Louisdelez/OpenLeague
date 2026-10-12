from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
queue=vector+0x10000;pool=vector+0x11000;argument=vector+0x12000;allocs=[]
def hook(uc,a,size,user):
 if a==0xada670:
  sp=uc.reg_read(UC_X86_REG_ESP);allocs.append(read(sp+8));finish(0)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
rows=[]
for sequence in sorted(set(itertools.permutations([0,1024,1024,0xffffffff]))):
 u.mem_write(queue,bytes(32));u.mem_write(pool,bytes(48));w(queue+8,pool)
 for i in range(4):w(pool+i*12,pool+(i+1)*12 if i<3 else 0)
 expected=[];snapshots=[]
 for index,key in enumerate(sequence):
  w(argument,index+1);call(0xb06140,queue,struct.pack('<II',key,argument));assert u.reg_read(UC_X86_REG_EAX)==1
  expected.append((key,index+1));expected.sort(key=lambda x:x[0]);actual=[];ptr=read(queue);last=0
  while ptr:
   assert len(actual)<4;actual.append((read(ptr+4),read(ptr+8)));last=ptr;ptr=read(ptr)
  assert actual==expected and read(queue+4)==last and read(queue+0x14)==index+1
  snapshots.append(actual)
 assert read(queue+8)==0
 rows.append(dict(sequence=sequence,snapshots=snapshots))
failures=[]
for capacity,count in [(0,0),(2,2),(2,1)]:
 u.mem_write(queue,bytes(32));w(queue+0x10,capacity);w(queue+0x14,count);before=bytes(u.mem_read(queue,32));allocs.clear()
 w(argument,55);call(0xb06140,queue,struct.pack('<II',100,argument))
 assert u.reg_read(UC_X86_REG_EAX)==2 and bytes(u.mem_read(queue,32))==before
 assert allocs==([12] if count<capacity else [])
 failures.append(dict(capacity=capacity,count=count,allocations=list(allocs),result=2))
proof=dict(passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),sequences=rows,insertions=sum(len(x['snapshots']) for x in rows),failures=failures,findings=['Actual B06140 maintains unsigned ascending keys and FIFO for equal keys; head/tail/count/free list verified after each insertion.','No free node and count>=capacity returns2 without allocation; allocator failure below capacity returns2 preserving queue.'],adapters=['Supplied preallocated pool. Allocation failure hook returns null; successful dynamic allocation not covered.'],limits=['Queue removal and action execution remain unqualified. Unsigned ordering is verified even at FFFFFFFF; no wrap-aware ordering substituted.'])
(r/'data/4.20/audio_schedule_queue.json').write_text(json.dumps(proof,indent=2)+'\n')
print('PASS',proof['insertions'],'insertions and',len(failures),'failure cases')
