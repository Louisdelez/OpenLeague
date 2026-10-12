from pathlib import Path
import collections,json,struct,sys
r=Path('E:/OpenLeague')
base_source=(r/'tools/probe_whole_announcer_startup.py').read_text().split('\npoison=165;cursor=arena;')[0]
anchor='dll,name=imports[address];sp=u.reg_read(UC_X86_REG_ESP);windows_calls.append({"dll":dll,"function":name})'
assert base_source.count(anchor)==1
base_source=base_source.replace(anchor,anchor+'\n if transport_windows(dll,name,sp):return')
threads={};current_thread=1;tls={1:0x3000b000};pending_wait=None;thread_exit=None;thread_events=[];native_entries=[];pending_name_exception=None
network_profile={'startup_code':0,'version':0x202,'cleanup_code':0,'begin_code':0,'end_code':0};network_events=[]

def transport_windows(dll,name,sp):
 global last_error,pending_wait,thread_exit,pending_name_exception
 if name=='GetCurrentThreadId':finish(eax=current_thread);return True
 if name=='InitializeCriticalSection' and read32(sp+4)==0x2d78ed8:
  reference=read32(sp+4);assert reference not in initialized_locks;u.mem_write(reference,bytes(24));initialized_locks.add(reference);finish(pop=4);return True
 if name=='TlsGetValue':
  assert read32(sp+4)==5;last_error=0;finish(eax=tls.get(current_thread,0),pop=4);return True
 if name=='TlsSetValue':
  assert read32(sp+4)==5;tls[current_thread]=read32(sp+8);finish(eax=1,pop=8);return True
 if name=='CreateThread':
  args=[read32(sp+i) for i in range(4,28,4)];security,stack_size,entry,argument,flags,id_output=args
  assert security==0 and stack_size==0 and entry==0xc9c3dc and flags==0
  tid=len(threads)+2;handle=0x73000000+tid
  threads[handle]={'id':tid,'entry':entry,'argument':argument,'done':False,'closed':False,'code':None}
  if id_output:write32(id_output,tid)
  thread_events.append({'op':'create','handle':handle,'thread':tid,'arguments':args,'callback':read32(argument+0x54),'callback_argument':read32(argument+0x58)})
  finish(eax=handle,pop=24);return True
 if name=='WaitForSingleObject':
  handle,timeout=read32(sp+4),read32(sp+8);assert handle in threads
  if not threads[handle]['done']:
   assert current_thread==1 and timeout!=0;pending_wait=(handle,timeout);u.emu_stop();return True
  thread_events.append({'op':'wait','handle':handle,'timeout':timeout,'result':0});finish(eax=0,pop=8);return True
 if name=='CloseHandle' and read32(sp+4) in threads:
  handle=read32(sp+4);assert threads[handle]['done'] and not threads[handle]['closed'];threads[handle]['closed']=True;thread_events.append({'op':'close','handle':handle});finish(eax=1,pop=4);return True
 if name=='GetExitCodeThread':
  handle,output=read32(sp+4),read32(sp+8);assert handle in threads;write32(output,threads[handle]['code'] if threads[handle]['done'] else 259);finish(eax=1,pop=8);return True
 if name=='ExitThread':
  assert current_thread!=1;thread_exit=read32(sp+4);thread_events.append({'op':'exit','thread':current_thread,'code':thread_exit,'tls':tls.get(current_thread,0)});u.emu_stop();return True
 if name=='IsDebuggerPresent':finish(eax=0);return True
 if name=='RaiseException':
  code,flags,count,arguments=[read32(sp+i) for i in range(4,20,4)]
  assert (code,flags,count)==(0x406d1388,0,4)
  values=[read32(arguments+i*4) for i in range(count)];assert values[0]==0x1000 and values[2:]==[0xffffffff,0]
  frame=read32(0);table=read32(frame+8)^read32(0x1222ed0)
  assert read32(frame+4)==0xca2a90 and read32(frame+12)==0 and table==0x11a0c38
  scope=[read32(table+i) for i in range(16,28,4)];assert scope==[0xfffffffe,0x8a9307,0x8a930d]
  pending_name_exception=(scope[1],scope[2]);thread_events.append({'op':'thread_name_exception','thread':current_thread,'name':cbytes(values[1]).decode('ascii'),'filter':scope[1],'handler':scope[2]});u.emu_stop();return True
 if name=='WSAStartup':
  version,output=read32(sp+4),read32(sp+8);assert version==0x202;u.mem_write(output,bytes(400));write32(output,network_profile['version']);network_events.append({'op':name,'version':version});finish(eax=network_profile['startup_code'],pop=8);return True
 if name=='WSACleanup':network_events.append({'op':name});finish(eax=network_profile['cleanup_code']);return True
 if name in ['htons','ntohs']:
  value=read32(sp+4)&0xffff;finish(eax=((value&255)<<8)|(value>>8),pop=4);return True
 if name=='inet_addr':
  import ipaddress
  value=int.from_bytes(ipaddress.IPv4Address(cbytes(read32(sp+4)).decode('ascii')).packed,'little');finish(eax=value,pop=4);return True
 if name=='WSAAddressToStringA':
  import ctypes
  address,length,protocol,output,capacity=[read32(sp+i) for i in range(4,24,4)];assert length==16 and protocol==0
  fn=ctypes.windll.ws2_32.WSAAddressToStringA;fn.argtypes=[ctypes.c_void_p,ctypes.c_uint32,ctypes.c_void_p,ctypes.c_void_p,ctypes.POINTER(ctypes.c_uint32)];fn.restype=ctypes.c_int
  data=(ctypes.c_ubyte*512)();assert ctypes.windll.ws2_32.WSAStartup(0x202,ctypes.byref(data))==0
  try:
   source=(ctypes.c_ubyte*length).from_buffer_copy(bytes(u.mem_read(address,length)));size=ctypes.c_uint32(read32(capacity));buffer=(ctypes.c_ubyte*size.value)();code=fn(source,length,None,buffer,ctypes.byref(size));assert code==0,('WSAAddressToStringA',ctypes.windll.ws2_32.WSAGetLastError())
  finally:assert ctypes.windll.ws2_32.WSACleanup()==0
  u.mem_write(output,bytes(buffer)[:size.value]);write32(capacity,size.value);windows_calls[-1]['observed_host_output']=bytes(buffer)[:size.value].hex();finish(eax=code,pop=20);return True
 if name in ['timeBeginPeriod','timeEndPeriod']:
  assert read32(sp+4)==1;network_events.append({'op':name,'period':1});finish(eax=network_profile['begin_code' if name=='timeBeginPeriod' else 'end_code'],pop=4);return True
 if name in ['timeGetTime','GetTickCount']:finish(eax=123456);return True
 return False

