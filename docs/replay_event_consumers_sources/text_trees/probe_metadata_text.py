"""Execute real 4.20 text setters; caller strings are explicit input data."""
from pathlib import Path
import json,sys,random
from unicorn import UC_HOOK_CODE
exec(compile(Path('E:/OpenLeague/tools/probe_replay_metadata.py').read_text().split('\ncases=[]')[0], 'metadata prerequisites', 'exec'))
assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
visited=set()
def text_track(uc,address,size,user):
 if 0x5c4680<=address<0x5c4948 or 0x735ef0<=address<0x73626f:visited.add(address)
u.hook_add(UC_HOOK_CODE,text_track)
def nodes(offset):
 head=read32(metadata+offset);out=[]
 def walk(p):
  if u.mem_read(p+13,1)[0]:return
  walk(read32(p));out.append(p);walk(read32(p+8))
 walk(read32(head+4));return out
def node_type(p):
 return sum(not u.mem_read(read32(p+i)+13,1)[0] for i in [0,8])
cases=[]
try:
 for fill in [0,165]:
  poison=fill;cursor=arena;allocations.clear();freed.clear();live={};metadata=0;metadata_events.clear();write32(0x14bef40,0);write32(0x14bef58,0)
  manager=call(0x9933e0,0,[68]);call(0x728e20,manager,[]);call(0x728fd0,manager,[]);initial=capture();steps=[]
  string,text=heap+0xc000,heap+0xd000
  keys=[(5,0),(1,0),(9,0xffffffff),(5,0xffffffff),(5,1),(0xffffffff,0),(0,0x80000000),(0,0x7fffffff),(2,0),(8,0),(3,0),(7,0)]
  rng=random.Random(420)
  keys += [(k,idx) for k,idx in zip(rng.sample(range(10,150),30),[0,1,0xffffffff]*10)]
  values=[b'',b'A',b'B'*15,b'C'*16,b'D'*31,b'E'*64,b'a\0embedded\0tail',b'Z'*128,b'prefix\0'+b'X'*60]
  for j in range(102):
   for offset,function in [(8,0x7285b0),(16,0x728830)]:
    target='new';old_node=None
    if j<len(keys):k,index=keys[j]
    else:
     rows=nodes(offset);head=read32(metadata+offset);selector=(j-len(keys))%6
     if selector==0:old_node=read32(head+4);target='root'
     elif selector==1:old_node=rows[0];target='minimum'
     elif selector==2:old_node=rows[-1];target='maximum'
     else:
      children=selector-3;matching=[p for p in rows if node_type(p)==children]
      old_node=(matching or rows)[rng.randrange(len(matching or rows))];target=f'children{node_type(old_node)}'
     k,index=read32(old_node+16),read32(old_node+20)
    value=values[j%len(values)];length=len(value)
    # Two explicit input descriptors demonstrate strlen ignoring stored length.
    if j in [20,21] and offset==16:length=0 if j==20 else 2
    u.mem_write(string,bytes([fill])*24)
    if len(value)<=15:u.mem_write(string,value+b'\0');capacity=15
    else:u.mem_write(text,value+b'\0');write32(string,text);capacity=len(value)
    write32(string+16,length);write32(string+20,capacity)
    args=[k,index,string]+([0x13570000+j] if offset==8 else [])
    call(function,metadata,args);captured=capture()
    steps.append({'function':function,'key':k,'index':index,'extra':0x13570000+j,'target':target,'old_node':old_node,
      'source':string,'source_hex':bytes(u.mem_read(string,24)).hex(),'raw':text,'raw_hex':(value+b'\0').hex() if capacity>=16 else '',
      'input_hex':value.hex(),'input_length':length,'snapshot':captured})
  call(0x7280b0,metadata,[]);cleared=capture();call(0x728ea0,manager,[1]);shutdown=capture();assert not live
  cases.append({'fill':fill,'metadata':metadata,'manager':manager,'initial':initial,'steps':steps,'cleared':cleared,'shutdown':shutdown})
 proof={'passed':True,'native_sha256':digest,'cases':cases,'native_code_visited':[hex(x) for x in sorted(visited)],'limits':['408 actual setter calls across2 native parent lifetimes; caller input descriptors explicit, allocator/copy/OS locks supplied by existing probe.','Original find, erase, insert, RB fixup and SSO bodies execute. No OOM, custom callback mutation, aliased erased input or concurrent mutation claimed.']}
except Exception as e:
 import traceback;traceback.print_exc();proof={'passed':False,'error':repr(e),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'cases_completed':len(cases)}
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({k:v for k,v in proof.items() if k not in ['cases','native_code_visited']}))
if not proof['passed']:sys.exit(1)


