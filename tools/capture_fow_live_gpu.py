from pathlib import Path
p=Path('E:/mapslol3v3/capture_visibility_texture.py')
s=p.read_text(encoding='utf-8').replace('16005','16013').replace('visibility-texture-133','fow-live-gpu-147').replace('visibility-texture-server','fow-live-gpu-server').replace('visibility-texture-client','fow-live-gpu-client').replace('visibility_texture_runtime_capture.json','fow_live_gpu_runtime_capture.json')
s=s.replace("WGPU_BACKEND='vulkan',", "WGPU_BACKEND='vulkan',OPENLEAGUE_FOW_MASK_PROBE='1',OPENLEAGUE_FOW_GPU_PROBE=str(r/'logs/fow-live-gpu-stages.json'),OPENLEAGUE_FOW_GPU_READBACK=str(r/'logs/fow-live-gpu-readback.json'),")
s=s.replace("if d and d['uploads']>3", "\n   try:\n    stages=json.loads((r/'logs/fow-live-gpu-stages.json').read_text());readback=json.loads((r/'logs/fow-live-gpu-readback.json').read_text())\n   except (FileNotFoundError,json.JSONDecodeError):stages=None;readback=None\n   if stages and stages['frames']>3 and readback and readback['bytes']==1048576 and readback['alpha_ready'] and readback['rgb_equal'] and readback['distinct_red_values']>2 and readback['nonzero_texels']>0 and d and d['uploads']>3")
s=s.replace("'normal_server':True,", "'normal_server':True,'gpu_stages':stages,'gpu_readback':readback,")
exec(compile(s,str(p),'exec'))
