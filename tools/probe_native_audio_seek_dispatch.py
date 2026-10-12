"""Original numeric seek API and type23 worker slice, with resource lookups adapted."""
from pathlib import Path
import json,struct,itertools,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py')
exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
event=heap+0x6000;actions=heap+0x7000;object_ptr=heap+0x8000;node=heap+0x8200;table=heap+0x8400;packet=heap+0x8600
calls=[];api_found=True;object_found=True;node_found=True;queue_result=1

def seek_hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xaf9530:ret(event if api_found else 0,4);return
 if a==0xb05ed0:
  pointer,length=read(sp+4,'II');assert length==24
  assert read(pointer+2,'H')[0]==0x23
  calls.append(dict(kind='packet',object_id=read(pointer+12,'I')[0],offset_raw=read(pointer+16,'I')[0],relative_raw=read(pointer+20,'B')[0],marker_raw=read(pointer+21,'B')[0]));ret(queue_result,8);return
 if a==0xb099d0:ret(object_ptr if object_found else 0,4);return
 if a==0xaf6480:
  ident,flag=read(sp+4,'II');assert flag==0;calls.append(dict(kind='lookup',target=ident));ret(node if node_found else 0,8);return
 if a==trap+0x100:
  ptr=read(sp+4,'I')[0];assert read(ptr,'I')[0]==4
  calls.append(dict(kind='seek',object_present=read(ptr+4,'I')[0]!=0,offset_raw=read(ptr+28,'I')[0],flags=read(ptr+32,'B')[0],action_kind=read(ptr+16,'I')[0],zero_words=list(read(ptr+8,'II'))));ret(0,4);return
 if a==trap+0x110:calls.append(dict(kind='node_release'));ret(0,0);return
 if a==trap+0x120:calls.append(dict(kind='event_release'));ret(0,0);return
 if a==0xb06f27:u.reg_write(UC_X86_REG_EIP,trap);u.emu_stop();return
 assert any(lo<=a<hi for lo,hi in [(0xaeb010,0xaeb075),(0xa1f350,0xa1f356),(0xb07183,0xb07289)]),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,seek_hook)
def invoke(start,args,ecx):
 sp=stack+0x8000;put(sp,'I',trap)
 for index,value in enumerate(args):put(sp+4+index*4,'I',value)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,ecx);u.emu_start(start,trap,count=10000)
 assert u.reg_read(UC_X86_REG_EIP)==trap
 return u.reg_read(UC_X86_REG_EAX)
api=[]
for api_found,oid,ms,marker,queue_result in itertools.product([False,True],[0,2,0xffffffff],[-500,0,250,2147483647,-2147483648],[0,1,2,255],[1,2]):
 calls.clear();result=invoke(0xaeb010,[123,oid,ms&0xffffffff,marker],0)
 assert result==(queue_result if api_found else 2)
 assert calls==([dict(kind='packet',object_id=oid,offset_raw=ms&0xffffffff,relative_raw=0,marker_raw=marker)] if api_found else [])
 api.append(dict(event_found=api_found,object_id=oid,milliseconds=ms,marker_raw=marker,queue_result=queue_result,result=result,calls=calls.copy()))
worker=[]
put(event,'I',table);put(table+8,'I',trap+0x120);put(event+16,'I',actions)
for index,(kind,target) in enumerate([(0x403,11),(0x503,22),(0x403,33)]):
 pointer=actions+index*0x100;put(pointer+16,'I',pointer+0x100 if index<2 else 0);put(pointer+28,'I',target);put(pointer+32,'H',kind)
put(node,'I',table+0x100);put(table+0x140,'I',trap+0x100);put(table+0x108,'I',trap+0x110)
for object_found,oid,ms,marker,node_found,fill in itertools.product([False,True],[0,2,0xffffffff],[-500,0,250],[0,1,2,255],[False,True],[0,0xa5]):
 calls.clear();u.mem_write(stack,bytes([fill])*0x10000);put(object_ptr+0x60,'I',0xc0000002)
 put(packet+8,'III',event,oid,ms&0xffffffff);put(packet+20,'BB',0,marker)
 u.reg_write(UC_X86_REG_EDI,packet);u.reg_write(UC_X86_REG_EBP,stack+0x8000);u.reg_write(UC_X86_REG_ESP,stack+0x7000);u.emu_start(0xb07183,trap,count=10000);assert u.reg_read(UC_X86_REG_EIP)==trap
 allowed=object_found or oid==0xffffffff
 assert [c['target'] for c in calls if c['kind']=='lookup']==([11,33] if allowed else [])
 seek=[c for c in calls if c['kind']=='seek'];assert len(seek)==(2 if allowed and node_found else 0)
 for c in seek:assert c==dict(kind='seek',object_present=object_found,offset_raw=ms&0xffffffff,flags=(fill&0xfc)|((marker&1)<<1),action_kind=4,zero_words=[0,0])
 assert calls[-1]==dict(kind='event_release')
 worker.append(dict(object_found=object_found,object_id=oid,milliseconds=ms,marker_raw=marker,node_found=node_found,stack_fill=fill,calls=calls.copy()))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(b).hexdigest(),api_cases=api,worker_cases=worker,entries=['AEB010','A1F350','B07183..B07284'],adapters=['Event lookupAF9530, object lookupB099D0 and node lookupAF6480 supplied. Object starts with acquired reference count2; original worker decrement executes.','QueueB05ED0 records24byte packet; nodevirtual40 records action kind4, object, raw milliseconds and flags; release callbacks recorded.','Worker slice enters at verified jump-table type23 target and exits commonB06F27; complete queue loop and target node seek not executed.'],limits=['Name hash already qualified separately; this API probe uses numeric event123.','Signed milliseconds pass unchanged; no clamp/sample conversion inferred.','Actual target-node propagation, marker/loop behavior and audio output remain unqualified.'])
(r/'data/4.20/audio_seek_dispatch_contract.json').write_text(json.dumps(proof,indent=2),encoding='utf-8');print(json.dumps(dict(passed=True,api_cases=len(api),worker_cases=len(worker))))
