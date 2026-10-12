from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
container=vector+0xa000;entries=vector+0xb000;vtable=vector+0xc000;destroyfn=vector+0xd000
w(vtable+4,destroyfn)
def ret(value,pop):
 sp=u.reg_read(UC_X86_REG_ESP);target=read(sp);u.reg_write(UC_X86_REG_EAX,value);u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EIP,target)
def factory(uc,a,n,d):
 global counter
 counter+=1;value=0 if fail_create else vector+0x14000+counter*0x40
 if value:w(value,vtable)
 created.append(dict(count=read(u.reg_read(UC_X86_REG_ESP)+4),value=value));ret(value,4)
def register(uc,a,n,d):
 registered.append(u.reg_read(UC_X86_REG_ECX));ret(2 if fail_register else 1,4)
def destroy(uc,a,n,d):
 destroyed.append(u.reg_read(UC_X86_REG_ECX));ret(0,0)
for address,fn in [(0xb1d6f0,factory),(0xaf6320,register),(destroyfn,destroy)]:u.hook_add(unicorn.UC_HOOK_CODE,fn,begin=address,end=address)
rows=[]
for shared in [False,True]:
 for fail_create,fail_register in [(False,False),(True,False),(False,True)]:
  u.mem_write(container,b'\0'*0xa0);u.mem_write(entries,b'\0'*256);u.mem_write(container+0x91,bytes([128 if shared else 0]))
  w(container+0x6c,entries);w(container+0x74,32)
  counter=0;created=[];registered=[];destroyed=[];results=[]
  owners=[vector+0x200,vector+0x300,vector+0x200,vector+0x300]
  for owner in owners:
   call(0xb1d7d0,container,struct.pack('<II',7,owner));results.append(u.reg_read(UC_X86_REG_EAX))
  failed=fail_create or (fail_register and not shared)
  if failed:assert results==[0]*4
  elif shared:assert len(set(results))==1 and results[0]!=0 and len(created)==1
  else:assert results[0]==results[2] and results[1]==results[3] and results[0]!=results[1] and len(created)==2
  if shared:assert registered==[] and read(container+0x70)==0
  elif not failed:assert read(container+0x70)==2 and registered==owners[:2]
  if fail_register and not shared:assert len(destroyed)==4
  assert all(x['count']==7 for x in created)
  rows.append(dict(shared=shared,fail_create=fail_create,fail_register=fail_register,owners=owners,results=results,created=created,registered=registered,destroyed=destroyed))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0xb1d7d0',cases=rows,limits=['History factory, owner registration and history destructor adapted and recorded; scope branch, native sorted lookup/insertion and reuse execute unchanged.','Container91 bit80 selects shared history78; clear selects map6C keyed by owner pointer. Bank property-to-bit mapping remains open.','Preallocated owner table, ascending first insertions; table growth and owner destruction lifecycle not covered.'])
(r/'data/4.20/audio_native_history_scope.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps(dict(passed=True,cases=len(rows),calls=24)))
