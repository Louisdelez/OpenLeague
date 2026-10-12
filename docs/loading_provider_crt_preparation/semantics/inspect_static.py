"""Read-only PE analysis; no native execution or filesystem API adapters."""
from pathlib import Path
import sys, importlib.util, json, hashlib
sys.dont_write_bytecode=True
OUT=Path(__file__).resolve().parent
REF=Path('E:/OpenLeague/docs/loading_standard_resource_preparation')
NEXT=Path('E:/mapslol3v3/loading_resource_provider_next')
spec=importlib.util.spec_from_file_location('source_extract_read_only',REF/'extract_resource.py')
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
verified=[]
for p in [REF/'source_regions.json',REF/'source_dependency_regions.json',REF/'source_data_regions.json',NEXT/'provider_source.json']:
    doc=json.loads(p.read_text(encoding='utf-8-sig'))
    for r in doc['regions']:
        data=bytes.fromhex(r['hex'])
        assert data==m.read(r['address'],r['size'])
        assert hashlib.sha256(data).hexdigest()==r['sha256']
        verified.append({'file':str(p),'role':r['role'],'address':r['address'],'size':r['size'],'sha256':r['sha256']})
entries=[('ini_string_lookup',0x8b0630,0x500),('ini_source_lookup',0x8b0380,0x800),
         ('manager_visit_active_entries',0x90b270,0x200),('provider_parent_set',0x905000,0x20),
         ('provider_scalar_delete',0x901d40,0x100),('ini_manager_string',0x8ad4d0,0x900),
         ('ini_manager_ctor',0x8aca20,0x1000),('ini_manager_file_pair',0x8acef0,0x600),
         ('ini_value_string',0x8b01c0,0x250),('provider_visit_entry',0x905e70,0x600),
         ('ini_file_ctor',0x8ad5b0,0x900)]
provider_methods=[int.from_bytes(m.read(0x10d64a8+4*i,4),'little') for i in range(13)]
entries.append(('provider_parent_context_resolve',provider_methods[8],0x300))
vt=0x10d6458
methods=[int.from_bytes(m.read(vt+4*i,4),'little') for i in range(6)]
for i in [2,4,5]:entries.append(('provider_visitor_virtual_'+str(i*4),methods[i],0x300))
regions=[];texts=[]
for entry in entries:
    r,t=m.walk(*entry);regions.append(r);texts.append(t)
(OUT/'supplemental_source.txt').write_text('\n\n'.join(texts)+'\n',encoding='utf-8')
(OUT/'source_verification.json').write_text(json.dumps({'source':str(m.EXE),'source_sha256':m.digest,
 'native_executed':False,'compiler_executed':False,'production_modified':False,
 'verified_existing_regions':verified,'supplemental_regions':regions,
 'visitor_vtable':{'address':vt,'hex':m.read(vt,24).hex(),'methods':methods},
 'provider_vtable':{'address':0x10d64a8,'hex':m.read(0x10d64a8,52).hex(),'methods':provider_methods},
 'imports':{hex(i.address):{'dll':d.dll.decode('ascii'),'name':i.name.decode('ascii') if i.name else str(i.ordinal)} for d in m.pe.DIRECTORY_ENTRY_IMPORT for i in d.imports if i.address in [0xfa4378,0xfa41a4,0xfa41ac,0xfa41d8]},
 'strings':{hex(a):m.read(a,256).split(b'\0')[0].decode('latin1') for a in [0x10867e4,0x10867f8,0x10d69dc,0x1085b2d,0x10c9a88,0x10883ac,0x10c9a34,0x10c9a40,0x10c9a28,0x10d6b1c]}},indent=2)+'\n',encoding='utf-8')
print(json.dumps({'existing_regions_byte_verified':len(verified),'supplemental':[(r['role'],r['size'],r['edges']) for r in regions]}))
