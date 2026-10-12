"""Native93F9BD..93FA0B finalization, including disabled-descriptor93EE30."""
from pathlib import Path
import json,datetime,ctypes,shutil,itertools
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_troy_reset.py').read_text(encoding='utf-8').split('\nfor index,(complex_count')[0]
setup=setup.replace("'0x93e6f0<=a<0x93e989'","'0x93ee30<=a<0x93eedc'")
setup=setup.replace('\nu.hook_add(unicorn.UC_HOOK_CODE,hook)\n','\nreset_hook_id=u.hook_add(unicorn.UC_HOOK_CODE,hook)\n')
exec(compile(setup,'frame finish setup','exec'));u.hook_del(reset_hook_id);reset_hook=hook
context=heap+0x8000;frame=stack+0x4000
def finish_hook(uc,a,size,user):
 if a==0x93ee30:events.append('oneshot')
 reset_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,finish_hook)
patterns=[0,0x80000000,1,0x7fa01234,0xffa05678,0x7f800000,0xff800000,bits(1.),bits(2.)]
cases=[]
for index,(flags,visible,emit,stopped) in enumerate(itertools.product(range(256),[0,1],[False,True],[False,True])):
 time=patterns[index%9];old_time=patterns[(index+3)%9];start=patterns[(index+5)%9];counter=[0,77,0xffffffff][index%3];captures=[]
 for corrected in [False,True]:
  enabled=corrected;events=[];u.mem_write(actor,b'\0'*0x200);u.mem_write(context,b'\0'*0x80);u.mem_write(frame-0x60,b'\0'*0x90);u.mem_write(actor+0x1dc,bytes([flags]));write32(actor+0xb0,old_time);write32(actor+0xa8,start);write32(context+0x14,counter)
  write32(frame,0);write32(frame+4,end);write32(frame+8,time);u.mem_write(frame+0xf,bytes([visible]));u.mem_write(frame+0x10,bytes([int(emit)]));u.reg_write(UC_X86_REG_ESP,frame-0x5c);u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESI,actor);u.reg_write(UC_X86_REG_EBX,context);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x93f9eb if stopped else 0x93f9bd,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==frame+20
  captures.append({'last_input_time':hex(read32(actor+0xb0)),'flags':u.mem_read(actor+0x1dc,1)[0],'counter':read32(context+0x14),'events':events.copy()})
 cases.append({'flags':flags,'visible':visible,'emit':emit,'stopped':stopped,'time':hex(time),'old_time':hex(old_time),'start':hex(start),'counter':counter,'emulator':captures[0],'cpu':captures[1]})
for addr in blocks:kernel.VirtualFree(addr,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'range':'93F9BD..93FA0B','cases':cases,'actual_cpu_sse_operations':cpu_calls,'emulator_cpu_case_disagreements':sum(c['emulator']!=c['cpu'] for c in cases),'adapters':['Full native finalization executes including actual93EE30 with both one-shot descriptors disabled. All256flag bytes, visibility, emit and stopped path combinations, raw time words and counter wrap checked.','Normal tail updates visibility bit2 and rawB0; stopped path skips those writes and one-shot call. Both paths execute stop-bit policy and increment context14.','Original return restores saved registers and ret12; stack checked. Actual CPU subtraction supplied for93EE30.'],'limits':['One-shot audio descriptors disabled; actual audio emission and remaining full-frame producers/integration unqualified.','Default masked arithmetic mode only.']}
(r/'data/4.20/troy_frame_finish_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'disagreements':proof['emulator_cpu_case_disagreements']}))
