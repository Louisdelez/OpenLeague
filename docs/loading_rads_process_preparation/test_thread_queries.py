"""Actual current-thread FILETIME calls, preserving aliased output addresses."""
from pathlib import Path
import sys,json,hashlib,ctypes
sys.dont_write_bytecode=True
sys.path.insert(0,r'E:\OpenLeague\tools\pythonlibs')
import unicorn
from unicorn.x86_const import UC_X86_REG_ESP
import crt_os as c
OUT=Path(__file__).resolve().parent
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(0x30000000,0x1000);u.reg_write(UC_X86_REG_ESP,0x30000000)
params=[];returns=[];checks=[];observations=[]
class IO:last_error=0
m={'u':u,'UC_X86_REG_ESP':UC_X86_REG_ESP,'read32':lambda a:params[(a-0x30000004)//4],
 'write32':lambda *a:None,'finish':lambda *a:returns.append(a),'allocate':None,'release':None}
crt=c.CrtOs(m,IO());actual=c.K
class ObserveActual:
    def __getattr__(self,n):return getattr(actual,n)
    def GetThreadTimes(self,h,*outputs):
        addresses=[ctypes.cast(p,ctypes.c_void_p).value for p in outputs]
        result=actual.GetThreadTimes(h,*outputs);error=ctypes.get_last_error()
        low=min(addresses);high=max(addresses)+8
        observations.append({'result':result,'error':error,'relative':[p-low for p in addresses],'bytes':ctypes.string_at(low,high-low).hex()})
        ctypes.set_last_error(error);return result
def call(name,*args):params[:]=args;assert crt.dispatch(name);return returns[-1]
def check(n,v):assert v,n;checks.append(n)
try:
    check('real pseudo thread handle sign translation',call('GetCurrentThread')==(actual.GetCurrentThread()&0xffffffff,))
    c.K=ObserveActual()
    for offsets in [[0,8,16,24],[0,8,8,8],[0,0,0,0]]:
        size=max(offsets)+8;start=0x30000202
        u.mem_write(start-2,bytes([0xcd])*(size+4));u.mem_write(start,bytes([0xa5])*size)
        got=call('GetThreadTimes',0xfffffffe,*[start+p for p in offsets]);obs=observations[-1]
        check('real OS output bytes preserved '+str(offsets),got==(obs['result'],20) and crt.io.last_error==obs['error'] and bytes(u.mem_read(start,size)).hex()==obs['bytes'])
        check('alias topology identical '+str(offsets),obs['relative']==offsets)
        check('FILETIME span guards unchanged '+str(offsets),bytes(u.mem_read(start-2,2))+bytes(u.mem_read(start+size,2))==bytes([0xcd])*4)
    check('pseudo handle creates no owner',not crt.heap_blocks and not crt.slots and not crt.locks)
finally:c.K=actual
result={'passed':True,'check_count':len(checks),'checks':checks,'observations':observations,'native_pe_execution':False,
 'source_hashes':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in [Path(__file__),OUT/'crt_os.py']}}
(OUT/'thread_query_tests.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({'passed':True,'checks':len(checks)}))
