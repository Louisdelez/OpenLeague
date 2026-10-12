"""Actual7056A0 disposal, unsigned multimap bounds and range iteration."""
from pathlib import Path
import sys,json,struct,hashlib,itertools,bisect
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/ambient_audio_context.json').read_text());e=next(p for p in Path(c['banks'][0]['path']).parents if p.name=='deploy')/'League of Legends.exe';raw=e.read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
p=pefile.PE(data=raw);u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(0x400000,(len(img)+4095)&~4095);u.mem_write(0x400000,img)
heap=0x30000000;stack=0x31000000;end=0x32000000
for a in [0,heap,stack,end]:u.mem_map(a,0x10000)
engine=heap;head=heap+0x800;nodes_base=heap+0x1000;obj=heap+0x3000;remaining=[];calls=[]
def read(a,fmt):return struct.unpack('<'+fmt,u.mem_read(a,struct.calcsize('<'+fmt)))
def put(a,fmt,*v):u.mem_write(a,struct.pack('<'+fmt,*v))
def node(i):return nodes_base+i*0x100

def rebuild():
 put(head,'3I',head,head,head);put(head+0xd,'B',1);put(engine+0x54,'2I',head,len(remaining))
 def branch(indices,parent):
  if not indices:return head
  mid=len(indices)//2;i=indices[mid];left=branch(indices[:mid],node(i));right=branch(indices[mid+1:],node(i));put(node(i),'3I',left,parent,right);put(node(i)+0xd,'B',0);put(node(i)+0x10,'I',keys[i]);return node(i)
 root=branch(remaining,head);put(head,'3I',node(remaining[0]) if remaining else head,root,node(remaining[-1]) if remaining else head)
def ret(value=None,pop=0):
 sp=u.reg_read(UC_X86_REG_ESP);target=read(sp,'I')[0]
 if value is not None:u.reg_write(UC_X86_REG_EAX,value)
 u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EIP,target)
def hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP);ecx=u.reg_read(UC_X86_REG_ECX)
 if a==0x6eb130:
  assert ecx==engine+0x54;out,k=read(sp+4,'2I');assert read(k,'I')[0]==request
 if a==0x5c2ce0:
  out,first,last=read(sp+4,'3I');assert ecx==engine+0x54
  lo=len(keys) if first==head else (first-nodes_base)//0x100;hi=len(keys) if last==head else (last-nodes_base)//0x100
  assert (lo,hi)==(bisect.bisect_left(keys,request),bisect.bisect_right(keys,request))
  calls.append({'kind':'erase_range','first':lo,'last':hi})
 if a==0x5c4420:
  out,target=read(sp+4,'2I');assert ecx==engine+0x54;i=(target-nodes_base)//0x100;pos=remaining.index(i);next_ptr=node(remaining[pos+1]) if pos+1<len(remaining) else head
  calls.append({'kind':'free_map_node','index':i});remaining.remove(i);rebuild();put(out,'I',next_ptr);ret(out,8);return
 if a==0x707170:
  assert ecx==obj;calls.append({'kind':'destroy_object'});ret();return
 if a==0xc98528:
  ptr=read(sp+4,'I')[0]
  if ptr==obj:calls.append({'kind':'free_object'})
  else:
   i=(ptr-nodes_base)//0x100;assert i in remaining;calls.append({'kind':'free_map_node','index':i});remaining.remove(i)
  ret();return
 assert any(s<=a<e for s,e in [(0x7056a0,0x7056ed),(0x7072f0,0x7072f4),(0x6eb130,0x6eb1a7),(0x5c2ce0,0x5c2d9d),(0x5c1370,0x5c13be),(0x707130,0x70716d)]),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
for n in range(6):
 for keys,request,present in itertools.product(itertools.combinations_with_replacement([0,1,42,0xffffffff],n),[0,1,42,43,0x80000000,0xffffffff],[False,True]):
  remaining=list(range(n));rebuild();put(obj,'2I',0x10af310,request);put(0x14bef40,'I',0);put(0,'I',0)
  calls.clear();sp=stack+0x8000;put(sp,'2I',end,obj if present else 0);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,engine);u.emu_start(0x7056a0,end,count=20000);assert u.reg_read(UC_X86_REG_EIP)==end
  expected_remaining=[i for i,k in enumerate(keys) if not present or k!=request];assert remaining==expected_remaining
  if present:
   assert calls[0]['kind']=='erase_range' and calls[-2:]==[{'kind':'destroy_object'},{'kind':'free_object'}]
   freed=[x['index'] for x in calls if x['kind']=='free_map_node'];assert sorted(freed)==[i for i,k in enumerate(keys) if k==request]
  else:assert not calls
  assert read(engine+0x58,'I')[0]==len(remaining)
  cases.append({'keys':list(keys),'request_raw':request,'wrapper_present':present,'remaining_indices':remaining.copy(),'calls':calls.copy()})
proof={'passed':True,'cases':cases,'native_sha256':digest,'limits':['Actual7056A0/7072F0/6EB130 multimap bounds/5C2CE0 range iteration/707130 deleting wrapper executed on0..5 entries/all multisets including duplicate IDs. Full-tree cleanup5C1370 recursion executed.','Partial single-node erase5C4420 explicitly adapted to remove/rebuild fixture tree; exact red-black balancing not qualified. Object destructor707170 adapted (separately684 cases); allocator free recorded.','Null wrapper skips everything. Otherwise all matching IDs removed before destroying only supplied wrapper, including no matching entry. ID0/FFFFFFFF have no special exclusion.','No actual heap reclamation or client audio. Configured free allocator excluded.'],'complete':False}
(r/'data/4.20/audio_engine_disposal_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Native engine object disposal',len(cases),'cases passed')
