from pathlib import Path
import json,shutil
r=Path('E:/OpenLeague');gpu=r/'logs/native-hud-atlas-gpu-dx12.json';readback=r/'logs/native-hud-shadow-atlas-readback-dx12.json'
assert not gpu.exists() and not readback.exists()
source=(r/'tools/capture_chaos_base_scene.py').read_text(encoding='utf-8')
source=source.replace('chaos-base-normal-scene','chaos-base-hud-atlases-dx12-scene').replace('chaos_base_scene_capture.json','native_hud_atlases_dx12_capture.json')
source=source.replace("WGPU_BACKEND='vulkan',RUST_LOG='warn'","WGPU_BACKEND='dx12',RUST_LOG='warn,bevy_render::renderer=info'")
source=source.replace('env=dict(os.environ,','env=dict(os.environ,OPENLEAGUE_HUD_ATLAS_GPU_RECEIPT=str(gpu),OPENLEAGUE_HUD_SHADOW_ATLAS_READBACK=str(readback),')
exec(compile(source,'owned DirectX12 HUD atlas capture','exec'))
g=json.loads(gpu.read_text());b=json.loads(readback.read_text());assert g['atlas_count']==5 and all(v['gpu_prepared'] for v in g['entries']);assert b['native_bytes_equal'] and b['bytes']==b['expected_bytes']==4194304
log=(r/'logs/chaos-base-hud-atlases-dx12-scene.client.log').read_text(encoding='utf-8',errors='replace');adapter=[line for line in log.splitlines() if 'AdapterInfo' in line];assert len(adapter)==1 and 'backend: Dx12' in adapter[0],adapter
assert 'panicked at' not in log and 'ShaderValidationError' not in log
p=r/'docs/native_hud_atlases_dx12_capture.json';proof=json.loads(p.read_text());proof.update(graphics_backend='Dx12',adapter_log=adapter[0],atlas_gpu_receipt=str(gpu),shadow_atlas_readback=str(readback),atlas_count=5,shadow_atlas_native_bytes_equal=True,hud_layout_applied=False)
p.write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(backend='Dx12',atlas_count=5,shadow_gpu_bytes_equal=True)))
