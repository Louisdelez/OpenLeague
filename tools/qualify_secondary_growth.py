from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague')
source=(root/'tools/qualify_announcer_secondary_owner_registries.py').read_text().split('\ncases=[]')[0]
exec(compile(source,str(root/'tools/qualify_announcer_secondary_owner_registries.py'),'exec'))
cases=[];thresholds=[]
for kind,poison,high in itertools.product(['secondary','owner'],[0,165],[False,True]):
 cursor=arena;write32(0x14bef40,0);manager=0x2110a10 if kind=='secondary' else 0x2d5f470;entry=0x64c270 if kind=='secondary' else 0x6b59f0;query=0x5bdd80 if kind=='secondary' else 0x6b5990
 opaque=heap+0x9000;u.mem_write(opaque,bytes([poison]));call(0x664e50,manager,[opaque,0])
 for offset in [36,40,44]:write32(manager+offset,0)
 steps=[]
 for index in range(48):
  key=(0x80000000 if high else 0)+index*8;actor=0x30004000+index*0x200
  allocations.clear();freed.clear();locks.clear();diagnostics.clear();before=call(query,0,[key]);returned=call(entry,0,[actor,key]);after=call(query,0,[key]);assert before==0 and after==actor and returned&255==1
  head=read32(manager+4);begin=read32(manager+12);end_pointer=read32(manager+16);vector_begin=read32(manager+36);vector_end=read32(manager+40)
  words=[[manager+i,read32(manager+i)] for i in range(4,48,4)]+[[head+i,read32(head+i)] for i in range(0,16,4)]+[[i,read32(i)] for i in range(begin,end_pointer,4)]
  node=read32(head);seen=set()
  while node!=head:
   assert node not in seen;seen.add(node);words.extend([[node+i,read32(node+i)] for i in range(0,16,4)]);node=read32(node)
  words.extend([[i,read32(i)] for i in range(vector_begin,vector_end,4)])
  steps.append({'key':key,'actor':actor,'before':before,'return_low_byte':returned&255,'after':after,'allocations':list(allocations),'freed':list(freed),'locks':list(locks),'diagnostics':list(diagnostics),'words':words})
 cases.append({'kind':kind,'manager':manager,'poison':poison,'steps':steps})
 for count in [9999,10000,10001]:
  for key in [steps[0]['key'],0xffffffff]:
   write32(manager+8,count);diagnostics.clear();value=call(query,0,[key]);assert len(diagnostics)==int(count>=10000)
   thresholds.append({'kind':kind,'case':len(cases)-1,'count':count,'key':key,'value':value,'diagnostics':list(diagnostics)})
 write32(manager+8,48)
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'thresholds':thresholds,'limits':['Actual identity lookup, insertion/rehash and pointer-vector growth executed; 384 registrations across8 lifetimes, identity table grows8 to64 and pointer vector reaches48 entries.48 native count-threshold queries include9999,10000,10001 and present/missing keys.','Primitive allocation/free, engine owner-array allocation, lock imports and returning diagnostics supplied. Native exception unwinding, source-alias vector append, real locks, engine heap internals, teardown and live playback remain open.']}
(root/'data/4.20/audio_announcer_secondary_growth_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'registrations':sum(len(c['steps']) for c in cases),'threshold_queries':len(thresholds),'passed':True}))
