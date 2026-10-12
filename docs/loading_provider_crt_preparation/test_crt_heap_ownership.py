"""Fault-injection checks for the Python bridge, not a native provider oracle."""
from pathlib import Path
import sys,json,hashlib,ctypes
sys.dont_write_bytecode=True
import crt_os as c
OUT=Path(__file__).resolve().parent
class Memory:
    def mem_map(self,*args):pass
    def reg_read(self,*args):return 100
    def mem_write(self,*args):pass
class IO:last_error=0
released=[]
def fail_allocate(n):raise RuntimeError('injected mirror allocation failure')
args={104:0x71000000,108:8,112:64}
m={'u':Memory(),'UC_X86_REG_ESP':0,'read32':lambda a:args[a],
   'write32':lambda a,v:None,'finish':lambda *a:None,'allocate':fail_allocate,'release':released.append}
crt=c.CrtOs(m,IO());actual=c.K;checks=[];error=None
def check(name,value):assert value,name;checks.append(name)
class FailFree:
    def __getattr__(self,name):return getattr(actual,name)
    def HeapFree(self,*args):ctypes.set_last_error(6);return 0
try:
    raw=actual.HeapAlloc(crt.heap,8,32);assert raw
    crt.heap_blocks[0x33000000]=raw
    c.K=FailFree()
    try:crt.heap_free(0x33000000)
    except OSError as e:check('failed HeapFree preserves actual error',e.winerror==6)
    else:raise AssertionError('failed HeapFree ignored')
    check('failed HeapFree retains host block and native mirror',crt.heap_blocks.get(0x33000000)==raw and released==[])
    c.K=actual;crt.heap_free(0x33000000)
    check('successful retry releases exactly once',not crt.heap_blocks and released==[0x33000000])
    try:crt.dispatch('HeapAlloc')
    except RuntimeError as e:check('mirror failure keeps primary error',str(e)=='injected mirror allocation failure')
    else:raise AssertionError('mirror allocation fault ignored')
    check('actual allocated raw block adopted by pending owner',len(crt.unadopted_heap_blocks)==1 and not crt.heap_blocks)
    c.K=FailFree();crt.release_host_backing()
    check('cleanup failure retains pending raw block',len(crt.unadopted_heap_blocks)==1)
    check('cleanup failure recorded as failure',crt.events[-1]['api']=='host_cleanup_unadopted_HeapFree' and not crt.events[-1]['success'])
    c.K=actual;crt.release_host_backing()
    check('cleanup retry releases pending allocation',not crt.unadopted_heap_blocks and crt.events[-1]['success'])
    crt.release_host_backing()
    check('repeated cleanup remains empty',not crt.unadopted_heap_blocks and not crt.heap_blocks)
except Exception as e:error=repr(e)
finally:
    c.K=actual;crt.release_host_backing()
    result={'passed':error is None,'check_count':len(checks),'checks':checks,'error':error,
            'remaining_heap_backing':len(crt.heap_blocks)+len(crt.unadopted_heap_blocks),'events':crt.events,
            'scope':'Bridge fault injection with actual process-heap blocks. Failed HeapFree and mirror failure are deliberately injected; no native provider result is simulated.',
            'source_hashes':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in [Path(__file__),OUT/'crt_os.py']}}
    (OUT/'crt_heap_ownership_tests.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({'passed':result['passed'],'checks':len(checks),'error':error}))
if error:raise SystemExit(1)
