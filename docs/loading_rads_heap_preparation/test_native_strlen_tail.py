"""Run the original139-byte strlen against real heap alignment observations."""
from pathlib import Path
import sys,json,hashlib,ctypes,struct
sys.dont_write_bytecode=True
sys.path.insert(0,r'E:\OpenLeague\tools\pythonlibs')
import unicorn
from unicorn.x86_const import *
import crt_os as c
from heap_mirrors import HeapMirrors,Rejected
from native_strlen_tail import NativeStrlenTail,PhysicalTailReader,ENTRY
OUT=Path(__file__).resolve().parent
checks=[];cases=[];error=None
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32)
u.mem_map(0x100f8000,0x1000);u.mem_map(0x31000000,0x1000);u.mem_map(0x32000000,0x1000);u.mem_map(0x40000000,0x1000)
arena=HeapMirrors(u,lambda:c.K,c.K.GetProcessHeap());policy=NativeStrlenTail(arena)
u.mem_write(ENTRY,policy.code);SP=0x31000800;RETURN=0x32000000
addresses=set()
def code_hook(uc,pc,size,user):
    if ENTRY<=pc<ENTRY+139:
        assert bytes(u.mem_read(pc,size))==policy.code[pc-ENTRY:pc-ENTRY+size]
        addresses.add(pc)
u.hook_add(unicorn.UC_HOOK_CODE,code_hook)
def check(name,value):assert value,name;checks.append(name)
def reject(name,fn):
    try:fn()
    except Rejected:checks.append(name);return
    raise AssertionError(name)
def prepare(pointer):
    u.mem_write(SP,struct.pack('<II',RETURN,pointer));u.reg_write(UC_X86_REG_ESP,SP)
    for reg,value in ((UC_X86_REG_EAX,0x12345678),(UC_X86_REG_ECX,0x98765432),(UC_X86_REG_EDX,0xabcdef01),(UC_X86_REG_EFLAGS,0x202)):
        u.reg_write(reg,value)
def run(pointer):
    prepare(pointer);before=len(policy.reader.events)
    u.emu_start(ENTRY,RETURN,count=1000);policy.observe_return()
    result={name:u.reg_read(reg) for name,reg in [('eax',UC_X86_REG_EAX),('ecx',UC_X86_REG_ECX),('edx',UC_X86_REG_EDX),('eflags',UC_X86_REG_EFLAGS),('esp',UC_X86_REG_ESP),('eip',UC_X86_REG_EIP)]}
    return result,policy.reader.events[before:]
