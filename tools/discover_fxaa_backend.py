from pathlib import Path
import struct,re,json,hashlib
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
refs=[]
for m in re.finditer(re.escape(struct.pack('<I',0x9c2d40)),image):
 loc=base+m.start(); table=loc-0x60
 refs.append(dict(reference=hex(loc),possible_vtable=hex(table),slot60='0x9c2d40',slots=[hex(struct.unpack_from('<I',image,table-base+i*4)[0]) for i in range(28)]))
proof=dict(native_sha256=hashlib.sha256(Path(source).read_bytes()).hexdigest(),static_only=True,refs=refs,format21=struct.unpack_from('<I',image,0x10e2b90-base+21*4)[0],pool0=struct.unpack_from('<I',image,0x10e2c9c-base)[0],usage_map=[dict(mask=hex(struct.unpack_from('<I',image,0x123ff68-base+i*8)[0]),value=hex(struct.unpack_from('<I',image,0x123ff6c-base+i*8)[0])) for i in range(5)],limits=['Candidate table identity and conversion values are static evidence; bridge and concrete construction must execute before qualification.'])
Path('E:/mapslol3v3/native_fxaa_backend_candidates.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(proof))
