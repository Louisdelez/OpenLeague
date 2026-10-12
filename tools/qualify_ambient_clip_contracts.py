"""Verify native clip periods and event owner pointer tables, without nearest-node guesses."""
from pathlib import Path
import sys,json,struct,hashlib,datetime
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'));import pefile,capstone
prior=json.loads((r/'docs/map_ambient_native_timing_validation.json').read_text());exe=Path(prior['native_executable']).read_bytes();assert hashlib.sha256(exe).hexdigest()==prior['native_executable_sha256'];pe=pefile.PE(data=exe);base=pe.OPTIONAL_HEADER.ImageBase
expected={0x888d72:'c70618890c01',0x888d7f:'8b4710',0x888d8a:'03c7',0x888d8e:'833801',0x888d95:'89462c',0x888dca:'ff7014',0x8890c4:'8b492c',0x8890cb:'8b4108',0x8890ce:'2b4104',0x8890df:'d8490c'}
for va,value in expected.items():
 off=pe.get_offset_from_rva(va-base);assert exe[off:off+len(value)//2].hex()==value,hex(va)
off=pe.get_offset_from_rva(0x10c8918+0x34-base);assert struct.unpack_from('<I',exe,off)[0]==0x8890c0
records=json.loads((r/'docs/map_ambient_blend_records.json').read_text());manifest=json.loads((r/'data/4.20/map_ambient_manifest.json').read_text());sources=json.loads((r/'docs/map_ambient_source_validation.json').read_text());owners={};clips=[]
for entry in records['clip_nodes']:
 b=Path(entry['path']).read_bytes();assert hashlib.sha256(b).hexdigest()==entry['sha256']
 source=next(m for m in sources['models'] if m['native_asset']==entry['native_asset'])
 for node in entry['candidate_clip_nodes']:
  offset=node['offset'];data=offset+struct.unpack_from('<I',b,offset+16)[0]
  kind,start,end,step,animation_index,event_reference=struct.unpack_from('<IIIfII',b,data)
  assert kind==1 and start==0 and end==node['frame_count_raw'] and step==node['time_step_raw']
  period=(end-start)*step;table=[]
  if event_reference:
   # Atomic data points to serialized resource object; twenty reserved bytes
   # precede the resource header. All offsets below are bounded and cross-checked
   # against already recovered exact event record/string addresses.
   resource=data+event_reference;header=resource+20
   size=struct.unpack_from('<I',b,header)[0];count=struct.unpack_from('<H',b,header+14)[0]
   assert 0<count<=18 and header+size<=len(b)
   table_relative=struct.unpack_from('<I',b,header+20)[0];table_offset=header+table_relative
   assert header<=table_offset and table_offset+4*count<=header+size
   for i in range(count):
    event_offset=header+struct.unpack_from('<I',b,table_offset+4*i)[0]
    assert header<=event_offset and event_offset+36<=header+size
    event=next(e for e in records['records'] if e['native_asset']==entry['native_asset'] and e['record_offset']==event_offset)
    assert event['candidate_owner']['offset']==offset
    key=(entry['native_asset'],event_offset);assert key not in owners
    owners[key]={'node_offset':offset,'node_name':node['name'],'event_resource_object':resource,'event_header':header,'event_table':table_offset,'entry_offset':table_offset+4*i,'record_offset':event_offset}
    table.append(event_offset)
  refs=source['blend_animation_references']
  path=refs[animation_index] if animation_index<len(refs) else None
  # Death can refer to an absent animation and is not part of the primary import.
  primary=bool(node['name']!='Death' and path and Path(path).stem.lower()==manifest['assets'][entry['native_asset']]['primary_name'].lower())
  if primary:assert abs(period-manifest['assets'][entry['native_asset']]['duration'])<1e-5
  clips.append({'native_asset':entry['native_asset'],'node':node['name'],'data_offset':data,'frame_start':start,'frame_end':end,'time_step':step,'native_period_seconds':period,'animation_index_raw':animation_index,'candidate_animation_reference':path,'matches_imported_primary':primary,'owned_event_offsets':table})
assert len(owners)==len(records['records'])==18
for event in records['records']:
 event['structural_owner_pointer_table']=owners[(event['native_asset'],event['record_offset'])]
 event['start_seconds']=event['start_value_raw']*event['candidate_owner']['time_step_raw']
 event['end_seconds']=None if event['end_value_raw']<0 else event['end_value_raw']*event['candidate_owner']['time_step_raw']
 event['loop_period_seconds']=event['candidate_owner']['frame_count_raw']*event['candidate_owner']['time_step_raw']
(r/'docs/map_ambient_blend_records.json').write_text(json.dumps(records,indent=2)+'\n')
proof={'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_executable_sha256':prior['native_executable_sha256'],'native_instruction_checks':len(expected),'native_duration_vtable':'0x10c8918 + 0x34 -> 0x8890c0','duration_formula':'(frame_end-frame_start)*time_step','clips':clips,'event_owners':list(owners.values()),'passed':True,'complete':False,'limits':['Owner linkage verified by exact bounded source pointer tables; complete loader/relocation grammar and blend selector transitions still incomplete.','Header animation-reference indexing must account for unloaded or absent clips; absent Death and secondary graph behavior remain open.','Full audio/particle playback and visual fidelity remain incomplete.']}
(r/'docs/map_ambient_clip_contract_validation.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS native periods',len(clips),'clips;',len(owners),'exact event-owner pointer-table entries')
