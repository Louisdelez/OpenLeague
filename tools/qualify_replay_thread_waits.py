from pathlib import Path
import itertools,json,sys
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_replay_transport_threads.py').read_text().split('\nstream=call(')[0],'transport prerequisites','exec'))
windows_original=transport_windows;events=[];observing=False;waits=[];close_result=1;close_error=0
thread=0;control=0;watched=set()
def transport_windows(dll,name,sp):
 global last_error
 if name=='GetCurrentThreadId':
  if observing:events.append({'op':'current_thread','value':1})
  finish(eax=1);return True
 if name=='WaitForSingleObject':
  assert waits,'unexpected wait';value,error=waits.pop(0);last_error=error
  if observing:events.append({'op':'wait','handle':read32(sp+4),'timeout':read32(sp+8),'result':value})
  finish(eax=value,pop=8);return True
 if name=='CloseHandle':
  last_error=close_error
  if observing:events.append({'op':'close','handle':read32(sp+4),'result':close_result})
  finish(eax=close_result,pop=4);return True
 if name=='GetLastError':
  if observing:events.append({'op':'last_error','value':last_error})
  finish(eax=last_error);return True
 return windows_original(dll,name,sp)
def observe(uc,pc,size,user):
 if observing and pc in [0x9941b0,0x994210]:events.append({'op':'lock' if pc==0x9941b0 else 'unlock','address':u.reg_read(UC_X86_REG_ECX)})
def write(uc,access,address,size,value,user):
 if observing and address in watched:
  assert size==4;events.append({'op':'write','address':address,'value':value&0xffffffff})
u.hook_add(unicorn.UC_HOOK_CODE,observe);u.hook_add(unicorn.UC_HOOK_MEM_WRITE,write)
pair=heap+0xe000;options=heap+0xe100
u.mem_write(options,bytes(40));write32(options+36,15)
wait_profiles=[[[0,0],[0,0]],[[0,0],[258,0]],[[0,0],[0xffffffff,6]],[[258,0]],[[0xffffffff,6]],[[0xffffffff,5]],[[128,0]]]
cases=[]
for operation,handle,own_thread,profile,close in itertools.product(['wait','join','apply_wait','apply_close','drain'],[0,0x73000000],[False,True],wait_profiles,[(1,0),(0,6),(0,5)]):
 observing=False;thread=call(0x9933e0,0,[80]);write32(pair,handle);write32(pair+4,1 if own_thread else 2);call(0x8a8d40,thread,[pair,options])
 write32(0x2d6ed70,0);write32(0x2d6ed74,0)
 control=0
 if operation=='drain':call(0x5d23c0,0x2d6ed70,[thread]);control=read32(0x2d6ed74)
 before=[read32(thread+i*4) for i in range(20)];before_control=[read32(control+i*4) for i in range(4)] if control else None
 watched={thread,thread+0x24,0x2d6ed70,0x2d6ed74}
 if control:watched.update([control,control+4,control+8])
 waits=[p.copy() for p in profile];close_result,close_error=close;events.clear();freed.clear();observing=True
 if operation=='wait':result=call(0x8a9240,thread,[9000])
 elif operation=='join':result=call(0x8a8c50,thread,[9000])
 elif operation=='apply_wait':result=call(0x8a8df0,thread,[0x8a9190])
 elif operation=='apply_close':result=call(0x8a8df0,thread,[0x8a9210])
 else:call(0x8fc480,0,[]);result=None
 observing=False
 cases.append({'operation':operation,'handle':handle,'own_thread':own_thread,'wait_profile':profile,'close_profile':list(close),'thread':thread,'control':control,'before':before,'before_control':before_control,'result':result,'events':list(events),'freed':list(freed),'after':None if thread in freed else [read32(thread+i*4) for i in range(20)],'after_control':None if not control or control in freed else [read32(control+i*4) for i in range(4)],'pair_after':[read32(0x2d6ed70),read32(0x2d6ed74)]})
 # Independent fixture cleanup; dispose refuses no handles and is outside traces.
 if thread not in freed:write32(thread,0);call(0x5d51c0,thread,[1])
 if control and control not in freed:raise AssertionError('unexpected retained control')
 allocations.clear();freed.clear()
proof={'passed':True,'complete':False,'native_sha256':digest,'cases':cases,'limits':[
 '420 actual native wait/join/apply/drain cases execute8A9240/8A8C50/8A8DF0/8A9190/8A9210/8FC480, with actual80-byte thread construction8A8D40,16-byte control5D23C0, disposal5D6740/5D51C0 and control deletion. Windows outcomes are supplied; engine mutex calls remain normal-return boundaries.',
 'Explicit handle0/nonzero and same/other-thread preconditions combine7 wait sequences and3 close profiles. Full thread/control words, relevant writes, double lock scope, last-error reads, close calls and ordered frees are captured. No real worker executes in this fixture; caller cleanup between cases is excluded from assertions.'
]}
assert len(cases)==420
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'cases':len(cases),'drain_timeout':next(c for c in cases if c['operation']=='drain' and not c['own_thread'] and c['handle'] and c['wait_profile'][0][0]==258 and c['close_profile']==[1,0])}))
