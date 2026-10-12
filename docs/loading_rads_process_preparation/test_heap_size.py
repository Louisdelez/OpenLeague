"""Real HeapSize only on exact owned base pointers; no native PE execution."""
from pathlib import Path
import sys,json,hashlib
sys.dont_write_bytecode=True
sys.path.insert(0,r'E:\OpenLeague\tools\pythonlibs')
import unicorn
from unicorn.x86_const import UC_X86_REG_ESP
import crt_os as c
OUT=Path(__file__).resolve().parent
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(0x30000000,0x10000);u.reg_write(UC_X86_REG_ESP,0x30000000)
params=[];returns=[];checks=[];released=[];cursor=0x30001000
class IO:last_error=0
def allocate(n):
    global cursor
    p=cursor;cursor+=(n+31)&~15;return p
m={'u':u,'UC_X86_REG_ESP':UC_X86_REG_ESP,'read32':lambda a:params[(a-0x30000004)//4],
 'write32':lambda *a:None,'finish':lambda *a:returns.append(a),'allocate':allocate,'release':released.append}
crt=c.CrtOs(m,IO());error=None
def call(name,*args):params[:]=args;assert crt.dispatch(name);return returns[-1]
def check(n,v):assert v,n;checks.append(n)
def reject(n,f):
    try:f()
    except c.Rejected:checks.append(n);return
    raise AssertionError(n)
try:
    for n in [1,4,128,544,2048]:
        p=call('HeapAlloc',crt.heap_label,8,n)[0]
        direct=c.K.HeapSize(crt.heap,0,crt.heap_blocks[p]);got=call('HeapSize',crt.heap_label,0,p)
        check('actual HeapSize and mirror capacity '+str(n),got==(direct,12) and direct<=crt.heap_sizes[p]==n)
        reject('interior pointer rejected '+str(n),lambda:call('HeapSize',crt.heap_label,0,p+1))
        check('HeapSize does not mutate zeroed bytes '+str(n),bytes(u.mem_read(p,n))==bytes(n))
        call('HeapFree',crt.heap_label,0,p)
        reject('released pointer rejected '+str(n),lambda:call('HeapSize',crt.heap_label,0,p))
    check('all real blocks and size records retired',not crt.heap_blocks and not crt.heap_sizes and len(released)==5)
except Exception as e:error=repr(e)
finally:
    crt.release_host_backing()
    result={'passed':error is None,'error':error,'checks':checks,'check_count':len(checks),'events':crt.events,
      'native_pe_execution':False,'remaining':len(crt.heap_blocks)+len(crt.unadopted_heap_blocks),
      'source_hashes':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in [Path(__file__),OUT/'crt_os.py']}}
    (OUT/'heap_size_tests.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({'passed':result['passed'],'checks':len(checks),'error':error}))
if error:raise SystemExit(1)
