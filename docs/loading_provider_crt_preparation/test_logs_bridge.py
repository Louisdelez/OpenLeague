from pathlib import Path
import sys,json,uuid,hashlib
sys.dont_write_bytecode=True
from isolated_io import *
from diagnostic_pipe_open import DiagnosticPipeOpen,PATH,EXPECTED
OUT=Path(__file__).resolve().parent
b=Bridge(OUT/('logs_test_'+uuid.uuid4().hex[:10]));checks=[];failure=None
def check(name,value):
    assert value,name
    checks.append(name)
def reject(name,fn):
    before=len(b.events)
    try:fn()
    except (Rejected,ValueError):check(name,len(b.events)==before);return
    raise AssertionError(name+' not rejected')
try:
    logs=b.root/'Logs';p=logs/'bridge-test.bin'
    check('source Config really exists independently',bool(K.GetFileAttributesW(extended(SOURCE/'Config'))&16))
    for name in ('Config','Logs'):
        target=b.root/name
        ctypes.set_last_error(0);direct=K.GetFileAttributesW(extended(target));error=ctypes.get_last_error()
        observed=b.attributes(str(target))
        check(name+' private missing attributes before mkdir',observed==direct==0xffffffff and b.last_error==error and b.events[-1]['physical_path']==str(target))
    actual,relative,shadow=b.resolve(str(logs),write=True)
    check('Logs resolves strictly inside owned scratch root',folded(actual)==folded(logs) and within(actual,b.root))
    check('actual Logs mkdir',b.mkdir(str(logs))==1 and logs.is_dir())
    payload=b'actual Windows Logs bridge\0'+bytes(range(128))
    h=b.open(str(p),READ|WRITE,1,1)
    check('actual Logs CREATE_NEW',h!=0xffffffff)
    check('actual Logs WriteFile',b.write(h,payload)==(True,len(payload)))
    check('actual Logs close after write',b.close(h)==1)
    h=b.open(str(p).swapcase())
    check('actual Logs reopen',h!=0xffffffff)
    ok,data=b.read(h,4096)
    check('Logs shadow read returns exact written bytes',ok and data==payload)
    check('actual Logs final close',b.close(h)==1)
    reject('Logs dotdot escape rejected',lambda:b.open(str(logs/'..'/'..'/'escape.bin'),WRITE,1,1))
    reject('D absolute write rejected',lambda:b.open(str(SOURCE/'Logs'/'never-created.bin'),WRITE,1,1))
    reject('production absolute write rejected',lambda:b.open('E:/OpenLeague/Logs/never-created.bin',WRITE,1,1))
    reject('Logs ADS rejected',lambda:b.open(str(p)+':stream',WRITE,1,1))
    reject('Logs prefix sibling rejected',lambda:b.open(str(b.root)+'_sibling/Logs/a',WRITE,1,1))
    reject('unlisted scratch top folder rejected',lambda:b.open(str(b.root/'Temp'/'a'),WRITE,1,1))
    check('every write target resolves under exact Logs root',all(within(e['physical_path'],logs) for e in b.events if e['api']=='WriteFile'))
    check('all real file handles closed',not b.handles and not b.finds)
    pipe=DiagnosticPipeOpen()
    reject('pipe helper rejects wildcard without calling OS',lambda:pipe.attempt(PATH+'*',EXPECTED))
    reject('pipe helper rejects remote path without calling OS',lambda:pipe.attempt(r'\\remote\pipe\LogViewerPipe',EXPECTED))
    reject('pipe helper rejects changed flags without calling OS',lambda:pipe.attempt(PATH,(*EXPECTED[:4],0,0)))
    check('negative pipe tests perform no open',not pipe.events and pipe.handle is None)
except Exception as error:failure=repr(error)
finally:
    b.cleanup()
    proof={'passed':failure is None,'check_count':len(checks),'checks':checks,'error':failure,'events':b.events,
           'root':str(b.root),'open_handles':len(b.handles)+len(b.finds),
           'limits':['No concurrent external filesystem mutation assumed. No successful truncation is exercised.',
                     'Pipe negative tests reject before OS; actual native exact open is a separate probe.'],
           'source_hashes':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in [Path(__file__),OUT/'isolated_io.py',OUT/'diagnostic_pipe_open.py']}}
    (OUT/'logs_bridge_tests.json').write_text(json.dumps(proof,indent=2)+'\n')
    print(json.dumps({'passed':proof['passed'],'checks':len(checks),'error':failure}))
if failure:raise SystemExit(1)
