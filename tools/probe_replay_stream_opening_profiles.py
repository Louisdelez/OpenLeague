from pathlib import Path
import itertools,json,sys
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_replay_transport_configuration.py').read_text().split('\ncases=[]')[0],'stream opening with real source worker prerequisites','exec'))
cases=[]
try:
 for poison,mode,host,has_callback in itertools.product([0,165],[0,1],[None,b'127.0.0.1',b'98.24.0.44'],[False,True]):
  network_profile['startup_code']=0;write32(0x2d78f04,0);write32(0x2d78f10,0);thread_events.clear();network_events.clear();native_entries.clear();snapshot();baseline=set(live)
  stream=call(0x9933e0,0,[120]);call(0x8f6700,stream,[]);incoming=0
  if has_callback:
   incoming=call(0x9933e0,0,[12]);u.mem_write(incoming,struct.pack('<3I',0x1086078,0x44000000,0x728e20))
  key=heap+0xd000;address=heap+0xd100;u.mem_write(key,bytes(range(16)))
  if host is not None:u.mem_write(address,host+b'\0')
  args=[incoming,0x11223344,0x55667788,key,0 if host is None else address,65535,mode,0x88776655,0,0,0]
  initial=snapshot();code=scheduled_call(0x8f68d0,stream,args);opened=snapshot()
  state={'state_id':read32(read32(stream+0x44)+12),'implementation':[read32(stream+0x64),read32(stream+0x68)],'manager':[read32(stream+0x6c),read32(stream+0x70)],'references':read32(0x2d78f10)}
  scheduled_call(0x8f67c0,stream,[1]);destroyed=snapshot()
  if read32(0x2d78f10):scheduled_call(0x8fc500,0,[])
  if read32(0x2d78ec4):call(0x901c00,0,[])
  final=snapshot();assert set(live)==baseline,{'remaining':sorted(set(live)-baseline),'removed_baseline':sorted(baseline-set(live))}
  cases.append({'fill':poison,'mode':mode,'host_hex':None if host is None else host.hex(),'has_callback':has_callback,'stream':stream,'arguments':args,'initial':initial,'return_code':code,'state':state,'opened':opened,'destroyed':destroyed,'shutdown':final,'thread_events':list(thread_events),'network_events':list(network_events)})
 proof={'passed':True,'native_sha256':digest,'cases':cases,'limits':['Actual8F68D0 uses original8FB650 with recording disabled and empty metadata pair, selects/configures actual derived or16-byte implementation, constructs/publishes the manager and delivers the initial state event. Actual startup/worker/close source executes in the logical worker scheduler.24 profiles cover two fills, both implementations, callback presence and null/numeric/CRC-zero host.','OS primitives are supplied boundaries. No files, active network hosts, replay packets or callback member invocation are exercised. Native global transport reference and logger are explicitly released after stream destruction; preparation recording/file branch remains unqualified.']}
except Exception as e:
 import traceback
 traceback.print_exc();proof={'passed':False,'native_sha256':digest,'cases_completed':len(cases),'error':repr(e),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'last_native_calls':call_trail[-12:]}
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({k:v for k,v in proof.items() if k not in ['cases','limits']}))
if not proof['passed']:sys.exit(1)
