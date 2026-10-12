"""Original706BC0 voice destruction, actual release706F90 and StopPlaying queue."""
from pathlib import Path
import json,itertools,hashlib,struct
r=Path(__file__).resolve().parents[1]
setup=(r/'tools/qualify_native_audio_release.py').read_text().split('release_cases=[]')[0]
setup=setup.replace('u.hook_add(unicorn.UC_HOOK_CODE,guard)','')
exec(compile(setup,'release_setup','exec'));u.mem_map(0,0x10000)
assert hashlib.sha256(b).hexdigest()=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
def destruction_hook(uc,a,size,user):
 if a==0x564900:
  offset=uc.reg_read(UC_X86_REG_ECX)-heap;assert offset in [0x10,0x2c];calls.append({'kind':'destroy_stop_string' if offset==0x2c else 'destroy_play_string'});ret(uc,0);return
 if a==0xc98528:
  ptr=struct.unpack('<I',uc.mem_read(uc.reg_read(UC_X86_REG_ESP)+4,4))[0];assert ptr==heap;calls.append({'kind':'free_voice'});ret(uc,0);return
 if 0x706bc0<=a<0x706c6a:return
 guard(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,destruction_hook)
cases=[]
for flag49,released,available,stop_id,obj,post_result,playing,delete_flags in itertools.product([0,1,255],[False,True],[False,True],[0,3068939807],[-1,123],[0,99],[0,456],[0,1,2,3]):
 u.mem_write(heap,b'\0'*0x100);put(heap+4,'Ii',playing,obj);put(heap+0x28,'I',stop_id);put(heap+0x48,'BB',int(released),flag49);put(0x14a7a28,'I',heap+0x900);put(0x14bef40,'I',0);put(0,'I',0)
 calls.clear();answer=invoke(0x706bc0,(delete_flags,));assert answer==heap
 expected=[];final_released=released
 if flag49 and not released and available:
  posted=stop_id!=0 and obj!=-1
  if posted:expected.append({'kind':'post_stop_event','event_id':stop_id,'object_id':obj})
  if not (posted and post_result!=0) and playing!=0:expected.append({'kind':'stop_playing_id','playing_id':playing,'duration_ms':0,'curve':4})
  final_released=True
 expected.extend([{'kind':'destroy_stop_string'},{'kind':'destroy_play_string'}])
 if delete_flags&1:expected.append({'kind':'free_voice'})
 assert calls==expected and bool(u.mem_read(heap+0x48,1)[0])==final_released
 cases.append({'flag49_raw':flag49,'released':released,'engine_available':available,'stop_event_id':stop_id,'object_id':obj,'post_return':post_result,'playing_id':playing,'delete_flags':delete_flags,'calls':list(calls),'final_released':final_released})
proof={'passed':True,'cases':cases,'native_sha256':hashlib.sha256(b).hexdigest(),'limits':['Original706BC0 destructor,706F90 release,AEB740 StopPlaying message path executed. Engine availability, PostStopEvent, queue capture, strings/free/logging adapted as explicitly recorded.','Byte49 nonzero gates release; deleted storage follows low bit of delete flags. Stop string destroyed before play string, then storage. Unavailable engine still destroys strings/storage without queued stop.','Default free path only; configured free callback excluded. Actual allocator side effects, PCM/fade execution and automatic host drop integration remain required.'],'complete':False}
(r/'data/4.20/audio_voice_destruction_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Original voice destruction',len(cases),'cases passed')
