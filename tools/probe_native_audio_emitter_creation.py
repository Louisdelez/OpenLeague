"""Derived constructor -> real init -> animation-start policy, factory adapted."""
from pathlib import Path
import json,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/probe_native_audio_emitter_constructor.py').read_text().split('rows=[]')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook_ctor)','ctor_hook_id=u.hook_add(unicorn.UC_HOOK_CODE,hook_ctor)')
exec(compile(source,'constructor setup','exec'));u.hook_del(ctor_hook_id)
target=heap+0x400;name=heap+0x800;owner=0

def combined(uc,a,size,user):
 if a in [0x716890,0x6ea710,0x718540]:hook_ctor(uc,a,size,user);return
 if a==0x564c20:
  sp=u.reg_read(UC_X86_REG_ESP);src=read32(sp+4);length=read32(sp+8);dest=u.reg_read(UC_X86_REG_ECX)
  assert length<=15;u.mem_write(dest,bytes(u.mem_read(src,length))+b'\0');write32(dest+16,length);write32(dest+20,15);finish(8,dest);return
 if a==0x6ceee0:
  out=u.reg_read(UC_X86_REG_ECX);assert u.reg_read(UC_X86_REG_EDX)==name
  write32(out,target if alive else 0);write32(out+4,0);finish(0,out);return
 if a==0x5bd6f0:
  sp=u.reg_read(UC_X86_REG_ESP);out=read32(sp+4);pair=u.reg_read(UC_X86_REG_ECX)
  assert pair==heap+0x11c;write32(out,read32(pair));write32(out+4,0);finish(4,out);return
 assert any(lo<=a<=hi for lo,hi in [(0x6c8be0,0x6c8d0c),(0x6c8e30,0x6c9073),(0x6c96f0,0x6c97aa),(0x928440,0x928443),(0x928460,0x928474),(0x9285f0,0x928612),(0x9289d0,0x9289da),(0x5b56b4,0x5b56c1)]),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,combined)
rows=[]
for fill,alive,flags,dirty in itertools.product([0,0xa5,0xff],[False,True],[0,0x80,0xffffffff],[0,0x2000,0xffffffff]):
 events=[];u.mem_write(heap,bytes([fill])*0x300);sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,heap);u.emu_start(0x6c8be0,end,count=10000)
 u.mem_write(target,bytes(0x180));write32(target,0x10d6db4);write32(target+0x24,flags);write32(target+0x144,dirty);u.mem_write(name,b'ambient.troy\0')
 write32(sp,end);write32(sp+4,name);write32(sp+8,123);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,heap);u.emu_start(0x6c8e30,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 assert read32(heap+0x144)==0 and read32(heap+0x124)==0 and read32(heap+0x12c)==1
 initialized={'flags':read32(target+0x24),'requests':read32(target+0x144),'position':[read32(target+0x40+4*i) for i in range(3)]}
 assert initialized['flags']==flags
 assert initialized['requests']==((dirty|0x1800)&~0x2000 if alive else dirty)
 assert initialized['position']==([0x7f7fffff]*3 if alive else [0]*3)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBX,heap);u.emu_start(0x5b56b4,0x5b56c6,count=10000)
 assert read32(heap+0x144)==1 and read32(target+0x24)==(flags|0x10 if alive else flags)
 rows.append(dict(fill=fill,alive=alive,initial_flags=flags,initial_requests=dirty,initialized=initialized,started_flags=read32(target+0x24),started_requests=read32(target+0x144)))
proof=dict(native_sha256=digest,passed=True,complete=False,cases=rows,entries=['6C8BE0','6C8E30','5B56B4..5B56C6','6C96F0','928440','928460','9285F0','9289D0'],adapters=['Base constructor and container inherited adapters; owner context absent.','Short string assignment adapted. Effect factory6CEEE0 returns supplied target/null and no control pointer; target fields supplied from qualified Troy constructor or explicit boundary profiles.','Weak lock adapted; real target accessors and derived initialization execute.'],limits=['Resource factory/loading and reference counters not exercised.','Source position MAX is initialization sentinel, not a playable source position; next owner pose must replace it.','No live Bevy or physical audio qualification.'])
(r/'data/4.20/audio_emitter_creation_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'constructor-init-start cases')
