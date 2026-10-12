from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
voice=vector+0x10000;source=vector+0x11000;rows=[]
for table,present,preserve in itertools.product([0xff0cdc,0xfeff88,0xff27d4],[False,True],[False,True]):
 u.mem_write(voice,bytes(0x240));u.mem_write(source,bytes(16));w(voice,table);w(source+12,2)
 u.mem_write(voice+0x12a,b'\x08');u.mem_write(voice+0x12e,bytes([0x80 if preserve else 0]));w(voice+0xd8,0x3f800000);w(voice+0x7c,99);w(voice+0x1fc,77);w(voice+0x1a8,source if present else 0)
 for repeat in range(2):
  call(0xaedf70,voice,struct.pack('<I',3))
  assert bytes(u.mem_read(voice+0x12e,1))[0]==(0x87 if preserve else 7)
  assert bytes(u.mem_read(voice+0x12d,1))[0]==0x34
  assert read(voice+0xd8)==(0x3f800000 if preserve else 0) and read(voice+0x7c)==(99 if preserve else 0)
  if table==0xff27d4:
   assert read(voice+0x1a8)==0 and read(voice+0x1fc)==0 and bytes(u.mem_read(voice+0x204,1))[0]&4
   assert read(source+12)==(1 if present else 2)
  else:assert read(source+12)==2
 rows.append(dict(vtable=hex(table),source_present=present,preserve=preserve,source_refs=read(source+12),flags=bytes(u.mem_read(voice+0x12d,2)).hex()))
proof=dict(passed=True,case_count=len(rows),native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['Actual AEDF70/AEF9E0/AEEE60 calls baseAEFB30 or derivedADC7D0/B2A9C0. No native functions intercepted.','FF27D4 clears1FC/source1A8, releases source exactly once even on repeated stop, sets204bit4.','12Ebit80 preserves D8/7C while stop flags still update; otherwise both clear.'],adapters=['Supplied active12Abit8; null transition handles/owner; source refcount2 avoids destruction.'],limits=['ADC7D0 third-argument1 branch, transition-backed stop, source destruction and physical audio remain open.'])
(r/'data/4.20/audio_derived_stop.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'derived stop cases with repeated execution')
