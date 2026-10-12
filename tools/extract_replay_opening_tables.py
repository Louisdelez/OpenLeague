from pathlib import Path
import json,hashlib,pefile,struct
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3');m=json.loads((r/'data/4.20/runtime/replay_runtime_image_manifest.json').read_text());raw=Path(m['native_source']).read_bytes();assert hashlib.sha256(raw).hexdigest()==m['native_sha256'];pe=pefile.PE(data=raw);image=pe.get_memory_mapped_image();tables={}
for address,size in [(0x10d5f34,4),(0x10d607c,40),(0x1085f4c,12),(0x10d6030,12),(0x10d5fec,48)]:
 data=image[address-0x400000:address-0x400000+size];assert len(data)==size;tables[str(address)]={'bytes':size,'words':list(struct.unpack('<'+'I'*(size//4),data))}
(s/'replay_opening_tables.json').write_text(json.dumps({'native_sha256':m['native_sha256'],'tables':tables},indent=2)+'\n',encoding='utf-8')
print(json.dumps(tables))
