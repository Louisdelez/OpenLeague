from pathlib import Path
import itertools,json,sys
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_replay_transport_configuration.py').read_text().split('\ncases=[]')[0],'recording preparation prerequisites','exec'))
cases=[]
try:
 for poison,mode,recording in itertools.product([0,165],[0,1],[0,1,256,257]):
  network_profile['startup_code']=0;write32(0x2d78f04,0);write32(0x2d78f10,0);thread_events.clear();network_events.clear();native_entries.clear();snapshot();baseline=set(live)
  stream=call(0x9933e0,0,[120]);call(0x8f6700,stream,[]);key=heap+0xd000;host=heap+0xd100;u.mem_write(key,bytes(range(16)));u.mem_write(host,b'127.0.0.1\0')
  args=[0,1,0,key,host,12345,mode,0,0,0,recording];initial=snapshot();result=scheduled_call(0x8f68d0,stream,args);opened=snapshot()
  state={'resource':[read32(stream+0x30),read32(stream+0x34)],'metadata':[read32(stream+0x38),read32(stream+0x3c)],'state_id':read32(read32(stream+0x44)+12),'references':read32(0x2d78f10),'logger':read32(0x2d78ec4)}
  scheduled_call(0x8f67c0,stream,[1]);destroyed=snapshot()
  if read32(0x2d78f10):scheduled_call(0x8fc500,0,[])
  if read32(0x2d78ec4):call(0x901c00,0,[])
  shutdown=snapshot();assert set(live)==baseline,{'remaining':sorted(set(live)-baseline),'removed_baseline':sorted(baseline-set(live))}
  cases.append({'fill':poison,'mode':mode,'recording_flag':recording,'stream':stream,'args':args,'return_code':result,'initial':initial,'opened':opened,'state':state,'destroyed':destroyed,'shutdown':shutdown})
 proof={'passed':True,'native_sha256':digest,'cases':cases,'limits':['Actual8FB650 resource preparation runs within8F68D0.16 profiles include recording low-byte0/1/256/257, both implementations and two memory fills, with null file path. Source resource/logger registration, teardown and stream lifetimes execute without replacing helpers.','No filename is supplied and no file is created. Primitive OS/CRT boundaries and logical worker scheduler are supplied. File creation/writes, nonempty paths and actual Windows resource/log callback integration remain unqualified.']}
except Exception as e:
 import traceback
 traceback.print_exc();proof={'passed':False,'native_sha256':digest,'cases_completed':len(cases),'error':repr(e),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'last_native_calls':call_trail[-16:],'last_windows_calls':windows_calls[-8:]}
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({k:v for k,v in proof.items() if k not in ['cases','limits']}))
if not proof['passed']:sys.exit(1)
