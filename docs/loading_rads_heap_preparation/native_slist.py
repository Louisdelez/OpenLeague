"""Execute the verified19-byte x86 Windows leaf; never call its host64 ABI."""
from pathlib import Path
import sys,hashlib
sys.dont_write_bytecode=True
sys.path.insert(0,r'E:\OpenLeague\tools\pythonlibs')
import pefile,unicorn
from unicorn.x86_const import UC_X86_REG_EIP
class SListBoundary(RuntimeError):pass
NT=Path('C:/Windows/SysWOW64/ntdll.dll')
KERNEL=Path('C:/Windows/SysWOW64/kernel32.dll')
NT_SHA='7e15bd30890e9bf93b47fc894a68b2445618ee7528eb39584a263b21e112f9df'
KERNEL_SHA='bafd9e061964642802d62f1eb694e7e4af60de739a8df1a492f90006dc5680f3'
CODE=bytes.fromhex('8bff558bec8b4508832000836004005dc20400')
class NativeSList:
    def __init__(self):
        raw=NT.read_bytes();kraw=KERNEL.read_bytes()
        if hashlib.sha256(raw).hexdigest()!=NT_SHA or hashlib.sha256(kraw).hexdigest()!=KERNEL_SHA:
            raise SListBoundary('Windows x86 source identity differs from qualified snapshot')
        pe=pefile.PE(data=raw);kernel=pefile.PE(data=kraw)
        if pe.FILE_HEADER.Machine!=0x14c or kernel.FILE_HEADER.Machine!=0x14c:raise SListBoundary('x86 Windows images required')
        export=next(x for x in pe.DIRECTORY_ENTRY_EXPORT.symbols if x.name==b'RtlInitializeSListHead')
        forward=next(x for x in kernel.DIRECTORY_ENTRY_EXPORT.symbols if x.name==b'InitializeSListHead')
        if forward.forwarder!=b'NTDLL.RtlInitializeSListHead' or export.forwarder is not None:
            raise SListBoundary('unexpected SList export routing')
        self.entry=pe.OPTIONAL_HEADER.ImageBase+export.address
        self.code=pe.get_data(export.address,len(CODE))
        if self.entry!=0x4b2ef0f0 or self.code!=CODE:raise SListBoundary('SList leaf source differs')
        self.page=self.entry&~0xfff;self.mapped=False;self.events=[]
        self.provenance={'kernel_path':str(KERNEL),'kernel_sha256':KERNEL_SHA,'ntdll_path':str(NT),'ntdll_sha256':NT_SHA,
          'export':'RtlInitializeSListHead','forwarder':'NTDLL.RtlInitializeSListHead','entry':self.entry,'rva':export.address,
          'bytes':len(self.code),'code_hex':self.code.hex(),'code_sha256':hashlib.sha256(self.code).hexdigest(),
          'scope':'One source-verified x86 leaf with no calls/imports/absolute references; not an ntdll module loader.'}
    def contains(self,pc,size):return self.entry<=pc and pc+size<=self.entry+len(self.code)
    def instruction_bytes(self,pc,size):
        if not self.contains(pc,size):raise SListBoundary('execution outside qualified Windows leaf')
        return self.code[pc-self.entry:pc-self.entry+size]
    def map_into(self,u):
        if self.mapped:return
        for low,high,_ in u.mem_regions():
            if self.page<=high and low<self.page+4096:raise SListBoundary('Windows leaf mapping overlaps machine')
        u.mem_map(self.page,4096);u.mem_write(self.entry,self.code)
        u.mem_protect(self.page,4096,unicorn.UC_PROT_READ|unicorn.UC_PROT_EXEC);self.mapped=True
    def dispatch(self,u,header):
        if not header or header&7 or header+8>0x100000000:raise SListBoundary('SList requires aligned8byte x86 header')
        before=bytes(u.mem_read(header,8))
        self.map_into(u)
        self.events.append({'operation':'native_leaf_call','header':header,'before_hex':before.hex(),'entry':self.entry})
        # Existing native stack supplies return address and argument. The real
        # leaf performs its two read/modify/writes and ret4, including flags.
        u.reg_write(UC_X86_REG_EIP,self.entry)
