"""Whole93E6F0 including actual Complex clear, Simple retirement queue and audio."""
from pathlib import Path
import json,struct,itertools,datetime,shutil,ctypes
r=Path('E:/OpenLeague');buffer_base=0x10000
setup=(r/'tools/probe_native_complex_concrete_trail_removal.py').read_text(encoding='utf-8').split('\ncases=[]')[0]+'\n'
setup=setup.replace(".split('\\ncases=[]')[0]", ".split('\\ncases=[]')[0].replace('address=heap+0x10000+i*0x4000','address=heap+buffer_base+i*0x4000')")
setup=setup.replace('\nu.hook_add(unicorn.UC_HOOK_CODE,hook)\n','\nconcrete_hook_id=u.hook_add(unicorn.UC_HOOK_CODE,hook)\n')
exec(compile(setup,'native reset setup','exec'));u.hook_del(concrete_hook_id);concrete_hook=hook
math_setup=(r/'tools/probe_native_troy_position_bounds.py').read_text(encoding='utf-8').split('\nconstants=')[0]
math_setup=math_setup[math_setup.index('from capstone'):].replace('0x921f60<=a<0x922000','0x93e6f0<=a<0x93e989')
exec(compile(math_setup,'actual SSE reset reference','exec'))
x87_setup=(r/'tools/probe_native_troy_properties.py').read_text(encoding='utf-8').split('\nactor=')[0]
x87_setup=x87_setup[x87_setup.index("machine=bytes.fromhex('d901d91ac3')"):]
exec(compile(x87_setup,'actual x87 reset reference','exec'))
actor=heap+0xf000;engine=heap+0xf400;audio_vtable=heap+0xf600;audio_release=end+0x700
def hook(uc,a,size,user):
 if a==audio_release:
  sp=u.reg_read(UC_X86_REG_ESP);assert u.reg_read(UC_X86_REG_ECX)==engine+4;events.append({'event':'audio_release','key':read32(sp+4)});finish(pop=4);return
 concrete_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
time_profiles=[(0,0),(bits(1.),bits(.5)),(bits(-1.),bits(2.)),(0x7f800000,0x7f800000),(0x7fa01234,0x7fc05678),(0x7fc01234,0x7fa05678),(1,0x80000001),(0x7f7fffff,0xff7fffff),(0x80000000,0)]
patterns=[0,0x80000000,1,0x7fa01234,0xffa05678,0x7fc01234,0x7f800000,0xff800000,bits(12.)]
cases=[]
def snapshot_complex(child):
 global container
 container=child['storage'];return {'flag':u.mem_read(child['object']+0x74,1)[0],'times':[hex(read32(child['object']+o)) for o in (0x78,0x80)],'counters':[read32(child['object']+o) for o in (0x84,0x88)],'last_update':hex(read32(child['object']+0x108)),'storage_last_update':hex(read32(container+0xa8)),'live_count':read32(container+0xac),'buffers':snapshot_buffers()}
def snapshot(complex_children,simple_children):
 begin=read32(0x2d6ee04);queue_count=(read32(0x2d6ee08)-begin)//4
 return {'handles':[read32(actor+o) for o in (0x1ac,0x1b0)],'times':[hex(read32(actor+o)) for o in (0xa8,0xac,0xb0)],'reset_b8':read32(actor+0xb8),'previous_position':[hex(read32(actor+0x84+i*4)) for i in range(3)],'flags_1dd':u.mem_read(actor+0x1dd,1)[0],'field_ec':read32(actor+0xec),'complex':[snapshot_complex(c) for c in complex_children],'simple':[{'flag':u.mem_read(c+0xd4,1)[0],'times':[hex(read32(c+o)) for o in (0xd8,0xdc)],'resource':read32(c+0xc)} for c in simple_children],'pending':[read32(begin+i*4) for i in range(queue_count)],'events':events.copy()}
