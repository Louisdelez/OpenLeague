"""Real heap transitions plus separately marked adapter fault injection."""
from pathlib import Path
import sys,json,hashlib,ctypes,struct
sys.dont_write_bytecode=True
sys.path.insert(0,r'E:\OpenLeague\tools\pythonlibs')
import unicorn
from unicorn.x86_const import UC_X86_REG_EIP
import crt_os as c
from heap_mirrors import HeapMirrors,BASE,SLOT,Rejected
OUT=Path(__file__).resolve().parent
checks=[];evidence=[];arenas=[];error=None
def check(name,yes):
    assert yes,name
    checks.append(name)
def rejected(name,call):
    try:call()
    except Rejected:checks.append(name);return
    raise AssertionError(name)
class RecordedApi:
    def __init__(self):self.calls=[];self.inject_free_fail=False;self.inject_realloc_null=False
    def HeapAlloc(self,*args):
        incoming=ctypes.get_last_error();v=c.K.HeapAlloc(*args);last=ctypes.get_last_error()
        self.calls.append(dict(api='HeapAlloc',result=int(v or 0),incoming_error=incoming,last_error=last,injected=False))
        ctypes.set_last_error(last);return v
    def HeapReAlloc(self,*args):
        incoming=ctypes.get_last_error()
        if self.inject_realloc_null:
            self.calls.append(dict(api='HeapReAlloc',result=0,old=args[2],incoming_error=incoming,injected=True))
            return None
        v=c.K.HeapReAlloc(*args);last=ctypes.get_last_error()
        self.calls.append(dict(api='HeapReAlloc',old=args[2],result=int(v or 0),size=args[3],incoming_error=incoming,last_error=last,injected=False))
        ctypes.set_last_error(last);return v
    def HeapFree(self,*args):
        if self.inject_free_fail:
            ctypes.set_last_error(6);self.calls.append(dict(api='HeapFree',raw=args[2],result=0,injected=True));return 0
        v=c.K.HeapFree(*args);last=ctypes.get_last_error()
        self.calls.append(dict(api='HeapFree',raw=args[2],result=int(bool(v)),last_error=last,injected=False))
        ctypes.set_last_error(last);return v
    def HeapSize(self,*args):return c.K.HeapSize(*args)
def make():
    raw=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);api=RecordedApi()
    arena=HeapMirrors(raw,lambda:api,c.K.GetProcessHeap());arenas.append((arena,api))
    return arena,api
def fault_once(expected):
    state=[False]
    def injected(stage,owner):
        if stage==expected and not state[0]:state[0]=True;raise RuntimeError('injected '+expected)
    return injected
def fail(name,call):
    try:call()
    except RuntimeError as caught:check(name,'injected' in str(caught));return
    raise AssertionError(name)
