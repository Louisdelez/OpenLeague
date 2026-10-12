"""Bounded guest mirrors with one stable owner per actual process-heap block.

This is an OS boundary adapter, not a replacement for either native CRT.
Only flags0 HeapReAlloc is admitted. Host exceptions stop the guest; cleanup
retains raw and mapped ownership independently and can be retried.
"""
from dataclasses import dataclass
import ctypes
import unicorn
from isolated_io import Rejected

BASE=0x50000000
END=0x70000000
SLOT=0x100000
PAGE=0x1000

@dataclass(slots=True)
class Region:
    base:int
    mapped:int=0
    owner:object=None

@dataclass(slots=True)
class Owner:
    index:int
    raw:int=0
    requested:int=0
    region:object=None
    candidate:object=None
    phase:str='unused'
    primary_error:object=None
    last_error:int=0
    old_raw:int=0
    returned_raw:int=0
    moved:object=None

class GuardedMemory:
    """Cover explicit Python memory reads/writes as well as guest hook accesses."""
    def __init__(self,arena):self.arena=arena
    def __getattr__(self,name):return getattr(self.arena.u,name)
    def mem_read(self,address,size):
        self.arena.validate_access(address,size)
        return self.arena.u.mem_read(address,size)
    def mem_write(self,address,data):
        self.arena.validate_access(address,len(data))
        return self.arena.u.mem_write(address,data)
    def mem_map(self,address,size,*args,**kwargs):
        self.arena.reject_external_mapping(address,size)
        return self.arena.u.mem_map(address,size,*args,**kwargs)
    def mem_unmap(self,address,size):
        self.arena.reject_external_mapping(address,size)
        return self.arena.u.mem_unmap(address,size)

