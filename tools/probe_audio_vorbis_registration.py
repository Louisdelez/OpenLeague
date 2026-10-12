from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
voice=vector+0x10000;source=vector+0x11000;decoder=vector+0x12000;registry=vector+0x14000
allocs=[]
def hook(uc,a,size,user):
 if a==0xada670:
  n=read(uc.reg_read(UC_X86_REG_ESP)+8);allocs.append(n);assert n in [260,308];u.mem_write(decoder,bytes(n));finish(decoder)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
w(0x14a7ac8,registry);w(0x14a7acc,0);w(0x14a7ad0,4);u.mem_write(registry,bytes(48))
call(0xaeaed0,0,struct.pack('<IIII',0,4,0xb3fca0,0xb3f360));assert u.reg_read(UC_X86_REG_EAX)==1
assert read(registry)==0x40001 and read(registry+4)==0xb3fca0 and read(registry+8)==0xb3f360
call(0xaeaed0,0,struct.pack('<IIII',0,4,0xb3fca0,0xb3f360));assert u.reg_read(UC_X86_REG_EAX)==2 and read(0x14a7acc)==1
rows=[]
for kind in [1,3]:
 u.mem_write(voice,bytes(424));u.mem_write(source,bytes(32));w(voice+0x64,source);w(source+0x10,kind<<2);w(source+0x18,0x40001);allocs.clear()
 w(stack,end);w(stack+4,voice);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xb27d40,end,count=5000);assert u.reg_read(UC_X86_REG_EIP)==end
 assert u.reg_read(UC_X86_REG_EAX)==decoder and read(decoder+0xc)==voice
 assert allocs==[308 if kind==1 else 260]
 assert read(decoder)==(0xff37a4 if kind==1 else 0xff3748)
 table=read(decoder);rows.append(dict(source_kind=kind,allocation_sizes=allocs.copy(),vtable=table,initialization=read(table+0x24)))
proof=dict(passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(rows),registration=dict(caller='0x7062a0',function='0xaeaed0/0xb09520',plugin_id=0x40001,stream_callback='0xb3fca0',resident_callback='0xb3f360',duplicate_result=2),cases=rows,limits=['Registry capacity preallocated; allocator supplied buffers. Actual registration, lookup and constructors execute.','Real media parsing, decoder initialization and playback remain open.'])
(r/'data/4.20/audio_vorbis_registration.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS native Vorbis registration, duplicate rejection and two constructors')
