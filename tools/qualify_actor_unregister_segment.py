from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague');source=(root/'tools/qualify_actor_registry_composition.py').read_text().split('\ncases=[]')[0]
exec(compile(source,str(root/'tools/qualify_actor_registry_composition.py'),'exec'))
def destructor_boundaries(uc,address,size,user):
 if address==0x62997c:uc.emu_stop()
 elif address==0xc97610:
  sp=u.reg_read(UC_X86_REG_ESP);destination,source,count=[read32(sp+i) for i in [4,8,12]]
  if count:u.mem_write(destination,bytes(u.mem_read(source,count)))
  finish(eax=destination)
u.hook_add(unicorn.UC_HOOK_CODE,destructor_boundaries)
cases=[]
for first,second,poison,secondary_prior,owner_id in itertools.product([0,0xffffffff],[42,0x80000000],[0,165],[None,0,0x3000aaaa],[42,0xffffffff]):
 cursor=arena;write32(0x14bef40,0);write32(0x2d789c0,0);u.mem_write(0x2d78974,b'\0');u.mem_write(0x2d78969,b'\1');write32(owner_storage,owner_id);write32(actor+0xfc,second)
 for table,prior,key in [(secondary,secondary_prior,77),(owner_table,None,42)]:
  opaque=heap+0x9000;u.mem_write(opaque,bytes([poison]));call(0x664e50,table,[opaque,0])
  for offset in [36,40,44]:write32(table+offset,0)
  if prior is not None:
   pair=heap+0xa000;result=heap+0xa100;write32(pair,key);write32(pair+4,prior);call(0x65e750,table,[result,pair])
 ids=[first,second];calls.clear();diagnostics.clear();call(0x62a140,actor,[]);primary=read32(0x2d789c0)
 initial={'primary_words':snapshot(primary,False),'secondary_words':snapshot(secondary,True),'owner_words':snapshot(owner_table,True)};steps=[]
 for invocation in range(2):
  allocations.clear();freed.clear();locks.clear();diagnostics.clear();sp=stack+0xe000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBP,stack+0xd000);u.reg_write(UC_X86_REG_ESI,actor);u.emu_start(0x629921,end,count=500000)
  assert u.reg_read(UC_X86_REG_EIP)==0x62997c and not allocations
  assert read32(primary+8)==0
  steps.append({'freed':list(freed),'locks':list(locks),'diagnostics':list(diagnostics),'primary_words':snapshot(primary,False),'secondary_words':snapshot(secondary,True),'owner_words':snapshot(owner_table,True)})
 cases.append({'first_id':first,'second_id':second,'poison':poison,'secondary_prior':secondary_prior,'owner_id':owner_id,'actor':actor,'primary_manager':primary,'initial':initial,'steps':steps})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual actor destructor segment629921 through62997C executes actual secondary unregister then primary lookup/removal, after complete actual62A140 registration with composed registries.48 lifetimes96 segment calls include repeat, existing-null/non-null secondary values, unsigned IDs and sentinel owner. No registry/unregister helper-result adapters.','This is the registry-removal segment only, not the complete actor destructor. Owner-component destructor, actor object release, later fields, concurrency and exceptions remain open. Virtual ID getter, allocation/free/lock imports, diagnostics and memmove primitive supplied.']}
(root/'data/4.20/audio_announcer_actor_unregister_segment_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_lifetimes':len(cases),'native_actor_unregister_segment_calls':sum(len(c['steps']) for c in cases),'passed':True}))
