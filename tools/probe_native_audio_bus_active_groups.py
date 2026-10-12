"""Original Bus active-group modes with actual priority-array rebuild bodies."""
from pathlib import Path
import itertools,json,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
node=heap+0x1000;cache=heap+0x2000;entries=heap+0x3000;groups=[cache+0x10,heap+0x4000,heap+0x5000];arrays=[heap+0x6000,heap+0x6100,heap+0x6200];calls=[]
regions=[(0xb009b0,0xb00a42),(0xb00c20,0xb00c87),(0xafd810,0xafd8b3),(0xafd8c0,0xafd963),(0xafd670,0xafd733),(0xafd740,0xafd803),(0xaffb10,0xaffb72)]
def guard(uc,a,n,d):
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
 if a in [0xafd810,0xafd8c0]:calls.append({'kind':'rebuild','group':u.reg_read(UC_X86_REG_ECX),'ascending':a==0xafd8c0})
u.hook_add(unicorn.UC_HOOK_CODE,guard)
profiles=[[],[(10.,10)],[(10.,30),(10.,10),(10.,20),(10.,0xffffffff)],[(30.,7),(10.,0),(10.,0xffffffff),(-5.,2)]]
entry_profiles=[[],[0],[groups[1],groups[2]],[groups[1],0,groups[2]]];rows=[]
for operation,pattern,requested,mode,profile,entry_layout in itertools.product(['ordering','property'],[0,1,2,3,0xa5,0xff],[0,1],range(4),range(4),range(4)):
 u.mem_write(node,bytes([0xa5])*200);put(node,'I',0xff1380);put(node+0x1c,'I',cache);u.mem_write(node+0x2e,bytes([pattern]));u.mem_write(cache,bytes(0x30));refs=entry_profiles[entry_layout];put(cache,'III',entries,len(refs),4)
 for i,g in enumerate(refs):put(entries+i*12,'III',i+100,g,0xa5a5a5a5)
 voices=[];before_groups=[]
 for j,(g,array) in enumerate(zip(groups,arrays)):
  u.mem_write(g,bytes([0xa5])*16);ascending=bool(mode&(1 if j==0 else 2));pairs=[]
  for i,(value,key) in enumerate(profiles[profile]):
   v=heap+0x8000+(j*4+i)*0x200;u.mem_write(v,bytes(0x140));put(v+0x134,'fI',value,key);pairs.append(v);voices.append({'reference':v,'value':value,'key':key})
  pairs.sort(key=lambda v:(-read(v+0x134,'f')[0],read(v+0x138,'I')[0] if ascending else -read(v+0x138,'I')[0]));put(g,'III',array,len(pairs),4);u.mem_write(g+0xe,bytes([int(ascending),0xa5]));
  for i,v in enumerate(pairs):put(array+i*4,'I',v)
  before_groups.append({'reference':g,'raw':bytes(u.mem_read(g,16)).hex(),'voices':pairs})
 before=bytes(u.mem_read(node,200)).hex();before_cache=bytes(u.mem_read(cache,16)).hex();calls.clear();sp=stack+0x8000;put(sp,'II',trap,requested);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,node);u.emu_start(0xb009b0 if operation=='ordering' else 0xb00c20,trap,count=10000);assert u.reg_read(UC_X86_REG_EIP)==trap
 after_groups=[]
 for g,array in zip(groups,arrays):after_groups.append({'reference':g,'raw':bytes(u.mem_read(g,16)).hex(),'voices':[read(array+i*4,'I')[0] for i in range(read(g+4,'I')[0])]})
 rows.append({'operation':operation,'pattern':pattern,'requested':requested,'mode':mode,'profile':profile,'entry_layout':entry_layout,'children':refs,'voices':voices,'before_cache':before_cache,'after_cache':bytes(u.mem_read(cache,16)).hex(),'before':before,'after':bytes(u.mem_read(node,200)).hex(),'before_groups':before_groups,'after_groups':after_groups,'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()} for a,e in regions],'adapters':['No callback result adapters: B009B0/B00C20 execute with active cache1C, actual AFD810/AFD8C0 rebuilds and AFD670/AFD740 search plus AFFB10 insertion.','Constructed valid sorted voice arrays with explicit capacity4; rebuild allocation branch is not reached. Null child groups are exercised.'],'limits':['Preparatory reference; Rust group mode/rebuild consumer not yet ported.','Finite priorities, unique keys and distinct groups only. No group allocation failure, lifecycle or voice admission/device acceptance.']}
(r/'data/4.20/audio_bus_active_groups_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'original Bus active-group mode and priority rebuild cases')
