from pathlib import Path
import json,shutil
r=Path('E:/OpenLeague')
source=(r/'tools/capture_native_zip_fallback_profiles.py').read_text(encoding='utf-8')
source=source.replace('chaos-base-zip-fallback-','chaos-base-hud-atlases-').replace('chaos_base_zip_fallback_','native_hud_atlases_').replace('native_zip_fallback_profiles_capture.json','native_hud_atlases_profiles_capture.json')
source=source.replace("  prefix=", "  gpu_path=r/('logs/native-hud-atlas-gpu.json' if profile=='default' else 'logs/native-hud-atlas-gpu-missing-eocd.json');readback_path=r/('logs/native-hud-shadow-atlas-readback.json' if profile=='default' else 'logs/native-hud-shadow-atlas-readback-missing-eocd.json');assert not gpu_path.exists() and not readback_path.exists()\n  prefix=")
source=source.replace(';ns={};exec',";code=code.replace('env=dict(os.environ,','env=dict(os.environ,OPENLEAGUE_HUD_ATLAS_GPU_RECEIPT=str(gpu_path),OPENLEAGUE_HUD_SHADOW_ATLAS_READBACK=str(readback_path),');ns={'gpu_path':gpu_path,'readback_path':readback_path};exec")
source=source.replace('  log=',"  gpu=json.loads(gpu_path.read_text());readback=json.loads(readback_path.read_text());assert gpu['atlas_count']==5 and all(e['gpu_prepared'] for e in gpu['entries']);assert readback['native_bytes_equal'] and readback['bytes']==readback['expected_bytes']==4194304\n  log=")
source=source.replace("  proof['limits'].append", "  proof.update(atlas_gpu_receipt=str(gpu_path),shadow_atlas_readback=str(readback_path),atlas_count=5,shadow_atlas_native_bytes_equal=True,hud_layout_applied=False)\n  proof['limits'].append")
exec(compile(source,'owned HUD atlas original/fallback captures','exec'))
summary=json.loads((r/'docs/native_hud_atlases_profiles_capture.json').read_text())
(r/'docs/native_hud_atlases_capture.json').write_text(json.dumps(summary['captures'][0],indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(profiles=2,atlas_count_per_profile=5,shadow_gpu_bytes_equal=True,archive_restored=True)))
