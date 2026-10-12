"""Bounded PE32 mapper. This module never executes an entry or a host DLL.

The caller must run the real x86 entry in its existing Unicorn machine and may
publish the mapped module only after a completed, successful native attach.
"""
from pathlib import Path
import hashlib,struct,sys
sys.dont_write_bytecode=True
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn

SOURCE=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/RiotRadsIO.dll')
SHA='60833cd552d93b93304d4937912951e144e38db5d70793eb60a0c5f5d579e521'
class Unsupported(RuntimeError):pass

class Image:
    def __init__(self,path=SOURCE):
        self.path=Path(path);self.raw=self.path.read_bytes();self.sha256=hashlib.sha256(self.raw).hexdigest()
        if self.sha256!=SHA:raise Unsupported('RADS source SHA differs from pinned original')
        self.pe=pefile.PE(data=self.raw);p=self.pe;o=p.OPTIONAL_HEADER
        if p.FILE_HEADER.Machine!=0x14c or o.Magic!=0x10b or not p.FILE_HEADER.Characteristics&0x2000:raise Unsupported('expected original x86 DLL')
        self.base=o.ImageBase;self.size=o.SizeOfImage;self.entry=self.base+o.AddressOfEntryPoint
        if self.base&0xffff or self.size&0xfff or self.size>0x1000000 or self.base+self.size>0x100000000:raise Unsupported('invalid image extent')
        if not 0<o.SizeOfHeaders<=min(len(self.raw),self.size):raise Unsupported('invalid headers')
        if hasattr(p,'DIRECTORY_ENTRY_TLS') or hasattr(p,'DIRECTORY_ENTRY_DELAY_IMPORT'):raise Unsupported('TLS/delay loader not yet qualified')
        self.image=bytearray(self.size);self.image[:o.SizeOfHeaders]=self.raw[:o.SizeOfHeaders]
        self.sections=[];previous=o.SizeOfHeaders
        for s in p.sections:
            a=s.VirtualAddress;n=max(s.Misc_VirtualSize,s.SizeOfRawData);end=a+n
            if a<previous or a&0xfff or end>self.size or s.PointerToRawData+s.SizeOfRawData>len(self.raw):raise Unsupported('overlapping/out of range section')
            self.image[a:a+s.SizeOfRawData]=self.raw[s.PointerToRawData:s.PointerToRawData+s.SizeOfRawData]
            self.sections.append({'name':s.Name.rstrip(b'\0').decode(),'rva':a,'size':n,'raw_size':s.SizeOfRawData,'virtual_size':s.Misc_VirtualSize,'characteristics':s.Characteristics})
            previous=end
        if not self.executable(self.entry,1):raise Unsupported('entry outside executable section')
        self.imports=[];seen=set()
        for d in p.DIRECTORY_ENTRY_IMPORT:
            library=d.dll.decode('ascii')
            for i in d.imports:
                rva=i.address-self.base
                if not 0<=rva<=self.size-4 or rva in seen:raise Unsupported('invalid/duplicate IAT slot')
                seen.add(rva)
                self.imports.append({'dll':library,'name':i.name.decode('ascii') if i.name else '#'+str(i.ordinal),'iat':i.address,'iat_rva':rva})
        self.exports={}
        for e in p.DIRECTORY_ENTRY_EXPORT.symbols:
            if e.forwarder:raise Unsupported('forwarded export unsupported')
            address=self.base+e.address
            if not self.executable(address,1):raise Unsupported('export outside executable section')
            for key in (('#'+str(e.ordinal)),e.name.decode('ascii') if e.name else None):
                if key is not None:
                    if key in self.exports:raise Unsupported('duplicate export identity')
                    self.exports[key]=address
        self.relocations=[]
        for block in getattr(p,'DIRECTORY_ENTRY_BASERELOC',[]):
            for e in block.entries:
                if e.type not in (0,3):raise Unsupported('unqualified relocation type')
                if e.type==3 and not 0<=e.rva<=self.size-4:raise Unsupported('relocation out of range')
                self.relocations.append((e.rva,e.type))
    def executable(self,address,n):
        rva=address-self.base
        return any(s['characteristics']&0x20000000 and s['rva']<=rva and rva+n<=s['rva']+s['size'] for s in self.sections)
    def instruction_bytes(self,address,n):
        if not self.executable(address,n):raise Unsupported('RADS execution outside original code section')
        rva=address-self.base;return bytes(self.image[rva:rva+n])

