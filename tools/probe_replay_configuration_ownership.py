from pathlib import Path
import itertools,json,sys
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_replay_transport_configuration.py').read_text().split('\ncases=[]')[0],'configuration ownership prerequisites','exec'))
logs=[]
def observe_config(uc,pc,size,user):
 if pc==0x8f92b0:
  sp=u.reg_read(UC_X86_REG_ESP);msg,src,line=[read32(sp+i) for i in [4,8,12]]
  logs.append({'message':cbytes(msg).decode('ascii'),'source':cbytes(src).decode('ascii') if src else None,'line':line})
u.hook_add(unicorn.UC_HOOK_CODE,observe_config)
def new_callback(owner,method):
 p=call(0x9933e0,0,[12])
 for i,v in enumerate([0x1086078,owner,method]):write32(p+4*i,v)
 return p
def narrow_snapshot():
 return {'snapshot':snapshot(),'uid_scratch_hex':bytes(u.mem_read(0x2d8dd58,128)).hex(),'validation_scratch_hex':bytes(u.mem_read(0x2d8ddd8,16)).hex(),'logs':list(logs),'clock':read32(0x2d78ec8),'global_state':{hex(p):read32(p) for p in [0x2d78f04,0x2d78f10,0x2d78ec4]}}
cases=[]
try:
 for poison,host,error,has_old in itertools.product([0,165],[None,b'A'*128,b'127.0.0.1',b'98.24.0.44'],[0,10093],[False,True]):
  network_profile['startup_code']=error
  write32(0x2d78f04,0);write32(0x2d78f10,0);write32(0x2d78ec8,0xdeadbeef)
  for p,n in [(0x2d8dd58,128),(0x2d8ddd8,16)]:u.mem_write(p,bytes([poison])*n)
  logs.clear();network_events.clear();snapshot();baseline=set(live)
  obj=call(0x9933e0,0,[224]);call(0x8fc230,obj,[])
  old=new_callback(0x41000000,0x728e20) if has_old else 0;write32(obj+0xdc,old)
  incoming=new_callback(0x42000000,0x728fd0)
  prepared=narrow_snapshot();logs.clear()
  hp=heap+0xd100
  if host is not None:u.mem_write(hp,host+b'\0')
  result=scheduled_call(0x8fc610,obj,[incoming,0x11223344,0x55667788,0 if host is None else hp,0x1234ffff])
  configured=narrow_snapshot();logs.clear()
  if read32(0x2d78f10):scheduled_call(0x8fc7b0,obj,[])
  call(0x8fc2d0,obj,[1]);destroyed=narrow_snapshot();logs.clear()
  if read32(0x2d78ec4):call(0x901c00,0,[])
  shutdown=narrow_snapshot();logs.clear();assert set(live)==baseline
  cases.append({'fill':poison,'host_hex':None if host is None else host.hex(),'port':0x1234ffff,'startup_error':error,'has_old':has_old,'object':obj,'old':old,'incoming':incoming,'prepared':prepared,'configured':configured,'destroyed':destroyed,'shutdown':shutdown,'return_code':result,'network_events':list(network_events)})
 result={'passed':True,'native_sha256':digest,'cases':cases,'limits':['The actual PE32 constructor/configuration/clone/scalar destructors/logger/transport startup and release execute under the established logical-worker scheduler. The supplied callbacks are real12-byte5CCDC0/578010 wrappers with non-invoked member pointers.','Windows startup results, clocks, locks and allocation addresses are supplied boundaries; numeric formatting calls the actual local Windows API. No replay frame transmission is exercised.','32 combinations cover two fills, four host values, startup success/failure, existing callback presence and a32-bit port whose low16bits are65535. Existing60-profile fixture additionally covers empty-name supplied DNS failure.']}
except Exception as e:
 import traceback
 traceback.print_exc()
 result={'passed':False,'native_sha256':digest,'cases_completed':len(cases),'error':repr(e),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'last_calls':call_trail[-12:]}
Path(sys.argv[1]).write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps({k:v for k,v in result.items() if k not in ['cases','limits']}))
if not result['passed']:sys.exit(1)
