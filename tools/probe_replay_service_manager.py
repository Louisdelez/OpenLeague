from pathlib import Path
import itertools,json,sys,types
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_parent_order.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'service-parent prerequisites','exec'))
assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
contract='--contract' in sys.argv
service=heap+0xa000;initialized=None;initial_globals=None;service_trace=[];parent_args=None
prior_service=types.FunctionType(boundary.__code__,globals())
def global_fields():
 p=read32(0x2d78520)
 return {'pointer':p,'words':[read32(0x2d78240+i) for i in range(0,68,4)],'reinitialize':int(u.mem_read(0x2d784e6,1)[0]),'registered':int(u.mem_read(0x2d78288,1)[0])}
def boundary_service(uc,address,size,user):
 global initialized,initial_globals,parent_args
 if contract and address==0x8a8b80 and read32(u.reg_read(UC_X86_REG_ESP)+4)==0x8fb860:finish(eax=0);return
 if contract and address==0x8a8c50 and u.reg_read(UC_X86_REG_ECX)==0:finish(eax=0,pop=4);return
 if address==0x72a791:initialized=snapshot();initial_globals=global_fields()
 if address in [0x72a800,0x72a780,0x5cf1e0,0x658f70,0x7338c0]:service_trace.append({'function':address,'this':u.reg_read(UC_X86_REG_ECX)})
 if address==0x7297e0:parent_args=[read32(u.reg_read(UC_X86_REG_ESP)+4+i*4) for i in range(12)]
 return prior_service(uc,address,size,user)
boundary.__code__=boundary_service.__code__
cases=[]
try:
 for poison,enabled,secondary,recording,host_kind in itertools.product([0,165],[0,1,165],[0,1,165],[0,1],['numeric','null']):
  profile=2;write_result=0;close_result=0;network_profile['startup_code']=0;extra=0x87654321 if enabled==165 else 0;flag=257 if secondary==165 else 0
  write32(0x2d78f04,0);write32(0x2d78f10,0);write32(0x2d78ec4,0);u.mem_write(0x2d78ec1,b'\0\0');write32(0x2d78520,0);u.mem_write(0x2d784e6,b'\0');u.mem_write(0x2d78288,b'\0');u.mem_write(0x2d78240,bytes([poison])*68);write32(0x2d62a48,extra)
  u.mem_write(service,bytes([poison])*392);write32(service,0x10afe8c);u.mem_write(service+0x122,bytes([enabled]));u.mem_write(service+0x12f,bytes([secondary]));service_before=bytes(u.mem_read(service,392)).hex()
  snapshot();baseline=set(live);events.clear();parent_trace.clear();service_trace.clear();retired_reads.clear();resource_pointer=0;retired=False;initialized=None;initial_globals=None;parent_args=None
  key=heap+0xd000;host=heap+0xd100;u.mem_write(key,bytes(range(16)));u.mem_write(host,b'127.0.0.1\0')
  args=[1,0,key,host if host_kind=='numeric' else 0,1,2,3,flag,0,recording]
  result=scheduled_call(0x72a780,service,args);mode=int(enabled!=0 and secondary==0);expected=0 if mode else(6 if host_kind=='numeric' else 2);assert result==expected,(result,expected)
  assert initialized is not None and parent_args[7]&255==mode and parent_args[9]==extra
  manager=read32(0x2d78520);stream=read32(manager+0x30);opened=snapshot();opened_globals=global_fields();state=read32(read32(stream+0x44)+12)
  scheduled_call(0x5d81b0,0,[]);destroyed=snapshot();destroyed_globals=global_fields();retired=bool(resource_pointer and resource_pointer in destroyed['freed'])
  assert read32(0x2d78f10)==0
  if read32(0x2d78ec4):call(0x901c00,0,[])
  shutdown=snapshot();retired=False;assert set(live)==baseline and not retired_reads,{'remaining':sorted(set(live)-baseline),'retired_reads':retired_reads}
  assert bytes(u.mem_read(service,392)).hex()==service_before
  cases.append({'fill':poison,'enabled':enabled,'secondary':secondary,'mode':mode,'recording':recording,'host_kind':host_kind,'extra':extra,'flag':flag,'service':service,'service_hex':service_before,'manager':manager,'stream':stream,'args':args,'parent_args':parent_args,'return_code':result,'state_after_parent_open':state,'initialized':initialized,'initialized_globals':initial_globals,'opened':opened,'opened_globals':opened_globals,'destroyed':destroyed,'destroyed_globals':destroyed_globals,'shutdown':shutdown,'trace':list(parent_trace),'service_trace':list(service_trace),'retired_reads':list(retired_reads)})
 proof={'passed':True,'native_sha256':digest,'stream_worker_creation_supplied_failure':contract,'cases':cases,'tables':{'service_init_slot':{'address':0x10afea8,'value':read32(0x10afea8)},'extra_global':{'address':0x2d62a48}},'limits':['72 native72A780->72A800->5CF1E0/728FD0->7297E0 lifetimes exercise both heap fills,0/1/A5 bytes at service122 and12F, recording flags and null/numeric host. Service storage392 and flags are explicit caller inputs with actual service vtable; this does not claim source service construction.','Source initialization replaces callbacks20 and24 with actual658F70/7338C0 wrappers and actual clone/delete methods. Native mode uses only BL; upper EBX residue is captured but is not assigned semantics.','Derived host8FD6A0 explicitly returns failure0; no active network traffic. Diagnostic filename is null. Parent global shutdown is followed immediately by logger shutdown; retired-resource reads are monitored and none occurred.','Stream worker is '+('an explicit creation failure0 with null-worker join supplied' if contract else 'actual PE32 worker/CRT capsule with logical scheduling when join occurs after run-flag clear')+'. Native startup transport worker uses logical scheduling. These are primitive supplied OS/allocator profiles, not live Windows acceptance.']}
except Exception as e:
 import traceback;traceback.print_exc();proof={'passed':False,'error':repr(e),'cases_completed':len(cases),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'calls':call_trail[-16:],'service_trace':service_trace,'parent_args':parent_args}
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({k:v for k,v in proof.items()if k not in ['cases','limits','tables']}))
if not proof['passed']:sys.exit(1)
