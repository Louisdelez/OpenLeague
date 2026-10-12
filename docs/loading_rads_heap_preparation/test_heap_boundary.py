"""Real CrtOs dispatch, stdcall counts and guarded explicit adapter accesses."""
from pathlib import Path
import sys,json,hashlib
sys.dont_write_bytecode=True
sys.path.insert(0,r'E:\OpenLeague\tools\pythonlibs')
import unicorn
from unicorn.x86_const import UC_X86_REG_ESP
import crt_os as c
from heap_mirrors import BASE,Rejected
OUT=Path(__file__).resolve().parent
args=[];returns=[];engine_frees=[];checks=[];error=None;lifetimes=[]
class IO:last_error=0
def fresh():
    raw=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);raw.mem_map(0x30000000,4096)
    raw.reg_write(UC_X86_REG_ESP,0x30000000)
    machine={'u':raw,'UC_X86_REG_ESP':UC_X86_REG_ESP,'read32':lambda a:args[(a-0x30000004)//4],
             'write32':lambda a,v:machine['u'].mem_write(a,v.to_bytes(4,'little')),
             'finish':lambda *a:returns.append(a),'release':engine_frees.append}
    runtime=c.CrtOs(machine,IO());lifetimes.append(runtime)
    return runtime,machine,machine['u']
crt,m,u=fresh()
def call(name,*values):args[:]=values;assert crt.dispatch(name);return returns[-1]
def check(name,yes):assert yes,name;checks.append(name)
def rejected(name,fn):
    before=len(returns)
    try:fn()
    except Rejected:check(name,len(returns)==before);return
    raise AssertionError(name)
try:
    p,pop=call('HeapAlloc',crt.heap_label,8,8)
    check('HeapAlloc x86 stdcall12 and owned mirror',pop==12 and p in crt.heap_blocks)
    u.mem_write(p,b'abcdefgh')
    q,pop=call('HeapReAlloc',crt.heap_label,0,p,32)
    check('HeapReAlloc x86 stdcall16 and preserved bytes',pop==16 and bytes(u.mem_read(q,8))==b'abcdefgh')
    check('HeapSize x86 stdcall12',call('HeapSize',crt.heap_label,0,q)==(32,12))
    check('HeapFree x86 stdcall12',call('HeapFree',crt.heap_label,0,q)==(1,12))
    rejected('stale CRT primitive cannot route to engine',lambda:crt.release_primitive(q))
    rejected('unreserved CRT primitive cannot route to engine',lambda:crt.release_primitive(BASE+0x1000000))
    check('engine untouched by stale CRT frees',engine_frees==[])
    crt.release_primitive(0x33000000);check('separate engine route retained',engine_frees==[0x33000000])
    p=call('HeapAlloc',crt.heap_label,8,8)[0]
    rejected('GetCPInfo cannot pre-read20 into8byte heap block',lambda:call('GetCPInfo',1252,p))
    rejected('GetThreadTimes cannot span past heap request',lambda:call('GetThreadTimes',0xfffffffe,p,p+8,p+8,p+8))
    u.mem_write(0x30000200,'AbC'.encode('utf-16le'))
    rejected('LCMapStringEx destination remains within heap request',lambda:call('LCMapStringEx',0,0x100,0x30000200,3,p+4,3,0,0,0))
    u.mem_write(p,b'ABCDEFGH')
    rejected('strz cannot search beyond unterminated heap block',lambda:crt.strz(p))
    check('rejected adapter copies preserve heap bytes',bytes(u.mem_read(p,8))==b'ABCDEFGH')
    call('HeapFree',crt.heap_label,0,p)
    p=call('HeapAlloc',crt.heap_label,8,8)[0]
    def fault(stage,owner):
        if stage=='free_after_os':raise RuntimeError('injected free-after-OS')
    crt.mirrors.fault=fault
    try:call('HeapFree',crt.heap_label,0,p)
    except RuntimeError:checks.append('free publication fault stays explicit')
    else:raise AssertionError('expected free fault')
    snap=crt.mirrors.snapshot()
    check('mapping is counted after raw successful release',not crt.heap_blocks and not crt.unadopted_heap_blocks and snap['mapped_regions']==1 and len(snap['interrupted'])==1)
    rejected('interrupted primitive never routes to engine',lambda:crt.release_primitive(p))
    crt.mirrors.fault=lambda *a:None;crt.release_host_backing()
    check('terminal cleanup retires remaining mapping',crt.mirrors.snapshot()['mapped_regions']==0 and not crt.mirrors.snapshot()['interrupted'])
    # Return publication failures are not native OS failures. They stop the guest
    # and preserve the successful backing under the interrupted stable owner.
    for operation in ('HeapAlloc','HeapReAlloc'):
        for boundary in ('event','finish'):
            crt,m,u=fresh()
            original_event=crt.event;original_finish=m['finish']
            old=call('HeapAlloc',crt.heap_label,8,8)[0] if operation=='HeapReAlloc' else 0
            def injected(*a,**kw):raise RuntimeError('injected '+boundary)
            if boundary=='event':crt.event=injected
            else:m['finish']=injected
            try:
                if operation=='HeapAlloc':call(operation,crt.heap_label,8,16)
                else:call(operation,crt.heap_label,0,old,32)
            except RuntimeError as caught:check(operation+' '+boundary+' primary kept',str(caught)=='injected '+boundary)
            else:raise AssertionError('expected publication failure')
            finally:crt.event=original_event;m['finish']=original_finish
            snap=crt.mirrors.snapshot()
            check(operation+' '+boundary+' raw retained interrupted',snap['raw_owners']==1 and snap['live_owners']==0 and len(snap['interrupted'])==1)
            crt.release_host_backing()
            check(operation+' '+boundary+' terminal cleanup complete',crt.mirrors.snapshot()['raw_owners']==crt.mirrors.snapshot()['mapped_regions']==0)
except Exception as caught:error=repr(caught)
finally:
    for runtime in lifetimes:
        runtime.mirrors.fault=lambda *a:None;runtime.release_host_backing()
    snaps=[runtime.mirrors.snapshot() for runtime in lifetimes]
    result=dict(passed=error is None and all(s['raw_owners']==s['mapped_regions']==0 for s in snaps),error=error,checks=checks,check_count=len(checks),
                remaining=snaps,native_EXE_DLL_execution=False,
                injected_failures=['free_after_os','HeapAlloc event','HeapAlloc finish','HeapReAlloc event','HeapReAlloc finish'],
                source_hashes={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in [Path(__file__),OUT/'heap_mirrors.py',OUT/'crt_os.py']})
    (OUT/'heap_boundary_tests.json').write_bytes((json.dumps(result,indent=2)+'\n').encode())
    print(json.dumps({'passed':result['passed'],'checks':len(checks),'error':error}))
if not result['passed']:raise SystemExit(1)
