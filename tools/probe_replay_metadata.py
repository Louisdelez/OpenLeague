from pathlib import Path
import itertools,json,sys,types
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_replay_manager_initialization.py').read_text().split('\ncases=[]')[0],'metadata prerequisites','exec'))
assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
metadata=0;metadata_events=[];original_boundary=types.FunctionType(boundary.__code__,globals())
def observed_boundary(uc,address,size,user):
 global metadata
 if address==0x727de0:metadata=u.reg_read(UC_X86_REG_ECX)
 if address==0x727eb7:metadata_events.append({'op':'initialize','object':metadata+0x1c8})
 if address==0x727fc5:metadata_events.append({'op':'destroy','object':metadata+0x1c8})
 if address in [0x9941b0,0x994210] and metadata and u.reg_read(UC_X86_REG_ECX)==metadata+0x1c8:
  metadata_events.append({'op':'enter' if address==0x9941b0 else 'leave','object':metadata+0x1c8})
 return original_boundary(uc,address,size,user)
boundary.__code__=observed_boundary.__code__
def capture():
 s=snapshot();s['blocks']=[{'pointer':p,'bytes':n,'hex':bytes(u.mem_read(p,n)).hex()} for p,n in sorted(live.items())];s['lock_events']=list(metadata_events);metadata_events.clear();return s
cases=[]
try:
 for fill,populated,action in itertools.product([0,165],[False,True],['clear_then_delete','scalar0','scalar1','scalar2','scalar257','dispose']):
  poison=fill;cursor=arena;allocations.clear();freed.clear();live={};metadata=0;metadata_events.clear();write32(0x14bef40,0);write32(0x14bef58,0)
  manager=call(0x9933e0,0,[68]);call(0x728e20,manager,[]);call(0x728fd0,manager,[]);control=read32(manager+0x38);assert metadata==read32(manager+0x34);initial=capture()
  if populated:
   string=heap+0xc000;text=heap+0xd000
   u.mem_write(string,bytes([fill])*24);write32(string+16,0);write32(string+20,15);u.mem_write(string,b'\0')
   for index,key in enumerate([5,1,9,3,7,0xffffffff,2,8,0x80000000]):
    data=(b'inline'+bytes([65+index])) if index%2==0 else (b'long-native-metadata-'+bytes([65+index])*32)
    u.mem_write(text,data+b'\0');call(0x564c20,string,[text,len(data)])
    call(0x7285b0,metadata,[key,index,string,0x12345678+index]);call(0x728830,metadata,[key,index,string]);call(0x728a40 if index%2 else 0x728a60,metadata,[key])
   call(0x564900,string,[])
   data=b'long-standalone-metadata-string-for-destruction';u.mem_write(text,data+b'\0')
   for offset in [0x1b0,0x1e8]:call(0x564c20,metadata+offset,[text,len(data)])
   for offset,value in [(0x1a0,7),(0x1a4,9),(0x1a8,11),(0x1ac,13)]:write32(metadata+offset,value)
   for offset in range(0x20,0x1a0,4):write32(metadata+offset,offset*17)
  prepared=capture();cleared=None
  if action=='clear_then_delete':call(0x7280b0,metadata,[]);cleared=capture();result=call(0x729d20,metadata,[1])
  elif action=='dispose':call(0x5a3220,control,[]);result=None
  else:result=call(0x729d20,metadata,[int(action[6:])])
  destroyed=capture()
  if action in ['scalar0','scalar2']:call(0xc98528,0,[metadata])
  call(0x5d5b40,control,[]);write32(manager+0x34,0);write32(manager+0x38,0);call(0x728ea0,manager,[1]);shutdown=capture();assert not live,live
  cases.append({'fill':fill,'populated':populated,'action':action,'manager':manager,'metadata':metadata,'control':control,'initial':initial,'prepared':prepared,'cleared':cleared,'destroyed':destroyed,'shutdown':shutdown,'result':result})
 proof={'passed':True,'native_sha256':digest,'cases':cases,'limits':['24 complete original parent initialization/metadata teardown lifetimes. Metadata construction is captured from actual728FD0 including the inline512-byte derived suffix. Populated cases execute actual7285B0/728830/728A40/728A60 and564C20 to build all three trees and short/long strings before destructor qualification.','Tests may consume populated native snapshots as input; metadata update methods themselves are not yet ported by this module. Allocator and single-thread OS critical-section primitives are supplied; custom allocator mutation, OOM/exception rollback and contention remain unqualified.','Direct teardown is followed by explicit parent-pair retirement to avoid double destruction; full parent release order is separately covered by manager fixtures. No frame decoding, recording or live game service integration is claimed.']}
except Exception as e:
 import traceback;traceback.print_exc();proof={'passed':False,'native_sha256':digest,'error':repr(e),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'cases_completed':len(cases),'calls':call_trail[-20:]}
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({k:v for k,v in proof.items() if k not in ['cases','limits']}))
if not proof['passed']:sys.exit(1)
