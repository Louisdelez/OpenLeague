"""Original5B5440 End marking; weak-lock dependency explicitly adapted."""
from pathlib import Path
import json,itertools,struct
r=Path(__file__).resolve().parents[1];source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split("hash_inputs=")[0].replace("u.hook_add(unicorn.UC_HOOK_CODE,hook)","");exec(compile(source,'legacy harness setup','exec'));alive=False

def end_hook(uc,a,size,user):
 if a==0x5bd6f0:
  sp=u.reg_read(UC_X86_REG_ESP);out=read32(sp+4);write32(out,heap+0x400 if alive else 0);write32(out+4,0);finish(4,out);return
 assert 0x5b5440<=a<=0x5b54b3,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,end_hook);cases=[]
for alive,ending,remaining,handle in itertools.product([False,True],[0,1,2,0xffffffff],[0,1,0xffffffff],[-1,0,42,2147483647]):
 u.mem_write(heap+0x400,b'\xa5'*0x200);write32(heap+0x20,heap+0x400);write32(heap+0x524,ending);write32(heap+0x52c,remaining);write32(heap+0x5ac,handle&0xffffffff);before=bytes(u.mem_read(heap+0x400,0x200))
 for repeat in range(2):
  sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,heap);u.emu_start(0x5b5440,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 after=bytes(u.mem_read(heap+0x400,0x200));expected=bytearray(before)
 if alive:struct.pack_into('<I',expected,0x124,1);struct.pack_into('<I',expected,0x12c,0)
 assert after==expected
 cases.append({'weak_alive':alive,'ending_raw':ending,'remaining_raw':remaining,'handle':handle,'final_ending_raw':read32(heap+0x524),'final_remaining_raw':read32(heap+0x52c),'final_handle':struct.unpack('<i',u.mem_read(heap+0x5ac,4))[0]})
proof={'native_sha256':digest,'passed':True,'cases':cases,'complete':False,'limits':['Actual5B5440 marking executed twice per case; weak-lock dependency explicitly adapted with no control pointer. Native weak ownership separately qualified.','All512 particle bytes compared; only124=1 and12C=0 change when alive; persistent handle untouched. No audio release callback invoked.','Full particle update/cleanup timing remains unqualified; marking does not itself qualify lifetime termination.']};(r/'data/4.20/audio_emitter_end_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Original emitter End {len(cases)} cases passed')
