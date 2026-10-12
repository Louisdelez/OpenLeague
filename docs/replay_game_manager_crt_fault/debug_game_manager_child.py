"""Debug only a newly created, hidden diagnostic child. No attachment, symbol server or network."""
import ctypes as C
from ctypes import wintypes as W
from pathlib import Path
import json, struct, sys, time

K=C.WinDLL('kernel32',use_last_error=True)
PVOID=C.c_void_p
U64=C.c_uint64
class EXCEPTION_RECORD(C.Structure):
    _fields_=[('code',W.DWORD),('flags',W.DWORD),('record',PVOID),('address',PVOID),('count',W.DWORD),('information',U64*15)]
class EXCEPTION_DEBUG_INFO(C.Structure):
    _fields_=[('record',EXCEPTION_RECORD),('first',W.DWORD)]
class CREATE_THREAD_DEBUG_INFO(C.Structure):
    _fields_=[('thread',W.HANDLE),('tls',PVOID),('start',PVOID)]
class CREATE_PROCESS_DEBUG_INFO(C.Structure):
    _fields_=[('file',W.HANDLE),('process',W.HANDLE),('thread',W.HANDLE),('base',PVOID),('offset',W.DWORD),('size',W.DWORD),('tls',PVOID),('start',PVOID),('name',PVOID),('unicode',W.WORD)]
class LOAD_DLL_DEBUG_INFO(C.Structure):
    _fields_=[('file',W.HANDLE),('base',PVOID),('offset',W.DWORD),('size',W.DWORD),('name',PVOID),('unicode',W.WORD)]
class EVENT_UNION(C.Union):
    _fields_=[('exception',EXCEPTION_DEBUG_INFO),('create_process',CREATE_PROCESS_DEBUG_INFO),('create_thread',CREATE_THREAD_DEBUG_INFO),('load_dll',LOAD_DLL_DEBUG_INFO),('exit_code',W.DWORD),('unload_base',PVOID)]
class DEBUG_EVENT(C.Structure):
    _fields_=[('code',W.DWORD),('pid',W.DWORD),('tid',W.DWORD),('u',EVENT_UNION)]
class STARTUPINFO(C.Structure):
    _fields_=[('cb',W.DWORD),('reserved',W.LPWSTR),('desktop',W.LPWSTR),('title',W.LPWSTR),('x',W.DWORD),('y',W.DWORD),('cx',W.DWORD),('cy',W.DWORD),('charsx',W.DWORD),('charsy',W.DWORD),('fill',W.DWORD),('flags',W.DWORD),('show',W.WORD),('reserved2_size',W.WORD),('reserved2',PVOID),('stdin',W.HANDLE),('stdout',W.HANDLE),('stderr',W.HANDLE)]
class PROCESS_INFORMATION(C.Structure):
    _fields_=[('process',W.HANDLE),('thread',W.HANDLE),('pid',W.DWORD),('tid',W.DWORD)]
class SECURITY_ATTRIBUTES(C.Structure):
    _fields_=[('length',W.DWORD),('descriptor',PVOID),('inherit',W.BOOL)]
def api(name,args,result):
    f=getattr(K,name); f.argtypes=args; f.restype=result; return f
create_file=api('CreateFileW',[W.LPCWSTR,W.DWORD,W.DWORD,C.POINTER(SECURITY_ATTRIBUTES),W.DWORD,W.DWORD,W.HANDLE],W.HANDLE)
close=api('CloseHandle',[W.HANDLE],W.BOOL)
create=api('CreateProcessW',[W.LPCWSTR,W.LPWSTR,PVOID,PVOID,W.BOOL,W.DWORD,PVOID,W.LPCWSTR,C.POINTER(STARTUPINFO),C.POINTER(PROCESS_INFORMATION)],W.BOOL)
wait=api('WaitForDebugEvent',[C.POINTER(DEBUG_EVENT),W.DWORD],W.BOOL)
cont=api('ContinueDebugEvent',[W.DWORD,W.DWORD,W.DWORD],W.BOOL)
terminate=api('TerminateProcess',[W.HANDLE,W.UINT],W.BOOL)
open_thread=api('OpenThread',[W.DWORD,W.BOOL,W.DWORD],W.HANDLE)
get_context=api('GetThreadContext',[W.HANDLE,PVOID],W.BOOL)
read_process=api('ReadProcessMemory',[W.HANDLE,PVOID,PVOID,C.c_size_t,C.POINTER(C.c_size_t)],W.BOOL)
path_by_handle=api('GetFinalPathNameByHandleW',[W.HANDLE,W.LPWSTR,W.DWORD,W.DWORD],W.DWORD)
assert C.sizeof(DEBUG_EVENT)==176 and C.sizeof(STARTUPINFO)==104 and C.sizeof(EXCEPTION_RECORD)==152