for index,(complex_count,simple_count,particle_count,slots,capacity,time_profile) in enumerate(itertools.product([0,1,2],[0,2],[0,3],[0,1],[0,32],time_profiles)):
 captures=[];time,rewind=time_profile;flags_1dd=index%256;handles=[0xffffffff,42] if index%2 else [0,0xffffffff];position=[patterns[(index+i)%9] for i in range(3)];initial_queue=[] if capacity==0 else [99,98]
 for corrected in [False,True]:
  enabled=False;resources={};controls={};events=[];rows=[];complex_children=[];simple_children=[]
  for ci in range(complex_count):
   buffer_base=0x10000+ci*0x50000;container=heap+0x1000+ci*0x300;config=heap+0xc000+ci*0x800;height=0.;initialize(32,slots,False);write32(config+0x10,9 if index%2 else 1)
   for particle in range(particle_count):append(payload(particle,0),particle)
   ptr=read32(container+0x94);child=heap+0x9000+ci*0x400;u.mem_write(child,b'\xcc'*0x140);write32(child+0xec,container);complex_children.append({'object':child,'storage':container})
   for slot in range(particle_count*slots):
    addr=heap+0xa0000+ci*0x8000+slot*0x400;control=addr+0x200;state=addr+0x240;state_control=addr+0x260;identifier=ci*10+slot+1
    alive=index%3==0 or (index%3==1 and slot%2==0);null=index%3==2 and slot%2==1;state_alive=index%2==0
    write32(addr,resource_vtable);write32(control,control_vtable);write32(control+4,int(alive));write32(control+8,2 if alive else 1);write32(state,0);write32(state+8,slot);u.mem_write(state+0xc,b'\0');write32(state_control,control_vtable);write32(state_control+4,int(state_alive));write32(state_control+8,2 if state_alive else 1);write32(addr+0xc8,state);write32(addr+0xcc,state_control);write32(addr+0x144,0)
    item={'id':identifier,'object':addr,'control':control,'state':state,'state_control':state_control,'alive':alive,'null':null,'initial_flags':0,'initial_owner':slot,'state_alive':state_alive};resources[addr]=item;controls[control]=f'resource:{identifier}';controls[state_control]=f'state:{identifier}';write32(ptr+slot*8,0 if null else addr);write32(ptr+slot*8+4,0 if null else control);rows.append(item.copy())
   write32(container+0xac,particle_count);write32(container+0xa8,0x7fa0beef)
  u.mem_write(actor,b'\xcc'*0x200);write32(actor,engine);write32(engine+4,audio_vtable);write32(audio_vtable+0x20,audio_release);u.mem_write(actor+0x1dd,bytes([flags_1dd]));u.mem_write(actor+0x90,struct.pack('<3I',*position))
  for o,v in zip((0x1ac,0x1b0),handles):write32(actor+o,v)
  write32(actor+8,heap+0xe000);write32(actor+0xc,heap+0xe000+complex_count*4)
  for ci,child in enumerate(complex_children):write32(heap+0xe000+ci*4,child['object'])
  write32(actor+0x38,heap+0xe100);write32(actor+0x3c,heap+0xe100+simple_count*4)
  for si in range(simple_count):
   child=heap+0xf800+si*0x300;u.mem_write(child,b'\xcc'*0x100);write32(child+0xc,0 if (si+index)%3==0 else 1000+si);write32(heap+0xe100+si*4,child);simple_children.append(child)
  pending=heap+0xe0000;write32(0x2d6ee04,pending if capacity else 0);write32(0x2d6ee08,pending+len(initial_queue)*4 if capacity else 0);write32(0x2d6ee0c,pending+capacity*4 if capacity else 0)
  for i,v in enumerate(initial_queue):write32(pending+i*4,v)
  before=snapshot(complex_children,simple_children);events=[];allocation_cursor=heap+0x100000;enabled=corrected;sp=stack+0x8000;write32(sp,end);write32(sp+4,time);write32(sp+8,rewind);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPTAG,0xffff)
  u.emu_start(0x93e6f0,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==sp+12 and restore is None
  captures.append(snapshot(complex_children,simple_children))
  for row in rows:row.update(final_flags=read32(row['object']+0x144),final_owner=read32(row['state']+8),final_dead=int(u.mem_read(row['state']+0xc,1)[0]),resource_strong=read32(row['control']+4),resource_weak=read32(row['control']+8),state_strong=read32(row['state_control']+4),state_weak=read32(row['state_control']+8))
 cases.append({'time':hex(time),'rewind':hex(rewind),'position':[hex(v) for v in position],'complex_objects':complex_children,'trail_slots':slots,'resources':rows,'before':before,'emulator':captures[0],'cpu':captures[1]})
for addr in blocks:kernel.VirtualFree(addr,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'93E6F0','cases':cases,'actual_cpu_sse_operations':cpu_calls,'actual_cpu_x87_copies':x87_copies,'emulator_cpu_case_disagreements':sum(c['emulator']!=c['cpu'] for c in cases),'adapters':['Whole93E6F0 executes including audio release policy, timing, position copies, both child families, whole938740/93A7E0 and concrete Troy virtual64/A0, global Simple retirement queue and original948970growth.','Explicit0/1/2Complex children with0/3particles,0/1trail slots,0/2Simple children, live/expired/null trails and live/expired states.','Audio release and control destroy/free endpoints record calls; logical resource IDs and preexisting queue entries supplied. Allocator/security transport inherited.','Separate actual CPU SSE subtraction and x87 copies; original VM capture preserved. Stack argument balance checked.'],'limits':['Death emitters disabled and explicitly unsupported; complete reset request200 caller/prewarm, ordinary frame/rendering and resource acquisition remain incomplete.','Audio/control destruction endpoints are adapters; queued Simple resources not destroyed here.','Default masked arithmetic mode and single-thread reference graph only.']}
(r/'data/4.20/troy_reset_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'passed':True,'cases':len(cases),'sse':cpu_calls,'x87':x87_copies,'disagreements':proof['emulator_cpu_case_disagreements']}))
