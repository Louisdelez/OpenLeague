"""Original707170 object teardown and707070 live voice object invalidation."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
setup=(r/'tools/qualify_native_audio_object_tick.py').read_text().split('\ncases=[]\n')[0]
setup=setup.replace('u.hook_add(unicorn.UC_HOOK_CODE,tick_hook)','')
exec(compile(setup,'tick_setup','exec'));put(voice_vt+0x28,'I',0x707070)
def destruction_hook(uc,a,size,user):
 ecx=u.reg_read(UC_X86_REG_ECX);sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xaea6b0:ret(int(available));return
 if a==0xaebc10:
  assert read(sp+4,'I')[0]==123;calls.append({'kind':'unregister','object_id':123});ret();return
 if a==0x707070:
  index=(ecx-voice_base)//0x100;calls.append({'kind':'invalidate','index':index});return
 if a==0xc98528:
  assert read(sp+4,'I')[0]==array;calls.append({'kind':'free_association_storage'});ret();return
 if a in [end+0x100,end+0x200]:
  index=(ecx-control_base)//0x100;calls.append({'kind':'destroy_voice' if a==end+0x100 else 'free_control','index':index});ret();return
 assert any(s<=a<e for s,e in [(0x707170,0x7072e3),(0x707070,0x707078),(0x5bd6f0,0x5bd72c),(0x5ec2a0,0x5ec2cb),(0x5ccf80,0x5ccfd7)]),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,destruction_hook)
inputs=[]
for n in range(5):
 for states,available in itertools.product(itertools.product(['expired','active','released','unmanaged'],repeat=n),[False,True]):inputs.append((states,available,True))
inputs.extend([((),False,False),((),True,False)])
cases=[]
for states,available,storage_present in inputs:
 u.mem_write(array,b'\0'*0x100);put(obj+4,'I',123);put(obj+0x1c,'3I',array if storage_present else 0,array+len(states)*8 if storage_present else 0,array+0x100 if storage_present else 0);put(0x14bef40,'I',0)
 for index,state in enumerate(states):
  v=voice_base+index*0x100;ctrl=control_base+index*0x100
  put(v,'3I',voice_vt,62+index,123);u.mem_write(v+0x48,bytes([255 if state=='released' else 0]));put(ctrl,'4I',control_vt,0 if state=='expired' else 1,1 if state=='expired' else 2,v);put(array+index*8,'2I',v,0 if state=='unmanaged' else ctrl)
 calls.clear();sp=stack+0x8000;put(sp,'I',end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,obj);u.emu_start(0x707170,end,count=20000);assert u.reg_read(UC_X86_REG_EIP)==end
 expected=[{'kind':'unregister','object_id':123}] if available else []
 expected.extend({'kind':'invalidate','index':i} for i,s in enumerate(states) if s in ['active','released'])
 expected.extend({'kind':'free_control','index':i} for i,s in enumerate(states) if s=='expired')
 if storage_present:expected.append({'kind':'free_association_storage'})
 assert calls==expected;assert read(obj+0x1c,'3I')==(0,0,0);assert read(obj,'I')[0]==0x10abb5c
 fields=[]
 for index,state in enumerate(states):
  playing,object_id=read(voice_base+index*0x100+4,'2I');released=u.mem_read(voice_base+index*0x100+0x48,1)[0]
  assert playing==62+index and object_id==(0xffffffff if state in ['active','released'] else 123) and released==(255 if state=='released' else 0)
  strong,weak=read(control_base+index*0x100+4,'2I');assert (strong,weak)==((0,0) if state=='expired' else (1,1) if state!='unmanaged' else (1,2))
  fields.append({'playing_id':playing,'object_id':object_id,'released_raw':released,'strong':strong if state!='unmanaged' else None,'weak':weak if state!='unmanaged' else None})
 cases.append({'states':list(states),'engine_available':available,'storage_present':storage_present,'calls':list(calls),'voice_fields':fields})
proof={'passed':True,'cases':cases,'native_sha256':digest,'limits':['Actual707170 destructor,707070 invalidation, weak copy/lock and atomic release loops executed for0..4 entries/all weak states, with/without engine and empty allocated/null vector.','Engine availability/UnregisterGameObject(AEBC10), control free and vector allocator free are explicit adapters; actual unregister queue/worker already separate qualification. Configured free branch excluded.','Unregister precedes invalidation; live/released owned voices only receive object IDFFFFFFFF. Playing ID and release flag unchanged. Null-control/expired entries are not dereferenced.','Object weak storage destruction does not stop still-owned voices directly. Subsequent release uses existing invalid-object fallback rule. No actual PCM/audio client claim.'],'complete':False}
(r/'data/4.20/audio_object_destruction_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Original audio object destruction',len(cases),'cases passed')
