"""Original6CE2D0 unsigned registry lookup and706EA0/706F90 release before erase."""
from pathlib import Path
import json,struct,itertools,hashlib
r=Path(__file__).resolve().parents[1]
setup=(r/'tools/qualify_native_audio_release.py').read_text().split('\nrelease_cases=[]\n')[0]
setup=setup.replace('u.hook_add(unicorn.UC_HOOK_CODE,guard)','')
exec(compile(setup,'release_setup','exec'))
backend=heap+0x800;head=heap+0x900;nodes={key:heap+0x1000+i*0x100 for i,key in enumerate([0,42,0xffffffff])};voices={key:heap+0x2000+i*0x100 for i,key in enumerate([0,42,0xffffffff])};remaining=[]
def rebuild():
 put(head,'3I',head,head,head);put(head+0xd,'B',1);put(backend+4,'I',head)
 def branch(keys,parent):
  if not keys:return head
  mid=len(keys)//2;key=keys[mid];node=nodes[key];left=branch(keys[:mid],node);right=branch(keys[mid+1:],node);put(node,'3I',left,parent,right);put(node+0xd,'B',0);put(node+0x10,'2I',key,voices[key]);return node
 root=branch(remaining,head);put(head+4,'I',root)
def backend_hook(uc,a,size,user):
 if a==0x5dee10:
  sp=uc.reg_read(UC_X86_REG_ESP);out,node=struct.unpack('<II',uc.mem_read(sp+4,8));assert uc.reg_read(UC_X86_REG_ECX)==backend+4
  key=struct.unpack('<I',uc.mem_read(node+0x10,4))[0];assert key in remaining;calls.append({'kind':'erase','reference':key});remaining.remove(key);rebuild();ret(uc,out,8);return
 if 0x6ce2d0<=a<0x6ce336 or 0x706ea0<=a<0x706ea5:return
 guard(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,backend_hook)
cases=[]
for keys,request,released,available,stop_found,post_success in itertools.product([[],[0,42,0xffffffff]],[0,1,42,43,0x80000000,0xffffffff],[False,True],[False,True],[False,True],[False,True]):
 remaining=list(keys);rebuild();post_result=99 if post_success else 0;stop_id=9 if stop_found else 0
 for key,voice in voices.items():
  u.mem_write(voice,b'\0'*0x80);put(voice,'I',0x10af338);put(voice+4,'Ii',456,123);put(voice+0x28,'I',stop_id);put(voice+0x48,'B',int(released))
 put(0x14a7a28,'I',heap+0x700);calls.clear()
 for _ in range(2):invoke(0x6ce2d0,(request,),receiver=backend)
 found=request in keys;expected=[]
 if found:
  if not released and available:
   if stop_found:expected.append({'kind':'post_stop_event','event_id':9,'object_id':123})
   if not (stop_found and post_success):expected.append({'kind':'stop_playing_id','playing_id':456,'duration_ms':0,'curve':4})
  expected.append({'kind':'erase','reference':request})
 assert calls==expected;assert remaining==[k for k in keys if k!=request]
 final_flag=bool(u.mem_read(voices[request]+0x48,1)[0]) if found else None;assert final_flag==(released or available) if found else final_flag is None
 cases.append({'keys':keys,'request_raw':request,'released':released,'engine_available':available,'stop_found':stop_found,'post_success':post_success,'repeat_runs':2,'calls':list(calls),'remaining_keys':list(remaining),'final_released':final_flag})
proof={'passed':True,'cases':cases,'native_sha256':hashlib.sha256(b).hexdigest(),'limits':['Original6CE2D0 unsigned tree lookup/706EA0 tailcall/706F90 release/AEB740 fallback message executed on empty and balanced three-key trees. Missing/zero/high-bit/FFFFFFFF keys tested; duplicate release after erase is ignored.','Map erase5DEE10 is explicit adapter recording removal and rebuilding fixture tree; actual red-black erase/owner destructor is not executed here. Shared final-owner destruction separately qualified144 cases.','Readiness/PostStopEvent/queue/logging adapters retained; no actual PCM/fade or client consumer. Non-null registered voice invariant; invalid null node payload excluded.'],'complete':False}
(r/'data/4.20/audio_backend_release_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Original backend registry release',len(cases),'cases/two requests passed')