class HeapMirrors:
    def __init__(self,u,api,heap):
        # api() is resolved per operation, allowing explicitly labelled test faults.
        self.u=u;self.api=api;self.heap=heap
        for low,high,_ in u.mem_regions():
            if low<END and high+1>BASE:raise Rejected('CRT mirror reservation overlaps existing mapping')
        self.regions=[Region(BASE+i*SLOT) for i in range((END-BASE)//SLOT)]
        self.owners=[Owner(i) for i in range((END-BASE)//SLOT)]
        self.next_region=0;self.next_owner=0;self.events=[];self.cleanup_errors=[];self.bounds_events=[];self.native_read_policy=None
        self.fault=lambda stage,owner:None
        self.guarded=GuardedMemory(self)
        # Global hook catches an access starting just before BASE but overlapping it.
        self.hook=u.hook_add(unicorn.UC_HOOK_MEM_READ|unicorn.UC_HOOK_MEM_WRITE,self._guest_access)

    def _guest_access(self,u,access,address,size,value,user):
        try:self.validate_access(address,size)
        except Rejected:
            if self.native_read_policy is not None and self.native_read_policy.allow(u,access,address,size):return
            from unicorn.x86_const import UC_X86_REG_EIP
            region=self.regions[(address-BASE)//SLOT] if BASE<=address<END else None
            owner=region.owner if region else None
            self.bounds_events.append(dict(kind='native_access_rejected',pc=u.reg_read(UC_X86_REG_EIP),
                access=access,address=address,size=size,owner=owner.index if owner else None,
                base=region.base if region else None,requested=owner.requested if owner else None,
                phase=owner.phase if owner else None,
                valid_suffix_hex=bytes(self.u.mem_read(address,min(size,region.base+owner.requested-address))).hex()
                if owner and owner.phase=='live' and owner.region is region and region.mapped and region.base<=address<region.base+owner.requested and address+min(size,region.base+owner.requested-address)<=region.base+region.mapped else None))
            raise
    def validate_access(self,address,size):
        if size<0 or address<0 or address+size>0x100000000:raise Rejected('invalid x86 memory range')
        if not size or address+size<=BASE or address>=END:return
        if address<BASE or address+size>END:raise Rejected('partial CRT arena access')
        region=self.regions[(address-BASE)//SLOT];owner=region.owner
        if owner is None or owner.phase!='live' or owner.region is not region or address+size>region.base+owner.requested:
            raise Rejected('access outside live requested CRT heap range')
    def reject_external_mapping(self,address,size):
        if address<END and address+size>BASE:raise Rejected('CRT mirror arena mapping is privately owned')

    def _reserve_region(self,owner):
        if self.next_region==len(self.regions):raise Rejected('CRT mirror reservations exhausted')
        region=self.regions[self.next_region];self.next_region+=1;region.owner=owner
        return region
    def _reserve_owner(self,n):
        if self.next_owner==len(self.owners):raise Rejected('CRT mirror owner records exhausted')
        owner=self.owners[self.next_owner];self.next_owner+=1
        owner.phase='prepared';owner.requested=n
        return owner
    def _extent(self,region,n):
        rounded=(n+PAGE-1)&~(PAGE-1)
        if rounded>region.mapped:
            self.u.mem_map(region.base+region.mapped,rounded-region.mapped,unicorn.UC_PROT_READ|unicorn.UC_PROT_WRITE)
            region.mapped=rounded
    def _trim(self,region,n):
        rounded=(n+PAGE-1)&~(PAGE-1)
        if region.mapped>rounded:
            self.u.mem_unmap(region.base+rounded,region.mapped-rounded)
            region.mapped=rounded
    def _drop(self,region):
        if region is not None and region.mapped:
            self.u.mem_unmap(region.base,region.mapped);region.mapped=0
    def _reject_request(self,n):
        if not 0<n<=SLOT:raise Rejected('CRT heap size outside qualified mirror bound')
    def _owner(self,p):
        if not BASE<=p<END or (p-BASE)%SLOT:raise Rejected('CRT heap requires exact owned base')
        region=self.regions[(p-BASE)//SLOT];owner=region.owner
        if owner is None or owner.phase!='live' or owner.region is not region or not owner.raw:
            raise Rejected('CRT heap base is stale, interrupted or foreign')
        return owner
    def _interrupted(self,owner,error):
        if owner.primary_error is None:owner.primary_error=repr(error)
        owner.phase='interrupted'
    def publication_failed(self,p,error):
        # CrtOs logging/register/stack publication happens after the mirror method.
        # It must retain a successful result as interrupted instead of reusable live.
        if BASE<=p<END and (p-BASE)%SLOT==0:
            region=self.regions[(p-BASE)//SLOT];owner=region.owner
            if owner is not None and owner.region is region and owner.phase=='live':
                self._interrupted(owner,error)
    def _event(self,kind,owner,**data):
        self.events.append(dict(operation=kind,owner=owner.index,phase=owner.phase,
                                pointer=owner.region.base if owner.region else None,**data))

    def allocate(self,n,flags):
        incoming_error=ctypes.get_last_error()
        self._reject_request(n)
        if flags not in (0,8):raise Rejected('unqualified HeapAlloc flags')
        owner=self._reserve_owner(n)
        try:
            owner.region=self._reserve_region(owner)
            self.fault('allocate_before_map',owner);self._extent(owner.region,n)
            self.fault('allocate_before_os',owner)
            ctypes.set_last_error(incoming_error)
            raw=self.api().HeapAlloc(self.heap,flags,n)
            owner.raw=int(raw or 0) # sole authority before any further fallible work
            owner.last_error=ctypes.get_last_error();owner.phase='raw_transition'
            self.fault('allocate_after_os',owner)
            if not owner.raw:
                self._drop(owner.region);owner.phase='retired'
                self._event('HeapAlloc',owner,result=0,size=n,flags=flags)
                ctypes.set_last_error(owner.last_error);return 0
            self.fault('allocate_before_copy',owner)
            self.u.mem_write(owner.region.base,ctypes.string_at(owner.raw,n))
            self.fault('allocate_before_publish',owner)
            owner.phase='live'
            self._event('HeapAlloc',owner,result=owner.region.base,size=n,flags=flags)
            ctypes.set_last_error(owner.last_error);return owner.region.base
        except Exception as error:self._interrupted(owner,error);raise

    def reallocate(self,p,n,flags=0):
        incoming_error=ctypes.get_last_error()
        self._reject_request(n)
        if flags!=0:raise Rejected('HeapReAlloc only flags0 is qualified')
        owner=self._owner(p);old_n=owner.requested;old_region=owner.region
        owner.phase='prepared';owner.old_raw=owner.raw;owner.returned_raw=0;owner.moved=None
        try:
            owner.candidate=self._reserve_region(owner)
            self.fault('reallocate_before_map',owner)
            self._extent(owner.candidate,n);self._extent(old_region,n)
            self.fault('reallocate_before_sync',owner)
            # Only internally validated owner bytes bypass the public memory guard.
            previous=bytes(self.u.mem_read(old_region.base,old_n))
            ctypes.memmove(owner.raw,previous,old_n)
            self.fault('reallocate_before_os',owner)
            ctypes.set_last_error(incoming_error)
            raw=self.api().HeapReAlloc(self.heap,flags,owner.raw,n)
            # A null result retains the old raw owner; successful transition adopts
            # immediately into the same object, without fallible dictionary rekey.
            if raw:owner.raw=int(raw)
            owner.returned_raw=int(raw or 0);owner.last_error=ctypes.get_last_error()
            owner.phase='raw_transition'
            self.fault('reallocate_after_os',owner)
            if not raw:
                self._trim(old_region,old_n);self._drop(owner.candidate);owner.candidate=None
                owner.phase='live'
                self._event('HeapReAlloc',owner,result=0,old_size=old_n,size=n,moved=None)
                ctypes.set_last_error(owner.last_error);return 0
            owner.moved=owner.raw!=owner.old_raw
            destination=owner.candidate if owner.moved else old_region
            self.fault('reallocate_before_copy',owner)
            self.u.mem_write(destination.base,ctypes.string_at(owner.raw,n))
            self.fault('reallocate_after_copy',owner)
            if owner.moved:
                owner.region=destination;owner.candidate=old_region
            owner.requested=n;owner.phase='mirror_ready'
            self.fault('reallocate_before_unmap',owner)
            self._trim(owner.region,n);self._drop(owner.candidate);owner.candidate=None
            self.fault('reallocate_before_publish',owner)
            owner.phase='live'
            self._event('HeapReAlloc',owner,result=owner.region.base,old_pointer=p,
                        old_size=old_n,size=n,moved=owner.moved)
            ctypes.set_last_error(owner.last_error);return owner.region.base
        except Exception as error:self._interrupted(owner,error);raise

    def size(self,p):
        owner=self._owner(p)
        value=self.api().HeapSize(self.heap,0,owner.raw);error=ctypes.get_last_error()
        failed=value==ctypes.c_size_t(-1).value
        self._event('HeapSize',owner,result=0xffffffff if failed else value,mirror_capacity=owner.requested)
        if not failed and value>owner.requested:raise Rejected('HeapSize exceeds requested mirror capacity')
        ctypes.set_last_error(error);return 0xffffffff if failed else value

    def free(self,p):
        owner=self._owner(p)
        ok=self.api().HeapFree(self.heap,0,owner.raw);error=ctypes.get_last_error()
        if not ok:
            # Real failure leaves a live owner, including its exact raw base.
            self._event('HeapFree',owner,result=0,last_error=error)
            ctypes.set_last_error(error);return 0
        owner.raw=0;owner.phase='raw_freed'
        try:
            self.fault('free_after_os',owner);self._drop(owner.region)
            owner.phase='retired';self._event('HeapFree',owner,result=1,last_error=error)
            ctypes.set_last_error(error);return 1
        except Exception as failure:self._interrupted(owner,failure);raise

    @property
    def live_blocks(self):return {o.region.base:o.raw for o in self.owners if o.phase=='live' and o.raw}
    @property
    def live_sizes(self):return {o.region.base:o.requested for o in self.owners if o.phase=='live' and o.raw}
    @property
    def retained_blocks(self):return {o.raw:o.requested for o in self.owners if o.phase!='live' and o.raw}
    def snapshot(self):
        return dict(raw_owners=sum(bool(o.raw) for o in self.owners),
                    mapped_regions=sum(bool(r.mapped) for r in self.regions),
                    live_owners=sum(o.phase=='live' for o in self.owners),
                    reserved_regions=self.next_region,allocated_owners=self.next_owner,
                    interrupted=[dict(owner=o.index,phase=o.phase,raw_owned=bool(o.raw),
                                      pointer=o.region.base if o.region else None,
                                      mapped=[r.base for r in (o.region,o.candidate) if r and r.mapped],
                                      primary_error=o.primary_error)
                                 for o in self.owners if o.phase not in ('unused','retired','live')])
    def cleanup(self):
        errors=[]
        for owner in self.owners[:self.next_owner]:
            if owner.phase=='retired':continue
            try:
                if owner.raw:
                    raw=owner.raw
                    ok=self.api().HeapFree(self.heap,0,raw);error=ctypes.get_last_error()
                    if ok:owner.raw=0;owner.phase='raw_freed'
                    # Logging after successful ownership removal cannot double-free.
                    self._event('host_cleanup_HeapFree',owner,result=int(bool(ok)),last_error=error)
                    if not ok:raise OSError(error,'actual/injected HeapFree failure during terminal cleanup')
                self.fault('cleanup_before_unmap',owner)
                self._drop(owner.region);self._drop(owner.candidate)
                owner.candidate=None;owner.phase='retired'
            except Exception as error:
                self._interrupted(owner,error);errors.append(dict(owner=owner.index,error=repr(error)))
        self.cleanup_errors.extend(errors)
        return errors
