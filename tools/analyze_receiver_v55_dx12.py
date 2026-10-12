from pathlib import Path
import json,datetime,hashlib
r=Path('E:/OpenLeague');path=r/'logs/projected-core-cycle-v55-receivers-dx12-pixels.json'
d=json.loads(path.read_text(encoding='utf-8'));rows=sorted(d['rows'],key=lambda x:x['gpu_frame'])
assert d['same_frame_gpu_pair'] and d['rgba_atlas_header_row']
active=[x for x in rows if x['draws']>0]
assert active, 'No active projection GPU frame observed'
first=min(x['time'] for x in active)
baseline=[x for x in rows if x['draws']==0 and first-2<=x['time']<first]
groups={}
for row in active:groups.setdefault(row['entity'],[]).append(row)
passed=bool(baseline) and all(x['changed_pixels']==0 for x in baseline) and len(groups)==2 and all(any(x['changed_pixels']>0 for x in frames) for frames in groups.values())
cases=[]
for entity,frames in groups.items():
    peak=max(frames,key=lambda x:x['difference_energy'])
    cases.append(dict(entity=entity,frames=len(frames),peak_changed_pixels=peak['changed_pixels'],peak_max_rgb_difference=peak['max_rgb_difference'],peak_difference_bounds=peak['bounds'],saved_rgba=[x['rgba'] for x in frames if x['rgba']]))
files=['logs/projected-core-cycle-v55-receivers-dx12-pixels.json','docs/projected_core_cycle_capture_v55_receivers_dx12.json','crates/client/src/projected_pixel_pair.rs','logs/missile-replay-client-build.log','target/debug/openleague-client.exe']
receipt=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,same_frame_pixel_attribution_passed=passed,baseline_frames=len(baseline),baseline_nonzero_frames=sum(x['changed_pixels']>0 for x in baseline),projection_instances=cases,artifacts_sha256={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in files},limits=d['limits']+['Three camera views impose diagnostic overhead. This compares the reconstructed consumer with itself suppressed; it does not qualify original LoL framebuffer equivalence or the full game.'])
(r/'docs/projected_receiver_pixels_v55_dx12.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps(receipt,indent=2))
