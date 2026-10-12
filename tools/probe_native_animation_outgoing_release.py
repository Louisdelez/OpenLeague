from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
blend=vector+0xc000;record=vector+0xc100;node=vector+0xc200;controller=vector+0xc300;vtable=vector+0xc400;shared=vector+0xc500;boundary=vector+0xc600
calls=[]
def capture(uc,a,size,user):
 if a==boundary:
  calls.append(dict(receiver=u.reg_read(UC_X86_REG_ECX),node=read(u.reg_read(UC_X86_REG_ESP)+4),node_event=read(node+0x30),node_shared=read(node+0x34),record_node=read(record+4)))
  finish(0,4)
u.hook_add(unicorn.UC_HOOK_CODE,capture)
rows=[]
for present,has_node,refcount in itertools.product([False,True],[False,True],[0,2,3]):
 for a in [blend,record,node,controller,vtable,shared]:u.mem_write(a,b'\0'*0x80)
 w(blend+0x10,record if present else 0);w(blend+0x14,0x1234);w(blend+0x1c,0x1234);w(blend+0x20,0x1234);w(blend+0xc,controller);w(controller,vtable);w(vtable+8,boundary)
 w(record+4,node if has_node else 0)
 for offset in [8,0xc,0x10,0x14]:w(record+offset,0x1234)
 w(node,0x10c8918);w(node+0x30,0x5678);w(node+0x34,shared if refcount else 0);w(shared+4,refcount)
 calls.clear();call(0x890ea0,blend)
 assert all(read(blend+offset)==0 for offset in [0x10,0x14,0x1c,0x20])
 if present:
  assert read(record+8)==0xffffffff and all(read(record+o)==0 for o in [4,0xc,0x10,0x14])
 if present and has_node:
  assert len(calls)==1 and calls[0]==dict(receiver=controller,node=node,node_event=0,node_shared=0,record_node=node)
  assert read(shared+4)==(refcount-1 if refcount else 0)
 else:assert not calls
 rows.append(dict(present=present,node=has_node,initial_refcount=refcount,final_refcount=read(shared+4),calls=list(calls)))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x890ea0',actual_node_release='0x8892a0',cases=rows,findings=['Outgoing record fields reset, native node event/shared pointers cleared, shared strong count decremented when retained elsewhere.','Controller release receives outgoing node after its native event detach and before record node pointer is cleared.','Blend references and timestamps cleared even with absent outgoing record.'],limits=['Controller virtual8 captured at explicit synthetic boundary; ownership/pool behavior not qualified.','Shared count1 destructor branch excluded. No full outgoing layer update here.'])
(r/'data/4.20/animation_outgoing_release_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS outgoing release',len(rows),'cases')
