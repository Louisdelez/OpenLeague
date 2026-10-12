"""Original derived emitter constructor6C8BE0; base/container adapters explicit."""
from pathlib import Path
import json,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text().split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,'legacy harness','exec'))
def hook_ctor(uc,a,size,user):
 if a==0x716890:
  assert u.reg_read(UC_X86_REG_ECX)==heap
  write32(heap+0xe4,owner);write32(heap+0xb0,2);finish(0,heap);return
 if a==0x6ea710:finish(8,u.reg_read(UC_X86_REG_ECX));return
 if a==0x718540:
  sp=u.reg_read(UC_X86_REG_ESP)
  assert [read32(sp+4+i*4) for i in range(3)]==[heap,2,0x212]
  assert u.reg_read(UC_X86_REG_ECX)==owner;events.append('owner-category-update');finish(12,0);return
 assert 0x6c8be0<=a<=0x6c8d0c or 0x6c8f07<=a<0x6c8f43,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook_ctor)
rows=[]
for fill,owner in itertools.product([0,0x55,0xa5,0xff],[0,heap+0x4000]):
 u.mem_write(heap,bytes([fill])*0x300);events=[];sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,heap)
 u.emu_start(0x6c8be0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)==heap
 result={hex(o):read32(heap+o) for o in [0,0x11c,0x120,0x144,0x148,0x14c,0x150,0x154,0x160,0x174,0x178,0x17c,0x180,0x188,0xe0,0xb0]}
 assert result['0x144']==0 and result['0x11c']==result['0x120']==0
 assert result['0x0']==0x10a4960 and result['0xb0']==0x212
 assert events==(['owner-category-update'] if owner else [])
 rows.append(dict(fill=fill,owner_present=bool(owner),result=result,events=events))
initialization=[]
for fill,argument in itertools.product([0,0x55,0xa5,0xff],[0,123,0xffffffff]):
 u.mem_write(heap,bytes([fill])*0x300);sp=stack+0x8000;bp=stack+0x9000;write32(bp+12,argument)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBP,bp);u.reg_write(UC_X86_REG_ESI,heap);u.reg_write(UC_X86_REG_EDI,heap+0x3000)
 u.emu_start(0x6c8f07,0x6c8f43,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x6c8f43
 result={hex(o):read32(heap+o) for o in [0x3c,0x124,0x128,0x12c,0x140]};result['0x130']=u.mem_read(heap+0x130,1)[0]
 assert result=={'0x3c':argument,'0x124':0,'0x128':0x3f800000,'0x12c':1,'0x140':0x3f800000,'0x130':0}
 initialization.append(dict(fill=fill,argument=argument,result=result))
proof=dict(native_sha256=digest,complete=False,passed=True,cases=rows,initialization=initialization,entry='6C8BE0 and6C8F07..6C8F43',adapters=['Base716890 replaced: only ownerE4 and categoryB0 supplied; remaining base fields not qualified.','Container6EA710 at18C replaced; owner category callback718540 captures args.','Initialization slice supplied owner and caller stack argument; stops before effect factory6CEEE0.'],limits=['Derived constructor flags144=0 and weak pointers11C/120=0 verified; later init/factory may still mutate state.','Separate pre-factory init clears ending124, sets remaining12C=1, scales128/140=1, byte130=0. Not a successful fully-created effect.','No live Bevy or physical audio qualification.'])
(r/'data/4.20/audio_emitter_constructor_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print('PASS',len(rows),'derived constructor cases and',len(initialization),'pre-factory initializations')
