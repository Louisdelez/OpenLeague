from pathlib import Path
import json,hashlib,shutil
r=Path('E:/OpenLeague');p=r/'docs/grass_live_registry_runtime.json';d=json.loads(p.read_text(encoding='utf-8'))
assert d['client_sha256']==hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest()
assert d['capture_sha256']==hashlib.sha256(Path(d['capture']).read_bytes()).hexdigest()
map_hash=hashlib.sha256((r/'assets/maps/twisted_treeline.glb').read_bytes()).hexdigest()
d.update(visual_inspected=True,visual_inspection_required=False,visual_observations=['Startup Vulkan framebuffer displays the textured Map10 blue base, shopkeeper, Garen model and health bars, plus the development HUD.','This image does not qualify collector masks, WALL brush rendering, complete map topology, full HUD fidelity or all champions.'],loaded_map_sha256=map_hash,external_vulkan_loader_warning_present='ERROR wgpu_hal::vulkan::instance' in (r/'logs/grass-live-215-client.log').read_text(encoding='utf-8'))
p.write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8')
for name in ['finish_grass_live_review.py','record_grass_live_registry_progress.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print(json.dumps(dict(visual_inspected=True,map_sha256=map_hash)))
