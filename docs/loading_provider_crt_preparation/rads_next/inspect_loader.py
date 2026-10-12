"""Static x86 DLL loading preparation only; never loads or executes the DLL."""
from pathlib import Path
import sys,json,hashlib,importlib.util
sys.dont_write_bytecode=True
OUT=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('source','E:/OpenLeague/docs/loading_standard_resource_preparation/extract_resource.py')
s=importlib.util.module_from_spec(spec);spec.loader.exec_module(s)
import pefile
dll=s.EXE.parent.parents[5]/'RADS'/'RiotRadsIO.dll';raw=dll.read_bytes();p=pefile.PE(data=raw)
assert hashlib.sha256(raw).hexdigest()=='60833cd552d93b93304d4937912951e144e38db5d70793eb60a0c5f5d579e521'
base=p.OPTIONAL_HEADER.ImageBase;image=p.get_memory_mapped_image()
regions=[];texts=[]
for role,a,budget in [('EXE_RADS_loader',0x9529b0,0x1000),('EXE_resource_dispatch_RADS_wrapper',0x953480,0x600)]:
    r,t=s.walk(role,a,budget)
    regions.append(r);texts.append(t)
exports=[{'name':x.name.decode() if x.name else None,'ordinal':x.ordinal,'rva':x.address,'preferred_va':base+x.address,'forwarder':x.forwarder.decode() if x.forwarder else None} for x in p.DIRECTORY_ENTRY_EXPORT.symbols]
for role,rva,size in [('DLL_CRT_entry',p.OPTIONAL_HEADER.AddressOfEntryPoint,0x200)]+[(x['name'],x['rva'],0x100) for x in exports if x['name'] in ('RadsInitialize','RadsSetLogger','RadsShutdown')]:
    data=image[rva:rva+size]
    regions.append({'role':role,'binary':'DLL','rva':rva,'address':base+rva,'size':size,'sha256':hashlib.sha256(data).hexdigest(),'hex':data.hex(),'scope':'bounded bytes, not necessarily complete function'})
    texts.append(role+'\n'+'\n'.join(f'{i.address:08X} {i.mnemonic} {i.op_str}' for i in s.md.disasm(data,base+rva)))
tls=None
if hasattr(p,'DIRECTORY_ENTRY_TLS'):
    t=p.DIRECTORY_ENTRY_TLS.struct;callbacks=[];i=t.AddressOfCallBacks-base
    if t.AddressOfCallBacks:
        while True:
            callback=int.from_bytes(image[i:i+4],'little');i+=4
            if not callback:break
            callbacks.append(callback)
            assert len(callbacks)<64
    tls={'raw_start_va':t.StartAddressOfRawData,'raw_end_va':t.EndAddressOfRawData,'index_va':t.AddressOfIndex,'callbacks_va':t.AddressOfCallBacks,'callbacks':callbacks,'zero_fill':t.SizeOfZeroFill,'characteristics':t.Characteristics}
relocs=[{'page_rva':x.struct.VirtualAddress,'entries':[{'rva':e.rva,'type':e.type} for e in x.entries]} for x in getattr(p,'DIRECTORY_ENTRY_BASERELOC',[])]
slots=[]
for i,address in enumerate([0x10d9694,0x10d965c,0x10d9730,0x10d96f8,0x10d97a0,0x10d9768,0x10d9810,0x10d97d8,0x10d9880,0x10d9844]):
    data=s.read(address,64).split(b'\0')[0]
    slots.append({'literal_va':address,'literal_hex':(data+b'\0').hex(),'name':data.decode(),'EXE_global':0x2d77890+4*i})
proof={'native_execution':False,'dll_path':str(dll),'dll_sha256':hashlib.sha256(raw).hexdigest(),
    'exe_path':str(s.EXE),'exe_sha256':s.digest,'machine':p.FILE_HEADER.Machine,'image_base':base,
    'image_size':p.OPTIONAL_HEADER.SizeOfImage,'headers_size':p.OPTIONAL_HEADER.SizeOfHeaders,'entry_rva':p.OPTIONAL_HEADER.AddressOfEntryPoint,
    'entry_preferred_va':base+p.OPTIONAL_HEADER.AddressOfEntryPoint,'dll_characteristics':p.OPTIONAL_HEADER.DllCharacteristics,
    'sections':[{'name':x.Name.rstrip(b'\0').decode(),'rva':x.VirtualAddress,'virtual_size':x.Misc_VirtualSize,'raw_offset':x.PointerToRawData,'raw_size':x.SizeOfRawData,'characteristics':hex(x.Characteristics)} for x in p.sections],
    'imports':[{'dll':x.dll.decode(),'symbols':[{'name':i.name.decode() if i.name else None,'ordinal':i.ordinal,'iat_rva':i.address-base} for i in x.imports]} for x in p.DIRECTORY_ENTRY_IMPORT],
    'delay_imports':[x.dll.decode() for x in getattr(p,'DIRECTORY_ENTRY_DELAY_IMPORT',[])],
    'tls':tls,'relocations':relocs,'exports':exports,'regions':regions,'EXE_resolved_export_slots':slots,
    'limits':['Static extraction only. No DLL handle or load success supplied. No emulated or host DllMain invoked.','RADS archive/resource content and callbacks are not qualified by this inventory.']}
(OUT/'loader_inventory.json').write_text(json.dumps(proof,indent=2)+'\n')
(OUT/'loader_source.txt').write_text('\n\n'.join(texts)+'\n')
print(json.dumps({'image_base':hex(base),'image_size':hex(proof['image_size']),'entry':hex(proof['entry_preferred_va']),
    'tls':tls,'relocation_blocks':len(relocs),'relocations':sum(len(v['entries']) for v in relocs),'imports':{x['dll']:len(x['symbols']) for x in proof['imports']},'exports':exports,'exe_regions':[(r['role'],hex(r['address']),r['size']) for r in regions[:2]]}))
