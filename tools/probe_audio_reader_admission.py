from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
voice=vector+0x10000;out=vector+0x11000;evictions=[]
def hook(uc,a,size,user):
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a==0xada4c0:
  p=read(sp+8);w(p,100);w(p+4,usage);finish(0)
 elif a==0xaedf70:evictions.append((uc.reg_read(UC_X86_REG_ECX),read(sp+4)));finish(0,4)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
rows=[]
for usage,priority,present,flags in itertools.product([25,75],[5.,10.,15.],[False,True],[0,1,0x10,0x40]):
 u.mem_write(voice,bytes(0x140));w(0x14a7a74,voice if present else 0);u.mem_write(voice+0x134,struct.pack('<f',10.));u.mem_write(voice+0x12e,bytes([flags&1]));u.mem_write(voice+0x12f,bytes([flags&0x50]))
 u.mem_write(0x14a79d8,struct.pack('<f',.5));u.mem_write(0x14a7d3c,struct.pack('<f',1.));w(0x14a7a70,0);w(0x14a7a6c,0);u.mem_write(0x12100ec,struct.pack('<H',128));evictions.clear()
 call(0xaf43c0,0,struct.pack('<fI',priority,out))
 victim=usage>50 and present and flags==0 and priority>10
 admitted=usage<=50 or victim
 assert u.reg_read(UC_X86_REG_EAX)==(1 if admitted else 2),(usage,priority,present,flags,u.reg_read(UC_X86_REG_EAX),evictions)
 assert read(out)==(0x21 if admitted else 0x22)
 assert evictions==([(voice,3)] if victim else [])
 rows.append(dict(usage=usage,priority=priority,present=present,flags=flags,admitted=admitted,reason=read(out),evicted=bool(evictions)))
proof=dict(passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(rows),cases=rows,findings=['Actual AF43C0/AF4440 admits below supplied pool pressure; above threshold eligible strictly lower priority voice is sent eviction reason3.','Excluded flags12Ebit1 and12Fbits10/40 prevent victim selection. Refusal reason22 versus admission21 observed.'],adapters=['Pool statistics ADA4C0 supplied100total/25or75used; AEDF70 eviction endpoint captured.','Second pool threshold1 disables its pressure test; voice capacity128 unexceeded; at most one voice.'],limits=['Eviction side effects, multi-voice selection, count-limit AF38F0 and real reader output remain open.'])
(r/'data/4.20/audio_reader_admission.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'reader admission cases')


