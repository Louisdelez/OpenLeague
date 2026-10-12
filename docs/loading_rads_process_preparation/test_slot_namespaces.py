"""Actual Windows FLS/TLS namespace collision. No native DLL execution."""
from pathlib import Path
import sys,json,hashlib
sys.dont_write_bytecode=True
import crt_os as c
OUT=Path(__file__).resolve().parent
class U:
    def mem_map(self,*a):pass
    def reg_read(self,*a):return 100
class IO:last_error=0
params=[];returns=[];checks=[];error=None
m={'u':U(),'UC_X86_REG_ESP':0,'read32':lambda a:params[(a-104)//4],
   'write32':lambda *a:None,'finish':lambda *a:returns.append(a),'allocate':None,'release':None}
crt=c.CrtOs(m,IO())
def call(name,*args):
    params[:]=list(args);crt.dispatch(name);return returns[-1][0]
def check(name,value):assert value,name;checks.append(name)
try:
    fls=[];tls=[];shared=None
    for i in range(64):
        f=call('FlsAlloc',0);t=call('TlsAlloc');assert f!=0xffffffff and t!=0xffffffff
        fls.append(f);tls.append(t)
        same=set(fls)&set(tls)
        if same:shared=min(same);break
    check('actual OS namespaces share a numeric index',shared is not None)
    check('both ownership entries retained',('Fls',shared) in crt.slots and ('Tls',shared) in crt.slots)
    check('FLS actual value set',call('FlsSetValue',shared,0x12345000)==1)
    check('TLS actual distinct value set',call('TlsSetValue',shared,0x23456000)==1)
    check('FLS value isolated',call('FlsGetValue',shared)==0x12345000)
    check('TLS value isolated',call('TlsGetValue',shared)==0x23456000)
    check('FLS free real success',call('FlsFree',shared)==1)
    check('TLS owner survives FLS free',('Tls',shared) in crt.slots and ('Fls',shared) not in crt.slots)
    check('null FLS callback did not queue native address0',not crt.pending)
    check('TLS value intact after FLS free',call('TlsGetValue',shared)==0x23456000)
    check('TLS free real success',call('TlsFree',shared)==1)
except Exception as e:error=repr(e)
finally:
    crt.host_cleanup();crt.release_host_backing()
    if error is None:check('all remaining actual slots freed',not crt.slots and not crt.pending)
    result={'passed':error is None,'checks':checks,'check_count':len(checks),'error':error,'shared_numeric_index':shared,
      'native_execution':False,'events':crt.events,'remaining_slots':len(crt.slots),'pending_callbacks':len(crt.pending),
      'source_hashes':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in [Path(__file__),OUT/'crt_os.py']}}
    (OUT/'slot_namespaces_tests.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({'passed':result['passed'],'checks':len(checks),'shared':shared,'error':error}))
if error:raise SystemExit(1)
