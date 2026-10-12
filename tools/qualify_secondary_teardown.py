from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague');source=(root/'tools/qualify_announcer_secondary_owner_registries.py').read_text().split('\ncases=[]')[0]
exec(compile(source,str(root/'tools/qualify_announcer_secondary_owner_registries.py'),'exec'))
critical_delete=end+0x900;custom_free=end+0xa00;context=0x3000d000;delete_calls=[];free_routes=[]
write32(0xfa41bc,critical_delete)
def teardown_boundaries(uc,address,size,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if address==critical_delete:delete_calls.append(read32(sp+4));finish(4)
 elif address==custom_free:
  pointer=read32(sp+4);ctx=read32(sp+8);assert ctx==context;freed.append(pointer);free_routes.append({'pointer':pointer,'context':ctx});finish()
u.hook_add(unicorn.UC_HOOK_CODE,teardown_boundaries)
cases=[]
for kind,poison,count,custom in itertools.product(['secondary','owner'],[0,165],[0,1,33,48],[False,True]):
 cursor=arena;write32(0x14bef40,0);write32(0x14bef44,context);manager=0x2110a10 if kind=='secondary' else 0x2d5f470;registration=0x64c270 if kind=='secondary' else 0x6b59f0;teardown=0x64c400 if kind=='secondary' else 0x6b5b80
 opaque=heap+0x9000;u.mem_write(opaque,bytes([poison]));call(0x664e50,manager,[opaque,0])
 for offset in [36,40,44]:write32(manager+offset,0)
 for key in range(count):call(registration,0,[0x30004000+key*0x200,key*8])
 allocations.clear();freed.clear();delete_calls.clear();free_routes.clear();write32(0x14bef40,custom_free if custom else 0);call(teardown,0,[])
 assert not allocations and delete_calls==[manager+56]
 assert all(read32(manager+i)==0 for i in [8,12,16,20,36,40,44])
 cases.append({'kind':kind,'poison':poison,'count':count,'custom_free':custom,'manager':manager,'deleted_critical_sections':list(delete_calls),'freed':list(freed),'custom_routes':list(free_routes),'words':[[manager+i,read32(manager+i)] for i in range(4,48,4)]})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual secondary64C400/64F360 and owner6B5B80/6B6380 teardown bodies execute with5DEAD0 node clearing.32 initialized one-shot lifetimes include empty,1,33,48 entries, vector/table growth, padding fills and standard/custom free. Critical-section deletion precedes vector release, table buckets, nodes and sentinel; fixed global manager storage is retained.','IATFA41BC critical-section deletion, malloc/free, owner array allocator, returning diagnostics/lock imports and custom free callback supplied. Teardown is one-shot; stale sentinel label is retained like native and must never be reused. Live concurrency, repeated teardown, actor ownership and exceptions remain open.']}
(root/'data/4.20/audio_announcer_secondary_teardown_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_teardown_lifetimes':len(cases),'native_free_calls':sum(len(c['freed']) for c in cases),'passed':True}))