class MappedModule:
    def __init__(self,image,stub_base=0x3c000000):
        self.image=image;self.stub_base=stub_base;self.stub_size=0x10000
        self.state='prepared';self.uc=None;self.bindings={};self.events=[]
    def map_into(self,uc,requested_base=None):
        if self.state!='prepared':raise Unsupported('module already mapped')
        if requested_base is not None and requested_base!=self.image.base:raise Unsupported('non-preferred relocation profile not qualified')
        targets=[(self.image.base,self.image.size),(self.stub_base,self.stub_size)]
        for i,(a,n) in enumerate(targets):
            for b,m in targets[:i]:
                if a<b+m and b<a+n:raise Unsupported('image and stub ranges overlap')
            for b,end,permissions in uc.mem_regions():
                if a<=end and b<a+n:raise Unsupported('mapping overlaps existing machine memory')
        if len(self.image.imports)*16>self.stub_size:raise Unsupported('import stub range exhausted')
        allocated=[]
        try:
            for a,n in targets:uc.mem_map(a,n);allocated.append((a,n))
            uc.mem_write(self.image.base,bytes(self.image.image));uc.mem_write(self.stub_base,b'\xcc'*self.stub_size)
            for i,imp in enumerate(self.image.imports):
                target=self.stub_base+16*i
                self.bindings[target]=dict(imp,module='RiotRadsIO.dll',module_base=self.image.base)
                uc.mem_write(imp['iat'],struct.pack('<I',target))
            # Apply section permissions after loader IAT writes; no section is W+X.
            uc.mem_protect(self.image.base,self.image.size,unicorn.UC_PROT_READ)
            for s in self.image.sections:
                flags=s['characteristics'];permissions=0
                if flags&0x40000000:permissions|=unicorn.UC_PROT_READ
                if flags&0x80000000:permissions|=unicorn.UC_PROT_WRITE
                if flags&0x20000000:permissions|=unicorn.UC_PROT_EXEC
                uc.mem_protect(self.image.base+s['rva'],(s['size']+0xfff)&~0xfff,permissions)
            uc.mem_protect(self.stub_base,self.stub_size,unicorn.UC_PROT_READ|unicorn.UC_PROT_EXEC)
        except Exception:
            for a,n in reversed(allocated):uc.mem_unmap(a,n)
            self.bindings.clear();raise
        self.uc=uc;self.state='mapped';self.events.append({'operation':'map','base':self.image.base,'bytes':self.image.size,'imports':len(self.bindings)})
    def begin_attach(self):
        if self.state!='mapped':raise Unsupported('attach phase differs from mapped module')
        self.state='attaching';self.events.append({'operation':'begin_native_attach','entry':self.image.entry})
        return self.image.entry,(self.image.base,1,0)
    def complete_native_attach(self,result):
        if self.state!='attaching':raise Unsupported('no pending native attach')
        if result==0:
            self.state='attach_failed';self.events.append({'operation':'native_attach_failed','result':result})
            raise Unsupported('native attach failed; partial module ownership retained for qualified cleanup')
        self.state='attached';self.events.append({'operation':'native_attach_returned','result':result})
    def module_handle(self):
        if self.state!='attached':raise Unsupported('module cannot be published before successful native attach')
        return self.image.base
    def get_export(self,module,name):
        if module!=self.module_handle():raise Unsupported('export queried for another module')
        if name not in self.image.exports:raise Unsupported('export missing; missing-export failure path not yet qualified')
        return self.image.exports[name]
