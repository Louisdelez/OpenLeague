"""Original6C9360 weak target removal, with no membership188."""
from pathlib import Path
import json,itertools,struct
r=Path(__file__).resolve().parents[1]
setup=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(setup,'native setup','exec'))
obj=heap+0x1000;target=heap+0x2000;control=heap+0x3000;table=heap+0x4000;target_call=end+0x100;destroy=end+0x200;free=end+0x300;alive=False;events=[]
def remove_hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0x5bd6f0:
  out=read32(sp+4);write32(out,target if alive else 0);write32(out+4,control if alive else 0)
  if alive:write32(control+4,read32(control+4)+1)
  finish(4,out);return
 if a==target_call:events.append('target_remove');finish();return
 if a==destroy:events.append('last_strong_destroy');finish();return
 if a==free:events.append('last_weak_free');finish();return
 assert 0x6c9360<=a<=0x6c9484,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,remove_hook);cases=[]
for alive,owners,extra_weak in itertools.product([False,True],[1,2,3],[0,1,2]):
 strong=owners if alive else 0;weak=extra_weak+(2 if alive else 1)
 u.mem_write(obj,b'\0'*0x200);write32(obj+0x11c,target);write32(obj+0x120,control);write32(target,table);write32(table+0xa0,target_call);write32(control,table+0x100);write32(table+0x100,destroy);write32(table+0x104,free);write32(control+4,strong);write32(control+8,weak);events=[]
 sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,obj);u.emu_start(0x6c9360,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end;assert u.reg_read(UC_X86_REG_EAX)==1
 assert events==(['target_remove'] if alive else [])
 assert read32(control+4)==strong;assert read32(control+8)==weak-(1 if alive else 0)
 assert read32(obj+0x11c)==(0 if alive else target);assert read32(obj+0x120)==(0 if alive else control)
 cases.append({'alive':alive,'strong_owners':strong,'extra_weak':extra_weak,'events':events[:],'association_retained':not alive,'strong_after':read32(control+4),'weak_after':read32(control+8)})
proof={'native_sha256':digest,'passed':True,'cases':cases,'complete':False,'limits':['Actual6C9360 and atomic counter decrements executed; weak-lock adapter supplies target/control and increments strong as specified; virtualA0 target callback explicitly adapted.','Membership188=0 only; no global membership removal path. At least one external strong owner when alive, so last-strong destructor path not covered.','Expired target retains stored weak association; alive target callback precedes weak detachment and temporary strong release.','Target virtualA0 implementation/particle cleanup and runtime manager wiring remain unqualified.']}
(r/'data/4.20/entity_target_removal_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Original target removal {len(cases)} cases passed')
