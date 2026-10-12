"""Execute animation start5B56B4..5B56C6 through real6C96F0 and target accessors."""
from pathlib import Path
import json,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,'legacy harness setup','exec'))
target=heap+0x400;vtable=heap+0x800;getter=0x928440;setter=0x928460

def transfer_hook(uc,a,size,user):
 if a==0x5bd6f0:
  sp=u.reg_read(UC_X86_REG_ESP);out=read32(sp+4)
  assert u.reg_read(UC_X86_REG_ECX)==heap+0x11c
  write32(out,target if alive else 0);write32(out+4,0);finish(4,out);return
 if a==getter:
  assert u.reg_read(UC_X86_REG_ECX)==target
  events.append({'call':'get','flags':read32(target+0x24)});return
 if a==setter:
  assert u.reg_read(UC_X86_REG_ECX)==target
  value=read32(u.reg_read(UC_X86_REG_ESP)+4);events.append({'call':'set','flags':value});return
 assert 0x5b56b4<=a<=0x5b56c1 or 0x6c96f0<=a<=0x6c97aa or getter<=a<=getter+3 or setter<=a<=setter+0x14,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,transfer_hook)
cases=[]
for alive,flags,current,dirty in itertools.product([False,True],list(range(8))+[0x80,0xffffffff],[0,2,0x10,0x20,0x80000000,0xffffffff],[0,0x2000,0xffffffff]):
 events=[];u.mem_write(heap,bytes(0x1000));write32(heap+0x144,flags);write32(target,vtable);write32(target+0x24,current);write32(target+0x144,dirty);write32(vtable+4,getter);write32(vtable+8,setter)
 sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,heap)
 u.reg_write(UC_X86_REG_EBX,heap);u.emu_start(0x5b56b4,0x5b56c6,count=10000);assert u.reg_read(UC_X86_REG_EIP)==0x5b56c6
 started=flags|1;assert read32(heap+0x144)==started
 expected=current | (started&2) | (0x10 if started&1 else 0) | (0x20 if started&4 else 0)
 assert events==([{'call':'get','flags':current},{'call':'set','flags':expected}] if alive else [])
 assert read32(target+0x24)==(expected if alive else current)
 assert read32(target+0x144)==(dirty|0x800 if alive else dirty)
 cases.append(dict(weak_alive=alive,wrapper_flags=flags,started_wrapper=started,existing=current,dirty=dirty,final_flags=read32(target+0x24),final_dirty=read32(target+0x144),events=events))
proof=dict(native_sha256=digest,passed=True,complete=False,cases=cases,entry='5B56B4..5B56C6 -> 6C96F0',adapters=['Weak lock returns supplied target or null and no control pointer.','Actual target928440getter and928460setter execute; target vtable addresses recovered from Troy constructor vtable10D6DB4.'],limits=['Slice starts after factory returns a supplied valid wrapper; full creation callback and factory not executed.','Initial wrapper flags, subsequent frame integration remain separate.'])
(r/'data/4.20/audio_emitter_start_flags_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print('PASS',len(cases),'native wrapper flag transfers')
