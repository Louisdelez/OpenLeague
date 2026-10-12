"""Bounded NLS ABI adapters compared with direct Windows calls; no native DLL."""
from pathlib import Path
import sys,json,hashlib,ctypes
sys.dont_write_bytecode=True
sys.path.insert(0,r'E:\OpenLeague\tools\pythonlibs')
import unicorn
from unicorn.x86_const import UC_X86_REG_ESP
import crt_os as c
OUT=Path(__file__).resolve().parent
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(0x30000000,0x1000)
u.reg_write(UC_X86_REG_ESP,0x30000000)
params=[];returns=[];checks=[]
class IO:last_error=0
m={'u':u,'UC_X86_REG_ESP':UC_X86_REG_ESP,'read32':lambda a:params[(a-0x30000004)//4],
 'write32':lambda *a:None,'finish':lambda *a:returns.append(a),'allocate':None,'release':None}
crt=c.CrtOs(m,IO())
def call(name,*args):
    params[:]=args;assert crt.dispatch(name);return returns[-1]
def check(name,condition):assert condition,name;checks.append(name)
check('CPINFO size20 and exact field offsets',ctypes.sizeof(c.CPInfo)==20 and [getattr(c.CPInfo,n).offset for n in ('MaxCharSize','DefaultChar','LeadByte')]==[0,4,6])
check('GetACP actual scalar and zero argument stdcall',call('GetACP')==(c.K.GetACP(),))
check('actual SSE2 feature result and stdcall4',call('IsProcessorFeaturePresent',10)==(c.K.IsProcessorFeaturePresent(10),4))
for cp in [c.K.GetACP(),65001,0xffffffff]:
    check('IsValidCodePage direct parity '+str(cp),call('IsValidCodePage',cp)==(c.K.IsValidCodePage(cp),4))
    for fill in [0,0xa5]:
        raw=bytes([fill])*20;direct=c.CPInfo.from_buffer_copy(raw)
        ctypes.set_last_error(9876);expected=c.K.GetCPInfo(cp,ctypes.byref(direct));error=ctypes.get_last_error()
        u.mem_write(0x30000200,bytes([0xcd])*24);u.mem_write(0x30000202,raw);crt.io.last_error=9876
        got=call('GetCPInfo',cp,0x30000202)
        check('GetCPInfo output/error/stdcall '+str((cp,fill)),got==(expected,8) and bytes(u.mem_read(0x30000202,20))==bytes(direct) and crt.io.last_error==error)
        check('GetCPInfo respects20byte bound '+str((cp,fill)),bytes(u.mem_read(0x30000200,2))+bytes(u.mem_read(0x30000216,2))==bytes([0xcd])*4)
for kind in [1,2,4,0xffffffff]:
    raw=('A\u00e9 9\0\u4e00').encode('utf-16le');count=len(raw)//2
    src=ctypes.create_string_buffer(raw,len(raw));direct=ctypes.create_string_buffer(bytes([0xa5])*len(raw),len(raw))
    ctypes.set_last_error(9876);expected=c.K.GetStringTypeW(kind,src,count,direct);error=ctypes.get_last_error()
    u.mem_write(0x30000400,raw);u.mem_write(0x30000500,bytes([0xcd])*(len(raw)+4));u.mem_write(0x30000502,bytes([0xa5])*len(raw));crt.io.last_error=9876
    got=call('GetStringTypeW',kind,0x30000400,count,0x30000502)
    check('GetStringTypeW real output/error/stdcall '+str(kind),got==(expected,16) and bytes(u.mem_read(0x30000502,len(raw)))==bytes(direct) and crt.io.last_error==error)
    check('GetStringTypeW source and output bound '+str(kind),bytes(u.mem_read(0x30000400,len(raw)))==raw and bytes(u.mem_read(0x30000500,2))+bytes(u.mem_read(0x30000502+len(raw),2))==bytes([0xcd])*4)
for locale in [None,'','en-US','tr-TR']:
    if locale is not None:u.mem_write(0x30000300,(locale+'\0').encode('utf-16le'))
    for flags in [0x100,0x200]:
        raw='Ab\u00e9I\0z'.encode('utf-16le');count=len(raw)//2
        src=ctypes.create_string_buffer(raw,len(raw));u.mem_write(0x30000400,raw)
        for capacity in [0,1,12]:
            initial=bytes([0xa5])*(capacity*2);direct=ctypes.create_string_buffer(initial,len(initial)) if capacity else None
            ctypes.set_last_error(9876);expected=c.K.LCMapStringEx(locale,flags,src,count,direct,capacity,None,None,0);error=ctypes.get_last_error()
            u.mem_write(0x30000500,bytes([0xcd])*(capacity*2+4))
            if capacity:u.mem_write(0x30000502,initial)
            crt.io.last_error=9876
            got=call('LCMapStringEx',0 if locale is None else 0x30000300,flags,0x30000400,count,0x30000502 if capacity else 0,capacity,0,0,0)
            check('LCMapStringEx direct return/error/bytes '+str((locale,flags,capacity)),got==(expected,36) and crt.io.last_error==error and (not capacity or bytes(u.mem_read(0x30000502,capacity*2))==bytes(direct)))
            check('LCMapStringEx source/bounds '+str((locale,flags,capacity)),bytes(u.mem_read(0x30000400,len(raw)))==raw and bytes(u.mem_read(0x30000500,2))+bytes(u.mem_read(0x30000502+capacity*2,2))==bytes([0xcd])*4)
for why,args in [('sort flag',(0,0x400,0x30000400,1,0,0,0,0,0)),('negative count',(0,0x100,0x30000400,0xffffffff,0,0,0,0,0)),('reserved',(0,0x100,0x30000400,1,0,0,0,1,0)),('overlap',(0,0x100,0x30000400,1,0x30000400,1,0,0,0))]:
    before=len(crt.events)
    try:call('LCMapStringEx',*args)
    except c.Rejected:check('unqualified '+why+' rejected before OS event',len(crt.events)==before)
    else:raise AssertionError(why)
result={'passed':True,'check_count':len(checks),'checks':checks,'native_execution':False,'events':crt.events,
 'sources':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in [Path(__file__),OUT/'crt_os.py']}}
(OUT/'nls_query_tests.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({'passed':True,'checks':len(checks)}))
