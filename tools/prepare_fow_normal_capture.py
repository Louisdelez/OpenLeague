from pathlib import Path
r=Path('E:/OpenLeague')
s=(r/'tools/capture_projected_live_v4.py').read_text().replace('5986','16015').replace('projected-live-v4','fow-projected-normal-148').replace('projected_normal_capture_v4.json','fow_projected_normal_capture.json')
s=s.replace("WGPU_BACKEND='vulkan',", "WGPU_BACKEND='vulkan',OPENLEAGUE_FOW_GPU_PROBE=str(r/'logs/fow-projected-normal-stages.json'),OPENLEAGUE_FOW_GPU_READBACK=str(r/'logs/fow-projected-normal-readback.json'),")
s=s.replace("'measurements':states,", "'measurements':states,'gpu_readback':json.loads((r/'logs/fow-projected-normal-readback.json').read_text()),'gpu_stages':json.loads((r/'logs/fow-projected-normal-stages.json').read_text()),")
s=s.replace('Exact native owner orientation, scale setters, receiver selection, FOW, blend/depth/sampler and full Q fidelity remain unqualified.', 'Projected RGB now uses final live visibility and recovered overlay alpha. Exact native owner orientation, scale setters, receiver selection and full Q fidelity remain unqualified; live pixel values not numerically read back.')
Path('E:/mapslol3v3/capture_fow_projected_normal.py').write_text(s)
