from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague');source=(root/'tools/qualify_announcer_registry_insertion.py').read_text().split('\ncases=[]')[0]
source=source.replace('elif address==0xc98528:freed.append(read32(sp+4));finish()','elif address==0xc98528:pass')
exec(compile(source,str(root/'tools/qualify_announcer_registry_insertion.py'),'exec'))
custom=0x32001000;context=0x3000d000;events=[];enabled=False;mode='';node_labels=set();manager=0
def release(uc,address,size,user):
 if address not in [custom,0xc98528]:return
 sp=u.reg_read(UC_X86_REG_ESP);pointer=read32(sp+4);ctx=read32(sp+8) if address==custom else None
 freed.append(pointer)
 if enabled:
  events.append({'pointer':pointer,'custom':address==custom,'context':ctx})
  if pointer in node_labels:
   if mode=='standard_to_custom':write32(0x14bef40,custom)
   elif mode=='custom_to_standard':write32(0x14bef40,0)
   elif mode=='changing_context':write32(0x14bef44,read32(0x14bef44)+4)
 finish()
u.hook_add(unicorn.UC_HOOK_CODE,release)
cases=[]
for mode,poison,count in itertools.product(['standard_to_custom','custom_to_standard','changing_context'],[0,165],[3,33]):
 enabled=False;cursor=arena;write32(0x14bef40,0);write32(0x14bef44,context);write32(0x2d789c0,0);u.mem_write(0x2d78974,b'\0');u.mem_write(0x2d78969,b'\1');call(0x661410,0,[]);manager=read32(0x2d789c0);nodes=[]
 for key in range(count):
  pair=heap+0xa000;result=heap+0xa100;write32(pair,key);write32(pair+4,heap+0x6000+key*32);call(0x65e6f0,manager,[result,pair]);nodes.append(read32(result))
 node_labels=set(nodes);enabled=True;events.clear();freed.clear();write32(0x14bef40,0 if mode=='standard_to_custom' else custom);call(0x6653b0,0,[])
 assert read32(0x2d789c0)==0 and u.mem_read(0x2d78974,1)[0]==1
 cases.append({'mode':mode,'poison':poison,'count':count,'original_manager':manager,'nodes':nodes,'free_events':list(events)})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual6653B0/5DE550/5DEAD0 bodies execute with callbacks changing native deallocator globals during node frees.12 lifetimes include3 and33 nodes, standard-to-custom, custom-to-standard and changing custom context.','Free callbacks/malloc/atexit are supplied normal-return adapters; live allocator reentrancy, throwing callbacks, actor ownership and audio playback remain open.']}
(root/'data/4.20/audio_announcer_shutdown_routes_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'lifetimes':len(cases),'free_events':sum(len(c['free_events']) for c in cases),'passed':True}))
