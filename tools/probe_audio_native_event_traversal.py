from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
message=vector+0x10000;eventobj=vector+0x11000;owner=vector+0x12000;manager=vector+0x13000;nodes=vector+0x14000;pool=vector+0x16000
calls=[];cursor=pool

def ret(value,pop):
 sp=u.reg_read(UC_X86_REG_ESP);addr=read(sp);u.reg_write(UC_X86_REG_EAX,value);u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EIP,addr)
def hook(uc,a,n,d):
 global cursor
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xb099d0:ret(owner if has_owner else 0,4)
 elif a==0xada670:
  assert read(sp+8)==64;ptr=cursor;cursor+=64;u.mem_write(ptr,bytes(64));ret(ptr,0)
 elif a==0xb05f00:
  pending=read(sp+4);calls.append(dict(action=read(read(pending+4)+8),owner=read(pending+0x14),playing_id=read(pending+0x28)));ret(0,4)
for a in [0xb099d0,0xada670,0xb05f00]:u.hook_add(unicorn.UC_HOOK_CODE,hook,begin=a,end=a)
rows=[];contract=json.loads((r/'data/4.20/ambient_audio_selection.json').read_text())
for event in contract['events']:
 for has_owner in [False,True]:
  for reverse in [False,True]:
   ids=[a['id'] for a in event['actions']];ids=ids[::-1] if reverse else ids
   for ptr,size in [(message,64),(eventobj,64),(owner,128),(nodes,512)]:u.mem_write(ptr,bytes(size))
   w(message+0x28,eventobj);w(message+0xc,123);w(eventobj+0x10,nodes);w(owner+0x60,2)
   for i,ident in enumerate(ids):
    ptr=nodes+i*64;w(ptr+8,ident);w(ptr+0x10,nodes+(i+1)*64 if i+1<len(ids) else 0);u.mem_write(ptr+0x20,struct.pack('<H',0x403))
   calls.clear();cursor=pool;bp=stack-0x100;w(bp-0x14,manager);u.reg_write(UC_X86_REG_EBP,bp);u.reg_write(UC_X86_REG_ESP,bp-0x200);u.reg_write(UC_X86_REG_EDI,message)
   u.emu_start(0xb06d25,0xb06e23,count=2000);assert u.reg_read(UC_X86_REG_EIP)==0xb06e23
   assert [x['action'] for x in calls]==(ids if has_owner else [])
   assert all(x['playing_id']==123 for x in calls)
   rows.append(dict(event=event['id'],owner_present=has_owner,input_action_links=ids,calls=list(calls)))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),region=['0xb06d25','0xb06e23'],cases=rows,limits=['Native event message action traversal and pending construction executed; object lookup, allocator and scheduling call adapted.','Executes event10 head and action10 next order, not numeric ID sorting; Play0403 skips scheduling when owner lookup fails.','Linked-list fixtures supplied in both orders. Bank loader insertion order still unqualified; this does not prove XML order equals runtime order. No physical playback.'])
(r/'data/4.20/audio_native_event_traversal.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps(dict(passed=True,cases=len(rows))))
