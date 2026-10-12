"""Native93F2F0 first phase with actual visibility, pause and resume bodies."""
from pathlib import Path
import json,datetime,ctypes,shutil,itertools
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_troy_reset.py').read_text(encoding='utf-8').split('\nfor index,(complex_count')[0]
setup=setup.replace("'0x93e6f0<=a<0x93e989'","'(0x93f2f0<=a<0x93f45b or 0x93ed60<=a<0x93ef76)'")
setup=setup.replace('\nu.hook_add(unicorn.UC_HOOK_CODE,hook)\n','\nreset_hook_id=u.hook_add(unicorn.UC_HOOK_CODE,hook)\n')
exec(compile(setup,'frame gate setup','exec'));u.hook_del(reset_hook_id);reset_hook=hook
actor_config=heap+0x7000;scratch=heap+0x5000;root_vtable=heap+0x6400;get_clock=end+0x1100;audio_pause=end+0x1110
def gate_hook(uc,a,size,user):
 if a in [0x93f45b,0x93f9bd,0x93f9eb]:u.emu_stop();return
 if a==get_clock:assert u.reg_read(UC_X86_REG_ECX)==engine;events.append({'event':'clock'});finish(eax=99);return
 if a==audio_pause:
  sp=u.reg_read(UC_X86_REG_ESP);events.append({'event':'audio_pause','key':read32(sp+4),'paused':read32(sp+8)});finish(pop=8);return
 if a in [0x93ed60,0x93eee0,0x93ef80]:events.append({'event':{0x93ed60:'acquire',0x93eee0:'resume',0x93ef80:'pause'}[a]})
 reset_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,gate_hook)
profiles=list(itertools.product([0,1,2,4,8,0x10,0x80,0xff],[0,2,0x40,0x42],[0,1,0x20,0x21],[False,True],[0,0x3f800000,0xbf800000,0x7fa01234,0x7f800000]))
cases=[]
for index,(flags,source_flags,config_flags,visible,lifetime) in enumerate(profiles):
 time=[0x3f800000,0x7fa01234,0x7f800000][index%3];start=[0,0x3f800000,0x7f800000][(index//3)%3];captures=[]
 for corrected in [False,True]:
  enabled=corrected;events=[];u.mem_write(actor,b'\0'*0x200);u.mem_write(actor_config,b'\0'*0x200);u.mem_write(scratch,b'\0'*0x12c);write32(actor,engine);write32(actor+0xe8,actor_config);write32(engine,root_vtable);write32(root_vtable+0x2c,get_clock);write32(engine+4,audio_vtable);write32(audio_vtable+0x24,audio_pause);write32(audio_vtable+0x20,audio_release)
  if not visible:write32(scratch+0x78,bits(-1.))
  write32(actor+0x70,source_flags);write32(actor_config+0x1bc,config_flags);write32(actor_config+0x1c0,bits(.5));write32(actor_config+0x58,0x12345678);u.mem_write(actor+0x1dc,bytes([flags]));u.mem_write(actor+0x1dd,bytes([index%256]));write32(actor+0xec,bits(.25));write32(actor+0xa8,start);write32(actor+0xb4,lifetime)
  handles=[0xffffffff,0xffffffff] if index%2 else [0,42]
  for o,v in zip([0x1ac,0x1b0],handles):write32(actor+o,v)
  sp=stack+0x8000;write32(sp,end);write32(sp+4,time);write32(sp+8,scratch);write32(sp+12,0);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff)
  u.emu_start(0x93f2f0,0x93f45b,count=10000);path={0x93f45b:'continue',0x93f9bd:'skip',0x93f9eb:'stop'}[u.reg_read(UC_X86_REG_EIP)]
  captures.append({'path':path,'visible':u.mem_read(sp+11,1)[0],'clock':read32(actor_config+0x58),'flags_1dc':u.mem_read(actor+0x1dc,1)[0],'flags_1dd':u.mem_read(actor+0x1dd,1)[0],'field_ec':hex(read32(actor+0xec)),'handles':[read32(actor+o) for o in [0x1ac,0x1b0]],'events':events.copy()})
 cases.append({'flags':flags,'source_flags':source_flags,'config_flags':config_flags,'visible':visible,'time':hex(time),'start':hex(start),'lifetime':hex(lifetime),'initial_flags_1dd':index%256,'initial_handles':handles,'emulator':captures[0],'cpu':captures[1]})
for addr in blocks:kernel.VirtualFree(addr,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'range':'93F2F0..93F45B with skip/stop boundaries','cases':cases,'actual_cpu_sse_operations':cpu_calls,'emulator_cpu_case_disagreements':sum(c['emulator']!=c['cpu'] for c in cases),'adapters':['Actual8E36B0 visibility,93EF80pause,93EEE0resume and93ED60acquire bodies execute. Child arrays empty and audio descriptors disabled; audio pause/release endpoints record calls.','Root virtual2C supplies99. Six-plane scratch supplied with an optional rejecting plane; owner bounds zero.','Independent actual CPU scalar math for lifetime and resume delay. Stops before continuing frame producers or skip/stop final writes.'],'limits':['Remaining frame, nonempty child transitions, real root clock/plane producers and ordinary graphics/audio integration not qualified.']}
(r/'data/4.20/troy_frame_gate_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'disagreements':proof['emulator_cpu_case_disagreements']}))
