from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
source=vector+0x1000;owner=vector+0x2000;new_owner=vector+0x3000;parents=vector+0x4000;parent_owners=vector+0x6000;tables=vector+0x7000;wrapper=vector+0x8000;vtable=vector+0xb000;callback=vector+0x1f000
regions=[('source',source,120),('owner',owner,60),('new_owner',new_owner,60),('parents',parents,360),('parent_owners',parent_owners,180),('parent_tables',tables,48),('wrapper',wrapper,4)]
def snap():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
calls=[];visited=set();allocation_failure=False;returns=[1,1,1]
def hook(uc,a,size,data):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xada670:
  pool=read(sp+4);size=read(sp+8);assert pool==19 and size==60;result=0 if allocation_failure else new_owner;calls.append({'kind':'allocate','pool':pool,'size':size,'result':result,'at_call':snap()});finish(result);return
 if a==callback:
  receiver=u.reg_read(UC_X86_REG_ECX);index=(receiver-parents)//120;result=returns[index];calls.append({'kind':'parent_virtual98','receiver':receiver,'selector':read(sp+4),'result':result,'at_call':snap()});finish(result,4);return
 assert 0xaff730<=a<0xaff7c9 or 0xafea80<=a<0xafeb06 or 0xaff3d0<=a<0xaff429 or 0xafdcf0<=a<0xafdd66 or 0xaffe50<=a<0xaffea1 or 0xb00800<=a<0xb00862,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,owner_kind,flag_bits,type_value,selector,parent_layout,counter,return_kind in itertools.product([0,0xa5],['existing','new','oom'],range(8),[0,0xbeef],[0,1,3,0xffff0003],['none','all','direct','wrapper'],[0,0xffff],['true','mixed','upper']):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 allocation_failure=owner_kind=='oom';w(source,0xff10f0);w(source+28,owner if owner_kind=='existing'else 0);u.mem_write(source+44,type_value.to_bytes(2,'little'));u.mem_write(source+46,bytes([(flag_bits&1)|((flag_bits&2))|((flag_bits&4)<<2)]));w(source+48,0)
 first=parents if parent_layout in['all','direct']else 0;second=parents+120 if parent_layout in['all','direct']else 0;third=parents+240 if parent_layout in['all','wrapper']else 0;w(source+32,first);w(source+36,second);w(source+56,wrapper if third else 0);w(wrapper,third);u.mem_write(owner+50,counter.to_bytes(2,'little'))
 for i in range(3):
  p=parents+i*120;o=parent_owners+i*60;t=tables+i*16;w(p,vtable);w(p+28,o);w(o+36,t);w(o+40,0);w(o+44,4)
 w(vtable+0x98,callback);w(0x12100dc,19);returns={'true':[1,1,1],'mixed':[1,0,1],'upper':[256,2,255]}[return_kind]
 before=snap();calls.clear();w(stack,end);w(stack+4,selector);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,source);u.emu_start(0xaff730,end,count=6000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'owner_kind':owner_kind,'source_flag_bits':flag_bits,'type_value':type_value,'selector':selector,'parent_layout':parent_layout,'initial_counter':counter,'parent_return_kind':return_kind,'before':before,'after':snap(),'calls':list(calls),'result_low_byte':u.reg_read(UC_X86_REG_EAX)&255})
d={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'native_addresses':len(visited),'cases':rows,'limits':['Actual Source virtual98 AFF730, owner ensure AFEA80, static selector AFF3D0, constructor60 AFDCF0, actual Source138 AFFE50 and parent owner attach B00800 execute. Fresh/existing/OOM owner, constructor flag mapping, type16, half50 counter wrap, selector upper bits, direct/wrapper/normal routing and noncanonical low-byte parent results captured. Full physical banks and all allocation/parent callback snapshots compared.','Root source FF10F0 supplied. Parent owners and child-table capacity4 preexisting; parent virtual98 controlled ABI adapters, not recursive execution. Static selector only: RTPC bit0x200 disabled. Growth, owner-null parent recursion, active source class/frame, real resource producers and complete audio playback remain open. Rust replay pending.']}
(r/'data/4.20/audio_path_source_input98_preparation.json').write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual Source98 owner60 creation/source138 parent attachment/counter wrap/selector/low-byte cases')
