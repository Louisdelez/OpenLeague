"""Bounded Win32 bridge: read-only source mapping, Config-only scratch writes.

The virtual deployment is an explicit probe input, not a historical process CWD.
Unknown APIs and unsupported access flags are rejected rather than emulated.
"""
from pathlib import Path
from contextlib import contextmanager
import ctypes, ntpath, os, hashlib
from ctypes import wintypes as w

SOURCE=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20')
DEPLOY_REL=Path('RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy')
WORKSPACE=Path('E:/mapslol3v3/loading_provider_io_probe')
K=ctypes.WinDLL('kernel32',use_last_error=True)
INVALID=ctypes.c_void_p(-1).value
READ=0x80000000; WRITE=0x40000000
class Rejected(RuntimeError):pass
class FindData(ctypes.Structure):
    _fields_=[('attr',w.DWORD),('creation',w.FILETIME),('access',w.FILETIME),('write',w.FILETIME),
        ('high',w.DWORD),('low',w.DWORD),('reserved0',w.DWORD),('reserved1',w.DWORD),
        ('name',w.WCHAR*260),('alternate',w.WCHAR*14)]
class FileInfo(ctypes.Structure):
    _fields_=[('attr',w.DWORD),('creation',w.FILETIME),('access',w.FILETIME),('write',w.FILETIME),
        ('volume',w.DWORD),('high',w.DWORD),('low',w.DWORD),('links',w.DWORD),('indexhigh',w.DWORD),('indexlow',w.DWORD)]
def sig(name,args,result):
    f=getattr(K,name);f.argtypes=args;f.restype=result;return f
sig('GetFileAttributesW',[w.LPCWSTR],w.DWORD)
sig('CreateDirectoryW',[w.LPCWSTR,ctypes.c_void_p],w.BOOL)
sig('CreateFileW',[w.LPCWSTR,w.DWORD,w.DWORD,ctypes.c_void_p,w.DWORD,w.DWORD,w.HANDLE],w.HANDLE)
sig('ReadFile',[w.HANDLE,ctypes.c_void_p,w.DWORD,ctypes.POINTER(w.DWORD),ctypes.c_void_p],w.BOOL)
sig('WriteFile',[w.HANDLE,ctypes.c_void_p,w.DWORD,ctypes.POINTER(w.DWORD),ctypes.c_void_p],w.BOOL)
sig('CloseHandle',[w.HANDLE],w.BOOL)
sig('GetFileInformationByHandle',[w.HANDLE,ctypes.POINTER(FileInfo)],w.BOOL)
sig('GetFinalPathNameByHandleW',[w.HANDLE,w.LPWSTR,w.DWORD,w.DWORD],w.DWORD)
sig('FindFirstFileW',[w.LPCWSTR,ctypes.POINTER(FindData)],w.HANDLE)
sig('FindNextFileW',[w.HANDLE,ctypes.POINTER(FindData)],w.BOOL)
sig('FindClose',[w.HANDLE],w.BOOL)
sig('SetFilePointer',[w.HANDLE,ctypes.c_long,ctypes.POINTER(ctypes.c_long),w.DWORD],w.DWORD)
sig('GetFileSize',[w.HANDLE,ctypes.POINTER(w.DWORD)],w.DWORD)
sig('SetEndOfFile',[w.HANDLE],w.BOOL)
def extended(p):return '\\\\?\\'+str(p)
def folded(p):return ntpath.normcase(ntpath.normpath(str(p)))
def within(p,root):return folded(p)==folded(root) or folded(p).startswith(folded(root)+'\\')
def inspect_chain(p):
    """Reject every existing reparse component, including ancestors of our root."""
    for part in reversed([p,*p.parents]):
        try:s=part.lstat()
        except FileNotFoundError:continue
        if s.st_file_attributes&0x400:raise Rejected('reparse component: '+str(part))
    resolved=p.resolve(strict=False)
    if folded(resolved)!=folded(p):raise Rejected('resolved path differs: '+str(p))
def handle_info(h,expected):
    info=FileInfo()
    if not K.GetFileInformationByHandle(h,ctypes.byref(info)):raise ctypes.WinError(ctypes.get_last_error())
    if info.attr&0x400:raise Rejected('reparse handle')
    # GetFinalPathNameByHandleW is denied in this sandbox. Compare the actual
    # opened file ID to lstat of the already confined, non-reparse path instead.
    # Existing ancestor handles stay pinned until the write/open completes.
    stat=expected.lstat()
    if stat.st_file_attributes&0x400 or stat.st_ino!=((info.indexhigh<<32)|info.indexlow):raise Rejected('opened handle identity mismatch')
    return info
