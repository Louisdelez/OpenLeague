from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague');source=(root/'tools/qualify_actor_unregister_segment.py').read_text().split('\ncases=[]')[0]
exec(compile(source,str(root/'tools/qualify_actor_unregister_segment.py'),'exec'))
mode='';target_node=0;new_id=0;mutated=False
def mutate(uc,address,size,user):
 global mutated
 if mutated:return
 if (mode=='free' and address==0xc98528 and freed and freed[-1]==target_node) or (mode=='leave' and address==0x994210 and u.reg_read(UC_X86_REG_ECX)==0x2110a40):
  write32(actor+0xfc,new_id);mutated=True
u.hook_add(unicorn.UC_HOOK_CODE,mutate)
cases=[]
for mode,poison,present in itertools.product(['free','leave'],[0,165],[False,True]):
 cursor=arena;write32(0x14bef40,0);write32(0x2d789c0,0);u.mem_write(0x2d78974,b'\0');u.mem_write(0x2d78969,b'\1');write32(owner_storage,0xffffffff);write32(actor+0xfc,42)
 for table in [secondary,owner_table]:
  opaque=heap+0x9000;u.mem_write(opaque,bytes([poison]));call(0x664e50,table,[opaque,0])
  for offset in [36,40,44]:write32(table+offset,0)
 ids=[42,42];calls.clear();diagnostics.clear();mutated=True;call(0x62a140,actor,[]);primary=read32(0x2d789c0);new_id=0x80000000 if present else 999
 if present:
  pair=heap+0xa000;result=heap+0xa100;write32(pair,new_id);write32(pair+4,0x3000bbbb);call(0x65e6f0,primary,[result,pair])
 target_node=read32(read32(secondary+4));initial={'primary_words':snapshot(primary,False),'secondary_words':snapshot(secondary,True),'owner_words':snapshot(owner_table,True)}
 allocations.clear();freed.clear();locks.clear();diagnostics.clear();mutated=False;sp=stack+0xe000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBP,stack+0xd000);u.reg_write(UC_X86_REG_ESI,actor);u.emu_start(0x629921,end,count=500000)
 assert u.reg_read(UC_X86_REG_EIP)==0x62997c and mutated and not allocations and read32(actor+0xfc)==new_id
 assert call(0x62b380,0,[42])==actor and call(0x62b380,0,[new_id])==0
 cases.append({'mode':mode,'poison':poison,'alternate_present':present,'actor':actor,'new_id':new_id,'initial':initial,'freed':list(freed),'locks':list(locks),'diagnostics':list(diagnostics),'primary_words':snapshot(primary,False),'secondary_words':snapshot(secondary,True),'owner_words':snapshot(owner_table,True)})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual actor registry destructor segment executes with callbacks changing actor+FC during secondary node free or lock leave.8 native cases verify fresh post-callback ID read, existing alternate ID removal or missing alternate skip, and original ID retention. Actual lookup/removal helpers execute, no result adapters.','Normal-return free/lock callbacks intentionally mutate explicit actor fields. This is the registry-removal segment, not whole actor destructor; live concurrency, owner component and exception unwinding remain open.']}
(root/'data/4.20/audio_announcer_actor_unregister_mutations_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_mutation_cases':len(cases),'passed':True}))
