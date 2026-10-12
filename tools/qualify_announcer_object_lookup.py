from pathlib import Path
import json,struct,itertools,shutil
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
manager=heap+0x1000;head=heap+0x1100;buckets=heap+0x1200;base=heap+0x2000
def native_hash_model(key):
 v=(key^0xdeadbeef);v=v if v<0x80000000 else v-0x100000000
 q=abs(v)//127773*(-1 if v<0 else 1);rem=v-q*127773
 value=(rem*16807-q*2836)&0xffffffff
 if value&0x80000000:value=(value+0x7fffffff)&0xffffffff
 return value
def bucket(key,mask,maximum):
 i=native_hash_model(key)&mask
 return i if i<maximum else (i-1-(mask>>1))&0xffffffff
layouts=[];cases=[];selected=[]
def capture(uc,a,size,user):assert 0x400000<=a<0x1000000,hex(a)
def read_hook(uc,access,address,size,value,user):
 if buckets<=address<buckets+64 and size==4:selected.append((address-buckets)//8)
u.hook_add(unicorn.UC_HOOK_CODE,capture);u.hook_add(unicorn.UC_HOOK_MEM_READ,read_hook)
keysets=[[],[0,1,17,42,100],[0,1,2,17,42,100,200,0x7fffffff,0x80000000,0xdeadbeef,0xfffffffe,0xffffffff]]
queries=[0,1,2,16,17,42,99,100,200,0x7fffffff,0x80000000,0xdeadbeef,0xfffffffe,0xffffffff]
for mask,maximum,keys in itertools.product([0,1,3,7],[1,2,3,4,5,8],keysets):
 if not ((mask>>1)+1<=maximum<=mask+1):continue
 words={}
 def putword(a,v):words[a]=v;write32(a,v)
 putword(0x2d789c0,manager);putword(manager+4,head);putword(manager+12,buckets);putword(manager+24,mask);putword(manager+28,maximum)
 groups=[sorted(k for k in keys if bucket(k,mask,maximum)==i) for i in range(maximum)]
 ordered=[k for g in groups for k in g];nodes={key:base+i*32 for i,key in enumerate(ordered)};values={key:(heap+0x7000+i*0x100) for i,key in enumerate(ordered)}
 putword(head,base if ordered else head);putword(head+4,nodes[ordered[-1]] if ordered else head)
 for i,key in enumerate(ordered):
  node=nodes[key];putword(node,nodes[ordered[i+1]] if i+1<len(ordered) else head);putword(node+4,nodes[ordered[i-1]] if i else head);putword(node+8,key);putword(node+12,values[key])
 for i,g in enumerate(groups):putword(buckets+i*8,nodes[g[0]] if g else head);putword(buckets+i*8+4,nodes[g[-1]] if g else head)
 index=len(layouts);layouts.append({'mask':mask,'maximum':maximum,'manager':manager,'head':head,'keys':keys,'words':[[a,v] for a,v in sorted(words.items())]})
 for key in queries:
  selected=[];sp=stack+0x8000;u.mem_write(sp,struct.pack('<II',end,key));u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0x62b380,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
  result=u.reg_read(UC_X86_REG_EAX);assert result==values.get(key,0),(mask,maximum,key,result,values.get(key,0));assert selected and all(i==bucket(key,mask,maximum) for i in selected)
  cases.append({'layout':index,'key':key,'bucket':selected[0],'result':result})
proof={'native_sha256':digest,'functions':['0x62B380','0x5C6830','0xC9B47B'],'passed':True,'complete':False,'layouts':layouts,'cases':cases,'limits':['Original signed hash arithmetic, bucket selection, linked-node lookup and result pointer executed without function-result adapters.','Initialized registry layouts supplied; original661410 lazy manager initialization not executed.','Unique keys, valid bucket/list topology only; live registry mutation, locking and object lifetime remain work.']}
(r/'data/4.20/audio_announcer_object_lookup_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_object_lookup.py'),r/'tools/qualify_announcer_object_lookup.py');print(json.dumps({'layouts':len(layouts),'native_cases':len(cases)}))
