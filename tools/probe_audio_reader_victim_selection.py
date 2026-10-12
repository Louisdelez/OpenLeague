from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
voices=[vector+0x10000+i*0x200 for i in range(3)];out=vector+0x11000;stops=[]
def hook(uc,a,size,user):
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a==0xada4c0:
  p=read(sp+8);w(p,100);w(p+4,75);finish(0)
 elif a==0xaef9e0:
  p=read(sp+4);stops.append(dict(voice=uc.reg_read(UC_X86_REG_ECX),parameters=[read(p),read(p+4)],immediate=read(sp+8)));finish(0,8)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
rows=[]
for priorities,excluded in itertools.product(sorted(set(itertools.permutations([10.,10.,20.]))),[-1,0,1,2]):
 for i,v in enumerate(voices):
  u.mem_write(v,bytes(0x140));w(v+12,voices[i+1] if i<2 else 0);u.mem_write(v+0x134,struct.pack('<f',priorities[i]));u.mem_write(v+0x12f,bytes([0x10 if excluded==i else 0]))
 w(0x14a7a74,voices[0]);u.mem_write(0x14a79d8,struct.pack('<f',.5));u.mem_write(0x14a7d3c,struct.pack('<f',1.));w(0x14a7a70,0);w(0x14a7a6c,0);u.mem_write(0x12100ec,struct.pack('<H',128));stops.clear()
 remaining=[i for i in range(3) if i!=excluded]
 expected=[]
 for _ in range(len(remaining)):
  minimum=min(priorities[i] for i in remaining);index=max(i for i in remaining if priorities[i]==minimum);remaining.remove(index);expected.append(index)
 for index in expected:
  call(0xaf43c0,0,struct.pack('<fI',30.,out));assert u.reg_read(UC_X86_REG_EAX)==1
  assert stops[-1]==dict(voice=voices[index],parameters=[0,4],immediate=1)
  assert bytes(u.mem_read(voices[index]+0x12e,1))[0]==7
 call(0xaf43c0,0,struct.pack('<fI',30.,out));assert u.reg_read(UC_X86_REG_EAX)==2 and len(stops)==len(expected)
 rows.append(dict(priorities=priorities,excluded=excluded,eviction_order=expected,stops=stops.copy()))
proof=dict(passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(rows),cases=rows,findings=['Native AF4440 chooses lowest eligible priority and last encountered on ties.','Actual AEDF70 sets stop flag and reason3 (byte12E=7); subsequent admission skips stopped voices and eventually refuses when none eligible.'],adapters=['Pool usage supplied. Stop execution AEF9E0 captured with parameters0/4 and immediate1; actual downstream stopping not executed.'],limits=['Count-limit policy, downstream voice stop and audible playback remain open.'])
(r/'data/4.20/audio_reader_victim_selection.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'multi-voice eviction sequences')