try:
    # Separate full invocations, various initial byte alignment and terminal tails.
    for n in (1,2,3,5,6,7,9,10,11,51):
        for offset in range(min(4,n)):
            p=arena.allocate(n,8);payload=b'A'*(n-1)+b'\0';arena.guarded.mem_write(p,payload)
            ctypes.set_last_error(0x6a6a);event_start=len(policy.events)
            actual,rpm=run(p+offset)
            check('native strlen/return '+str((n,offset)),actual['eax']==n-1-offset and actual['ecx']==p+offset and actual['esp']==SP+4 and actual['eip']==RETURN)
            check('helper preserves incoming last-error '+str((n,offset)),ctypes.get_last_error()==0x6a6a)
            reads=[e for e in policy.events[event_start:] if e['kind']=='bounded_native_read']
            check('invocation retired '+str((n,offset)),not policy.stack)
            if reads:
                check('both native reads share one actual RPM '+str((n,offset)),len(reads)==2 and [r['pc'] for r in reads]==[0x100f8700,0x100f8718] and len(rpm)==1 and reads[0]['padding_hex']==reads[1]['padding_hex']==rpm[0]['bytes_hex'])
                check('physical read exact count '+str((n,offset)),rpm[0]['success'] and rpm[0]['requested']==rpm[0]['transferred']==4-reads[0]['valid_bytes'])
                tail=bytes.fromhex(reads[0]['padding_hex'])
            else:
                check('byte path needs no RPM '+str((n,offset)),not rpm);tail=b''
            # A reference invocation uses these same observed bytes in a plain
            # buffer, not a guessed zero padding. It executes the same139bytes.
            u.mem_write(0x40000000,payload+tail)
            reference,other_rpm=run(0x40000000+offset)
            check('original code registers match observed-byte reference '+str((n,offset)),
                  actual['eax']==reference['eax'] and actual['edx']==reference['edx'] and actual['eflags']==reference['eflags'] and reference['ecx']==0x40000000+offset and not other_rpm)
            check('HeapSize remains logical requested '+str((n,offset)),arena.size(p)==n)
            reject('Python tail read stays denied '+str((n,offset)),lambda:arena.guarded.mem_read(p+n,1))
            reject('Python tail write stays denied '+str((n,offset)),lambda:arena.guarded.mem_write(p+n,b'X'))
            check('logical bytes unchanged '+str((n,offset)),bytes(arena.guarded.mem_read(p,n))==payload)
            cases.append(dict(requested=n,offset=offset,actual=actual,reference=reference,physical_reads=rpm))
            arena.free(p)
    # Exact boundary rejections: no invocation, wrong PC, no NUL, write, changed source.
    p=arena.allocate(2,8);arena.guarded.mem_write(p,b'C\0')
    prepare(p);u.reg_write(UC_X86_REG_EIP,0x100f8700)
    check('no invocation cannot grant read',not policy.allow(u,unicorn.UC_MEM_READ,p,4))
    policy.observe(u,ENTRY,4,None);u.reg_write(UC_X86_REG_EIP,0x100f8702)
    check('unqualified PC denied',not policy.allow(u,unicorn.UC_MEM_READ,p,4))
    u.reg_write(UC_X86_REG_EIP,0x100f8700)
    check('writes never granted',not policy.allow(u,unicorn.UC_MEM_WRITE,p,4))
    check('unaligned read denied',not policy.allow(u,unicorn.UC_MEM_READ,p+1,4))
    check('nonDWORD read denied',not policy.allow(u,unicorn.UC_MEM_READ,p,2))
    u.reg_write(UC_X86_REG_ESP,SP+4)
    check('changed stack pointer denied',not policy.allow(u,unicorn.UC_MEM_READ,p,4))
    u.reg_write(UC_X86_REG_ESP,SP);u.mem_write(SP,struct.pack('<II',RETURN+4,p))
    check('changed return address denied',not policy.allow(u,unicorn.UC_MEM_READ,p,4))
    u.mem_write(SP,struct.pack('<II',RETURN,p+1))
    check('changed argument denied',not policy.allow(u,unicorn.UC_MEM_READ,p,4))
    u.mem_write(SP,struct.pack('<II',RETURN,p))
    arena.guarded.mem_write(p,b'CD')
    check('unterminated valid suffix denied',not policy.allow(u,unicorn.UC_MEM_READ,p,4))
    arena.guarded.mem_write(p,b'C\0')
    u.mem_write(0x100f8700,b'\x90\x90')
    reject('read source mutation denied',lambda:policy.allow(u,unicorn.UC_MEM_READ,p,4))
    u.mem_write(ENTRY,policy.code);policy.abandon('rejection test invocation ended');arena.free(p)
    check('abandoned invocation cannot grant a tail read',not policy.allow(u,unicorn.UC_MEM_READ,p,4))
    p=arena.allocate(2,8);arena.guarded.mem_write(p,b'CD')
    reject('real unterminated source execution stops at strict bound',lambda:run(p))
    policy.abandon('unterminated native test');arena.free(p)
    p=arena.allocate(2,8);arena.guarded.mem_write(p,b'C\0')
    prepare(p);policy.observe(u,ENTRY,4,None);u.reg_write(UC_X86_REG_EIP,0x100f8700)
    q=arena.reallocate(p,64)
    check('changed owner identity or length rejects captured invocation',not policy.allow(u,unicorn.UC_MEM_READ,p,4))
    policy.abandon('owner transition test');arena.free(q)
    # Explicit injected reader failure/incomplete transfer are not real RPM errors.
    real_reader=policy.reader
    class FailedReader:
        def __init__(self):self.events=[]
        def read(self,address,count):
            self.events.append(dict(injected=True,success=False,requested=count,transferred=0))
            ctypes.set_last_error(5);raise Rejected('injected ReadProcessMemory failure')
    class ShortReader:
        def __init__(self):self.events=[]
        def read(self,address,count):
            self.events.append(dict(injected=True,success=True,requested=count,transferred=0));return b''
    for reader,label in ((FailedReader(),'failure'),(ShortReader(),'incomplete')):
        p=arena.allocate(2,8);arena.guarded.mem_write(p,b'C\0');policy.reader=reader
        ctypes.set_last_error(0x5b5b)
        reject('injected '+label+' stops native call',lambda:run(p))
        check('injected '+label+' preserves error/owner',ctypes.get_last_error()==0x5b5b and arena._owner(p).raw!=0 and not any(e['kind']=='bounded_native_read' for e in policy.events[-1:]))
        policy.abandon('injected reader '+label);arena.free(p)
    policy.reader=real_reader
except Exception as caught:error=repr(caught)
finally:
    policy.abandon('test terminal cleanup');cleanup=arena.cleanup();snap=arena.snapshot()
    result=dict(passed=error is None and not cleanup and snap['raw_owners']==snap['mapped_regions']==0,error=error,check_count=len(checks),checks=checks,
                completed_original_strlen_invocations=len(cases)*2,interrupted_original_strlen_invocations=3,
                manual_invocation_context_setups=2,cases=cases,executed_source_addresses=sorted(addresses),
                source=policy.provenance,events=policy.events,cleanup_errors=cleanup,remaining=snap,
                limits=['No full DLL attachment or provider execution in this test.',
                        'Alignment bytes are observed from the current host process heap, not a historical x86 allocator parity claim.',
                        'ReadProcessMemory failure and incomplete transfer are deliberately injected in separate cases.'],
                source_hashes={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in [Path(__file__),OUT/'native_strlen_tail.py',OUT/'heap_mirrors.py',OUT/'crt_os.py']})
    (OUT/'native_strlen_tail_tests.json').write_bytes((json.dumps(result,indent=2)+'\n').encode())
    print(json.dumps({'passed':result['passed'],'checks':len(checks),'invocations':len(cases)*2,'error':error,'remaining':snap['raw_owners']}))
if not result['passed']:raise SystemExit(1)
