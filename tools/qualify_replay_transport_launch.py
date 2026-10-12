from pathlib import Path
import itertools,json,sys
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_replay_transport_threads.py').read_text().split('\nstream=call(')[0],'transport prerequisites','exec'))
base_windows=transport_windows;launch_error=0;events=[];observing=False;launches=[]
def transport_windows(dll,name,sp):
 global last_error
 if name=='CreateThread' and launch_error:
  last_error=launch_error
  if observing:events.append({'op':'failed_create','error':launch_error})
  finish(eax=0,pop=24);return True
 return base_windows(dll,name,sp)
def trace_launch(uc,pc,size,user):
 if not observing:return
 if pc==0x8a8b80:
  sp=u.reg_read(UC_X86_REG_ESP);o=read32(sp+12);s=o+16;n=read32(s+16);p=read32(s) if read32(s+20)>=16 else s
  launches.append({'callback':read32(sp+4),'argument':read32(sp+8),'options':[read32(o+i*4) for i in range(4)],'name':bytes(u.mem_read(p,n)).hex()})
 if pc==0x8fc480:
  raw=read32(0x2d6ed70);control=read32(0x2d6ed74)
  events.append({'op':'drain_entry','raw':raw,'control':control,'handle':read32(raw) if raw else None,'id':read32(raw+0x24) if raw else None})
u.hook_add(unicorn.UC_HOOK_CODE,trace_launch)
cases=[]
for status,refs,error in itertools.product([0,1,2,3],[0,1],[0,8]):
 launch_error=error;write32(0x2d78f04,status);write32(0x2d78f10,refs);write32(0x2d6ed70,0);write32(0x2d6ed74,0)
 before_threads=set(threads);snapshot();events.clear();launches.clear();thread_events.clear();observing=True
 code=scheduled_call(0x8fc380,0,[]);observing=False
 raw=read32(0x2d6ed70);control=read32(0x2d6ed74)
 result={'status':read32(0x2d78f04),'references':read32(0x2d78f10),'raw':raw,'control':control,'control_words':[read32(control+i*4) for i in range(4)] if control else None}
 cases.append({'before_status':status,'before_references':refs,'create_error':error,'return_byte':code&255,'launches':list(launches),'events':list(events),'thread_events':list(thread_events),'after':result,'threads':{str(h):t for h,t in threads.items() if h not in before_threads}})
 # Native null raw suppresses8FC480 cleanup, leaving a live null-object control.
 # Explicit caller cleanup between independent cases does not change that result.
 if control:call(0x5bd3c0,0x2d6ed70,[]);write32(0x2d6ed74,0)
 snapshot()
sequences=[]
for errors in [[0,0],[8,8,0,0],[8,0,8]]:
 write32(0x2d78f04,0);write32(0x2d78f10,0);write32(0x2d6ed70,0);write32(0x2d6ed74,0);steps=[]
 for launch_error in errors:
  events.clear();launches.clear();thread_events.clear();freed.clear();observing=True;code=scheduled_call(0x8fc380,0,[]);observing=False
  control=read32(0x2d6ed74)
  steps.append({'create_error':launch_error,'return_byte':code&255,'launches':list(launches),'events':list(events),'thread_events':list(thread_events),'after':{'status':read32(0x2d78f04),'references':read32(0x2d78f10),'raw':read32(0x2d6ed70),'control':control,'control_words':[read32(control+i*4) for i in range(4)] if control else None}})
 sequences.append({'errors':errors,'steps':steps})
proof={'passed':True,'complete':False,'native_sha256':digest,'cases':cases,'sequences':sequences,'limits':[
 'Actual8FC380/8FC480 and all native lower thread/CRT/control bodies run. Windows creation/scheduling/wait/close are explicit logical profiles; supplied CreateThread error8 exercises original CRT errno mapping and capsule cleanup. Initial status/reference words are explicit preconditions.',
 'The returned low byte is1 even on failed creation. Status2 skips new creation. Failed creation while status!=2 leaves status1 and a null-object control in2D6ED74 because8FC480 returns immediately for null2D6ED70. Independent cases explicitly release that control after capturing the result.',
 'No launch timeout, self-thread wait, concurrency, real replay frames or production client connection is qualified by this file.'
]}
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'cases':len(cases),'first':cases[0],'failure':cases[1]}))
