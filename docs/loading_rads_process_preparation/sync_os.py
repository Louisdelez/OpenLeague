"""Owned unnamed synchronization handles for the bounded RADS initializers.

No guest waits, signalling, threads, named objects, inherited handles, or ETW.
The registry owns each real handle independently of native wrapper allocation.
"""
import ctypes
from ctypes import wintypes as w
from isolated_io import K,sig,Rejected
P=ctypes.c_void_p
sig('CreateSemaphoreA',[P,w.LONG,w.LONG,ctypes.c_char_p],w.HANDLE)
sig('CreateEventA',[P,w.BOOL,w.BOOL,ctypes.c_char_p],w.HANDLE)
sig('CloseHandle',[w.HANDLE],w.BOOL)

class SyncOs:
    def __init__(self,machine,io):
        self.m=machine;self.io=io;self.handles={};self.next_label=0x72000000;self.events=[]
    def create(self,name,args):
        security,a,b,object_name=args
        if security or object_name:raise Rejected('only unnamed noninherited synchronization handles are qualified')
        if name=='CreateEventA' and (a not in (0,1) or b not in (0,1)):
            raise Rejected('event BOOL profile must be0/1')
        if name not in ('CreateSemaphoreA','CreateEventA'):raise Rejected('unknown synchronization creator')
        # Reserve the ownership record before the OS can return a resource.
        if self.next_label>=0x72010000:raise Rejected('synchronization label bank exhausted')
        label=self.next_label;self.next_label+=4
        record={'kind':name,'raw':None,'state':'reserved'};self.handles[label]=record
        ctypes.set_last_error(self.io.last_error)
        if name=='CreateSemaphoreA':raw=K.CreateSemaphoreA(None,ctypes.c_int32(a).value,ctypes.c_int32(b).value,None)
        else:raw=K.CreateEventA(None,a,b,None)
        error=ctypes.get_last_error()
        # Adopt before logging, emulator writes/returns, or native allocation.
        record['raw']=raw;record['state']='owned' if raw else 'creation_failed'
        if not raw:del self.handles[label]
        self.io.last_error=error
        self.events.append({'api':name,'args':list(args),'result':label if raw else 0,'last_error':error})
        return label if raw else 0
    def close(self,label,cleanup=False):
        if label and label not in self.handles:raise Rejected('unknown synchronization handle')
        record=self.handles.get(label)
        if record is not None and record['state']!='owned':raise Rejected('synchronization handle has no owned OS backing')
        raw=record['raw'] if record is not None else None
        ctypes.set_last_error(self.io.last_error)
        result=K.CloseHandle(raw);error=ctypes.get_last_error()
        if result and record is not None:
            record['state']='closed';record['raw']=None;del self.handles[label]
        self.io.last_error=error
        self.events.append({'api':'cleanup_CloseHandle' if cleanup else 'CloseHandle','handle':label,'result':result,'last_error':error})
        return result
    def dispatch(self,name):
        m=self.m;sp=m['u'].reg_read(m['UC_X86_REG_ESP']);arg=lambda i:m['read32'](sp+4*i)
        if name in ('CreateSemaphoreA','CreateEventA'):
            m['finish'](self.create(name,[arg(i) for i in range(1,5)]),16);return True
        if name=='CloseHandle' and (arg(1)==0 or arg(1) in self.handles):
            m['finish'](self.close(arg(1)),4);return True
        return False
    def cleanup(self):
        errors=[]
        for label in list(self.handles):
            try:self.close(label,cleanup=True)
            except Exception as error:errors.append({'handle':label,'error':repr(error)})
        return errors
