"""Whole941210 attachment update and940C15 caller stop gate."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_complex_particle_storage.py').read_text(encoding='utf-8').split('\ncases=[]')[0].replace('\nu.hook_add(unicorn.UC_HOOK_CODE,hook)\n','\nregistered_hook=u.hook_add(unicorn.UC_HOOK_CODE,hook)\n')
exec(compile(setup,'native attachment setup','exec'));u.hook_del(registered_hook);native_hook=hook
actor=heap+0x9000;wrapper=heap+0xa000;state=heap+0xb000;state_vt=heap+0xb100;context=heap+0xc000;manager=heap+0xc100;manager_vt=heap+0xc200;data=heap+0xd000
eligible_entry=end+0x900;key_entry=end+0x910;activate_entry=end+0x920;pause_entry=end+0x930
events=[];profile={}
def hook(uc,a,size,user):
 if a==0x940c2b:u.emu_stop();return
 sp=u.reg_read(UC_X86_REG_ESP);obj=u.reg_read(UC_X86_REG_ECX)
 if a==eligible_entry:assert obj==state;events.append({'event':'eligible'});finish(eax=profile['eligible']);return
 if a==key_entry:assert obj==state;events.append({'event':'key'});finish(eax=profile['key']&0xffffffff);return
 if a==activate_entry:
  assert obj==manager;events.append({'event':'activate','id':read32(sp+4),'key':read32(sp+8),'descriptor':bytes(u.mem_read(read32(sp+12),76)).hex()});finish(pop=12);return
 if a==pause_entry:assert obj==manager;events.append({'event':'pause','id':read32(sp+4)});finish(pop=4);return
 native_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
for frame,owner,linked,flags,key,visibility,source_flags,count in itertools.product([False,True],[(False,0),(True,0),(True,1),(True,255)],[False,True],[0,16],[-1,0,42],[0,2,255],[0,8],[0,2]):
 if frame and not linked:continue
 present,eligible=owner;profile={'eligible':eligible,'key':key};events=[]
 u.mem_write(actor,b'\0'*0x200);u.mem_write(wrapper,b'\0'*0x200);u.mem_write(data,b'\0'*160);u.mem_write(actor+0x1dc,bytes([flags]));write32(actor+0x70,source_flags);write32(wrapper,0x10d6db4);write32(wrapper+0x114,actor if linked else 0);write32(wrapper+0xc8,state if present else 0);u.mem_write(wrapper+0x84,bytes([visibility]));write32(wrapper+0x158,context);write32(context+8,manager);write32(manager,manager_vt);write32(manager_vt+0x2c,activate_entry);write32(manager_vt+0x30,pause_entry);write32(state,state_vt);write32(state_vt+0x24,eligible_entry);write32(state_vt+0x28,key_entry)
 write32(wrapper+0x14c,data);write32(wrapper+0x150,data+count*80);write32(wrapper+0x154,data+160)
 for i in range(count):write32(data+i*80,100+i);write32(data+i*80+4,0x12340000+i);write32(data+i*80+0x48,15)
 attachments=[{'id':read32(data+i*80),'descriptor':bytes(u.mem_read(data+i*80+4,76)).hex()} for i in range(count)]
 sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,wrapper);u.reg_write(UC_X86_REG_EDI,wrapper)
 start=0x940c15 if frame else 0x941210;stop=0x940c2b if frame else end;u.emu_start(start,stop,count=100000);assert u.reg_read(UC_X86_REG_EIP)==stop;assert u.reg_read(UC_X86_REG_ESP)==sp+(0 if frame else 4)
 assert read32(wrapper+0x150)==data+count*80
 cases.append({'frame':frame,'owner_present':present,'owner_eligible':eligible,'linked':linked,'emitter_flags':flags,'key':key,'visibility':visibility,'source_flags':source_flags,'attachments':attachments,'events':events.copy()})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'941210','caller':'940C15..940C2B','concrete_gate':'940F30','cases':cases,'adapters':['Whole941210 executes, including concrete Troy virtual44/940F30 raw visibility query and original attachment iteration.288profiles also execute actual caller940C15 stop-bit gate.','Owner eligibility/key and manager virtual2C/30 endpoints supply/observe explicit values.80byte attachment records supplied; descriptor76bytes forwarded unchanged.','Stack balance and unchanged attachment count checked.'],'limits':['Owner virtual producer bodies, manager concrete virtual2C/30 implementations and graphical/audio resources incomplete.','Entire940frame and reset/audio/child flag phases remain incomplete; no ordinary renderer integration.']}
(r/'data/4.20/troy_attachments_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'passed':True,'cases':len(cases),'events':sum(len(c['events']) for c in cases)}))
