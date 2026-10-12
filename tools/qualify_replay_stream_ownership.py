from pathlib import Path
import itertools,json,sys
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_replay_object_commands.py').read_text().split('\nmanager=heap+')[0],'replay ownership prerequisites','exec'))
destination=heap+0xa000;source_pair=heap+0xa010
first_control=heap+0xa100;second_control=heap+0xa200;shared_vt=heap+0xa300
events=[];mutation=0;observing_pairs=True;custom=False
write32(shared_vt,end+0x8000);write32(shared_vt+4,end+0x8100)

def pair_words(p):return [read32(p),read32(p+4)]
def observe(uc,address,size,user):
 if address in [end+0x8000,end+0x8100]:
  p=u.reg_read(UC_X86_REG_ECX)
  events.append({'op':'dispose' if address==end+0x8000 else 'release','control':p,'strong':read32(p+4),'weak':read32(p+8),'destination':pair_words(destination),'source':pair_words(source_pair)})
  if address==end+0x8000:
   if mutation&1:write32(source_pair,0xfefefefe);write32(source_pair+4,0)
   if mutation&2:write32(destination,0xedededed);write32(destination+4,0)
  finish()
 elif not observing_pairs:
  if address in [0x9941b0,0x994210]:events.append({'op':'enter' if address==0x9941b0 else 'leave','manager':u.reg_read(UC_X86_REG_ECX)})
  if address in [0x8fd680,0x8fd690]:events.append({'op':'id' if address==0x8fd680 else 'value','object':u.reg_read(UC_X86_REG_ECX)})
  if address==end+0x8300:
   sp=u.reg_read(UC_X86_REG_ESP);p=read32(sp+4);context=read32(sp+8)
   assert context==0x13572468;freed.append(p);events.append({'op':'custom_free','pointer':p,'context':context});finish()
u.hook_add(unicorn.UC_HOOK_CODE,observe)

def words():return [[p+i,read32(p+i)] for p,n in [(destination,8),(source_pair,8),(first_control,12),(second_control,12)] for i in range(0,n,4)]
def setup(strong,weak):
 events.clear();allocations.clear();freed.clear()
 for p in [first_control,second_control]:write32(p,shared_vt);write32(p+4,strong);write32(p+8,weak)

moves=[]
for strong,weak,new,old,alias,mutation in itertools.product([0,1,2,0xffffffff],[0,1,2],[0,first_control],[0,first_control,second_control],[False,True],range(4)):
 setup(strong,weak);write32(destination,0x1234);write32(destination+4,old);write32(source_pair,0x87654321);write32(source_pair+4,new)
 src=destination if alias else source_pair;before=words();result=call(0x5bd4e0,destination,[src]);assert result==destination
 moves.append({'strong':strong,'weak':weak,'new':new,'old':old,'alias':alias,'mutation':mutation,'source':src,'before':before,'result':result,'after':words(),'events':list(events)})

factories=[];mutation=0
for poison,obj,(strong,weak),fail in itertools.product([0,165],[0,heap+0x7000],controls,[False,True]):
 cursor=arena;setup(strong or 0,weak or 0);write32(destination,0x1234);write32(destination+4,0 if strong is None else first_control);write32(source_pair,0);write32(source_pair+4,0)
 before=words();call(0x9019a0,destination,[obj]);selected=read32(destination+4)
 assert bool(selected)==(not fail);assert read32(destination)==obj
 factories.append({'fill':poison,'object':obj,'strong':strong or 0,'weak':weak or 0,'before':before,'fail_allocation':fail,'after':words(),'allocations':list(allocations),'new_words':[[selected+i,read32(selected+i)] for i in range(0,16,4)] if selected else [],'events':list(events)})

observing_pairs=False;fail=False
held=heap+0xa800;incoming=heap+0xa900;extra=heap+0xa920;packet_pair=heap+0xa940
live={}
def snapshot():
 for a in allocations:
  assert a['pointer'];live[a['pointer']]=a['bytes']
 for p in freed:
  assert p in live,hex(p);del live[p]
 value={'allocations':list(allocations),'freed':list(freed),'events':list(events),'words':[[p+i,read32(p+i)] for p,n in sorted(live.items()) for i in range(0,n,4)],'pairs':[[p,*pair_words(p)] for p in [held,incoming,extra]]}
 allocations.clear();freed.clear();events.clear();return value
