from pathlib import Path
import itertools,json,sys
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_replay_transport_threads.py').read_text().split('\nstream=call(')[0],'configuration prerequisites','exec'))
#8FC830 inlines the global mutex release. It needs the actual9941B0/994210
# owner-word updates, not the inherited lower-level mutex profile used elsewhere.
import types
original_boundaries=types.FunctionType(boundary.__code__,globals())
def qualified_boundaries(uc,address,size,user):
 if address in [0x9941b0,0x994210] and u.reg_read(UC_X86_REG_ECX)==0x2d6ed50:return
 return original_boundaries(uc,address,size,user)
boundary.__code__=qualified_boundaries.__code__
original_transport_windows=transport_windows
def transport_windows(dll,name,sp):
 if name=='InitializeCriticalSection' and read32(sp+4)==0x2d6ed58:
  assert 0x2d6ed58 not in initialized_locks;u.mem_write(0x2d6ed58,bytes(24));initialized_locks.add(0x2d6ed58);finish(pop=4);return True
 if name=='InterlockedExchange':
  pointer,value=read32(sp+4),read32(sp+8);old=read32(pointer);write32(pointer,value);finish(eax=old,pop=8);return True
 if name=='getaddrinfo':
  address,service,hints,output=[read32(sp+i) for i in range(4,20,4)]
  assert cbytes(address)==b'',('unsupported DNS query',cbytes(address))
  windows_calls[-1]['supplied_failure_profile']={'name':'','code':11001,'hints_words':[read32(hints+i*4) for i in range(8)]}
  write32(output,0);finish(eax=11001,pop=16);return True
 return original_transport_windows(dll,name,sp)
call(0x531a00,0,[]);snapshot()
cases=[]
hosts=[None,b'',b'A'*128,b'127.0.0.1',b'0.0.0.0']
try:
 for poison,host,port,start_error in itertools.product([0,165],hosts,[0,12345,65535],[0,10093]):
  network_profile['startup_code']=start_error
  write32(0x2d78f04,0);write32(0x2d78f10,0);thread_events.clear();network_events.clear();native_entries.clear();snapshot();before=set(live)
  pointer=call(0x9933e0,0,[224]);call(0x8fc230,pointer,[]);constructed=snapshot()
  address=heap+0xd100
  if host is not None:u.mem_write(address,host+b'\0')
  args=[0,0x11223344,0x55667788,0 if host is None else address,port]
  result=scheduled_call(0x8fc610,pointer,args);configured=snapshot();state={hex(p):read32(p) for p in [0x2d78f04,0x2d78f10,0x2d78ec4]}
  if read32(0x2d78f10):scheduled_call(0x8fc7b0,pointer,[])
  call(0x8fc2d0,pointer,[1]);destroyed=snapshot()
  if read32(0x2d78ec4):call(0x901c00,0,[])
  final=snapshot();assert set(live)==before, {'remaining': sorted(set(live)-before), 'removed_baseline': sorted(before-set(live))}
  cases.append({'fill':poison,'host_hex':None if host is None else host.hex(),'port':port,'supplied_wsa_startup_error':start_error,'object':pointer,'args':args,'return_code':result,'constructed':constructed,'configured':configured,'global_state_after_configuration':state,'destroyed':destroyed,'logger_shutdown':final,'thread_events':list(thread_events),'network_events':list(network_events),'native_entries':list(native_entries)})
 result={'passed':True,'native_sha256':digest,'cases':cases,'limits':['Native8FC230/8FC610/8FC2D0/8FC7B0 execute with actual lower PE32 functions and the established logical worker scheduler. OS clock/Winsock results are supplied profiles; numeric IPv4 formatting calls the real host read-only formatter. No network traffic.','Native531A00 initializes the global transport critical section before configuration. Native9941B0/994210 now execute for this global mutex, preserving its owner word needed by the inlined8FC830 release; other inherited mutex boundaries remain supplied.','Configuration callback is null. Cases cover two fills, null/empty/128-byte/numericIPv4 addresses, three16-bit ports and successful/failing WSAStartup. Empty-name getaddrinfo failure11001 is explicitly supplied, not a measured DNS outcome. Unknown imports fail explicitly.','Resource callbacks, successful DNS/IPv6 and allocation failures remain unqualified. Global transport teardown is explicit when a reference survives; logger shutdown is separately owned.']}
except Exception as e:
 import traceback
 traceback.print_exc()
 sp=u.reg_read(UC_X86_REG_ESP)
 print(json.dumps({'stack_return':hex(read32(sp)),'stack_arg1':hex(read32(sp+4)),'initialized_locks':[hex(v) for v in sorted(initialized_locks)]}))
 result={'passed':False,'native_sha256':digest,'cases_completed':len(cases),'error':repr(e),'failure_pc':hex(u.reg_read(UC_X86_REG_EIP)),'host':None if host is None else host.decode('ascii'),'port':port,'startup_error':start_error,'last_windows_calls':windows_calls[-12:],'last_native_calls':call_trail[-15:],'constructed':globals().get('constructed'),'configured':globals().get('configured'),'destroyed':globals().get('destroyed'),'final':globals().get('final'),'global_state':{hex(p):read32(p) for p in [0x2d78f04,0x2d78f10,0x2d78ec4]}}
Path(sys.argv[1]).write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps({k:v for k,v in result.items() if k not in ['cases','limits','constructed','configured','destroyed','final']}))
