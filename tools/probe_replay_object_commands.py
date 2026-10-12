from pathlib import Path
import json,sys
r=Path('E:/OpenLeague');source=(r/'tools/probe_whole_announcer_startup.py').read_text().split('\npoison=165;cursor=arena;')[0]
exec(compile(source,'native replay manager prerequisites','exec'))
poison=165;cursor=arena;fail=False
write32(0x14bef40,0);write32(0x14bef58,0);u.mem_write(0x2d77b20,b'\1')
call(0xc9a0b9,0,[]);write32(0x2da5308,read32(0x1222ed0))
manager=heap+0xa000;nested=heap+0xa100;packet=heap+0xa300;service=heap+0xa500;held_control=heap+0xa800
u.mem_write(manager,bytes([poison])*0x44);call(0x728e20,manager,[]);write32(0x2d78520,manager)
objects=call(0x9933e0,0,[48]);call(0x8f8810,objects,[])
write32(manager+0x30,nested);write32(nested+0x6c,objects);write32(nested+0x70,held_control)
for off,val in [(0,0x1085f4c),(4,1),(8,1),(12,objects)]:write32(held_control+off,val)
print(json.dumps({'constructed':hex(objects),'vtable':[hex(read32(0x10d6048+i)) for i in [0,4,8]]}),flush=True)
def trees():
 result={}
 for offset in [0x20,0x28]:
  head=read32(objects+offset);nodes=[];seen=set()
  def walk(p):
   if u.mem_read(p+13,1)[0]:return
   assert p not in seen;seen.add(p);walk(read32(p));nodes.append({'node':p,'words':[read32(p+i) for i in range(0,28,4)]});walk(read32(p+8))
  walk(read32(head+4));result[str(offset)]={'head':head,'size':read32(objects+offset+4),'nodes':nodes}
 return result
steps=[]
commands=[(0,42,1,2),(0,42,3,4),(0,43,1,2),(0,44,0,0),(0,44,5,6),(1,42,0,0),(1,42,0,0),(1,43,0,0),(1,44,0,0),(0,0xffffffff,0xffffffff,0xffffffff),(0,0x80000000,0,0x80000000),(1,0xffffffff,0,0),(1,0x80000000,0,0),(255,1,0,0)]
for opcode,key,low,high in commands:
 allocations.clear();freed.clear();windows_calls.clear();u.mem_write(packet,bytes([poison])*16)
 u.mem_write(packet,bytes([opcode]));write32(packet+4,key);write32(packet+8,low);write32(packet+12,high)
 result=call(0x72c780,service,[0x87654321,0,0,0,packet]);assert result&255==1
 observed=call(0x8f8cf0,objects,[key]);high_result=u.reg_read(UC_X86_REG_EDX)
 steps.append({'command':[opcode,key,low,high],'trees':trees(),'lookup':[observed,high_result],'allocations':list(allocations),'freed':list(freed),'held_counts':[read32(held_control+4),read32(held_control+8)],'windows_calls':list(windows_calls)})
 print(json.dumps({'command':steps[-1]['command'],'sizes':[v['size'] for v in steps[-1]['trees'].values()],'value':steps[-1]['lookup']}),flush=True)
freed.clear();call(0x8f88a0,objects,[])
proof={'passed':True,'complete':False,'native_sha256':digest,'objects':objects,'manager':manager,'steps':steps,'destroyed_freed':list(freed),'object_vtable':[read32(0x10d6048+i) for i in [0,4,8]],'limits':['Actual72C780 command routing,729CF0/738AC0/5CC070/5BD3C0,8F8810 construction,8F89D0 insertion,8F8B30 removal,8F8CF0 lookup and8F88A0 destruction execute with real native trees and packet objects. Only existing primitive allocation and single-thread Win32 critical-section boundaries are supplied. No tree or object-command result adapters.','Caller-owned manager/nested fields and held shared-manager control are explicit preconditions; manager stream creation/lifetime and engine startup are not proven. This evidence does not implement the Rust object-manager path or live replay streaming.']}
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
