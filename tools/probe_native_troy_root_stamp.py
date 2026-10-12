"""Troy root stamp field88: initializer, increment and actual virtual getter."""
from pathlib import Path
import json
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text().split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,'base','exec'))
assert read32(0x10d6c70+0x2c)==0x922060
rows=[]
for initial in [0,1,42,0x7fffffff,0x80000000,0xfffffffe,0xffffffff]:
 u.mem_write(heap,b'\xa5'*0x100);u.reg_write(UC_X86_REG_ESI,heap)
 u.emu_start(0x928bfb,0x928c05,count=1);assert read32(heap+0x88)==0
 write32(heap+0x88,initial);u.reg_write(UC_X86_REG_EBX,heap)
 u.emu_start(0x92b306,0x92b30c,count=1);assert read32(heap+0x88)==(initial+1)&0xffffffff
 sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,heap)
 u.emu_start(0x922060,end,count=100);assert u.reg_read(UC_X86_REG_EIP)==end
 value=u.reg_read(UC_X86_REG_EAX);assert value==(initial+1)&0xffffffff
 rows.append(dict(initial=initial,result=value))
proof=dict(native_sha256=digest,passed=True,complete=False,cases=rows,entries=['928BFB','92B306','922060'],vtable='10D6C70+2C',findings=['Root getter returns raw field88; initialization writes0; increment wraps u32. It is not floating-point elapsed seconds.'],limits=['Initializer and increment instructions executed in isolation with supplied object registers.','Whole92B306 caller, branches and host scheduling frequency remain unqualified.','No Bevy runtime binding in this probe.'])
(r/'data/4.20/troy_root_stamp_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'root stamp boundary cases')
