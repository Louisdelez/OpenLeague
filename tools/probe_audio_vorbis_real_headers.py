from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
voice=vector+0x10000;decoder=vector+0x12000;media=0x50000000
u.mem_map(media,0x1000000)
def hook(uc,a,size,user):
 if a==0xada670:
  n=read(uc.reg_read(UC_X86_REG_ESP)+8);assert n==260;u.mem_write(decoder,bytes(n));finish(decoder)
 elif a==0xb3f3c0:uc.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,hook)
rows=[]
manifest=json.loads((r/'data/4.20/ambient_audio_manifest.json').read_text())
for m in manifest['media']:
 b=(r/'assets'/m['wem']).read_bytes();assert hashlib.sha256(b).hexdigest()==m['wem_sha256'];u.mem_write(media,b);u.mem_write(voice,bytes(424));w(voice+0x14c,media);w(voice+0x150,len(b));u.mem_write(voice+0x128,b'\x01\x00')
 w(stack,end);w(stack+4,voice);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xb3f360,end,count=5000);assert u.reg_read(UC_X86_REG_EIP)==end
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,decoder);u.emu_start(0xb3f720,end,count=20000)
 assert u.reg_read(UC_X86_REG_EIP)==0xb3f3c0,(m['source_id'],hex(u.reg_read(UC_X86_REG_EIP)),u.reg_read(UC_X86_REG_EAX))
 assert read(voice+0x70)==m['sample_rate'] and read(decoder+0x14)==m['frames']
 assert read(decoder+0x20)+read(decoder+0x1c)==len(b)
 assert read(decoder+0x100)==media+read(decoder+0x20)
 rows.append(dict(source_id=m['source_id'],wem_sha256=m['wem_sha256'],sample_rate=read(voice+0x70),format_word=read(voice+0x74),frames=read(decoder+0x14),data_offset=read(decoder+0x20),data_bytes=read(decoder+0x1c),loop_start=read(decoder+0x24),loop_end=read(decoder+0x28)))
proof=dict(passed=True,case_count=len(rows),native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,adapters=['260-byte constructor allocation supplied; voice populated with actual WEM pointer/length and loopcount1.'],limits=['B3F720/B35D90 native header initialization only; stops B3F3C0 before codebook setup and decoding.','Resident decoder route invoked directly; full bank-driven source-kind selection and audio output unproven.'])
(r/'data/4.20/audio_vorbis_real_headers.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'actual WEM native headers')
