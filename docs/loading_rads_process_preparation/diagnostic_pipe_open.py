"""One authorised local diagnostic-pipe open, with no IPC data operation.

This helper deliberately does not extend the filesystem Bridge or return an
opened handle to native code. Success is a terminal probe boundary.
"""
import ctypes
from ctypes import wintypes as w

PATH=r'\\.\pipe\LogViewerPipe'
EXPECTED=(0x40000000,0,0,3,0x40000000,0)
K=ctypes.WinDLL('kernel32',use_last_error=True)
K.CreateFileA.argtypes=[w.LPCSTR,w.DWORD,w.DWORD,ctypes.c_void_p,w.DWORD,w.DWORD,w.HANDLE]
K.CreateFileA.restype=w.HANDLE
K.CloseHandle.argtypes=[w.HANDLE]
K.CloseHandle.restype=w.BOOL
INVALID=ctypes.c_void_p(-1).value

class DiagnosticPipeOpen:
    def __init__(self):
        self.events=[]
        self.handle=None
    def attempt(self,path,args):
        if path!=PATH or tuple(args)!=EXPECTED:
            raise ValueError('diagnostic pipe open differs from sole authorised literal/arguments')
        ctypes.set_last_error(0)
        h=K.CreateFileA(path.encode('ascii'),*args)
        error=ctypes.get_last_error()
        result={'api':'CreateFileA','path':path,'arguments':list(args),
                'succeeded':h!=INVALID,'native_result':0xffffffff if h==INVALID else None,
                'last_error':error,'bytes_written':0,'data_operations':0}
        self.events.append(result)
        if h!=INVALID:
            self.handle=h
            self.cleanup()
        ctypes.set_last_error(error)
        return result
    def cleanup(self):
        if self.handle is not None:
            ctypes.set_last_error(0)
            ok=K.CloseHandle(self.handle)
            self.events.append({'api':'CloseHandle','success':bool(ok),'last_error':ctypes.get_last_error()})
            if ok:self.handle=None
            else:raise ctypes.WinError(ctypes.get_last_error())
