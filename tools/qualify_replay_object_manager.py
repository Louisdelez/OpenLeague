from pathlib import Path
import json,random,sys
r=Path('E:/OpenLeague');source=(r/'tools/probe_replay_object_commands.py').read_text().split('\nmanager=heap+')[0]
exec(compile(source,'replay native prerequisites','exec'))
manager=heap+0xa000;nested=heap+0xa100;packet=heap+0xa300;service=heap+0xa500;held_control=heap+0xa800;incoming=heap+0xa900;temp=heap+0xaa00;callback=heap+0xab00
live={};events=[];returns=[]
def observe(uc,address,size,user):
 if address in [0x9941b0,0x994210]:events.append({'op':'enter' if address==0x9941b0 else 'leave','manager':u.reg_read(UC_X86_REG_ECX)})
 if address in [0x8fd680,0x8fd690]:events.append({'op':'id' if address==0x8fd680 else 'value','object':u.reg_read(UC_X86_REG_ECX)})
u.hook_add(unicorn.UC_HOOK_CODE,observe)
def snapshot():
 for a in allocations:live[a['pointer']]=a['bytes']
 for p in freed:live.pop(p,None)
 v={'allocations':list(allocations),'freed':list(freed),'events':list(events),'words':[[p+i,read32(p+i)] for p,n in sorted(live.items()) for i in range(0,n,4)]}
 allocations.clear();freed.clear();events.clear();return v
keys=list(range(32))+[0x7fffffff,0x80000000,0xffffffff]
cases=[]
for fill in [0,165]:
 for order in ['ascending','descending','mixed','duplicates']:
  cursor=arena;poison=fill;allocations.clear();freed.clear();events.clear();live={}
  u.mem_write(manager,bytes([fill])*0x44);call(0x728e20,manager,[]);write32(0x2d78520,manager)
  objects=call(0x9933e0,0,[48]);call(0x8f8810,objects,[])
  write32(manager+0x30,nested);write32(nested+0x6c,objects);write32(nested+0x70,held_control)
  for off,val in [(0,0x10afd08),(4,service),(8,0x72c780),(12,0)]:write32(callback+off,val)
  write32(callback+0x20,0x12345678)
  for off,val in [(0,0x1085f4c),(4,1),(8,1),(12,objects)]:write32(held_control+off,val)
  initial=snapshot();ordered=keys.copy()
  if order=='descending':ordered.reverse()
  if order in ['mixed','duplicates']:random.Random(420).shuffle(ordered)
  commands=[]
  for i,k in enumerate(ordered):
   value=((k*0x1f123bb5)&0xffffffff)|((k^0x80000000)<<32)
   if order=='duplicates':value=[0,1,0xffffffffffffffff,0x8000000000000000,0x7fffffffffffffff][i%5]
   commands.append(['insert',k,value&0xffffffff,value>>32])
  commands += [['insert',k,123,456] for k in ordered[::7]]
  commands += [['lookup',k] for k in [0,31,999,0x80000000,0xffffffff]]
  removed=ordered.copy();random.Random(704).shuffle(removed)
  commands += [['remove',k] for k in removed[:23]]
  commands += [['remove',k] for k in [999,removed[0]]]
  # Commands0/1 also exercise zero-valued entries and preservation of both indices.
  commands += [['packet',op,k,lo,hi] for op,k,lo,hi in [(0,99,0,0),(0,99,7,8),(1,99,0,0),(0,100,7,8),(1,100,0,0),(255,22,0,0)]]
  steps=[]
  for command in commands:
   kind=command[0]
   if kind=='insert':
    _,key,low,high=command;obj=call(0x9933e0,0,[16])
    for off,val in [(0,0x10d6048),(4,key),(8,low),(12,high)]:write32(obj+off,val)
    write32(incoming,0);write32(incoming+4,0);call(0x5d1fa0,incoming,[obj]);result=call(0x8f89d0,objects,[read32(incoming),read32(incoming+4)])&255
   elif kind=='lookup':
    result=call(0x8f8cf0,objects,[command[1]])|(u.reg_read(UC_X86_REG_EDX)<<32)
   elif kind=='remove':result=call(0x8f8b30,objects,[command[1]])&255
   else:
    _,op,key,low,high=command;u.mem_write(packet,bytes([fill])*16);u.mem_write(packet,bytes([op]));write32(packet+4,key);write32(packet+8,low);write32(packet+12,high)
    result=call(0x734130,callback,[callback+0x20,0,0x100,0,packet])&255
   steps.append({'command':command,'result':result,'state':snapshot(),'held_counts':[read32(held_control+4),read32(held_control+8)]})
  call(0x8f88a0,objects,[]);destroyed=snapshot();assert len(live)==1 and list(live)==[objects]
  cases.append({'fill':fill,'order':order,'objects':objects,'initial':initial,'steps':steps,'destroyed':destroyed})
proof={'passed':True,'complete':False,'native_sha256':digest,'arena':arena,'cases':cases,'limits':['Actual dual red-black trees, packet/control objects, all lookup/insert/remove/destruction bodies and734130 ->72C780 object commands execute. Native counters, allocations, frees and complete live-block words are captured for eight lifetimes. Existing engine mutex9941B0/994210 and memory primitives are supplied boundaries; constructor/destructor critical-section OS calls are supplied. No tree or object method result adapters.','Native manager/nested/held-control fields are explicit preconditions, not complete replay-stream initialization. Valid normal-return storage, successful allocations and no callback mutation/exception are covered here. Concurrency, OOM/unwind, real-world producers and consumers are separate requirements.']}
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'lifetimes':len(cases),'steps':sum(len(c['steps']) for c in cases),'complete_live_memory':True}))
