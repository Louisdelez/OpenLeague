from pathlib import Path
import itertools,json,sys
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_replay_transport_configuration.py').read_text().split('\ncases=[]')[0],'derived configuration prerequisites','exec'))
cases=[];logs=[]
def capture_log(uc,pc,size,user):
 if pc==0x8f92b0:
  sp=u.reg_read(UC_X86_REG_ESP);message,source,line=[read32(sp+i) for i in [4,8,12]];logs.append({'message':cbytes(message).decode('ascii'),'source':cbytes(source).decode('ascii') if source else None,'line':line})
u.hook_add(unicorn.UC_HOOK_CODE,capture_log)
try:
 for poison,host,start_error,has_callback in itertools.product([0,165],[None,b'127.0.0.1',b'98.24.0.44'],[0,10093],[False,True]):
  network_profile['startup_code']=start_error;write32(0x2d78f04,0);write32(0x2d78f10,0);logs.clear();network_events.clear();snapshot();before=set(live)
  p=call(0x9933e0,0,[0x918]);call(0x8f6d00,p,[]);incoming=0
  if has_callback:
   incoming=call(0x9933e0,0,[12]);u.mem_write(incoming,struct.pack('<3I',0x1086078,0x44000000,0x728e20))
  key=bytes(range(16));kp=heap+0xe000;hp=heap+0xe100;u.mem_write(kp,key)
  if host is not None:u.mem_write(hp,host+b'\0')
  prepared=snapshot();args=[incoming,0x11223344,0x55667788,kp,0 if host is None else hp,0xabcdffff,0x1ff,0x88776655]
  result=scheduled_call(0x8f6eb0,p+0xe0,args);configured=snapshot();state={hex(a):read32(a) for a in [0x2d78f04,0x2d78f10,0x2d78ec4]};configured_logs=list(logs);logs.clear()
  if read32(0x2d78f10):scheduled_call(0x8f6fa0,p,[])
  closed=snapshot();closed_logs=list(logs);logs.clear();call(0x8f6d90,p,[1]);destroyed=snapshot()
  if read32(0x2d78ec4):call(0x901c00,0,[])
  shutdown=snapshot();assert set(live)==before
  cases.append({'fill':poison,'host_hex':None if host is None else host.hex(),'startup_error':start_error,'has_callback':has_callback,'object':p,'incoming':incoming,'key_hex':key.hex(),'args':args,'prepared':prepared,'return_code':result,'configured':configured,'configuration_globals':state,'configuration_logs':configured_logs,'closed':closed,'close_logs':closed_logs,'destroyed':destroyed,'shutdown':shutdown,'network_events':list(network_events)})
 result={'passed':True,'native_sha256':digest,'cases':cases,'limits':['Actual2328-byte derived constructor,8F6EB0 key creation and configuration delegation,8F6FA0 virtual close and scalar destructor execute with real98F710 key schedule and the established logical worker scheduler.24 profiles cover fill0/A5, null/numeric/CRC-zero addresses, successful/failing WSAStartup and owned callback presence.','Windows startup results and clock/allocator primitives are supplied; numeric address formatting is actual local Windows. No active host is created, no packet is transmitted and callback members are not invoked.']}
except Exception as e:
 import traceback
 traceback.print_exc();result={'passed':False,'native_sha256':digest,'cases_completed':len(cases),'error':repr(e),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'last_calls':call_trail[-12:]}
Path(sys.argv[1]).write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8');print(json.dumps({k:v for k,v in result.items() if k not in ['cases','limits']}))
if not result['passed']:sys.exit(1)
