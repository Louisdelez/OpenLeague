from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
record=vector+0xc000;node=vector+0xd000;clip=vector+0xd100;config=vector+0xd200
rows=[]
for present,flags,loop,speed,age,lead in itertools.product([False,True],[0,8],[False,True],[0.,.5,1.,2.],[0.,7.,8.,9.],[0.,.5,1.,2.,4.]):
 u.mem_write(record,b'\0'*0x30);u.mem_write(node,b'\0'*0x80);u.mem_write(clip,b'\0'*0x30);u.mem_write(config,b'\0'*0x20)
 w(record+4,node if present else 0);w(record+0xc,flags);w(node,0x10c8918);w(node+0x2c,clip);w(node+0x20,config);w(config+4,2 if loop else 0);w(clip+8,8)
 for a,v in [(clip+0xc,1.),(node+0xc,age),(node+0x10,speed)]:u.mem_write(a,struct.pack('<f',v))
 before=bytes(u.mem_read(node,0x80));call(0x88d3b0,record,struct.pack('<f',lead));actual=bool(u.reg_read(UC_X86_REG_EAX)&255)
 expected=True if not present or flags&8 else False if loop else lead*speed>=8.-age
 assert actual==expected,(present,flags,loop,speed,age,lead,actual,expected)
 assert bytes(u.mem_read(node,0x80))==before
 rows.append(dict(present=present,flags=flags,loop=loop,speed=speed,age=age,lead=lead,ready=actual))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x88d3b0',actual_virtual_calls=['0x8894b0','0x889080','0x705f40'],cases=rows,findings=['Missing node or record flag8 returns true; otherwise looping node returns false.','Nonlooping node compares lead*speed >= f32(duration-age); equality is ready. Speed zero can still be ready at or past end.','Predicate does not change node state; it has no wall-clock read.'],limits=['Finite dyadic profiles only; no NaN or infinity.','Predicate only: queued transition mutation, blends and owner caller remain unqualified.'])
(r/'data/4.20/animation_transition_readiness_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print('PASS native transition readiness',len(rows),'cases')
