"""Execute original frame tail with enabled one-shot request; backend capture only."""
from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/qualify_native_audio_requests.py').read_text().split('u.hook_add(unicorn.UC_HOOK_CODE,guard)')[0],'audio setup','exec'))
from unicorn.x86_const import UC_X86_REG_EBP,UC_X86_REG_ESI,UC_X86_REG_EBX,UC_X86_REG_MXCSR
frame=stack+0x800;context=heap+0x800
visited=set()
def hook(uc,a,size,user):
 visited.add(a)
 if 0x93f9bd<=a<=0x93fa0b:return
 guard(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
rows=[]
for birth,old,current in [(0.,0.,2.),(0.,.5,2.),(0.,1.,1.),(0.,1.25,1.25),(10.,10.25,12.),(10.,10.25,10.25)]:
 for emit in [False,True]:
  for stopped in [False,True]:
   u.mem_write(heap,bytes(0x1000));u.mem_write(stack,bytes(0x1000));calls.clear()
   def w(a,v):u.mem_write(a,struct.pack('<I',v&0xffffffff))
   w(heap,heap+0x400);w(heap+0x404,heap+0x500);w(heap+0x518,tramp+0x18)
   w(heap+0x15c,4);event_names={heap+0x14c:'qualified-create'}
   w(heap+0x1ac,-1);w(heap+0x1b0,-1)
   for off,value in [(0xa8,birth),(0xb0,old)]:u.mem_write(heap+off,struct.pack('<f',value))
   w(frame+4,tramp);u.mem_write(frame+8,struct.pack('<f',current));u.mem_write(frame+0x10,bytes([emit]))
   for reg,value in [(UC_X86_REG_ESP,frame-0x5c),(UC_X86_REG_EBP,frame),(UC_X86_REG_ESI,heap),(UC_X86_REG_EBX,context),(UC_X86_REG_MXCSR,0x1f80)]:u.reg_write(reg,value)
   u.emu_start(0x93f9eb if stopped else 0x93f9bd,tramp,count=1000)
   assert u.reg_read(UC_X86_REG_EIP)==tramp
   expected_call=emit and not stopped and old-birth<1.
   assert len(calls)==int(expected_call),(birth,old,current,emit,stopped,calls)
   if calls:assert calls[0]['age']==old-birth
   after=struct.unpack('<f',u.mem_read(heap+0xb0,4))[0]
   assert after==(old if stopped else current)
   rows.append(dict(birth=birth,previous_time=old,input_time=current,emit=emit,stopped=stopped,calls=list(calls),stored_time=after))
proof=dict(passed=True,complete=False,source=str(exe),native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,case_count=len(rows),native_addresses=len(visited),findings=['Enabled creation request in original frame tail uses previous B0 minus birth A8, before replacing B0 with supplied frame time.','Strict age <1 gate applies to previous time, including a frame that jumps beyond 1.','Stopped path does not request creation and preserves previous clock; paused equal-time inputs preserve age.'],limits=['Backend callback captured, no playback. Tail and request functions executed; frame head, provider and complete ordinary emitter update remain to qualify.','Finite exactly representable time values; no claim about all floating point profiles.'])
(r/'data/4.20/audio_frame_tail_clock_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps(dict(passed=True,cases=len(rows),native_addresses=len(visited))))
