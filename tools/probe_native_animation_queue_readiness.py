from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
record=vector+0xc000;node=vector+0xd000;clip=vector+0xd100;config=vector+0xd200
layer=vector+0xe000;head=vector+0xe100;entry=vector+0xe200;blend=vector+0xe300
rows=[]
for loop,speed,age,lead,blend_slot in itertools.product([False,True],[0.,.5,1.,2.],[0.,7.,8.,9.],[0.,.5,1.,2.,4.],[0,0x58,0x5c]):
 for address,length in [(layer,0x100),(head,0x20),(entry,0x30),(blend,0x20),(node,0x80),(clip,0x30),(config,0x20)]:u.mem_write(address,b'\0'*length)
 w(layer+0x14,1);w(layer+0x10,head);w(head,entry);w(layer+0x34,node);w(layer+0x3c,4);w(entry+0x14,0x40)
 if blend_slot:w(layer+blend_slot,blend);w(blend+4,1)
 w(node,0x10c8918);w(node+0x2c,clip);w(node+0x20,config);w(config+4,2 if loop else 0);w(clip+8,8)
 for address,value in [(clip+0xc,1.),(node+0xc,age),(node+0x10,speed),(entry+0x18,lead)]:u.mem_write(address,struct.pack('<f',value))
 expected=0x40 | (2 if not loop and lead*speed>=8.-age else 0)
 before=bytes(u.mem_read(node,0x80))
 states=[]
 for frame in range(3):
  call(0x891b40,layer)
  assert u.reg_read(UC_X86_REG_EAX)&255==0
  assert read(entry+0x14)==expected
  assert read(layer+0x14)==1 and read(head)==entry and read(layer+0x34)==node
  assert bytes(u.mem_read(node,0x80))==before
  states.append(read(entry+0x14))
 rows.append(dict(loop=loop,speed=speed,age=age,lead=lead,blend_slot=hex(blend_slot),queued_flags=states))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x891b40',cases=rows,findings=['Queued entry flag2 can be set even while active flag4 or a blend prevents dequeue.','Readiness marking occurs before blend/active guards; repeated evaluation is idempotent in these profiles.','Without advancing node time, qualifying entries can still change flags on first evaluation; freezing all state evaluation would differ from native behavior.'],limits=['Three repeated evaluations with unchanged node time model evaluation without time advance; not full native pause dispatch.','Dequeue, allocation/free, callbacks, blend weights and replacement branches are not exercised.'])
(r/'data/4.20/animation_queue_readiness_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print('PASS native queued readiness',len(rows),'profiles',len(rows)*3,'evaluations')
