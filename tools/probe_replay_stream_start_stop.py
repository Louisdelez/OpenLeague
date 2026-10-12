from pathlib import Path
import itertools,json,sys,types
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_replay_transport_configuration.py').read_text().split('\ncases=[]')[0],'stream start prerequisites','exec'))
previous_boundary=types.FunctionType(boundary.__code__,globals())
host_failures=[];resource_pointer=0;retired=False;retired_reads=[];start_entries=[]
def start_boundary(uc,address,size,user):
 if address==0x8fd6a0:
  sp=u.reg_read(UC_X86_REG_ESP)
  values=[u.reg_read(UC_X86_REG_ECX),u.reg_read(UC_X86_REG_EDX),read32(sp+4),read32(sp+8)]
  assert values==[0,1,0,0],values
  host_failures.append({'function':address,'arguments':values,'supplied_result':0})
  finish(eax=0);return
 if address in [0x8fb860,0x8fb7b0,0x8f6fa0,0x8f8f90]:start_entries.append({'function':address,'thread':current_thread})
 return previous_boundary(uc,address,size,user)
boundary.__code__=start_boundary.__code__
def observe_retired(uc,access,address,size,value,user):
 if resource_pointer and (retired or resource_pointer in freed) and address<resource_pointer+40 and address+size>resource_pointer:
  retired_reads.append({'address':address,'size':size,'pc':u.reg_read(UC_X86_REG_EIP)})
u.hook_add(unicorn.UC_HOOK_MEM_READ,observe_retired)
def state(p):
 return {'state_id':read32(read32(p+0x44)+12),'flags':list(u.mem_read(p+4,3)),
         'thread_pair':[read32(p+8),read32(p+12)],'references':read32(0x2d78f10)}
cases=[]
try:
 for poison,mode,recording,stop_explicitly in itertools.product([0,165],[0,1],[0,1,256,257],[False,True]):
  network_profile['startup_code']=0;write32(0x2d78f04,0);write32(0x2d78f10,0)
  thread_events.clear();network_events.clear();native_entries.clear();host_failures.clear();start_entries.clear();retired_reads.clear();retired=False;resource_pointer=0;snapshot();baseline=set(live)
  stream=call(0x9933e0,0,[120]);call(0x8f6700,stream,[])
  key=heap+0xd000;host=heap+0xd100;u.mem_write(key,bytes(range(16)));u.mem_write(host,b'127.0.0.1\0')
  initial=snapshot();args=[0,1,0,key,host,12345,mode,0,0,0,recording]
  result=scheduled_call(0x8f68d0,stream,args);assert result==0
  opened=snapshot();opened_state=state(stream);resource_pointer=read32(stream+0x30)
  start_args=[0x12345678,0x87654321,42,19,20,21]
  code=scheduled_call(0x8f6af0,stream,start_args);assert code==(6 if mode==0 else 0),code
  started=snapshot();started_state=state(stream)
  repeated=scheduled_call(0x8f6af0,stream,start_args);assert repeated==8
  repeat_snapshot=snapshot();assert not repeat_snapshot['allocations'] and not repeat_snapshot['freed']
  if stop_explicitly:
   scheduled_call(0x8f6bc0,stream,[]);stopped=snapshot();stopped_state=state(stream)
   assert stopped_state['state_id']==3 and stopped_state['references']==0 and stopped_state['flags'][:2]==[1,0]
  else:stopped=None;stopped_state=None
  scheduled_call(0x8f67c0,stream,[1]);destroyed=snapshot();retired=bool(resource_pointer and resource_pointer in destroyed['freed'])
  assert read32(0x2d78f10)==0
  if read32(0x2d78ec4):call(0x901c00,0,[])
  shutdown=snapshot();retired=False
  assert set(live)==baseline and not retired_reads,{'remaining':sorted(set(live)-baseline),'retired_reads':retired_reads}
  cases.append({'fill':poison,'mode':mode,'recording_flag':recording,'stop_explicitly':stop_explicitly,'stream':stream,'arguments':args,'start_arguments':start_args,'start_code':code,'repeat_code':repeated,
   'initial':initial,'opened':opened,'opened_state':opened_state,'started':started,'started_state':started_state,'stopped':stopped,'stopped_state':stopped_state,'destroyed':destroyed,'shutdown':shutdown,
   'host_creation_failure_boundary':list(host_failures),'thread_events':list(thread_events),'native_entries':list(start_entries),'retired_resource_reads':list(retired_reads)})
 proof={'passed':True,'native_sha256':digest,'cases':cases,'limits':[
  'Thirty-two full native opening/start/repeated-start/stop/destruction lifetimes. Both explicit stop and active stream scalar deletion execute. No-op uses actual native start methods; derived start executes actual8F7060 with explicitly supplied host-creation failure8FD6A0 returning0, yielding code6 while still entering state4.',
  'Logical scheduling executes both real PE worker/CRT bodies on join; stream stop clears its run flag before its worker is first scheduled. No active polling or real Windows worker is proven here.',
  'Optional recording uses a null filename: actual resource/logger composite registration and teardown, no file creation or writes. Retired resource reads are instrumented during destruction and through logger shutdown.',
  'Successful network host, frame delivery, parent game manager ordering and concurrent stop remain unqualified. This supplied source-correct stop order is not proof of normal game integration.' ]}
except Exception as e:
 import traceback
 traceback.print_exc();proof={'passed':False,'native_sha256':digest,'cases_completed':len(cases),'error':repr(e),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'last_native_calls':call_trail[-16:],'last_windows_calls':windows_calls[-10:]}
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({k:v for k,v in proof.items() if k not in ['cases','limits']}))
if not proof['passed']:sys.exit(1)
