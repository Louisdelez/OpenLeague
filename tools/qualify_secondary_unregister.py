from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague');source=(root/'tools/qualify_announcer_secondary_owner_registries.py').read_text().split('\ncases=[]')[0]
exec(compile(source,str(root/'tools/qualify_announcer_secondary_owner_registries.py'),'exec'))
def memory_move(uc,address,size,user):
 if address==0xc97610:
  sp=u.reg_read(UC_X86_REG_ESP);destination,source,count=[read32(sp+i) for i in [4,8,12]]
  if count:u.mem_write(destination,bytes(u.mem_read(source,count)))
  finish(eax=destination)
u.hook_add(unicorn.UC_HOOK_CODE,memory_move)
def snapshot(manager):
 head=read32(manager+4);begin=read32(manager+12);bucket_end=read32(manager+16)
 words=[[manager+i,read32(manager+i)] for i in range(4,48,4)]+[[head+i,read32(head+i)] for i in range(0,16,4)]+[[i,read32(i)] for i in range(begin,bucket_end,4)]
 node=read32(head);seen=set()
 while node!=head:
  assert node not in seen;seen.add(node);words.extend([[node+i,read32(node+i)] for i in range(0,16,4)]);node=read32(node)
 words.extend([[i,read32(i)] for i in range(read32(manager+36),read32(manager+40),4)])
 return words
patterns={'unique':[(0,0x30004000),(8,0x30004200),(0xffffffff,0x30004400)],'shared_actor':[(0,0x30004000),(8,0x30004000),(0xffffffff,0x30004000)],'null_repeat':[(0,0),(0,0),(0,0),(8,0x30004000)],'growth':[(i*8,0x30004000+i*0x200) for i in range(48)]}
cases=[]
for kind,poison,pattern in itertools.product(['secondary','owner'],[0,165],patterns):
 cursor=arena;write32(0x14bef40,0);manager=0x2110a10 if kind=='secondary' else 0x2d5f470;registration=0x64c270 if kind=='secondary' else 0x6b59f0;unregister=0x64c330 if kind=='secondary' else 0x6b5ab0
 opaque=heap+0x9000;u.mem_write(opaque,bytes([poison]));call(0x664e50,manager,[opaque,0])
 for offset in [36,40,44]:write32(manager+offset,0)
 seed=patterns[pattern]
 for key,actor in seed:call(registration,0,[actor,key])
 initial=snapshot(manager);steps=[]
 attempts=[(0x3000eeee,0),(seed[0][1],999),(0,999)]
 if pattern=='growth':attempts += [(seed[i][1],seed[i][0]) for i in [0,24,47]+[i for i in range(48) if i not in [0,24,47]]]
 else:attempts += [(seed[0][1],seed[-1][0])]+[(actor,key) for key,actor in seed]+[(actor,key) for key,actor in seed]
 for actor,key in attempts:
  freed.clear();allocations.clear();locks.clear();diagnostics.clear();result=call(unregister,0,[actor,key]);assert not allocations
  assert len(diagnostics)==int(actor==0);assert len(locks)==2*int(result!=0xffffffff)
  steps.append({'actor':actor,'key':key,'result':result,'freed':list(freed),'locks':list(locks),'diagnostics':list(diagnostics),'words':snapshot(manager)})
 cases.append({'kind':kind,'poison':poison,'pattern':pattern,'manager':manager,'seed':seed,'initial_words':initial,'steps':steps})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual64C330/6B5AB0 unregister, identity lookup,64F3E0/6B6400 node deletion and sorted bucket/list mutations execute.16 lifetimes cover grown48-entry tables, null repeated entries, same actor under multiple keys, first/middle/last vector erasure, missing actor/key and mismatched supplied actor/key.','Malloc/free, owner array allocator, locks, returning diagnostics and memmove primitive supplied. Native callers own actor/key consistency; helper checks independent key-node and actor-vector presence. Live world teardown, concurrent mutation and exceptions remain open.']}
(root/'data/4.20/audio_announcer_secondary_unregister_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_lifetimes':len(cases),'native_unregister_calls':sum(len(c['steps']) for c in cases),'passed':True}))
