from pathlib import Path
import json,sys
r=Path('E:/OpenLeague');source=(r/'tools/probe_replay_object_commands.py').read_text().split('\nmanager=heap+')[0]
exec(compile(source,'replay initialization prerequisites','exec'))
live={}
def snapshot():
 for a in allocations:live[a['pointer']]=a['bytes']
 for p in freed:live.pop(p,None)
 result={'allocations':list(allocations),'freed':list(freed),'words':[[p+i,read32(p+i)] for p,n in sorted(live.items()) for i in range(0,n,4)]}
 allocations.clear();freed.clear();return result
cases=[]
for fill in [0,165]:
 poison=fill;cursor=arena;allocations.clear();freed.clear();live={}
 manager=call(0x9933e0,0,[0x44]);assert call(0x728e20,manager,[])==manager;initial=snapshot()
 result=call(0x728fd0,manager,[])&255;assert result==1;configured=snapshot();nested=read32(manager+0x30)
 fields={'nested':nested,'object_pair':[read32(nested+0x6c),read32(nested+0x70)],'callbacks':[read32(manager+i) for i in [0x20,0x24,0x28,0x2c]],'metadata_pair':[read32(manager+0x34),read32(manager+0x38)]}
 print(json.dumps({'configured':True,'fill':fill,'live_blocks':len(live),'fields':fields}),flush=True)
 assert call(0x728ea0,manager,[1])==manager;destroyed=snapshot();assert not live,live
 cases.append({'fill':fill,'manager':manager,'initial':initial,'configured':configured,'fields':fields,'destroyed':destroyed})
proof={'passed':True,'complete':False,'native_sha256':digest,'cases':cases,'limits':['Actual728E20 construction,728FD0 callback/stream/metadata initialization and728EA0/728EE0 full destruction execute. Existing engine allocation/memmove/mutex and OS initialization primitives supplied. No manager, stream or metadata helper result adapters.','Stream8F6700 starts with null object-manager pair; this initialization alone does not make72C780 object commands callable. Stream startup8F68D0 and its resources must create and publish the object manager before command delivery. No live replay file or simulation integration is proven.']}
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'lifetimes':len(cases),'all_owned_allocations_released':True}))
