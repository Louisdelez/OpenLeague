"""Recover bounded BLND record fields; do not infer unverified timing semantics."""
from pathlib import Path
import json,struct,re,hashlib,datetime
r=Path(__file__).resolve().parents[1];source=json.loads((r/'docs/map_ambient_source_validation.json').read_text());refs=json.loads((r/'docs/map_ambient_event_sources.json').read_text())['references'];all_records=[];nodes_out=[]
for model in source['models']:
 path=Path(next(x['path'] for x in model['sources'] if x['path'].endswith('.blnd')));raw=path.read_bytes();assert raw[:8]==b'r3d2blnd' and struct.unpack_from('<I',raw,8)[0]==1
 nodes=[]
 for offset in range(0,len(raw)-48,4):
  size,kind,flags,name_offset,payload=struct.unpack_from('<5I',raw,offset)
  if size not in [72,76] or kind not in [0,2] or name_offset!=20 or not 24<=payload<160:continue
  start=offset+name_offset;end=raw.find(b'\0',start)
  if end<start:continue
  name=raw[start:end]
  if not re.fullmatch(rb'[A-Za-z0-9_]+',name):continue
  framecount=struct.unpack_from('<I',raw,offset+payload+8)[0];step=struct.unpack_from('<f',raw,offset+payload+12)[0]
  if framecount<=0 or abs(step-1/30)>1e-5:continue
  nodes.append({'offset':offset,'name':name.decode(),'record_kind_raw':kind,'flags_raw':flags,'frame_count_raw':framecount,'time_step_raw':step})
 assert nodes,model['native_asset'];nodes_out.append({'native_asset':model['native_asset'],'path':str(path),'sha256':hashlib.sha256(raw).hexdigest(),'candidate_clip_nodes':nodes})
 glb=(r/'assets'/model['asset']).read_bytes();length=struct.unpack_from('<I',glb,12)[0];gltf=json.loads(glb[20:20+length]);joint_names={gltf['nodes'][i].get('name','').lower() for skin in gltf.get('skins',[]) for i in skin['joints']}
 for ref in [x for x in refs if x['native_asset']==model['native_asset']]:
  particle_offset=ref['byte_offset'];candidates=[]
  for offset in range(max(0,particle_offset-200),particle_offset-36+1,4):
   zero,kind,flags=struct.unpack_from('<3I',raw,offset)
   if zero!=0 or kind!=2 or flags not in [0,1,3]:continue
   name_ptr,particle_ptr,bone_ptr,extra_ptr=struct.unpack_from('<4I',raw,offset+16)
   if offset+particle_ptr!=particle_offset or name_ptr!=36:continue
   def string(relative):
    ptr=offset+relative;assert offset+36<=ptr<len(raw);end=raw.find(b'\0',ptr);assert end>=ptr;return raw[ptr:end].decode('ascii')
   event_name=string(name_ptr);particle=string(particle_ptr);bone=string(bone_ptr);assert particle==ref['particle_reference']
   start_value=struct.unpack_from('<f',raw,offset+12)[0];end_value=struct.unpack_from('<f',raw,offset+32)[0];assert start_value>=0 and (end_value>=0 or end_value==-1)
   owner=max((n for n in nodes if n['offset']<offset),key=lambda n:n['offset'])
   candidates.append({'native_asset':model['native_asset'],'source_blnd':str(path),'record_offset':offset,'record_kind_raw':kind,'flags_raw':flags,'event_name':event_name,'particle':particle,'attachment_bone':bone,'attachment_joint_present':bool(bone) and bone.lower() in joint_names,'attachment_unresolved':bool(bone) and bone.lower() not in joint_names,'start_value_raw':start_value,'end_value_raw':end_value,'extra_data_offset_raw':extra_ptr,'candidate_owner':owner,'time_units_qualified':False,'start_seconds':None,'end_seconds':None})
  assert len(candidates)==1,(model['native_asset'],particle_offset,candidates);all_records.extend(candidates)
assert len(all_records)==18
proof={'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'records':all_records,'clip_nodes':nodes_out,'unresolved_attachments':[{'native_asset':x['native_asset'],'event':x['event_name'],'bone':x['attachment_bone']} for x in all_records if x['attachment_unresolved']],'particle_records':len(all_records),'bone_attachments_resolved':sum(x['attachment_joint_present'] for x in all_records),'passed':True,'complete':False,'limits':['Record offsets/strings verified structurally; unmatched native bone names retained explicitly; complete BLND grammar/ownership/event flags remain unqualified.','Start/end raw floats retained without guessing frames versus seconds or interpreting persistent flags.','Candidate clip frame counts/time steps are recovered; native executable evaluation must qualify event timing before playback.']}
(r/'docs/map_ambient_blend_records.json').write_text(json.dumps(proof,indent=2)+'\n');print('Native BLND records recovered:',len(all_records),'resolved joints:',proof['bone_attachments_resolved'])
for x in all_records:print(x['native_asset'],x['event_name'],x['start_value_raw'],x['end_value_raw'],x['attachment_bone'])

