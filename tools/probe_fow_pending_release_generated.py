from pathlib import Path
import json,struct,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_source_release.py').read_text().split('\ncases=[]')[0],'release prerequisites','exec'))
pending_storage=0x40006000;pair=0x40007000
priority_sets=[[0x3f800000,0x40000000,0x40400000],[0x3f800000]*3,[0x7fc00000,0,0xbf800000],[0x80000000,0,0x7f800000]]
patterns=[[0,1,2],[0,1,2,0],[1,2],[]]
def capture_pending():
 return [dict(identity=next(i for i,(obj,_) in enumerate(sources) if obj==read32(a)),priority_bits=read32(a+4)) for a in range(read32(view+0x3c),read32(view+0x40),8)]
cases=[]
definitions=[(0x55555555,[1,2,5,6]),(0xaaaaaaaa,[3,1,7,5]),(0xffffffff,[0,3,4,7])]
for observers,applied,order,pattern,priorities in itertools.product([1,2],[True],itertools.permutations(range(3)),patterns,priority_sets):
 allocation_cursor=heap+0x19000;events.clear();frees.clear()
 for pointer,size in [(manager,0x40),(entries,32),(output,24),(head,0x40),(node,0x40),(event_body,0x30),(event_list,0x30),(subscriber,80),(view,0x100),(view_control,16),(event_control,16)]:u.mem_write(pointer,bytes(size))
 write32(manager+4,entries);write32(manager+8,entries);write32(manager+0xc,entries+32)
 u.mem_write(head+0xd,bytes([1]));write32(head+4,node if observers else head);write32(manager+0x1c,head);write32(0x2d5f468,77)
 write32(view,0x10a0330);write32(view+4,view);write32(view+8,view_control);write32(view_control+4,10);write32(view_control+8,10)
 if observers:
  write32(node,head);write32(node+8,head);write32(node+0x10,77);write32(node+0x14,event_body)
  write32(event_body+0xc,event_list);write32(event_body+0x10,event_control);write32(event_control+4,10);write32(event_control+8,10)
  for i in range(observers):invoke(0x68cf70,subscriber+20*i,struct.pack('<4I',view,0,0x669d81,0))
  write32(event_list,subscriber);write32(event_list+4,subscriber+20*observers);write32(event_list+8,subscriber+20*observers)
 u.mem_write(counts,bytes(64));u.mem_write(pixels,bytes(64));write32(view+0x10,8);write32(view+0x14,counts);write32(view+0x18,pixels)
 sources=[]
 for i,(word,rect) in enumerate(definitions):
  invoke(0x6b1b20,manager,struct.pack('<5IfI5f',output+8*i,0,55+i,66,100,200.,0,128.,64.,0.,128.,128.))
  obj=read32(output+8*i);control=read32(output+8*i+4);sources.append((obj,control))
  bp=bits+i*0x100;u.mem_write(bp,struct.pack('<2I',word,word));write32(obj+0x40,bp)
  for off,val in zip([0xc,0x10,0x14,0x18],[rect[0],rect[2],rect[1],rect[3]]):write32(obj+0x40+off,val)
  if applied:invoke(0x6b2d80,obj+0x40,struct.pack('<7I',8,pixels,view+0x14,rect[0],rect[2],rect[1],rect[3]))
  else:u.mem_write(obj+0x44,bytes([0]))
 write32(view+0x3c,pending_storage);write32(view+0x40,pending_storage);write32(view+0x44,pending_storage+64)
 for index,identity in enumerate(pattern):
  u.mem_write(pair,struct.pack('<2I',sources[identity][0],priorities[identity]));u.reg_write(UC_X86_REG_EDX,index)
  invoke(0x6bbfb0,pending_storage,struct.pack('<3I',pending_storage,pair,0));write32(view+0x40,pending_storage+8*(index+1))
 initial_pending=capture_pending()
 initial_counts=list(u.mem_read(counts,64));initial_pixels=list(u.mem_read(pixels,64));steps=[];remaining=list(range(3))
 for identity in order:
  source_object,source_control=sources[identity];events.clear();frees.clear()
  addresses=range(entries,read32(manager+8),8);entry=next(a for a in addresses if read32(a)==source_object)
  try:invoke(0x6b1f90,manager,struct.pack('<I',entry))
  except Exception:
   print('failed sequence',observers,applied,order,'removed',identity,'entry',hex(entry),'sources',sources,'manager words',[read32(manager+i) for i in range(0,32,4)])
   raise
  remaining.remove(identity)
  actual_order=[next(i for i,(obj,_) in enumerate(sources) if obj==read32(a)) for a in range(entries,read32(manager+8),8)]
  assert sorted(actual_order)==sorted(remaining)
  invoke(0x5bd6f0,output+8*identity,struct.pack('<I',promoted));assert read32(promoted)==0 and read32(promoted+4)==0
  callbacks=[dict(strong=e['strong'],applied=e['applied']) for e in events if e['kind']=='callback']
  assert len(callbacks)==observers and source_object in frees
  assert all(e['strong']==1 for e in callbacks)
  assert [e['applied'] for e in callbacks]==([applied]+[False]*(observers-1) if observers else [])
  assert all(read32(sources[i][1]+4)==1 for i in remaining)
  assert read32(source_control+8)==1
  invoke(0x585aa0,output+8*identity)
  assert read32(source_control+8)==0 and source_control in frees
  steps.append(dict(pending=capture_pending(),removed=identity,remaining_order=actual_order,callbacks=callbacks,counts=list(u.mem_read(counts,64)),pixels=list(u.mem_read(pixels,64)),strong_after=read32(source_control+4),weak_expired=True,source_deallocation_requested=True,final_weak_count=read32(source_control+8),control_deallocation_requested=True))
 cases.append(dict(pattern=pattern,priorities=priorities,initial_pending=initial_pending,observers=observers,initial_applied=applied,order=list(order),initial_counts=initial_counts,initial_pixels=initial_pixels,steps=steps))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,final_weak_release='0x585aa0',cases=cases,native_addresses=len(visited-{0xc9f39b,0x9933e0,0xc98528,0x9941b0,0x994210,0xc975f5}),definitions=[dict(word=w,rect=rect) for w,rect in definitions],limits=['Allocator/free/mutex boundaries adapted as in single-source probe; event tree and shared receiver controls supplied. Deallocation requests recorded without unmapping memory.','Subscribers target the same view; source-global applied flag prevents a second decrement. Pending heap insertion/popping/rebuild executes original6BBFB0/6BD740 with raw source identity and supplied priority bits; priority producers and scheduling remain unknown. Distinct views, concurrency and full view registration remain unqualified.','No live gameplay/GPU binding or full game qualification.'])
(r/'data/4.20/fow_pending_release_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),pending_heap=True,removals=sum(len(c['steps']) for c in cases),native_addresses=proof['native_addresses'],orders=sorted(set(tuple(s['remaining_order']) for c in cases for s in c['steps'])))))
