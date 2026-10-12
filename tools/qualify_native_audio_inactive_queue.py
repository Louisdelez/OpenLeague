"""Original7184B0 inactive-object queue, preserving sorted identities/duplicates."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1];source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split("hash_inputs=")[0].replace("u.hook_add(unicorn.UC_HOOK_CODE,hook)","");exec(compile(source,'legacy harness setup','exec'))
manager=heap+0x1000;vector=heap+0x3000;actor=heap+0x8000

def queue_hook(uc,a,size,user):
 if a==0xc97610:
  sp=u.reg_read(UC_X86_REG_ESP);dest,src,n=[read32(sp+i) for i in (4,8,12)];assert n<=256
  if n:u.mem_write(dest,bytes(u.mem_read(src,n)))
  finish(eax=dest);return
 assert 0x7184b0<=a<=0x71852f or 0x735880<=a<=0x735918 or 0x736dc0<=a<0x736e60 or 0x6b6530<=a<=0x6b66cc or 0x5ed350<=a<=0x5ed380,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,queue_hook);cases=[]
for n in range(5):
 for initial in itertools.combinations_with_replacement([actor-4,actor,actor+4],n):
  for active in [0,1,255]:
   write32(manager+0x48,vector);write32(manager+0x4c,vector+4*n);write32(manager+0x50,vector+256);u.mem_write(actor+0xad,bytes([active]));u.mem_write(vector,b'\0'*256)
   if n:u.mem_write(vector,struct.pack('<'+'I'*n,*initial))
   expected=list(initial);outputs=[]
   for repeat in range(2):
    sp=stack+0x8000;u.mem_write(sp,struct.pack('<II',end,actor));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,manager);u.emu_start(0x7184b0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
    if active:
     if actor in expected:expected.remove(actor)
    elif actor not in expected:expected.append(actor);expected.sort()
    begin,finishptr=read32(manager+0x48),read32(manager+0x4c);count=(finishptr-begin)//4;observed=list(struct.unpack('<'+'I'*count,u.mem_read(begin,4*count))) if count else [];assert observed==expected,(initial,active,observed,expected);outputs.append(observed)
   cases.append({'initial':list(initial),'identity':actor,'active_raw':active,'outputs':outputs})
proof={'native_sha256':digest,'passed':True,'cases':cases,'complete':False,'limits':['Actual7184B0,735880 equal-range helpers and6B6530 insertion with spare capacity executed; CRT memmove explicitly adapted. Allocation/growth path excluded.','Inactive queues identity only if absent; active removes one matching entry per invocation, preserving order and other duplicates.','This queue tracks manager activity. It does not destroy objects or release voices. Actual manager drain/particle cleanup timing remains unqualified.']};(r/'data/4.20/audio_inactive_queue_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Original inactive queue {len(cases)} cases passed')
