from pathlib import Path
import sys,json
r=Path('E:/OpenLeague');backend=sys.argv[1];assert backend in ['vulkan','dx12']
source=(r/'tools/capture_hud_layout_loading.py').read_text(encoding='utf-8').replace('hud-layout-loading-','hud-groups-loading-')
exec(compile(source,'owned HUD group loading capture','exec'))
tag='hud-groups-loading-'+backend;log=(r/('logs/'+tag+'.client.log')).read_text(encoding='utf-8',errors='replace')
assert 'Native HUD groups=48 bound=697 unbound=6 cache_clock_producer=false drawing=false' in log
p=r/('docs/'+tag+'-capture.json');proof=json.loads(p.read_text());proof.update(scene_groups=48,bound_elements=697,unbound_elements=6,undeclared_group='HUDCenterAbilitys',group_cache_clock_producer=False,hud_group_binding_complete=False)
p.write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(groups=48,bound=697,unbound=6,widgets_drawn=False)))
