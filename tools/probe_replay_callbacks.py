from pathlib import Path
import itertools,json,sys,types
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_replay_transport_configuration.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'callback primitive prerequisites','exec'))
factories=[0x733540,0x7335c0,0x733640,0x7336c0,0x733740,0x7337c0,0x733840,0x658f70,0x7338c0]
vtables=[0x108606c,0x1086078,0x10afd14,0x10afd20,0x10afd34,0x109b2d4,0x10afcfc,0x10afd08]
out=heap+0xe000;owner_slot=heap+0xe010;parent=heap+0xe100
null_next=False
original_callback_allocation=types.FunctionType(callback_allocation.__code__,globals())
def callback_boundary(uc,address,size,user):
 global null_next
 if address==0xc9f39b and null_next:
  null_next=False;allocations.append({'bytes':read32(u.reg_read(UC_X86_REG_ESP)+4),'pointer':0});finish(eax=0);return
 return original_callback_allocation(uc,address,size,user)
callback_allocation.__code__=callback_boundary.__code__
def capture():
 for a in allocations:
  if a['pointer']:live[a['pointer']]=a['bytes']
 for p in freed:live.pop(p,None)
 value={'allocations':list(allocations),'freed':list(freed),'words':[[p+i,read32(p+i)] for p,n in sorted(live.items()) if p not in globals().get('baseline',set()) for i in range(0,n,4)]}
 allocations.clear();freed.clear();return value
def make(fid,owner,member=0x738a3a,extra=0x13579bdf):
 write32(owner_slot,owner)
 assert call(fid,out,[owner_slot,member,extra] if fid in [0x658f70,0x7338c0] else [owner_slot,0])==out
 return read32(out)
def erase(p,flags=1):
 if p:assert call(read32(read32(p)),p,[flags])==p
def release(p):call(0xc98528,0,[p])
def bundle_new():
 p=call(0x9933e0,0,[20])
 # Exact inlined writes72914D..729168; parent-lifetime fixture separately runs
 # those instructions in728FD0. There is no standalone constructor entry.
 for off,v in [(0,0x10b0128),(4,0),(8,0),(12,0),(16,0)]:write32(p+off,v)
 return p
capture();baseline=set(live);factory_cases=[];replace_cases=[];bundle_cases=[];null_cases=[];extra_clone_cases=[]
try:
 for poison,fid,owner,flags in itertools.product([0,165],factories,[0,0x30008500,0xffffffff],[0,1,2,257]):
  p=make(fid,owner);created=capture();clone_fn=read32(read32(p)+4);q=call(clone_fn,p,[]);cloned=capture()
  erase(q,flags);deleted=capture()
  if flags&1==0:release(q)
  erase(p);finished=capture();assert set(live)==baseline
  factory_cases.append({'fill':poison,'factory':fid,'owner':owner,'member':0x738a3a,'extra':0x13579bdf,'flags':flags,'pointer':p,'clone_pointer':q,'created':created,'cloned':cloned,'deleted':deleted,'finished':finished})
 for poison,fid,failure in itertools.product([0,165],factories,['factory','clone']):
  if failure=='factory':
   null_next=True;p=make(fid,0x30008500);assert p==0;created=capture();cloned=None
  else:
   p=make(fid,0x30008500);created=capture();null_next=True;q=call(read32(read32(p)+4),p,[]);assert q==0;cloned=capture();erase(p)
  finished=capture();assert set(live)==baseline
  null_cases.append({'fill':poison,'factory':fid,'failure':failure,'pointer':p,'created':created,'cloned':cloned,'finished':finished})
 for poison,extra,fail_clone in itertools.product([0,165],[0,17,0xffffffff],[False,True]):
  p=call(0x9933e0,0,[16])
  for off,v in[(0,0x10afd08),(4,0x30008500),(8,0x72b950),(12,extra)]:write32(p+off,v)
  created=capture();null_next=fail_clone;q=call(0x7340c0,p,[]);cloned=capture()
  assert bool(q)==(not fail_clone);erase(q);erase(p);finished=capture();assert set(live)==baseline
  extra_clone_cases.append({'fill':poison,'extra':extra,'null_clone':fail_clone,'pointer':p,'clone_pointer':q,'created':created,'cloned':cloned,'finished':finished})
 for poison,wrapper in itertools.product([0,165],[False,True]):
  for offset,old_present,new_present in itertools.product([12,16] if wrapper else [4,8,12,16],[False,True],[False,True]):
   p=bundle_new();write32(parent+0x28,p)
   old_factory=factories[(offset//4+2)%len(factories)];new_factory=0x658f70 if offset%8 else 0x7338c0
   old=make(old_factory,0x30008500) if old_present else 0
   write32(p+offset,old);incoming=make(new_factory,0x30008600) if new_present else 0;created=capture()
   fn=({12:0x729a50,16:0x729ae0} if wrapper else {4:0x728b60,8:0x728c10,12:0x728cc0,16:0x728d70})[offset]
   result=call(fn,parent if wrapper else p,[out,incoming]);assert result==out;returned=read32(out);replaced=capture()
   erase(returned);call(0x728ae0,p,[1]);finished=capture();assert set(live)==baseline
   replace_cases.append({'fill':poison,'wrapper':wrapper,'offset':offset,'old_factory':old_factory,'new_factory':new_factory,'old_present':old_present,'new_present':new_present,'bundle':p,'incoming':incoming,'output':out,'parent':parent,'returned':returned,'created':created,'replaced':replaced,'finished':finished})
 for poison,flags in itertools.product([0,165],[0,1,2,257]):
  p=bundle_new()
  for offset,fid in zip([4,8,12,16],[0x733540,0x7337c0,0x658f70,0x7338c0]):write32(p+offset,make(fid,0x30008500+offset))
  created=capture();assert call(0x728ae0,p,[flags])==p;deleted=capture()
  if flags&1==0:release(p)
  finished=capture();assert set(live)==baseline
  bundle_cases.append({'fill':poison,'flags':flags,'bundle':p,'created':created,'deleted':deleted,'finished':finished})
 result={'passed':True,'native_sha256':digest,'vtables':[[v,[read32(v+i) for i in [0,4,8]]] for v in vtables],'bundle_vtable':[0x10b0128,[read32(0x10b0128)]],'factory_cases':factory_cases,'null_cases':null_cases,'extra_clone_cases':extra_clone_cases,'replace_cases':replace_cases,'bundle_cases':bundle_cases,'limits':['All9 factories,8 virtual clones,578010 scalar deletion,4 bundle replacements,2 parent wrappers and728AE0 execute actual source functions. Allocation/free primitives use the existing standard-route adapter. Null allocator return is explicitly supplied for each factory and clone.','Bundle construction is inlined in728FD0, reproduced as the5 directly observed writes for setup here; complete parent native initialization is separately covered by replay_manager_initialization_probe.json. The10AFD08 source wrapper is explicitly supplied caller storage. This probe qualifies no callback member invocation, active host, exception rollback, custom allocator or concurrent mutation.']}
except Exception as e:
 import traceback;traceback.print_exc();result={'passed':False,'error':repr(e),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'factories_completed':len(factory_cases),'null_completed':len(null_cases),'replacements_completed':len(replace_cases),'bundles_completed':len(bundle_cases),'calls':call_trail[-12:]}
Path(sys.argv[1]).write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps({k:v for k,v in result.items() if k not in ['factory_cases','null_cases','extra_clone_cases','replace_cases','bundle_cases','limits','vtables']}))
if not result['passed']:sys.exit(1)
