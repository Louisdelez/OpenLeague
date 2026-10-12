"""Opt-in real padding observation for two pinned native strlen DWORD reads.

Logical capacity, Python accesses and every write remain requested-size bounded.
Only an identified invocation may observe 1..3 real host alignment bytes. The
snapshot is shared by its two reads; no padded string or length is synthesized.
"""
from pathlib import Path
import ctypes,hashlib,struct
from ctypes import wintypes as w
import unicorn
from unicorn.x86_const import UC_X86_REG_EIP,UC_X86_REG_ESP,UC_X86_REG_EAX,UC_X86_REG_ECX,UC_X86_REG_EDX,UC_X86_REG_EFLAGS
from heap_mirrors import BASE,END,SLOT
from isolated_io import K,sig,Rejected
import pefile

ENTRY=0x100f86d0
SOURCE_BYTES=139
SOURCE_SHA='5044fc769fb26ae1772d18e3e1ef5ffc16757c910207278cab8d90af3557a7f0'
DLL_SHA='60833cd552d93b93304d4937912951e144e38db5d70793eb60a0c5f5d579e521'
DLL=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\RiotRadsIO.dll')
READS={0x100f8700:bytes.fromhex('8b01'),0x100f8718:bytes.fromhex('8b41fc')}
sig('GetCurrentProcess',[],w.HANDLE)
sig('ReadProcessMemory',[w.HANDLE,ctypes.c_void_p,ctypes.c_void_p,ctypes.c_size_t,ctypes.POINTER(ctypes.c_size_t)],w.BOOL)

class PhysicalTailReader:
    def __init__(self):self.events=[]
    def read(self,address,count):
        if not 1<=count<=3:raise Rejected('physical alignment read is limited to1..3bytes')
        incoming=ctypes.get_last_error()
        try:
            out=ctypes.create_string_buffer(count);read=ctypes.c_size_t()
            success=K.ReadProcessMemory(K.GetCurrentProcess(),address,out,count,ctypes.byref(read))
            error=ctypes.get_last_error()
            self.events.append(dict(api='ReadProcessMemory',injected=False,success=bool(success),
                requested=count,transferred=read.value,last_error=error,host_address=address,
                bytes_hex=out.raw.hex() if success and read.value==count else None))
            if not success or read.value!=count:raise Rejected('physical alignment ReadProcessMemory failed or incomplete')
            return bytes(out)
        finally:ctypes.set_last_error(incoming)

class NativeStrlenTail:
    def __init__(self,arena,reader=None):
        raw=DLL.read_bytes()
        if hashlib.sha256(raw).hexdigest()!=DLL_SHA:raise Rejected('unrecognized RADS source DLL')
        pe=pefile.PE(data=raw);code=pe.get_data(ENTRY-pe.OPTIONAL_HEADER.ImageBase,SOURCE_BYTES)
        if hashlib.sha256(code).hexdigest()!=SOURCE_SHA:raise Rejected('unrecognized native strlen code')
        self.arena=arena;self.u=arena.u;self.code=code;self.reader=reader or PhysicalTailReader()
        self.stack=[];self.events=[];self.next_id=0
        self.provenance=dict(path=str(DLL),dll_sha256=DLL_SHA,va=ENTRY,bytes=SOURCE_BYTES,sha256=SOURCE_SHA)
        if arena.native_read_policy is not None:raise Rejected('native read policy already owned')
        arena.native_read_policy=self
        self.hook=self.u.hook_add(unicorn.UC_HOOK_CODE,self.observe)
    def observe_return(self):
        if not self.stack:return
        top=self.stack[-1]
        if self.u.reg_read(UC_X86_REG_EIP)==top['return_pc'] and self.u.reg_read(UC_X86_REG_ESP)==top['sp']+4:
            self.stack.pop()
            self.events.append(dict(kind='native_return',invocation=top['id'],
                eax=self.u.reg_read(UC_X86_REG_EAX),ecx=self.u.reg_read(UC_X86_REG_ECX),
                edx=self.u.reg_read(UC_X86_REG_EDX),eflags=self.u.reg_read(UC_X86_REG_EFLAGS)))
    def observe(self,u,pc,size,user):
        self.observe_return()
        if pc!=ENTRY:return
        if bytes(self.u.mem_read(ENTRY,SOURCE_BYTES))!=self.code:raise Rejected('native strlen source bytes modified')
        sp=u.reg_read(UC_X86_REG_ESP)
        ret,arg=struct.unpack('<II',bytes(self.arena.guarded.mem_read(sp,8)))
        region=self.arena.regions[(arg-BASE)//SLOT] if BASE<=arg<END else None
        owner=region.owner if region else None
        if not(owner and owner.phase=='live' and owner.region is region and region.base<=arg<region.base+owner.requested):owner=None
        ctx=dict(id=self.next_id,sp=sp,return_pc=ret,arg=arg,owner=owner,
                 raw=owner.raw if owner else None,requested=owner.requested if owner else None,
                 region=region if owner else None,tail=None,tail_address=None)
        self.next_id+=1;self.stack.append(ctx)
        self.events.append(dict(kind='entry',invocation=ctx['id'],sp=sp,return_pc=ret,arg=arg,owner=owner.index if owner else None))
    def allow(self,u,access,address,size):
        pc=u.reg_read(UC_X86_REG_EIP)
        if access!=unicorn.UC_MEM_READ or size!=4 or address&3 or pc not in READS or not self.stack:return False
        ctx=self.stack[-1];owner=ctx['owner'];region=ctx['region']
        if owner is None or owner.phase!='live' or owner.region is not region or owner.raw!=ctx['raw'] or owner.requested!=ctx['requested']:return False
        if u.reg_read(UC_X86_REG_ESP)!=ctx['sp']:return False
        if bytes(self.arena.guarded.mem_read(ctx['sp'],8))!=struct.pack('<II',ctx['return_pc'],ctx['arg']):return False
        if bytes(self.u.mem_read(pc,len(READS[pc])))!=READS[pc]:raise Rejected('native strlen read instruction modified')
        end=region.base+owner.requested;valid=end-address
        if not region.mapped or not(region.base<=ctx['arg']<=address<end) or not 1<=valid<=3 or address+4!=((end+3)&~3):return False
        suffix=bytes(self.arena.guarded.mem_read(address,valid))
        if b'\0' not in suffix:return False
        incoming=ctypes.get_last_error()
        try:
            if ctx['tail'] is None:
                tail=self.reader.read(owner.raw+owner.requested,4-valid)
                if len(tail)!=4-valid:raise Rejected('physical reader returned incomplete padding snapshot')
                ctx['tail']=tail;ctx['tail_address']=end
            elif ctx['tail_address']!=end or len(ctx['tail'])!=4-valid:
                raise Rejected('native strlen alignment window changed within invocation')
            # Internal initialization of a read window. Public writes remain denied.
            self.u.mem_write(end,ctx['tail'])
            self.events.append(dict(kind='bounded_native_read',invocation=ctx['id'],pc=pc,address=address,
                owner=owner.index,requested=owner.requested,valid_bytes=valid,valid_hex=suffix.hex(),
                padding_hex=ctx['tail'].hex(),padding_source='real current-process ReadProcessMemory snapshot'))
            return True
        finally:ctypes.set_last_error(incoming)
    def abandon(self,reason):
        for ctx in self.stack:self.events.append(dict(kind='abandoned',invocation=ctx['id'],reason=reason))
        self.stack.clear()
