"""Whole removal with legal live/expired weak handles and original Troy virtual64/A0 bodies."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_complex_particle_storage.py').read_text(encoding='utf-8').split('\ncases=[]')[0].replace('\nu.hook_add(unicorn.UC_HOOK_CODE,hook)\n','\nregistered_hook=u.hook_add(unicorn.UC_HOOK_CODE,hook)\n')
exec(compile(setup,'append setup','exec'));u.hook_del(registered_hook);append_hook=hook
resource_vtable=0x10d6db4;control_vtable=heap+0x8200;query_stub=0x928660;stop_stub=0x9289b0;destroy_stub=end+0x420;free_stub=end+0x430
assert read32(resource_vtable+0x64)==query_stub and read32(resource_vtable+0xa0)==stop_stub;write32(control_vtable,destroy_stub);write32(control_vtable+4,free_stub)
resources={};controls={};events=[]
def hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP);objptr=u.reg_read(UC_X86_REG_ECX)
 if a==query_stub:
  item=resources[objptr];events.append({'event':'query_state','id':item['id']})
 if a==stop_stub:
  item=resources[objptr];events.append({'event':'stop','id':item['id'],'dead':int(u.mem_read(item['state']+0xc,1)[0])})
 if a in (destroy_stub,free_stub):events.append({'event':'destroy' if a==destroy_stub else 'free_control','control':controls[objptr]});finish();return
 append_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
for kind,slots,index,mode,state_alive in itertools.product([1,4,5,9],[1,3],range(4),['live','expired','mixed'],[False,True]):
 height=0.;initialize(32,slots,False);write32(config+0x10,kind);resources={};controls={};events=[];rows=[]
 for particle in range(4):append(payload(particle,0),particle)
 ptr=read32(container+0x94)
 for slot in range(4*slots):
  addr=heap+0x50000+slot*0x400;control=addr+0x200;state=addr+0x240;state_control=addr+0x260;identifier=slot+1
  alive=mode=='live' or (mode=='mixed' and slot%3==0);null=mode=='mixed' and slot%3==2
  write32(addr,resource_vtable);write32(control,control_vtable);write32(control+4,int(alive));write32(control+8,2 if alive else 1)
  write32(state,0);write32(state+8,slot//slots);u.mem_write(state+0xc,b'\0');write32(state_control,control_vtable);write32(state_control+4,int(state_alive));write32(state_control+8,2 if state_alive else 1);write32(addr+0xc8,state);write32(addr+0xcc,state_control);initial_flags=[0,0x40,0x80000400,0xffffffff][index];write32(addr+0x144,initial_flags)
  item={'id':identifier,'object':addr,'control':control,'state':state,'state_control':state_control,'alive':alive,'null':null,'initial_flags':initial_flags}
  resources[addr]=item;controls[control]=f'resource:{identifier}';controls[state_control]=f'state:{identifier}'
  write32(ptr+slot*8,0 if null else addr);write32(ptr+slot*8+4,0 if null else control);rows.append(item.copy())
 write32(container+0xac,4);before=snapshot_buffers();sp=stack+0x8000;write32(sp,end);write32(sp+4,index);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,container);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPTAG,0xffff)
 u.emu_start(0x937f30,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end;after=snapshot_buffers();assert read32(container+0xac)==3
 for row in rows:
  row.update(final_flags=read32(row['object']+0x144),final_owner=read32(row['state']+8),final_dead=int(u.mem_read(row['state']+0xc,1)[0]),resource_strong=read32(row['control']+4),resource_weak=read32(row['control']+8),state_strong=read32(row['state_control']+4),state_weak=read32(row['state_control']+8))
 cases.append({'kind':kind,'trail_slots':slots,'index':index,'mode':mode,'state_alive':state_alive,'before':before,'after':after,'resources':rows,'events':events.copy()})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'937F30 /93A7E0 /928660 /9289B0','concrete_troy_vtable':'0x10d6db4','cases':cases,'adapters':['Original whole removal, weak lock, atomic reference increments/decrements, ordered shifts and swap execute. Legal resource/weak-control/state graph supplied.','Original Troy vtable10D6DB4: virtual64/928660 reads C8/CC and retains weak state reference; virtualA0/9289B0 sets request bit400 in144. Entry observers capture callbacks without replacing either body.','Control block destroy/free virtual endpoints record calls; they do not release actual Windows memory.','Finite attribute payloads, null/live/expired resource handles, state lock success/failure supplied. Native heap/security transport retained.'],'limits':['Concrete Troy virtual64/A0 bodies now execute; resource acquisition, concrete control destruction, stop request consumption, death emitters and renderer binding remain incomplete.','Atomic instructions execute single threaded in emulator; concurrent weak lock/destruction is not qualified.','Death-emitter descriptors disabled; full birth/owner behavior and ordinary renderer binding remain incomplete.']}
(r/'data/4.20/complex_concrete_trail_removal_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'passed':True,'cases':len(cases),'stop_callbacks':sum(e['event']=='stop' for c in cases for e in c['events']),'state_queries':sum(e['event']=='query_state' for c in cases for e in c['events'])}))