def require_exclusive_file(info):
    if info.links!=1:raise Rejected('write hardlink is not exclusive')
@contextmanager
def pin_parents(p):
    """Hold existing parent directories against rename/reparse during a write."""
    held=[]
    try:
        inspect_chain(p)
        for part in reversed(list(p.parents)):
            h=K.CreateFileW(extended(part),0x80,1,None,3,0x02200000,None)
            if h==INVALID:
                error=ctypes.get_last_error()
                if error in (2,3):break # Let the actual requested API return its real missing-parent error.
                raise ctypes.WinError(error)
            held.append(h);info=handle_info(h,part)
            if not (info.attr&16):raise Rejected('parent identity mismatch')
        inspect_chain(p)
        yield
    finally:
        for h in reversed(held):K.CloseHandle(h)
def ansi_find(d):
    name=d.name.encode('ascii');alt=d.alternate.encode('ascii')
    if len(name)>=260 or len(alt)>=14:raise Rejected('native find name too long')
    return bytes(d)[:44]+name.ljust(260,b'\0')+alt.ljust(14,b'\0')+b'\0\0'

class Bridge:
    def __init__(self,root):
        self.root=Path(ntpath.abspath(str(root)));self.source=SOURCE
        if not within(self.root,WORKSPACE) or folded(self.root)==folded(WORKSPACE):raise Rejected('root outside owned package')
        inspect_chain(self.root);inspect_chain(self.source)
        if self.root.exists():raise Rejected('fresh private root required')
        self.root.mkdir(parents=True)
        self.cwd=self.root/DEPLOY_REL
        # Only empty directory structure; original resource files stay in source.
        self.cwd.mkdir(parents=True)
        self.events=[];self.handles={};self.finds={};self.next_label=0x61000000;self.last_error=0
        self.shadow_roots=set();self.consumed={}
    def resolve(self,query,write=False,wildcards=False):
        if not isinstance(query,str) or not query or not query.isascii() or '\0'in query:raise Rejected('invalid native ASCII path')
        q=query.replace('/','\\')
        if q.startswith('\\') or q.startswith('\\\\?\\'):raise Rejected('UNC/device/root-relative path unsupported')
        drive,tail=ntpath.splitdrive(q)
        if drive and not tail.startswith('\\'):raise Rejected('drive-relative path unsupported')
        for component in tail.split('\\'):
            if component in ('','.','..'):continue
            if ':'in component or component.endswith((' ','.')):raise Rejected('ambiguous path component')
            stem=component.split('.')[0].upper()
            if stem in {'CON','PRN','AUX','NUL',*[f'COM{i}' for i in range(1,10)],*[f'LPT{i}' for i in range(1,10)]}:raise Rejected('DOS device path')
        absolute=ntpath.normpath(q if drive else ntpath.join(str(self.cwd),q))
        if not within(absolute,self.root):raise Rejected('virtual path escapes root')
        relative=ntpath.relpath(absolute,str(self.root));parts=Path(relative).parts
        if any('*'in p or '?'in p for p in parts[:-1]) or (not wildcards and ('*'in relative or '?'in relative)):raise Rejected('wildcards unsupported here')
        key=folded(relative)
        if write and (not parts or parts[0].casefold()!='config'):raise Rejected('write outside Config allowlist')
        shadow=any(key==s or key.startswith(s+'\\') for s in self.shadow_roots)
        base=self.root if write or shadow else self.source
        target=base/relative
        inspect_chain(target.parent if wildcards else target)
        if not within(target.resolve(strict=False),base):raise Rejected('physical mapping escapes root')
        return target,relative,shadow
    def note(self,api,query,target,result,**kw):
        self.last_error=ctypes.get_last_error()
        self.events.append(dict(api=api,query=query,physical_path=str(target),result=result,last_error=self.last_error,**kw))
    def attributes(self,q):
        target,_,shadow=self.resolve(q);ctypes.set_last_error(0)
        result=K.GetFileAttributesW(extended(target));self.note('GetFileAttributesA',q,target,result,shadow=shadow);return result
    def mkdir(self,q):
        target,rel,_=self.resolve(q,write=True)
        with pin_parents(target):
            ctypes.set_last_error(0);result=K.CreateDirectoryW(extended(target),None);error=ctypes.get_last_error()
        ctypes.set_last_error(error);self.note('CreateDirectoryA',q,target,int(bool(result)))
        if result:self.shadow_roots.add(folded(rel))
        return int(bool(result))
    def open(self,q,access=READ,share=1,creation=3,flags=0x80):
        # No DELETE/FILE_APPEND_DATA/GENERIC_ALL or flags that mutate source.
        if access&~(READ|WRITE) or access==0 or share&~7 or creation not in (1,2,3,4,5) or flags not in (0,0x80):raise Rejected('unsupported CreateFile flags')
        write=bool(access&WRITE) or creation!=3
        if write and not access&WRITE:raise Rejected('creation requires explicit write access')
        target,rel,shadow=self.resolve(q,write=write)
        with pin_parents(target):
            # Do not truncate an existing hardlink/reparse file before its
            # identity and link count have been checked on this exact handle.
            open_creation={2:4,5:3}.get(creation,creation)
            ctypes.set_last_error(0);h=K.CreateFileW(extended(target),access,share,None,open_creation,flags|0x00200000,None);error=ctypes.get_last_error()
            if h!=INVALID:
                try:
                    info=handle_info(h,target)
                    if write and not within(target,self.root):raise Rejected('opened file escaped mapping')
                    if write:require_exclusive_file(info)
                    if creation in (2,5) and not K.SetEndOfFile(h):raise ctypes.WinError(ctypes.get_last_error())
                except Exception:K.CloseHandle(h);raise
        ctypes.set_last_error(error)
        if h==INVALID:label=0xffffffff
        else:
            label=self.next_label;self.next_label+=4;self.handles[label]=dict(handle=h,write=write,read=bool(access&READ),path=target)
            if write:self.shadow_roots.add(folded(rel))
        self.note('CreateFileA',q,target,label,access=access,creation=creation,shadow=shadow);return label
    def read(self,label,n):
        if label not in self.handles or not 0<=n<=0x100000:raise Rejected('invalid/big file read')
        item=self.handles[label]
        if not item['read']:raise Rejected('read on write-only handle')
        buf=ctypes.create_string_buffer(n);done=w.DWORD();ctypes.set_last_error(0)
        result=K.ReadFile(item['handle'],buf,n,ctypes.byref(done),None);self.note('ReadFile',None,item['path'],int(bool(result)),requested=n,read=done.value)
        b=buf.raw[:done.value]
        self.events[-1]['returned_sha256']=hashlib.sha256(b).hexdigest()
        return bool(result),b
    def write(self,label,b):
        if label not in self.handles or len(b)>0x100000:raise Rejected('invalid/big file write')
        item=self.handles[label]
        if not item['write'] or not within(item['path'],self.root):raise Rejected('write on source/read-only handle')
        done=w.DWORD();ctypes.set_last_error(0);result=K.WriteFile(item['handle'],b,len(b),ctypes.byref(done),None)
        self.note('WriteFile',None,item['path'],int(bool(result)),requested=len(b),written=done.value);return bool(result),done.value
    def close(self,label):
        if label not in self.handles:raise Rejected('unknown file handle')
        item=self.handles[label];ctypes.set_last_error(0);result=K.CloseHandle(item['handle']);self.note('CloseHandle',None,item['path'],int(bool(result)))
        if result:del self.handles[label]
        return int(bool(result))
    def find_first(self,q):
        target,_,shadow=self.resolve(q,wildcards=True);d=FindData();ctypes.set_last_error(0)
        h=K.FindFirstFileW(extended(target),ctypes.byref(d));error=ctypes.get_last_error()
        if h==INVALID:label=0xffffffff;data=None
        else:
            try:data=ansi_find(d)
            except Exception:K.FindClose(h);raise
            label=self.next_label;self.next_label+=4;self.finds[label]=(h,target)
        ctypes.set_last_error(error);self.note('FindFirstFileA',q,target,label,first_name=d.name if data else None,shadow=shadow)
        return label,data
    def find_next(self,label):
        if label not in self.finds:raise Rejected('unknown find handle')
        h,target=self.finds[label];d=FindData();ctypes.set_last_error(0);ok=K.FindNextFileW(h,ctypes.byref(d));error=ctypes.get_last_error()
        data=ansi_find(d) if ok else None;ctypes.set_last_error(error);self.note('FindNextFileA',None,target,int(bool(ok)),name=d.name if ok else None);return int(bool(ok)),data
    def find_close(self,label):
        if label not in self.finds:raise Rejected('unknown find handle')
        h,target=self.finds[label];ctypes.set_last_error(0);ok=K.FindClose(h);self.note('FindClose',None,target,int(bool(ok)))
        if ok:del self.finds[label]
        return int(bool(ok))
    def cleanup(self):
        for label in list(self.finds):self.find_close(label)
        for label in list(self.handles):self.close(label)
