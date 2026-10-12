"""Original camera target gate/getter/hash lookup and full automatic target prelude."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_camera_sequence.py').read_text(encoding='utf-8').split('\nu.hook_add(unicorn.UC_HOOK_CODE,hook)')[0]
exec(compile(source,'sequence setup','exec'))
proxy=heap+0xd000;vector=heap+0xe000;references=heap+0xe200;renderer_control=heap+0xa800;input_state=heap+0xa900;controller_holder=heap+0xaa00;bucket_table=heap+0xb300;sentinel=heap+0xb400;nodes=heap+0xb500
write32(0x2d78a44,input_state);write32(0x2d78d24,controller_holder);write32(controller_holder,renderer_control);write32(0x2d78dfc,0)
cached_index=0;update_calls=0;gate_calls=0;getter_calls=0;lookup_calls=[];prelude_query=0;prelude_active=1
allowed=[(0x7cfb70,0x7cfbe0),(0x5a54e0,0x5a5534),(0x5aeb40,0x5aebb0),(0x5bdd20,0x5bdd7a),(0x5c3160,0x5c31d0),(0x7d0e80,0x7d0ea2)]
def hook(uc,a,size,user):
 global update_calls,gate_calls,getter_calls,prelude_query
 if a==0x5ae9f0:update_calls+=1;write32(proxy+0x5a8,cached_index&0xffffffff);finish();return
 if a==end+0x400:prelude_query+=1;finish(eax=prelude_active);return
 if a==0x5aeb40:gate_calls+=1
 if a==0x5a54e0:getter_calls+=1
 if a==0x5bdd20:lookup_calls.append(read32(u.reg_read(UC_X86_REG_ESP)+4))
 assert any(lo<=a<hi for lo,hi in allowed),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def run(start,stop=end,ecx=proxy,args=[]):
 sp=stack+0x8000;u.mem_write(sp,struct.pack('<'+'I'*(1+len(args)),end,*args));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,ecx);u.emu_start(start,stop,count=10000);assert u.reg_read(UC_X86_REG_EIP)==stop
 return u.reg_read(UC_X86_REG_EAX)
def gate_setup(flags=(1,1,1,1),times=(0,0),input_option=0,mode=2,ui_present=True):
 for a,b in zip([proxy+0x1a1,proxy+0x334,ui+0x1b0,renderer_control+0xdc],flags):u.mem_write(a,bytes([b]))
 write32(proxy+0x338,times[0]);write32(proxy+0x340,times[1]);u.mem_write(input_state+0x20,bytes([input_option]));write32(0x2d788d4,mode);write32(0x2d77e54,ui if ui_present else 0)
def vector_setup(ids):
 write32(proxy+0x370,vector);write32(proxy+0x374,vector+len(ids)*4)
 for i,id in enumerate(ids):write32(vector+i*4,references+i*4);write32(references+i*4,id)
def registry_setup(ids,mask=7,count=8):
 write32(0x2d5cb58+4,sentinel);write32(0x2d5cb58+8,len(ids));write32(0x2d5cb58+0xc,bucket_table);write32(0x2d5cb58+0x18,mask);write32(0x2d5cb58+0x1c,count);write32(sentinel,sentinel)
 buckets={i:[] for i in range(count)};entities={}
 for i,id in enumerate(ids):
  node=nodes+i*0x10;entity=heap+0xf000+i*0x100;position=[7300.+i*100.,44.+i,8100.+i*80.];entities[id]=(entity,position);write32(node+8,id);write32(node+0xc,entity);u.mem_write(entity+0x60,struct.pack('<3f',*position));bucket=id&mask
  if bucket>=count:bucket-=((mask>>1)+1)
  buckets[bucket].append((id,node))
 for i,bucket in buckets.items():
  bucket.sort();write32(bucket_table+i*8,bucket[0][1] if bucket else sentinel);write32(bucket_table+i*8+4,bucket[-1][1] if bucket else sentinel)
  for j,(_,node) in enumerate(bucket):write32(node,bucket[j+1][1] if j+1<len(bucket) else sentinel)
 return entities
gates=[]
for flags,times,option,mode,present in itertools.product(itertools.product([0,2],repeat=4),[(bits([-1.])[0],bits([-1.])[0]),(bits([1.])[0],bits([-1.])[0]),(bits([-1.])[0],bits([1.])[0]),(0x7fc00000,0x7fc00000)],[0,2],[0,2],[False,True]):
 gate_setup(flags,times,option,mode,present);value=run(0x5aeb40)&0xff;gates.append({'flags':flags,'times_bits':times,'input_option_raw':option,'mode_raw':mode,'ui_present':present,'result_raw':value})
getters=[]
for ids,enabled,cached_index in itertools.product([[],[0],[0x80000000,7],[1,7,0xffffffff,12]],[False,True],[-2,-1,0,1,4,5]):
 gate_setup((int(enabled),1,1,1));vector_setup(ids);write32(proxy+0x5a8,0xdeadbeef);update_calls=0;out=heap+0xe800;write32(out,0xa5a5a5a5);run(0x5a54e0,args=[out]);getters.append({'ids':ids,'gate':enabled,'cached_index_after_update':cached_index,'target_id':read32(out),'index_update_calls':update_calls})
resolvers=[]
for ids,layout,query in itertools.product([[],[0,1,7,8,15,16,0x80000000,0xffffffff]],[(7,8),(15,10),(15,16)],[0,1,2,7,8,15,16,0x80000000,0xffffffff]):
 entities=registry_setup(ids,*layout);actual=run(0x5bdd20,ecx=0,args=[query]);assert actual==(entities[query][0] if query in entities else 0)
 resolvers.append({'registered_ids':ids,'mask':layout[0],'bucket_count':layout[1],'query':query,'resolved':actual!=0})
preludes=[]
for y,block,prelude_active,present,provider,resolved,cached_index,enabled in itertools.product([-1000.,-999.,10.],[0,1],[0,2],[False,True],[False,True],[False,True],[-1,0,1],[False,True]):
 gate_setup((int(enabled),1,1,1),ui_present=present);vector_setup([11,22]);entities=registry_setup([11,22] if resolved else []);write32(ui+0x130,proxy if provider else 0);write32(0x2d77f48,block);u.mem_write(controller,b'\x00'*0x200);focus=[7100.,y,7700.];u.mem_write(controller+0x104,struct.pack('<3f',*focus));getter_calls=0;update_calls=0;lookup_calls=[];prelude_query=0
 run(0x7cfb70,0x7cfbe0,controller,args=[camera])
 preludes.append({'focus':focus,'follow_block_raw':block,'service_active_raw':prelude_active,'ui_present':present,'provider_present':provider,'registry':{str(id):position for id,(_,position) in entities.items()},'gate':enabled,'cached_index_after_update':cached_index,'target_ids':[11,22],'output_focus_bits':list(struct.unpack('<3I',u.mem_read(controller+0x104,12))),'service_queries':prelude_query,'getter_calls':getter_calls,'index_update_calls':update_calls,'lookup_ids':lookup_calls})
proof={'native_sha256':digest,'passed':True,'gates':gates,'getters':getters,'resolvers':resolvers,'preludes':preludes,'complete':False,'limits':['Full5AEB40 gate and5A54E0 target getter execute;5AE9F0 selection-index refresh supplied by explicit adapter, not claimed qualified.','Full5BDD20 and5C3160 execute on supplied native linear-hash buckets/chains including unsigned high-bit IDs. Registry construction/removal and limit-warning path>=10000 excluded.','Full7CFB70..7CFBE0 automatic target prelude executes with real gate/getter/registry lookup/7D0E80 position setter; service virtual query and index refresh are the only adapters.','UI flags/timing/globalmode/input producers, selection hit testing59B830 and camera lock/spectator binding remain incomplete.','These IDs are entity network IDs in a hash registry; no generation-checked weak-reference mechanism inferred.']}
(r/'data/4.20/camera_target_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Native target cases',len(gates),len(getters),len(resolvers),len(preludes))
