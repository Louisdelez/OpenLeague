from pathlib import Path
import shutil,json,datetime
r=Path('E:/OpenLeague');shutil.copy2(Path(__file__).with_name('projected_warmup.rs'),r/'crates/client/src/projected_warmup.rs')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');assert 'mod projected_warmup;' not in s
s=s.replace('mod projected_pipeline_probe;','mod projected_pipeline_probe;\nmod projected_warmup;').replace('.add_plugins(projected_pipeline_probe::Plugin)','.add_plugins(projected_pipeline_probe::Plugin)\n        .add_plugins(projected_warmup::Plugin)');p.write_text(s,encoding='utf-8')
s=(r/'tools/capture_projected_core_cycle_v6.py').read_text(encoding='utf-8').replace('10493','10494').replace('cycle-v6','cycle-v7').replace('capture_v6','capture_v7');(r/'tools/capture_projected_core_cycle_v7.py').write_text(s,encoding='utf-8')
d=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,status='source_changed_build_pending',build_log='logs/projected-warmup-build.log',capture_script='tools/capture_projected_core_cycle_v7.py',limits=['Pre-specialization implemented with production vertex layout/material/camera keys; build and actual first-cast pipeline reuse still require verification.', 'No layout template spawned or drawn; terrain geometry and particle lifetime preserved.'])
(r/'docs/projected_warmup_pending.json').write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8');print('Production projected pipeline startup preparation installed')
