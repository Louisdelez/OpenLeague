"""Original B27F20 control consumer; downstream notification endpoints captured."""
from pathlib import Path
r=Path('E:/OpenLeague')
s=(r/'tools/qualify_native_audio_pitch.py').read_text().split('u.hook_add(unicorn.UC_HOOK_CODE,guard)')[0];exec(compile(s,'pitch setup','exec'))
node=heap+0x100;vt=heap+0x400;duration=heap+0x500;getter=trap+0x200;end=trap+0x1000
u.mem_write(getter,b'\xd9\x05'+struct.pack('<I',duration)+b'\xc3')
w=lambda a,v:u.mem_write(a,struct.pack('<I',v&0xffffffff))
read=lambda a:struct.unpack('<I',u.mem_read(a,4))[0]
def finish(pop=0,eax=0):
 sp=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EAX,eax);u.reg_write(UC_X86_REG_EIP,read(sp));u.reg_write(UC_X86_REG_ESP,sp+4+pop)
calls=[]
def hook(uc,a,n,user):
 if a==0xaf36b0:
  sp=uc.reg_read(UC_X86_REG_ESP);args=list(struct.unpack('<4I',uc.mem_read(sp+4,16)));calls.append(dict(kind='control',args=args));finish();return
 if a==0xaed710:finish(eax=77);return
 if a==0xaf4af0:
  sp=uc.reg_read(UC_X86_REG_ESP);args=list(struct.unpack('<4I',uc.mem_read(sp+4,16)));calls.append(dict(kind='notification',args=args));finish(pop=16);return
u.hook_add(unicorn.UC_HOOK_CODE,hook)
rows=[]
for cents in [-1200.,-200.,0.,200.,1200.]:
 for value in [0.,1.,2500.]:
  calls.clear();u.mem_write(heap,bytes(0x600));w(heap,vt);w(heap+0xc,node);u.mem_write(heap+0x10,b'\1');w(vt+0x30,getter);u.mem_write(node+0x12c,b'\x20');w(node+0x48,123)
  u.mem_write(node+0x80,struct.pack('<f',cents));u.mem_write(duration,struct.pack('<f',value));sp=stack+0x1800;w(sp,end)
  u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,heap);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff)
  u.emu_start(0xb27f20,end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==sp+4
  assert [x['kind'] for x in calls]==['control','notification']
  c=calls[0]['args'];n=calls[1]['args'];assert c[:3]==[node,3,0] and n[0]==123 and n[3]==77 and c[3]==n[2]
  adjusted=struct.unpack('<f',struct.pack('<I',c[3]))[0];assert abs(adjusted-value/(2**(cents/1200)))<max(.001,abs(adjusted)*.000001)
  rows.append(dict(cents=cents,input=value,adjusted=adjusted,calls=list(calls),flags=u.mem_read(node+0x12a,1)[0]))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(b).hexdigest(),entry='0xb27f20',cases=rows,case_count=len(rows),findings=['Whole B27F20 executes actual pitch power and inverse scaling of supplied virtual30 value.','Actual AEE470 sets flags and forwards adjusted value as control3 to AF36B0; AF4AF0 receives original and adjusted values.'],adapters=['Virtual30 supplies finite test value; node flag12Cbit20 skips refresh.','AF36B0 and AF4AF0 notifications captured; AED710 returns tag77. Object flag10000 cleared.'],limits=['Does not establish semantic units of virtual30 or a native PCM resampler.','No mix/output integration or audible playback proof.'])
(r/'data/4.20/audio_pitch_control_consumer_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print('PASS',len(rows),'whole pitch-control consumer cases')
