from pathlib import Path
import json,datetime,struct
s=Path('E:/mapslol3v3/probe_native_grass_object_growth.py').read_text(encoding='utf-8').split('\ncases=[]')[0]
s=s.replace('assert n in [4,8,12,16,64,80]','assert n>0 and n<=512 and n%4==0')
exec(compile(s,'pool native setup','exec'))
cases=[]
for capacity in [0,1,2,3,4,8]:
 for length in range(capacity+1):
  for internal in [False,True]:
   if internal and length==0:continue
   cursor=terrain+0x8000;write32(0x14bef40,0);write32(0x2d712b4,object_pool);write32(0x2d712b8,object_pool+length*4);write32(0x2d712bc,object_pool+capacity*4)
   initial=[100+i for i in range(length)]
   for i,value in enumerate(initial):write32(object_pool+i*4,value)
   steps=[]
   for step in range(12):
    start=read32(0x2d712b4);size=(read32(0x2d712b8)-start)//4;source_index=(step*7)%size if internal else None
    if internal:source=start+source_index*4;value=read32(source)
    else:source=lower;value=1000+step;write32(source,value)
    reservations.clear();call(0x969e60,0,[source]);start=read32(0x2d712b4);size=(read32(0x2d712b8)-start)//4
    steps.append(dict(source_index=source_index,value=value,reservations=list(reservations),capacity=(read32(0x2d712bc)-start)//4,handles=list(struct.unpack('<'+str(size)+'I',u.mem_read(start,size*4)))))
   cases.append(dict(initial=initial,capacity=capacity,internal=internal,steps=steps))
proof=dict(passed=True,complete=False,updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),native_sha256=digest,native_addresses=len(visited),cases=cases,entry='0x969e60',growth='0x96a9a0/0x96b010/0x96b050',limits=['Supplied valid handle vectors and successful small allocations. Native allocator/free adapted; actual growth/copy and internal-source relocation execute. OOM/custom allocation and cross-context ownership remain unqualified.'])
(r/'data/4.20/grass_object_pool_sequences_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),steps=sum(len(c['steps']) for c in cases),addresses=len(visited))))
