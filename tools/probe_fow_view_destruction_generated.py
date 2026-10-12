from pathlib import Path
import json,struct,datetime
r=Path('E:/OpenLeague')
view_constructor_factory_prefix=(r/'tools/probe_fow_circle_factory.py').read_text(encoding='utf-8').split('cases=[]')[0].replace('assert 0<amount<1024','assert 0<amount<65536').replace('assert allocation_cursor<heap+0x1f000','assert allocation_cursor<0x70100000')
release=(r/'tools/probe_fow_source_release.py').read_text(encoding='utf-8').split('\ncases=[]')[0]
release=release.replace("exec(compile(prefix,'native circle factory prerequisites','exec'))", "exec(compile(view_constructor_factory_prefix,'native circle factory prerequisites','exec'))")
exec(compile(release,'native view constructor prerequisites','exec'))
u.mem_map(0x70000000,0x100000)
cases=[]
for extent,destroy_first in __import__('itertools').product([1000.,15398.671875],[False,True]):
 allocation_cursor=0x70000000;allocations.clear();frees.clear();events.clear()
 for pointer,size in [(manager,64),(head,64),(node,64),(event_body,48),(event_list,48),(subscriber,128),(event_control,16)]:u.mem_write(pointer,bytes(size))
 u.mem_write(view,bytes([0xcc])*128);u.mem_write(head+0xd,bytes([1]));write32(head+4,node);write32(manager+0x1c,head);write32(0x2d798ac,manager);write32(0x2d5f468,77)
 for address,value in [(node,head),(node+8,head),(node+0x10,77),(node+0x14,event_body),(event_body+0xc,event_list),(event_body+0x10,event_control),(event_control+4,10),(event_control+8,10),(event_list,subscriber),(event_list+4,subscriber),(event_list+8,subscriber+100)]:write32(address,value)
 invoke(0x6b3b80,view,struct.pack('<If',0,extent));assert u.reg_read(UC_X86_REG_EAX)==view
 countptr=read32(view+0x14);pixelptr=read32(view+0x18);assert bytes(u.mem_read(countptr,16384))==bytes(16384) and bytes(u.mem_read(pixelptr,16384))==bytes(16384)
 constructor=dict(destroy_first=destroy_first,extent=extent,dimension=read32(view+0x10),extent_bits=read32(view+0xc),initialized_words={hex(off):read32(view+off) for off in [4,8,0x20,0x24,0x28,0x2c,0x30,0x34,0x38,0x3c,0x40,0x44,0x4c]},uninitialized_bytes={hex(off):u.mem_read(view+off,1)[0] for off in [0x1c,0x48]},count_buffer_zero=True,pixel_buffer_zero=True,subscriber_count=(read32(event_list+4)-read32(event_list))//20,subscriber_words=[read32(subscriber+off) for off in range(0,20,4)],self_wrapper_vtable=hex(read32(read32(view+4))),self_wrapper_targets_view=read32(read32(view+4)+4)==view,self_control_strong=read32(read32(view+8)+4),self_control_weak=read32(read32(view+8)+8),allocations=list(allocations))
 write32(manager+4,entries);write32(manager+8,entries);write32(manager+0xc,entries+16)
 invoke(0x6b1b20,manager,struct.pack('<5IfI5f',output,0,55,66,100,200.,0,128.,64.,0.,128.,128.))
 source_object=read32(output);source_control=read32(output+4);write32(source_object+0x40,bits);write32(source_object+0x48,512);u.mem_write(bits,struct.pack('<512I',*([0x55555555]*512)))
 invoke(0x6b2d80,source_object+0x40,struct.pack('<7I',128,pixelptr,view+0x14,1,5,2,6));assert any(u.mem_read(countptr,16384))
 wrapper=read32(view+4);wrapper_control=read32(view+8);scratchptr=read32(view+0x20)
 if destroy_first:
  frees.clear();invoke(0x6b3d70,view)
  constructor.update(pixel_free_requested=pixelptr in frees,count_free_requested=countptr in frees,scratch_free_requested=scratchptr in frees,wrapper_free_requested=wrapper in frees,self_control_strong_after=read32(wrapper_control+4),self_control_weak_after=read32(wrapper_control+8))
  assert all(constructor[k] for k in ['pixel_free_requested','count_free_requested','scratch_free_requested','wrapper_free_requested'])
 events.clear();invoke(0x6b1f90,manager,struct.pack('<I',entries))
 if not destroy_first:assert not any(u.mem_read(countptr,16384)) and not any(u.mem_read(pixelptr,16384))
 constructor.update(callbacks=sum(e['kind']=='callback' for e in events),subscriber_count_after=(read32(event_list+4)-read32(event_list))//20,counts_zero_after_removal=not any(u.mem_read(countptr,16384)),pixels_zero_after_removal=not any(u.mem_read(pixelptr,16384)),source_applied_after_removal=bool(u.mem_read(source_object+0x44,1)[0]))
 assert constructor['callbacks']==int(not destroy_first) and constructor['source_applied_after_removal']==destroy_first
 cases.append(constructor)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x6b3b80',subscription='0x66d460',native_addresses=len(visited-{0xc9f39b,0x9933e0,0xc98528,0x9941b0,0x994210,0xc975f5}),cases=cases,limits=['Original view constructor including6B7D70 self-wrapper shared initialization, zero buffers,68CF70 subscriber creation,66D460 existing-event registration and6B2D10 stencil allocation executes. Original source creation/removal and registered view callback retire the applied stencil.','Allocator/mutex boundaries adapted. Event tree/event list/control and subscriber capacity supplied rather than initialized from empty dispatcher.','Original view destruction6B3D70 executes before later source dispatch in half the cases. Freed buffers remain mapped by deallocation adapter; their contents after destruction are stale memory, not an active view. First argument semantics and full texture/GPU activation remain unqualified. Fields1C and48 retain preexistingCC bytes; not assigned fabricated defaults.'])
(r/'data/4.20/fow_view_destruction_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=proof['native_addresses'],sample=cases[0])))
