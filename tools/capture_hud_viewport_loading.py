from pathlib import Path
import sys,json,re
r=Path('E:/OpenLeague');backend=sys.argv[1];assert backend in ['vulkan','dx12']
source=(r/'tools/capture_hud_groups_loading.py').read_text(encoding='utf-8').replace(".replace('hud-layout-loading-','hud-groups-loading-')",".replace('hud-layout-loading-','hud-viewport-loading-')").replace("tag='hud-groups-loading-'","tag='hud-viewport-loading-'")
exec(compile(source,'owned HUD viewport loading capture','exec'))
tag='hud-viewport-loading-'+backend
log=(r/('logs/'+tag+'.client.log')).read_text(encoding='utf-8',errors='replace')
rows=re.findall(r'Native HUD viewport physical=(\d+)x(\d+) scalar=1 refreshed=(\d+) groups=48 dimension_supplier=bevy_window widgets=false',log)
assert rows and int(rows[0][2])==41 and all(int(x)>0 for x in rows[0][:2]),rows
assert 'Native HUD viewport refresh failed:' not in log
p=r/('docs/'+tag+'-capture.json');proof=json.loads(p.read_text());proof.update(viewport_bounds_runtime_observed=True,viewport_dimension_supplier='Bevy physical window',viewport_initial_scalar=1,viewport_events=[dict(width=int(w),height=int(h),refreshed=int(c)) for w,h,c in rows],full_original_resize_lifecycle_qualified=False,hud_widgets_drawn=False)
p.write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(backend=backend,viewport_events=rows,widgets_drawn=False)))
