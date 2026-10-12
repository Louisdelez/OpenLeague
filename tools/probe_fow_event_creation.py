from pathlib import Path
r=Path('E:/OpenLeague')
event_creation_source=(r/'tools/probe_fow_view_constructor.py').read_text(encoding='utf-8')
event_creation_source=event_creation_source.replace(' allocation_cursor=0x70000000;allocations.clear();frees.clear();events.clear()', ' allocation_cursor=0x70000000;allocations.clear();frees.clear();events.clear()\n head=heap+0x18100;node=heap+0x18200;event_body=heap+0x18300;event_list=heap+0x18400;subscriber=heap+0x18500;event_control=heap+0x18600')
event_creation_source=event_creation_source.replace('write32(head+4,node);', 'write32(head,head);write32(head+4,head);write32(head+8,head);')
event_creation_source=event_creation_source.replace('u.mem_map(0x70000000,0x100000)', '''u.mem_map(0x70000000,0x100000)
def critical_section_adapter(uc,a,size,user):
 if a==0x66d282:
  top=u.reg_read(UC_X86_REG_ESP);pointer=read32(top);u.mem_write(pointer,bytes(24));u.reg_write(UC_X86_REG_ESP,top+4);u.reg_write(UC_X86_REG_EIP,0x66d288)
u.hook_add(unicorn.UC_HOOK_CODE,critical_section_adapter)''')
needle=" invoke(0x6b3b80,view,struct.pack('<If',0,extent));assert u.reg_read(UC_X86_REG_EAX)==view"
replacement=needle+'''\n node=read32(head+4);assert node!=head and read32(node+0x10)==77
 event_body=read32(node+0x14);event_list=read32(event_body+0xc);subscriber=read32(event_list)
 assert read32(manager+0x20)==1'''
assert needle in event_creation_source;event_creation_source=event_creation_source.replace(needle,replacement)
event_creation_source=event_creation_source.replace('fow_view_constructor_contract.json','fow_event_creation_contract.json')
event_creation_source=event_creation_source.replace('constructor=dict(extent=extent,','constructor=dict(event_count=read32(manager+0x20),extent=extent,')
event_creation_source=event_creation_source.replace('0x994210,0xc975f5}', '0x994210,0xc975f5,0x66d282}')
event_creation_source=event_creation_source.replace('Event tree/event list/control and subscriber capacity supplied rather than initialized from empty dispatcher.', 'Empty dispatcher sentinel supplied; original event map insertion, event/list/control creation and first subscription growth execute.')
event_creation_source=event_creation_source.replace('Allocator/mutex boundaries adapted.', 'Allocator/mutex boundaries adapted; original InitializeCriticalSection import at66D282 supplied initialized24-byte storage in this single-thread probe.')
(r/'tools/probe_fow_event_creation_generated.py').write_text(event_creation_source,encoding='utf-8')
try:exec(compile(event_creation_source,'native absent event construction','exec'))
except Exception:
 if 'u' in globals():
  pointer=u.reg_read(UC_X86_REG_EIP);print('native instruction at failure',hex(pointer));print('stack',[hex(v) for v in struct.unpack('<16I',u.mem_read(u.reg_read(UC_X86_REG_ESP),64))])
 raise
