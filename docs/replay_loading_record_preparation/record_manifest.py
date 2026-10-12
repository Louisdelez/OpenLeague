from pathlib import Path
import json,hashlib,datetime
out=Path(__file__).resolve().parent
proof=json.loads((out/'replay_loading_existing_record_probe.json').read_text())
summary=json.loads((out/'native_result.json').read_text())
assert summary['passed'] and summary['cases']==1600 and len(proof['cases'])==1600
assert all(c['non_target_bytes_unchanged'] and c['payload_unchanged'] for c in proof['cases'])
sources={'native_sha256':proof['native_sha256'],'regions':proof['source_regions']}
(out/'loading_record_sources.json').write_text(json.dumps(sources,indent=2)+'\n')
prior=[]
for receipt_path in ['E:/mapslol3v3/replay_packet95_agent/packet95_receipt.json','E:/mapslol3v3/replay_packet95_recipient_audit/recipient_audit_manifest.json']:
    path=Path(receipt_path);receipt=json.loads(path.read_text())
    for entry in receipt['files']:
        f=Path(entry['path']);assert hashlib.sha256(f.read_bytes()).hexdigest()==entry['sha256'],f
    prior.append({'path':str(path),'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'manifest_members_unchanged':True})
files=[p for p in out.iterdir() if p.is_file() and p.name!='loading_record_manifest.json']
manifest={'created_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'scope':'Native-only next-lot preparation: existing loading-screen records, nonempty SSO','passed':True,'complete':False,'integrated':False,'application_code_added':False,'rust_compilation_performed':False,'production_modified':False,'network_executable_started':False,'native_sha256':proof['native_sha256'],'results':summary,'trace_events':sum(len(c['trace']) for c in proof['cases']),'source_regions':len(proof['source_regions']),'source_bytes':sum(r['size'] for r in proof['source_regions']),'frozen_prior_artifacts':prior,'files':[{'path':str(p),'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in sorted(files)],'limits':proof['limits']}
(out/'loading_record_manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
for f in [out/'replay_loading_existing_record_probe.json',out/'loading_record_manifest.json']:
    print(json.dumps({'path':str(f),'bytes':f.stat().st_size,'sha256':hashlib.sha256(f.read_bytes()).hexdigest()}))
print(json.dumps({'trace_events':manifest['trace_events'],'source_bytes':manifest['source_bytes'],'prior_manifests_intact':True}))
