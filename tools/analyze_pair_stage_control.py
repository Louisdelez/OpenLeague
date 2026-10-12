from pathlib import Path
import json,datetime,hashlib,sys
from PIL import Image,ImageChops
r=Path('E:/OpenLeague');version=sys.argv[1];prefix='projected-core-cycle-'+version.replace('_','-')
p=r/'logs'/(prefix+'-pixels.json');d=json.loads(p.read_text());rows=sorted(d['rows'],key=lambda x:x['gpu_frame'])
active=[x for x in rows if x['draws']];assert active
first=min(x['time'] for x in active);baseline=[x for x in rows if not x['draws'] and first-2<=x['time']<first]
assert baseline
groups={}
for row in active:groups.setdefault(row['entity'],[]).append(row)
files=[str(p.relative_to(r)),'crates/client/src/projected_pixel_pair.rs','target/debug/openleague-client.exe','logs/projected-pair-baseline-controls-build.log','docs/projected_core_cycle_capture_'+version+'.json']
for row in rows:
    if row['rgba']:
        f=Path(row['rgba']);raw=Image.frombytes('RGBA',(2560,801),f.read_bytes());on=raw.crop((0,0,1280,800));off=raw.crop((1280,0,2560,800))
        outputs=[f.with_suffix('.on.png'),f.with_suffix('.off.png'),f.with_suffix('.difference.png')]
        for image,out in zip([on,off,ImageChops.difference(on.convert('RGB'),off.convert('RGB'))],outputs):image.save(out)
        files.extend(str(x.relative_to(r)) for x in [f]+outputs)
passed=all(x['changed_pixels']==0 for x in baseline) and len(groups)==2 and all(any(x['changed_pixels'] for x in frames) for frames in groups.values())
out=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,version=version,
    diagnostic_no_gamma=d['diagnostic_no_gamma'],diagnostic_no_msaa=d['diagnostic_no_msaa'],strict_baseline_equal=all(x['changed_pixels']==0 for x in baseline),same_frame_attribution_gate_passed=passed,
    baseline=dict(frames=len(baseline),nonzero_frames=sum(x['changed_pixels']>0 for x in baseline),changed_pixels_min=min(x['changed_pixels'] for x in baseline),changed_pixels_max=max(x['changed_pixels'] for x in baseline),max_rgb_difference=max(x['max_rgb_difference'] for x in baseline)),
    instances=[dict(entity=e,frames=len(frames),changed_pixels_max=max(x['changed_pixels'] for x in frames)) for e,frames in groups.items()],
    artifacts_sha256={f:hashlib.sha256((r/f).read_bytes()).hexdigest() for f in files},limits=d['limits']+['Gamma/MSAA controls isolate stages only; passing an altered diagnostic view does not qualify unmodified ordinary output or original LoL fidelity.'])
(r/'docs'/('projected_pair_control_'+version+'.json')).write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
