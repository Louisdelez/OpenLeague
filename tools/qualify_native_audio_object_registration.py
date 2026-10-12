"""Native game object factory/constructor, registration packet11 and worker."""
from pathlib import Path
import sys,json,struct,hashlib,itertools
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,capstone,unicorn
from unicorn.x86_const import *
prior=json.loads((r/'data/4.20/audio_emitter_position_contract.json').read_text())
b=Path(prior['provenance']['executable']).read_bytes();assert hashlib.sha256(b).hexdigest()==prior['provenance']['sha256']
p=pefile.PE(data=b);base=p.OPTIONAL_HEADER.ImageBase
areas=[(0x7055d0,0x705691),(0x707080,0x707124),(0x7072f0,0x7072f4),(0xaeaee0,0xaeaf30),
 (0xb073fe,0xb07412),(0xb09bf0,0xb09ca2),(0xaf5ce0,0xaf5d77),(0xaf6270,0xaf6284),(0xb09d10,0xb09d86)]
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);regions=[]
for a,e in areas:
 blob=p.get_data(a-base,e-a);ins=list(md.disasm(blob,a));assert sum(i.size for i in ins)==len(blob),(hex(a),hex(e))
 regions.append({'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(blob).hexdigest(),'instructions':[{'address':hex(i.address),'bytes':i.bytes.hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in ins]})
assert struct.unpack('<I',p.get_data(0xb07d78+11*4-base,4))[0]==0xb073fe
heap,stack,trap=0x30000000,0x31000000,0x32000000
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
for a in [0,heap,stack,trap]:u.mem_map(a,0x10000 if a else 0x1000)
manager,wrapper,map_slot,registered,node,message=[heap+i for i in [0,0x1000,0x2000,0x3000,0x4000,0x5000]]
def put(a,fmt,*v):u.mem_write(a,struct.pack('<'+fmt,*v))
def read(a,fmt):return struct.unpack('<'+fmt,u.mem_read(a,struct.calcsize('<'+fmt)))
def ret(v,cleanup):
 sp=u.reg_read(UC_X86_REG_ESP);target=read(sp,'I')[0];u.reg_write(UC_X86_REG_EAX,v);u.reg_write(UC_X86_REG_ESP,sp+4+cleanup);u.reg_write(UC_X86_REG_EIP,target)
available=True;wrapper_fail=False;object_fail=False;node_fail=False;queue_result=1;packets=[];calls=[]
def hook(uc,a,n,d):
 if a==0xaea6b0:ret(int(available),0);return
 if a==0xc9f39b:
  size=read(u.reg_read(UC_X86_REG_ESP)+4,'I')[0];assert size==40
  calls.append('allocate_wrapper');ret(0 if wrapper_fail else wrapper,0);return
 if a==0x64d040:
  ptr=read(u.reg_read(UC_X86_REG_ESP)+4,'I')[0];assert read(ptr,'I')[0]==read(wrapper+4,'I')[0]
  calls.append('insert_wrapper');ret(map_slot,4);return
 if a==0x5bfee0:ret(56,0);return
 if a==0xb05ed0:
  ptr,size=read(u.reg_read(UC_X86_REG_ESP)+4,'II');assert size==56
  data=u.mem_read(ptr,20);assert read(ptr+2,'H')[0]==11
  packets.append({'type':11,'object_id':struct.unpack_from('<I',data,8)[0],
   'listener_mask':struct.unpack_from('<I',data,12)[0],'extra_raw':struct.unpack_from('<I',data,16)[0]})
  ret(queue_result,8);return
 if a==0xada670:
  size=read(u.reg_read(UC_X86_REG_ESP)+8,'I')[0];assert size in [100,12]
  calls.append('allocate_object' if size==100 else 'allocate_node')
  ret((0 if object_fail else registered) if size==100 else (0 if node_fail else node),0);return
 if a==0xaf5d80:calls.append('destroy_object');ret(0,0);return
 if a==0xada3e0:
  ptr=read(u.reg_read(UC_X86_REG_ESP)+8,'I')[0];assert ptr==registered
  calls.append('free_object');ret(0,0);return
 if a==0xb07412:u.emu_stop();return
 assert any(s<=a<e for s,e in areas),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def invoke(start,args,ecx):
 sp=stack+0x8000;put(sp,'I',trap)
 for i,v in enumerate(args):put(sp+4+i*4,'I',v)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,ecx);u.emu_start(start,trap,count=10000)
 assert u.reg_read(UC_X86_REG_EIP)==trap
 return u.reg_read(UC_X86_REG_EAX)
orientation=[0x3f000000,0xbf400000,0x3f800000];factories=[]
for counter,available,wrapper_fail,queue_result in itertools.product([0,1,123,0xfffffffe,0xffffffff],[False,True],[False,True],[1,2]):
 u.mem_write(heap,b'\0'*0x6000);put(0x1224d20,'I',counter);put(0x2d77b20,'B',1);put(0x14bef58,'I',0)
 put(0x2d773b4,'3I',*orientation);packets.clear();calls.clear()
 result=invoke(0x7055d0,[],manager)
 assert read(0x1224d20,'I')[0]==(counter+1)&0xffffffff
 assert result==(0 if wrapper_fail else wrapper)
 fields=None
 if not wrapper_fail:
  assert read(wrapper+4,'I')[0]==counter;assert read(wrapper+8,'3I')==tuple(orientation)
  assert read(wrapper+0x14,'I')[0]==0 and read(wrapper+0x18,'B')[0]==1
  assert read(wrapper+0x1c,'3I')==(0,0,0);assert read(map_slot,'I')[0]==wrapper
  fields={'object_id':counter,'orientation_words':orientation,'field14':0,'field18':1,'collection_words':[0,0,0]}
 expected=[{'type':11,'object_id':counter,'listener_mask':1,'extra_raw':0}] if not wrapper_fail and available and counter not in [0,0xffffffff] else []
 assert packets==expected
 factories.append({'counter':counter,'engine_available':available,'allocation_failure':wrapper_fail,'queue_result':queue_result,
  'next_counter':read(0x1224d20,'I')[0],'created':not wrapper_fail,'fields':fields,'packets':packets.copy(),'calls':calls.copy()})
registrations=[]
for existing,seed,mask,object_fail,node_fail in itertools.product([False,True],[0,0xa5,0xff],[0,1,255,256,0xffffffff],[False,True],[False,True]):
 u.mem_write(heap,b'\0'*0x6000);u.mem_write(registered,bytes([seed])*100)
 obj=386;put(manager+0x1c,'I',1);put(0x14a7a04,'I',manager)
 if existing:
  put(manager+0x20,'I',node);put(node,'III',0,obj,registered)
  put(registered+4,'I',heap+0x8000);put(registered+8,'H',3)
  put(registered+0xb,'B',seed);put(registered+0x60,'I',0x12345678)
 put(message+8,'III',obj,mask,0)
 calls.clear();sp=stack+0x8000;put(sp,'I',trap)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EDI,message)
 u.emu_start(0xb073fe,trap,count=10000);assert u.reg_read(UC_X86_REG_EIP)==0xb07412
 success=existing or not(object_fail or node_fail)
 assert u.reg_read(UC_X86_REG_EAX)==(registered if success else 0)
 fields=None
 if success:
  fields={'count':read(registered+8,'H')[0],'mask':read(registered+0xa,'B')[0],
   'mode':read(registered+0xb,'B')[0],'dirty':read(registered+0x60,'I')[0]}
  assert fields=={'count':3 if existing else 0,'mask':mask&0xff,'mode':seed if existing else seed&0xf8,'dirty':0x52345678 if existing else 0xc0000001}
  if not existing:
   assert read(registered+4,'I')[0]==0
   assert read(registered+0x48,'2I')==(0x3f800000,0x3f800000)
   assert read(registered+0x5c,'I')[0]==obj
 if existing:assert calls==[]
 elif object_fail:assert calls==['allocate_object']
 elif node_fail:assert calls==['allocate_object','allocate_node','destroy_object','free_object']
 else:assert calls==['allocate_object','allocate_node']
 registrations.append({'existing':existing,'allocation_seed':seed,'mask':mask,'object_allocation_failure':object_fail,
  'node_allocation_failure':node_fail,'created_or_existing':success,'fields':fields,'calls':calls.copy()})
