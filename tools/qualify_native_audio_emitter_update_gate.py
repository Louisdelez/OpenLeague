"""Original6C97B0 pre-update gate, not the full update/cleanup."""
from pathlib import Path
import json,itertools,struct
r=Path(__file__).resolve().parents[1];source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split("hash_inputs=")[0].replace("u.hook_add(unicorn.UC_HOOK_CODE,hook)","");exec(compile(source,'legacy harness setup','exec'));alive=False;ended_byte=0;queries=0;proceed=False;predicate=end+0x100
write32(heap+0x400,heap+0x500);write32(heap+0x514,predicate)
def gate_hook(uc,a,size,user):
 global queries,proceed
 if a==0x5bd6f0:
  sp=u.reg_read(UC_X86_REG_ESP);out=read32(sp+4);write32(out,heap+0x400 if alive else 0);write32(out+4,0);finish(4,out);return
 if a==predicate:queries+=1;finish(eax=ended_byte);return
 if a==0xc975f5:finish(eax=u.reg_read(UC_X86_REG_EAX));return
 if a==0x6c9824:proceed=True;u.emu_stop();return
 assert 0x6c97b0<=a<=0x6c9824 or 0x6c9a34<=a<=0x6c9a81,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,gate_hook);cases=[]
for alive,ended_byte,ending in itertools.product([False,True],[0,1,255],[0,1,2,0xffffffff]):
 queries=0;proceed=False;write32(heap+0x124,ending);sp=stack+0x8000;u.mem_write(sp,struct.pack('<II',end,0));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,heap);u.emu_start(0x6c97b0,end,count=10000)
 expected=alive and ended_byte==0 and ending==0;assert proceed==expected;assert queries==int(alive)
 if not proceed:assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)==0
 cases.append({'weak_alive':alive,'native_ended_byte':ended_byte,'ending_raw':ending,'proceed':proceed,'predicate_queries':queries})
proof={'native_sha256':digest,'passed':True,'cases':cases,'complete':False,'limits':['Original6C97B0 entry/gates and early-return epilogue executed. Allowed branch stops before9824, so full spatial/update actions not claimed.','Weak-lock/object virtual14 predicate/security explicitly adapted. Expired targets skip predicate; alive target predicate called before ending124 check.','False return does not itself prove manager cleanup timing or voice release. Actual calling manager remains unqualified.']};(r/'data/4.20/audio_emitter_update_gate_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Original emitter update gate {len(cases)} cases passed')
