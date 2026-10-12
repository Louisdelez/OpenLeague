"""Original940C2B..940D19 orchestration; frame producer endpoints are adapters."""
from pathlib import Path
import json,datetime,ctypes,shutil,itertools
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_troy_reset.py').read_text(encoding='utf-8').split('\nfor index,(complex_count')[0]
setup=setup.replace("'0x93e6f0<=a<0x93e989'","'0x940c2b<=a<0x940d19'")
exec(compile(setup,'prewarm setup','exec'))
wrapper=heap+0x5000;target=heap+0x6000;frame=stack+0x4000;stop_after=0;updates=0
def prewarm_hook(uc,a,size,user):
 global updates
 if a==0x940d19:u.emu_stop();return
 if a in (0x93ef80,0x93eee0):
  assert u.reg_read(UC_X86_REG_ECX)==target;events.append({'event':'pause' if a==0x93ef80 else 'resume'});finish();return
 if a==0x8e2e80:
  assert u.reg_read(UC_X86_REG_ECX)==frame-0x170;events.append({'event':'scratch_create'});finish(eax=frame-0x170);return
 if a==0x93f2f0:
  sp=u.reg_read(UC_X86_REG_ESP);assert u.reg_read(UC_X86_REG_ECX)==target
  events.append({'event':'update','time':hex(read32(sp+4)),'scratch':read32(sp+8),'flag':read32(sp+12)});updates+=1
  if stop_after and updates>=stop_after:u.mem_write(target+0x1dc,bytes([u.mem_read(target+0x1dc,1)[0]|2]))
  finish(pop=12);return
 if a==0xc97c54:
  sp=u.reg_read(UC_X86_REG_ESP);assert [read32(sp+o) for o in (4,8,12,16)]==[frame-0x104,16,6,0x5642d0];events.append({'event':'scratch_destroy'});finish(pop=16);return
u.hook_add(unicorn.UC_HOOK_CODE,prewarm_hook)
profiles=[(bits(1.),bits(.1)),(bits(1.),bits(.2)),(bits(1.),bits(1.)),(bits(0.),bits(.3)),(bits(100000.),1),(0x7f800000,bits(1.)),(bits(1.),0x7f800000),(bits(1.),0x7fa01234),(0x7fa05678,bits(1.)),(bits(1.),0)]
cases=[]
for bh,initial_flags,stop_after,(time,rewind) in itertools.product([0,1],[0,2,128,130],[0,1,3],profiles):
 captures=[]
 for corrected in [False,True]:
  enabled=corrected;events=[];updates=0;u.mem_write(wrapper,b'\0'*0x200);u.mem_write(target,b'\0'*0x200);write32(wrapper+0x114,target);write32(wrapper+0x148,rewind);u.mem_write(target+0x1dc,bytes([initial_flags]));write32(frame-0x178,time);write32(frame-0x17c,0x12345678);write32(frame-0x174,0x87654321);write32(frame-4,0x55555555)
  sp=stack+0x8000;u.reg_write(UC_X86_REG_EDI,wrapper);u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBX,0xa5b600d8|(bh<<8));u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x940c2b,0x940d19,count=10000);assert u.reg_read(UC_X86_REG_EIP)==0x940d19 and u.reg_read(UC_X86_REG_ESP)==sp and restore is None
  captures.append({'ebx':hex(u.reg_read(UC_X86_REG_EBX)),'step':hex(read32(frame-0x17c)),'cursor':hex(read32(frame-0x174)),'unwind_state':hex(read32(frame-4)),'flags':u.mem_read(target+0x1dc,1)[0],'events':events.copy()})
 cases.append({'bh':bh,'initial_flags':initial_flags,'stop_after':stop_after,'time':hex(time),'rewind':hex(rewind),'emulator':captures[0],'cpu':captures[1]})
for addr in blocks:kernel.VirtualFree(addr,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'range':'940C2B..940D19','scratch_pointer':frame-0x170,'cases':cases,'actual_cpu_sse_operations':cpu_calls,'actual_cpu_x87_copies':x87_copies,'emulator_cpu_case_disagreements':sum(c['emulator']!=c['cpu'] for c in cases),'adapters':['Original arithmetic, loop branches, flag gates and destruction-call arguments execute.','Scratch constructor/destructor, pause93EF80/resume93EEE0 and frame93F2F0 endpoints record calls; supplied frame stop flag after0/1/3updates. No claim those bodies execute.','Independent actual CPU SSE and x87 argument copies; masked default arithmetic only.'],'limits':['Frame update/pause/resume/scratch bodies and ordinary rendering/audio remain unqualified.','Allocation failure, concurrent mutation and nonterminating positive-step cases not covered.']}
(r/'data/4.20/troy_prewarm_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'x87':x87_copies,'disagreements':proof['emulator_cpu_case_disagreements']}))
