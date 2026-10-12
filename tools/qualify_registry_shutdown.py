from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague');source=(root/'tools/qualify_announcer_registry_insertion.py').read_text().split('\ncases=[]')[0]
exec(compile(source,str(root/'tools/qualify_announcer_registry_insertion.py'),'exec'))
custom=0x32001000;context=0x3000d000;routes=[]
def callback(uc,address,size,user):
 if address==custom:
  sp=u.reg_read(UC_X86_REG_ESP);pointer=read32(sp+4);ctx=read32(sp+8);assert ctx==context;routes.append({'pointer':pointer,'context':ctx});freed.append(pointer);finish()
u.hook_add(unicorn.UC_HOOK_CODE,callback)
cases=[]
for count,custom_free,poison,flag in itertools.product([None,0,1,33],[False,True],[0,165],[0,1]):
 cursor=arena;write32(0x14bef40,0);write32(0x14bef44,context);write32(0x2d789c0,0);u.mem_write(0x2d78974,bytes([flag]));manager=0
 if count is not None:
  u.mem_write(0x2d78969,b'\1');call(0x661410,0,[]);manager=read32(0x2d789c0)
  for key in range(count):
   pair=heap+0xa000;result=heap+0xa100;write32(pair,key);write32(pair+4,heap+0x6000+key*32);call(0x65e6f0,manager,[result,pair])
 write32(0x14bef40,custom if custom_free else 0);u.mem_write(0x2d78974,bytes([flag]));steps=[]
 for invocation in range(2):
  freed.clear();routes.clear();call(0x6653b0,0,[]);assert read32(0x2d789c0)==0
  words=[[manager+i,read32(manager+i)] for i in range(4,36,4)] if manager else []
  steps.append({'freed':list(freed),'custom_routes':list(routes),'manager':read32(0x2d789c0),'initialization_flag':u.mem_read(0x2d78974,1)[0],'words':words})
 cases.append({'initial_count':count,'custom_free':custom_free,'poison':poison,'initial_flag':flag,'original_manager':manager,'steps':steps})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual6653B0 shutdown,5DE550 table destructor and5DEAD0 node destruction execute through normal return;32 lifetimes64 shutdown calls, null/empty/one/grown33-node tables, custom and standard free routing, both flag states and padding fills.','Free imports/custom callback and malloc/atexit primitives supplied; callbacks return normally and storage snapshots after free are emulator observations only, never live Rust reads of released memory. Actor/owner ownership and exception unwinding remain open.']}
(root/'data/4.20/audio_announcer_registry_shutdown_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'sequences':len(cases),'shutdown_calls':sum(len(c['steps']) for c in cases),'passed':True}))
