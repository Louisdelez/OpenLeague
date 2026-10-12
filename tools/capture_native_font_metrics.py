from pathlib import Path
import json,re,sys
r=Path('E:/OpenLeague');backend=sys.argv[1];assert backend in ['vulkan','dx12']
source=(r/'tools/capture_native_font_descriptor_loading.py').read_text(encoding='utf-8').replace('native-font-descriptor-loading-','native-font-metrics-')
exec(compile(source,'owned native font metrics capture','exec'))
tag='native-font-metrics-'+backend
log=(r/('logs/'+tag+'.client.log')).read_text(encoding='utf-8',errors='replace')
rows=re.findall(r'Native HUD FreeType version=2.4.8 dpi=(\d+)x(\d+) faces=(\d+) source_texts=(\d+) metric_adjustment=true glyph_gpu=false widgets=false',log)
assert rows and all(int(row[2])==19 and int(row[3])==154 for row in rows)
assert 'Native HUD font metrics unavailable:' not in log
path=r/('docs/'+tag+'-capture.json');proof=json.loads(path.read_text())
proof.update(native_matching_freetype_version='2.4.8',font_metric_runtime_observed=True,font_dpi=[int(rows[0][0]),int(rows[0][1])],persistent_face_count=19,source_text_count=154,glyph_gpu_rendering_qualified=False,hud_widgets_drawn=False)
path.write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'backend':backend,'dpi':proof['font_dpi'],'faces':19,'source_texts':154,'glyph_gpu':False}))
