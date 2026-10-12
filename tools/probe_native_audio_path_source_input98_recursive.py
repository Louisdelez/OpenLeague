from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
source=vector+0x1000;wrappers=vector+0x5000;old_owners=vector+0x6000;new_owners=vector+0x7000;old_tables=vector+0x8000;new_tables=vector+0xa000
regions=[('sources',source,480),('wrappers',wrappers,16),('old_owners',old_owners,256),('new_owners',new_owners,256),('old_tables',old_tables,128),('new_tables',new_tables,1024)]
def snap():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
calls=[];freed=[];allocations=[];visited=set();failure='none';owner_index=table_index=0
parents=[source+i*120 for i in range(4)]
def hook(uc,a,size,data):
 global owner_index,table_index
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xada670:
  pool=read(sp+4);size=read(sp+8);assert pool==19 and(size==60 or size in[4,8,12,16]);fail=(failure=='owner'and size==60)or(failure=='table'and size!=60)
  if size==60:result=0 if fail else new_owners+owner_index*64;owner_index+=not fail
  else:result=0 if fail else new_tables+table_index*32;table_index+=not fail
  assert owner_index<=4 and table_index<=32;calls.append({'kind':'allocate','pool':pool,'size':size,'result':result,'at_call':snap()});
  if result:allocations.append({'reference':result,'size':size})
  finish(result);return
 if a==0xada3e0:
  pool=read(sp+4);ref=read(sp+8);calls.append({'kind':'free','pool':pool,'reference':ref,'at_call':snap()});assert ref not in freed;freed.append(ref);finish(0);return
 if a==0xaff730 and u.reg_read(UC_X86_REG_ECX)!=source:calls.append({'kind':'parent_input98','receiver':u.reg_read(UC_X86_REG_ECX),'selector':read(sp+4),'at_call':snap()})
 assert 0xaff730<=a<0xaff7c9 or 0xafea80<=a<0xafeb06 or 0xaff3d0<=a<0xaff429 or 0xafdcf0<=a<0xafdd66 or 0xaffe50<=a<0xaffea1 or 0xb00800<=a<0xb00862 or 0xaff610<=a<0xaff67c,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,graph,existing_mask,failure,table_mode,selector in itertools.product([0,0xa5],['chain','fork','shared','duplicate'],[0,15,5],['none','owner','table'],['empty','spare','full'],[0,3,0xffff0003]):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 owner_index=table_index=0
 for i in range(4):
  p=parents[i];o=old_owners+i*64;t=old_tables+i*32;w(p,0xff10f0);w(p+28,o if existing_mask&(1<<i)else 0);w(p+32,0);w(p+36,0);w(p+56,0);u.mem_write(p+44,(11+i).to_bytes(2,'little'));u.mem_write(p+46,bytes([17 if i&1 else 3]));w(p+48,0);w(wrappers+i*4,0)
  for off in[0,4,8,12,16,20,24,48,52]:w(o+off,0)
  w(o+36,t);w(o+40,1 if table_mode=='full'else 0);w(o+44,0 if table_mode=='empty'else 1);w(t,0x60000000+i)
 if graph=='chain':
  for i in range(3):w(parents[i]+32,parents[i+1])
 elif graph=='fork':w(source+32,parents[1]);w(source+36,parents[2]);w(source+56,wrappers);w(wrappers,parents[3])
 elif graph=='shared':w(source+32,parents[1]);w(source+36,parents[2]);w(parents[1]+32,parents[3]);w(parents[2]+36,parents[3])
 else:w(source+32,parents[1]);w(source+36,parents[1]);w(source+56,wrappers);w(wrappers,parents[1]);w(parents[1]+32,parents[3])
 w(0x12100dc,19);before=snap();calls.clear();freed.clear();allocations.clear();w(stack,end);w(stack+4,selector);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,source);u.emu_start(0xaff730,end,count=30000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'graph':graph,'existing_mask':existing_mask,'failure':failure,'table_mode':table_mode,'selector':selector,'before':before,'after':snap(),'calls':list(calls),'allocations':list(allocations),'freed':list(freed),'result_low_byte':u.reg_read(UC_X86_REG_EAX)&255})
d={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Original AFF730 recursive4-node Source98, AFEA80/AFDCF0 owner60 producers, actual AFFE50/B00800 parent child-table attachment and AFF610 capacity+1 growth/copy/free-before-publication execute. Chain/fork/shared/duplicate graph, fresh/existing/mixed owners, OOM owner/table, empty/spare/full tables and selector upper bits captured. Only allocator/free ABI adapters; parent98 calls execute original bodies. Full physical banks and every call/free snapshot captured.','Source classes FF10F0 and static selector supplied; RTPC override disabled, allocator physical slots/capacity and borrowed initial child entries supplied. Malformed/cyclic graphs, mutable allocation/free callbacks, active voice class, full registry/action producer/progression/frame and physical playback remain open. Rust replay pending.']}
(r/'data/4.20/audio_path_source_input98_recursive_preparation.json').write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual recursive4-source owner creation/parent attachment/growth/allocation OOM/physical memory cases')
