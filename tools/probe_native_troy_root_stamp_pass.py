"""Native cache-maintenance -> root stamp -> per-instance update ordering."""
from pathlib import Path
import json,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text().split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','');exec(compile(source,'base','exec'))
sentinel=heap+0x1000;nodes=heap+0x2000;array=heap+0x4000

def step_hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0x919f80:events.append(dict(kind='resource',stamp=read32(sp+4)));finish(4,0);return
 if a==0x77d670:
  out=u.reg_read(UC_X86_REG_ECX);assert read32(sp+4)==heap+0xdc
  write32(out,array);write32(out+4,array+count*8);write32(out+8,array+count*8);finish(4,out);return
 if a==0x940570:events.append(dict(kind='instance',stamp=read32(heap+0x88)));finish(0,0);return
 assert 0x92b293<=a<0x92b3ab or 0x922060<=a<=0x922066,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,step_hook)
rows=[]
for resources,count,stamp in itertools.product([0,1,3],[0,1,4],[0,0xffffffff]):
 events=[];u.mem_write(heap,bytes(0x6000));write32(heap,0x10d6c70);write32(heap+0x88,stamp);write32(heap+0xbc,sentinel);u.mem_write(sentinel+13,b'\1');write32(sentinel,nodes if resources else sentinel)
 for i in range(resources):
  node=nodes+i*64;write32(node,sentinel);write32(node+4,node-64 if i else sentinel);write32(node+8,node+64 if i+1<resources else sentinel);write32(node+0x28,heap+0x5000+i*16)
 for i in range(count):write32(array+i*8,heap+0x5800+i*16);write32(array+i*8+4,0)
 sp=stack+0x8000;u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBX,heap)
 u.emu_start(0x92b293,0x92b3ab,count=10000);assert u.reg_read(UC_X86_REG_EIP)==0x92b3ab
 new=(stamp+1)&0xffffffff;assert read32(heap+0x88)==new
 assert events==[dict(kind='resource',stamp=stamp)]*resources+[dict(kind='instance',stamp=new)]*count
 rows.append(dict(resources=resources,instances=count,initial=stamp,final=new,events=events))
proof=dict(native_sha256=digest,passed=True,complete=False,cases=rows,entry='92B293..92B3AB',adapters=['Resource maintenance919F80 captures input; supplied valid right-linked resource tree.','Collection snapshot77D670 returns supplied target/control0 pairs;940570 records entry only, child frame body separate.'],findings=['Each pass increments once even with no resources or instances. Resource callbacks see old stamp; instance callbacks see incremented stamp.'],limits=['Starts after camera preparation; external pass invocation and remaining frame/destruction not executed.','Bevy host maps one ambient update system call to one native effect pass; full scheduler fidelity remains separate.'])
(r/'data/4.20/troy_root_stamp_pass_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'native pass ordering cases')
