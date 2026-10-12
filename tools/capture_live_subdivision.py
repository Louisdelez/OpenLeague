from pathlib import Path
s=Path('E:/mapslol3v3/capture_grass_live_registry.py').read_text(encoding='utf-8')
s=s.replace('16019','16023').replace('grass-live-215','grass-live-216').replace('docs/grass_live_registry_runtime.json','docs/grass_live_subdivision_runtime.json')
s=s.replace("m['error'] is None and any", "m['error'] is None and m['queued_subdivisions']==0 and any")
exec(compile(s,'capture-live-subdivision','exec'))