result={'passed':True,'factory_cases':factories,'registration_cases':registrations,'regions':regions,'provenance':prior['provenance'],
 'wrapper_orientation_words':orientation,
 'stubs':['C9F39B wrapper allocator returns fixed buffer/zero;64D040 wrapper map insertion captures slot;AEA6B0 availability;5BFEE0 packet size56;B05ED0 packet capture/return.',
 'ADA670 object/node allocators explicit fixed buffers/failures;AF5D80 destructor captured;ADA3E0 free captured. Native pool hash insertion B09D10, object ctorAF5CE0, mask setterAF6270 and worker11 call execute.'],
 'limits':['SEH fs:[0] storage mapped in emulator; native exception handling and custom allocator paths not exercised.',
 'Wrapper map container64D040 not executed; registered object hash collision test covered in prior storage contract but new registration inserts empty bucket.',
 'Constructor leaves upper5 mode bits from allocator bytes unchanged; they are not initialized native defaults.',
 'Wrapper orientation initial words come from direction global2D773B4; not a source position.',
 'Unregister/destruction, full queue scheduling, all extended object fields and audible playback not qualified.'],'complete':False}
(r/'data/4.20/audio_object_registration_contract.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print('Native object registration:',len(factories),'factory cases;',len(registrations),'worker cases')