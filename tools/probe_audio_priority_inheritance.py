from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
node=vector+0x10000;parent=vector+0x11000;props=vector+0x12000;parentprops=vector+0x13000;output=vector+0x14000;distance=vector+0x15000
rows=[]
for has_parent,override,offset_enabled,has_props in itertools.product([False,True],repeat=4):
 for a in [node,parent,props,parentprops,output,distance]:u.mem_write(a,bytes(128))
 w(node,0xff1cd8);w(parent,0xff1cd8);w(node+0x20,parent if has_parent else 0)
 u.mem_write(node+0x2e,bytes([(0x40 if override else 0)|(0x20 if offset_enabled else 0)]));u.mem_write(parent+0x2e,b'\x20')
 for obj,p,basevalue,offsetvalue in [(node,props,25.,-5.),(parent,parentprops,75.,-15.)]:
  if has_props:w(obj+0x28,p)
  u.mem_write(p,b'\x02\x05\x06');u.mem_write(p+4,struct.pack('<ff',basevalue,offsetvalue))
 selected_parent=has_parent and not override
 expected_base=(75. if selected_parent else 25.) if has_props else struct.unpack('<f',u.mem_read(0x121011c,4))[0]
 enabled=selected_parent or offset_enabled
 expected_offset=(( -15. if selected_parent else -5.) if has_props else struct.unpack('<f',u.mem_read(0x1210120,4))[0]) if enabled else 0.
 call(0xaf4560,0,struct.pack('<IIII',output,node,0,distance))
 assert u.reg_read(UC_X86_REG_EAX)==output
 assert struct.unpack('<f',u.mem_read(output,4))[0]==expected_base
 assert struct.unpack('<ff',u.mem_read(output+8,8))==(expected_base,expected_offset)
 assert read(distance)==0
 rows.append(dict(parent=has_parent,override=override,offset_enabled=offset_enabled,properties=has_props,base=expected_base,offset=expected_offset))
proof=dict(passed=True,case_count=len(rows),native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['Actual AF4560/AFF450 inherits parent priority unless2Ebit40 overrides. Property5 gives base, property6 offset enabled by2Ebit20, otherwise0.','Actual AF19E0 with absent attenuation returns no distance adjustment; output priority stays base and preserves offset separately.'],adapters=['Supplied parent chain/property bundles; no native calls intercepted. No RTPC bits or attenuation object.'],limits=['RTPC priority and distance attenuation remain open; no reader or audio output proof.'])
(r/'data/4.20/audio_priority_inheritance.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'native priority inheritance cases')
