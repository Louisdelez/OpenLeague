from pathlib import Path
source=Path('E:/mapslol3v3/capture_fow_vertex_normal.py').read_text()
source=source.replace('16019','16021').replace('fow-vertex-normal','actor-lifecycle-normal').replace('fow_vertex_normal_runtime_capture','actor_lifecycle_runtime_capture').replace('-150.png','-151.png').replace('-150.json','-151.json')
exec(compile(source,__file__,'exec'))
