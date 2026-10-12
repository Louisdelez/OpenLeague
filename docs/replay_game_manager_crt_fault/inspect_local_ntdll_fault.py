from pathlib import Path
import hashlib, struct, pefile, capstone
p=Path('C:/Windows/System32/ntdll.dll')
raw=p.read_bytes(); pe=pefile.PE(data=raw)
target=0x1cc5d; base=pe.OPTIONAL_HEADER.ImageBase
print('source',str(p),'sha256',hashlib.sha256(raw).hexdigest(),'machine',hex(pe.FILE_HEADER.Machine),'image_base',hex(base))
items=sorted((x.address,x.name.decode(errors='replace') if x.name else f'ordinal{x.ordinal}') for x in pe.DIRECTORY_ENTRY_EXPORT.symbols)
before=[v for v in items if v[0]<=target]
after=[v for v in items if v[0]>target]
print('neighbor_exports',[(hex(a),n) for a,n in before[-4:]+after[:4]])
entry=next((x for x in pe.DIRECTORY_ENTRY_EXCEPTION if x.struct.BeginAddress<=target<x.struct.EndAddress),None)
if entry:
    start=entry.struct.BeginAddress;end=entry.struct.EndAddress
    print('runtime_function',hex(start),hex(end))
    image=pe.get_memory_mapped_image()
    d=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_64)
    for i in d.disasm(image[start:end],base+start):
        if abs((i.address-base)-target)<=96:
            print(hex(i.address-base),i.mnemonic,i.op_str)
