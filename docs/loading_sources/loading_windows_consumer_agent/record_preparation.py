from pathlib import Path
import json,hashlib,datetime
out=Path(__file__).resolve().parent
names=['audio_replay_windows_loading.rs','audio_replay_windows_loading_tests.rs','audio_replay_windows_receive.rs','integration.patch','prepare_integration.py','INTEGRATION.md','record_preparation.py']
def record(p):
    data=p.read_bytes();return dict(path=str(p),bytes=len(data),sha256=hashlib.sha256(data).hexdigest())
result=dict(prepared_at_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),scope='Windows loading consumer adapter and tests, scratch proposal only',compiled=False,tests_executed=False,tests_prepared=3,hot_packet_cases=48,truncated_packet_cases=96,production_modified=False,complete=False,files=[record(out/n) for n in names],root_required_api='Backend::loading_clock_f32_bits() -> Result<u32, &static str> and audio_loading_metadata::Boundary',generic_consumer_proof=record(Path('E:/mapslol3v3/loading_consumer_agent/qualification_manifest.json')))
(out/'preparation_manifest.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({k:result[k] for k in ['compiled','tests_executed','tests_prepared','production_modified']}))
