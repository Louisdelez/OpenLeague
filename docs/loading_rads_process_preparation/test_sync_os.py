"""Real unnamed kernel owners. No native PE, waits, threads or ETW are run."""
from pathlib import Path
import sys,json,hashlib,ctypes
sys.dont_write_bytecode=True
import sync_os as s
from ctypes import wintypes as w
OUT=Path(__file__).resolve().parent
s.sig('GetHandleInformation',[w.HANDLE,ctypes.POINTER(w.DWORD)],w.BOOL)
class U:
    def reg_read(self,*a):return 100
class IO:last_error=0
params=[];returns=[];checks=[];error=None
m={'u':U(),'UC_X86_REG_ESP':0,'read32':lambda a:params[(a-104)//4],'finish':lambda *a:returns.append(a)}
owner=s.SyncOs(m,IO())
def check(n,v):assert v,n;checks.append(n)
def reject(n,f):
    try:f()
    except s.Rejected:checks.append(n);return
    raise AssertionError(n)
def valid(label):
    flags=w.DWORD();return s.K.GetHandleInformation(owner.handles[label]['raw'],ctypes.byref(flags))!=0 and flags.value==0
try:
    sem=owner.create('CreateSemaphoreA',[0,4,0x7fffffff,0]);check('real unnamed semaphore adopted',sem in owner.handles and valid(sem))
    events=[owner.create('CreateEventA',[0,1,0,0]) for _ in range(4)]
    check('four real unnamed events owned',all(p in owner.handles and valid(p) for p in events))
    check('five labels distinct',len({sem,*events})==5)
    check('semaphore independent of native wrapper adoption',len(owner.handles)==5 and owner.handles[sem]['state']=='owned')
    direct=s.K.CreateSemaphoreA(None,4,2,None);expected_error=ctypes.get_last_error()
    if direct:s.K.CloseHandle(direct)
    check('invalid count produces actual OS failure',not direct)
    before=len(owner.handles);got=owner.create('CreateSemaphoreA',[0,4,2,0])
    check('failed real create adds no owner',got==0 and owner.io.last_error==expected_error and len(owner.handles)==before)
    direct=s.K.CloseHandle(None);expected_error=ctypes.get_last_error();got=owner.close(0)
    check('CloseHandle null preserves real failure',got==direct==0 and owner.io.last_error==expected_error)
    check('real close releases just one owner',owner.close(events[0])!=0 and events[0] not in owner.handles and len(owner.handles)==4)
    reject('double close rejected before OS',lambda:owner.close(events[0]))
    reject('named semaphore rejected before OS',lambda:owner.create('CreateSemaphoreA',[0,4,5,1]))
    reject('inherited event rejected before OS',lambda:owner.create('CreateEventA',[1,1,0,0]))
    before=len(owner.handles)
    def failed_finish(*args):raise RuntimeError('injected guest return failure')
    m['finish']=failed_finish;params[:]=[0,1,0,0]
    try:owner.dispatch('CreateEventA')
    except RuntimeError:pass
    else:raise AssertionError('missing injected failure')
    check('OS owner survives guest return failure',len(owner.handles)==before+1 and all(valid(p) for p in owner.handles))
    m['finish']=lambda *args:returns.append(args)
    class FailedLog(list):
        def append(self,*args):raise RuntimeError('injected log allocation failure')
    prior=owner.events;owner.events=FailedLog();before=len(owner.handles)
    try:owner.create('CreateSemaphoreA',[0,4,0x7fffffff,0])
    except RuntimeError:pass
    else:raise AssertionError('missing injected log failure')
    owner.events=prior
    check('OS owner survives fallible logging',len(owner.handles)==before+1 and all(valid(p) for p in owner.handles))
    check('wait remains explicit unsupported boundary',owner.dispatch('WaitForSingleObject') is False)
except Exception as e:error=repr(e)
finally:
    cleanup=owner.cleanup()
    if error is None:check('all actual synchronization handles retired',not cleanup and not owner.handles)
    result={'passed':error is None and not owner.handles,'error':error,'cleanup_errors':cleanup,'remaining':len(owner.handles),
      'checks':checks,'check_count':len(checks),'native_execution':False,'events':owner.events,
      'limits':['CloseHandle failure for a valid owned handle is not injected. Native wrapper-allocation failure is not executed; independent host ownership is qualified.'],
      'source_hashes':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in [Path(__file__),OUT/'sync_os.py']}}
    (OUT/'sync_os_tests.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({'passed':result['passed'],'checks':len(checks),'error':error}))
if not result['passed']:raise SystemExit(1)
