from pathlib import Path
import sys,json,re
r=Path('E:/OpenLeague');backend=sys.argv[1];assert backend in ['vulkan','dx12']
source=(r/'tools/capture_hud_font_assets_loading.py').read_text(encoding='utf-8').replace('hud-font-assets-loading-','native-font-descriptor-loading-')
exec(compile(source,'owned native font descriptor loading capture','exec'))
tag='native-font-descriptor-loading-'+backend;log=(r/('logs/'+tag+'.client.log')).read_text(encoding='utf-8',errors='replace')
sizes=re.findall(r'Native HUD font sizing height=(\d+) texts=154 factor_bits=3aaaaaab rounding=ceil precision=concordant widgets=false',log)
bindings=re.findall(r'Native HUD font descriptor bindings texts=154 unique=(\d+) device_lifecycle=false widgets=false',log)
assert sizes and bindings and int(bindings[0])==19
assert 'font descriptors unavailable:' not in log and 'font sizing unavailable:' not in log
p=r/('docs/'+tag+'-capture.json');proof=json.loads(p.read_text());proof.update(font_size_runtime_observed=True,font_size_height=int(sizes[0]),font_size_rounding='ceil',source_text_bindings_runtime_observed=154,unique_font_descriptors=int(bindings[0]),native_font_device_lifecycle_ported=False,glyph_gpu_rendering_qualified=False,hud_widgets_drawn=False)
p.write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(backend=backend,height=sizes[0],texts=154,descriptors=bindings[0],widgets_drawn=False)))
