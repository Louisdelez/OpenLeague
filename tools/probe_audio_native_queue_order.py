from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
queue=vector+0x10000;nodes=vector+0x11000;payload=vector+0x12000
rows=[]
for keys in [[5,1,5,3,1],[0xffffffff,0,1,0xfffffffe],[7,7,7,7],[9,8,7,6,5],[0,1,2,3]]:
 u.mem_write(queue,b'\0'*32);u.mem_write(nodes,b'\0'*256)
 for i in range(len(keys)):w(nodes+i*12,nodes+(i+1)*12 if i+1<len(keys) else 0)
 w(queue+8,nodes);states=[]
 for index,key in enumerate(keys):
  w(payload,index+1);call(0xb06140,queue,struct.pack('<II',key,payload));assert u.reg_read(UC_X86_REG_EAX)==1
  cursor=read(queue);actual=[]
  while cursor:actual.append([read(cursor+4),read(cursor+8)-1]);cursor=read(cursor);assert len(actual)<=len(keys)
  expected=sorted([[k,i] for i,k in enumerate(keys[:index+1])],key=lambda x:x[0]);assert actual==expected
  assert read(queue+0x14)==index+1;states.append(actual)
 rows.append(dict(keys=keys,states=states))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0xb06140',cases=rows,limits=['Native insertion uses unsigned ascending deadline and stable order for equal deadlines, including wrap-shaped keys.','Preallocated node pool; allocation failure, clock production and callback drain remain separate qualifications.'])
(r/'data/4.20/audio_native_queue_order.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps(dict(passed=True,sequences=len(rows))))
