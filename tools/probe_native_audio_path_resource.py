from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
resource=vector+0x5000;source_points=vector+0x6000;source_pairs=vector+0x7000;old_points=vector+0x8000;old_descriptors=vector+0x9000;new_points=vector+0xa000;new_descriptors=vector+0xb000;calls=[];freed=[];allocations=[];nth=0;visited=set()
def hook(uc,a,size,data):
 global nth
 if a==0xada670:
  nth+=1;sp=u.reg_read(UC_X86_REG_ESP);pool,size=read(sp+4),read(sp+8);assert pool==17 and size==(point_count if nth==1 else descriptor_count)*16;ref=0 if failure==nth else new_points if nth==1 else new_descriptors;calls.append({'kind':'allocate','pool':pool,'bytes':size,'reference':ref})
  if ref:u.mem_write(ref,bytes([pattern])*size);allocations.append({'reference':ref,'size':size})
  finish(ref);return
 if a==0xada3e0:
  sp=u.reg_read(UC_X86_REG_ESP);pool,ref=read(sp+4),read(sp+8);assert pool==17 and ref in [old_points,old_descriptors] and ref not in freed;freed.append(ref);calls.append({'kind':'free','pool':pool,'reference':ref});finish(1);return
 if a==0xca1ef0:
  sp=u.reg_read(UC_X86_REG_ESP);dest,src,size=read(sp+4),read(sp+8),read(sp+12);assert dest==new_points and src==source_points and size==point_count*16;u.mem_write(dest,bytes(u.mem_read(src,size)));calls.append({'kind':'copy','source':src,'destination':dest,'bytes':size});finish(dest);return
 assert 0xb1b220<=a<0xb1b3bc,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
profiles=list((*v,layout,'normal')for v in itertools.product([0,0xa5],[3,6],[1,2,3],[0,1,1024,0xffffffff],[False,True],[0,1,2])for layout in ['single','multi','empty','negative'])
profiles += [(p,0 if guard=='zero_points'else 3,0 if guard=='zero_descriptors'else 2,1024,previous,0,'single',guard)for p,previous,guard in itertools.product([0,0xa5],[False,True],['zero_points','zero_descriptors','null_points','null_pairs'])]
for pattern,point_count,descriptor_count,duration,previous,failure,layout,guard in profiles:
 calls.clear();freed.clear();allocations.clear();nth=0;u.mem_write(resource,bytes([pattern])*56);w(resource+36,duration);w(resource+40,old_points if previous else 0);w(resource+44,2);w(resource+48,old_descriptors if previous else 0);w(resource+52,2);w(0x12100dc,17)
 for i in range(point_count):u.mem_write(source_points+i*16,struct.pack('<3fI',float(i+1),float(2*i),float(-i),40+i))
 for i in range(descriptor_count):w(source_pairs+i*8,i);w(source_pairs+i*8+4,0 if layout=='empty'else 0xffffffff if layout=='negative'else min(2,point_count-i)if layout=='multi'else 1)
 if previous:
  for ref in [old_points,old_descriptors]:u.mem_write(ref,bytes([0x33])*32);allocations.append({'reference':ref,'size':32})
 def snap():return {'resource':bytes(u.mem_read(resource,56)).hex(),'source_points':bytes(u.mem_read(source_points,point_count*16)).hex(),'source_pairs':bytes(u.mem_read(source_pairs,descriptor_count*8)).hex(),'allocations':[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex(),'freed':v['reference']in freed}for v in allocations]}
 before=snap();w(stack,end)
 for i,v in enumerate([0 if guard=='null_points'else source_points,point_count,0 if guard=='null_pairs'else source_pairs,descriptor_count]):w(stack+4+i*4,v)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,resource);u.emu_start(0xb1b220,end,count=5000);assert u.reg_read(UC_X86_REG_EIP)==end;rows.append({'guard':guard,'layout':layout,'pattern':pattern,'failure':failure,'point_count':point_count,'descriptor_count':descriptor_count,'before':before,'after':snap(),'result':u.reg_read(UC_X86_REG_EAX),'calls':list(calls)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xb1b220','case_count':len(rows),'cases':rows,'native_addresses':len(visited),'findings':['Old point and descriptor allocations are released before validation/allocation; old counts are reset.','Two allocations copy point records and distribute interior point references into descriptors; jitter amplitudes initialize to0. Descriptor last-point duration is replaced by resource word36.','Second allocation failure retains the first point allocation and count; cleanup/resource lifetime is required later.'],'limits':['Physical allocation/free and memcpy are controlled transport primitives. Valid descriptor starts/count1/2/0/-1 and16 null/zero input guards only; out-of-range spans and invalid-start fault behavior, shared interior-reference resolution, Rust resource producer/teardown and whole manager/frame integration remain required.']}
(r/'data/4.20/audio_path_resource_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native path resource construction cases')
