from pathlib import Path
import json,sys
r=Path('E:/OpenLeague');backend=sys.argv[1];assert backend in ['vulkan','dx12'];label='Vulkan' if backend=='vulkan' else 'Dx12'
tag='hud-layout-loading-'+backend;gpu=r/('logs/'+tag+'-atlas-gpu.json');readback=r/('logs/'+tag+'-atlas-readback.json')
assert not gpu.exists() and not readback.exists()
source=(r/'tools/capture_chaos_base_scene.py').read_text(encoding='utf-8')
source=source.replace('chaos-base-normal-scene',tag).replace('chaos_base_scene_capture.json',tag+'-capture.json').replace('16104','16204')
source=source.replace("WGPU_BACKEND='vulkan',RUST_LOG='warn'",f"WGPU_BACKEND='{backend}',RUST_LOG='warn,bevy_render::renderer=info'")
source=source.replace('env=dict(os.environ,','env=dict(os.environ,OPENLEAGUE_HUD_ATLAS_GPU_RECEIPT=str(gpu),OPENLEAGUE_HUD_SHADOW_ATLAS_READBACK=str(readback),')
exec(compile(source,'owned HUD layout loading capture','exec'))
g=json.loads(gpu.read_text());b=json.loads(readback.read_text());assert g['atlas_count']==5 and all(v['gpu_prepared'] for v in g['entries']);assert b['native_bytes_equal'] and b['bytes']==b['expected_bytes']==4194304
log=(r/('logs/'+tag+'.client.log')).read_text(encoding='utf-8',errors='replace')
adapter=[line for line in log.splitlines() if 'AdapterInfo' in line];assert len(adapter)==1 and 'backend: '+label in adapter[0]
assert 'Native HUD structural files=32 accepted=703 rejected=0 repaired=2 resource_binding=false drawing=false' in log
repairs=[line for line in log.splitlines() if 'Native HUD reconstructed overlay' in line];assert len(repairs)==2 and all('provenance=reconstructed_from_source_patterns' in line for line in repairs)
assert 'panicked at' not in log and 'ShaderValidationError' not in log
p=r/('docs/'+tag+'-capture.json');proof=json.loads(p.read_text());proof.update(graphics_backend=label,adapter_log=adapter[0],atlas_gpu_receipt=str(gpu),shadow_atlas_readback=str(readback),atlas_count=5,shadow_atlas_native_bytes_equal=True,structural_layout_files=32,accepted_elements=703,rejected_elements=0,repaired_files=2,repair_selection_log=repairs,hud_resource_handles_resolved=False,hud_group_binding_complete=False,hud_widgets_drawn=False)
p.write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(backend=label,files=32,accepted=703,repaired=2,atlas_gpu_bytes_equal=True,widgets_drawn=False)))
