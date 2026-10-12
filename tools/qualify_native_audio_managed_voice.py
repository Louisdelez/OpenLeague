"""Actual shared last-owner release through voice destructor and control free."""
from pathlib import Path
import json,itertools,struct
r=Path(__file__).resolve().parents[1]
setup=(r/'tools/qualify_native_audio_voice_destruction.py').read_text().split('\ncases=[]\n')[0]
setup=setup.replace('u.hook_add(unicorn.UC_HOOK_CODE,destruction_hook)','')
exec(compile(setup,'destruction_setup','exec'))
control=heap+0x200;shared=heap+0x300
prior_hook=destruction_hook

def managed_hook(uc,a,size,user):
 if a==0xc98528:
  ptr=struct.unpack('<I',uc.mem_read(uc.reg_read(UC_X86_REG_ESP)+4,4))[0];assert ptr in [heap,control];calls.append({'kind':'free_voice' if ptr==heap else 'free_control'});ret(uc,0);return
 if any(s<=a<e for s,e in [(0x5bd3c0,0x5bd3f3),(0x5a3220,0x5a322e),(0x5d5b40,0x5d5b4c),(0x5d6840,0x5d687e),(0x7073a9,0x7073ba)]):return
 prior_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,managed_hook)
cases=[]
for strong,weak,present,flag49,released,available in itertools.product([1,2,3],[1,2,3],[False,True],[0,1],[False,True],[False,True]):
 u.mem_write(heap,b'\0'*0x400);put(heap,'I',0x10af338);put(heap+4,'Ii',42,123);put(heap+0x28,'I',9);put(heap+0x48,'BB',int(released),flag49);put(0x14a7a28,'I',heap+0x900);put(0x14bef40,'I',0);put(0,'I',0);put(control,'4I',0x1085f4c,strong,weak,heap if present else 0);put(shared,'2I',heap if present else 0,control);post_result=0
 calls.clear();milestones=[]
 for i in range(strong):
  invoke(0x5bd3c0,receiver=shared)
  s,w=struct.unpack('<II',u.mem_read(control+4,8));assert s==strong-i-1 and w==(weak if s else weak-1)
  if s:assert not calls
  milestones.append({'strong':s,'weak':w,'calls':list(calls)})
 assert sum(x['kind']=='destroy_stop_string' for x in calls)==int(present)
 assert sum(x['kind']=='free_voice' for x in calls)==int(present)
 after_last=list(calls);expected=[]
 if present:
  if flag49 and not released and available:expected.extend([{'kind':'post_stop_event','event_id':9,'object_id':123},{'kind':'stop_playing_id','playing_id':42,'duration_ms':0,'curve':4}])
  expected.extend([{'kind':'destroy_stop_string'},{'kind':'destroy_play_string'},{'kind':'free_voice'}])
 if weak==1:expected.append({'kind':'free_control'})
 assert calls==expected
 # Native weak decrement/free fragment from object tick; no fabricated control free.
 for i in range(weak-1):
  put(stack+0x3800,'I',tramp);u.reg_write(UC_X86_REG_ESP,stack+0x3800);u.reg_write(UC_X86_REG_ECX,control);u.emu_start(0x7073a9,0x7073ba,count=10000);assert u.reg_read(UC_X86_REG_EIP)==0x7073ba
 assert sum(x['kind']=='free_control' for x in calls)==1
 cases.append({'strong_before':strong,'weak_before':weak,'voice_present':present,'flag49_raw':flag49,'released':released,'engine_available':available,'milestones':milestones,'after_last_owner':after_last,'after_all_weak':list(calls)})
proof={'passed':True,'cases':cases,'native_sha256':hashlib.sha256(b).hexdigest(),'limits':['Original5BD3C0 shared decrement ->5A3220 voice destroy ->706BC0/706F90 release ->5D5B40/5D6840 control free executed; native7073A9 weak decrement fragment drains remaining weak references.','Actual stop PostEvent/queue/free/string operations retain explicit adapters from destructor qualification; configured allocator/free branches excluded.','Last strong owner destroys voice once even while weak owners remain; final weak owner frees control later. Null voice controls free without voice destruction.','No real backend PCM, thread scheduling or client playback measured.'],'complete':False}
(r/'data/4.20/audio_managed_voice_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Native managed voice final ownership',len(cases),'cases passed')
