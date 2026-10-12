"""Original9406DB..94071E stop request and actual93FA10, including its queue."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_complex_particle_storage.py').read_text(encoding='utf-8').split('\ncases=[]')[0].replace('\nu.hook_add(unicorn.UC_HOOK_CODE,hook)\n','\nregistered_hook=u.hook_add(unicorn.UC_HOOK_CODE,hook)\n')
exec(compile(setup,'native setup','exec'));u.hook_del(registered_hook);native_hook=hook
engine=heap+0x9000;actor=heap+0xa000;wrapper=heap+0xb000;context=heap+0xc000;attachment_manager=heap+0xd000;state=heap+0xe000;manager_vt=heap+0xf000;state_vt=heap+0xf100;clock_obj=heap+0xf200;clock_vt=heap+0xf300;clock_data=heap+0xf400;audio_vt=heap+0xf500;stop_config=heap+0xf600;pending=heap+0x50000;attachment_data=heap+0x60000
detach=end+0x500;owner_cleanup=end+0x510;eligible=end+0x520;owner_key=end+0x530;clock_entry=end+0x540;clock_code=end+0x550;audio_release=end+0x560
u.mem_write(clock_code,b'\xd9\x05'+struct.pack('<I',clock_data)+b'\xc3')
events=[];gate=False;clock=0.;stop_address=0x94071e
def hook(uc,a,size,user):
 if a in (stop_address,0x940e83):u.emu_stop();return
 if clock_code<=a<clock_code+7:return
 sp=u.reg_read(UC_X86_REG_ESP);obj=u.reg_read(UC_X86_REG_ECX)
 if a==detach:assert obj==attachment_manager;events.append({'event':'detach','key':read32(sp+4)});finish(pop=4);return
 if a==eligible:assert obj==state;events.append({'event':'owner_eligible'});finish(eax=int(gate));return
 if a==owner_key:assert obj==state;events.append({'event':'owner_key'});finish(eax=77);return
 if a==owner_cleanup:assert obj==attachment_manager;events.append({'event':'owner_cleanup','actor':read32(sp+4),'key':read32(sp+8)});finish(pop=8);return
 if a==clock_entry:assert obj==clock_obj;events.append({'event':'clock'});u.reg_write(UC_X86_REG_EIP,clock_code);return
 if a==audio_release:assert obj==engine+4;events.append({'event':'audio_release','key':struct.unpack('<i',u.mem_read(sp+4,4))[0]});finish(pop=4);return
 native_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
profiles=[(False,False,-1.),(True,False,1.),(True,True,-1.),(True,True,0.),(True,True,1.)]
for requests,linked,flags,config_flags,attachment_count,owner_profile in itertools.product([0,0x400,0x401,0x80000400],[False,True],[1,65],[0,16],[0,2],profiles):
 present,gate,owner_threshold=owner_profile;clock=5.25;events=[]
 for ptr,length in [(engine,0x200),(actor,0x200),(wrapper,0x200),(stop_config,0x200),(attachment_data,0xa0)]:u.mem_write(ptr,b'\0'*length)
 write32(actor,engine);write32(engine+4,audio_vt);write32(audio_vt+0x20,audio_release);write32(actor+0xe8,stop_config);u.mem_write(stop_config+0x1bc,bytes([config_flags]));write32(stop_config+0x1d0,bits(owner_threshold));u.mem_write(actor+0x1dc,bytes([flags]));write32(actor+0x148,bits(999.));write32(actor+0x1ac,0);write32(actor+0x1b0,42)
 write32(engine+0xd0,pending);write32(engine+0xd4,pending);write32(engine+0xd8,pending+256)
 write32(wrapper+0x114,actor if linked else 0);write32(wrapper+0x144,requests);write32(wrapper+0x158,context);write32(context+8,attachment_manager);write32(attachment_manager,manager_vt);write32(manager_vt+0x34,detach);write32(manager_vt+0x40,owner_cleanup)
 write32(wrapper+0xc8,state if present else 0);write32(state,state_vt);write32(state_vt+0x24,eligible);write32(state_vt+0x28,owner_key)
 write32(wrapper+0x14c,attachment_data);write32(wrapper+0x150,attachment_data+attachment_count*80);write32(wrapper+0x154,attachment_data+160)
 for i in range(attachment_count):write32(attachment_data+i*80,100+i);write32(attachment_data+i*80+0x48,15)
 write32(0x2d78f28,clock_obj);write32(clock_obj,clock_vt);write32(clock_vt+4,clock_entry);write32(clock_data,bits(clock));write32(0x14bef40,0)
 snapshots=[]
 for repeat in range(2):
  sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBP,sp-0x100);u.reg_write(UC_X86_REG_EDI,wrapper);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPTAG,0xffff)
  u.emu_start(0x9406db,stop_address,count=1000000);assert u.reg_read(UC_X86_REG_EIP) in (stop_address,0x940e83)
  snapshots.append({'requests':read32(wrapper+0x144),'attachment_count':(read32(wrapper+0x150)-read32(wrapper+0x14c))//80,'flags':int(u.mem_read(actor+0x1dc,1)[0]),'stop_time':hex(read32(actor+0x148)),'handles':[struct.unpack('<i',u.mem_read(actor+o,4))[0] for o in (0x1ac,0x1b0)],'pending':[read32(pending+i*4) for i in range((read32(engine+0xd4)-pending)//4)],'events':events.copy()})
 cases.append({'requests':requests,'linked':linked,'flags':flags,'config_flags':config_flags,'attachment_count':attachment_count,'owner_present':present,'owner_eligible':gate,'owner_threshold':owner_threshold,'clock_bits':hex(bits(clock)),'actor':actor,'snapshots':snapshots})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'cases':cases,'range':'9406DB..94071E','adapters':['Original request dispatch,9412C0/947300/94BEA0 attachment clearing,9413C0 owner eligibility policy,93FA10 and ordered queue helpers execute.','Clock endpoint supplies5.25 through x87; attachment detach, owner eligibility/key/cleanup and logical audio release virtual endpoints record callbacks. Concrete virtual bodies of those endpoints remain separate.','Legal0/2attachment records with short empty strings, preallocated pending queue,0/42audio handles; linked/null effect and owner gates supplied.'],'limits':['Stops before other request bits, pose/property transfer and final request reset; whole940frame unqualified.','Manager attachment deletion, owner state virtual bodies, actual audio/GPU consumption and acquisition incomplete.','Queue growth, concurrent ownership and ordinary application rendering not qualified.']}
(r/'data/4.20/troy_stop_consumer_contract.json').write_text(json.dumps(proof,separators=(',',':'))+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'passed':True,'cases':len(cases),'complete':False}))
