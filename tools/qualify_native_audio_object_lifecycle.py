"""Native game-object point update, reference acquisition and unregister ownership."""
from pathlib import Path
import sys,json,struct,hashlib,itertools
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,capstone,unicorn
from unicorn.x86_const import *
prior=json.loads((r/'data/4.20/audio_emitter_position_contract.json').read_text());b=Path(prior['provenance']['executable']).read_bytes()
assert hashlib.sha256(b).hexdigest()==prior['provenance']['sha256']
p=pefile.PE(data=b);base=p.OPTIONAL_HEADER.ImageBase;md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
areas=[(0x707420,0x707496),(0xaeb1c0,0xaeb1da),(0xaeb1e0,0xaeb237),(0xaebc10,0xaebc4e),
 (0xb0a1a0,0xb0a211),(0xb09970,0xb099cd),(0xb098f0,0xb09969),(0xb099d0,0xb09a24),(0xb0a0c0,0xb0a192),(0xb10810,0xb1085e)]
regions=[]
for a,e in areas:
 blob=p.get_data(a-base,e-a);ins=list(md.disasm(blob,a));assert sum(i.size for i in ins)==len(blob)
 regions.append({'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(blob).hexdigest(),'instructions':[{'address':hex(i.address),'bytes':i.bytes.hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in ins]})
multiplier=struct.unpack('<f',p.get_data(0x1139390-base,4))[0];assert multiplier==-2500.
heap,stack,trap=0x30000000,0x31000000,0x32000000
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
for a in [heap,stack,trap]:u.mem_map(a,0x10000)
def put(a,fmt,*v):u.mem_write(a,struct.pack('<'+fmt,*v))
def read(a,fmt):return struct.unpack('<'+fmt,u.mem_read(a,struct.calcsize('<'+fmt)))
def ret(v,cleanup):
 sp=u.reg_read(UC_X86_REG_ESP);target=read(sp,'I')[0];u.reg_write(UC_X86_REG_EAX,v);u.reg_write(UC_X86_REG_ESP,sp+4+cleanup);u.reg_write(UC_X86_REG_EIP,target)
available=True;messages=[];calls=[];node_ptrs=set();object_ptrs=set()
manager,wrapper,registered,node,other,source=[heap+i for i in [0,0x1000,0x2000,0x3000,0x3100,0x4000]]
def hook(uc,a,n,d):
 if a==0xaea6b0:ret(int(available),0);return
 if a in [0x87cd10,0x83bb30]:ret(56,0);return
 if a==0xc975f5:ret(0,0);return
 if a==0xb05ed0:
  ptr,size=read(u.reg_read(UC_X86_REG_ESP)+4,'II');assert size==56
  typ=read(ptr+2,'H')[0]
  msg={'type':typ,'object_id':read(ptr+8,'I')[0]}
  if typ==13:msg.update({'position_bits':list(read(ptr+12,'3I')),'opaque_tail':list(read(ptr+24,'3I'))})
  else:assert typ==12
  messages.append(msg);ret(1,8);return
 if a==0xada3e0:
  ptr=read(u.reg_read(UC_X86_REG_ESP)+8,'I')[0];assert ptr in {node,registered}|node_ptrs|object_ptrs
  calls.append('free_node' if ptr==node or ptr in node_ptrs else 'free_object');ret(0,0);return
 if a==0xaf5d80:calls.append('destroy_object');ret(0,0);return
 assert any(s<=a<e for s,e in areas),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def invoke(start,args,ecx=manager):
 sp=stack+0x8000;put(sp,'I',trap)
 for i,v in enumerate(args):put(sp+4+4*i,'I',v)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,ecx);u.emu_start(start,trap,count=10000)
 assert u.reg_read(UC_X86_REG_EIP)==trap
 return u.reg_read(UC_X86_REG_EAX)
positions=[]
for obj,height,available,seed in itertools.product([0,123,0xffffffff],[0.,0.25,1.,-0.5],[False,True],[0,0x7fc00000]):
 u.mem_write(heap,b'\0'*0x5000);u.mem_write(stack,struct.pack('<I',seed)*(0x10000//4))
 put(wrapper+4,'I',obj);put(wrapper+0x14,'f',height)
 point=[7400.,1500.,7700.];put(source,'3f',*point);messages.clear()
 invoke(0x707420,[source],wrapper)
 assert list(read(wrapper+8,'3f'))==point
 expected=[] if not available or obj==0 else [{'type':13,'object_id':obj,'position_bits':list(struct.unpack('<3I',struct.pack('<3f',point[0],height*multiplier,point[2]))),'opaque_tail':[seed]*3}]
 assert messages==expected
 positions.append({'object_id':obj,'height_raw':height,'engine_available':available,'stack_seed':seed,'input_point':point,
  'stored_point_bits':list(read(wrapper+8,'3I')),'messages':messages.copy()})
packets=[]
for obj in [0,1,123,0xffffffff]:
 messages.clear();result=invoke(0xaebc10,[obj])
 assert len(messages)==int(obj!=0);assert result==(2 if obj==0 else 1)
 packets.append({'object_id':obj,'messages':messages.copy(),'result':result})
flags=[0,1,2,0x3fffffff,0x40000000,0x40000001,0x80000001,0xc0000001,0xc0000002,0xffffffff]
acquisitions=[];unregister=[]
def setup(found,link,flag):
 u.mem_write(heap,b'\0'*0x5000)
 # Object386 shares hash bucket0 with objects193 and579.
 put(manager+0x1c,'I',1);put(manager+0x324,'I',2 if found else 1)
 if link==0:put(manager+0x20,'I',node if found else other);put(node,'III',other,386,registered);put(other,'III',0,193,registered+0x100)
 else:put(manager+0x20,'I',other);put(other,'III',node if found else 0,193,registered+0x100);put(node,'III',0,386,registered)
 put(registered+0x60,'I',flag)
for found,flag in itertools.product([False,True],flags):
 setup(found,1,flag);result=invoke(0xb099d0,[386])
 expected=(flag&0xc0000000)|((flag+1)&0x3fffffff) if found else flag
 assert read(registered+0x60,'I')[0]==expected;assert result==(registered if found else 0)
 acquisitions.append({'found':found,'prior_flags':flag,'after_flags':expected})
for found,link,flag in itertools.product([False,True],[0,1],flags):
 setup(found,link,flag);calls.clear();invoke(0xb0a1a0,[386])
 expected=((flag&0x40000000)|((flag-1)&0x3fffffff)) if found else flag
 assert read(registered+0x60,'I')[0]==expected
 destroyed=found and expected&0x3fffffff==0
 assert calls==(['free_node']+(['destroy_object','free_object'] if destroyed else []) if found else [])
 assert read(manager+0x324,'I')[0]==1
 assert read(manager+0x20,'I')[0]==other
 if link==1:assert read(other,'I')[0]==0
 unregister.append({'found':found,'collision_position':link,'prior_flags':flag,'after_flags':expected,'destroyed':destroyed,'calls':calls.copy(),'registered_after':False})
all_cases=[]
for ids,flag in itertools.product([[],[0],[193],[0,193,386,1,192]],flags):
 u.mem_write(heap,b'\0'*0xa000);put(manager+0x1c,'I',1);put(manager+0x324,'I',len(ids))
 node_ptrs.clear();object_ptrs.clear();addresses={}
 for i,obj in enumerate(ids):
  np=heap+0x6000+i*0x100;op=heap+0x8000+i*0x100
  node_ptrs.add(np);object_ptrs.add(op);addresses[obj]=op;bucket=manager+0x20+(obj%193)*4
  previous=read(bucket,'I')[0];put(np,'III',previous,obj,op);put(bucket,'I',np);put(op+0x60,'I',flag)
 calls.clear();invoke(0xb0a0c0,[])
 after=[]
 for obj,op in addresses.items():
  expected=flag if obj==0 else (flag&0xc0000000)|((flag-1)&0x3fffffff)
  assert read(op+0x60,'I')[0]==expected
  after.append({'object_id':obj,'prior_flags':flag,'after_flags':expected,'registered_after':obj==0,'destroyed':obj!=0 and expected&0x3fffffff==0})
 assert read(manager+0x324,'I')[0]==int(0 in ids)
 assert calls.count('free_node')==len(ids)-int(0 in ids)
 assert calls.count('destroy_object')==sum(a['destroyed'] for a in after)
 assert calls.count('free_object')==sum(a['destroyed'] for a in after)
 for bucket in range(193):
  pointer=read(manager+0x20+bucket*4,'I')[0]
  if pointer:
   assert read(pointer+4,'I')[0]==0 and read(pointer,'I')[0]==0
 all_cases.append({'input_ids':ids,'prior_flags':flag,'objects':after,'calls':calls.copy()})
out={'passed':True,'position_cases':positions,'unregister_packet_cases':packets,'acquire_cases':acquisitions,'unregister_cases':unregister,
 'unregister_all_cases':all_cases,'height_multiplier':multiplier,'regions':regions,'provenance':prior['provenance'],
 'stubs':['Availability;packet size56;queue packet capture;security check. Native707420 changes cached XYZ then submits source[X,heightField14*-2500,Z];opaque tail explicit.',
 'ADA3E0 captures node/object free;AF5D80 captures destruction. Original hash find/erase and reference flag mutations executed.'],
 'limits':['Game-object point setter differs from ambient706DF0: it overwrites sourceY using field14, even though cachedXYZ retains inputY. Native height-control producer not qualified.',
 'Unregister removes registry node immediately; object stays allocated when low30 reference count remains nonzero. Native destruction and final retained-voice release internals not executed.',
 'Unregister-all B0A0C0 skips objectID0 and decrements other objects without clearing upper registered bit; single-object B0A1A0 clears bit31 first. Original all-worker/iteration executed; full scheduler not executed.',
 'Invalid zero-reference states included for bit-exact wrapping behavior, not evidence such states occur in ordinary playback.',
 'No live audio or full ownership/queue worker scheduling acceptance.'],'complete':False}
(r/'data/4.20/audio_object_lifecycle_contract.json').write_text(json.dumps(out,indent=2)+'\n',encoding='utf-8')
print('Native lifecycle:',len(positions),'point cases;',len(packets),'unregister packets;',len(acquisitions),'acquires;',len(unregister),'unregisters')
print('Native unregister-all:',len(all_cases),'cases')