exec(compile(base_source,'replay transport startup prerequisites','exec'))
poison=0;cursor=arena;fail=False;write32(0x14bef40,0);write32(0x14bef58,0);u.mem_write(0x2d77b20,b'\1')
call(0xc9a0b9,0,[]);write32(0x2da5308,read32(0x1222ed0))
u.mem_map(0x35000000,0x10000)
def observe_native(uc,pc,size,user):
 if pc in [0xc9c3dc,0xc9c439,0xc9c315,0x8a8f90,0x8fc100,0x900e00,0xc9c356,0x8fc610,0x8fc930,0x8fca30]:native_entries.append({'entry':hex(pc),'thread':current_thread})
u.hook_add(unicorn.UC_HOOK_CODE,observe_native)

def run_worker(handle):
 global current_thread,last_error,thread_exit,pending_name_exception
 worker=threads[handle];parent=u.context_save();parent_seh=read32(0);parent_error=last_error
 current_thread=worker['id'];last_error=0;thread_exit=None;write32(0,0xffffffff)
 sp=0x3500e000;write32(sp,end);write32(sp+4,worker['argument']);u.reg_write(UC_X86_REG_ESP,sp)
 try:
  pc=worker['entry']
  for _ in range(4):
   pending_name_exception=None;u.emu_start(pc,end,count=2000000)
   if pending_name_exception is None:break
   filter_entry,handler=pending_name_exception;context=u.context_save();filter_sp=0x35008000;write32(filter_sp,end);u.reg_write(UC_X86_REG_ESP,filter_sp)
   u.emu_start(filter_entry,end,count=100);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)==1
   u.context_restore(context);pc=handler
  assert thread_exit is not None,'worker did not reach ExitThread: '+hex(u.reg_read(UC_X86_REG_EIP))
  worker['done']=True;worker['code']=thread_exit
 finally:
  worker['last_pc']=hex(u.reg_read(UC_X86_REG_EIP));current_thread=1;last_error=parent_error;write32(0,parent_seh);u.context_restore(parent)

