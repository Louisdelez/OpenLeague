"""Actual FF1380 virtual144 B044E0 bank loader orchestration and control list."""
from pathlib import Path
import json,itertools,struct,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
node=heap+0x1000;parent=heap+0x2000;payload=heap+0x3000;blocks=[heap+0x5000+i*0x100 for i in range(4)];table=0xff1380
property_loader=read(table+0x11c,'I')[0];effects_loader=read(table+0x120,'I')[0];put(0x12100f4,'I',48000);calls=[];allocated=0;cfg={}
properties_pointer=heap+0x8000
regions=[(0xb023c0,0xb02427),(0xb02540,0xb025cf),(0xae0a10,0xae0a72),(0xae0a80,0xae0b01),(0xae1120,0xae1180),(0xb03ab0,0xb03aeb),(0xaffea0,0xaffeab),(0xb04c40,0xb04c8d),(0xb043f0,0xb044dd),(0xb225a0,0xb2262b),(0xb009b0,0xb00a40),(0xb00c20,0xb00c85),(0xb044e0,0xb046e4),(0xb02430,0xb02490)]
def guard(uc,a,n,d):
 global allocated
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xaf6480:
  ident,selector=read(sp+4,'II');calls.append({'kind':'lookup','id':ident,'selector':selector});ret(parent if cfg['found'] else 0,8);return
 if a==read(table+4,'I')[0]:calls.append({'kind':'retain','node':u.reg_read(UC_X86_REG_ECX)});ret(0,0);return
 if a==read(table+8,'I')[0]:calls.append({'kind':'release','node':u.reg_read(UC_X86_REG_ECX)});ret(0,0);return
 if a==read(table+0x24,'I')[0]:calls.append({'kind':'attach','parent':u.reg_read(UC_X86_REG_ECX),'child':read(sp+4,'I')[0]})
 if a==0xb03ab0:calls.append({'kind':'link','child':u.reg_read(UC_X86_REG_ECX),'parent':read(sp+4,'I')[0]})
 if a==0xb04c40:calls.append({'kind':'inherit_kind','node':u.reg_read(UC_X86_REG_ECX),'kind_value':read(sp+4,'I')[0]&255})
 if a==0xaff610:
  ptr=u.reg_read(UC_X86_REG_ECX);selector=0 if ptr==parent+0x40 else 1;calls.append({'kind':'reserve','selector':selector})
  if not reserve_failure:put(ptr,'I',parent_arrays[selector]);put(ptr+8,'I',4)
  ret(0 if reserve_failure else 1,4);return
 if a==property_loader:
  ptr,remaining=read(sp+4,'II');calls.append({'kind':'properties','offset':read(ptr,'I')[0]-payload,'remaining':read(remaining,'I')[0]})
 stage={effects_loader:'effects',0xb008b0:'rtpc',0xb000c0:'states',0xb00010:'position'}.get(a)
 if stage:
  ptr,remaining=read(sp+4,'II');calls.append({'kind':stage,'offset':read(ptr,'I')[0]-payload,'remaining':read(remaining,'I')[0]});ret(2 if cfg['failure_stage']==stage else 1,12 if stage=='effects' else 8);return
 if a==0xca1ef0:
  dest,src,length=read(sp+4,'III');u.mem_write(dest,bytes(u.mem_read(src,length)));ret(dest,0);return
 if a==0xada670:
  pool,size=read(sp+4,'II')
  if size!=0x1c:
   calls.append({'kind':'allocate_properties','size':size});ret(0 if property_failure else properties_pointer,0);return
  assert size==0x1c;calls.append({'kind':'allocate','size':size});value=0 if cfg['allocation_failure'] else blocks[allocated];allocated+=1;ret(value,0);return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
