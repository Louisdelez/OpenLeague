from pathlib import Path
import struct,json,hashlib
r=Path('E:/OpenLeague')
exec(compile((r/'tools/discover_audio_emitter_clock_writes.py').read_text(encoding='utf-8-sig').split('start=0x93e000')[0],'setup','exec'))
rows=[]
for va in range(0xfef000,0xff4000,4):
 if pe.get_data(va+4-base,8)!=struct.pack('<II',0xafe1a0,0xb00180):continue
 getter=struct.unpack('<I',pe.get_data(va+0x38-base,4))[0];reader=struct.unpack('<I',pe.get_data(va+0x13c-base,4))[0];code=pe.get_data(getter-base,8)
 if code[:1]!=b'\xb8' or code[5]!=0xc3:continue
 stores=[];needle=struct.pack('<I',va);pos=0
 while True:
  pos=raw.find(needle,pos)
  if pos<0:break
  at=base+pe.get_rva_from_offset(pos)
  if 0xad0000<=at<0xb40000 and raw[pos-2]==0xc7 and raw[pos-1] in [0,1,2,3,6,7]:
   stores.append(dict(address=hex(at-2),instruction=next(md.disasm(raw[pos-2:pos+4],at-2)).op_str))
  pos+=4
 rows.append(dict(vtable=hex(va),type_value=struct.unpack('<I',code[1:5])[0],type_getter=hex(getter),reader=hex(reader),assignments=stores))
proof=dict(native_sha256=hashlib.sha256(raw).hexdigest(),kind='static table assignments and constant type getters',classes=rows,findings=['Shared retainAFE1A0/releaseB00180 establishes table alignment; instruction assignments located for concrete type tables.','Do not equate internal virtual38 type values with bank HIRC tags without factory evidence.'],limits=['Assignments can occur in constructors or destructors; individual functions require classification.','Reader entrypoints not executed; semantic sound/container mapping remains open.'])
(r/'docs/audio_target_class_tables.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps(rows))