def reset(fill,use_custom):
 global cursor,poison,live,custom
 cursor=arena;poison=fill;live={};custom=use_custom;allocations.clear();freed.clear();events.clear()
 write32(0x14bef40,end+0x8300 if custom else 0);write32(0x14bef44,0x13572468)
 for p in [held,incoming,extra]:write32(p,0);write32(p+4,0)
def new_manager(count):
 obj=call(0x9933e0,0,[48]);call(0x8f8810,obj,[])
 for i in range(count):
  key=[0,1,42,0x80000000,0xffffffff,7][i];value=[0,0,1,1,0xffffffffffffffff,0x8000000000000000][i]
  packet=call(0x9933e0,0,[16])
  for off,v in [(0,0x10d6048),(4,key),(8,value&0xffffffff),(12,value>>32)]:write32(packet+off,v)
  write32(packet_pair,0);write32(packet_pair+4,0);call(0x5d1fa0,packet_pair,[packet]);call(0x8f89d0,obj,pair_words(packet_pair))
 return obj

lifetimes=[]
profiles=list(itertools.product([0,165],[0,6],[False,True],[False,True],[False,True]))
profiles += [(fill,None,occupied,False,custom) for fill,occupied,custom in itertools.product([0,165],[False,True],[False,True])]
for fill,count,occupied,weak_owner,custom in profiles:
 reset(fill,custom);obj=0 if count is None else new_manager(count);old=new_manager(3) if occupied else 0
 steps=[{'op':'create','state':snapshot()}]
 call(0x9019a0,incoming,[obj]);ctrl=read32(incoming+4)
 if weak_owner:write32(ctrl+8,2)
 steps.append({'op':'factory','state':snapshot()})
 if occupied:call(0x9019a0,held,[old])
 steps.append({'op':'old_factory','state':snapshot()})
 call(0x5cc070,extra,[incoming]);steps.append({'op':'acquire','state':snapshot()})
 call(0x5bd4e0,held,[incoming]);steps.append({'op':'move','state':snapshot()})
 call(0x5bd3c0,incoming,[]);steps.append({'op':'release_empty','state':snapshot()})
 call(0x5bd3c0,extra,[]);steps.append({'op':'release_copy','state':snapshot()})
 call(0x5bd3c0,held,[]);steps.append({'op':'release_owner','state':snapshot()})
 if weak_owner:
  assert read32(ctrl+4)==0 and read32(ctrl+8)==1
  # Explicit external weak-owner release; control's native release body then runs.
  write32(ctrl+8,0);call(0x5d5b40,ctrl,[])
 steps.append({'op':'release_weak','state':snapshot()});assert not live
 lifetimes.append({'fill':fill,'count':count,'occupied':occupied,'weak_owner':weak_owner,'custom':custom,'object':obj,'old':old,'control':ctrl,'steps':steps})

deletions=[]
for fill,count,custom,arg in itertools.product([0,165],[0,6],[False,True],[0,1,256,0xffffffff]):
 reset(fill,custom);obj=new_manager(count);before=snapshot();result=call(0x901b00,obj,[arg]);assert result==obj;after=snapshot();assert not live
 deletions.append({'fill':fill,'count':count,'custom':custom,'argument':arg,'object':obj,'before':before,'result':result,'after':after})

proof={'passed':True,'complete':False,'native_sha256':digest,'moves':moves,'factories':factories,'lifetimes':lifetimes,'deletions':deletions,'limits':[
 'Actual5BD4E0 move and9019A0 factory execute with native atomic counters. Synthetic old-control callbacks retain storage and observe both pairs, optionally mutating them; self-move, shared-control aliases and wrapping counters are preconditions, not claims of arbitrary ownership validity. Primitive malloc null return is supplied for104 factory cases.',
 'Forty complete manager-control lifetimes execute9019A0/901B40/901B00, actual dual trees, native packet/control virtuals and5D5B40/5D6840, plus32 direct deletion lifetimes. Complete live bytes and ordered frees are compared; native methods are not replaced by results. Engine mutex9941B0/994210, Windows critical-section and memory primitives remain supplied boundaries. External weak-reference release is explicit caller input.',
 'Stream opening, actual replay data, normal client event integration, native concurrency and exception/unwind are outside this contract.'
]}
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'moves':len(moves),'factories':len(factories),'manager_lifetimes':len(lifetimes),'direct_deletions':len(deletions)}))
