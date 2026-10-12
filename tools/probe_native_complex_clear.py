"""Whole938740 clear with all13buffers and concrete Troy trail virtuals."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_complex_concrete_trail_removal.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'native clear setup','exec'))
cases=[]
for kind,slots,count,mode,state_alive,initial_flags in itertools.product([1,4,5,9],[0,1,3],[0,1,4],['live','expired','mixed'],[False,True],[0,0xffffffff]):
 height=0.;initialize(32,slots,False);write32(config+0x10,kind);resources={};controls={};events=[];rows=[]
 for particle in range(count):append(payload(particle,0),particle)
 ptr=read32(container+0x94)
 for slot in range(count*slots):
  addr=heap+0x50000+slot*0x400;control=addr+0x200;state=addr+0x240;state_control=addr+0x260;identifier=slot+1
  alive=mode=='live' or (mode=='mixed' and slot%3==0);null=mode=='mixed' and slot%3==2
  write32(addr,resource_vtable);write32(control,control_vtable);write32(control+4,int(alive));write32(control+8,2 if alive else 1)
  write32(state,0);write32(state+8,slot//slots);u.mem_write(state+0xc,b'\0');write32(state_control,control_vtable);write32(state_control+4,int(state_alive));write32(state_control+8,2 if state_alive else 1);write32(addr+0xc8,state);write32(addr+0xcc,state_control);write32(addr+0x144,initial_flags)
  item={'id':identifier,'object':addr,'control':control,'state':state,'state_control':state_control,'alive':alive,'null':null,'initial_flags':initial_flags}
  resources[addr]=item;controls[control]=f'resource:{identifier}';controls[state_control]=f'state:{identifier}'
  write32(ptr+slot*8,0 if null else addr);write32(ptr+slot*8+4,0 if null else control);rows.append(item.copy())
 write32(container+0xac,count);write32(container+0xa8,0x7fa0beef);before=snapshot_buffers();sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,container)
 u.emu_start(0x938740,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==sp+4
 after=snapshot_buffers();assert read32(container+0xac)==0 and read32(container+0xa8)==0xff7fffff and all(not b['records'] for b in after)
 for row in rows:row.update(final_flags=read32(row['object']+0x144),final_owner=read32(row['state']+8),final_dead=int(u.mem_read(row['state']+0xc,1)[0]),resource_strong=read32(row['control']+4),resource_weak=read32(row['control']+8),state_strong=read32(row['state_control']+4),state_weak=read32(row['state_control']+8))
 cases.append({'kind':kind,'trail_slots':slots,'count':count,'mode':mode,'state_alive':state_alive,'before':before,'after':after,'last_update':hex(read32(container+0xa8)),'live_count':read32(container+0xac),'resources':rows,'events':events.copy()})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'938740 /93A7E0 /928660 /9289B0','cases':cases,'adapters':['Whole938740 clears all13attribute/trailbuffers; original93A7E0 release, weak locks, concrete Troy virtual64/A0 and reference increments/decrements execute.','Explicit legal null/live/expired resource graph and empty/preallocated storage. Original heap/security adapters.','Control destroy/free endpoints record calls; no actual Windows deallocation.'],'limits':['Death emitter descriptors disabled; their emission/acquisition and complete reset200 caller remain incomplete.','Single threaded reference graph only; concurrent locking and concrete GPU/control destruction not qualified.','Ordinary renderer and full frame integration incomplete.']}
(r/'data/4.20/complex_clear_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'passed':True,'cases':len(cases),'events':sum(len(c['events']) for c in cases),'stop_callbacks':sum(e['event']=='stop' for c in cases for e in c['events'])}))
