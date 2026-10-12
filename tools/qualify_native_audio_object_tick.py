"""Execute original707300 object tick with native weak lock and ordered erase."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
setup=(r/'tools/qualify_native_audio_object_association.py').read_text().split('cases=[]')[0]
setup=setup.replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(setup,'association_setup','exec'))
voice_base=heap+0x2000;control_base=heap+0x4000;voice_vt=heap+0x800;control_vt=heap+0x900;calls=[]
put(voice_vt+4,'I',end+0x300);put(voice_vt+0x1c,'I',0x706eb0);put(control_vt,'2I',end+0x100,end+0x200)
for a in [end+0x100,end+0x200,end+0x300]:u.mem_write(a,b'\xc3')
def ret(value=None,pop=0):
 sp=u.reg_read(UC_X86_REG_ESP);target=read(sp,'I')[0]
 if value is not None:u.reg_write(UC_X86_REG_EAX,value)
 u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EIP,target)
def tick_hook(uc,a,size,user):
 ecx=u.reg_read(UC_X86_REG_ECX);sp=u.reg_read(UC_X86_REG_ESP)
 if a==0x707610:
  assert ecx==obj;assert read(sp+4,'I')[0]==0x3dcccccd;calls.append({'kind':'height_update'});ret(pop=4);return
 if a==end+0x300:
  index=(ecx-voice_base)//0x100;calls.append({'kind':'refresh','index':index})
  if retire_on_refresh:u.mem_write(ecx+0x48,b'\x01')
  ret(1);return
 if a in [end+0x100,end+0x200]:
  index=(ecx-control_base)//0x100;calls.append({'kind':'destroy_voice' if a==end+0x100 else 'free_control','index':index});ret();return
 assert any(s<=a<e for s,e in [(0x707300,0x70741e),(0x706eb0,0x706eb4),(0x5bd6f0,0x5bd72c),(0x5ec2a0,0x5ec2cb),(0x5ccf80,0x5ccfd7),(0x713120,0x713189)]),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,tick_hook)
cases=[]
for n in range(5):
 for states,retire_on_refresh in itertools.product(itertools.product(['expired','active','released','unmanaged'],repeat=n),[False,True]):
  u.mem_write(array,b'\0'*0x100);put(obj+0x1c,'3I',array,array+n*8,array+0x100)
  for index,state in enumerate(states):
   v=voice_base+index*0x100;ctrl=control_base+index*0x100
   put(v,'I',voice_vt);u.mem_write(v+0x48,bytes([255 if state=='released' else 0]));put(ctrl,'4I',control_vt,0 if state=='expired' else 1,1 if state=='expired' else 2,v);put(array+index*8,'2I',v,0 if state=='unmanaged' else ctrl)
  calls.clear();returns=[]
  for run in range(2):
   sp=stack+0x8000;put(sp,'2I',end,0x3dcccccd);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,obj);u.emu_start(0x707300,end,count=20000);assert u.reg_read(UC_X86_REG_EIP)==end;returns.append(u.reg_read(UC_X86_REG_EAX)&255)
  count=(read(obj+0x20,'I')[0]-array)//8;remaining=[(read(array+i*8,'I')[0]-voice_base)//0x100 for i in range(count)]
  expected_remaining=[i for i,s in enumerate(states) if s in ['active','released']];assert remaining==expected_remaining and returns==[1,1]
  expected=[]
  for run in range(2):
   expected.append({'kind':'height_update'})
   for index,state in enumerate(states):
    if state=='expired' and run==0:expected.append({'kind':'free_control','index':index})
    if state=='active' and (run==0 or not retire_on_refresh):expected.append({'kind':'refresh','index':index})
  assert calls==expected
  counts=[]
  for index,state in enumerate(states):
   strong,weak=read(control_base+index*0x100+4,'2I');assert (strong,weak)==((0,0) if state=='expired' else (1,2))
   counts.append({'strong':strong if state!='unmanaged' else None,'weak':weak if state!='unmanaged' else None})
  cases.append({'states':list(states),'retire_on_refresh':retire_on_refresh,'repeat_runs':2,'calls':list(calls),'remaining_indices':remaining,'returns':returns,'control_counts':counts})
proof={'passed':True,'cases':cases,'native_sha256':digest,'limits':['Original707300/5BD6F0/5EC2A0/5CCF80/713120 and released getter706EB0 executed on0..4 entries/all expired-active-released-unmanaged combinations twice. Ordered weak entry shifts and tail weak decrement executed.','Height updater707610 explicitly adapted (separately qualified); voice refresh virtual4 adapted with optional release flag transition; control final free virtual4 recorded. Actual PCM/RTPC work not performed here.','Released but still-owned voices stay associated and skip refresh; refresh marking released does not immediately remove weak entry. Expiration prunes entry in insertion order, not swap-last.','Actual clock-driven voice refresh and final voice destructor remain separate integration; no live audio claim.'],'complete':False}
(r/'data/4.20/audio_object_tick_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Original object audio tick',len(cases),'cases/two updates passed')
