from pathlib import Path
import json,datetime
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_simple_cycle.py').read_text(encoding='utf-8').split('frames=[]')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook_cycle)','')
exec(compile(prefix,'native setup','exec'))
owner=heap+0x16000;visited=set();stop_calls=[]
def owner_hook(uc,a,size,user):
 visited.add(a)
 if a==0x9289b0:stop_calls.append(u.reg_read(UC_X86_REG_ECX))
 assert any(lo<=a<hi for lo,hi in native_code_ranges),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,owner_hook)
cases=[]
for live_mask in range(256):
 u.mem_write(owner,b'\0'*0x1400);u.mem_write(owner,b'\1');stop_calls=[]
 for i in range(8):
  control=heap+0x1a000+i*0x20;effect=heap+0x1b000+i*0x200;slot=owner+0x44+i*0x270
  write32(slot,effect);write32(slot+4,control)
  write32(control+4,1 if live_mask&(1<<i) else 0);write32(control+8,1)
  write32(effect,0x10d6db4);write32(effect+0x144,0x2000|i)
 write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,owner)
 u.emu_start(0x7558c0,end,count=20000);assert u.reg_read(UC_X86_REG_EIP)==end
 assert stop_calls==[heap+0x1b000+i*0x200 for i in range(8) if live_mask&(1<<i)]
 cases.append(dict(live_mask=live_mask,owner_active=u.mem_read(owner,1)[0],owner_stop=u.mem_read(owner+0x38,1)[0],stop_slots=[(a-(heap+0x1b000))//0x200 for a in stop_calls],requests=[read32(heap+0x1b000+i*0x200+0x144) for i in range(8)],strong_counts=[read32(heap+0x1a000+i*0x20+4) for i in range(8)]))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),native_sha256=digest,complete=False,passed=True,entry='0x7558c0',original_instruction_addresses=len(visited),runtime_adapters=[],cases=cases,limits=['Eight explicit weak effect handles with preallocated control blocks, strong count1live/0expired; native lock/refcount and virtual request setter execute.','Owner already active supplied to avoid unrelated diagnostic assertion branch.','This qualifies effect-holder stop dispatch; identifying exact missile owner entry and full manager/audio processing remains open.'])
(r/'data/4.20/effect_owner_stop_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'all_live':cases[-1],'expired':cases[0]}))
