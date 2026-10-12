from pathlib import Path
import itertools,json,sys,types
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_replay_transport_configuration.py').read_text().split('\ncases=[]')[0],'composite callback prerequisites','exec'))
calls=[];before_composite=types.FunctionType(boundary.__code__,globals())
def composite_boundary(uc,address,size,user):
 if address==0x32008a00:
  sp=u.reg_read(UC_X86_REG_ESP);owner=u.reg_read(UC_X86_REG_ECX)
  calls.append({'owner':owner,'member':address,'message':read32(sp+4)})
  finish(eax=read32(owner),pop=4);return
 return before_composite(uc,address,size,user)
boundary.__code__=composite_boundary.__code__
cases=[]
try:
 for poison,depth in itertools.product([0,165],[1,2,3]):
  for mask in range(1<<depth):
   write32(0x2d78ec4,0);u.mem_write(0x2d78ec1,b'\0\0');snapshot();baseline=set(live)
   call(0x901a70,0,[]);logger=read32(0x2d78ec4);initial=snapshot();steps=[]
   for index in range(depth):
    owner=heap+0xc000+index*16;write32(owner,257 if mask&(1<<index) else 256)
    incoming=call(0x9933e0,0,[12]);write32(incoming,0x1086078);write32(incoming+4,owner);write32(incoming+8,0x32008a00)
    call(0x8f9380,logger,[incoming]);steps.append({'incoming':incoming,'owner':owner,'supplied_return':read32(owner),'snapshot':snapshot()})
   root=read32(logger+32);clone=call(0x901750,root,[]);cloned=snapshot()
   calls.clear();message=heap+0xd000;u.mem_write(message,b'raw message\0')
   result=call(0x901840,clone,[message])&255;invocations=list(calls)
   call(0x901860,clone,[1]);clone_deleted=snapshot();call(0x901c00,0,[]);shutdown=snapshot();assert set(live)==baseline
   cases.append({'fill':poison,'depth':depth,'mask':mask,'logger':logger,'initial':initial,'steps':steps,'cloned_pointer':clone,'cloned':cloned,'message':message,'return_byte':result,'invocations':invocations,'clone_deleted':clone_deleted,'shutdown':shutdown})
 proof={'passed':True,'native_sha256':digest,'cases':cases,'limits':['28 native append/clone/invoke/delete lifetimes with1/2/3 recipients and every low-byte return combination, two allocation fills. The initial default callback is actual573FA0. Additional member targets are explicit supplied callback results256/257.','All composite constructors, recursive clones, virtual dispatch, logger publication and callback deletion execute source PE functions. No file writes, OOM, thrown exceptions, null-child invocation or concurrent logger use are qualified by this fixture.']}
except Exception as e:
 import traceback
 traceback.print_exc();proof={'passed':False,'error':repr(e),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'cases_completed':len(cases),'calls':call_trail[-12:]}
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({k:v for k,v in proof.items()if k not in ['cases','limits']}))
if not proof['passed']:sys.exit(1)
