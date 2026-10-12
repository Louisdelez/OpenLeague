from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
voices=[vector+0x10000+i*0x200 for i in range(3)];out=vector+0x11000;stops=[]
def hook(uc,a,size,user):
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a==0xada4c0:
  p=read(sp+8);w(p,100);w(p+4,75);finish(0)

u.hook_add(unicorn.UC_HOOK_CODE,hook)
rows=[]
for priorities,excluded in itertools.product(sorted(set(itertools.permutations([10.,10.,20.]))),[-1,0,1,2]):
 for i,v in enumerate(voices):
  u.mem_write(v,bytes(0x200));w(v,0xff0cdc);u.mem_write(v+0x12a,b"\x08");w(v+0xd8,0x3f800000);w(v+0x7c,99);w(v+12,voices[i+1] if i<2 else 0);u.mem_write(v+0x134,struct.pack('<f',priorities[i]));u.mem_write(v+0x12f,bytes([0x10 if excluded==i else 0]))
 w(0x14a7a74,voices[0]);u.mem_write(0x14a79d8,struct.pack('<f',.5));u.mem_write(0x14a7d3c,struct.pack('<f',1.));w(0x14a7a70,0);w(0x14a7a6c,0);u.mem_write(0x12100ec,struct.pack('<H',128));stops.clear()
 remaining=[i for i in range(3) if i!=excluded]
 expected=[]
 for _ in range(len(remaining)):
  minimum=min(priorities[i] for i in remaining);index=max(i for i in remaining if priorities[i]==minimum);remaining.remove(index);expected.append(index)
 for index in expected:
  call(0xaf43c0,0,struct.pack('<fI',30.,out));assert u.reg_read(UC_X86_REG_EAX)==1
  stops.append(index)
  assert read(voices[index]+0xd8)==0 and read(voices[index]+0x7c)==0
  assert bytes(u.mem_read(voices[index]+0x12d,1))[0]==0x34
  assert bytes(u.mem_read(voices[index]+0x12e,1))[0]==7
 call(0xaf43c0,0,struct.pack('<fI',30.,out));assert u.reg_read(UC_X86_REG_EAX)==2 and len(stops)==len(expected)
 rows.append(dict(priorities=priorities,excluded=excluded,eviction_order=expected,stops=stops.copy()))
proof=dict(passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(rows),cases=rows,findings=['Actual AF43C0/AF4440/AEDF70/AEF9E0/AEEE60/AEFB30 execute whole stop path for base vtableFF0CDC with12A bit8.','Stopped voices have12E=7,12D=34, D8/7C zero and are skipped by later admissions.'],adapters=['Only pool statistics ADA4C0 supplied; no stop function intercepted.','Base voice vtable and active12A bit8 supplied, transition handles50/54 and owner190 absent.'],limits=['Derived voice overrides, transition-backed stopping and physical playback remain open; this is base-state stop execution.'])
(r/'data/4.20/audio_reader_native_stop.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'native base-voice stop sequences')
