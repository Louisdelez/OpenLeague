"""Resolve native ambient BLND effect references without inventing event semantics."""
from pathlib import Path
import json,re,hashlib,datetime
r=Path(__file__).resolve().parents[1];source=json.loads((r/'docs/map_ambient_source_validation.json').read_text());deploy=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy');particles=deploy/'DATA/Particles';by_name={p.name.lower():p for p in particles.iterdir() if p.is_file()};references=[]
for model in source['models']:
 for entry in model['sources']:
  p=Path(entry['path'])
  if p.suffix.lower()!='.blnd':continue
  raw=p.read_bytes()
  for match in re.finditer(rb'[A-Za-z0-9_\-]+\.troy',raw,re.I):
   name=match.group().decode('ascii');target=by_name.get((name+'bin').lower());assert target is not None,name
   data=target.read_bytes();strings=[{'offset':m.start(),'value':m.group().decode('ascii')} for m in re.finditer(rb'[ -~]{5,}',data)]
   references.append({'native_asset':model['native_asset'],'blend_file':str(p),'blend_sha256':hashlib.sha256(raw).hexdigest(),'byte_offset':match.start(),'particle_reference':name,'resolved_path':str(target),'particle_sha256':hashlib.sha256(data).hexdigest(),'particle_bytes':len(data),'printable_strings':strings,'event_time':None,'attachment_bone':None,'semantics':'Raw reference resolved; binary event timing/attachment graph not yet decoded.'})
proof={'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'references':references,'resolved_references':len(references),'unique_particle_files':len({x['resolved_path'] for x in references}),'complete':False,'limits':['Printable string discovery proves source presence, not parsed event semantics.','No replacement particle geometry, audio timing or random idle transitions inferred.','Native event timing, attachment, particle emitter parameters and audio bank/event resolution must be implemented and qualified.']}
(r/'docs/map_ambient_event_sources.json').write_text(json.dumps(proof,indent=2)+'\n');print('Native ambient event references resolved:',len(references),'unique files:',proof['unique_particle_files'])
