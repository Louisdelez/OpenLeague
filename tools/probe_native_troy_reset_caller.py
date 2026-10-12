"""Original9408E8..940938 caller: capture arguments, BH and local prewarm time."""
from pathlib import Path
import json,datetime,ctypes,shutil,itertools
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_troy_reset.py').read_text(encoding='utf-8').split('\nfor index,(complex_count')[0]
exec(compile(setup,'reset caller setup','exec'))
wrapper=heap+0x5000;target=heap+0x6000;frame=stack+0x4000
def caller_hook(uc,a,size,user):
 if a==0x940938:u.emu_stop();return
 if a==0x93e6f0:
  sp=u.reg_read(UC_X86_REG_ESP);events.append({'event':'reset','target':u.reg_read(UC_X86_REG_ECX),'time':hex(read32(sp+4)),'rewind':hex(read32(sp+8))});finish(pop=8);return
u.hook_add(unicorn.UC_HOOK_CODE,caller_hook)
threshold=read32(0x1138ac8);assert threshold==0x3dcccccd
patterns=[0,0x80000000,0x3dcccccc,0x3dcccccd,0x3dccccce,0x3f800000,0xbf800000,0x7f800000,0xff800000,0x7fa01234,0x7fc05678]
cases=[]
for requests,time,rewind in itertools.product([0,0x200,0xffffffff],patterns,patterns):
 captures=[]
 for corrected in [False,True]:
  enabled=corrected;events=[];u.mem_write(wrapper,b'\0'*0x200);write32(wrapper+0x144,requests);write32(wrapper+0x114,target);write32(wrapper+0x118,time);write32(wrapper+0x148,rewind);write32(frame-0x178,0x12345678)
  sp=stack+0x8000;u.reg_write(UC_X86_REG_EDI,wrapper);u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBX,0xa5b6c7d8);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x9408e8,0x940938,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x940938 and u.reg_read(UC_X86_REG_ESP)==sp and restore is None
  captures.append({'ebx':hex(u.reg_read(UC_X86_REG_EBX)),'local_time':hex(read32(frame-0x178)),'requests':read32(wrapper+0x144),'events':events.copy()})
 cases.append({'requests':requests,'time':hex(time),'rewind':hex(rewind),'emulator':captures[0],'cpu':captures[1]})
for addr in blocks:kernel.VirtualFree(addr,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'range':'9408E8..940938','threshold':hex(threshold),'target':target,'cases':cases,'actual_cpu_x87_copies':x87_copies,'emulator_cpu_case_disagreements':sum(c['emulator']!=c['cpu'] for c in cases),'adapters':['Reset endpoint captures ECX, raw x87-copied stack arguments and ret8; whole reset separately qualified by troy_reset_contract.json.','Original COMISS, branch, BH write and local-time store execute with default masked FP modes. Actual CPU x87 copies preserve independent VM reference.'],'limits':['Prewarm loop and full ordinary frame/render integration remain unqualified. Reset body not executed by this caller-specific probe.']}
(r/'data/4.20/troy_reset_caller_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'x87':x87_copies,'disagreements':proof['emulator_cpu_case_disagreements']}))
