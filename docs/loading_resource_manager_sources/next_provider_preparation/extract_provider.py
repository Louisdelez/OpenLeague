from pathlib import Path
import sys,importlib.util,json,hashlib
sys.dont_write_bytecode=True
OUT=Path(__file__).resolve().parent
p=Path('E:/OpenLeague/docs/loading_standard_resource_preparation/extract_resource.py')
spec=importlib.util.spec_from_file_location('source',p);src=importlib.util.module_from_spec(spec);spec.loader.exec_module(src)
entries=[('bounded_format',0x993860,0x60),('crt_bounded_vformat',0xc9b551,0x260),('physical_iterator_factory',0x8b9e30,0x300),('physical_iterator_create',0x8b6380,0x300),('filesystem_singleton',0x8bc440,0x140),('provider_destructor',0x901cd0,0x100),('iterator_source_open',0x8b4400,0x400),('provider_scalar_delete',0x901d40,0x100),('directory_release',0x90aab0,0x250),('context_ctor',0x9062a0,0x140),('directory_populate',0x901f60,0x1100),('directory32_ctor',0x903030,0xa0),('directory32_init',0x9030c0,0x420),('provider56_ctor',0x9034d0,0xc0),('provider_init',0x903590,0x600),('directory_enumerate',0x905620,0x200),('file_iterator_factory',0x8b4830,0x300),('provider_resolve',0x903ee0,0x320),('provider_exists',0x9041e0,0x110)]
regions=[];texts=[]
for role,a,budget in entries:
 r,t=src.walk(role,a,budget);regions.append(r);texts.append(t)
data=[]
for role,a,n in [('provider_vtable',0x10d64a8,52),('directory_callback_vtable',0x10d6364,28),('provider_callback_vtable',0x10d6458,28)]:
 b=src.read(a,n);data.append(dict(role=role,address=a,size=n,hex=b.hex(),sha256=hashlib.sha256(b).hexdigest()))
(OUT/'provider_source.json').write_text(json.dumps(dict(source=str(src.EXE),source_sha256=src.digest,regions=regions,data=data),indent=2)+'\n')
(OUT/'provider_source.txt').write_text('\n\n'.join(texts)+'\n')
print(json.dumps({'regions':len(regions),'edges':[(r['role'],r['edges']) for r in regions if r['edges']],'vtable':data[0]}))
