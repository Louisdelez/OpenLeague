from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague');source=(root/'tools/qualify_announcer_secondary_owner_registries.py').read_text().split('\ncases=[]')[0]
exec(compile(source,str(root/'tools/qualify_announcer_secondary_owner_registries.py'),'exec'))
component=heap+0x4178;metadata=heap+0x5500;owner_storage=heap+0x5600;control=heap+0x6500;vtable=heap+0x6600;dispose=end+0xb00;release_control=end+0xc00;virtual_calls=[]
write32(vtable,dispose);write32(vtable+4,release_control);write32(control,vtable);write32(component+4,metadata);write32(metadata+0x30,owner_storage);write32(0x2d5f448,0xffffffff)
def virtual_boundary(uc,address,size,user):
 if address==0xc97610:
  sp=u.reg_read(UC_X86_REG_ESP);destination,source,count=[read32(sp+i) for i in [4,8,12]]
  if count:u.mem_write(destination,bytes(u.mem_read(source,count)))
  finish(eax=destination)
 if address in [dispose,release_control]:
  assert u.reg_read(UC_X86_REG_ECX)==control
  virtual_calls.append({'op':'dispose' if address==dispose else 'release_control','strong':read32(control+4),'weak':read32(control+8)});finish()
u.hook_add(unicorn.UC_HOOK_CODE,virtual_boundary)
def snapshot(manager):
 head=read32(manager+4);begin=read32(manager+12);bucket_end=read32(manager+16)
 words=[[manager+i,read32(manager+i)] for i in range(4,48,4)]+[[head+i,read32(head+i)] for i in range(0,16,4)]+[[i,read32(i)] for i in range(begin,bucket_end,4)]
 node=read32(head);seen=set()
 while node!=head:
  assert node not in seen;seen.add(node);words.extend([[node+i,read32(node+i)] for i in range(0,16,4)]);node=read32(node)
 words.extend([[i,read32(i)] for i in range(read32(manager+36),read32(manager+40),4)])
 return words
controls=[(None,None)]+list(itertools.product([0,1,0xffffffff],[0,1,2,0xffffffff]))
cases=[]
for poison,prior,owner_id,(strong,weak) in itertools.product([0,165],[None,0,component,heap+0x7000],[42,0xffffffff],controls):
 cursor=arena;manager=0x2d5f470;write32(0x14bef40,0);opaque=heap+0x9000;u.mem_write(opaque,bytes([poison]));call(0x664e50,manager,[opaque,0])
 for offset in [36,40,44]:write32(manager+offset,0)
 if prior is not None:
  if prior==0:
   pair=heap+0xa000;result=heap+0xa100;write32(pair,42);write32(pair+4,0);call(0x65e750,manager,[result,pair])
  else:call(0x6b59f0,0,[prior,42])
 write32(owner_storage,owner_id);write32(component+8,0 if strong is None else control)
 if strong is not None:write32(control+4,strong);write32(control+8,weak)
 initial=snapshot(manager);allocations.clear();freed.clear();locks.clear();diagnostics.clear();virtual_calls.clear();call(0x6b2b20,component,[])
 assert not allocations and not diagnostics
 if strong is None:assert not virtual_calls
 else:
  assert read32(control+4)==(strong-1)&0xffffffff
  assert len(virtual_calls)==(int(strong==1)+int(strong==1 and weak==1))
 cases.append({'poison':poison,'prior':prior,'owner_id':owner_id,'component':component,'control':None if strong is None else control,'initial_strong':strong,'initial_weak':weak,'initial_words':initial,'words':snapshot(manager),'freed':list(freed),'locks':list(locks),'virtual_calls':list(virtual_calls),'final_strong':None if strong is None else read32(control+4),'final_weak':None if strong is None else read32(control+8),'retained_component_control':read32(component+8)})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual full6B2B20 owner-component destructor executes actual owner query/unregister and atomic strong/weak decrements.208 cases cover null control, zero/one/wrapping strong counts, weak0/1/2/FFFFFFFF, absent/null/self/other owner entries, sentinel skip and padding fills. No registry/helper result adapters.','Virtual disposal/control-release callbacks supplied and record counts without freeing control bytes; object-specific callback internals remain open. Owner metadata fields, allocator/lock imports and memmove primitive supplied. Normal return only; live atomic synchronization, throwing callbacks and complete actor destructor remain open.']}
(root/'data/4.20/audio_announcer_owner_component_destructor_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_owner_component_destructor_cases':len(cases),'passed':True}))
