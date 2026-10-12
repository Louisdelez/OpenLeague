from pathlib import Path
import json, datetime, hashlib
r=Path('E:/OpenLeague');proof=r/'logs/projected-core-cycle-v6-pipeline.json'
d=json.loads(proof.read_text(encoding='utf-8'))
assert d['render_world_measurement'] and d['before_camera_driver']
groups={}
for frame in d['frames']:
    for draw in frame['draws']:
        groups.setdefault(draw['entity'],[]).append(dict(time=frame['time'],**draw))
assert len(groups)==2, groups.keys()
summary=[]
for entity, frames in groups.items():
    ready=[f for f in frames if 'ready' in f['pipeline_states']]
    assert ready, (entity,frames)
    assert all(f['fow_ready']==1 for f in frames), (entity,frames)
    summary.append(dict(entity=entity,frames=len(frames),first_seen=frames[0]['time'],first_ready=ready[0]['time'],
        warmup_seconds=ready[0]['time']-frames[0]['time'],
        initial_pipeline_states=frames[0]['pipeline_states'],all_fow_ready=True,
        nonready_frames=sum('ready' not in f['pipeline_states'] for f in frames)))
out=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,projection_instances=summary,
    client_sha256=hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest(),
    artifacts_sha256={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in ['logs/projected-core-cycle-v6-pipeline.json','docs/projected_core_cycle_capture_v6.json','crates/client/src/projected_pipeline_probe.rs','crates/client/src/main.rs','logs/projected-preload-build.log']},
    limits=d['limits']+['Time reflects extracted main-world frames; the pipeline is checked before actual camera rendering. Native framebuffer and exact fragment attribution remain unqualified.'])
(r/'docs/projected_pipeline_preload_measurement_progress.json').write_text(json.dumps(out,indent=2)+'\n',encoding='utf-8')
print(json.dumps(out,indent=2))

