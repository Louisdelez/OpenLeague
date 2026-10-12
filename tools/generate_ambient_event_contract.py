"""Compile bounded source event contracts for the selected native primary clips."""
from pathlib import Path
import json,hashlib
r=Path(__file__).resolve().parents[1]
def read(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
manifest=read('data/4.20/map_ambient_manifest.json');contracts=read('docs/map_ambient_clip_contract_validation.json');records=read('docs/map_ambient_blend_records.json');models={}
assert contracts['passed'] and records['passed']
for name,asset in manifest['assets'].items():
 clips=[c for c in contracts['clips'] if c['native_asset']==name and c['matches_imported_primary']];assert len(clips)==1,(name,clips);clip=clips[0]
 events=[e for e in records['records'] if e['native_asset']==name and e['record_offset'] in clip['owned_event_offsets']]
 assert len(events)==len(clip['owned_event_offsets'])
 models[name]={'primary_name':asset['primary_name'],'source_node':clip['node'],'time_step':clip['time_step'],'period':clip['native_period_seconds'],'asset_sha256':asset['sha256'],'events':[{'name':e['event_name'],'record_offset':e['record_offset'],'particle':e['particle'],'bone':e['attachment_bone'],'attachment_source_resolved':e['attachment_joint_present'],'start_frame':e['start_value_raw'],'end_frame':e['end_value_raw'],'flags':e['flags_raw']} for e in events]}
proof={'models':models,'source_contract_sha256':hashlib.sha256((r/'docs/map_ambient_clip_contract_validation.json').read_bytes()).hexdigest(),'source_records_sha256':hashlib.sha256((r/'docs/map_ambient_blend_records.json').read_bytes()).hexdigest(),'limits':['Primary clip bindings only; complete native selectors/secondary transitions remain incomplete.','Timeline integration does not substitute for native particle/audio consumers.']}
(r/'data/4.20/ambient_events.json').write_text(json.dumps(proof,indent=2)+'\n');print('Primary templates',sum(len(m['events']) for m in models.values()),'placement event instances',sum(len(models[p['native_asset']]['events']) for p in manifest['placements']))
