from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
voice=vector+0x10000;decoder=vector+0x12000;media=0x50000000
u.mem_map(media,0x1000000)
u.mem_map(0x60000000,0x1000000)
heap=0x60000000;allocations=[]
def hook(uc,a,size,user):
 global heap
 if a==0xb0e1d0:
  n=read(uc.reg_read(UC_X86_REG_ESP)+4);target=heap;heap+=(n+15)&~15;u.mem_write(target,bytes(n));finish(target);return
 if a==0xada670:
  n=read(uc.reg_read(UC_X86_REG_ESP)+8);target=decoder if not allocations else heap;allocations.append(n);heap+=(n+15)&~15;assert heap<0x61000000;u.mem_write(target,bytes(n));finish(target)

u.hook_add(unicorn.UC_HOOK_CODE,hook,begin=0xada670,end=0xada670)
u.hook_add(unicorn.UC_HOOK_CODE,hook,begin=0xb0e1d0,end=0xb0e1d0)
rows=[]
manifest=json.loads((r/'data/4.20/ambient_audio_manifest.json').read_text())
for m in manifest['media']:
 heap=0x60000000;allocations.clear();u.mem_write(0x14a83c8,bytes(124))
 b=(r/'assets'/m['wem']).read_bytes();assert hashlib.sha256(b).hexdigest()==m['wem_sha256'];u.mem_write(media,b);u.mem_write(voice,bytes(424));w(voice+0x14c,media);w(voice+0x150,len(b));u.mem_write(voice+0x128,b'\x01\x00')
 w(stack,end);w(stack+4,voice);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xb3f360,end,count=5000);assert u.reg_read(UC_X86_REG_EIP)==end
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,decoder);u.emu_start(0xb3f720,end,count=20000000)
 assert u.reg_read(UC_X86_REG_EIP)==end,(m['source_id'],hex(u.reg_read(UC_X86_REG_EIP)),u.reg_read(UC_X86_REG_EAX))
 assert u.reg_read(UC_X86_REG_EAX)==1,(m['source_id'],u.reg_read(UC_X86_REG_EAX),allocations)
 assert read(voice+0x70)==m['sample_rate'] and read(decoder+0x14)==m['frames']
 assert read(decoder+0x20)+read(decoder+0x1c)==len(b)
 assert read(decoder+0x100)==media+read(decoder+0x20)
 import wave
 wavpath=r/'assets'/m['wav'];assert hashlib.sha256(wavpath.read_bytes()).hexdigest()==m['wav_sha256']
 with wave.open(str(wavpath),'rb') as wav: reference=wav.readframes(m['frames'])
 output=bytearray();blocks=[]
 for index in range((m['frames']+511)//512+4):
  outbuf=vector+0x18000;u.mem_write(outbuf,bytes(48));u.mem_write(outbuf+0xc,struct.pack('<H',512))
  w(stack,end);w(stack+4,outbuf);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,decoder);u.emu_start(0xb3f4b0,end,count=20000000)
  assert u.reg_read(UC_X86_REG_EIP)==end
  frames=struct.unpack('<H',u.mem_read(outbuf+0xe,2))[0];status=read(outbuf+0x28);assert frames<=512 and status!=2
  if frames:output.extend(bytes(u.mem_read(read(outbuf),frames*m['channels']*2)))
  blocks.append(dict(frames=frames,status=status))
  if status==17:break
  assert frames>0,(m['source_id'],index,status)
 assert len(output)==len(reference),(m['source_id'],len(output),len(reference),blocks[-2:])
 values=struct.unpack('<'+'h'*(len(output)//2),output);expected=struct.unpack('<'+'h'*(len(reference)//2),reference)
 diff=max(abs(a-b) for a,b in zip(values,expected));nonzero=sum(x!=0 for x in values)
 assert diff<=1 and nonzero>0 and blocks[-1]['status']==17
 rows.append(dict(source_id=m['source_id'],wem_sha256=m['wem_sha256'],wav_sha256=m['wav_sha256'],frames=m['frames'],channels=m['channels'],decoded_sha256=hashlib.sha256(output).hexdigest(),max_difference_pcm16=diff,nonzero_samples=nonzero,block_count=len(blocks),last_blocks=blocks[-2:],final_status=blocks[-1]['status']))
 print('decoded',m['source_id'],'frames',m['frames'],'maxdiff',diff,flush=True)
 (r/'data/4.20/audio_vorbis_full_pcm_progress.json').write_text(json.dumps(rows,indent=2)+'\n')
proof=dict(passed=True,case_count=len(rows),native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,adapters=['Mapped allocator/output-buffer allocations; registry reset per media, resident voice supplied with WEM and loopcount1.'],limits=['No looping, seeking, streaming or mixer/output integration proven. PCM comparison records measured differences, not assumed bit identity.'])
(r/'data/4.20/audio_vorbis_full_pcm.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'complete native decoded streams')