def scheduled_call(entry,this,args):
 global pending_wait
 sp=stack+0xe000;u.mem_write(sp,struct.pack('<'+'I'*(len(args)+1),end,*args));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,this);pc=entry
 for _ in range(12):
  pending_wait=None;u.emu_start(pc,end,count=2000000)
  if pending_wait is not None:
   handle,timeout=pending_wait;run_worker(handle)
   thread_events.append({'op':'wait','handle':handle,'timeout':timeout,'result':0});finish(eax=0,pop=8);pc=u.reg_read(UC_X86_REG_EIP);continue
  assert u.reg_read(UC_X86_REG_EIP)==end,'nonterminal instruction limit at '+hex(u.reg_read(UC_X86_REG_EIP));return u.reg_read(UC_X86_REG_EAX)
 raise RuntimeError('too many scheduler yields')

live={}
def snapshot():
 for a in allocations:
  if a['pointer']:live[a['pointer']]=a['bytes']
 for p in freed:live.pop(p,None)
 result={'allocations':list(allocations),'freed':list(freed),'words':[[p+i,read32(p+i)] for p,n in sorted(live.items()) for i in range(0,n-(n%4),4)]}
 allocations.clear();freed.clear();return result
assert call(0xcb0378,0,[])==1;assert call(0xcaff53,0,[])==0
prerequisites=snapshot();baseline=set(live)
stream=call(0x9933e0,0,[120]);call(0x8f6700,stream,[]);initial=snapshot()
key=heap+0xd000;host=heap+0xd100;u.mem_write(key,bytes(16));u.mem_write(host,b'127.0.0.1\0');args=[0,1,0,key,host,12345,0,0,0,0,0]
result={'native_sha256':digest,'complete':False,'stream':stream,'arguments':args,'prerequisites':prerequisites,'initial':initial}
try:
 code=scheduled_call(0x8f68d0,stream,args);result.update({'returned':True,'return_code':code,'state_id':read32(read32(stream+0x44)+12),'opened':snapshot()})
 scheduled_call(0x8f67c0,stream,[1]);result['destroyed']=snapshot();result['after_stream_destroy_globals']={hex(p):read32(p) for p in [0x2d78f04,0x2d78f10]}
 scheduled_call(0x8fc500,0,[]);scheduled_call(0x901c00,0,[]);result['global_shutdown']=snapshot();result['new_allocations_remaining']=[p for p in live if p not in baseline]
except Exception as error:
 result.update({'returned':False,'error':str(error),'exception_type':type(error).__name__,'failure_pc':hex(u.reg_read(UC_X86_REG_EIP)),'last_windows_calls':windows_calls[-12:],'last_native_calls':call_trail[-15:],'partial':snapshot()})
result.update({'threads':threads,'thread_events':thread_events,'network_events':network_events,'native_entries':native_entries,'tls':tls,'global_state':{hex(p):read32(p) for p in [0x2d78f04,0x2d78f10,0x1225878,0x122587c]}})
result['limits']=['Actual PE32 worker entry, callback, transport startup and teardown execute on an emulated child stack when its parent joins. CreateThread/Wait/Exit are explicit logical scheduling boundaries; no physical host thread or network traffic is claimed.','The naming RaiseException boundary validates the exact active EH4 registration, decoded scope table and exception arguments, executes native filter8A9307, then transfers to native handler8A930D. General Windows exception dispatch and unwind are not emulated.','Winsock2.2 success, fixed clock and timer outcomes are supplied Windows profiles. Address formatting is measured with the real read-only WSAAddressToStringA and a balanced host Winsock reference. Other unknown imports raise. Parent CPU/SEH/error state and separate per-thread TLS are preserved. Resource I/O and real replay content remain unqualified.','Explicit8FC500 global release and901C00 registered logger shutdown follow stream destruction. Stream destruction alone keeps the global Winsock reference and logger alive. This qualifies one supplied numeric IPv4 configuration, not replay playback.']
Path(sys.argv[1]).write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps({k:v for k,v in result.items() if k not in ['prerequisites','initial','opened','destroyed','global_shutdown','partial','limits']}))
