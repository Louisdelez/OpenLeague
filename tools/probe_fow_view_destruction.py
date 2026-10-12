from pathlib import Path
r=Path('E:/OpenLeague')
view_destroy_source=(r/'tools/probe_fow_view_constructor.py').read_text(encoding='utf-8')
view_destroy_source=view_destroy_source.replace('for extent in [1000.,15398.671875]:', "for extent,destroy_first in __import__('itertools').product([1000.,15398.671875],[False,True]):")
view_destroy_source=view_destroy_source.replace('constructor=dict(extent=extent,', 'constructor=dict(destroy_first=destroy_first,extent=extent,')
needle=' events.clear();invoke(0x6b1f90,manager,struct.pack(\'<I\',entries))'
change=''' wrapper=read32(view+4);wrapper_control=read32(view+8);scratchptr=read32(view+0x20)
 if destroy_first:
  frees.clear();invoke(0x6b3d70,view)
  constructor.update(pixel_free_requested=pixelptr in frees,count_free_requested=countptr in frees,scratch_free_requested=scratchptr in frees,wrapper_free_requested=wrapper in frees,self_control_strong_after=read32(wrapper_control+4),self_control_weak_after=read32(wrapper_control+8))
  assert all(constructor[k] for k in ['pixel_free_requested','count_free_requested','scratch_free_requested','wrapper_free_requested'])
 events.clear();invoke(0x6b1f90,manager,struct.pack('<I',entries))'''
assert needle in view_destroy_source;view_destroy_source=view_destroy_source.replace(needle,change)
view_destroy_source=view_destroy_source.replace(' assert not any(u.mem_read(countptr,16384)) and not any(u.mem_read(pixelptr,16384))', ' if not destroy_first:assert not any(u.mem_read(countptr,16384)) and not any(u.mem_read(pixelptr,16384))')
view_destroy_source=view_destroy_source.replace('counts_zero_after_removal=True,pixels_zero_after_removal=True,', 'subscriber_count_after=(read32(event_list+4)-read32(event_list))//20,counts_zero_after_removal=not any(u.mem_read(countptr,16384)),pixels_zero_after_removal=not any(u.mem_read(pixelptr,16384)),')
view_destroy_source=view_destroy_source.replace(" assert constructor['callbacks']==1 and not constructor['source_applied_after_removal']", " assert constructor['callbacks']==int(not destroy_first) and constructor['source_applied_after_removal']==destroy_first")
view_destroy_source=view_destroy_source.replace('fow_view_constructor_contract.json','fow_view_destruction_contract.json')
view_destroy_source=view_destroy_source.replace('View destruction/unsubscription, first argument semantics and full texture/GPU activation remain unqualified.', 'Original view destruction6B3D70 executes before later source dispatch in half the cases. Freed buffers remain mapped by deallocation adapter; their contents after destruction are stale memory, not an active view. First argument semantics and full texture/GPU activation remain unqualified.')
(r/'tools/probe_fow_view_destruction_generated.py').write_text(view_destroy_source,encoding='utf-8')
exec(compile(view_destroy_source,'native view destruction and later dispatch','exec'))
