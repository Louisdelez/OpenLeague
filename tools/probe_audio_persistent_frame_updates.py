"""Original whole emitter frame with active audio descriptors; capture backend only."""
from pathlib import Path
r=Path('E:/OpenLeague')
s=(r/'tools/probe_native_troy_frame.py').read_text().split('\ncases=[];status=0')[0]
s=s.replace('def frame_hook(uc,a,size,user):','''def frame_hook(uc,a,size,user):
 if a in [end+0x1400,end+0x1410]:
  sp=u.reg_read(UC_X86_REG_ESP);age=struct.unpack('<f',uc.mem_read(sp+12,4))[0]
  events.append(dict(event='persistent' if a==end+0x1400 else 'creation',age=age))
  finish(eax=1,pop=12);return''')
exec(compile(s,'whole enabled frame setup','exec'))
rows=[];status=0;enabled=False
for birth,previous,current in [(0.,0.,2.),(0.,.5,2.),(0.,1.,1.),(10.,10.25,10.25),(10.,10.25,12.)]:
 for emit,source_flags,config_flags in itertools.product([False,True],[0,2,0x40],[0,0x20]):
  events=[]
  for a,n in [(actor,0x200),(actor_config,0x200),(scratch,0x12c)]:u.mem_write(a,bytes(n))
  write32(actor,engine);write32(actor+0xe8,actor_config);write32(engine,root_vtable);write32(root_vtable+0x2c,clock_endpoint);write32(root_vtable+0x50,get_status);write32(engine+0xe8,bits(10.));write32(engine+4,audio_vtable)
  for off,dst in [(0x10,end+0x1400),(0x18,end+0x1410),(0x24,pause_endpoint),(0x20,audio_release),(0x2c,position_endpoint)]:write32(audio_vtable+off,dst)
  write32(actor+0x70,source_flags);write32(actor_config+0x1bc,config_flags)
  write32(actor+0x15c,4);write32(actor+0x18c,4);write32(actor+0x1ac,0xffffffff);write32(actor+0x1b0,0xffffffff)
  write32(actor_config+0x138,bits(2.));write32(actor+0xa8,bits(birth));write32(actor+0xac,bits(previous));write32(actor+0xb0,bits(previous));write32(actor+0xb4,bits(100.))
  sp=stack+0x8000;u.mem_write(sp-0x400,bytes(0x440));write32(sp,end);write32(sp+4,bits(current));write32(sp+8,scratch);write32(sp+12,int(emit))
  for reg,value in [(UC_X86_REG_ESP,sp),(UC_X86_REG_ECX,actor),(UC_X86_REG_MXCSR,0x1f80),(UC_X86_REG_FPCW,0x37f),(UC_X86_REG_FPTAG,0xffff)]:u.reg_write(reg,value)
  u.emu_start(0x93f2f0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
  audio=[e for e in events if isinstance(e,dict) and e['event'] in ['persistent','creation']]
  assert all(e['age']==previous-birth for e in audio),audio
  assert any(e['event']=='persistent' for e in audio),events
  assert sum(e['event']=='creation' for e in audio)==int(emit and previous-birth<1),events
  assert read32(actor+0xb0)==bits(current)
  assert read32(actor+0x1ac)==1
  first_events=events.copy();events=[]
  first_flags=u.mem_read(actor+0x1dc,1)[0]
  u.mem_write(actor+0x1dc,bytes([first_flags & ~2])) # Explicit active-frame fixture, empty children otherwise finish.
  for i,v in enumerate([7.,8.,9.]):write32(actor+0x90+i*4,bits(v))
  write32(sp,end);write32(sp+4,bits(current));write32(sp+8,scratch);write32(sp+12,int(emit))
  u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor)
  u.emu_start(0x93f2f0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
  assert not any(isinstance(e,dict) and e['event']=='persistent' for e in events)
  assert read32(actor+0x1ac)==1
  updates=[e for e in events if isinstance(e,dict) and e['event']=='audio_position']
  assert updates==[{'event':'audio_position','key':1,'position':['0x40e00000','0x41000000','0x41100000']}],events
  pauses=[e for e in events if isinstance(e,dict) and e['event']=='audio_pause']
  assert pauses==([{'event':'audio_pause','key':1,'paused':0}] if config_flags&0x20 else []),events
  second_events=events.copy();events=first_events
  rows.append(dict(first_flags=first_flags,second_input_flags=first_flags & ~2,source_flags=source_flags,config_flags=config_flags,second_events=second_events,birth=birth,previous=previous,current=current,emit=emit,audio=audio,events=events.copy()))
proof=dict(passed=True,complete=False,native_sha256=digest,cases=rows,case_count=len(rows),findings=['Whole93F2F0 executed twice with logical return1; initial request ages use previous B0 minus A8.','Persistent logical return1 is retained. A second same-time frame does not reacquire.'],limits=['Engine clock/status endpoints supplied; time provider not qualified here. Empty child arrays; no playback, mixer or full ordinary emitter acceptance.','Finite exact time profiles only; visibility uses supplied accepting planes. Second-frame stopped bit explicitly cleared: active-state fixture, not natural empty-child continuation.'])
(r/'data/4.20/audio_persistent_frame_updates.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps(dict(passed=True,cases=len(rows))))
