from pathlib import Path
import importlib.util,json,hashlib,sys
sys.dont_write_bytecode=True
OUT=Path(__file__).resolve().parent
p=Path('E:/OpenLeague/docs/loading_standard_resource_preparation/extract_resource.py')
spec=importlib.util.spec_from_file_location('native_resource_source',p);src=importlib.util.module_from_spec(spec);spec.loader.exec_module(src)
entries=[('configuration_hash_getter',0x901ef0,0x10),('interface_hash_getter',0x901ee0,0x10),('shared_hash_getter',0x901ed0,0x10),('forward_hash_getter',0x901e20,0x10),('node_allocate24',0x5d54a0,0x100),('insert_at',0x5da5e0,0x350),('insert_unhinted',0x5da8c0,0x220),('index_node',0x5d2710,0xc0),('metadata_node',0x661f80,0xc0),('index_hint',0x5d2950,0x220),('metadata_hint',0x663240,0x220),('index_slot',0x5bd9b0,0x150),('metadata_slot',0x64d040,0x140),
 ('sentinel44',0x5c74a0,0x80),('sentinel48',0x5c7630,0x80),('sentinel24',0x5c73c0,0x80),('sentinel64',0x6542a0,0x80),
 ('vector_clear',0x90d0b0,0x100),('tree48_clear',0x90d110,0x120),('tree64_clear',0x66e2c0,0x120),
 ('tree24_clear',0x5c2ce0,0x120),('tree_string_clear',0x5c2ab0,0x120),('tree24_erase',0x5c1370,0x100),
 ('tree_string_erase',0x5c1ed0,0x100)]
regions=[];text=[]
for role,a,budget in entries:
 r,t=src.walk(role,a,budget);regions.append(r);text.append(t)
data=[]
for role,a,n in [('hash_globals',0x2d6edf0,16),('config_name',0x10d666c,16),('shared_name',0x10bf2d4,9),('forward_name',0x10d6880,13),('interface_name',0x10d6b34,12),('manager_vtable',0x10d6450,8),('configuration_vtable',0x10d63e8,0x28),('interface_vtable',0x10d62fc,0x28),('shared_vtable',0x10d62c8,0x28),('forward_vtable',0x10d6330,0x28)]:
 blob=src.read(a,n);data.append({'role':role,'address':a,'size':n,'sha256':hashlib.sha256(blob).hexdigest(),'hex':blob.hex()})
(OUT/'manager_source.json').write_text(json.dumps({'source':str(src.EXE),'source_sha256':src.digest,'regions':regions,'data':data},indent=2)+'\n')
(OUT/'manager_source.txt').write_text('\n\n'.join(text)+'\n')
print(json.dumps({'regions':len(regions),'unresolved':[(r['role'],r['edges']) for r in regions if r['edges']],'data':[(r['role'],hex(r['address']),r['size']) for r in data]}))
