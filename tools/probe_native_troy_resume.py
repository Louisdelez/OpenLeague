"""Whole93EEE0 resume including original93ED60 audio acquisition policy."""
from pathlib import Path
import json,datetime,ctypes,shutil,itertools
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_troy_reset.py').read_text(encoding='utf-8').split('\nfor index,(complex_count')[0]
setup=setup.replace("'0x93e6f0<=a<0x93e989'","'0x93ed60<=a<0x93ef76'")
setup=setup.replace('\nu.hook_add(unicorn.UC_HOOK_CODE,hook)\n','\nreset_hook_id=u.hook_add(unicorn.UC_HOOK_CODE,hook)\n')
exec(compile(setup,'resume setup','exec'))
u.hook_del(reset_hook_id);reset_hook=hook
wrapper=heap+0x5000;owner=heap+0x6000;owner_vtable=heap+0x6400;actor_config=heap+0x7000
entries={name:end+0x1000+i*0x10 for i,name in enumerate(['primary','secondary','pause','eligible','owner_id'])}
def resume_hook(uc,a,size,user):
 if a in entries.values():
  name=next(k for k,v in entries.items() if v==a);sp=u.reg_read(UC_X86_REG_ESP)
  if name=='eligible':events.append({'event':name});finish(eax=eligibility);return
  if name=='owner_id':events.append({'event':name});finish(eax=1234);return
  assert u.reg_read(UC_X86_REG_ECX)==engine+4
  if name=='pause':events.append({'event':'audio_pause','key':read32(sp+4),'paused':read32(sp+8)});finish(pop=8);return
  primary=name=='primary';argc=3 if primary else 4;args=[read32(sp+4+i*4) for i in range(argc)]
  assert args[0]==actor+(0x17c if primary else 0x194) and args[-2]==actor+0x90
  events.append({'event':'audio_create','kind':name,'owner_id':None if primary else args[1],'elapsed':hex(args[-1]),'descriptor':bytes(u.mem_read(args[0],24)).hex(),'position':[hex(read32(args[-2]+i*4)) for i in range(3)]})
  finish(pop=argc*4,eax=returns[0 if primary else 1]);return
 reset_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,resume_hook)
patterns=[0,0x80000000,1,0x7fa01234,0xffa05678,0x3f800000]
cases=[]
profiles=itertools.product([[0xffffffff,0xffffffff],[0,42],[7,0xffffffff],[0xffffffff,8]],[(0,0),(1,0),(0,1),(1,1)],[0,42,0xffffffff],[(0,0),(2,0),(0,1),(2,1)],range(6))
def snapshot():return {'handles':[read32(actor+o) for o in (0x1ac,0x1b0)],'flags_1dc':u.mem_read(actor+0x1dc,1)[0],'flags_1dd':u.mem_read(actor+0x1dd,1)[0],'field_ec':hex(read32(actor+0xec)),'global_last_primary':read32(0x2d8ded4),'events':events.copy()}
for index,(handles,descriptors,created,(source_flags,config_flags),phase) in enumerate(profiles):
 returns=[created,[0xffffffff,0,42][index%3]];eligibility=[0,1,255][index%3];present=index%4!=0;times=[patterns[phase],patterns[(phase+1)%6]];delay=patterns[(phase+2)%6];ec=patterns[(phase+3)%6];position=[patterns[(phase+i)%6] for i in range(3)];captures=[]
 for corrected in [False,True]:
  enabled=corrected;events=[];u.mem_write(actor,b'\0'*0x200);u.mem_write(wrapper,b'\0'*0x200);u.mem_write(actor_config,b'\0'*0x200);write32(actor,engine);write32(actor+4,wrapper);write32(actor+0xe8,actor_config);write32(engine+4,audio_vtable)
  for name,offset in [('primary',0x10),('secondary',0x14),('pause',0x24)]:write32(audio_vtable+offset,entries[name])
  write32(wrapper+0xc8,owner if present else 0);write32(owner,owner_vtable);write32(owner_vtable+0x24,entries['eligible']);write32(owner_vtable+0x50,entries['owner_id']);write32(actor+0x70,source_flags);write32(actor_config+0x1bc,config_flags);write32(actor_config+0x1c0,delay)
  u.mem_write(actor+0x1dc,bytes([index%256]));u.mem_write(actor+0x1dd,bytes([(index//3)%256]));write32(actor+0xec,ec);write32(actor+0xa8,times[0]);write32(actor+0xb0,times[1]);write32(0x2d8ded4,77)
  u.mem_write(actor+0x90,b''.join(v.to_bytes(4,'little') for v in position))
  for i,off in enumerate([0x17c,0x194]):u.mem_write(actor+off,bytes([0x41+i])*24);write32(actor+off+16,descriptors[i]);write32(actor+[0x1ac,0x1b0][i],handles[i])
  before=snapshot();sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x93eee0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==sp+4 and restore is None;captures.append(snapshot())
 cases.append({'source_flags':source_flags,'config_flags':config_flags,'descriptors':list(descriptors),'returns':returns,'owner_present':present,'eligibility':eligibility,'times':[hex(v) for v in times],'delay':hex(delay),'position':[hex(v) for v in position],'before':before,'emulator':captures[0],'cpu':captures[1]})
for addr in blocks:kernel.VirtualFree(addr,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'93EEE0','audio_acquisition_entry':'93ED60','cases':cases,'actual_cpu_sse_operations':cpu_calls,'emulator_cpu_case_disagreements':sum(c['emulator']!=c['cpu'] for c in cases),'adapters':['Whole93EEE0 and93ED60 execute. Audio virtual10/14 create endpoints receive raw24-byte descriptors, position and SSE elapsed; virtual24 pause records key and argument0.','Owner virtual24 eligibility and virtual50 identity are explicit supplied endpoints. Audio return handles and global primary key initialized explicitly.','Independent actual CPU SSE subtraction/addition; original VM result preserved.'],'limits':['Actual audio creation/playback and owner producer bodies remain unqualified. Whole ordinary frame and graphical/audio integration incomplete.','Default masked arithmetic mode, single-threaded supplied state only.']}
(r/'data/4.20/troy_resume_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'disagreements':proof['emulator_cpu_case_disagreements']}))
