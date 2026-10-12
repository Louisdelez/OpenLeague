from pathlib import Path
import json,hashlib,datetime,difflib
out=Path(__file__).resolve().parent
proof=json.loads((out/'replay_packet95_probe.json').read_text())
assert len(proof['consumers'])==148 and len(proof['assignments'])==192
assert '3 passed; 0 failed' in (out/'tests.log').read_text()
sources={'native_sha256':proof['native_sha256'],'regions':proof['source_regions']}
(out/'packet95_sources.json').write_text(json.dumps(sources,indent=2)+'\n')
patch=''
for name in ['audio_replay_packet95.rs','audio_replay_packet95_tests.rs']:
    patch+=''.join(difflib.unified_diff([], (out/name).read_text().splitlines(True),fromfile='/dev/null',tofile='b/crates/core/src/'+name))
(out/'packet95.patch').write_text(patch)
names=['audio_replay_packet95.rs','audio_replay_packet95_tests.rs','replay_packet95_probe.json','probe_packet95.py','packet95_sources.json','packet95.patch','packet95_disassembly.txt','packet95_global_xrefs.txt','packet95_harness.rs','prepare_harness.py','compile.log','tests.log','README.md','record_packet95.py']
receipt={'created_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'scope':'scratch-only packet95 generic consumer and ownership transfer','complete':False,'native_sha256':proof['native_sha256'],'native_consumers':148,'native_assignments':192,'ordered_events':sum(len(c['trace']) for c in proof['consumers']+proof['assignments']),'tests':{'passed':3,'failed':0,'filtered':67,'duration_seconds':0.04},'source_regions':len(proof['source_regions']),'source_bytes':sum(s['size'] for s in proof['source_regions']),'production_modified':False,'terminal_game_handler_implemented':False,'files':[{'path':str(out/name),'bytes':(out/name).stat().st_size,'sha256':hashlib.sha256((out/name).read_bytes()).hexdigest()} for name in names],'limits':proof['limits']}
(out/'packet95_receipt.json').write_text(json.dumps(receipt,indent=2)+'\n')
print(json.dumps({k:receipt[k] for k in ['native_consumers','native_assignments','ordered_events','tests','source_regions','source_bytes']}))
