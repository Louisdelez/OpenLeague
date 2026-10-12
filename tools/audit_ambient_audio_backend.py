"""Audit current ambient media and runtime integration, without playback claims."""
from pathlib import Path
import json,hashlib,wave,datetime
r=Path('E:/OpenLeague');manifest=json.loads((r/'data/4.20/ambient_audio_manifest.json').read_text());selection=json.loads((r/'data/4.20/ambient_audio_selection.json').read_text())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
rows=[];errors=[]
for m in manifest['media']:
 row=dict(source_id=m['source_id'])
 for kind in ['wem','wav']:
  p=r/'assets'/Path(m[kind]);ok=p.is_file() and sha(p)==m[kind+'_sha256'];row[kind]=dict(path=str(p),hash_matches=ok)
  if not ok:errors.append(str(p))
 p=r/'assets'/Path(m['wav'])
 if p.is_file():
  with wave.open(str(p),'rb') as w:
   actual=dict(frames=w.getnframes(),sample_rate=w.getframerate(),channels=w.getnchannels(),sample_width=w.getsampwidth())
   row['format']=actual;row['format_matches']=all(actual[k]==m[k] for k in actual)
   if not row['format_matches']:errors.append('format '+str(p))
 rows.append(row)
ids={m['source_id'] for m in manifest['media']};events=[]
for e in manifest['events']:
 missing=sorted(set(e['source_ids'])-ids);events.append(dict(event_id=e['event_id'],name=e['event_name'],source_count=len(e['source_ids']),missing=missing));errors.extend(missing)
missing_selected=sorted({s['source'] for s in selection['sounds']}-ids);errors.extend(missing_selected)
modules=['audio_selection','audio_launch_dispatcher','audio_managed_voice','audio_pcm']
uses={m:[] for m in modules}
for p in (r/'crates/client/src').rglob('*.rs'):
 s=p.read_text()
 for m in modules:
  if m in s:uses[m].append(str(p.relative_to(r)))
requests=(r/'crates/client/src/map_audio_requests.rs').read_text();assert '-1 // Backend unavailable' in requests
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,media_integrity_passed=not errors,errors=errors,media=rows,events=events,selection_missing_sources=missing_selected,client_module_references=uses,backend_unavailable_sentinel_present=True,artifacts_sha256={p:sha(r/p) for p in ['data/4.20/ambient_audio_manifest.json','data/4.20/ambient_audio_selection.json','crates/client/src/map_audio_requests.rs']},next_integration=['Consume actual pending request through event/container selection with explicit per-emitter/global history and qualified randomness.','Connect selected source to decoded PCM with native inherited gain/pitch/routing/seek and real backend admission.','Return logical handle only after physical registration; handle positions, release and completion via existing native contracts.'],limits=['Hash/format/dependency audit only; no audible playback or original selection equivalence claim.','Client module-reference search is a source-level indicator; no dynamic callgraph proof.','Native RNG, continuous scheduling and full mixer/backend lifecycle must not be silently replaced by a random WAV choice.'])
(r/'docs/ambient_audio_backend_readiness.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps(dict(media=len(rows),events=len(events),integrity_passed=not errors,module_references=uses,errors=errors)))
assert not errors