parent_arrays=[heap+0xa000,heap+0xa100];existing=[heap+0xc000,heap+0xc100];desc=[heap+0xe000,heap+0xe100];desc_array=heap+0xe800
layouts=[[],[(100,0x3f000000,7,2,3,4)],[(100,0x3f000000,7,2,3,4),(100,0x80000000,8,9,10,11)],[(100,0x3f000000,7,2,3,4),(200,0x3f800000,8,9,10,11)]]
rows=[]
for parent_id,found,attach,primary,secondary,failure_stage,layout_index,allocation_failure,property_layout,property_failure,populated,old_link,parent_kind,depth,full,reserve_failure in itertools.product([1234,55],[True],[1],[0],[0],[None],range(4),[False,True],[1],[False,True],[False,True],[0,heap+0x7000],[0,0x80],[0,2],[False,True],[False,True]):
 cfg={'found':found,'attach':attach,'failure_stage':failure_stage,'allocation_failure':allocation_failure};allocated=0;calls.clear();u.mem_write(node,bytes(0xc8));put(node,'I',table);put(node+8,'I',55);u.mem_write(node+0xc4,b'\xa5');put(node+0x78,'I',100);put(parent,'I',table);put(parent+8,'I',parent_id);u.mem_write(parent+0xc4,bytes([0x25|parent_kind]));u.mem_write(node+0x2f,b'\x02');put(node+0x24,'I',old_link)
 for address,ident in zip(existing,[55,200]):u.mem_write(address,bytes(200));put(address,'I',table);put(address+8,'I',ident)
 for selector,array in enumerate(parent_arrays):
  count=2 if populated else 0;u.mem_write(array,bytes(16));put(parent+0x40+selector*0x10,'III',array if count or not full else 0,count,count if full else 4)
  for i in range(count):put(array+i*4,'I',existing[i])
 put(node+0x50,'III',desc_array,depth,2)
 for i,address in enumerate(desc):u.mem_write(address,bytes(200));put(address,'I',table);u.mem_write(address+0xc4,b'\xa5')
 for i in range(depth):put(desc_array+i*4,'I',desc[i])
 before_parent=bytes(u.mem_read(parent,200)).hex()
 for address in blocks:u.mem_write(address,bytes(0x1c))
 u.mem_write(properties_pointer,b'\xa5'*128)
 put(0x14a7aac,'I',primary);put(0x14a7ab0,'I',secondary)
 properties=[[],[(2,0x42200000),(3,0x40b00000)],[(23,0xc0e80000),(24,0x40600000)]][property_layout];prefix=bytes([len(properties),*[key for key,value in properties]])+b''.join(struct.pack('<I',value) for key,value in properties)+bytes([1,0,1,0])+struct.pack('<H',3)+bytes([1])+struct.pack('<HH',0xffff,0x1234)+bytes([1,1]);raw=struct.pack('<II',55,parent_id)+prefix+struct.pack('<III',25,0x3f400000,len(layouts[layout_index]))
 for record in layouts[layout_index]:raw+=struct.pack('<IIIIBB',*record)
 u.mem_write(payload,raw);before=bytes(u.mem_read(node,0xc8)).hex();sp=stack+0x8000;put(sp,'III',trap,payload,len(raw));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,node);u.emu_start(read(table+0x144,'I')[0],trap,count=20000);assert u.reg_read(UC_X86_REG_EIP)==trap
 items=[];cursor=read(node+0x68,'I')[0]
 while cursor:
  assert cursor in blocks and len(items)<4;items.append({'reference':cursor,'words':read(cursor,'IIIIIII')});cursor=read(cursor,'I')[0]
 rows.append({'populated':populated,'old_link':old_link,'parent_kind':parent_kind,'depth':depth,'full':full,'reserve_failure':reserve_failure,'before_parent':before_parent,'after_parent':bytes(u.mem_read(parent,200)).hex(),'parent_lists':[[read(array+i*4,'I')[0] for i in range(read(parent+0x44+selector*0x10,'I')[0])] for selector,array in enumerate(parent_arrays)],'desc_flags':[read(address+0xc4,'B')[0] for address in desc[:depth]],'property_layout':property_layout,'property_failure':property_failure,'property_table':bytes(u.mem_read(properties_pointer,12)).hex() if property_layout and not property_failure and any(c['kind']=='allocate_properties' for c in calls) else None,'parent_id':parent_id,'found':found,'attach_result':attach,'primary':primary,'secondary':secondary,'failure_stage':failure_stage,'layout':layout_index,'allocation_failure':allocation_failure,'payload':raw.hex(),'before':before,'after':bytes(u.mem_read(node,0xc8)).hex(),'result':u.reg_read(UC_X86_REG_EAX),'primary_after':read(0x14a7aac,'I')[0],'secondary_after':read(0x14a7ab0,'I')[0],'items':items,'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()} for a,e in regions],'adapters':['Actual FF1380 virtual144 B044E0 executes parent lookup/attach ordering, root selection, raw control-list reading and stage short circuits unchanged. Actual B02430 list allocation/linking, existing-key mutation and count updates execute unchanged; heap allocator is an explicit result interface.','Only parent lookup/retain/release/reserve and effects/RTPC/state/position loaders are mandatory interfaces; actual parent B023C0/B02540/search/insertion/B03AB0/AFFEA0/B04C40 execute in bank loading. Actual B043F0/B225A0/B009B0/B00C20 property-prefix bodies execute unchanged, with allocator/memcpy interfaces. This is not a complete native bank payload; active group pointer1C is absent.'],'limits':['Preparatory evidence: dependency loader bodies and parent callbacks remain separately required; no complete bank format/runtime acceptance.','Sample rate48000 is an explicit global input; other rates, capacities/pool paths and resource lifetime require qualification.','No normal audio device/runtime acceptance.']}
(r/'data/4.20/audio_bus_bank_parent_properties_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual Bus bank loader with original parent attachment and property-prefix cases')
