from pathlib import Path
p=Path('E:/OpenLeague/crates/client/examples/grass_mask_gpu_probe.rs');s=p.read_text(encoding='utf-8');assert 'brush,&TexelCopyBufferLayout' in s;p.write_text(s.replace('brush,&TexelCopyBufferLayout','brush,TexelCopyBufferLayout'),encoding='utf-8')
# Keep the one-shot source installer accurate too.
p=Path('E:/mapslol3v3/prepare_grass_mask_gpu.py');s=p.read_text(encoding='utf-8');p.write_text(s.replace('brush,&TexelCopyBufferLayout','brush,TexelCopyBufferLayout'),encoding='utf-8')
print('Updated texture upload to the installed wgpu29 argument signature.')
