"""Execute original7185D0 removal batch loop and64ADA0 copy with spare capacity."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
setup=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(setup,'native setup','exec'))
pending=heap+0x1000;scratch=heap+0x2000;calls=[];remaining=0;next_identity=0;return_value=0

def loop_hook(uc,a,size,user):
 global remaining,next_identity
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xc97610:
  dest,src,n=[read32(sp+i) for i in (4,8,12)];assert n<=256
  if n:u.mem_write(dest,bytes(u.mem_read(src,n)))
  finish(eax=dest);return
 if a==0x6e3080:
  assert u.reg_read(UC_X86_REG_ECX)==0x2d62900
  write32(0x2d62904,read32(0x2d62900));calls.append({'clear_pending':True});finish(4);return
 if a==0x717af0:
  identity=read32(sp+4);calls.append({'remove':identity})
  if remaining:
   pos=read32(0x2d62904);write32(pos,next_identity);write32(0x2d62904,pos+4);next_identity+=4;remaining-=1
  finish(4,return_value);return
 assert 0x7185d0<=a<=0x718683 or 0x64ada0<=a<=0x64ae9a,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,loop_hook)
cases=[]
for n,added,scratch_count,result in itertools.product(range(4),range(4),[0,4],[0,1]):
 initial=[heap+0x8000+4*i for i in range(n)];remaining=added;next_identity=heap+0x9000;return_value=result;calls=[]
 write32(0x2d62900,pending);write32(0x2d62904,pending+4*n);write32(0x2d62908,pending+256)
 for i,v in enumerate(initial):write32(pending+4*i,v)
 write32(0x2d7c3cc,1);write32(0x2d7c3d0,scratch);write32(0x2d7c3d4,scratch+4*scratch_count);write32(0x2d7c3d8,scratch+256)
 sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0x7185d0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
 expected=[];batch=initial[:];todo=added;child=heap+0x9000
 while batch:
  expected.append({'clear_pending':True});new=[]
  for identity in batch:
   expected.append({'remove':identity})
   if todo:new.append(child);child+=4;todo-=1
  batch=new
 assert calls==expected,(n,added,scratch_count,result,calls,expected)
 assert read32(0x2d62904)==pending
 cases.append({'initial':initial,'added':added,'scratch_initial_count':scratch_count,'remove_return':result,'calls':calls})
proof={'native_sha256':digest,'passed':True,'cases':cases,'complete':False,'limits':['Actual7185D0 and64ADA0 copy executed with initialized scratch vector and spare capacity. CRTmemmove and6E3080 vector clear adapted explicitly.','717AF0 removal adapter records calls and appends finite new identities; real object destruction, registry erasure and particle/audio cleanup excluded.','Order preserved; pending cleared before callbacks; newly enqueued entries handled in next batch during same drain call; removal return ignored.','Scratch static initialization/atexit and allocation growth excluded; actual loop has no termination guarantee if removal continually enqueues.']}
(r/'data/4.20/entity_removal_queue_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Original entity removal loop {len(cases)} cases passed')
