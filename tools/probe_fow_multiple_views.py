from pathlib import Path
import json,struct,datetime
r=Path('E:/OpenLeague')
multi_prefix=(r/'tools/probe_fow_event_creation_generated.py').read_text(encoding='utf-8').split('\ncases=[]')[0]
exec(compile(multi_prefix,'native multi-view prerequisites','exec'))
callback_order=[];views=[]
def trace_view_callback(uc,a,size,user):
 if a==0x6b4860:callback_order.append(views.index(u.reg_read(UC_X86_REG_ECX)))
u.hook_add(unicorn.UC_HOOK_CODE,trace_view_callback)
cases=[]
for view_count in [2,3,6]:
 masks=range(1<<view_count) if view_count<6 else [0,1,0x15,0x2a,63]
 for expired_mask in masks:
  for pending in [False,True]:
   allocation_cursor=0x70000000;allocations.clear();frees.clear();events.clear();callback_order.clear();views=[]
   head=heap+0x18100
   u.mem_write(manager,bytes(64));u.mem_write(head,bytes(64));u.mem_write(head+0xd,bytes([1]))
   for address,value in [(head,head),(head+4,head),(head+8,head),(manager+0x1c,head),(0x2d798ac,manager),(0x2d5f468,77),(manager+4,entries),(manager+8,entries),(manager+0xc,entries+16)]:write32(address,value)
   for i in range(view_count):
    view=0x40000000+0x100*i;views.append(view);u.mem_write(view,bytes([0xcc])*128);invoke(0x6b3b80,view,struct.pack('<If',0,15398.671875))
   event_body=read32(read32(head+4)+0x14);event_list=read32(event_body+0xc);initial_subscribers=(read32(event_list+4)-read32(event_list))//20
   assert initial_subscribers==view_count and read32(manager+0x20)==1
   invoke(0x6b1b20,manager,struct.pack('<5IfI5f',output,0,55,66,100,200.,0,128.,64.,0.,128.,128.));source_object=read32(output);source_control=read32(output+4)
   pending_ptrs=[]
   for i,view in enumerate(views):
    if pending:
     storage=0x40009000+0x100*i;pending_ptrs.append(storage);pair=0x4000f000
     u.mem_write(pair,struct.pack('<2I',source_object,0x3f800000));u.reg_write(UC_X86_REG_EDX,0);invoke(0x6bbfb0,storage,struct.pack('<3I',storage,pair,0))
     write32(view+0x3c,storage);write32(view+0x40,storage+8);write32(view+0x44,storage+16)
    if expired_mask&(1<<i):invoke(0x6b3d70,view)
   before_count=(read32(event_list+4)-read32(event_list))//20;assert before_count==view_count
   callback_order.clear();invoke(0x6b1f90,manager,struct.pack('<I',entries))
   expected=[i for i in range(view_count) if not expired_mask&(1<<i)];assert sorted(callback_order)==expected
   pending_after=[(read32(v+0x40)-read32(v+0x3c))//8 for v in views];assert not any(pending_after)
   cases.append(dict(view_count=view_count,expired_mask=expired_mask,pending=pending,event_count=read32(manager+0x20),initial_subscribers=initial_subscribers,subscriber_count_after=(read32(event_list+4)-read32(event_list))//20,callback_order=list(callback_order),pending_counts_after=pending_after,pending_deallocation_requested=[p in frees for p in pending_ptrs],allocation_sizes=[a['bytes'] for a in allocations]))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,native_addresses=len(visited-{0xc9f39b,0x9933e0,0xc98528,0x9941b0,0x994210,0xc975f5,0x66d282}),cases=cases,limits=['Original empty-event creation, view constructors, subscriber vector growth/relocation, view destruction and source dispatch execute for2/3/6views. Expired subscriptions erased during dispatch; original6B4860 purges pending source identity from each live view.','Allocator/mutex and InitializeCriticalSection boundaries adapted explicitly. Pending queues supplied one-entry preallocated storage populated by original6BBFB0; their actual vector-growth producer is not executed.','Sources have no applied stencil here: this isolates subscriber ordering and pending lifetime, not cross-view vision count ownership or continuous terrain/GPU output.','Deallocation requests recorded without unmapping emulator memory. No concurrency, live entity binding or GPU qualification.'])
(r/'data/4.20/fow_multiple_views_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=proof['native_addresses'],orders=[dict(count=c['view_count'],mask=c['expired_mask'],order=c['callback_order']) for c in cases if not c['pending']])))
