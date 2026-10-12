"""Actual Bus parent attach B023C0/B02540 and B03AB0/AFFEA0 kind propagation."""
from pathlib import Path
import json,itertools,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
parent=heap+0x1000;child=heap+0x2000;existing=[heap+0x6000,heap+0x6100];desc=[heap+0x6500,heap+0x6600];arrays=[heap+0x5000,heap+0x5100];desc_array=heap+0x5400;calls=[];reserve_failure=False
regions=[(0xb023c0,0xb02427),(0xb02540,0xb025cf),(0xae0a10,0xae0a72),(0xae0a80,0xae0b01),(0xae1120,0xae1180),(0xb03ab0,0xb03aeb),(0xaffea0,0xaffeab),(0xb04c40,0xb04c8d)]
def guard(uc,a,n,d):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xafe1a0:calls.append({'kind':'retain','node':u.reg_read(UC_X86_REG_ECX)});ret(0,0);return
 if a==0xb00180:calls.append({'kind':'release','node':u.reg_read(UC_X86_REG_ECX)});ret(0,0);return
 if a==0xaff610:
  ptr=u.reg_read(UC_X86_REG_ECX);selector=0 if ptr==parent+0x40 else 1;calls.append({'kind':'reserve','selector':selector});
  if not reserve_failure:put(ptr,'I',arrays[selector]);put(ptr+8,'I',4)
  ret(0 if reserve_failure else 1,4);return
 if a==0xb03ab0:calls.append({'kind':'link','child':u.reg_read(UC_X86_REG_ECX),'parent':read(sp+4,'I')[0]})
 if a==0xb04c40:calls.append({'kind':'inherit_kind','node':u.reg_read(UC_X86_REG_ECX),'kind_value':read(sp+4,'I')[0]&255})
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
rows=[]
for child_id,parent_id,flags,old_link,populated,parent_kind,child_kind,depth,full,reserve_failure in itertools.product([1,101,202,303,0xffffffff],[1,202],[0,2,0xa5,0xff],[0,heap+0x7000],[False,True],[0,0x80],[0,0x80],[0,2],[False,True],[False,True]):
 for address in [parent,child,*existing,*desc]:u.mem_write(address,bytes(200));put(address,'I',0xff1380)
 put(parent+8,'I',parent_id);put(child+8,'I',child_id);put(child+0x24,'I',old_link);u.mem_write(child+0x2f,bytes([flags]));u.mem_write(parent+0xc4,bytes([0x25|parent_kind]));u.mem_write(child+0xc4,bytes([0x25|child_kind]))
 for i,address in enumerate(existing):put(address+8,'I',[101,303][i])
 for selector,array in enumerate(arrays):
  u.mem_write(array,bytes(16));count=2 if populated else 0;put(parent+0x40+selector*0x10,'III',array if count or not full else 0,count,count if full else 4)
  for i in range(count):put(array+i*4,'I',existing[i])
 put(child+0x50,'III',desc_array,depth,2)
 for i in range(depth):put(desc_array+i*4,'I',desc[i]);u.mem_write(desc[i]+0xc4,bytes([0x25|child_kind]))
 before_parent=bytes(u.mem_read(parent,200)).hex();before_child=bytes(u.mem_read(child,200)).hex();calls.clear();sp=stack+0x8000;put(sp,'II',trap,child);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,parent);u.emu_start(0xb023c0,trap,count=10000);assert u.reg_read(UC_X86_REG_EIP)==trap
 lists=[]
 for selector,array in enumerate(arrays):lists.append([read(array+i*4,'I')[0] for i in range(read(parent+0x44+selector*0x10,'I')[0])])
 rows.append({'child_id':child_id,'parent_id':parent_id,'flags':flags,'old_link':old_link,'populated':populated,'parent_kind':parent_kind,'child_kind':child_kind,'depth':depth,'full':full,'reserve_failure':reserve_failure,'before_parent':before_parent,'before_child':before_child,'after_parent':bytes(u.mem_read(parent,200)).hex(),'after_child':bytes(u.mem_read(child,200)).hex(),'desc_flags':[read(address+0xc4,'B')[0] for address in desc[:depth]],'lists':lists,'result':u.reg_read(UC_X86_REG_EAX),'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()} for a,e in regions],'adapters':['Only retain/release and vector-reserve interfaces adapted. Actual B023C0/B02540, AE0A80/AE0A10/AE1120 binary search and sorted insertion, B03AB0/AFFEA0 bus24 assignment and B04C40 recursive kind-bit propagation execute native instructions.','Constructed acyclic descendant graphs and raw selector flags; flagbit1 selects Sound/Bus child lists. This does not prove native bank constructors create all raw flag combinations.'],'limits':['Preparatory parent attachment evidence; Rust implementation and bank backend integration remain open.','Reference-counter registry lifetime, reserve allocator growth/ownership, native detachment and normal resource creation remain open.','No normal audio runtime/device acceptance.']}
(r/'data/4.20/audio_bus_parent_attachment_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual Bus parent attachment/search/insertion/recursive kind propagation cases')
