"""Native global clock construction and both emitter-manager call sites."""
from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
wrapper=vector+0xa000;manager=vector+0xb000;captured=[]
def hook(uc,a,size,user):
 if a==0x9933e0:
  assert read(uc.reg_read(UC_X86_REG_ESP)+4)==0x30
  finish(wrapper);return
 if a==0x92ca00:
  sp=uc.reg_read(UC_X86_REG_ESP);captured.append(dict(time_bits=read(sp+8),scratch=read(sp+4),receiver=uc.reg_read(UC_X86_REG_ECX)))
  uc.reg_write(UC_X86_REG_EIP,end);uc.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,hook)
rows=[]
for entry in [0x929739,0x92b918]:
 for dt in [.015625,.125,1.]:
  u.mem_write(obj,bytes(0x50));call(0x99c410,obj)
  u.mem_write(wrapper,bytes(0x30));call(0x9283f0,obj)
  assert read(0x2d78f28)==wrapper and read(wrapper)==0x10d6bc4 and read(wrapper+8)==obj
  frames=[]
  for scale in [1.,1.,0.,0.,0.,1.]:
   u.mem_write(obj+0x10,struct.pack('<d',scale));call(0x99c5e0,obj+0x20,struct.pack('<d',dt))
   u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EBX,manager);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff)
   u.emu_start(entry,end,count=100)
   assert captured[-1]['time_bits']==read(obj+0x2c) and captured[-1]['receiver']==manager
   frames.append(dict(scale=scale,game_time_bits=read(obj+0x2c),manager_argument=captured[-1]))
  assert frames[1]['game_time_bits']==frames[4]['game_time_bits']
  rows.append(dict(entry=hex(entry),delta=dt,frames=frames))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),sequences=len(rows),frames=sum(len(x['frames']) for x in rows),cases=rows,findings=['Original9283F0 allocates and initializes global2D78F28 wrapper with vtable10D6BC4, source+8, scale1, origin0, offset0.','Both929739 and92B918 call blocks execute virtual4 ->928360 -> supplied actual GameClock getter, convert to f32, pass unchanged to92CA00.','Zero source scale preserves manager time; resume advances.'],adapters=['Allocator returns mapped buffer. Source object supplied as actual GameClock; upstream928B00 caller source identity still requires verification.','Manager endpoint captured before execution; scratch packet contents not validated here. Source delta supplied.'],limits=['Not proof of full audio playback or upstream game initialization identity. Separate whole-frame request contract covers emitter body.'])
(r/'data/4.20/audio_manager_clock_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps(dict(passed=True,sequences=len(rows),frames=proof['frames'])))
