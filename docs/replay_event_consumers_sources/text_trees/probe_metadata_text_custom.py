"""Supplied deallocator callbacks mutate their global route; tree code is original."""
from pathlib import Path
import json,sys
exec(compile(Path('E:/mapslol3v3/replay_metadata_text_agent/probe_metadata_text.py').read_text().split('\ncases=[]')[0], 'text prerequisites','exec'))
callback_a,callback_b=heap+0xf000,heap+0xf010
u.mem_write(callback_a,b'\xc3');u.mem_write(callback_b,b'\xc3')
custom_events=[];next_callback=0;watched_tree=0;watched_node=0
def custom_boundary(uc,address,size,user):
 if address not in [callback_a,callback_b]:return
 sp=u.reg_read(UC_X86_REG_ESP);pointer,context=read32(sp+4),read32(sp+8)
 custom_events.append({'callback':address,'context':context,'pointer':pointer,'count':read32(watched_tree+4),'node_capacity':read32(watched_node+44)})
 freed.append(pointer)
 if address==callback_a:write32(0x14bef40,next_callback);write32(0x14bef44,0x22222222)
 finish()
u.hook_add(UC_HOOK_CODE,custom_boundary)
def input_value(value,fill):
 string,text=heap+0xc000,heap+0xd000;u.mem_write(string,bytes([fill])*24)
 if len(value)<=15:u.mem_write(string,value+b'\0');capacity=15
 else:u.mem_write(text,value+b'\0');write32(string,text);capacity=len(value)
 write32(string+16,len(value));write32(string+20,capacity)
 return {'source':string,'source_hex':bytes(u.mem_read(string,24)).hex(),'raw':text,'raw_hex':(value+b'\0').hex() if capacity>=16 else '', 'input_hex':value.hex(),'input_length':len(value)}
cases=[]
try:
 for fill in [0,165]:
  for offset,function in [(8,0x7285b0),(16,0x728830)]:
   for next_callback in [0,callback_b]:
    for replacement in [b'new',b'N'*64]:
     poison=fill;cursor=arena;allocations.clear();freed.clear();live={};metadata=0;metadata_events.clear();write32(0x14bef40,0);write32(0x14bef58,0)
     manager=call(0x9933e0,0,[68]);call(0x728e20,manager,[]);call(0x728fd0,manager,[]);initial=capture();steps=[]
     for j,value in enumerate([b'O'*64,replacement]):
      row=input_value(value,fill);row.update(function=function,key=42,index=0xffffffff,extra=0x13570000+j,target='custom_replace' if j else 'new')
      if j:
       watched_tree=metadata+offset;watched_node=read32(read32(watched_tree)+4);custom_events.clear();write32(0x14bef40,callback_a);write32(0x14bef44,0x11111111)
      call(function,metadata,[42,0xffffffff,row['source']]+([row['extra']] if offset==8 else []));row['snapshot']=capture();row['custom_events']=list(custom_events) if j else [];steps.append(row)
     write32(0x14bef40,0);call(0x7280b0,metadata,[]);cleared=capture();call(0x728ea0,manager,[1]);shutdown=capture();assert not live
     cases.append({'fill':fill,'metadata':metadata,'manager':manager,'initial':initial,'steps':steps,'watched_tree':watched_tree,'watched_node':watched_node,'callback_a':callback_a,'callback_b':callback_b,'next_callback':next_callback,'cleared':cleared,'shutdown':shutdown})
 proof={'passed':True,'native_sha256':digest,'cases':cases,'limits':['16 native lifetimes; supplied deallocator callback A retires input then changes global callback/context to B or standard. Actual5C4680 reload and setters execute unchanged. This tests one controlled callback mutation, not arbitrary reentrancy.']}
except Exception as error:
 import traceback;traceback.print_exc();proof={'passed':False,'error':repr(error),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'cases_completed':len(cases)}
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({k:v for k,v in proof.items() if k not in ['cases']}))
if not proof['passed']:sys.exit(1)
