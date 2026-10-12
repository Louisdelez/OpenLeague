from pathlib import Path
import json,struct,datetime
r=Path('E:/OpenLeague')
for relative in ['docs/destroyed_animation_source_audit.json','docs/destroyed_animation_binding.json']:
 p=r/relative;d=json.loads(p.read_text(encoding='utf-8'))
 for model,m in d['models'].items():
  source=m.get('source',m);raw=Path(source['blend']).read_bytes()
  assert raw[0xac:0xac+8]==b'Default\0'
  for state in source['states']:
   offset=state['record_offset'];pointer=state.pop('clip_descriptor_offset',state.get('shared_descriptor_offset'))
   assert pointer==0x9c
   state.update(shared_descriptor_offset=pointer,shared_descriptor_name='Default',shared_descriptor_semantics_qualified=False,payload_offset_raw=struct.unpack_from('<I',raw,offset+16)[0])
   payload=offset+state['payload_offset_raw'];state.update(payload_words_raw=list(struct.unpack_from('<8I',raw,payload)),frame_count_raw=struct.unpack_from('<I',raw,payload+8)[0],time_step_raw=struct.unpack_from('<f',raw,payload+12)[0])
 d['pointer_label_correction']='Shared relative pointer addresses Default descriptor, not a qualified animation clip descriptor. One authored ANM per file and zero-valued candidate clip index remain structural evidence; native state/loop/time consumer qualification remains open.'
 d['updated_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat()
 p.write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8')
print('Corrected shared Default descriptor label; preserved unresolved state/time semantics.')