try:
    # Fresh real allocations with guest writes newer than the initial backing.
    arena,api=make();moves=stays=0
    for cycle in range(4):
        p=arena.allocate(128,8);check('HeapAlloc actual zero bytes '+str(cycle),bytes(arena.guarded.mem_read(p,128))==bytes(128))
        for n in (256,64,8192,32,4096):
            old=p;owner=arena._owner(p);old_n=owner.requested;old_raw=owner.raw
            pattern=bytes((i*7+cycle+1)&255 for i in range(old_n))
            arena.guarded.mem_write(p,pattern)
            check('guest pattern written '+str((cycle,n)),bytes(arena.u.mem_read(p,old_n))==pattern)
            if n==256:
                check('guest differs from actual initial Win32 backing '+str(cycle),ctypes.string_at(old_raw,old_n)!=pattern)
            p=arena.reallocate(p,n);assert p
            current=arena._owner(p);moved=current.raw!=old_raw
            moves+=int(moved);stays+=int(not moved)
            check('actual raw/guest identity match '+str((cycle,n)),(p!=old)==moved)
            check('actual realloc preserves guest-authored bytes '+str((cycle,n)),bytes(arena.guarded.mem_read(p,min(old_n,n)))==pattern[:min(old_n,n)])
            check('actual HeapSize equals qualified request '+str((cycle,n)),arena.size(p)==n)
            rejected('direct access rejects requested tail '+str((cycle,n)),lambda:arena.guarded.mem_read(p+n-1,2))
            if moved:rejected('old moved pointer is stale '+str((cycle,n)),lambda:arena.guarded.mem_read(old,1))
            evidence.append(dict(kind='actual_realloc',cycle=cycle,old_size=old_n,new_size=n,moved=moved,old_guest=old,new_guest=p))
        check('actual HeapFree '+str(cycle),arena.free(p)==1)
        rejected('freed pointer is stale '+str(cycle),lambda:arena.guarded.mem_read(p,1))
    check('real transition suite no retained owners',arena.snapshot()['raw_owners']==0 and arena.snapshot()['mapped_regions']==0)
    # A preparatory operation deliberately touches last-error but does not fail.
    arena,api=make()
    arena.fault=lambda stage,owner:ctypes.set_last_error(1234)
    ctypes.set_last_error(0x5a5a);p=arena.allocate(8,8)
    check('HeapAlloc gets incoming last-error after preparation',api.calls[-1]['incoming_error']==0x5a5a)
    ctypes.set_last_error(0x6b6b);q=arena.reallocate(p,32)
    check('HeapReAlloc gets incoming last-error after preparation',api.calls[-1]['incoming_error']==0x6b6b)
    arena.fault=lambda *a:None;arena.free(q)
    # Injected null is an adapter ownership test, explicitly not a real OS failure.
    arena,api=make();p=arena.allocate(8,8);arena.guarded.mem_write(p,b'12345678');raw=arena._owner(p).raw
    api.inject_realloc_null=True
    check('injected null result unchanged pointer owner',arena.reallocate(p,64)==0 and arena._owner(p).raw==raw)
    check('injected null result data retained',bytes(arena.guarded.mem_read(p,8))==b'12345678' and arena.size(p)==8)
    check('injected null retains one mapping',arena.snapshot()['mapped_regions']==1 and arena.snapshot()['raw_owners']==1)
    api.inject_realloc_null=False;arena.free(p)
    # Each fault is after a real allocation or realloc; cleanup never replays OS realloc.
    for stage in ('allocate_before_map','allocate_after_os','allocate_before_copy','allocate_before_publish',
                  'reallocate_before_map','reallocate_before_sync','reallocate_before_os','reallocate_after_os',
                  'reallocate_before_copy','reallocate_after_copy','reallocate_before_unmap','reallocate_before_publish'):
        arena,api=make();p=0
        if stage.startswith('reallocate'):p=arena.allocate(128,8);arena.guarded.mem_write(p,b'X'*128)
        arena.fault=fault_once(stage)
        fail(stage+' propagates injected primary',lambda:arena.reallocate(p,256) if p else arena.allocate(64,8))
        snapshot=arena.snapshot();owner=arena.owners[0]
        check(stage+' interrupted owner retained',owner.phase=='interrupted' and owner.primary_error=='RuntimeError(\'injected '+stage+'\')')
        calls_before=sum(x['api']=='HeapReAlloc' for x in api.calls)
        api.inject_free_fail=True;arena.fault=lambda *a:None
        first=arena.cleanup()
        if snapshot['raw_owners']:
            check(stage+' failed cleanup retains raw',bool(first) and arena.snapshot()['raw_owners']==1)
        else:check(stage+' no raw was acquired',not first and arena.snapshot()['raw_owners']==0)
        primary=owner.primary_error
        api.inject_free_fail=False;arena.fault=fault_once('cleanup_before_unmap')
        arena.cleanup();free_count=sum(x['api']=='HeapFree' and x['result']==1 for x in api.calls)
        check(stage+' cleanup can retire raw independently',arena.snapshot()['raw_owners']==0)
        arena.fault=lambda *a:None;arena.cleanup()
        check(stage+' retry does not double free',sum(x['api']=='HeapFree' and x['result']==1 for x in api.calls)==free_count)
        check(stage+' primary preserved',owner.primary_error==primary)
        check(stage+' no remaining resource',arena.snapshot()['mapped_regions']==0 and arena.snapshot()['raw_owners']==0)
        check(stage+' never replays realloc',sum(x['api']=='HeapReAlloc' for x in api.calls)==calls_before)
        evidence.append(dict(kind='injected_fault',stage=stage,before_cleanup=snapshot,api_calls=api.calls))
    # Both explicit Python accesses and actual guest machine instructions cross limits.
    arena,api=make();p=arena.allocate(8,8)
    rejected('Python tail read rejected',lambda:arena.guarded.mem_read(p+7,2))
    rejected('Python tail write rejected',lambda:arena.guarded.mem_write(p+7,b'AB'))
    rejected('external map into reserved arena rejected',lambda:arena.guarded.mem_map(BASE+SLOT,4096))
    arena.u.mem_map(BASE-4096,4096);code=0x30000000;arena.u.mem_map(code,4096)
    # mov eax,[BASE-2] / mov [BASE-2],eax: start outside, end inside arena.
    for label,op in [('read',b'\xa1'),('write',b'\xa3')]:
        arena.u.mem_write(code,op+struct.pack('<I',BASE-2)+b'\x90')
        rejected('native cross-arena '+label+' rejected',lambda:arena.u.emu_start(code,code+5,count=1))
    check('rejected native write leaves valid bytes unchanged',bytes(arena.guarded.mem_read(p,8))==bytes(8))
    arena.free(p)
    # Invalid request rejection never reaches a real heap API.
    arena,api=make();p=arena.allocate(8,8);calls=len(api.calls)
    for label,args in [('null',(0,16,0)),('interior',(p+1,16,0)),('zero-size',(p,0,0)),
                       ('too-large',(p,SLOT+1,0)),('zero-flag-mode',(p,16,8)),('inplace-mode',(p,16,0x10))]:
        rejected(label+' rejected before OS',lambda args=args:arena.reallocate(*args))
    check('invalid requests made no OS calls',len(api.calls)==calls)
    api.inject_free_fail=True
    check('injected free failure leaves live owner',arena.free(p)==0 and p in arena.live_blocks)
    api.inject_free_fail=False;arena.free(p)
except Exception as caught:error=repr(caught)
finally:
    cleanup=[]
    for arena,api in arenas:
        api.inject_free_fail=False;api.inject_realloc_null=False;arena.fault=lambda *a:None
        cleanup.extend(arena.cleanup())
    remaining=[a.snapshot() for a,_ in arenas if a.snapshot()['raw_owners'] or a.snapshot()['mapped_regions']]
    result=dict(passed=error is None and not remaining and not cleanup,error=error,check_count=len(checks),checks=checks,
                real_moves=locals().get('moves',0),real_same_address=locals().get('stays',0),
                actual_OS_null_realloc_observed=False,injected_null_separate=True,
                evidence=evidence,cleanup_errors=cleanup,remaining=remaining,
                native_execution='Two five-byte x86 guard-access snippets only; no original EXE or DLL.',
                source_hashes={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in [Path(__file__),OUT/'heap_mirrors.py',OUT/'crt_os.py']})
    (OUT/'heap_mirrors_tests.json').write_bytes((json.dumps(result,indent=2)+'\n').encode())
    print(json.dumps({k:result[k] for k in ('passed','check_count','real_moves','real_same_address','error','remaining')}))
if not result['passed']:raise SystemExit(1)
