"""Original6C8620 queued entity identity validation/deactivation."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1];source=(r/'tools/qualify_native_audio_inactive_queue.py').read_text(encoding='utf-8').split("u.hook_add(unicorn.UC_HOOK_CODE,queue_hook)")[0];exec(compile(source,'inactive setup','exec'));inactive_hook=queue_hook
u.mem_map(heap+0x10000,0x50000);registry=heap+0x10000;commands=heap+0x6000;notifications=[]
def entity_hook(uc,a,size,user):
 if a==0x991e60:notifications.append('invalid_sentinel_diagnostic');finish();return
 if a==0x6e3080:
  assert u.reg_read(UC_X86_REG_ECX)==0x2d5f57c;write32(0x2d5f580,read32(0x2d5f57c));notifications.append('clear_commands');finish(4);return
 if a==0x7184b0:notifications.append('manager_deactivate')
 if 0x6c8620<=a<=0x6c86cf:return
 inactive_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,entity_hook);cases=[]
for id,length,present,match,managed in itertools.product([0,1,0x10001,0x80000001,0xffffffff,0x12345678],[0,2,65536],[False,True],[False,True],[False,True]):
 index=id&0xffff;u.mem_write(registry,b'\0'*(65536*4));write32(0x2d628c0,registry);write32(0x2d628c4,length)
 if present:write32(registry+index*4,actor)
 object_id=id if match else id^0x10000;write32(actor+8,object_id);u.mem_write(actor+0xad,b'\xff');write32(actor+0xe4,manager if managed else 0)
 write32(manager+0x48,vector);write32(manager+0x4c,vector);write32(manager+0x50,vector+256)
 write32(0x2d5f57c,commands);write32(0x2d5f580,commands+8);u.mem_write(commands,struct.pack('<II',id,id));notifications=[]
 sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0x6c8620,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
 expected=[]
 if id==0xffffffff:expected+=['invalid_sentinel_diagnostic']
 eligible=id!=0 and index<length and present and match
 # Diagnostics occur per pending command, including sentinel that can still match.
 expected=[]
 for repeat in range(2):
  if id==0xffffffff:expected.append('invalid_sentinel_diagnostic')
  if eligible and managed:expected.append('manager_deactivate')
 expected.append('clear_commands');assert notifications==expected
 active=u.mem_read(actor+0xad,1)[0];assert active==(0 if eligible else 255)
 count=(read32(manager+0x4c)-vector)//4;queued=list(struct.unpack('<'+'I'*count,u.mem_read(vector,count*4))) if count else [];assert queued==([actor] if eligible and managed else [])
 assert read32(0x2d5f580)==commands
 cases.append({'id':id,'registry_length':length,'object_present':present,'object_id':object_id,'manager_present':managed,'active_raw':active,'manager_queue':queued,'notifications':notifications})
proof={'native_sha256':digest,'passed':True,'cases':cases,'complete':False,'limits':['Actual6C8620 and7184B0 sorted inactive queue executed. Logger991E60, pending-vector clear6E3080 and CRTmemmove explicitly adapted; queue insertion with spare capacity.','Zero command skipped. Low16 index must be below registry length and full object ID equal; stale generations rejected. RawFFFFFFFF logs then continues validation, not unconditional rejection.','No object destruction/particle/audio release or manager drain timing implied. Object registry construction/generation allocation unqualified.']};(r/'data/4.20/entity_deactivation_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Original entity deactivation {len(cases)} cases passed')
