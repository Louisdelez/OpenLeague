from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
voice=vector+0x10000;decoder=vector+0x12000;media=0x50000000
u.mem_map(media,0x1000000)
u.mem_map(0x60000000,0x1000000)
heap=0x60000000;allocations=[]
def hook(uc,a,size,user):
 global heap
 if a==0xada670:
  n=read(uc.reg_read(UC_X86_REG_ESP)+8);target=decoder if not allocations else heap;allocations.append(n);heap+=(n+15)&~15;assert heap<0x61000000;u.mem_write(target,bytes(n));finish(target)

u.hook_add(unicorn.UC_HOOK_CODE,hook)
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
 rows.append(dict(allocations=allocations.copy(),source_id=m['source_id'],wem_sha256=m['wem_sha256'],sample_rate=read(voice+0x70),format_word=read(voice+0x74),frames=read(decoder+0x14),data_offset=read(decoder+0x20),data_bytes=read(decoder+0x1c),loop_start=read(decoder+0x24),loop_end=read(decoder+0x28)))
proof=dict(passed=True,case_count=len(rows),native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,adapters=['Mapped allocator supplied all requested buffers; reset codebook registry per media; voice populated with actual WEM pointer/length and loopcount1.'],limits=['Native resident initialization returns1, including codebook setup. PCM packet decoding remains unverified.','Resident decoder route invoked directly; full bank-driven source-kind selection and audio output unproven.'])
(r/'data/4.20/audio_vorbis_real_initialization.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'actual WEM native initialization')
