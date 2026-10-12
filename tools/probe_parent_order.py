from pathlib import Path
import itertools,json,sys,types
r=Path('E:/OpenLeague')
source=(r/'tools/probe_replay_recording_file.py').read_text(encoding='utf-8').split('\ncases=[]')[0]
exec(compile(source,'parent lifetime prerequisites','exec'))
prior=types.FunctionType(boundary.__code__,globals())
parent_trace=[];resource_pointer=0;retired=False;retired_reads=[]
watched={0x7297e0,0x7337c0,0x8f68d0,0x8f6af0,0x8f6bc0,0x8f6fa0,0x8fc500,0x8f8e10,0x8f8f90,0x5f9d70,0x5d6340,0x901c00,0x728ee0,0x8fb490,0x8f92b0,0x5d81b0}
def boundary_parent(uc,address,size,user):
 global resource_pointer
 if address==0x8fd6a0:finish(eax=0);return
 if address==0x8f8e10:resource_pointer=u.reg_read(UC_X86_REG_ECX)
 if address in watched:parent_trace.append({'function':address,'this':u.reg_read(UC_X86_REG_ECX),'thread':current_thread})
 return prior(uc,address,size,user)
boundary.__code__=boundary_parent.__code__
def observe(uc,access,address,size,value,user):
 if resource_pointer and (retired or resource_pointer in freed) and address<resource_pointer+40 and address+size>resource_pointer:
  retired_reads.append({'address':address,'size':size,'pc':u.reg_read(UC_X86_REG_EIP)})
u.hook_add(unicorn.UC_HOOK_MEM_READ,observe)
cases=[]
try:
 for poison,mode,recording,host_kind in itertools.product([0,165],[0,1],[0,1],['numeric','null']):
  profile=2;write_result=0;close_result=0;network_profile['startup_code']=0
  write32(0x2d78f04,0);write32(0x2d78f10,0);write32(0x2d78ec4,0);u.mem_write(0x2d78ec1,b'\0\0');snapshot();baseline=set(live)
  events.clear();parent_trace.clear();retired_reads.clear();resource_pointer=0;retired=False
  manager=call(0x9933e0,0,[68]);call(0x728e20,manager,[]);assert call(0x728fd0,manager,[])&255==1
  stream=read32(manager+0x30);initial=snapshot()
  key=heap+0xd000;host=heap+0xd100;u.mem_write(key,bytes(range(16)));u.mem_write(host,b'127.0.0.1\0')
  args=[1,0,key,host if host_kind=='numeric' else 0,1,2,3,mode,0,0,0,recording]
  result=scheduled_call(0x7297e0,manager,args)
  expected=(0 if mode else (6 if host_kind=='numeric' else 2));assert result==expected,(result,expected)
  opened=snapshot();state=read32(read32(stream+0x44)+12)
  assert state==(4 if mode or host_kind=='numeric' else 1),state
  scheduled_call(0x728ea0,manager,[1]);destroyed=snapshot();retired=bool(resource_pointer and resource_pointer in destroyed['freed'])
  assert read32(0x2d78f10)==0
  if read32(0x2d78ec4):call(0x901c00,0,[])
  shutdown=snapshot();retired=False
  assert set(live)==baseline and not retired_reads,{'remaining':sorted(set(live)-baseline),'retired_reads':retired_reads}
  cases.append({'fill':poison,'mode':mode,'recording':recording,'host_kind':host_kind,'manager':manager,'stream':stream,'args':args,'return_code':result,'state_after_parent_open':state,'initial':initial,'opened':opened,'destroyed':destroyed,'shutdown':shutdown,'trace':list(parent_trace),'retired_reads':list(retired_reads)})
  print(json.dumps({k:cases[-1][k] for k in ['fill','mode','recording','host_kind','return_code','state_after_parent_open']}),flush=True)
 proof={'passed':True,'native_sha256':digest,'cases':cases,'limits':['Actual 728E20,728FD0,7297E0,7337C0 and728EA0/728EE0 execute. Parent opening calls8F68D0 then8F6AF0 on success. Derived host allocation8FD6A0 is explicitly supplied failure0; native start returns6 after state4 transition. No-op start returns0.','Both recording flags and two heap fills are covered with null recording filename. Actual PE stream worker runs only at join after run flag clears. No active polling/network or file I/O is claimed.','Stream callbacks use real parent pointer. Metadata constructor is the source512-byte derived object727DE0 + suffix, not merely a generic488-byte base.','Logger shutdown is explicit immediately after parent destruction. This proves no intervening retired read for this sequence; later unrelated logs, callback invocations, original process-global shutdown ordering and live service integration remain outside the probe.']}
except Exception as e:
 import traceback
 traceback.print_exc();proof={'passed':False,'error':repr(e),'cases_completed':len(cases),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'native_calls':call_trail[-16:],'windows_calls':windows_calls[-8:],'trace':parent_trace[-24:]}
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({k:v for k,v in proof.items() if k not in ['cases','limits']}))
if not proof['passed']:sys.exit(1)
