from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague');source=(root/'tools/qualify_announcer_actor_registration.py').read_text().split('\ncases=[]')[0]
source=source.replace('    elif address==0x62a1f5:uc.emu_stop()','')
exec(compile(source,str(root/'tools/qualify_announcer_actor_registration.py'),'exec'))
locks=[]
def boundaries(uc,address,size,user):
 global cursor
 if address in [0x9941b0,0x994210]:
  locks.append({'op':'enter' if address==0x9941b0 else 'leave','object':u.reg_read(UC_X86_REG_ECX)});finish()
 elif address==0x5cc6b0:
  count=u.reg_read(UC_X86_REG_ECX)*4;pointer=cursor;cursor+=(count+31)&~15;u.mem_write(pointer,bytes([poison])*count);allocations.append({'bytes':count,'pointer':pointer,'allocator':'owner_pointer_array'});finish(eax=pointer)
u.hook_add(unicorn.UC_HOOK_CODE,boundaries)
secondary=0x2110a10;owner_table=0x2d5f470;metadata=heap+0x5500;owner_storage=heap+0x5600
write32(actor+8,77);write32(actor+0x17c,metadata);write32(metadata+0x30,owner_storage);write32(0x2d5f448,0xffffffff)
def snapshot(manager,vector):
 head=read32(manager+4);begin=read32(manager+12);finish_pointer=read32(manager+16)
 words=[[manager+i,read32(manager+i)] for i in range(4,48 if vector else 36,4)]+[[head+i,read32(head+i)] for i in range(0,16,4)]+[[i,read32(i)] for i in range(begin,finish_pointer,4)]
 node=read32(head);seen=set()
 while node!=head:
  assert node not in seen;seen.add(node);words.extend([[node+i,read32(node+i)] for i in range(0,16,4)]);node=read32(node)
 if vector:words.extend([[i,read32(i)] for i in range(read32(manager+36),read32(manager+40),4)])
 return words
cases=[]
for existed,first,second,poison,secondary_prior,owner_prior,owner_id in itertools.product([False,True],[0,0xffffffff],[42,0x80000000],[0,165],[None,0,0x3000aaaa],[None,0,0x3000bbbb],[42,0xffffffff]):
 cursor=arena;write32(0x14bef40,0);write32(0x2d789c0,0);u.mem_write(0x2d78974,b'\0');u.mem_write(0x2d78969,b'\1');write32(owner_storage,owner_id)
 for table,prior,key in [(secondary,secondary_prior,77),(owner_table,owner_prior,42)]:
  opaque=heap+0x9000;u.mem_write(opaque,bytes([poison]));call(0x664e50,table,[opaque,0])
  for offset in [36,40,44]:write32(table+offset,0)
  if prior is not None:
   pair=heap+0xa000;result=heap+0xa100;write32(pair,key);write32(pair+4,prior);call(0x65e750,table,[result,pair])
 if existed:
  call(0x661410,0,[]);primary=read32(0x2d789c0);pair=heap+0xa000;result=heap+0xa100;write32(pair,second);write32(pair+4,0x11223344);call(0x65e6f0,primary,[result,pair])
 steps=[]
 for invocation in range(2):
  allocations.clear();freed.clear();locks.clear();diagnostics.clear();calls.clear();ids=[first,second]
  sp=stack+0xe000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor);u.emu_start(0x62a140,end,count=500000)
  assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==sp+4 and calls==ids
  primary=read32(0x2d789c0);assert call(0x62b380,0,[second])==actor
  steps.append({'primary_manager':primary,'getter_calls':list(calls),'allocations':list(allocations),'freed':list(freed),'locks':list(locks),'diagnostics':list(diagnostics),'primary_words':snapshot(primary,False),'secondary_words':snapshot(secondary,True),'owner_words':snapshot(owner_table,True)})
 cases.append({'existed':existed,'first_id':first,'second_id':second,'poison':poison,'secondary_prior':secondary_prior,'owner_prior':owner_prior,'owner_id':owner_id,'actor':actor,'steps':steps})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual complete62A140 and actual secondary/owner lookup, insertion, growth and registration execute together with original primary registry.288 lifetimes576 registrations with repeated actor admission, existing-null/non-null values, invalid ID diagnostics, invalid owner skip and owner repeat failure diagnostics. No helper-result adapters.','Virtual ID getter, malloc/free/atexit, engine owner-array allocator, lock primitives and returning diagnostics supplied; physical actor metadata fields are explicit fixture values. Live world ownership, throwing boundaries, concurrency and audio playback remain open.']}
(root/'data/4.20/audio_announcer_actor_registry_composition_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_lifetimes':len(cases),'native_registrations':sum(len(c['steps']) for c in cases),'passed':True}))