def main():
    exe=Path(sys.argv[1]); root=Path(sys.argv[2]); out=Path(sys.argv[3])
    if not exe.is_absolute() or not root.is_absolute() or not out.is_absolute():raise SystemExit('Use explicit absolute paths')
    # Limit process creation to the requested local diagnostic binary and command.
    if exe.name!='openleague-client.exe':raise SystemExit('Unexpected diagnostic executable name')
    report={'executable':str(exe),'arguments':['--native-replay-game-manager-probe',str(root)],'events':[],'modules':[],'fault':None}
    sa=SECURITY_ATTRIBUTES(C.sizeof(SECURITY_ATTRIBUTES),None,True)
    output=create_file(str(out.with_suffix('.child.log')),0x40000000,3,C.byref(sa),2,0x80,None)
    if output in (None,C.c_void_p(-1).value):raise C.WinError(C.get_last_error())
    si=STARTUPINFO();si.cb=C.sizeof(si);si.flags=0x100;si.stdout=output;si.stderr=output
    pi=PROCESS_INFORMATION();cmd=C.create_unicode_buffer(f'"{exe}" --native-replay-game-manager-probe "{root}"')
    if not create(str(exe),cmd,None,None,True,0x08000002,None,str(root),C.byref(si),C.byref(pi)):
        close(output);raise C.WinError(C.get_last_error())
    close(output);report['pid']=pi.pid
    print('Created owned diagnostic child',pi.pid,flush=True)
    modules={};deadline=time.monotonic()+30;exited=False;captured=False
    def read(at,size):
        b=C.create_string_buffer(size);n=C.c_size_t()
        ok=read_process(pi.process,at,b,size,C.byref(n))
        return b.raw[:n.value] if ok or n.value else b''
    def location(at):
        for base,m in modules.items():
            if base<=at<base+m['size']:return {'module':m['path'],'rva':hex(at-base)}
        return None
    def module(handle,base):
        path='';buf=C.create_unicode_buffer(32768)
        if handle and path_by_handle(handle,buf,len(buf),0):path=buf.value
        header=read(base,0x40);size=0
        if len(header)==0x40:
            off=struct.unpack_from('<I',header,0x3c)[0];nt=read(base+off,0x60)
            if len(nt)>=0x54:size=struct.unpack_from('<I',nt,0x50)[0]
        modules[base]={'base':hex(base),'size':size,'path':path}
        if handle:close(handle)
    try:
        while time.monotonic()<deadline:
            event=DEBUG_EVENT()
            if not wait(C.byref(event),200):
                if C.get_last_error()==121:continue
                raise C.WinError(C.get_last_error())
            status=0x00010002
            row={'code':event.code,'pid':event.pid,'tid':event.tid}
            if event.code==3:
                d=event.u.create_process;module(d.file,d.base);row['base']=hex(d.base)
            elif event.code==6:
                d=event.u.load_dll;module(d.file,d.base);row['base']=hex(d.base)
            elif event.code==7:modules.pop(event.u.unload_base,None)
            elif event.code==2:row['start']=hex(event.u.create_thread.start or 0)
            elif event.code in (4,5):row['exit']=hex(event.u.exit_code)
            elif event.code==1:
                ex=event.u.exception;row.update(exception=hex(ex.record.code),first_chance=bool(ex.first),address=hex(ex.record.address or 0))
                # Leave thread-naming SEH and other exceptions to the target's handler.
                status=0x00010002 if ex.record.code==0x80000003 else 0x80010001
                if ex.record.code==0xc0000005:
                    h=open_thread(0x48,False,event.tid)
                    if not h:raise C.WinError(C.get_last_error())
                    backing=C.create_string_buffer(1232+16);addr=(C.addressof(backing)+15)&~15
                    C.memset(addr,0,1232);C.c_uint32.from_address(addr+48).value=0x100003
                    try:
                        if not get_context(h,addr):raise C.WinError(C.get_last_error())
                        offsets={'rax':120,'rcx':128,'rdx':136,'rbx':144,'rsp':152,'rbp':160,'rsi':168,'rdi':176,'r8':184,'r9':192,'r10':200,'r11':208,'r12':216,'r13':224,'r14':232,'r15':240,'rip':248}
                        regs={name:C.c_uint64.from_address(addr+off).value for name,off in offsets.items()}
                        stack=read(regs['rsp'],4096)
                        values=[{'slot':hex(regs['rsp']+i),'address':hex(struct.unpack_from('<Q',stack,i)[0]),'location':location(struct.unpack_from('<Q',stack,i)[0])} for i in range(0,len(stack)-7,8)]
                        report['fault']={'event':row,'registers':{k:hex(v) for k,v in regs.items()},'location':location(regs['rip']),'access_information':[hex(ex.record.information[i]) for i in range(min(ex.record.count,15))],'stack_words':values,'stack_read_bytes':len(stack),'context_alignment':addr%16}
                    finally:close(h)
                    captured=True
            report['events'].append(row)
            if event.code==5:exited=True
            if captured:
                report['modules']=list(modules.values());out.write_text(json.dumps(report,indent=2),encoding='utf-8')
                print('Captured access violation',report['fault']['location'],'to',out,flush=True)
                # Only this helper-created debug child may be terminated.
                terminate(pi.process,0xc0000005)
            if not cont(event.pid,event.tid,status):raise C.WinError(C.get_last_error())
            if exited or captured:break
        if not exited and not captured:report['timeout']=True;terminate(pi.process,0xdead0030)
    finally:
        if not exited:terminate(pi.process,0xc0000005 if captured else 0xdead0030)
        report['modules']=list(modules.values());out.write_text(json.dumps(report,indent=2),encoding='utf-8')
        close(pi.thread);close(pi.process)
    print('Debugger complete: fault=',captured,'normal_exit=',exited,flush=True)

if __name__=='__main__':main()
