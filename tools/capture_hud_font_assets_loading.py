from pathlib import Path
import sys,json,re
r=Path('E:/OpenLeague');backend=sys.argv[1];assert backend in ['vulkan','dx12']
source=(r/'tools/capture_hud_layout_loading.py').read_text(encoding='utf-8').replace('hud-layout-loading-','hud-font-assets-loading-')
exec(compile(source,'owned HUD font asset loading capture','exec'))
tag='hud-font-assets-loading-'+backend
log=(r/('logs/'+tag+'.client.log')).read_text(encoding='utf-8',errors='replace')
rows=re.findall(r'Native HUD font asset family=(.*?) path=(.*?) bytes=(\d+) glyphs_verified=false widgets=false',log)
assert len(rows)==1 and rows[0][0]=='Gill Sans MT Pro Medium'
assert rows[0][1]=='assets/fonts/native4.20/GillSansMTPro-Medium.otf' and int(rows[0][2])>0
assert 'Native HUD font source locale=en_GB' in log
p=r/('docs/'+tag+'-capture.json');proof=json.loads(p.read_text());proof.update(source_font_assets_startup_observed=True,active_font_family=rows[0][0],active_font_path=rows[0][1],active_font_bytes=int(rows[0][2]),glyph_gpu_rendering_qualified=False,hud_widgets_drawn=False)
p.write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(backend=backend,font_asset_observed=rows,widgets_drawn=False)))
